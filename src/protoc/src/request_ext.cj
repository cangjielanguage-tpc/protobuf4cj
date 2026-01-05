/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package protoc

extend CodeGeneratorRequest {
    prop pkg_default: String {
        get() {
            "default" // cangjie默认包名
        }
    }
    /**
     * 前置数据处理
     */
    func preBuild(): Unit {
        defaultPkg()
    }
    /**
     * 处理空package
     */
    func defaultPkg(): Unit {
        // proto with empty pkg
        for (file in protoFile) {
            if (!file.hasPackage) {
                file.package_ = pkg_default
            }
            walkField(file.messageType)
        }
    }
    func walkField(msgs: RepeatedMessage<DescriptorProto>): Unit {
        for (msg in msgs) {
            for (field in msg.field) {
                if (field.hasTypeName && field.typeName[0] == b'.') {
                    let pkg = field.typeName.split(".")[1]
                    let pkg_matched: Int = this.protoFile |> filter {f => f.hasPackage && f.package_ == pkg} |> count
                    if (pkg_matched == 0) {
                        field.typeName = ".${pkg_default}${field.typeName}"
                    }
                }
            }
            walkField(msg.nestedType)
        }
    }
}
