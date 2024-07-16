// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: base/protobuf_double.pb.cj 

package base

from std import io.*

@Test
public class ProtoBufDoubleTest {

	//查看默认值，不进行赋值直接读取
	@TestCase
	func test_protobuf_double_001(): Unit {
		// double类型默认值，对应到C++中是double，对应到cj是Float64
		var douleData = DoubleData.empty()
		var douleData01 = douleData.doubleData01
		var douleData02 = douleData.doubleData02
		@Assert(douleData01, Float64(0))
		@Assert(douleData02, RepeatedField<Float64>())
	}

	//设置值后读取
	@TestCase
	func test_protobuf_double_002(): Unit {
		var douleData = DoubleData.empty()

		douleData.doubleData01 = 3.1415
		var list = RepeatedField<Float64>([0.123, 1.234, 2.345])
		douleData.doubleData02.copyFrom(list)

		// 创建写入工具, 注意要设置长度
		var doublePack = SimpleWriter(douleData.size)
		// 先清空再打包
		doublePack.clear()
		douleData.pack(doublePack)
		// 获取打包后的数据
		var packData = doublePack.data

		// 新建存放解析结果变量
		var unpackData = DoubleData.empty()

		// 解析并验证
		unpackData.unpack(packData)
		@Assert(unpackData.doubleData01, 3.1415)
		@Assert(unpackData.doubleData02, list)
	}
}