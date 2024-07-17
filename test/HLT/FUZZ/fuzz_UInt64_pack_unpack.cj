// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: protobuf_int.pb.cj 

package base
import secodeFuzz.*
from std import unittest.*
from std import unittest.testmacro.*
from std import collection.ArrayList
from protobuf import protobuf.*
from protobuf import grpc.*

func call_fuzz(input:UInt64){
    try{
        var intData = IntData.empty()
		var uIntData03 = intData.uIntData03
		var uIntData04 = intData.uIntData04

		intData.uIntData03 = input
		var list = RepeatedField<UInt64>([input, input, input])
		intData.uIntData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
    }catch(e:Exception){}
    return
}

func unboundTest():Unit{
    var case_name = CString("Fuzz_UInt64_pack_unpack")
    unsafe{
        // 根据 call_fuzz的入参类型，选择fuzz方法，例如DF_FUZZ_Int64。其他方法见secodeFuzz.cj。其中100000为定义测试次数。其他参数可不变
        DT_FUZZ_UInt64(0,30000000,case_name,0,call_fuzz)
        case_name.free()
    }
}

main(){
    unboundTest()
    return
}