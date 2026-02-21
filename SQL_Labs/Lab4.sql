--Part – A 
--1. Write a scalar function to print "Welcome to DBMS Lab". 

GO
CREATE OR ALTER FUNCTION WELCOM_MSG()
RETURNS VARCHAR(100)
AS
BEGIN
     RETURN 'Welcome to DBMS Lab'
END
GO

SELECT dbo.WELCOM_MSG() AS WEL_MSG

--2. Write a scalar function to calculate simple interest.  

GO
CREATE OR ALTER FUNCTION FN_INTEREST_CAL
(
@P FLOAT,
@N FLOAT,
@R FLOAT
)
RETURNS FLOAT
AS
BEGIN
     RETURN (@P*@N*@R)/100
END
GO

SELECT dbo.FN_INTEREST_CAL(10.0,2,4)


--3. Function to Get Difference in Days Between Two Given Dates 

GO
CREATE OR ALTER FUNCTION FN_DATEDIFF
(
@D1 DATE,
@D2 DATE
)
RETURNS INT
AS
BEGIN
     RETURN (DATEDIFF(DAY,@D1,@D2))
END
GO

SELECT dbo.FN_DATEDIFF('2025-5-5','2025-5-10')

--4. Write a scalar function which returns the sum of Credits for two given CourseIDs. 

GO
CREATE OR ALTER FUNCTION FN_CREDITS
(
@CID1 VARCHAR(100),
@CID2 VARCHAR(100)
)
RETURNS INT
AS
BEGIN
       DECLARE @SUMAMT INT = 0
       SELECT @SUMAMT = SUM(COURSE.CourseCredits) FROM COURSE WHERE COURSE.CourseID IN (@CID1,@CID2)
       RETURN @SUMAMT
END
GO

SELECT dbo.FN_CREDITS('CS101','CS201')



--5. Write a function to check whether the given number is ODD or EVEN. 

GO
CREATE OR ALTER FUNCTION FN_ODDEVEN
(
@NUM INT
)
RETURNS VARCHAR(40)
AS
BEGIN
       IF @NUM%2 = 0
       BEGIN
         RETURN 'EVEN' 
       END

       RETURN 'ODD'
END                                                                   
GO

SELECT dbo.FN_ODDEVEN(3)

--6. Write a function to print number from 1 to N. (Using while loop) 

GO
CREATE OR ALTER FUNCTION FN_ONETOn
(
@N INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN

      DECLARE @RES VARCHAR(MAX) = ''
      DECLARE @I INT 

      SET @I = 1      

      WHILE(@I<=@N)
      BEGIN
      SET @RES = @RES + ' ' + CAST(@I AS VARCHAR)
      SET @I = @I + 1
      END

      SET @RES = TRIM(@RES)

      RETURN @RES 

END
GO

SELECT dbo.FN_ONETOn(12)

--7. Write a scalar function to calculate factorial of total credits for a given CourseID. 

GO
CREATE OR ALTER FUNCTION FN_FACT_OF_TOTAL_CREDITS
(
@COURSEID VARCHAR(100)
)
RETURNS INT
AS
BEGIN
        DECLARE @FACT INT = 1,@SUM INT = 0
        DECLARE @I INT = 1

        SELECT @SUM = SUM(COURSE.CourseCredits)
        FROM COURSE
        WHERE @COURSEID=COURSE.CourseID
        GROUP BY COURSE.CourseID

        WHILE(@I<=@SUM)
        BEGIN
            SET @FACT = @FACT * @I
            SET @I = @I + 1
        END

        RETURN @FACT
        
END
GO

SELECT dbo.FN_FACT_OF_TOTAL_CREDITS('IT101')
SELECT dbo.FN_FACT_OF_TOTAL_CREDITS('CS101')

--8. Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case 
--statement)  

GO
CREATE OR ALTER FUNCTION FN_CHECK_ENROLLMENT_YEAR
(
@YEAR INT
)
RETURNS VARCHAR(20)
BEGIN
         IF(DATEPART(YEAR,GETDATE()) = @YEAR)
         BEGIN
         RETURN 'CURRENT'
         END
         ELSE IF (DATEPART(YEAR,GETDATE()) > @YEAR)
         BEGIN
         RETURN 'PAST'
         END

         RETURN 'FUTURE'
END
GO

SELECT dbo.FN_CHECK_ENROLLMENT_YEAR(2027)

--9. Write a table-valued function that returns details of students whose names start with a given letter. 

GO
CREATE OR ALTER FUNCTION dbo.FN_CHECK_STU_NAME_2
(
    @LETTER CHAR(1)
)
RETURNS @T TABLE (STUDENT_NAME VARCHAR(100))
AS
BEGIN
    INSERT INTO @T (STUDENT_NAME)
    SELECT StuName
    FROM STUDENT
    WHERE StuName LIKE @LETTER + '%';   --  fixed: parameter concatenation + no quotes around @LETTER

    RETURN;   -- this line is correct and required in MSTVF
