package protoc

import protobuf.*
import collection.*

public func cj_gen(req: CodeGeneratorRequest, resp: CodeGeneratorResponse) {
    let file = resp.file.add()
    // todo 根据req生成pb.cj代码
    file.name = "req.json"
    file.content = req.toString()
}
