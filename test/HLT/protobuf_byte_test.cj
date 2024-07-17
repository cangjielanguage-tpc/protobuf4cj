// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_byte.pb.cj

package base

from std import io.*

@Test
public class ProtoBufByteTest {

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_byte_001(): Unit {
		var byteData = ByteData()
		var byteData01 = byteData.byteData01
		var byteData02 = byteData.byteData02
	
		var a = RoArray<Byte>(ArrayList<UInt8>())
	    @Assert(byteData01, a)
		var b = ArrayList<RoArray<Byte>>()
		@Assert(byteData02, RepeatedField<RoArray<Byte>>(b))
	}

	//设置值后读取
	@TestCase
	func test_protobuf_byte_002(): Unit {
		var byteData = ByteData()

		var a = RoArray<Byte>(ArrayList<UInt8>([1, 2 , 55, 111]))
	    byteData.byteData01 = a
		var list = ArrayList<RoArray<Byte>>()
        list.append(RoArray<Byte>(ArrayList<UInt8>([1, 2, 3])))
        list.append(RoArray<Byte>(ArrayList<UInt8>([4, 5, 6])))
        list.append(RoArray<Byte>(ArrayList<UInt8>([7, 8, 9])))
        
        byteData.byteData02.copyFrom(RepeatedField<RoArray<Byte>>(list))
		
		var bytePack = SimpleWriter(byteData.size)
		bytePack.clear()
		byteData.pack(bytePack)

		var packData = bytePack.data
		var unpackData = ByteData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.byteData01, a)
		@Assert(unpackData.byteData02, RepeatedField<RoArray<Byte>>(list))
	}
}