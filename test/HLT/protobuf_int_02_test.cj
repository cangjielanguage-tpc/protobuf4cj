// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_int.pb.cj

package base

from std import io.*

@Test
public class ProtoBufIntTest {
	
	@TestCase
	func test_protobuf_int_011(): Unit {
		var intData = IntData.empty()
		var sIntData03 = intData.sIntData03
		var sIntData04 = intData.sIntData04
		@Assert(sIntData03, Int64(0))
		@Assert(sIntData04, RepeatedField<Int64>())
	}
	
	@TestCase
	func test_protobuf_int_012(): Unit {
		var intData = IntData.empty()

		intData.sIntData03 = 2222
		var list = RepeatedField<Int64>([1000, 2245370, 3])
		intData.sIntData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.sIntData03, 2222)
		@Assert(unpackData.sIntData04, list)
	}

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_013(): Unit {
		var intData = IntData.empty()
		var fixedData01 = intData.fixedData01
		var fixedData02 = intData.fixedData02
		@Assert(fixedData01, UInt32(0))
		@Assert(fixedData02, RepeatedField<UInt32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_014(): Unit {
		var intData = IntData.empty()

		intData.fixedData01 = 15
		var list = RepeatedField<UInt32>([1000, 20, 3])
		intData.fixedData02.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.fixedData01, 15)
		@Assert(unpackData.fixedData02, list)
	}

	@TestCase
	func test_protobuf_int_015(): Unit {
		var intData = IntData.empty()
		var fixedData03 = intData.fixedData03
		var fixedData04 = intData.fixedData04
		@Assert(fixedData03, UInt64(0))
		@Assert(fixedData04, RepeatedField<UInt64>())
	}
	
	@TestCase
	func test_protobuf_int_016(): Unit {
		var intData = IntData.empty()

		intData.fixedData03 = 2222
		var list = RepeatedField<UInt64>([1000, 2245370, 3])
		intData.fixedData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.fixedData03, 2222)
		@Assert(unpackData.fixedData04, list)
	}

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_017(): Unit {
		var intData = IntData.empty()
		var sFixedData01 = intData.sFixedData01
		var sFixedData02 = intData.sFixedData02
		@Assert(sFixedData01, Int32(0))
		@Assert(sFixedData02, RepeatedField<Int32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_018(): Unit {
		var intData = IntData.empty()

		intData.sFixedData01 = 15
		var list = RepeatedField<Int32>([1000, 20, 3])
		intData.sFixedData02.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.sFixedData01, 15)
		@Assert(unpackData.sFixedData02, list)
	}

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_019(): Unit {
		var intData = IntData.empty()
		var sFixedData03 = intData.sFixedData03
		var sFixedData04 = intData.sFixedData04
		@Assert(sFixedData03, Int64(0))
		@Assert(sFixedData04, RepeatedField<Int64>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_020(): Unit {
		var intData = IntData.empty()

		intData.sFixedData03 = 15
		var list = RepeatedField<Int64>([1000, 20, 3])
		intData.sFixedData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.sFixedData03, 15)
		@Assert(unpackData.sFixedData04, list)
	}
}