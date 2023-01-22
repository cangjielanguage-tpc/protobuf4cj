package protobuf

class RBTreeNode<E> {
    var left: ?RBTreeNode<E> = None
    var right: ?RBTreeNode<E> = None

    RBTreeNode(
        var data: E,
        var parent!: ?RBTreeNode<E> = None,
        var black!: Bool = false
    ) { }

    init(data: E, left: ?RBTreeNode<E>, right: ?RBTreeNode<E>, black: Bool) {
        this.data = data
        this.left = left
        this.right = right
        this.black = black
        this.parent = None

        left?.parent = this
        right?.parent = this
    }

    func clone(): RBTreeNode<E> {
        RBTreeNode<E>(data, left?.clone(), right?.clone(), black)
    }

    func increment(): ?RBTreeNode<E> {
        if (let Some(right) = this.right) {
            var node = right
            while (match(node.left) {
                case Some(n) => node = n; true
                case _ => false
            }) { }
            return node
        }

        var node = this
        while (match (node.parent) {
            case Some(parent) where nodeEq(node, parent.right) => node = parent; true
            case _ => false
        }) { }

        return node.parent
    }

    func decrement(): ?RBTreeNode<E> {
        if (let Some(left) = this.left) {
            var node = left
            while (match(node.right) {
                case Some(n) => node = n; true
                case _ => false
            }) { }
            return node
        }

        var node = this
        while (match (node.parent) {
            case Some(parent) where nodeEq(node, parent.left) => node = parent; true
            case _ => false
        }) { }

        return node.parent
    }
}

func nodeEq<E>(a: RBTreeNode<E>, b: ?RBTreeNode<E>) {
    if (let Some(n) = b) {
        return refEq(a, n)
    }

    return false
}

func nodeEq<E>(a: ?RBTreeNode<E>, b: ?RBTreeNode<E>) {
    match ((a, b)) {
        case (Some(a_), Some(b_)) => refEq(a_, b_)
        case (None, None) => true
        case _ => false
    }
}

type TreeMapNode<K, V> = RBTreeNode<(K, V)>

public class TreeMapIterator<K, V> <: Iterator<(K, V)> {
    TreeMapIterator(
        private var node_: ?TreeMapNode<K, V>,
        private var reversed_: Bool
    ) { }

    init(node: ?TreeMapNode<K, V>) {
        node_ = node
        reversed_ = false
    }

    public prop let reversed: Bool { get() { reversed_ } }

    public func reverse() {
        reversed_ = !reversed_
        return this
    }

    public func iterator() {
        return this
    }

    public func next(): ?(K, V) {
        if (let Some(node) = node_) {
            let data = node.data
            node_ = if (reversed_) { node.decrement() } else { node.increment() }
            return data
        }

        return None
    }
}

extend TreeMapIterator<K, V> <: ToString where K <: ToString, V <: ToString {
    public func toString() {
        let buff = StringBuilder("[")
        var sep = false
        for ((k, v) in this) {
            if (sep) { buff.append(", ") } else { sep = true }
            buff.append("(${k}, ${v})")
        }
        buff.append("]").toString()
    }
}

public class TreeMapKeysIterator<K, V> <: Iterator<K> {
    public TreeMapKeysIterator(
        private let iter: TreeMapIterator<K, V>
    ) { }

    public func iterator() { this }

    public func next() { iter.next()?[0] }
}

public class TreeMapValuesIterator<K, V> <: Iterator<V> {
    public TreeMapValuesIterator(
        private let iter: TreeMapIterator<K, V>
    ) { }

    public func iterator() { this }

    public func next() { iter.next()?[1] }
}

public class TreeMap<K, V> <: Map<K, V> where K <: Less<K> & Equatable<K> {
    private TreeMap(
        private var root: ?TreeMapNode<K, V>,
        private var size_: Int64
    ) { }

    public init() {
        root = None
        size_ = 0
    }

    public init(elements: Collection<(K, V)>) {
        this()
        putAll(elements)
    }

    public init(elements: Array<(K, V)>) {
        this()

        var i = 0
        while (i < elements.size) {
            if (let Some(node) = insert(elements[i])) {
                node.data = elements[i]
            }
            i++
        }
    }

    public init(map: TreeMap<K, V>) {
        this(map.root?.clone(), map.size_)
    }

    public func isEmpty() {
        size_ == 0
    }

    public prop let size: Int64 { get( ) { size_ } }

    public func clear() {
        root = None
        size_ = 0
    }

    public func clone() {
        TreeMap(root?.clone(), size_)
    }

    public operator func[](key: K) {
        get(key).getOrThrow()
    }

    public func get(key: K): ?V {
        return search(root, key)?.data[1]
    }

    public func contains(key: K): Bool {
        match (search(root, key)) {
            case None => return false
            case _ => return true
        }
    }

    public func containsAll(keys: Collection<K>): Bool {
        for (key in keys) {
            match (search(root, key)) {
                case None => return false
                case _ => continue
            }
        }

        return true
    }

    public func put(key: K, val: V): ?V {
        if (let Some(node) = insert((key, val))) {
            let old = node.data[1]
            node.data = (key, val)
            return old
        }
        return None
    }

