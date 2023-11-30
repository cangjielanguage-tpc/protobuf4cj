/*
 * Copyright (c) Huawei Technologies co., Ltd. 2022-2023. All Rights Resverd.
 * Description: protobuf stdio.ffi.c for Cangjie API
 */

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <assert.h>

#ifdef WIN32
#include <fcntl.h>
#include <io.h>
#endif

typedef struct {
    unsigned char* data;
    size_t size;
} Buffer;

#define INITIAL_RBUF_SIZE   (32 * 1024)
#define CAPACITY_INCR_RATE  (2)

Buffer stdin_read()
{
    size_t size = INITIAL_RBUF_SIZE;
    size_t resSize = 0;
    unsigned char* res = (unsigned char*)malloc(size);
    assert(res != NULL);

#ifdef WIN32
    assert(_setmode(_fileno(stdin), _O_BINARY) != -1);
#else
    assert(freopen(NULL, "rb", stdin) == stdin);
#endif
    while (1) {
        resSize += fread(res + resSize, 1, size - resSize, stdin);
        if (resSize < size) {
            break;
        }

        size_t new_size = size * CAPACITY_INCR_RATE;
        unsigned char* new_res = (unsigned char*)malloc(new_size);
        assert(new_res != NULL);

        (void)memset_s(new_res, new_size, 0, new_size);
        (void)memcpy_s(new_res, new_size, res, size);
        free(res);

        res = new_res;
        size = new_size;
    }

    Buffer buffer = { res, resSize };
    return buffer;
}

void stdout_write(unsigned char* data, size_t size)
{
    assert(data);

#ifdef WIN32
    assert(_setmode(_fileno(stdout), _O_BINARY) != -1);
#else
    assert(freopen(NULL, "wb", stdout) == stdout);
#endif

    assert(fwrite(data, 1, size, stdout) == size);

    assert(fflush(stdout) == 0);
}
