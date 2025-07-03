/*
 * Copyright (c) Huawei Technologies co., Ltd. 2022-2023. All Rights Resverd.
 * Description: protobuf typecast.ffi.c for Cangjie API
 */

unsigned ftoi(float in)
{
    return *(unsigned*)&in;
}

float itof(unsigned in)
{
    return *(float*)&in;
}

unsigned long dtol(double in)
{
    return *(unsigned long*)&in;
}

double ltod(unsigned long in)
{
    return *(double*)&in;
}