    public func putAll(elements: Collection<(K, V)>): Unit {
        for (ele in elements) {
            if (let Some(node) = insert(ele)) {
                node.data = ele
            }
        }
    }

    public operator func[](key: K, value!: V): Unit {
        if (let Some(node) = insert((key, value))) {
            node.data = (key, value)
        }
    }

    /* insert data to rb-tree, return the node if the key of data exists */
    private func insert(data: (K, V)): ?TreeMapNode<K, V> {
        if (size_ == 0) {
            /* empty tree */
            root = TreeMapNode(data, black: true)
            size_ = 1
            return None
        }

        var parent = root.getOrThrow()
        while (true) {
            if (parent.data[0] == data[0]) {
                /* node exists */
                return parent
            }

            if (let Some(node) = if (parent.data[0] < data[0]) { parent.right } else { parent.left }) {
                /* find the next */
                parent = node
            } else {
                /* found */
                break
            }
        }

        /* link to parent */
        let cur = TreeMapNode(data, parent: parent)
        if (parent.data[0] < data[0]) {
            parent.right = cur
        } else {
            parent.left = cur
        }

        if (parent.black == false) {
            /* fix up rb-tree color and structure */
            insertFixUp(cur)
        }

        size_++
        return None
    }

    private func leftRotate(x: TreeMapNode<K, V>): Unit {
        let y = x.right.getOrThrow()

        x.right = y.left
        if (let Some(left) = y.left) {
            left.parent = x
        }

        y.parent = x.parent
        if (let Some(parent) = x.parent) {
            if (nodeEq(x, parent.left)) {
                parent.left = y
            } else {
                parent.right = y
            }
        } else {
            root = y
        }

        y.left = x
        x.parent = y
    }

    private func rightRotate(y: TreeMapNode<K, V>): Unit {
        let x = y.left.getOrThrow()

        y.left = x.right
        if (let Some(right) = x.right) {
            right.parent = y
        }

        x.parent = y.parent
        if (let Some(parent) = y.parent) {
            if (nodeEq(y, parent.right)) {
                parent.right = x
            } else {
                parent.left = x
            }
        } else {
            root = x
        }

        x.right = y
        y.parent = x
    }

    private func insertFixUp(cur: TreeMapNode<K, V>): Unit {
        var node = cur
        var parent = node.parent.getOrThrow()

        do {
            var grandParent = parent.parent.getOrThrow()

            if (nodeEq(parent, grandParent.left)) {
                if (let Some(uncle) = grandParent.right) {
                    if (uncle.black == false) {
                        uncle.black = true
                        parent.black = true
                        grandParent.black = false
                        node = grandParent
                        continue
                    }
                }

                if (nodeEq(node, parent.right)) {
                    leftRotate(parent)
                    let tmp = parent
                    parent = node
                    node = tmp
                }

                parent.black = true
                grandParent.black = false
                rightRotate(grandParent)
            } else {
                if (let Some(uncle) = grandParent.left) {
                    if (uncle.black == false) {
                        uncle.black = true
                        parent.black = true
                        grandParent.black = false
                        node = grandParent
                        continue
                    }
                }

                if (nodeEq(node, parent.left)) {
                    rightRotate(parent)
                    let tmp = parent
                    parent = node
                    node = tmp
                }

                parent.black = true
                grandParent.black = false
                leftRotate(grandParent)
            }
        } while (match (node.parent) {
            case Some(n) => parent = n; parent.black == false
            case _ => false
        })

        root?.black = true
    }

    private static func search(x: ?TreeMapNode<K, V>, key: K): ?TreeMapNode<K, V> {
        if (let Some(node) = x) {
            if (key == node.data[0]) {
                return node
            }

            if (key < node.data[0]) {
                return search(node.left, key)
            }

            return search(node.right, key)
        }

        return None
    }

    public func remove(key: K): ?V {
        if (let Some(node) = search(root, key)) {
            let old = node.data[1]
            remove(node)
            return old
        }
        return None
    }

    public func removeAll(keys: Collection<K>): Unit {
        for (key in keys) {
            if (let Some(node) = search(root, key)) {
                remove(node)
            }
        }
    }

    public func removeIf(predicate: (K, V) -> Bool): Unit {
        if (size_ == 0) {
            return
        }

        var node = root.getOrThrow()
        while (match(node.left) {
            case Some(left) => node = left; true
            case _ => false
        }) {}

        while (true) {
            let next = node.increment()
            if (predicate(node.data[0], node.data[1])) {
                remove(node)
            }
            match (next) {
                case Some(n) => node = n
                case _ => break
            }
        }
    }

