package example

from protobuf import reflection.*

main() {
    let clz = Class(
        person: [
            (100, Person(id: 100, name: "xiao1", email: "xiao123.email.com")),
            (200, Person(id: 200, name: "xiao2", gender: Male, hobby: [Study]))
        ], teacher: [
            Person(id: 301, name: "laoji", hobby: [Game])
        ]
    )

    println(clz)

    /* reflection of class */
    let clz_ref = clz.getReflection()
    /* descriptor of class */
    let clz_desc = clz.getDescriptor()
    println(clz_desc)

    /* teacher (arraylist) field descriptor */
    let teacher_list = clz_desc.findFieldByName("teacher").getOrThrow()
    println(teacher_list)

    /* get teacher[0] */
    let teacher_0 = clz_ref.getMessage(teacher_list, 0)
    println(teacher_0)

    /* reflection of teacher[0] */
    let teacher_0_ref = teacher_0.getReflection()
    /* get id of teacher[0] */
    let teacher_0_id = teacher_0_ref.getInt32(teacher_0.getDescriptor().findFieldByName("id").getOrThrow())

    /* person (map) field descriptor */
    let person_map = clz_desc.findFieldByName("person").getOrThrow()
    println(person_map)

    /* put teacher[0] to person map */
    clz_ref.putMessage(person_map, teacher_0_id, teacher_0)

    println("================= result: =================:")
    println(clz)
}