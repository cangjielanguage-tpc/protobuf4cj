// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: protobuf_double.pb.cj 

package base
import secodeFuzz.*
from std import unittest.*
from std import unittest.testmacro.*
from std import collection.ArrayList
from protobuf import protobuf.*
from protobuf import grpc.*

func call_fuzz(input:Float64){
    try{
        var douleData = DoubleData.empty()
		var douleData01 = douleData.doubleData01
		var douleData02 = douleData.doubleData02

		douleData.doubleData01 = input
		var list = RepeatedField<Float64>([input, input, input])
		douleData.doubleData02.copyFrom(list)

		var doublePack = SimpleWriter(douleData.size)
		doublePack.clear()
		douleData.pack(doublePack)
        
		var packData = doublePack.data
		var unpackData = DoubleData.empty()
		unpackData.unpack(packData)
    }catch(e:Exception){}
    return
}

func unboundTest():Unit{
    var case_name = CString("Fuzz_Float64_pack_unpack")
    unsafe{
        // 根据 call_fuzz的入参类型，选择fuzz方法，例如DF_FUZZ_Int64。其他方法见secodeFuzz.cj。其中100000为定义测试次数。其他参数可不变
        DT_FUZZ_Float64(0,30000000,case_name,0,call_fuzz)
        case_name.free()
    }
}

main(){
    unboundTest()
    return
}