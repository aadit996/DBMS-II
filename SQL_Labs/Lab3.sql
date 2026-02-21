--Advanced Stored Procedure
--Part – A 
--1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.

GO
CREATE OR ALTER PROCEDURE PR_ACCEPTDATE_RETURN_FACULTY_MEMBER
@JOININGDATE DATETIME
AS                              
BEGIN
       SELECT FACULTY.FacultyJoiningDate,FACULTY.FacultyName
       FROM FACULTY
       WHERE FACULTY.FacultyJoiningDate=@JOININGDATE
END
GO

EXEC PR_ACCEPTDATE_RETURN_FACULTY_MEMBER '2015-06-10'

--2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.

GO
CREATE OR ALTER PROCEDURE PR_SEARCH_BY_STUDENTID_OR_COURSEID
@STUDENTID INT  = NULL,
@COURSEID VARCHAR(10) = NULL
AS
BEGIN
       SELECT ENROLLMENT.EnrollmentID,ENROLLMENT.EnrollmentDate,ENROLLMENT.Grade,ENROLLMENT.EnrollmentStatus
       FROM ENROLLMENT
       WHERE ENROLLMENT.StudentID=@STUDENTID OR ENROLLMENT.CourseID=@COURSEID

END
GO

EXEC PR_SEARCH_BY_STUDENTID_OR_COURSEID 1
EXEC PR_SEARCH_BY_STUDENTID_OR_COURSEID @COURSEID = 'CS101'

--3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.

GO
CREATE OR ALTER PROCEDURE PR_SEARCH_COURSE_BETWEEN_TWO_VALUES
@A INT,
@B INT
AS
BEGIN

SELECT COURSE.CourseName,COURSE.CourseCredits
FROM COURSE
WHERE COURSE.CourseCredits BETWEEN @A AND @B

END
GO

EXEC PR_SEARCH_COURSE_BETWEEN_TWO_VALUES 3,4


--4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.

GO
CREATE OR ALTER PROCEDURE PR_SEARCH_STUDENT_BY_COURSENAME
@COURSENAME VARCHAR(100)
AS
BEGIN

SELECT COURSE.CourseName,STUDENT.StuName
FROM COURSE
INNER JOIN ENROLLMENT
ON COURSE.CourseID=ENROLLMENT.CourseID
INNER JOIN STUDENT
ON STUDENT.StudentID=ENROLLMENT.StudentID
WHERE COURSE.CourseName=@COURSENAME

END
GO

EXEC  PR_SEARCH_STUDENT_BY_COURSENAME 'Data Structures'


--5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.

GO
CREATE OR ALTER PROCEDURE PR_SEARCH_COURSEASSIGMENT_BY_FACULTYNAME
@FacultyName VARCHAR(100)
AS
BEGIN

       SELECT FACULTY.FacultyName,COURSE.CourseName
       FROM COURSE
       INNER JOIN COURSE_ASSIGNMENT
       ON COURSE.CourseID=COURSE_ASSIGNMENT.CourseID
       INNER JOIN FACULTY
       ON FACULTY.FacultyID=COURSE_ASSIGNMENT.FacultyID
       WHERE FACULTY.FacultyName=@FacultyName

END
GO

EXEC  PR_SEARCH_COURSEASSIGMENT_BY_FACULTYNAME 'Dr. Patel'

--6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.

GO
CREATE OR ALTER PROCEDURE PR_FACULTYNAME_CLASSROOM_BY_SEMNO_YEAR
@SEMESTER INT = NULL,
@YEAR DATETIME = NULL
AS
BEGIN

        SELECT COURSE_ASSIGNMENT.Semester,COURSE_ASSIGNMENT.Year,FACULTY.FacultyName,COURSE_ASSIGNMENT.ClassRoom
        FROM COURSE_ASSIGNMENT
        INNER JOIN FACULTY
        ON COURSE_ASSIGNMENT.FacultyID=FACULTY.FacultyID
        WHERE  COURSE_ASSIGNMENT.Semester=@SEMESTER AND COURSE_ASSIGNMENT.Year=@YEAR

END
GO

exec PR_FACULTYNAME_CLASSROOM_BY_SEMNO_YEAR 1,2024


--Part – B 
--7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.

GO
CREATE OR ALTER PROCEDURE PR_RETURN_ENROLLMENT_STATUS_BY_FIRST_LETTER
@CHR VARCHAR(1)
AS
BEGIN

          SELECT *
          FROM ENROLLMENT
          WHERE @CHR=LEFT(ENROLLMENT.EnrollmentStatus,1)

