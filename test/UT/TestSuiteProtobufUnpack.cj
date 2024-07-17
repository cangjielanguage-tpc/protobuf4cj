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
public class TestSuiteProtobufUnpack {
    var schoolStream = Array<Byte>()
	var roArray = RoArray<Byte>()

	var schoolData = School()
    var schoolUnpack = School()

    public override func beforeAll(): Unit {
	    setData()

		schoolStream = schoolData.pack()
		roArray = RoArray(schoolStream)
    }

    public override func afterAll(): Unit {
    }

    @Bench[10000]
    @TestCase
	func testUnpackT10000(): Unit {
		// 清空消息后从data解包
		schoolUnpack.clear()
		schoolUnpack.unpack(schoolStream)
    }

	@Bench[10000]
    @TestCase
	func testUnpack_From_ReadOnly_Array(): Unit {
		// 清空消息后从data解包
		schoolUnpack.clear()
		schoolUnpack.unpack(roArray)
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
		var record01 = Person_Student_TestRecord()
		record01.subject = Person_Subject.LANGUAGE
		record01.score = 60
		var record02 = Person_Student_TestRecord()
		record02.subject = Person_Subject.HISTORY
		record02.score = 80
		s01.records.append(record01)
		s01.records.append(record02)
		schoolData.studentArray.append(s01)

		var s02 = Person_Student()
		s02.name = "s02"
		s02.age = 16
		s02.gender = Person_Gender.FEMALE
		var record03 = Person_Student_TestRecord()
		record03.subject = Person_Subject.LANGUAGE
		record03.score = 80
		var record04 = Person_Student_TestRecord()
		record04.subject = Person_Subject.HISTORY
		record04.score = 90
		s02.records.append(record03)
		s02.records.append(record04)
		schoolData.studentArray.append(s02)

		schoolData.id = "id"
	}
}