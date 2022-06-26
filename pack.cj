/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: Functions that manipulate data.
 */
package protobuf

/* encode/decode basic datum */
from std import collection.*
public type Tag = UInt32
public type Bytes = Buffer<UInt8>

/*
 * the number of bytes required to store the tag for the field. Includes
 * 3 bits for the wire-type, and a single bit that denotes the end-of-tag.
 */
func tagSize(tagID: Tag) {
    if (tagID < (1 << 4)) {
		1
	} else if (tagID < (1 << 11)) {
		2
	} else if (tagID < (1 << 18)) {
		3
	} else if (tagID < (1 << 25)) {
		4
	} else {
		5
	}
}

/* pack a tag(with wire-type). */
func tagPack(v: Tag, w: WireType, out: Bytes) {
    varintPack(UInt64(v) << 3 | UInt64(w.value()), out)
}

/* parse a tag(with wire-type). */
func tagParse(src: SimpleReader): (Tag, WireType) {
    if (src.isEmpty()) {
        throw ParseValueExecption("tag", reason: "empty buffer")
    }

    var byte = src.read()
    if ((byte & 0xf8) == 0) {
        src.seek(-1)
        throw ParseValueExecption("tag", reason: "invalid tag value")
    }

    var tag = UInt32(byte & 0x7f) >> 3
    let wireType = WireType.parse(Int32(byte & 7))
    if ((byte & 0x80) == 0) {
        return (tag, wireType)
    }

    var shift: UInt8 = 4
    for (i in 1..5) {
        if (src.isEmpty()) {
            src.seek(-i)
            throw ParseValueExecption("tag", reason: "incomplete buffer")
        }

        byte = src.read()
        if ((byte & 0x80) == 0) {
            tag |= UInt32(byte) << shift
            return (tag, wireType)
        }

        tag |= UInt32(byte & 0x7f) << shift
        shift += 7
    }

    src.seek(-5)
    throw ParseValueExecption("tag", reason: "invalid tag value")
}

/* the number of bytes required to store a base-128 encoding varint. */
func varintSize(v: UInt64) {
    if (v > 0x7fff_ffff_ffff_ffff) {
        10
    } else if (v < (1 << 7)) {
        1
    } else if (v < (1 << 14)) {
        2
    } else if (v < (1 << 21)) {
        3
    } else if (v < (1 << 28)) {
        4
    } else if (v < (1 << 35)) {
        5
    } else if (v < (1 << 42)) {
        6
    } else if (v < (1 << 49)) {
        7
    } else if (v < (1 << 56)) {
        8
    } else {
        9
    }
}

/* pack a varint. */
@overflowWrapping
func varintPack(v: UInt64, out: Bytes) {
    var v = v
    while (v >= 0x80) {
        out.add(UInt8(v | 0x80))
        v >>= 7
    }
    out.add(UInt8(v))
}

/* parse a varint. */
func varintParse(src: SimpleReader) { 
    if (src.isEmpty()) {
        throw ParseValueExecption("varint", reason: "empty buffer")
    }

    var byte = src.read()
    var rv = UInt64(byte & 0x7f)
    if ((byte & 0x80) == 0) {
        return rv
    }

    var shift: UInt8 = 7
    for (i in 1..10) {
        if (src.isEmpty()) {
            src.seek(-i)
            throw ParseValueExecption("varint", reason: "incomplete buffer")
        }

        byte = src.read()
        if ((byte & 0x80) == 0) {
            rv |= UInt64(byte) << shift
            return rv
        }
        rv |= UInt64(byte & 0x7f) << shift
        shift += 7
    }

    src.seek(-10)
    throw ParseValueExecption("varint", reason: "invalid tag value")
}

/**
 * the ZigZag-encoded 32-bit unsigned integer form of a 32-bit signed
 * integer.
 */
@overflowWrapping
func zigzag(v: Int32) {
    (UInt32(v) << 1) ^ UInt32(v >> 31)
}

/**
 * the ZigZag-encoded 64-bit unsigned integer form of a 64-bit signed integer.
 */
@overflowWrapping
func zigzag(v: Int64) {
    (UInt64(v) << 1) ^ UInt64(v >> 63)
}

