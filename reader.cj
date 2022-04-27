package protobuf

public enum ReaderSeekBase { SET | CUR | END }

public class SimpleReader {
    public SimpleReader (
        private let buffer: List<UInt8>,
        private let begin!: Int64 = 0,
        private let end!: Int64 = buffer.size(),
        private var offset!: Int64 = begin
    ) {
        if (begin < 0 || end > buffer.size()) {
            throw IllegalArgumentException("SimpleReader Arguments out of range.")
        }
    }

    /* unread bytes size */
    public func size() {
        end - offset
    }

    /* any data unread */
    public func isEmpty() {
        return offset >= end
    }

    /* seek the offset */
    public func seek(offset: Int64, base!: ReaderSeekBase = CUR) {
        match(base) {
            case SET => this.offset = begin + offset
            case CUR => this.offset += offset
            case END => this.offset = end - offset
        }
        this.offset
    }

    /* peek a byte */
    public func peek(i: Int64) { 
        buffer[offset + i]
    }

    /* all data */
    public func data() { 
        if (offset >= end) {
            return List<UInt8>()
        }
        buffer[offset..end]
    }

    /* read a byte, increase the offset */
    public func read() { 
        let v = buffer[offset]
        offset++
        v
    }

    /* read length of `s` bytes, return its reader. */
    public func read(s: Int64) { 
        let v = SimpleReader(buffer, begin: offset, end: offset + s)
        offset += s
        v
    }

    /* read `v`, if succeed, increase the offset */
    public func read(v: UInt8) {
        if (offset < begin || offset >= end || buffer[offset] != v) {
            return false
        }
        offset++
        true
    }

    /* read `a`, if succeed, increase the offset */
    public func read(a: Collection<UInt8>) {
        if (offset < begin || offset + a.size() > end) {
            return false
        }

        var s = offset
        for (u in a) {
            if (buffer[s] != u) {
                return false
            }
            s++
        }

        offset = s
        true
    }

    public func debug() {
        println("begin: ${begin}, end: ${end}, offset: ${offset}")
    }
}