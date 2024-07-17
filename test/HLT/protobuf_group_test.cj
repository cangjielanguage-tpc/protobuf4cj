// 3rd_party_lib:protobuf-cj/output
// 3rd_party_lib:protobuf-cj/output/protobuf
// dependence: grouptest/protobuf_group.pb.cj

package grouptest

from std import io.*

@Test
public class ProtoBufGroupTest {
	
	// oneof验证
	@TestCase
	func test_oneof01(): Unit {
		var schoolData = School.empty()	
		
		//3个都设置，验证是否最后赋值成功，其他是否可获取
		schoolData.id = "id"
		schoolData.number = "number"
		schoolData.nikename = "nikename"
		
		var schoolPack = SimpleWriter(schoolData.size)
		schoolPack.clear()
		schoolData.pack(schoolPack)
		var packData = schoolPack.data

		var schoolUnpack = School.empty()
		schoolUnpack.unpack(packData)

		@Assert(schoolUnpack.nikename, "nikename")
   
		var isException = false
		try {
		  var id = schoolUnpack.id
		  @Assert(id, "id")
		} catch(e:Exception) {
		  isException = true
		}
		@Assert(isException, true)
		isException = false
		
		try {
		  var number = schoolUnpack.number
		  @Assert(number, "number")
		} catch(e:Exception) {
		  isException = true
		}
		@Assert(isException, true)
	}
	
	// oneof验证
	@TestCase
	func test_oneof02(): Unit {
		var schoolData = School.empty()	
		// 只设置1个，验证是否成功，其他是否可获取
		schoolData.id = "id"
		
		var schoolPack = SimpleWriter(schoolData.size)
		schoolPack.clear()
		schoolData.pack(schoolPack)
		var packData = schoolPack.data

		var schoolUnpack = School.empty()
		schoolUnpack.unpack(packData)
		
		@Assert(schoolUnpack.id, "id")
		
		var isException = false
		try {
		  var nikename = schoolUnpack.nikename
		  @Assert(nikename, "nikename")
		} catch(e:Exception) {
		  isException = true
		}
		@Assert(isException, true)
		isException = false
		
		try {
		  var number = schoolUnpack.number
		  @Assert(number, "number")
		} catch(e:Exception) {
		  isException = true
		}
		@Assert(isException, true)
	}
	
	@TestCase
	func test_group(): Unit {
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
		@Assert(schoolUnpack.id, "id")
		
		// 验证teacherArray
		@Assert(schoolUnpack.teacherArray.size, 2)
		
		var teacher01 = schoolUnpack.teacherArray[0]
		@Assert(teacher01.name, "t01")
		@Assert(teacher01.age, 30)
		@Assert(teacher01.gender, Person_Gender.MAN)
		@Assert(teacher01.subject, Person_Subject.LANGUAGE)
		
		var teacher02 = schoolUnpack.teacherArray[1]
		@Assert(teacher02.name, "t02")
		@Assert(teacher02.age, 25)
		@Assert(teacher02.gender, Person_Gender.FEMALE)
		@Assert(teacher02.subject, Person_Subject.HISTORY)
				
		// 验证studentArray
		@Assert(schoolUnpack.studentArray.size, 2)
		var student01 = schoolUnpack.studentArray[0]
		@Assert(student01.name, "s01")
		@Assert(student01.age, 15)
		@Assert(student01.gender, Person_Gender.MAN)
		
		for (i in student01.records) {
			if (i.subject == Person_Subject.LANGUAGE) {
				@Assert(i.score, 60)
			}else if (i.subject == Person_Subject.HISTORY) {
				@Assert(i.score, 80)
			}else {
				@Assert("未知的subject值", "")
			}
		}
		
		var student02 = schoolUnpack.studentArray[1]
		@Assert(student02.name, "s02")
		@Assert(student02.age, 16)
		@Assert(student02.gender, Person_Gender.FEMALE)
		
		for (i in student02.records) {
			if (i.subject == Person_Subject.LANGUAGE) {
				@Assert(i.score, 80)
			}else if (i.subject == Person_Subject.HISTORY) {
				@Assert(i.score, 90)
			}else {
				@Assert("未知的subject值", "")
			}
		}
		
	}
	
	func setData(): School {
		var schoolData = School.empty()
		// 组装school对象

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
		
		println("setData done")
		return schoolData
	}

}
