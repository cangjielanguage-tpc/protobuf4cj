/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

public class MessageUnknownField <: ToString {
    public MessageUnknownField(
        /** The tag number. */
        let tag: Tag,
        /** The wire type of the field. */
        let wireType: WireType,
        /** Field data. */
        let data: Array<UInt8>
    ) {}

    func packSize() {
        tag.tagSize + data.size()
    }

    /* Pack out the unknown field with tag. */
    func pack(out: BytesWriter) {
        tag.tagPack(wireType, out)
        out.appendAll(data)
    }

    static func unpack(tag: Tag, wt: WireType, src: BytesReader) {
        let len: Int64
        match (wt.value) {
            case v where v == WireType.BIT32.value => len = 4
            case v where v == WireType.BIT64.value => len = 8
            case v where v == WireType.VARINT.value => len = UInt64.parse(src).packSize(); src.seek(-len, CurPos)
            case _ => let p = Int64.parse(src); let v = p.packSize(); len = p + v; src.seek(-v, CurPos)
        }
        MessageUnknownField(tag, wt, src.read(len).data())
    }

    /**
     * The Function is toString
     *
     * @return Type of $
     * @since 0.29.3
     */
    public func toString() { "tag: ${tag}, wireType: ${wireType}, data: ${data}" }
}