/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights resvered.
 */
package protoc

main() {
    let input = stdin()
    let output = cj_generator(input)

    stdout(output)
}