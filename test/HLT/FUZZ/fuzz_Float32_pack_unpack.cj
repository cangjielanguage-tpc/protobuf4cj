// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: protobuf_float.pb.cj 

package base
import secodeFuzz.*
from std import unittest.*
from std import unittest.testmacro.*
from std import collection.ArrayList
from protobuf import protobuf.*
from protobuf import grpc.*

func call_fuzz(input:Float32){
    try{
        var floatData = FloatData.empty()
		var floatData01 = floatData.floatData01
		var floatData02 = floatData.floatData02

		floatData.floatData01 = input
		var list = RepeatedField<Float32>([input, input, input])
		floatData.floatData02.copyFrom(list)

		var floatPack = SimpleWriter(floatData.size)
		floatPack.clear()
		floatData.pack(floatPack)

		var packData = floatPack.data
		var unpackData = FloatData.empty()

		unpackData.unpack(packData)
    }catch(e:Exception){}
    return
}

func unboundTest():Unit{
    var case_name = CString("Fuzz_Float32_pack_unpack")
    unsafe{
        // 根据 call_fuzz的入参类型，选择fuzz方法，例如DF_FUZZ_Int64。其他方法见secodeFuzz.cj。其中100000为定义测试次数。其他参数可不变
        DT_FUZZ_Float32(0,30000000,case_name,0,call_fuzz)
        case_name.free()
    }
}

main(){
    unboundTest()
    return
}