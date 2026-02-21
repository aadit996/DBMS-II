USE DBMS_II_2026


--CURSOR--
--CURSOR IS database object
--Result of a query one row at a time instead of all at once.


---WHY CURSOR????
--1) CALCULATE SALES PERSON'S BONUS
--2) SEND PERSONALIZED EMAIL TO STUDENT BASED ON THEIR SCORE


--STEPS IN CURSOR

-----------------------------
--1. DECLARE the Cursor
--2. OPEN the Cursor
--3. FETCH rows
--4. LOOP through all rows
--5. CLOSE the Cursor
--6. DEALLOCATE the Cursor

SELECT * FROM Person
SELECT * FROM Department
SELECT * FROM Designation


--@ is used for user-defined variables.
--@@ is reserved for built-in global variables.



--@@FETCH_STATUS, it is a global variable in SQL Server that indicates 
--the success or failure of the last cursor FETCH operation. 

--	0: FETCH was successful.
--	-1: FETCH failed (end of result set or cursor is not open).
--	-2: Row fetched is missing. (e.g., deleted after cursor opened)


SELECT FIRSTNAME,LastName FROM PERSON

---1) RETRIVE FIRSTNAME, LASTNAME ROW BY ROW USING CURSOR
--VARIABLE DECLARATION
DECLARE @FNAME VARCHAR(50), @LNAME VARCHAR(50)
--1. DECLARE the Cursor
DECLARE CURSOR_PERSONDETAIL CURSOR
FOR
	SELECT FIRSTNAME, LASTNAME
	FROM Person
--2. OPEN the Cursor
OPEN  CURSOR_PERSONDETAIL
--3. FETCH row
FETCH NEXT FROM CURSOR_PERSONDETAIL 
INTO @FNAME,@LNAME;
--4. LOOP through all rows
WHILE @@FETCH_STATUS=0 
	BEGIN
		PRINT	@FNAME+ '-' +@LNAME  --PRINTS FIRSTNAME AND LASTNAME
				FETCH NEXT FROM CURSOR_PERSONDETAIL --FETCH NEXT RECORD
		INTO @FNAME,@LNAME;
	END
--5. CLOSE the Cursor
CLOSE CURSOR_PERSONDETAIL
--6. DEALLOCATE the Cursor
DEALLOCATE CURSOR_PERSONDETAIL



------2) RETRIVE PERSON NAME WITH DEPARTMENT DETAIL

DECLARE @FIRSTNAME VARCHAR(50), @DEPTNAME VARCHAR(50)

--1. DECLARE the Cursor
DECLARE CURSOR_PERSONDEPT CURSOR
FOR
	SELECT 
		FIRSTNAME, 
		DeptName
	FROM Person
	INNER JOIN Department
	ON PERSON.DepartmentID=Department.DeptID


--2. OPEN the Cursor
OPEN  CURSOR_PERSONDEPT


--3. FETCH row
FETCH NEXT FROM CURSOR_PERSONDEPT 
INTO @FIRSTNAME,@DEPTNAME;

--4. LOOP through all rows
WHILE @@FETCH_STATUS=0 
	BEGIN
		PRINT	@FIRSTNAME + '-' + @DEPTNAME  --PRINTS FIRSTNAME AND DEPTNAME

		FETCH NEXT FROM CURSOR_PERSONDEPT --FETCH NEXT RECORD
		INTO @FIRSTNAME,@DEPTNAME;
	END


--5. CLOSE the Cursor
CLOSE CURSOR_PERSONDEPT

--6. DEALLOCATE the Cursor
DEALLOCATE CURSOR_PERSONDEPT

-----create a cursor to fatch the record of the person who worked in IT support as a programmer.
--example: Hardik WORKS IN IT Support Department AS A PROGRAMMAR
--FILTER: DEPT:IT Support, DESIGNATION:PROGRAMMAR  

DECLARE @NAME VARCHAR(50), @DPNAME VARCHAR(50), @DSNAME VARCHAR(50)

