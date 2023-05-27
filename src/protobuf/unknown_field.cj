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
        public let data: BytesSlice
    ) {}

    @OverflowWrapping
    public func packSize() {
        tagSize(tag) + if (wireType.value == PREFIXED) { varintSize(data.size) + data.size } else { data.size }
    }

    /* Pack out the unknown field with tag. */
    public func pack<T>(out: T) where T <: BytesWriter {
        out.packTag(tag, wireType)
        if (wireType.value == PREFIXED) { out.packVarint(data.size) }
        out.appendBytes(unsafe { data.getRawArray() })
    }

    public static func unpack<T>(tag: Tag, wt: WireNum, src: T) where T <: BytesReader {
        MessageUnknownField(tag, WireType.parse(wt), match (wt) {
            case 0 => src.parseVarintData()
            case 1 => src.read(8)
            case 2 => src.parseBytesSlice()
            case 5 => src.read(4)
            case _ => throw ParseValueExecption("UnknownField")
        })
    }

    public func toString() { "{tag: ${tag}, wireType: ${wireType}, data: ${data}}" }

    public func clone() { this }
}