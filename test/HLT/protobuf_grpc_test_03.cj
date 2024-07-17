// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: grpctest/grpc_test.pb.cj

package grpctest

from std import io.*
from std import time.*
from std import sync.*

@Test
public class ProtoBufGRPCTest {

	@TestCase
	func test_protobuf_grpc_013(): Unit {
		// 服务地址
		let address = Address("http://0.0.0.0:1234") 
		// 凭证
		let credential = Credential()
		// grpc服务
		let server = grpc.Server()
		// 绑定地址
		server.bind(address)
		// 注册服务实体
		server.registerService(EchoServiceImpl())
		println("server start.")

		// 客户端通道
		let channel = SingleChannel(address, credential) 
		// 客户端
		let client = EchoClient(channel) 
		
		let result:Future<Bool> = spawn { =>
			sleep(200 * Duration.nanosecond) 
			// 启动连接
			channel.connect()

			let sendResult:Future<Bool> = spawn { =>
				var returnBool = false 
				let req = Text()
				req.text = "test_protobuf_grpc_013"
				
				let metadata = Metadata()
				metadata.append("test", "test_protobuf_grpc_013--1")
				metadata.append("test", "test_protobuf_grpc_013--2")
				let recTrailer = Metadata()
				recTrailer.append("test", [1, 2, 3, 4, 5])
				let header = Metadata()

				let (resp, status) = client.echo(req, opts: CallOptions().withMetadata(metadata).withRecHeader(header).withTimeOut(1 * Duration.second))
				println(status)
				if(resp.toString() != ("{text: \"test_protobuf_grpc_013\"}")){
					returnBool = false
				} else if(header.toString() !=("{}")) {
					returnBool = false
				} else {
					returnBool = true
				}
				server.shutdown() 
				return true
			}
			var res = sendResult.get()
			return res
		}
		server.run() 
		var resultBool = result.get()
		@Assert(resultBool)
	}

	@TestCase
	func test_protobuf_grpc_014(): Unit {
		// 服务地址
		let address = Address("http://0.0.0.0:1234") 
		// 凭证
		let credential = Credential()
		// grpc服务
		let server = grpc.Server()
		// 绑定地址
		server.bind(address, credential)
		// 注册服务实体
		server.registerService(EchoServiceImpl())
		println("server start.")

		// 客户端通道
		let channel = SingleChannel(address, credential)     
		// 客户端
		let client = EchoClient(channel)   
		// 计数器
		// let count = AtomicInt64(0)

		let result:Future<Bool> = spawn { =>
			sleep(200 * Duration.nanosecond)  
			var returnBool = false
			// 启动连接
			channel.connect()

			let stream = client.echoDoubleStream()  
			let text = Text()

			try {
				// 请求数据
				text.text = "hello stream, request"
				print("send: ${text}\n", flush: true)
				// 向流中写入请求数据
				stream.write(text)          

				if (stream.read(text)) {  
					returnBool = true
					print("recv: ${text}\n", flush: true)
				} else {
					returnBool = false
				}
			} catch (ex: Exception) {
				returnBool = false
			}
			stream.finish()
			server.shutdown() 
			return returnBool
		}
		
		server.run()        
		println("exit...") 
		var resultBool = result.get()
		@Assert(resultBool)
	}
}

// 服务器实体
class EchoServiceImpl <: EchoService {
    public func echo(ctx: Context, req: Text) {
		// 返回接收到的信息,用于验证
		println(ctx.getRequestTimeout())
        (req, OK) 
    }

    protected func echoServerStream(ctx: Context, req: Text, writer: ServerWriter<Text>): Status {
        for (i in 0..10) {
            writer.write(req)
        }
		println(ctx.getRequestTimeout())
        OK
    }

    protected func echoClientStream(ctx: Context, reader: ServerReader<Text>): (Text, Status) {
        let resp = Text()
        let tmp = Text()
        while (reader.read(tmp)) {
            resp.text += tmp.text
        }
		println(ctx.getRequestTimeout())
        (resp, OK)
    }

    protected func echoDoubleStream(ctx: Context, stream: ServerReaderWriter<Text, Text>): Status {
        let text = Text()
        while (stream.read(text)) {
            stream.write(text)
        }
		println(ctx.getRequestTimeout())
        OK
    }
}