    private func remove(node: TreeMapNode<K, V>): Unit {
        if (let (Some(left), Some(right)) = (node.left, node.right)) {
            var replace = right
            while (match (replace.left) {
                case Some(n) => replace = n; true
                case _ => false
            }) { }

            match (node.parent) {
                case Some(parent) => if (nodeEq(node, parent.left)) { parent.left = replace } else { parent.right = replace }
                case _ => root = replace
            }

            var child = replace.right
            var parent = replace.parent.getOrThrow()
            let black = replace.black

            if (nodeEq(node, parent)) {
                parent = replace
            } else {
                child?.parent = parent
                parent.left = child
                replace.right = node.right
                node.right?.parent = replace
            }

            replace.parent = node.parent
            replace.black = node.black
            replace.left = node.left
            node.left?.parent = replace

            if (black) {
                removeFixUp(child, parent)
            }

            size_--
            return
        }

        let child: ?TreeMapNode<K, V> = node.left ?? node.right
        let black = node.black

        child?.parent = node.parent
        match (node.parent) {
            case Some(parent) => if (nodeEq(node, parent.left)) { parent.left = child } else { parent.right = child }
            case _ => root = child
        }

        if (black) {
            removeFixUp(child, node.parent.getOrThrow())
        }

        size_--
    }

    private func removeFixUp(child: ?TreeMapNode<K, V>, np: TreeMapNode<K, V>) {
        var node = child
        var opti: ?TreeMapNode<K, V> = np
        var other: TreeMapNode<K, V>

        while ((node?.black ?? true) && !nodeEq(node, root)) {
            let parent = opti.getOrThrow()
            if (nodeEq(node, parent.left)) {
                other = parent.right.getOrThrow()
                if (other.black == false) {
                    other.black = true
                    parent.black = false
                    leftRotate(parent)
                    other = parent.right.getOrThrow()
                }

                if ((other.left?.black ?? true) && (other.right?.black ?? true)) {
                    other.black = false
                    node = opti
                    opti = parent.parent
                } else {
                    if (other.right?.black ?? true) {
                        other.left?.black = true
                        other.black = false
                        rightRotate(other)
                        other = parent.right.getOrThrow()
                    }

                    other.black = parent.black
                    parent.black = true
                    other.right?.black = true
                    leftRotate(parent)
                    node = root
                    break
                }
            } else {
                other = parent.left.getOrThrow()
                if (other.black == false) {
                    other.black = true
                    parent.black = false
                    rightRotate(parent)
                    other = parent.left.getOrThrow()
                }

                if ((other.left?.black ?? true) && (other.right?.black ?? true)) {
                    other.black = false
                    node = opti
                    opti = parent.parent
                } else {
                    if (other.left?.black ?? true) {
                        other.right?.black = true
                        other.black = false
                        leftRotate(other)
                        other = parent.left.getOrThrow()
                    }

                    other.black = parent.black
                    parent.black = true
                    other.left?.black = true
                    rightRotate(parent)
                    node = root
                    break
                }
            }
        }

        node?.black = true
    }

    /* itearator */
    public func iterator(): TreeMapIterator<K, V> {
        if (size_ == 0) {
            return TreeMapIterator<K, V>(None)
        }

        /* left most node */
        var left = root.getOrThrow()
        while (match(left.left) {
            case Some(node) => left = node; true
            case _ => false
        }) {}
        return TreeMapIterator<K, V>(left)
    }

    /* reversed iterator */
    public func reverse(): TreeMapIterator<K, V> {
        if (size_ == 0) {
            return TreeMapIterator<K, V>(None, true)
        }

        /* right most node */
        var right = root.getOrThrow()
        while (match(right.right) {
            case Some(node) => right = node; true
            case _ => false
        }) {}
        return TreeMapIterator<K, V>(right, true)
    }

    public func keys() {
        TreeMapKeys(this)
    }

    public func values() {
        TreeMapValues(this)
    }
}

extend TreeMap<K, V> <: ToString where K <: ToString, V <: ToString {
    public func toString() {
        return this.iterator().toString()
    }
}

public class TreeMapKeys<K, V> <: Keys<K> where K <: Less<K> & Equatable<K> {
    public TreeMapKeys(
        public let map: TreeMap<K, V>
    ) { }

    public prop let size: Int64 { get() { map.size } }

    public func isEmpty() { map.isEmpty() }

    public func contains(key: K) { map.contains(key) }

    public func containsAll(keys: Collection<K>) { map.containsAll(keys) }

    public func remove(key: K) { match (map.remove(key)) { case None => false case _ => true } }

    public func removeAll(keys: Collection<K>) { map.removeAll(keys) }

    public func removeIf(predicate: (K) -> Bool) { map.removeIf { key, val => predicate(key) } }

    public func clear() { map.clear() }

    public func iterator() { TreeMapKeysIterator(map.iterator()) }

    public func reverse() { TreeMapKeysIterator(map.reverse()) }
}

public class TreeMapValues<K, V> <: Values<V> where K <: Less<K> & Equatable<K> {
    public TreeMapValues(
        public let map: TreeMap<K, V>
    ) { }

    public prop let size: Int64 { get() { map.size } }

    public func isEmpty() { map.isEmpty() }

    public func removeIf(predicate: (V) -> Bool) { map.removeIf { key, val => predicate(val) } }

    public func clear() { map.clear() }

    public func iterator() { TreeMapValuesIterator(map.iterator()) }

    public func reverse() { TreeMapValuesIterator(map.reverse()) }
}