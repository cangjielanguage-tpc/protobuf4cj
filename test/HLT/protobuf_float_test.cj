// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_float.pb.cj

package base

from std import io.*

@Test
public class ProtoBufFloatTest {

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_float_001(): Unit {
		var floatData = FloatData.empty()
		var floatData01 = floatData.floatData01
		var floatData02 = floatData.floatData02
		@Assert(floatData01, Float32(0))
		@Assert(floatData02, RepeatedField<Float32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_float_002(): Unit {
		var floatData = FloatData.empty()
		
		floatData.floatData01 = 0.12
		var list = RepeatedField<Float32>([0.12, 1.24, 2.35])
		floatData.floatData02.copyFrom(list)

		var floatPack = SimpleWriter(floatData.size)
		floatPack.clear()
		floatData.pack(floatPack)

		var packData = floatPack.data
		var unpackData = FloatData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.floatData01, 0.12)
		@Assert(unpackData.floatData02, list)
	}
}