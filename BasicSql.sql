/* I. CREATE TABLES */

-- faculty (Khoa trong trường)
create table faculty (
	id numeric primary key,
	name nvarchar(30) not null
);


-- subject (Môn học)
create table subject(
	id numeric primary key,
	name nvarchar(100) not null,
	lesson_quantity numeric(2,0) not null -- tổng số tiết học
);

-- student (Sinh viên)
create table student (
	id numeric primary key,
	name nvarchar(30) not null,
	gender nvarchar(10) not null, -- giới tính
	birthday date not null,
	hometown nvarchar(100) not null, -- quê quán
	scholarship numeric, -- học bổng
	faculty_id numeric not null constraint faculty_id references faculty(id) -- mã khoa
);

-- exam management (Bảng điểm)
create table exam_management(
	id numeric primary key,
	student_id numeric not null constraint student_id references student(id),
	subject_id numeric not null constraint subject_id references subject(id),
	number_of_exam_taking numeric not null, -- số lần thi (thi trên 1 lần được gọi là thi lại) 
	mark numeric(4,2) not null -- điểm
);

/*================================================*/

/* II. INSERT SAMPLE DATA */

-- subject
insert into subject (id, name, lesson_quantity) values (1, N'Cơ sở dữ liệu', 45);
insert into subject values (2, N'Trí tuệ nhân tạo', 45);
insert into subject values (3, N'Truyền tin', 45);
insert into subject values (4, N'Đồ họa', 60);
insert into subject values (5, N'Văn phạm', 45);


-- faculty
insert into faculty values (1, N'Anh - Văn');
insert into faculty values (2, N'Tin học');
insert into faculty values (3, N'Triết học');
insert into faculty values (4, N'Vật lý');



-- student
insert into student values (1, N'Nguyễn Thị Hải', N'Nữ', '1990/02/23', N'Hà Nội', 130000, 2);
insert into student values (2, N'Trần Văn Chính', N'Nam', '1992/12/24', N'Bình Định', 150000, 4);
insert into student values (3, N'Lê Thu Yến', N'Nữ', '1990/02/21',  N'TP HCM', 150000, 2);
insert into student values (4, N'Lê Hải Yến', N'Nữ', '1990/02/21',  N'TP HCM', 170000, 2);
insert into student values (5, N'Trần Anh Tuấn', N'Nam', '1990/12/20',  N'Hà Nội', 180000, 1);
insert into student values (6, N'Trần Thanh Mai', N'Nữ', '1991/08/12',  N'Hải Phòng', null, 3);
insert into student values (7, N'Trần Thị Thu Thủy', N'Nữ', '1991/01/02', N'Hải Phòng', 10000, 1);



-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 2, 2, 6);
insert into exam_management values (3, 1, 3, 1, 5);
insert into exam_management values (4, 2, 1, 1, 4.5);
insert into exam_management values (5, 2, 3, 1, 10);
insert into exam_management values (6, 2, 5, 1, 9);
insert into exam_management values (7, 3, 1, 2, 5);
insert into exam_management values (8, 3, 3, 1, 2.5);
insert into exam_management values (9, 4, 5, 2, 10);
insert into exam_management values (10, 5, 1, 1, 7);
insert into exam_management values (11, 5, 3, 1, 2.5);
insert into exam_management values (12, 6, 2, 1, 6);
insert into exam_management values (13, 6, 4, 1, 10);



/*================================================*/

/* III. QUERY */


 /********* A. BASIC QUERY *********/

-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần	
			Select * from student
			order by id ASC
--      b. giới tính
			Select * from student
			order by gender
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
			Select * from student
			order by birthday ASC, scholarship DESC

-- 2. Môn học có tên bắt đầu bằng chữ 'T'
			Select * from subject
			where name LIKE 'T%'

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
			Select * from student
			where name LIKE '%i'

-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
			Select * from faculty
			where name LIKE '_n%'

-- 5. Sinh viên trong tên có từ 'Thị'
			Select * from student
			where name LIKE N'%Thị%'

-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
			Select * from student
			where name LIKE '[a-m]%'
			order by name

-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
			Select * from student
			where scholarship > 100000
			order by faculty_id DESC
			
-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
			Select * from student
			where scholarship > 150000 and hometown = N'Hà Nội'

