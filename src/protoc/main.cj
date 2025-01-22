/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights reserved.
 */
package protoc

main() {
    let input = stdin()
    let output = cj_generator(input)

    stdout(output)
}