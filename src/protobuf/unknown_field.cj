/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

public class MessageUnknownField <: ToString {
    public MessageUnknownField(
        /** The tag number. */
        public let tag: Tag,
        /** The wire type of the field. */
        public let wireType: WireType,
        /** Field data. */
        public let data: Bytes
    ) {}

    public func packSize() {
        tagSize(tag) + if (wireType.value == PREFIXED) { varintSize(data.size) + data.size } else { data.size }
    }

    /* Pack out the unknown field with tag. */
    public func pack<T>(out: T) where T <: BytesWriter {
        tagPack(tag, wireType, out)
        if (wireType.value == PREFIXED) { varintPack(data.size, out) }
        out.appendBytes(data)
    }

    public static func unpack<T>(tag: Tag, wt: WireNum, src: T) where T <: BytesReader & SubReader<T> {
        MessageUnknownField(tag, WireType.parse(wt), match (wt) {
            case 0 => varintData(src)
            case 1 => src.read(8).data().toArray()
            case 2 => sub(src).data().toArray()
            case 5 => src.read(4).data().toArray()
            case _ => throw ParseValueExecption("UnknownField")
        })
    }

    public func toString() { "{tag: ${tag}, wireType: ${wireType}, data: ${data}}" }

    public func clone() { MessageUnknownField(tag, wireType, data.clone()) }
}