/**
 * Unzigzag a ZigZag-decoded 32-bit unsigned integer to a 32-bit signed integer.
 */
@overflowWrapping
func unzigzag(v: UInt32) {
    Int32((v >> 1) ^ -(v & 1))
}

/**
 * Unzigzag a ZigZag-decoded 64-bit unsigned integer to a 64-bit signed integer.
 */
@overflowWrapping
func unzigzag(v: UInt64) {
    Int64((v >> 1) ^ -(v & 1))
}

/**
 * Pack a 32-bit quantity in little-endian byte order. Used for protobuf wire
 * types fixed32, sfixed32, float. Similar to "htole32".
 */
@overflowWrapping
func fixedPack(value: UInt32, out: Bytes) {
    out.add(UInt8(value))
    out.add(UInt8(value >> 8))
    out.add(UInt8(value >> 16))
    out.add(UInt8(value >> 24))
}
@overflowWrapping
func fixedPack(value: Int32, out: Bytes) {
    out.add(UInt8(value))
    out.add(UInt8(value >> 8))
    out.add(UInt8(value >> 16))
    out.add(UInt8(value >> 24))
}
func fixedPack(value: Float32, out: Bytes) {
    fixedPack(floatBits(value), out)
}

/**
 * Pack a 64-bit quantity in little-endian byte order. Used for protobuf wire
 * types fixed64, sfixed64, double. Similar to "htole64".
 */
@overflowWrapping
func fixedPack(value: UInt64, out: Bytes) {
    out.add(UInt8(value))
    out.add(UInt8(value >> 8))
    out.add(UInt8(value >> 16))
    out.add(UInt8(value >> 24))
    out.add(UInt8(value >> 32))
    out.add(UInt8(value >> 40))
    out.add(UInt8(value >> 48))
    out.add(UInt8(value >> 56))
}
@overflowWrapping
func fixedPack(value: Int64, out: Bytes) {
    out.add(UInt8(value))
    out.add(UInt8(value >> 8))
    out.add(UInt8(value >> 16))
    out.add(UInt8(value >> 24))
    out.add(UInt8(value >> 32))
    out.add(UInt8(value >> 40))
    out.add(UInt8(value >> 48))
    out.add(UInt8(value >> 56))
}
func fixedPack(value: Float64, out: Bytes) {
    fixedPack(floatBits(value), out)
}

/**
 * Pack bytes.
 */
func binPack(value: Collection<UInt8>, out: Bytes) {
    varintPack(UInt64(value.size()), out)
	out.addAll(value)
}

/* Pack string */
func strPack(v: String, out: Bytes) {
    binPack(v.toUtf8Array(), out)
}

// ffi
foreign func itof(v: UInt32): Float32
foreign func ltod(v: UInt64): Float64
foreign func ftoi(v: Float32): UInt32
foreign func dtol(v: Float64): UInt64

func floatBits(v: UInt32) {
    unsafe { itof(v) }
}

func floatBits(v: UInt64) {
    unsafe { ltod(v) }
}

func floatBits(v: Float32) {
    unsafe { ftoi(v) }
}

func floatBits(v: Float64) {
    unsafe { dtol(v) }
}

/* parse a 32-bits value. */
func fixed32Parse(src: SimpleReader) { 
    if (src.size() < 4) {
        throw ParseValueExecption("fixed32", reason: "incomplete buffer")
    }

    UInt32(src.read()) | (UInt32(src.read()) << 8) | (UInt32(src.read()) << 16) | (UInt32(src.read()) << 24)
}

/* parse a 64-bits value. */
func fixed64Parse(src: SimpleReader) { 
    if (src.size() < 8) {
        throw ParseValueExecption("fixed32", reason: "incomplete buffer")
    }

    UInt64(src.read()) | (UInt64(src.read()) << 8) | (UInt64(src.read()) << 16) | (UInt64(src.read()) << 24) |
    (UInt64(src.read()) << 32) | (UInt64(src.read()) << 40) | (UInt64(src.read()) << 48) | (UInt64(src.read()) << 56)
}

func binParse(src: SimpleReader) {
    src.read(Int64(varintParse(src)))
}

func strParse(src: SimpleReader): String {
    StringBuilder().append(binParse(src).data()).toString()
}