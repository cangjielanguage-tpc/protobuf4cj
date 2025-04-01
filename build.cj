import std.env.*
import std.fs.*

func stagePreInstall(): Int64 {
    0
}

func stagePostInstall(): Int64 {
    0
}

func stagePostBuild(): Int64 {
    // protoc-gen-cj无法直接作为编译输出名称 手动拷贝
    copy("target/release/bin/protoc", to: "target/release/bin/protoc-gen-cj", overwrite: true)
    0
}

main(): Int64 {
    match (getCommandLine()[1]) {
        // Add operation here with format: "pre-"/"post-" + optionName
        case "pre-install" => stagePreInstall()
        case "post-install" => stagePreInstall()
        // case "pre-build" => stagePreBuild()
        case "post-build" => stagePostBuild()
        // case "pre-clean" => stagePreClean()
        // case "post-clean" => stagePostClean()
        case _ => 0
    }
}
