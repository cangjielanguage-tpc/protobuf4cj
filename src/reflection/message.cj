package reflection

from std import collection.*
from protobuf import protobuf.*

public interface GetDescriptor {
    static func descriptor(): MessageDescriptor
    func getDescriptor(): MessageDescriptor
}

public abstract class Message <: MessageLite & GetDescriptor {
    public static func descriptor(): MessageDescriptor { throw DescriptorException("abstract message no static type descriptor") }

    public open func getTypeName(): String { getDescriptor().fullName[1 .. ] }

    public func getReflection(): Reflection { Reflection(this) }

    /* reflection operation getter/setter */
    protected func m_get(tag: Tag): Option<Field>
    protected func m_set(tag: Tag, field: Field): Unit /* throws */
    /* clear to default */
    protected open func m_reset(tag: Tag): Unit
}

public class DynamicMessage <: Message & TypedMessage<DynamicMessage> {
    DynamicMessage(
        let descriptor_: MessageDescriptor
    ) {
        isProto2 = descriptor_.isProto2()
        for (desc in descriptor_.fields) {
            if (desc.isRepeated()) {
                let repeat = Prototype.createRepeatedFields(desc)
                values[desc.tag] = repeat
                repeat.setParent(this)
                continue
            }
            if (!isProto2 && !desc.isMessage()) {  /* TODO, oneof */
                values[desc.tag] = defaultValue(desc.type_, desc.typeName)
            }
        }
        m_innerInit()
    }

    let values = HashMap<Tag, Field>()
    public let isProto2: Bool

    public static func descriptor(): MessageDescriptor { throw DescriptorException("dynamic message no static type descriptor") }

    public func getDescriptor(): MessageDescriptor { descriptor_ }

    public func getTypeName(): String { getDescriptor().fullName[1 .. ] }

    protected func m_clear() {
        values.removeIf { _, val =>
            match (val) {
                case _: Repeated => false
                case msg: Message => m_assign(msg); true
                case _ => isProto2
            }
        }
        for ((tag, val) in values) {
            values[tag] = clearToDefaultValue(val) ?? continue
        }
    }

    protected func m_size() {
        var size = 0
        for (desc in descriptor_.fields) {
            match (values.get(desc.tag)) {
                case Some(val) where !isDefaultValue(val) => size += packSizeWithTag(desc, val)
                case _ => ()
            }
        }
        return size
    }

    protected func m_hashCode() {
        var hasher = DefaultHasher()
        for (desc in descriptor_.fields) {
            match (values.get(desc.tag)) {
                case Some(val) where !isDefaultValue(val) => hasher.write(val.hashCode())
                case _ => ()
            }
        }

        return hasher.finish()
    }

    protected func m_isEmpty() {
        for ((_, val) in values where !isDefaultValue(val)) {
            return false
        }

        return true
    }

    /* unpack from bytes reader interface */
    public func unpacki(src: BytesReader): Unit {
        let reflection = this.getReflection()
        while (!src.isEmpty()) {
            let tag = src.parseTag()
            match (descriptor_.findFieldByTag(tag[0])) {
                case Some(field) => parseValue(field, reflection, src, tag[1])
                case None => m_unknown(src, tag)
            }
        }
    }

    /* pack to bytes writer interface */
    public func packi(out: BytesWriter): Unit {
        for (desc in descriptor_.fields) {
            match (values.get(desc.tag)) {
                case Some(val) where !isDefaultValue(val) => packOutWithTag(desc, val, out)
                case _ => ()
            }
        }
        m_unknown(out)
    }

    public func toString(): String {
        var res = StructPrinter()
        for (desc in descriptor_.fields) {
            match (values.get(desc.tag)) {
                case Some(str: String) where !str.isEmpty() => res.append(desc.jsonName, str)
                case Some(val) where !isDefaultValue(val) => res.append(desc.jsonName, val)
                case _ => ()
            }
        }

        return res.done().toString()
    }

    protected func m_get(tag: Tag): Option<Field> {
        if (let Some(val) <- values.get(tag)) {
            return val
        }

        if (isProto2) {
            return None
        }

        let field = descriptor_.findFieldByTag(tag) ?? return None
        if (!field.isMessage()) {
            return None
        }

        /* proto3 default message value */
        let new = Prototype.createMessage(field.typeName)
        values.put(tag, new)
        return new
    }

    protected func m_set(tag: Tag, field: Field): Unit {
        match ((values.put(tag, field), field)) {
            case (Some(old: Message), new: Message) => m_assign(old, new)
            case (None, new: Message) => m_init(new)
            case _ => ()
        }
        markDirty()
    }

    protected func m_reset(tag: Tag): Unit {
        match (values.get(tag) ?? return) {
            case msg: Message => m_assign(msg); values.remove(tag)
            case rep: Repeated => rep.clear()
            case _ where isProto2 => values.remove(tag)
            case old => values[tag] = clearToDefaultValue(old) ?? return
        }
        markDirty()
    }

    public func clone(): DynamicMessage {
        DynamicMessage(this.descriptor_).copyFrom(this)
    }

    public func copyFrom(that: DynamicMessage): DynamicMessage {
        // TODO, fields copy
        clear()
        unpack(that.pack())
        return this
    }

    public operator func==(that: MessageLite): Bool { that as DynamicMessage == this }
    public operator func==(that: DynamicMessage): Bool {
        if (descriptor_.fullName == that.getDescriptor().fullName || !m_innerEquals(that)) {
            return false
        }

        /* [BUG] TODO, save values by ordered-map */
        let thisIter = this.values.iterator()
        let thatIter = that.values.iterator()

        let fd = { tag: Tag => descriptor_.findFieldByTag(tag).getOrThrow() }

        while (match ((thisIter.next(), thatIter.next())) {
            case (None, None) => return true
            case (Some(a), Some(b)) => 
                a[0] == b[0] &&
                match ((a[1], b[1])) {
                    case (ra: Repeated, rb: Repeated) => ra.size == rb.size && equalsTo(fd(a[0]), ra, rb)
                    case _ => equalsTo(a[1], b[1])
                }
            case _ => false
        }) { }

        return false
    }

    public static func empty(): DynamicMessage { throw ConstructionException("dynamic message no static construction") }
    public static func fromBytes(_: Collection<Byte>): DynamicMessage { throw ConstructionException("dynamic message no static construction") }
    public static func fromBytes(_: BytesReader): DynamicMessage { throw ConstructionException("dynamic message no static construction") }
}