package protoc

main() {
    let input = stdin()
    let output = cj_generator(input)

    stdout(output)
}