-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
			Select * from student
			where birthday between '01/01/1991' and '05/06/1992'
-- 10. Những sinh viên có học bổng từ 80000 đến 150000
			Select * from student
			where scholarship between '80000' and '150000'
-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
			Select * from subject
			where lesson_quantity between '30' and '45'


-------------------------------------------------------------------

/********* B. CALCULATION QUERY *********/

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
		Select id,gender,faculty_id,scholarship,IIF(scholarship > 500000 ,N'Học bổng cao',N'Mức trung bình') AS scholarship 
		from student
		
-- 2. Tính tổng số sinh viên của toàn trường
		Select COUNT(*) AS tongSinhVien
		from student

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
		Select COUNT(*) AS tongSinhVienNam,(Select COUNT(*) from student where gender = N'Nữ') AS tongSinhVienNu
		from student
		where gender = N'Nam'

-- 4. Tính tổng số sinh viên từng khoa
		Select faculty.name, COUNT(*) AS tongSVKhoa
		from faculty,student
		where faculty.id = student.faculty_id
		group by faculty.name

-- 5. Tính tổng số sinh viên của từng môn học
		Select subject.name, COUNT(*) AS tongSVMonHoc
		from subject,student,exam_management
		where subject.id = exam_management.subject_id and student.id = exam_management.subject_id
		group by subject.name

-- 6. Tính số lượng môn học mà sinh viên đã học
		Select student.name, count(*) AS tongSoLuongMonHoc
		from subject,student,exam_management
		where subject.id = exam_management.subject_id and student.id= exam_management.student_id
		group by student.name

-- 7. Tổng số học bổng của mỗi khoa	
		Select faculty.name,COUNT(*) AS tongSoHocBongMoiKhoa
		from faculty,student
		where faculty.id = student.faculty_id and student.scholarship > 0
		group by faculty.name

-- 8. Cho biết học bổng cao nhất của mỗi khoa
		Select faculty.name,MAX(student.scholarship)
		from faculty,student
		where faculty.id = student.faculty_id
		group by faculty.name

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
		Select faculty.name AS Khoa,
		COUNT(case when student.gender=N'Nam' Then 1 end) as tongSinhVienNam,
		COUNT(case when student.gender=N'Nữ' Then 1 end) as tongSinhVienNu
		from faculty, student
		where faculty.id = student.faculty_id
		group by faculty.name
		


-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
		Select COUNT(*) AS soLuongSV ,(Year(GETDATE())-YEAR(birthday)) AS tuoi
		from student
		group by (Year(GETDATE())-YEAR(birthday))
		order by tuoi
	

	
-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
		Select hometown AS diaDiem,COUNT(*) AS soLuongSV
		from student
		group by student.hometown
		having COUNT(*) >=2

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
		Select student.name,COUNT(exam_management.number_of_exam_taking) AS soLanThiLaiItNhat2Lan
		from student,exam_management
		where student.id = exam_management.student_id and exam_management.number_of_exam_taking > 1
		group by student.id,student.name
		having COUNT(exam_management.number_of_exam_taking) > 1

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 
		Select student.name,student.gender,AVG(exam_management.mark) AS diemTrungBinh
		from student,exam_management
		where student.id = exam_management.student_id and student.gender = 'Nam' and exam_management.number_of_exam_taking =1 
		group by student.id,student.name,student.gender
		having AVG(exam_management.mark) > 7


-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
		Select student.name, COUNT(*) AS soMonRot
		from student,exam_management
		where student.id= exam_management.student_id and exam_management.number_of_exam_taking = 1 and exam_management.mark <= 4
		group by student.id,student.name
		having COUNT(*) >= 2


-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
		Select faculty.name AS tenKhoa,COUNT(student.gender) as soLuongSinhVienNam
		from faculty,student
		where student.faculty_id = faculty.id and student.gender='Nam'
		group by faculty.name,student.gender
		having COUNT(student.gender) > 2



-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
		Select faculty.name AS tenKhoa, COUNT(student.id) AS soLuongHocSinhDatHocBong
		from faculty,student
		where student.faculty_id = faculty.id and student.scholarship between '200000' and '300000' 
		group by faculty.name
		having COUNT(student.id) > 2
