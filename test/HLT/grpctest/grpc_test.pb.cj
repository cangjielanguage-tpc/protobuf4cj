package grpctest

from std import collection.*
from protobuf import protobuf.*
from protobuf import grpc.*

public class Text <: MessageLite & TypedMessage<Text> {
    private var p_text: String

    public init(
        text!: String = ""
    ) {
        this.p_text = text
        m_init()
    }

    public init(src: Text__Builder) {
        this.p_text = src.text
        m_init()
    }

    private func m_init() {
        m_innerInit()
    }

    public mut prop text: String { get() { p_text } set(_v) { p_text = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_text.isEmpty()) { _x += 1 + binSize(p_text) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_text.isEmpty()) { _x.write(p_text.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_text.isEmpty()
    }

    protected func m_clear(): Unit {
        p_text = ""
    }

    public operator func !=(src: Text): Bool { !(this == src) }
    public operator func ==(src: Text): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_text == src.p_text
    }

    public func mergeFrom(src: Text): Unit {
        if (!src.p_text.isEmpty()) { p_text = src.p_text }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: Text): Text {
        p_text = src.p_text
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Text {
        return Text().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_text = src.parseString()
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_text.isEmpty()) { out.append(10); out.packBin(p_text) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_text.isEmpty()) { _x.append("text", p_text) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Text() }
    public static func newBuilder() { Text__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Text(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Text(); _x.unpack(src); _x }
}

public class Text__Builder {
    public var text: String = ""
    public func setText(text: String) { this.text = text; return this }

    public func build() { Text(this) }
}

public abstract class EchoService <: Service {
    protected init() { super("grpctest.Echo") }
    protected func m_dispatch(fn: String, sess: ServerSession) {
        match (fn) {
            case "echo" => unaryRequest(sess, echo)
            case "echo_server_stream" => serverStream(sess, echoServerStream)
            case "echo_client_stream" => clientStream(sess, echoClientStream)
            case "echo_double_stream" => duplexStream(sess, echoDoubleStream)
            case _ => notfound(sess)
        }
    }

    protected func echo(ctx: Context, req: Text): (Text, Status)
    protected func echoServerStream(ctx: Context, req: Text, stream: ServerWriter<Text>): Status
    protected func echoClientStream(ctx: Context, stream: ServerReader<Text>): (Text, Status)
    protected func echoDoubleStream(ctx: Context, stream: ServerReaderWriter<Text, Text>): Status
}

public abstract class Unimplemented_EchoService <: EchoService {
    protected open func echo(ctx: Context, req: Text): (Text, Status) { (Text(), UNIMPLEMENTED) }
    protected open func echoServerStream(ctx: Context, req: Text, stream: ServerWriter<Text>): Status { UNIMPLEMENTED }
    protected open func echoClientStream(ctx: Context, stream: ServerReader<Text>): (Text, Status) { (Text(), UNIMPLEMENTED) }
    protected open func echoDoubleStream(ctx: Context, stream: ServerReaderWriter<Text, Text>): Status { UNIMPLEMENTED }
}

public class EchoClient <: Stub {
    public init(chan: Channel) { super(chan, "grpctest.Echo") }

    public func echo(req: Text, resp: Text, opts!: ?CallOptions = None) {
        unaryRequest("echo", req, resp, opts)
    }
    public func echo(req: Text, opts!: ?CallOptions = None) {
        unaryRequest<Text>("echo", req, opts)
    }

    public func echoServerStream(req: Text, opts!: ?CallOptions = None) {
        serverStream<Text>("echo_server_stream", req, opts)
    }

    public func echoClientStream(opts!: ?CallOptions = None) {
        clientStream<Text, Text>("echo_client_stream", opts)
    }

    public func echoDoubleStream(opts!: ?CallOptions = None) {
        duplexStream<Text, Text>("echo_double_stream", opts)
    }
}
