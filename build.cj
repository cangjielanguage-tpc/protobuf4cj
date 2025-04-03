import std.os.process.*
import std.fs.*

@When[os == "Windows"]
let ext = ".exe"
@When[os != "Windows"]
let ext = ""

func stagePostBuild(): Int64 {
    // protoc-gen-cj无法直接作为编译输出名称 手动拷贝
    File.copy("target/release/bin/protoc${ext}", "target/release/bin/protoc-gen-cj${ext}", true)
    0
}

main(): Int64 {
    println("Process.current.commandLine ${Process.current.commandLine}")
    match (Process.current.commandLine[1]) {
        // Add operation here with format: "pre-"/"post-" + optionName
        // case "pre-install" => stagePreInstall()
        // case "post-install" => stagePreInstall()
        // case "pre-build" => stagePreBuild()
        case "post-build" => stagePostBuild()
        // case "pre-clean" => stagePreClean()
        // case "post-clean" => stagePostClean()
        case _ => 0
    }
}