--STEP1
DECLARE CURSOR_PERDEPTDESI CURSOR
FOR SELECT
	PERSON.FirstName,
	Department.DeptName,
	Designation.DesignationName
FROM Person
INNER JOIN Department
ON PERSON.DepartmentID=Department.DeptID
INNER JOIN Designation
ON PERSON.DesignationID=Designation.DesignationID
WHERE Department.DeptName='IT SUPPORT'
AND Designation.DesignationName='PROGRAMMAR'

--STEP2
OPEN CURSOR_PERDEPTDESI

--STEP3
FETCH NEXT FROM CURSOR_PERDEPTDESI INTO @NAME , @DPNAME , @DSNAME 

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT @NAME +' WORKS IN '+ @DPNAME + ' Department AS A '+ @DSNAME 
	FETCH NEXT FROM CURSOR_PERDEPTDESI INTO @NAME , @DPNAME , @DSNAME
END

CLOSE CURSOR_PERDEPTDESI

DEALLOCATE CURSOR_PERDEPTDESI

--student table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    Dept VARCHAR(50) NOT NULL,
    Sem INT NOT NULL
);

INSERT INTO Students (Name, Dept, Sem)
VALUES
('Arjun', 'Computer Science', 3),
('Priya', 'Electronics', 2),
('Ravi', 'Mechanical', 4),
('Sneha', 'Civil', 1);

select * from Students
select * from RESULT
--result table
CREATE TABLE Result (
    ResultID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
    Subject1 INT NOT NULL,
    Subject2 INT NOT NULL,
    Subject3 INT NOT NULL
);

INSERT INTO Result (StudentID, Subject1, Subject2, Subject3)
VALUES
(1, 50, 60, 55), 
(2, 88, 82, 91), 
(3, 75, 70, 69), 
(4, 92, 85, 88); 


--3)create a cursor to display 3 subject marks and total marks



DECLARE @S1 INT,@S2 INT,@S3 INT,@TOTAL INT;

DECLARE CURSOR_TOTAL CURSOR
FOR
	SELECT Subject1,Subject2,Subject3
	FROM Result

OPEN CURSOR_TOTAL

FETCH NEXT FROM CURSOR_TOTAL
INTO @S1,@S2,@S3

WHILE @@FETCH_STATUS=0
	BEGIN
		SET @TOTAL=(@S1+@S2+@S3);
			
		SELECT   @S1 ,@S2,@S3,@TOTAL AS TOTAL

		FETCH NEXT FROM CURSOR_TOTAL
		INTO @S1,@S2,@S3
	END

CLOSE CURSOR_TOTAL

DEALLOCATE CURSOR_TOTAL


--4) PRINT STUDENT NAME AND AVERAGE MARKS
DECLARE @SUB1 INT,@SUB2 INT,@SUB3 INT
DECLARE @AVG DECIMAL(5,2)
DECLARE @NAME VARCHAR(50);

DECLARE CURSOR_AVG_MARKS CURSOR
FOR
	SELECT Subject1,Subject2,Subject3,NAME
	FROM Result
	JOIN STUDENTS
	ON RESULT.StudentID=Students.StudentID;

OPEN CURSOR_AVG_MARKS

FETCH NEXT FROM CURSOR_AVG_MARKS
INTO @SUB1,@SUB2,@SUB3,@NAME

WHILE @@FETCH_STATUS=0
	BEGIN
		SET @AVG=(@SUB1+@SUB2+@SUB3)/3;
		PRINT @NAME + '-'+CAST(@AVG AS VARCHAR)
		
		
		FETCH NEXT FROM CURSOR_AVG_MARKS
		INTO @SUB1,@SUB2,@SUB3,@NAME
	END

CLOSE CURSOR_AVG_MARKS

DEALLOCATE CURSOR_AVG_MARKS


--5)
--PRINT AVERAGE MARKS and personlized message according to average marks

