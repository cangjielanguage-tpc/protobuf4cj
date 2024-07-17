package base

from std import collection.*
from protobuf import protobuf.*

public class IntData <: MessageLite & TypedMessage<IntData> {
    private var p_intData01 = Int32(0)
    public let intData02 = RepeatedField<Int32>()
    private var p_intData03 = 0
    public let intData04 = RepeatedField<Int64>()
    private var p_uIntData01 = UInt32(0)
    public let uIntData02 = RepeatedField<UInt32>()
    private var p_uIntData03 = UInt64(0)
    public let uIntData04 = RepeatedField<UInt64>()
    private var p_sIntData01 = Int32(0)
    public let sIntData02 = RepeatedField<Int32>()
    private var p_sIntData03 = 0
    public let sIntData04 = RepeatedField<Int64>()
    private var p_fixedData01 = UInt32(0)
    public let fixedData02 = RepeatedField<UInt32>()
    private var p_fixedData03 = UInt64(0)
    public let fixedData04 = RepeatedField<UInt64>()
    private var p_sFixedData01 = Int32(0)
    public let sFixedData02 = RepeatedField<Int32>()
    private var p_sFixedData03 = 0
    public let sFixedData04 = RepeatedField<Int64>()

    public init() {
        m_init(intData02)
        m_init(intData04)
        m_init(uIntData02)
        m_init(uIntData04)
        m_init(sIntData02)
        m_init(sIntData04)
        m_init(fixedData02)
        m_init(fixedData04)
        m_init(sFixedData02)
        m_init(sFixedData04)
        m_innerInit()
    }

    public mut prop intData01: Int32 { get() { p_intData01 } set(i_vtmp) { p_intData01 = i_vtmp; markDirty() } }

    public mut prop intData03: Int64 { get() { p_intData03 } set(i_vtmp) { p_intData03 = i_vtmp; markDirty() } }

    public mut prop uIntData01: UInt32 { get() { p_uIntData01 } set(i_vtmp) { p_uIntData01 = i_vtmp; markDirty() } }

    public mut prop uIntData03: UInt64 { get() { p_uIntData03 } set(i_vtmp) { p_uIntData03 = i_vtmp; markDirty() } }

    public mut prop sIntData01: Int32 { get() { p_sIntData01 } set(i_vtmp) { p_sIntData01 = i_vtmp; markDirty() } }

    public mut prop sIntData03: Int64 { get() { p_sIntData03 } set(i_vtmp) { p_sIntData03 = i_vtmp; markDirty() } }

    public mut prop fixedData01: UInt32 { get() { p_fixedData01 } set(i_vtmp) { p_fixedData01 = i_vtmp; markDirty() } }

    public mut prop fixedData03: UInt64 { get() { p_fixedData03 } set(i_vtmp) { p_fixedData03 = i_vtmp; markDirty() } }

    public mut prop sFixedData01: Int32 { get() { p_sFixedData01 } set(i_vtmp) { p_sFixedData01 = i_vtmp; markDirty() } }

