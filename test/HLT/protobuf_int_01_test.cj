// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_int.pb.cj

package base

from std import io.*

@Test
public class ProtoBufIntTest {

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_001(): Unit {
		var intData = IntData.empty()
		var intData01 = intData.intData01
		var intData02 = intData.intData02
		@Assert(intData01, Int32(0))
		@Assert(intData02, RepeatedField<Int32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_002(): Unit {
		var intData = IntData.empty()

		intData.intData01 = 15
		var list = RepeatedField<Int32>([1000, 20, 3])
		intData.intData02.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.intData01, 15)
		@Assert(unpackData.intData02, list)
	}

	@TestCase
	func test_protobuf_int_003(): Unit {
		var intData = IntData.empty()
		var intData03 = intData.intData03
		var intData04 = intData.intData04
		@Assert(intData03, Int64(0))
		@Assert(intData04, RepeatedField<Int64>())
	}
	
	@TestCase
	func test_protobuf_int_004(): Unit {
		var intData = IntData.empty()

		intData.intData03 = 2222
		var list = RepeatedField<Int64>([1000, 2245370, 3])
		intData.intData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.intData03, 2222)
		@Assert(unpackData.intData04, list)
	}


	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_005(): Unit {
		var intData = IntData.empty()
		var uIntData01 = intData.uIntData01
		var uIntData02 = intData.uIntData02
		@Assert(uIntData01, UInt32(0))
		@Assert(uIntData02, RepeatedField<UInt32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_006(): Unit {
		var intData = IntData.empty()

		intData.uIntData01 = 15
		var list = RepeatedField<UInt32>([1000, 20, 3])
		intData.uIntData02.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.uIntData01, 15)
		@Assert(unpackData.uIntData02, list)
	}

	@TestCase
	func test_protobuf_int_007(): Unit {
		var intData = IntData.empty()
		var uIntData03 = intData.uIntData03
		var uIntData04 = intData.uIntData04
		@Assert(uIntData03, UInt64(0))
		@Assert(uIntData04, RepeatedField<UInt64>())
	}
	
	@TestCase
	func test_protobuf_int_008(): Unit {
		var intData = IntData.empty()

		intData.uIntData03 = 2222
		var list = RepeatedField<UInt64>([1000, 2245370, 3])
		intData.uIntData04.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.uIntData03, 2222)
		@Assert(unpackData.uIntData04, list)
	}

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_int_009(): Unit {
		var intData = IntData.empty()
		var sIntData01 = intData.sIntData01
		var sIntData02 = intData.sIntData02
		@Assert(sIntData01, Int32(0))
		@Assert(sIntData02, RepeatedField<Int32>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_int_010(): Unit {
		var intData = IntData.empty()

		intData.sIntData01 = 15
		var list = RepeatedField<Int32>([1000, 20, 3])
		intData.sIntData02.copyFrom(list)

		var intPack = SimpleWriter(intData.size)
		intPack.clear()
		intData.pack(intPack)

		var packData = intPack.data
		var unpackData = IntData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.sIntData01, 15)
		@Assert(unpackData.sIntData02, list)
	}
}