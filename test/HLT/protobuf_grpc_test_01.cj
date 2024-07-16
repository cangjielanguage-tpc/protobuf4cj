// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf

package grpctest

from std import io.*
from std import collection.*
from protobuf import grpc.*

@Test
public class ProtoBufGRPCTest {

	// public enum LogVerbosity <: ToString
	@TestCase
	func test_protobuf_grpc_001(): Unit {
		var a = LogVerbosity.TRACE
		var b = LogVerbosity.DEBUG
		var c = LogVerbosity.INFO
		var d = LogVerbosity.ERROR
		var e = LogVerbosity.NONE

		@Assert(a.toString(), "TRACE")
		@Assert(b.toString(), "DEBUG")
		@Assert(c.toString(), "INFO ")
		@Assert(d.toString(), "ERROR")
		@Assert(e.toString(), "NONE ")
	}

	@TestCase
	func test_protobuf_grpc_002(): Unit {
		var metadata = Metadata()
		var key = "key"
		var value = "value"
		metadata.append(key, value)
		@Assert(metadata.toString(), "{key: value}")
	}

	@TestCase
	func test_protobuf_grpc_003(): Unit {
		var metadata = Metadata()
		var key = "key"
		var valueList = ArrayList<String>()
		valueList.append("value1")
		valueList.append("value2")

		metadata.append(key, valueList)
		@Assert(metadata.toString(), "{key: [value1, value2]}")
	}

	@TestCase
	func test_protobuf_grpc_004(): Unit {
		var metadata = Metadata()
		var key = "key"
		var valueList = ArrayList<String>()
		valueList.append("value1")
		valueList.append("value2")

		metadata.append(key, valueList)
		@Assert(metadata.toString(), "{key: [value1, value2]}")

		var list = metadata.get(key)
		@Assert(list.toString(), "Some([value1, value2])")

		metadata.remove(key)
		@Assert(metadata.toString(), "{}")
	}

	@TestCase
	func test_protobuf_grpc_005(): Unit {
		var metadata = Metadata()
		var key = "key"
		var valueList = ArrayList<String>()
		valueList.append("value1")
		valueList.append("value2")

		metadata.append(key, valueList)
		@Assert(metadata.toString(), "{key: [value1, value2]}")

		var one = metadata.getOne(key)
		@Assert(one, "value1")

		metadata.remove(key, "value1")
		@Assert(metadata.toString(), "{key: value2}")
	}

	@TestCase
	func test_protobuf_grpc_006(): Unit {
		var metadata = Metadata()
		var key = "key"
		var valueList = ArrayList<String>()
		valueList.append("value1")
		valueList.append("value2")

		metadata.append(key, valueList)
		@Assert(metadata.toString(), "{key: [value1, value2]}")

		var metadata2 = metadata.clone()
		@Assert(metadata2.isEmpty(), false)
		@Assert(metadata2.toString(), "{key: [value1, value2]}")

		metadata2.clear()
		@Assert(metadata2.isEmpty())
	}

	@TestCase
	func test_protobuf_grpc_007(): Unit {
		var metadata = Metadata()
		var key = "key"
		var valueList = ArrayList<String>()
		valueList.append("value1")
		valueList.append("value2")

		metadata.append(key, valueList)

		var bin:Array<UInt8> = Array<UInt8>([1, 2, 3])
		metadata.append(key, bin)

		var getB = metadata.getBin(key)
		@Assert(bin, getB)
	}

	@TestCase
	func test_protobuf_grpc_008(): Unit {
		var key1 = ":key"
		var key2 = "grpc-key"
		var key3 = "te"
		var key4 = "content-type"
		var key5 = "accept-encoding"
		var key6 = "key6"

		@Assert(Metadata.isReservedHeader(key1))
		@Assert(Metadata.isReservedHeader(key2))
		@Assert(Metadata.isReservedHeader(key3))
		@Assert(Metadata.isReservedHeader(key4))
		@Assert(Metadata.isReservedHeader(key5))
		@Assert(Metadata.isReservedHeader(key6), false)
	}
}