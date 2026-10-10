import std.env.*
import std.fs.*

@When[os == "Windows"]
let ext = ".exe"
@When[os != "Windows"]
let ext = ""

/*
 * 为什么重命名:
 * protoc按"protoc-gen-<name>"约定查找插件(由protoc --<name>_out触发)
 * 而cangjie模块名不允许连字符 故模块及编译产物需改名为protoc-gen-cj
 *
 * 职责: 构建出protoc-gen-cj的最终产物并拷贝到根项目target(../../target/release/bin)
 * cjpm install(安装到~/.cjpm/bin)依赖本target内改名后的protoc-gen-cj
 */
func stagePostBuild(): Int64 {
    let binDir = "target/release/bin"
    // cjpm可执行产物名随版本可能为main或包名protoc_gen_cj, 多候选兜底
    var src = ""
    for (name in ["main${ext}", "protoc_gen_cj${ext}"]) {
        if (exists("${binDir}/${name}")) {
            src = "${binDir}/${name}"
            break
        }
    }
    if (src == "") {
        eprintln("Error: plugin binary not found in ${binDir}(expected main|protoc_gen_cj)")
        return 1
    }
    try {
        copy(src, to: "${binDir}/protoc-gen-cj${ext}", overwrite: true)
        let rootBinDir = "../../target/release/bin"
        if (!exists(rootBinDir)) {
            Directory.create(rootBinDir, recursive: true)
        }
        copy(src, to: "${rootBinDir}/protoc-gen-cj${ext}", overwrite: true)
    } catch (e: Exception) {
        eprintln("Error: failed to stage protoc-gen-cj${ext}: ${e.message}")
        return 1
    }
    0
}

main(): Int64 {
    let args = getCommandLine()
    if (args.size < 2) {
        return 0
    }
    match (args[1]) {
        case "post-build" => stagePostBuild()
        case _ => 0
    }
}
