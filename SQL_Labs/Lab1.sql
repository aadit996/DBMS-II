--Lab-1
--Part – A 
--1.	Retrieve all unique departments from the STUDENT table.

SELECT * 
FROM STUDENT
--2.	Insert a new student record into the STUDENT table.
--(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

INSERT INTO STUDENT VALUES (9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

--3.	Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)

UPDATE STUDENT
SET StuEmail='raj.p@univ.edu'
WHERE  StuName = 'Raj Patel'

--4.	Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.

ALTER TABLE STUDENT
ADD  CGPA DECIMAL(3,2)

--5.	Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)

SELECT * 
FROM COURSE
WHERE CourseName LIKE '%Data%'

--6.	Retrieve all students whose Name contains 'Shah'. (STUDENT table)

SELECT * FROM STUDENT
WHERE StuName LIKE '%Shah%'

--7.	Display all Faculty Names in UPPERCASE. (FACULTY table)

SELECT UPPER(FacultyName) FROM FACULTY


--8.	Find all faculty who joined after 2015. (FACULTY table)

SELECT * FROM FACULTY
WHERE FacultyJoiningDate >'2015-12-31'

--9.	Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)

SELECT SQRT(CourseCredits) FROM COURSE
WHERE CourseName ='Database Management Systems'

--10.	Find the Current Date using SQL Server in-built function.

SELECT GETDATE()

--11.	Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)

SELECT TOP 3 * FROM STUDENT
ORDER BY StuEnrollmentYear

--12.	Find all enrollments that were made in the year 2022. (ENROLLMENT table)

SELECT EnrollmentDate FROM ENROLLMENT
WHERE DATEPART(year,EnrollmentDate) = '2022'

--13.	Find the number of courses offered by each department. (COURSE table)

SELECT CourseName,COUNT(COURSEID) FROM COURSE
GROUP BY CourseName


--14.	Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)

SELECT CourseID,COUNT(*) from ENROLLMENT
GROUP BY CourseID
HAVING COUNT(*)>2

--15.	Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)

SELECT s.StuName,e.EnrollmentStatus
FROM STUDENT s
LEFT OUTER JOIN ENROLLMENT e
ON s.StudentID=e.StudentID

--16.	Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)

SELECT s.StuName,c.CourseName
FROM STUDENT s
INNER JOIN ENROLLMENT e
ON s.StudentID=e.StudentID
INNER JOIN COURSE c
ON c.CourseID=e.CourseID

--17.	Create a view called 'ActiveEnrollments' showing only active enrollments with student name and  course name. (STUDENT, COURSE, ENROLLMENT,  table)

GO
CREATE VIEW VActiveEnrollments AS 
SELECT s.StuName,c.CourseName,e.EnrollmentStatus
FROM STUDENT s
INNER JOIN ENROLLMENT e
ON s.StudentID=e.StudentID
INNER JOIN COURSE c
ON c.CourseID=e.CourseID
WHERE e.EnrollmentStatus='Active'
GO

select * from VActiveEnrollments

--18.	Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)

Select s.StuName FROM STUDENT s
WHERE s.StudentID NOT IN (
                     SELECT e.StudentID
                     FROM ENROLLMENT e
)

--19.	Display course name having second highest credit. (COURSE table)




--SELECT MIN(Salary) AS NthHighestSalary
--FROM (
--    SELECT TOP 3 Salary
--    FROM Employees
--    ORDER BY Salary DESC
--) AS TopSalaries

--Part – B 
--20.	Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)

SELECT c.CourseName,COUNT(e.StudentID) FROM COURSE c
LEFT OUTER JOIN ENROLLMENT e
ON c.CourseID=e.CourseID
GROUP BY c.CourseName

--21.	Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)

SELECT EnrollmentStatus ,COUNT(*)from ENROLLMENT
GROUP BY EnrollmentStatus
HAVING COUNT(*)>2

--22.	Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE, COURSE_ASSIGNMENT table)

SELECT f.FacultyName,c.CourseName,c.CourseCredits FROM FACULTY f
INNER JOIN COURSE_ASSIGNMENT ca
ON f.FacultyID=ca.FacultyID
INNER JOIN COURSE c
ON c.CourseID=ca.CourseID
WHERE f.FacultyName = 'Dr. Sheth'
ORDER BY c.CourseCredits DESC

--Part – C 
--23.	List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)

SELECT s.StudentID, COUNT(e.CourseID) FROM STUDENT s
INNER JOIN ENROLLMENT e
ON s.StudentID=e.StudentID
GROUP BY s.StudentID
HAVING COUNT(e.CourseID)>3

--24.	Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT, ENROLLMENT table)

SELECT s.StudentID,s.StuName FROM STUDENT s
WHERE s.StudentID IN (
                       SELECT e.StudentID FROM ENROLLMENT e
                       WHERE e.CourseID = 'CS201'
)
AND s.StudentID IN (
                       SELECT e.StudentID FROM ENROLLMENT e
                       WHERE e.CourseID = 'CS101'
)

--25.	Retrieve department-wise count of faculty members along with their average years of experience (calculate experience from JoiningDate). (Faculty table)
SELECT FacultyDepartment,COUNT(*) AS [FAC_COUNT],AVG(DATEPART(year,GETDATE())-DATEPART(YEAR,FacultyJoiningDate)) AS [FAC_EXP] FROM FACULTY
GROUP BY FacultyDepartment

