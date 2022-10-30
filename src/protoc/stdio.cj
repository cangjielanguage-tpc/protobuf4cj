/* 通过ffi进行stdio */

@c
struct rbuf {
    var data: CPointer<UInt8> = CPointer<UInt8>()
    var size: Int64 = 0
}

foreign func stdin_read(buf: CPointer<rbuf>): Unit
foreign func stdout_write(buf: CPointer<rbuf>): Unit
foreign func rbuf_new(): CPointer<rbuf>
foreign func rbuf_malloc(size: Int64): CPointer<rbuf>
foreign func rbuf_free(buf: CPointer<rbuf>): Unit

func stdin(b: ArrayList<UInt8>) {
    unsafe {
        let ptr = rbuf_new()
        stdin_read(ptr)
        let buf = ptr.read()
        for (i in 0..buf.size) {
            b.append(buf.data.read(i))
        }
        rbuf_free(ptr)
    }
}

func stdout(c: Collection<UInt8>) {
    unsafe {
        let ptr = rbuf_malloc(c.size)
        let buf = ptr.read()
        var i = 0
        for (b in c) {
            buf.data.write(i, b)
            i++
        }
        stdout_write(ptr)
        rbuf_free(ptr)
    }
}