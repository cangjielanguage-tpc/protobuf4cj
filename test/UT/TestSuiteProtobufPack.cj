// 3rd_party_lib:protobuf-cj/ci_lib
// 3rd_party_lib:protobuf-cj/ci_lib/protobuf
// 3rd_party_lib:protobuf-cj/ci_lib/proto

package test.protobuf

from std import unittest.*
from std import unittest.testmacro.*

from std import collection.*
from std import io.*

from proto import grouptest.* //导入proto文件生成的cjo文件
from protobuf import protobuf.*

@Test
public class TestSuiteProtobufPack {
    var schoolStream = Array<UInt8>()
	var schoolData = School()
    var writer = SimpleWriter([])

    public override func beforeAll(): Unit {
        setData()

        schoolStream = schoolData.pack()
        writer = SimpleWriter(schoolData.size)
    }

    public override func afterAll(): Unit {
        checkData()
    }

    @Bench[10000]
    @TestCase
	func testPackT1000(): Unit {
        // 清空writer后向它打包
        writer.clear()
        schoolData.pack(writer)
    }

    func setData() {
		// 组装school对象
		var classMap = schoolData.className
		classMap.put(1, "一年级")
		classMap.put(2, "二年级")
		classMap.put(3, "三年级")

		var t01 = Person_Teacher()
		t01.name = "t01"
		t01.age = 30
		t01.gender = Person_Gender.MAN
		t01.subject = Person_Subject.LANGUAGE
		schoolData.teacherArray.append(t01)

		var t02 = Person_Teacher()
		t02.name = "t02"
		t02.age = 25
		t02.gender = Person_Gender.FEMALE
		t02.subject = Person_Subject.HISTORY
		schoolData.teacherArray.append(t02)

		var s01 = Person_Student()
		s01.name = "s01"
		s01.age = 15
		s01.gender = Person_Gender.MAN

		schoolData.studentArray.append(s01)

		var s02 = Person_Student()
		s02.name = "s02"
		s02.age = 16
		s02.gender = Person_Gender.FEMALE

		schoolData.studentArray.append(s02)

		schoolData.id = "id"
	}

    func checkData(): Unit {
        var schoolUnpack = School()
		schoolUnpack.unpack(schoolStream)
        //验证oneof的name
        if (!(schoolUnpack.id == "id")) {
            println("schoolUnpack.id================error:${schoolUnpack.id} != id")
        }
		if (!(schoolUnpack.teacherArray.size == 2)) {
            println("schoolUnpack.teacherArray.size================error:${schoolUnpack.teacherArray.size} != 2")
        }

		var teacher01 = schoolUnpack.teacherArray[0]
        if (!(teacher01.name == "t01")) {
            println("teacher01.name================error:${teacher01.name} != t01")
        }
        if (!(teacher01.age == 30)) {
            println("teacher01.age================error:${teacher01.age} != 30")
        }
        if (!(teacher01.gender == Person_Gender.MAN)) {
            println("teacher01.gender================error:${teacher01.gender} != ${Person_Gender.MAN}")
        }
        if (!(teacher01.subject == Person_Subject.LANGUAGE)) {
            println("teacher01.subject================error:${teacher01.subject} != ${Person_Subject.LANGUAGE}")
        }

		var teacher02 = schoolUnpack.teacherArray[1]
        if (!(teacher02.name == "t02")) {
            println("teacher02.name================error:${teacher02.name} != t02")
        }
        if (!(teacher02.age == 25)) {
            println("teacher02.age================error:${teacher02.age} != 25")
        }
        if (!(teacher02.gender == Person_Gender.FEMALE)) {
            println("teacher02.gender================error:${teacher02.gender} != ${Person_Gender.FEMALE}")
        }
        if (!(teacher02.subject == Person_Subject.HISTORY)) {
            println("teacher02.subject================error:${teacher02.subject} != ${Person_Subject.HISTORY}")
        }

		// 验证studentArray
        if (!(schoolUnpack.studentArray.size == 2)) {
            println("schoolUnpack.studentArray.size================error:${schoolUnpack.studentArray.size} != 2")
        }

		var student01 = schoolUnpack.studentArray[0]

        if (!(student01.name == "s01")) {
            println("student01.name================error:${student01.name} != s01")
        }

        if (!(student01.age == 15)) {
            println("student01.age================error:${student01.age} != 15")
        }

        if (!(student01.gender == Person_Gender.MAN)) {
            println("student01.gender================error:${student01.gender} != ${Person_Gender.MAN}")
        }

		for (i in student01.records) {
			if (i.subject == Person_Subject.LANGUAGE) {
                if (!(i.score == 60)) {
                    println("i.score================error:${i.score} != 60")
                }
			}else if (i.subject == Person_Subject.HISTORY) {
                if (!(i.score == 80)) {
                    println("i.score================error:${i.score} != 80")
                }
			}else {
				println("未知的subject值")
			}
		}

		var student02 = schoolUnpack.studentArray[1]
        if (!(student02.name == "s02")) {
            println("student02.name================error:${student02.name} != s02")
        }
        if (!(student02.age == 16)) {
            println("student02.age================error:${student02.age} != 16")
        }
        if (!(student02.gender == Person_Gender.FEMALE)) {
            println("student02.gender================error:${student02.gender} != ${Person_Gender.FEMALE}")
        }

		for (i in student02.records) {
			if (i.subject == Person_Subject.LANGUAGE) {
				if (!(i.score == 80)) {
                    println("i.score================error:${i.score} != 80")
                }
			}else if (i.subject == Person_Subject.HISTORY) {
				if (!(i.score == 90)) {
                    println("i.score================error:${i.score} != 90")
                }
			}else {
				println("未知的subject值")
			}
		}

		// 验证classMap
		var classMap = schoolUnpack.className
        if (!(classMap[1] == "一年级")) {
            println("classMap[1]================error:${classMap[1]} != 一年级")
        }
        if (!(classMap[2] == "二年级")) {
            println("classMap[2]================error:${classMap[2]} != 二年级")
        }
        if (!(classMap[3] == "三年级")) {
            println("classMap[3]================error:${classMap[3]} != 三年级")
        }

		for ((k, v) in schoolUnpack.className) {
			//println("key: ${k}, value: ${v}")
		}
    }
}