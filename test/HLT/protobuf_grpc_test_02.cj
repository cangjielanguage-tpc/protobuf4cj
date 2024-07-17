// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf

package grpctest

from std import io.*
from std import collection.*
from protobuf import grpc.*
from std import time.*
from std import sync.*

@Test
public class ProtoBufGRPCTest02 {
	var status_1 = Status.OK
	var status_2 = Status.CANCELLED
	var status_3 = Status.UNKNOWN
	var status_4 = Status.INVALID_ARGUMENT
	var status_5 = Status.DEADLINE_EXCEEDED
	var status_6 = Status.NOT_FOUND
	var status_7 = Status.ALREADY_EXISTS
	var status_8 = Status.PERMISSION_DENIED 
	var status_9 = Status.RESOURCE_EXHAUSTED
	var status_10 = Status.FAILED_PRECONDITION
	var status_11 = Status.ABORTED
	var status_12 = Status.OUT_OF_RANGE
	var status_13 = Status.UNIMPLEMENTED
	var status_14 = Status.INTERNAL
	var status_15 = Status.UNAVAILABLE
	var status_16 = Status.DATA_LOSS
	var status_17 = Status.UNAUTHENTICATED

	@TestCase
	func test_protobuf_grpc_009(): Unit {
		println(status_1.exception().toString())
		println(status_3.exception().toString())
		println(status_6.exception().toString())
		println(status_12.exception().toString())

		@Assert(status_1.ok())
		@Assert(status_2.ok(), false)
		@Assert(status_3.ok(), false)
		@Assert(status_4.ok(), false)
		@Assert(status_5.ok(), false)
		@Assert(status_6.ok(), false)
		@Assert(status_7.ok(), false)
		@Assert(status_8.ok(), false)
		@Assert(status_9.ok(), false)
		@Assert(status_10.ok(), false)
		@Assert(status_11.ok(), false)
		@Assert(status_12.ok(), false)
		@Assert(status_13.ok(), false)
		@Assert(status_14.ok(), false)
		@Assert(status_15.ok(), false)
		@Assert(status_16.ok(), false)
		@Assert(status_17.ok(), false)
	}

	@TestCase
	func test_protobuf_grpc_010(): Unit {
		
		@Assert(status_1.toString(), "OK")
		@Assert(status_2.toString(), "CANCELLED")
		@Assert(status_3.toString(), "UNKNOWN")
		@Assert(status_4.toString(), "INVALID ARGUMENT")
		@Assert(status_5.toString(), "DEADLINE EXCEEDED")
		@Assert(status_6.toString(), "NOT FOUND")
		@Assert(status_7.toString(), "ALREADY EXISTS")
		@Assert(status_8.toString(), "PERMISSION DENIED")
		@Assert(status_9.toString(), "RESOURCE EXHAUSTED")
		@Assert(status_10.toString(), "FAILED PRECONDITION")
		@Assert(status_11.toString(), "ABORTED")
		@Assert(status_12.toString(), "OUT OF RANGE")
		@Assert(status_13.toString(), "UNIMPLEMENTED")
		@Assert(status_14.toString(), "INTERNAL")
		@Assert(status_15.toString(), "UNAVAILABLE")
		@Assert(status_16.toString(), "DATA LOSS")
		@Assert(status_17.toString(), "UNAUTHENTICATED")
	}

	@TestCase
	func test_protobuf_grpc_011(): Unit {
		@Assert(Status.fromCode(0).toString(), status_1.toString())
		@Assert(Status.fromCode(1).toString(), status_2.toString())
		@Assert(Status.fromCode(2).toString(), status_3.toString())
		@Assert(Status.fromCode(3).toString(), status_4.toString())
		@Assert(Status.fromCode(4).toString(), status_5.toString())
		@Assert(Status.fromCode(5).toString(), status_6.toString())
		@Assert(Status.fromCode(6).toString(), status_7.toString())
		@Assert(Status.fromCode(7).toString(), status_8.toString())
		@Assert(Status.fromCode(8).toString(), status_9.toString())
		@Assert(Status.fromCode(9).toString(), status_10.toString())
		@Assert(Status.fromCode(10).toString(),status_11.toString())
		@Assert(Status.fromCode(11).toString(), status_12.toString())
		@Assert(Status.fromCode(12).toString(), status_13.toString())
		@Assert(Status.fromCode(13).toString(), status_14.toString())
		@Assert(Status.fromCode(14).toString(), status_15.toString())
		@Assert(Status.fromCode(15).toString(), status_16.toString())
		@Assert(Status.fromCode(16).toString(), status_17.toString())
	}

	@TestCase
	func test_protobuf_grpc_012(): Unit {
		var address = Address("http", "0.0.0.0", 1234)
		@Assert(address.toString(), "http://0.0.0.0:1234")
		var address2 = Address("https://192.168.1.111:222")
		@Assert(address2.toString(), "https://192.168.1.111:222")
	}
	
}