    public mut prop sFixedData03: Int64 { get() { p_sFixedData03 } set(i_vtmp) { p_sFixedData03 = i_vtmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (p_intData01 != 0) { i_tmp += 1 + varintSize(p_intData01) }
        if (!intData02.isEmpty()) { for (i_itmp in intData02) { i_tmp += 1 + varintSize(i_itmp) } }
        if (p_intData03 != 0) { i_tmp += 1 + varintSize(p_intData03) }
        if (!intData04.isEmpty()) { for (i_itmp in intData04) { i_tmp += 1 + varintSize(i_itmp) } }
        if (p_uIntData01 != 0) { i_tmp += 1 + varintSize(p_uIntData01) }
        if (!uIntData02.isEmpty()) { for (i_itmp in uIntData02) { i_tmp += 1 + varintSize(i_itmp) } }
        if (p_uIntData03 != 0) { i_tmp += 1 + varintSize(p_uIntData03) }
        if (!uIntData04.isEmpty()) { for (i_itmp in uIntData04) { i_tmp += 1 + varintSize(i_itmp) } }
        if (p_sIntData01 != 0) { i_tmp += 1 + sintSize(p_sIntData01) }
        if (!sIntData02.isEmpty()) { for (i_itmp in sIntData02) { i_tmp += 1 + sintSize(i_itmp) } }
        if (p_sIntData03 != 0) { i_tmp += 1 + sintSize(p_sIntData03) }
        if (!sIntData04.isEmpty()) { for (i_itmp in sIntData04) { i_tmp += 1 + sintSize(i_itmp) } }
        if (p_fixedData01 != 0) { i_tmp += 1 + 4 }
        if (!fixedData02.isEmpty()) { i_tmp += (1 + 4) * fixedData02.size }
        if (p_fixedData03 != 0) { i_tmp += 2 + 8 }
        if (!fixedData04.isEmpty()) { i_tmp += (2 + 8) * fixedData04.size }
        if (p_sFixedData01 != 0) { i_tmp += 2 + 4 }
        if (!sFixedData02.isEmpty()) { i_tmp += (2 + 4) * sFixedData02.size }
        if (p_sFixedData03 != 0) { i_tmp += 2 + 8 }
        if (!sFixedData04.isEmpty()) { i_tmp += (2 + 8) * sFixedData04.size }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_intData01 == 0 && intData02.isEmpty() && p_intData03 == 0 && intData04.isEmpty() && p_uIntData01 == 0 &&
        uIntData02.isEmpty() && p_uIntData03 == 0 && uIntData04.isEmpty() && p_sIntData01 == 0 &&
        sIntData02.isEmpty() && p_sIntData03 == 0 && sIntData04.isEmpty() && p_fixedData01 == 0 &&
        fixedData02.isEmpty() && p_fixedData03 == 0 && fixedData04.isEmpty() && p_sFixedData01 == 0 &&
        sFixedData02.isEmpty() && p_sFixedData03 == 0 && sFixedData04.isEmpty()
    }

    protected func m_clear(): Unit {
        p_intData01 = 0
        intData02.clear()
        p_intData03 = 0
        intData04.clear()
        p_uIntData01 = 0
        uIntData02.clear()
        p_uIntData03 = 0
        uIntData04.clear()
        p_sIntData01 = 0
        sIntData02.clear()
        p_sIntData03 = 0
        sIntData04.clear()
        p_fixedData01 = 0
        fixedData02.clear()
        p_fixedData03 = 0
        fixedData04.clear()
        p_sFixedData01 = 0
        sFixedData02.clear()
        p_sFixedData03 = 0
        sFixedData04.clear()
    }

    public func copyFrom(src: IntData): IntData {
        p_intData01 = src.p_intData01
        intData02.copyFrom(src.intData02)
        p_intData03 = src.p_intData03
        intData04.copyFrom(src.intData04)
        p_uIntData01 = src.p_uIntData01
        uIntData02.copyFrom(src.uIntData02)
        p_uIntData03 = src.p_uIntData03
        uIntData04.copyFrom(src.uIntData04)
        p_sIntData01 = src.p_sIntData01
        sIntData02.copyFrom(src.sIntData02)
        p_sIntData03 = src.p_sIntData03
        sIntData04.copyFrom(src.sIntData04)
        p_fixedData01 = src.p_fixedData01
        fixedData02.copyFrom(src.fixedData02)
        p_fixedData03 = src.p_fixedData03
        fixedData04.copyFrom(src.fixedData04)
        p_sFixedData01 = src.p_sFixedData01
        sFixedData02.copyFrom(src.sFixedData02)
        p_sFixedData03 = src.p_sFixedData03
        sFixedData04.copyFrom(src.sFixedData04)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): IntData {
        return IntData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_intData01 = src.parseInt32()
                case 2 => s_add(intData02, src.parseInt32())
                case 3 => p_intData03 = src.parseInt64()
                case 4 => s_add(intData04, src.parseInt64())
                case 5 => p_uIntData01 = src.parseUInt32()
                case 6 => s_add(uIntData02, src.parseUInt32())
                case 7 => p_uIntData03 = src.parseUInt64()
                case 8 => s_add(uIntData04, src.parseUInt64())
                case 10 => p_sIntData01 = src.parseSInt32()
                case 11 => s_add(sIntData02, src.parseSInt32())
                case 12 => p_sIntData03 = src.parseSInt64()
                case 13 => s_add(sIntData04, src.parseSInt64())
                case 14 => p_fixedData01 = src.parseFixed32()
                case 15 => s_add(fixedData02, src.parseFixed32())
                case 16 => p_fixedData03 = src.parseFixed64()
                case 17 => s_add(fixedData04, src.parseFixed64())
                case 18 => p_sFixedData01 = src.parseSFixed32()
                case 19 => s_add(sFixedData02, src.parseSFixed32())
                case 20 => p_sFixedData03 = src.parseSFixed64()
                case 21 => s_add(sFixedData04, src.parseSFixed64())
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_intData01 != 0) { out.append(8); out.packVarint(p_intData01) }
        if (!intData02.isEmpty()) { for (i_itmp in intData02) { out.append(16); out.packVarint(i_itmp) } }
        if (p_intData03 != 0) { out.append(24); out.packVarint(p_intData03) }
        if (!intData04.isEmpty()) { for (i_itmp in intData04) { out.append(32); out.packVarint(i_itmp) } }
        if (p_uIntData01 != 0) { out.append(40); out.packVarint(p_uIntData01) }
        if (!uIntData02.isEmpty()) { for (i_itmp in uIntData02) { out.append(48); out.packVarint(i_itmp) } }
        if (p_uIntData03 != 0) { out.append(56); out.packVarint(p_uIntData03) }
        if (!uIntData04.isEmpty()) { for (i_itmp in uIntData04) { out.append(64); out.packVarint(i_itmp) } }
        if (p_sIntData01 != 0) { out.append(80); out.packSInt(p_sIntData01) }
        if (!sIntData02.isEmpty()) { for (i_itmp in sIntData02) { out.append(88); out.packSInt(i_itmp) } }
        if (p_sIntData03 != 0) { out.append(96); out.packSInt(p_sIntData03) }
        if (!sIntData04.isEmpty()) { for (i_itmp in sIntData04) { out.append(104); out.packSInt(i_itmp) } }
        if (p_fixedData01 != 0) { out.append(117); out.packFixed(p_fixedData01) }
        if (!fixedData02.isEmpty()) { for (i_itmp in fixedData02) { out.append(125); out.packFixed(i_itmp) } }
        if (p_fixedData03 != 0) { out.packTag(16, BIT64); out.packFixed(p_fixedData03) }
        if (!fixedData04.isEmpty()) { for (i_itmp in fixedData04) { out.packTag(17, BIT64); out.packFixed(i_itmp) } }
        if (p_sFixedData01 != 0) { out.packTag(18, BIT32); out.packFixed(p_sFixedData01) }
        if (!sFixedData02.isEmpty()) { for (i_itmp in sFixedData02) { out.packTag(19, BIT32); out.packFixed(i_itmp) } }
        if (p_sFixedData03 != 0) { out.packTag(20, BIT64); out.packFixed(p_sFixedData03) }
        if (!sFixedData04.isEmpty()) { for (i_itmp in sFixedData04) { out.packTag(21, BIT64); out.packFixed(i_itmp) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (p_intData01 != 0) { i_tmp.append("intData01", p_intData01) }
        if (!intData02.isEmpty()) { i_tmp.append("intData02", intData02) }
        if (p_intData03 != 0) { i_tmp.append("intData03", p_intData03) }
        if (!intData04.isEmpty()) { i_tmp.append("intData04", intData04) }
        if (p_uIntData01 != 0) { i_tmp.append("uIntData01", p_uIntData01) }
        if (!uIntData02.isEmpty()) { i_tmp.append("uIntData02", uIntData02) }
        if (p_uIntData03 != 0) { i_tmp.append("uIntData03", p_uIntData03) }
        if (!uIntData04.isEmpty()) { i_tmp.append("uIntData04", uIntData04) }
        if (p_sIntData01 != 0) { i_tmp.append("sIntData01", p_sIntData01) }
        if (!sIntData02.isEmpty()) { i_tmp.append("sIntData02", sIntData02) }
        if (p_sIntData03 != 0) { i_tmp.append("sIntData03", p_sIntData03) }
        if (!sIntData04.isEmpty()) { i_tmp.append("sIntData04", sIntData04) }
        if (p_fixedData01 != 0) { i_tmp.append("fixedData01", p_fixedData01) }
        if (!fixedData02.isEmpty()) { i_tmp.append("fixedData02", fixedData02) }
        if (p_fixedData03 != 0) { i_tmp.append("fixedData03", p_fixedData03) }
        if (!fixedData04.isEmpty()) { i_tmp.append("fixedData04", fixedData04) }
        if (p_sFixedData01 != 0) { i_tmp.append("sFixedData01", p_sFixedData01) }
        if (!sFixedData02.isEmpty()) { i_tmp.append("sFixedData02", sFixedData02) }
        if (p_sFixedData03 != 0) { i_tmp.append("sFixedData03", p_sFixedData03) }
        if (!sFixedData04.isEmpty()) { i_tmp.append("sFixedData04", sFixedData04) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { IntData() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = IntData(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = IntData(); i_tmp.unpack(src); i_tmp }
}