END
GO

SELECT * FROM dbo.FN_CHECK_STU_NAME_2('A')

GO
CREATE OR ALTER FUNCTION FN_CHECK_STU_NAME
(
@LETTER CHAR(1)
)
RETURNS TABLE
AS

      RETURN(
       SELECT STUDENT.StuName
       FROM STUDENT
       WHERE STUDENT.StuName LIKE  @LETTER + '%'
      )

GO

SELECT * FROM dbo.FN_CHECK_STU_NAME('A')

--10. Write a table-valued function that returns unique department names from the STUDENT table. 

GO
CREATE OR ALTER FUNCTION FN_UNIQUE_DEPARTMENT()
RETURNS TABLE
AS
 
         RETURN(
         SELECT DISTINCT STUDENT.StuDepartment
         FROM STUDENT
         )

GO

SELECT * FROM dbo.FN_UNIQUE_DEPARTMENT()


--Part – B 
--11. Write a scalar function that calculates age in years given a DateOfBirth. 

GO
CREATE OR ALTER FUNCTION FN_CALC_AGE(@DOB DATE)
RETURNS INT 
BEGIN
       DECLARE @AGE INT = 0
       SET @AGE = DATEDIFF(YEAR,@DOB,GETDATE())

       RETURN @AGE
END
GO

SELECT dbo.FN_CALC_AGE('2006-10-15')

--12. Write a scalar function to check whether given number is palindrome or not. 

GO
CREATE OR ALTER FUNCTION FN_PALINDROME(@N1 INT)
RETURNS VARCHAR(30)
AS
BEGIN
        DECLARE @N2 INT
        SET @N2 = REVERSE(@N1)

        IF(@N1 = @N2)
        BEGIN
        RETURN 'palindrome'
        END

        RETURN 'NOT palindrome'
END 
GO
                           
SELECT dbo.FN_PALINDROME(1321)

--13. Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department. 

GO
CREATE OR ALTER FUNCTION FN_CALC_CSE_CREDITS()
RETURNS INT
AS
BEGIN
      DECLARE @SUM INT 

      SELECT @SUM = SUM(COURSE.CourseCredits)
      FROM COURSE
      WHERE COURSE.CourseDepartment = 'CSE'

      RETURN @SUM
END
GO

SELECT * FROM COURSE

SELECT dbo.FN_CALC_CSE_CREDITS()

--14. Write a table-valued function that returns all courses taught by faculty with a specific designation. 
GO
CREATE OR ALTER FUNCTION FN_FAC_DESIG_COURSE(@FacultyDesignation VARCHAR(50))
RETURNS TABLE
AS     
      RETURN(
      SELECT FACULTY.FacultyDesignation,COURSE.CourseName
      FROM FACULTY 
      INNER JOIN COURSE_ASSIGNMENT
      ON FACULTY.FacultyID = COURSE_ASSIGNMENT.FacultyID
      INNER JOIN COURSE
      ON COURSE.CourseID = COURSE_ASSIGNMENT.CourseID 
      WHERE FACULTY.FacultyDesignation=@FacultyDesignation
      )
GO

SELECT * FROM dbo.FN_FAC_DESIG_COURSE('Professor')

--Part – C 
--15. Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits 
--from all active enrollments).

GO
CREATE OR ALTER FUNCTION FN_STU_SUM_CREDITS(@STUID INT)
RETURNS INT
AS
BEGIN 
              DECLARE @SUM INT = 0 
              SELECT @SUM = SUM(COURSE.CourseCredits)
              FROM COURSE
              INNER JOIN ENROLLMENT
              ON COURSE.CourseID = ENROLLMENT.CourseID
              INNER JOIN STUDENT
              ON STUDENT.StudentID=ENROLLMENT.StudentID
              WHERE STUDENT.StudentID = @STUID AND EnrollmentStatus = 'Active'

              RETURN @SUM
END
GO

SELECT dbo.FN_STU_SUM_CREDITS(1)

--16. Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who 
--joined in that period. 

GO
CREATE OR ALTER FUNCTION FN_JD_FAC_COUNT(@D1 DATE,@D2 DATE)
RETURNS INT
AS
BEGIN
           DECLARE @FAC INT

           SELECT @FAC = COUNT(FACULTY.FacultyName)
           FROM FACULTY
           WHERE FACULTY.FacultyJoiningDate BETWEEN @D1 AND @D2

           RETURN @FAC
END
GO

SELECT dbo.FN_JD_FAC_COUNT('2010-07-15','2015-06-10')