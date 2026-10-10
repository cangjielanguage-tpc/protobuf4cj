import std.env.*
import std.process.*
import std.fs.*

// Windows文件系统大小写不敏感需小写归一化, POSIX大小写敏感保留原样
@When[os == "Windows"]
func normPath(p: String): String {
    p.replace("\\", "/").toAsciiLower()
}

@When[os != "Windows"]
func normPath(p: String): String {
    p.replace("\\", "/")
}

// 本包作为依赖被构建时, 脚本exe位于消费方目录而非本包内;
// 仅当exe位于cwd下且首段路径为build-script-cache(即本包是本次构建的根)时才编排
func isRootBuild(): Bool {
    let exe = normPath(getCommandLine()[0])
    let cwd = normPath(getWorkingDirectory().toString())
    if (cwd.endsWith("/")) {
        return false
    }
    return exe.startsWith("${cwd}/build-script-cache/")
}

// post-build: 仅负责触发protoc_gen_cj的独立构建(依赖../protobuf/src与../google/src的static第二级,
// 不在workspace依赖树内, 避免与dynamic成员同名冲突);
// 产物重命名与拷贝由protoc_gen_cj自己的build.cj负责, 本脚本不感知产物
func triggerStaticPluginBuild(): Int64 {
    let pluginDir = Path("src/protoc_gen_cj")
    let code = execute("cjpm", ["build"], workingDirectory: pluginDir)
    if (code != 0) {
        eprintln("Error: static build of protoc-gen-cj failed, exit code ${code}")
    }
    code
}

main(): Int64 {
    let args = getCommandLine()
    if (args.size < 2 || args[1] != "post-build" || !isRootBuild()) {
        return 0
    }
    triggerStaticPluginBuild()
}
