/*
 * Copyright (c) Huawei Technologies co., Ltd. 2022-2023. All Rights Resverd.
 * Description: protobuf stdio.ffi.c for Cangjie API
 */

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <assert.h>

typedef struct rbuf {
    unsigned char* data;
    long long size;
} rbuf;

#define INITIAL_RBUF_SIZE   (32 * 1024)
#define CAPACITY_INCR_RATE  (2)

void stdin_read(rbuf* buf)
{
    assert(buf != NULL);

    buf->size = 0;
    if (buf->data != NULL) {
        free(buf->data);
        buf->data = NULL;
    }

    long long size = INITIAL_RBUF_SIZE;
    unsigned char* res = (unsigned char*)malloc(size);
    assert(res != NULL);

    assert(freopen(NULL, "rb", stdin) == stdin);
    while (1) {
        buf->size += fread(res + buf->size, 1, size - buf->size, stdin);
        if (buf->size < size) {
            break;
        }

        long long new_size = size * CAPACITY_INCR_RATE;
        unsigned char* new_res = (unsigned char*)malloc(new_size);
        assert(new_res != NULL);

        (void)memset_s(new_res, new_res, 0, new_size);
        (void)memcpy_s(new_res, new_size, res, size);
        free(res);

        res = new_res;
        size = new_size;
    }

    buf->data = res;
}

void stdout_write(rbuf* buf)
{
    assert(buf != NULL && buf->data != NULL);

    assert(freopen(NULL, "wb", stdout) == stdout);

    assert(fwrite(buf->data, 1, buf->size, stdout) == buf->size);

    assert(fflush(stdout) == 0);
}

rbuf* rbuf_new()
{
    rbuf* ret = malloc(sizeof(rbuf));
    if (ret != NULL) {
        ret->data = NULL;
        ret->size = 0;
    }

    return ret;
}

rbuf* rbuf_malloc(long long size)
{
    assert(size > 0);

    rbuf* ret = malloc(sizeof(rbuf));
    if (ret != NULL) {
        ret->data = (unsigned char*)malloc(size);
        if (ret->data != NULL) {
            ret->size = size;
            return ret;
        }

        free(ret);
    }

    return NULL;
}

void rbuf_free(rbuf* buf)
{
    if (buf != NULL && buf->data != NULL) {
        free(buf->data);
    }

    if (buf != NULL) {
        free(buf);
    }
}