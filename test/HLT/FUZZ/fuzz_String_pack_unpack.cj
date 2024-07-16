// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: protobuf_string.pb.cj 

package base
import secodeFuzz.*
from std import unittest.*
from std import unittest.testmacro.*
from std import collection.ArrayList
from protobuf import protobuf.*
from protobuf import grpc.*

func call_fuzz(data:String){
    try{
        var stringData = StringData.empty()
        var stringData01 = stringData.stringData01
        var stringData02 = stringData.stringData02

        stringData.stringData01 = data
        stringData.stringData02.append(data)

        var stringPack = SimpleWriter(stringData.size)
        stringPack.clear()
        stringData.pack(stringPack)

        var packData = stringPack.data
        var unpackData = StringData.empty()

        unpackData.unpack(packData)
    }catch(e:Exception){}
    return
}

func unboundTest():Unit{
    var case_name = CString("Fuzz_String_pack_unpack")
    unsafe{
        // 根据 call_fuzz的入参类型，选择fuzz方法，例如DF_FUZZ_Int64。其他方法见secodeFuzz.cj。其中100000为定义测试次数。其他参数可不变
        DT_FUZZ_String(0,30000000,case_name,0,call_fuzz)
        case_name.free()
    }
}

main(){
    unboundTest()
    return
}