--if avg>=85 Congratulations Arjun Your average score is 89 excellent work
--if avg>=60 Hi Arjun Your average score is 63 Good job, but you can still improve.
--ELSE Hi Arjun Your average score is 45 work hard to improve your grades.


DECLARE @SUBJ1 INT,@SUBJ2 INT,@SUBJ3 INT
DECLARE @AVGE DECIMAL(5,2)
DECLARE @Msg VARCHAR(500),@fname varchar(50);

DECLARE CURSOR_AVG_MARKS_MSG CURSOR
FOR
	SELECT Subject1,Subject2,Subject3,name
	FROM Result
	JOIN STUDENTS
	ON RESULT.StudentID=Students.StudentID;

OPEN CURSOR_AVG_MARKS_MSG

FETCH NEXT FROM CURSOR_AVG_MARKS_MSG
INTO @SUBJ1,@SUBJ2,@SUBJ3,@fname

WHILE @@FETCH_STATUS=0
	BEGIN
		SET @AVGE=(@SUBJ1+@SUBJ2+@SUBJ3)/3;
		--PRINT @NAME + '-'+CAST(@AVGE AS VARCHAR)
		
		IF @AVGE >= 85
			SET @Msg = 'Congratulations ' + @fname + 
                       ' Your average score is ' + CAST(@AVGE AS VARCHAR(10)) + 
                       ' excellent work!';
		ELSE IF @AVGE >= 60
			SET @Msg = 'Hi ' + @fname + 
                       ' Your average score is ' + CAST(@AVGE AS VARCHAR(10)) + 
                       ' Good job, but you can still improve.';
		ELSE
			SET @Msg = 'Hello ' + @fname + 
                       ' Your average score is ' + CAST(@AVGE AS VARCHAR(10)) + 
                       ' work hard to improve your grades.';
		
			Print  @Msg
			--PRINT  CHAR(10) ; --line break. (blank line)

		FETCH NEXT FROM CURSOR_AVG_MARKS_MSG
		INTO @SUBJ1,@SUBJ2,@SUBJ3,@fNAME
	END

CLOSE CURSOR_AVG_MARKS_MSG

DEALLOCATE CURSOR_AVG_MARKS_MSG


--6) CREATE CURSOR TO GRACE THE SUBJECT1 MARKS BY 10%
DECLARE @StudentID INT;
DECLARE @Subject1 int;

DECLARE cursor_GraceMarks CURSOR 
FOR
SELECT StudentID,subject1
FROM Result

OPEN cursor_GraceMarks;

FETCH NEXT FROM cursor_GraceMarks INTO @StudentID,@Subject1;

WHILE @@FETCH_STATUS = 0
BEGIN
    
    UPDATE Result
    SET subject1 = @Subject1 + (@Subject1*10)/100
    WHERE StudentID = @StudentID;
  
    FETCH NEXT FROM cursor_GraceMarks INTO @StudentID,@Subject1;
END;

CLOSE cursor_GraceMarks;
DEALLOCATE cursor_GraceMarks;


create table sem4
(name varchar(50),sem int);
--7)
--create cursor to insert data (name,sem) into new table if student
--belongs to 4TH sem

declare @fname varchar(50), @sem int;

DECLARE CURSOR_4SEMSTUDENTS CURSOR
FOR
	SELECT NAME,SEM
	FROM 
	Students
	

OPEN CURSOR_4SEMSTUDENTS

FETCH NEXT FROM CURSOR_4SEMSTUDENTS INTO @fname,@sem;

WHILE @@FETCH_STATUS=0
	BEGIN
	if @sem=4
		INSERT INTO sem4 VALUES(@fname,@sem)
	FETCH NEXT FROM CURSOR_4SEMSTUDENTS INTO @fname,@sem;
	END
CLOSE CURSOR_4SEMSTUDENTS

DEALLOCATE CURSOR_4SEMSTUDENTS


--------
SELECT * FROM sem4


