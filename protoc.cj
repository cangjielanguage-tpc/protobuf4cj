package protoc

import egg.*
import protobuf.*
import collection.*

public func cj_generator(inbuf: Bytes, outbuf: Bytes) {
    let req = CodeGeneratorRequest()
    req.unpack(inbuf)

    let resp = CodeGeneratorResponse()
    reqProcess(req, resp)
    resp.pack(outbuf)
}

public func reqProcess(req: CodeGeneratorRequest, resp: CodeGeneratorResponse) {
    let file = resp.file.add()
    // todo 根据req生成pb.cj代码
    file.name = "req.json"
    file.content = req.toString()
}

class GenCodeHelper {
    // todo
}

/**
 * 根据依赖计算对应的仓颉包名
 * exp: google/protobuf/any.proto => google.protobuf.*
 */
func getDependencyPackageName(dep: String) {
    ""
}

/**
 * 根据包名和文件名计算生成代码的路径
 * exp: google.protobuf any.proto => google/protobuf/any_pb.cj
 */
func getGenCodePath(pkg: String, name: String) {
    ""
}

func genCodeMessage(msg: DescriptorProto, helper: GenCodeHelper, outbuf: StringBuilder) {

}

func genCodeEnum(e: EnumDescriptorProto, helper: GenCodeHelper, outbuf: StringBuilder) {

}

func genCodeService(ser: ServiceDescriptorProto, helper: GenCodeHelper, outbuf: StringBuilder) {

}

func genCodeExtension(ext: FieldDescriptorProto, helper: GenCodeHelper, outbuf: StringBuilder) {
    
}