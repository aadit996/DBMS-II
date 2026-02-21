--Part – A 
--1. Create a cursor Course_Cursor to fetch all rows from COURSE table and display them. 

DECLARE @CourseID VARCHAR(10),  
@CourseName VARCHAR(100),  
@CourseCredits INT, 
@CourseDepartment VARCHAR(50), 
@CourseSemester INT

DECLARE Course_Cursor CURSOR
FOR SELECT * FROM COURSE

OPEN Course_Cursor

FETCH NEXT FROM Course_Cursor INTO @CourseID,@CourseName,@CourseCredits,@CourseDepartment,@CourseSemester

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT CONCAT_WS(' ',@CourseID,@CourseName,@CourseCredits,@CourseDepartment,@CourseSemester)				-- IN concat no need to type case (by default converted into string)
  FETCH NEXT FROM Course_Cursor INTO @CourseID,@CourseName,@CourseCredits,@CourseDepartment,@CourseSemester
END

 CLOSE 	Course_Cursor

 DEALLOCATE Course_Cursor

 -- Msg 16915, Level 16, State 1, Line 11
--A cursor with the name 'Course_Cursor' already exists.
--if both deallocate and close remove

--2. Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example: --1_Raj Patel). 

DECLARE @StudentID INT,@StuName VARCHAR(100) 

DECLARE Student_Cursor_Fetch CURSOR
FOR SELECT STUDENT.StudentID,STUDENT.StuName FROM STUDENT

OPEN Student_Cursor_Fetch

FETCH NEXT FROM Student_Cursor_Fetch INTO @StudentID,@StuName

WHILE @@FETCH_STATUS = 0
BEGIN
      PRINT CONCAT_WS('_',@StudentID,@StuName)
      FETCH NEXT FROM Student_Cursor_Fetch INTO @StudentID,@StuName
END

CLOSE Student_Cursor_Fetch
DEALLOCATE Student_Cursor_Fetch



--3. Create a cursor to find and display all courses with Credits greater than 3. 

DECLARE @CourseNameQ3 VARCHAR(100),@CourseCreditsQ3 INT 

DECLARE COURSE_W_CREDITS CURSOR
FOR SELECT COURSE.CourseName,COURSE.CourseCredits
            FROM COURSE
            WHERE COURSE.CourseCredits>3

OPEN COURSE_W_CREDITS

FETCH NEXT FROM COURSE_W_CREDITS INTO @CourseNameQ3,@CourseCreditsQ3

WHILE @@FETCH_STATUS = 0
BEGIN
     PRINT CONCAT_WS(' ',@CourseNameQ3,@CourseCreditsQ3)
     FETCH NEXT FROM COURSE_W_CREDITS INTO  @CourseNameQ3,@CourseCreditsQ3
END

CLOSE COURSE_W_CREDITS

DEALLOCATE COURSE_W_CREDITS

--4. Create a cursor to display all students who enrolled in year 2021 or later. 

DECLARE @StuNameQ4 VARCHAR(100),@StuEnrollmentYearQ4 INT 

DECLARE STU_AFTER_2021 CURSOR
FOR SELECT STUDENT.StuName,STUDENT.StuEnrollmentYear
FROM STUDENT
WHERE STUDENT.StuEnrollmentYear>=2021

OPEN STU_AFTER_2021

FETCH NEXT FROM STU_AFTER_2021 INTO @StuNameQ4,@StuEnrollmentYearQ4 

WHILE @@FETCH_STATUS=0
BEGIN
 PRINT CONCAT_WS(' ',@StuNameQ4,@StuEnrollmentYearQ4)
 FETCH NEXT FROM STU_AFTER_2021 INTO @StuNameQ4,@StuEnrollmentYearQ4 
END

CLOSE STU_AFTER_2021
DEALLOCATE STU_AFTER_2021

--5. Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses 
--with Credits less than 4. 

DECLARE @CourseIDQ5 VARCHAR(10),@CourseCreditsQ5 INT 

DECLARE Course_CursorUpdate CURSOR
FOR SELECT COURSE.CourseID,COURSE.CourseCredits
           FROM COURSE
           WHERE COURSE.CourseCredits<4

OPEN Course_CursorUpdate

FETCH NEXT FROM Course_CursorUpdate INTO @CourseIDQ5,@CourseCreditsQ5 

WHILE @@FETCH_STATUS = 0
BEGIN
     UPDATE COURSE
     SET COURSE.CourseCredits = COURSE.CourseCredits + 1
     WHERE COURSE.CourseID =  @CourseIDQ5
     
     PRINT CONCAT_WS(' ',@CourseIDQ5,@CourseCreditsQ5)

     FETCH NEXT FROM Course_CursorUpdate INTO @CourseIDQ5,@CourseCreditsQ5 

END

SELECT * FROM COURSE

--6. Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database 
--Management System) 

DECLARE @StuNameQ6 VARCHAR(100),@CourseNameQ6 VARCHAR(100)  

DECLARE STU_WITH_CNAME CURSOR
FOR SELECT STUDENT.StuName,COURSE.CourseName
           FROM STUDENT
           JOIN ENROLLMENT
           ON STUDENT.StudentID = ENROLLMENT.StudentID
           JOIN COURSE
           ON COURSE.CourseID=ENROLLMENT.CourseID

