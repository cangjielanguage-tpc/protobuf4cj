参数赋值:
```
name: "test"
id: 1
email: "test@huawei.com"
phone {
  number: "12345678901"
  type: WORK
  comment {
    comment1: "colleague"
  }
}
phone {
  number: "12345678902"
  type: HOME
  comment {
    comment1: "family"
  }
}

```

```
// 序列化后的数据内容：
hexdump -C pb_cj2java.bin

00000000  0a 04 74 65 73 74 10 01  1a 0f 74 65 73 74 40 68  |..test....test@h|
00000010  75 61 77 65 69 2e 63 6f  6d 22 1c 0a 0b 31 32 33  |uawei.com"...123|
00000020  34 35 36 37 38 39 30 31  10 02 1a 0b 0a 09 63 6f  |45678901......co|
00000030  6c 6c 65 61 67 75 65 22  19 0a 0b 31 32 33 34 35  |lleague"...12345|
00000040  36 37 38 39 30 32 10 01  1a 08 0a 06 66 61 6d 69  |678902......fami|
00000050  6c 79                                             |ly|
00000052

```