END
GO

EXEC  PR_RETURN_ENROLLMENT_STATUS_BY_FIRST_LETTER 'A'

--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.

GO
CREATE OR ALTER PROCEDURE PR_RETURN_STUDENT_DATA_BY_STUDENTNAME_OR_DEPARTMENTNAME
@STUNAME VARCHAR(100) = NULL,
@STUDEPARTMENT VARCHAR(100) = NULL
AS
BEGIN

          SELECT * FROM STUDENT
          WHERE STUDENT.StuName=@STUNAME OR STUDENT.StuDepartment=@STUDEPARTMENT

END
GO

EXEC PR_RETURN_STUDENT_DATA_BY_STUDENTNAME_OR_DEPARTMENTNAME 'Raj Patel','CSE'
EXEC PR_RETURN_STUDENT_DATA_BY_STUDENTNAME_OR_DEPARTMENTNAME NULL,'IT'
EXEC PR_RETURN_STUDENT_DATA_BY_STUDENTNAME_OR_DEPARTMENTNAME @STUDEPARTMENT='ECE'

--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.

GO
CREATE OR ALTER PROCEDURE PR_RETURN_STUDENT_BY_COURSE_ID
@COURSEID VARCHAR(10)
AS
BEGIN

        SELECT COURSE.CourseID,ENROLLMENT.EnrollmentStatus,COUNT(ENROLLMENT.StudentID) AS COUNTS
        FROM COURSE
        INNER JOIN ENROLLMENT
        ON COURSE.CourseID=ENROLLMENT.CourseID
        WHERE COURSE.CourseID=@COURSEID
        GROUP BY COURSE.CourseID,ENROLLMENT.EnrollmentStatus
        

END
GO

EXEC PR_RETURN_STUDENT_BY_COURSE_ID 'IT201'

--Part – C 
--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.

GO
CREATE OR ALTER PROCEDURE PR_RETURN_COURSE_ASSIGNED_WITH_CLASSROOM_BY_YEAR
@YEAR INT
AS
BEGIN

        SELECT COURSE_ASSIGNMENT.Year,COURSE.CourseName,FACULTY.FacultyName,COURSE_ASSIGNMENT.ClassRoom
        FROM COURSE_ASSIGNMENT
        INNER JOIN COURSE
        ON COURSE_ASSIGNMENT.CourseID=COURSE.CourseID
        INNER JOIN FACULTY
        ON FACULTY.FacultyID=COURSE_ASSIGNMENT.FacultyID
        WHERE COURSE_ASSIGNMENT.Year=@YEAR

END
GO

EXEC PR_RETURN_COURSE_ASSIGNED_WITH_CLASSROOM_BY_YEAR 2024

--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.

GO
CREATE OR ALTER PROCEDURE PR_RETURN_STUDENT_AND_COURSE_DETAILS_BY_DATE
@A DATE,
@B DATE
AS
BEGIN

       SELECT ENROLLMENT.EnrollmentDate,STUDENT.StuName,COURSE.CourseName
       FROM STUDENT 
       INNER JOIN ENROLLMENT
       ON STUDENT.StudentID=ENROLLMENT.StudentID
       INNER JOIN COURSE
       ON COURSE.CourseID=ENROLLMENT.CourseID
       WHERE ENROLLMENT.EnrollmentDate BETWEEN @A AND @B

END
GO

EXEC PR_RETURN_STUDENT_AND_COURSE_DETAILS_BY_DATE '2021-07-01','2022-01-05'

--12.	Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).


GO
CREATE OR ALTER PROCEDURE PR_RETURN_TOTAL_CREDITS_BY_FACULTYID
@FACULTYID INT
AS
BEGIN

          SELECT FACULTY.FacultyID,FACULTY.FacultyName,SUM(COURSE.CourseCredits) AS TOTAL_CREDITS_BY_TEACHING
          FROM FACULTY
          INNER JOIN COURSE_ASSIGNMENT
          ON FACULTY.FacultyID=COURSE_ASSIGNMENT.FacultyID
          INNER JOIN COURSE
          ON COURSE.CourseID=COURSE_ASSIGNMENT.CourseID
          WHERE FACULTY.FacultyID=@FACULTYID
          GROUP BY FACULTY.FacultyID,FACULTY.FacultyName


END
GO

EXEC  PR_RETURN_TOTAL_CREDITS_BY_FACULTYID 103
