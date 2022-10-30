#include <stdio.h>
#include <string.h>
#include <malloc.h>

typedef struct rbuf {
    unsigned char* data;
    long long size;
} rbuf;

void stdin_read(rbuf* buf) {
    if (buf == NULL) {
        return;
    }

    long long size = 32 * 1024;
    unsigned char* res = (unsigned char*)malloc(size);
    if (res == NULL) {
        return;
    }

    freopen(NULL, "rb", stdin);
    buf->size = 0;
    while (1) {
        buf->size += fread(res + buf->size, 1, size - buf->size, stdin);
        if (buf->size < size) {
            break;
        }
        unsigned char* tmp = (unsigned char*)malloc(size * 2);
        if (tmp == NULL) {
            break;
        }
        memcpy(tmp, res, size);
        free(res);
        res = tmp;
        size *= 2;
    }

    if (buf->data != NULL) {
        free(buf->data);
    }
    buf->data = res;
}

void stdout_write(rbuf* buf) {
    if (buf == NULL || buf->data == NULL) {
        return;
    }
    freopen(NULL, "wb", stdout);
    fwrite(buf->data, 1, buf->size, stdout);
    fflush(stdout);
}

rbuf* rbuf_new() {
    rbuf* ret = malloc(sizeof(rbuf));
    if (ret != NULL) {
        ret->data = NULL;
        ret->size = 0;
    }
    return ret;
}

rbuf* rbuf_malloc(long long size) {
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

void rbuf_free(rbuf* buf) {
    if (buf != NULL && buf->data != NULL) {
        free(buf->data);
    }
    if (buf != NULL) {
        free(buf);
    }
}