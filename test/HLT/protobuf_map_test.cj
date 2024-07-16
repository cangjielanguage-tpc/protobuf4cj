// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: maptest/protobuf_map.pb.cj

package maptest

from std import io.*

@Test
public class ProtoBufMapTest {

	@TestCase
	func test_map(): Unit {
		var schoolData = School.empty()
		// 添加数据
		schoolData = setData()
		// 打包成二进制
		var schoolPack = SimpleWriter(schoolData.size)
		schoolPack.clear()
		schoolData.pack(schoolPack)
		var packData = schoolPack.data
		
		// 解析
		var schoolUnpack = School.empty()
		schoolUnpack.unpack(packData) 

		//验证oneof的name
		@Assert(schoolUnpack.name, "name")
		
		// 验证teacherMap
		for ((k, v) in schoolUnpack.teacherids) {
			// k=String, v=Person_Teacher
			if (k == "num1") {
				@Assert(v.name, "t01")
				@Assert(v.age, 30)
				@Assert(v.gender, Person_Gender.MAN)
				@Assert(v.subject, Person_Subject.LANGUAGE)
			} else if (k == "num2") {
				@Assert(v.name, "t02")
				@Assert(v.age, 25)
				@Assert(v.gender, Person_Gender.FEMALE)
				@Assert(v.subject, Person_Subject.HISTORY)
			} else {
				@Assert("位置的key值", "")
			}
		}
		// 验证studentMap
		for ((k, v) in schoolUnpack.studentids) {
			// k=String, v=Person_Student
			if (k == 1) {
				@Assert(v.name, "s01")
				@Assert(v.age, 15)
				@Assert(v.gender, Person_Gender.MAN)
				
				for (i in v.records) {
					if (i.subject == Person_Subject.LANGUAGE) {
						@Assert(i.score, 60)
					}else if (i.subject == Person_Subject.HISTORY) {
						@Assert(i.score, 80)
					}else {
						@Assert("未知的subject值", "")
					}
				}
			} else if (k == 2) {
				@Assert(v.name, "s02")
				@Assert(v.age, 16)
				@Assert(v.gender, Person_Gender.FEMALE)
				
				for (i in v.records) {
					if (i.subject == Person_Subject.LANGUAGE) {
						@Assert(i.score, 80)
					}else if (i.subject == Person_Subject.HISTORY) {
						@Assert(i.score, 90)
					}else {
						@Assert("未知的subject值", "")
					}
				}
			} else {
				@Assert("未知的key值", "")
			}
		}
		// 验证ids
		for ((k, v) in schoolUnpack.ids) {
			// k=int, v=String
			match(k) {
				case 1 => @Assert(v, "a")
				case 2 => @Assert(v, "b")
				case 3 => @Assert(v, "c")
				case _ => @Assert(false)
			}
		}
	}

	func setData(): School {
		var schoolData = School.empty()
		// 组装school对象
		var teacherMap = MapMessage<String, Person_Teacher>()
		
		var t01 = Person_Teacher()
		t01.name = "t01"
		t01.age = 30
		t01.gender = Person_Gender.MAN
		t01.subject = Person_Subject.LANGUAGE
		teacherMap.put("num1", t01)
		
		var t02 = Person_Teacher()
		t02.name = "t02"
		t02.age = 25
		t02.gender = Person_Gender.FEMALE
		t02.subject = Person_Subject.HISTORY
		teacherMap.put("num2", t02)
		
		schoolData.teacherids.putAll(teacherMap)
		
		var studentMap = MapMessage<Int32, Person_Student>()
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

		studentMap.put(1,s01)
		studentMap.put(2,s02)
		
		schoolData.studentids.putAll(studentMap)
		
		var ids = MapField<Int32, String>()
		ids.put(1, "a")
		ids.put(2, "b")
		ids.put(3, "c")
		schoolData.ids.putAll(ids)

		schoolData.name = "name"
		
		println("setData done")
		return schoolData
	}
}