-- 17. Cho biết sinh viên nào có học bổng cao nhất
		Select *
		from student
		where scholarship = (select MAX(scholarship) from student)

-------------------------------------------------------------------

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
		Select * 
		from student
		where hometown = N'Hà Nội' and MONTH(birthday) =2
-- 2. Sinh viên có tuổi lớn hơn 20
		Select * ,(YEAR(GETDATE())-YEAR(birthday)) as tuoi
		from student
		where (YEAR(GETDATE())-YEAR(birthday)) > 20
-- 3. Sinh viên sinh vào mùa xuân năm 1990
		Select *
		from student
		where YEAR(birthday) = 1990 AND MONTH(birthday) < 4



-------------------------------------------------------------------


/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
	Select student.name , faculty.name AS tenKhoa
	from student
	INNER JOIN faculty ON faculty.id = student.faculty_id
	where faculty.name = N'Anh - Văn' or faculty.name = N'Vật lý'

-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
	Select student.name, faculty.name AS tenKhoa
	from student
	INNER JOIN faculty ON faculty.id = student.faculty_id
	where (faculty.name = N'Anh - Văn' or faculty.name = N'Vật lý') and student.gender = N'Nam'
-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
	Select student.name, subject.name AS tenMon, exam_management.mark AS diem
	from student
	INNER JOIN exam_management ON exam_management.student_id = student.id
	INNER JOIN subject ON subject.id = exam_management.subject_id
	where mark = (select max(mark)
	from exam_management
	JOIN subject ON subject.id = exam_management.subject_id
	where exam_management.number_of_exam_taking = 1 and subject.name = N'Cơ sở dữ liệu')


-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
	Select student.name, (YEAR(GETDATE()) - YEAR(birthday)) AS tuoi
	from student
	JOIN faculty ON faculty.id = student.faculty_id
	where faculty.name = N'Anh - Văn' 
	and (YEAR(GETDATE()) - YEAR(birthday)) = (select MAX(YEAR(GETDATE()) - YEAR(birthday)) from student)
	
-- 5. Cho biết khoa nào có đông sinh viên nhất
	Select  faculty.name, COUNT(student.id) as soSinhVien
	from faculty
	JOIN student on faculty.id = student.faculty_id
	group by faculty.name
	having count(student.id) = (
		select max(soSinhVien) 
		from ( select count(student.id) as soSinhVien from faculty 
		JOIN student on faculty.id = student.faculty_id
		group by faculty.id)
		as tongSinhVien)
-- 6. Cho biết khoa nào có đông nữ nhất
	Select faculty.name, COUNT(student.id) as soSinhVien
	from faculty
	JOIN student on faculty.id=student.faculty_id
	where student.gender = N'Nữ'
	group by faculty.name
	having count(student.id) = (select max(soSinhVien)
	from(select COUNT(student.id) as soSinhVien from faculty
	JOIN student on faculty.id = student.faculty_id 
	where student.gender = N'Nữ'
	group by faculty.id)
	as tongSinhVien)
-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
	Select subject.name ,student.name, exam_management.mark AS diem
	from (
		select subject_id,MAX(mark) as max_mark
		from exam_management
		group by subject_id
	) as max_marks
	JOIN exam_management on exam_management.subject_id = max_marks.subject_id AND exam_management.mark = max_marks.max_mark
	JOIN student on student.id = exam_management.student_id
	JOIN subject on subject.id = exam_management.subject_id

-- 8. Cho biết những khoa không có sinh viên học
	Select faculty.name as khoaKhongCoSinhVien
	from faculty
	JOIN student ON student.faculty_id = faculty.id
	where student.id is null
-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
	Select student.name as chuaThi
	from student
	LEFT JOIN exam_management ON exam_management.student_id = student.id
	LEFT JOIN subject on subject.id = exam_management.subject_id and subject.name=N'Cơ sở dữ liệu'
	where exam_management.student_id is null
-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
	Select student.name as tenSinhVien 
	from student
	LEFT JOIN exam_management em1 ON student.id = em1.student_id AND em1.number_of_exam_taking = 1
	INNER JOIN exam_management em2 ON student.id = em2.student_id AND em2.number_of_exam_taking = 2
	WHERE em1.student_id IS NULL;