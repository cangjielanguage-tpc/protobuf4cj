// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_bool.pb.cj base/protobuf_string.pb.cj 

package base

from std import io.*

@Test
public class ProtoBufBoolAndStringTest {

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_bool_001(): Unit {
		var boolData = BoolData.empty()
		var boolData01 = boolData.boolData01
		var boolData02 = boolData.boolData02
		@Assert(boolData01, false)
		@Assert(boolData02, RepeatedField<Bool>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_bool_002(): Unit {
		var boolData = BoolData.empty()

		boolData.boolData01 = true
		var list = RepeatedField<Bool>([false, true, true])
		boolData.boolData02.copyFrom(list)

		var boolPack = SimpleWriter(boolData.size)
		boolPack.clear()
		boolData.pack(boolPack)

		var packData = boolPack.data
		var unpackData = BoolData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.boolData01, true)
		@Assert(unpackData.boolData02, list)
	}

	@TestCase
	func test_protobuf_string_001(): Unit {
		var stringData = StringData.empty()
		var stringData01 = stringData.stringData01
		var stringData02 = stringData.stringData02
		@Assert(stringData01, "")
		@Assert(stringData02.toArray(), Array<String>())
	}
	
	@TestCase
	func test_protobuf_string_002(): Unit {
		var stringData = StringData.empty()

		stringData.stringData01 = "hello"
		var list = ["数据1", "数据2", "数据3"]
		stringData.stringData02.appendAll(list)

		var stringPack = SimpleWriter(stringData.size)
		stringPack.clear()
		stringData.pack(stringPack)

		var packData = stringPack.data
		var unpackData = StringData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.stringData01, "hello")
		@Assert(unpackData.stringData02.toArray(), list)
	}

	@TestCase
	func test_protobuf_string_003(): Unit {
		var stringData = StringData.empty()

		var string01 = """
						Hello,
						Cangjie Lang"""
		// 单行字符串字面量：内容定义在一对双引号之内，非转义的双引号和单独出现的 \ 不能编译
		// 原始字符串字面量：以一个或多个井号#加上一个双引号开始，里面的转义符不会转义
		var string02 = [##"\n"##, "123\n456", "\"Hello Cangjie Lang\""]

		stringData.stringData01 = string01
		stringData.stringData02.appendAll(string02)

		var stringPack = SimpleWriter(stringData.size)
		stringPack.clear()
		stringData.pack(stringPack)

		var packData = stringPack.data
		var unpackData = StringData.empty()

		unpackData.unpack(packData)
		@Assert(unpackData.stringData01, string01)
		@Assert(unpackData.stringData02.toArray(), string02)
	}

}