OPEN STU_WITH_CNAME

FETCH NEXT FROM STU_WITH_CNAME INTO @StuNameQ6,@CourseNameQ6   

WHILE @@FETCH_STATUS = 0
BEGIN
     PRINT  @StuNameQ6+' is enrolled in ' +@CourseNameQ6
     FETCH NEXT FROM STU_WITH_CNAME INTO @StuNameQ6,@CourseNameQ6 
END

CLOSE STU_WITH_CNAME
DEALLOCATE STU_WITH_CNAME 

--7. Create a cursor to insert data into new table if student belong to ‘CSE’ department. (create new table 
--CSEStudent with relevant columns) 

CREATE TABLE CSEStudent(
             StuName VARCHAR(100),
             StuDepartment VARCHAR(50)
)

DECLARE @StuNameQ7 VARCHAR(100),@StuDepartmentQ7 VARCHAR(50)

DECLARE INS_DATA_IN_TBL CURSOR
FOR  SELECT STUDENT.StuName,STUDENT.StuDepartment
            FROM STUDENT
            WHERE STUDENT.StuDepartment = 'CSE'

OPEN INS_DATA_IN_TBL

FETCH NEXT FROM INS_DATA_IN_TBL INTO @StuNameQ7,@StuDepartmentQ7

WHILE @@FETCH_STATUS = 0
BEGIN
     INSERT INTO CSEStudent VALUES (@StuNameQ7,@StuDepartmentQ7)
     FETCH NEXT FROM INS_DATA_IN_TBL INTO @StuNameQ7,@StuDepartmentQ7
END

CLOSE INS_DATA_IN_TBL
DEALLOCATE INS_DATA_IN_TBL

SELECT * FROM CSEStudent

--Part – B 
--8. Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed' 

DECLARE @ENROLLMENTIDQ8 INT

DECLARE UPD_NULL_GRADE CURSOR
FOR SELECT ENROLLMENT.EnrollmentID 
           FROM ENROLLMENT 
           WHERE ENROLLMENT.EnrollmentStatus = 'Completed' AND ENROLLMENT.Grade IS NULL

OPEN UPD_NULL_GRADE

FETCH NEXT FROM UPD_NULL_GRADE INTO @ENROLLMENTIDQ8

WHILE @@FETCH_STATUS = 0 
BEGIN
     UPDATE ENROLLMENT
     SET ENROLLMENT.Grade = 'F'
     WHERE ENROLLMENT.EnrollmentID = @ENROLLMENTIDQ8
     FETCH NEXT FROM UPD_NULL_GRADE INTO @ENROLLMENTIDQ8

END

CLOSE UPD_NULL_GRADE
DEALLOCATE UPD_NULL_GRADE

SELECT * FROM ENROLLMENT

--9. Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure) 

DECLARE @FACULTYNAMEQ9 VARCHAR(100),@COURSENAMEQ9 VARCHAR(100)

DECLARE FAC_WITH_COURSE CURSOR
FOR SELECT FACULTY.FacultyName,COURSE.CourseName
           FROM FACULTY
           JOIN COURSE_ASSIGNMENT
           ON FACULTY.FacultyID = COURSE_ASSIGNMENT.FacultyID
           JOIN COURSE
           ON COURSE.CourseID = COURSE_ASSIGNMENT.CourseID


OPEN FAC_WITH_COURSE 

FETCH NEXT FROM FAC_WITH_COURSE INTO @FACULTYNAMEQ9,@COURSENAMEQ9 

WHILE @@FETCH_STATUS = 0
BEGIN 
    PRINT   @FACULTYNAMEQ9+' teaches '+@COURSENAMEQ9
    FETCH NEXT FROM FAC_WITH_COURSE INTO @FACULTYNAMEQ9,@COURSENAMEQ9 

END

CLOSE FAC_WITH_COURSE
DEALLOCATE FAC_WITH_COURSE

--Part – C 
--10. Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15) 

DECLARE @STUDENTIDQ10 INT,@STUNAMEQ10 VARCHAR(100),@CREDITSSUM INT

DECLARE STU_TOT_CRED CURSOR
FOR  SELECT STUDENT.StudentID,STUDENT.StuName,SUM(COURSE.CourseCredits) 
     FROM STUDENT
     JOIN ENROLLMENT
     ON STUDENT.StudentID = ENROLLMENT.StudentID
     JOIN COURSE
     ON COURSE.CourseID = ENROLLMENT.CourseID
     GROUP BY STUDENT.StudentID,STUDENT.StuName


OPEN  STU_TOT_CRED  

FETCH NEXT FROM STU_TOT_CRED INTO @STUDENTIDQ10,@STUNAMEQ10,@CREDITSSUM

WHILE @@FETCH_STATUS = 0
BEGIN
           PRINT  @STUNAMEQ10+' has total credits = '+CAST(@CREDITSSUM AS VARCHAR)
           FETCH NEXT FROM STU_TOT_CRED INTO @STUDENTIDQ10,@STUNAMEQ10,@CREDITSSUM

END

CLOSE STU_TOT_CRED
DEALLOCATE STU_TOT_CRED