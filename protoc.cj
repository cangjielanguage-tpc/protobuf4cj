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
