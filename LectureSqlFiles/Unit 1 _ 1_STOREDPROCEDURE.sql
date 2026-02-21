CREATE DATABASE DBMS_II_2026

USE DBMS_II_2026

drop database DBMS_II_2026

------------STORED PROCEDURE----------------


--A Stored Procedure is a prepared SQL code that you can save, 
--so the code can be reused over and over again.

--EX:A Stored Procedure is like a Saved Contact for your database code. 
--You save the complex logic once, and "speed dial" it whenever you need it.



---SYNTAX
CREATE or ALTER PROCEDURE Procedure_Name 
--	List of Parameters with datatype if required
AS 
BEGIN  
    -- SQL statements OR Body
END



DROP PROCEDURE PR_WelcomeMessage

--1 WELCOME MESSAGE SP

create or alter  PROCEDURE PR_WelcomeMessage
AS
BEGIN
    PRINT 'Welcome to DBMS-II ';
END 


-- How to execute SP?
--METHOD1
PR_WelcomeMessage 

--METHOD2
EXEC PR_WelcomeMessage

--METHOD3
EXECUTE PR_WelcomeMessage


---
DROP TABLE Department
-- Create the Department table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,        
    DeptName VARCHAR(50),          
    Location VARCHAR(50)          
);


INSERT INTO Department (DeptID, DeptName, Location) VALUES (1, 'Admin', 'A-Block')
INSERT INTO Department (DeptID, DeptName, Location) VALUES  (2, 'IT Support', 'C-Block')
INSERT INTO Department (DeptID, DeptName, Location) VALUES (3, 'Human Resources', 'B-Block')
INSERT INTO Department (DeptID, DeptName, Location) VALUES (4, 'Cafeteria', 'D-Block')
INSERT INTO Department (DeptID, DeptName, Location) VALUES (5, 'Library', 'E-Block')


select * from Department

DROP PROC PR_SelectAll_Dept

---2 SELECT ALL WITH SP

CREATE OR ALTER PROCEDURE PR_SelectAll_Dept
AS
BEGIN
	SELECT * FROM Department
END

EXEC PR_SelectAll_Dept


---3 SELECT BY ID

SELECT * FROM Department WHERE DeptID=1

SELECT * FROM Department WHERE DeptID=2

DROP PROCEDURE PR_SelectBY_DEPTID    

CREATE OR ALTER PROCEDURE PR_SelectBY_DEPTID
	@DID int
AS
BEGIN
	SELECT * FROM DEPARTMENT WHERE DeptID=@DID
END

EXEC PR_SelectBY_DEPTID 2


---4 STRING CONCATE IN SP

DROP PROCEDURE SP_WELCOME_USER

CREATE OR ALTER PROCEDURE SP_WELCOME_USER
	@USERNAME VARCHAR(25)
AS
BEGIN
	PRINT 'WELCOME TO DBMS-II' + ' '+@USERNAME
END

EXECUTE SP_WELCOME_USER 'KRISHNA'



DROP PROCEDURE PR_DEPARTMENT_INSERT

--5 SP TO INSERT DATA

CREATE OR ALTER PROCEDURE PR_DEPARTMENT_INSERT
	@DeptId int,
	@DeptName VARCHAR(50),
	@LOCATION VARCHAR(50)
AS
BEGIN
	INSERT INTO Department (DeptID, DeptName, Location)
	VALUES (@DeptId,@DeptName,@LOCATION)
END


DELETE FROM Department
	
--POSITIONAL PARAMETER

EXEC PR_DEPARTMENT_INSERT 6,'CSE','C-BLOCK'


select * from Department

--ERROR
EXEC PR_DEPARTMENT_INSERT 'Electrical', 7, 'A-BLOCK';


--NAMED PARAMETER
-- Putting Location first, then ID, then Name
EXEC PR_DEPARTMENT_INSERT  @LOCATION = 'D-BLOCK',  @DeptId = 8,   @DeptName = 'Mechanical';


EXEC PR_DEPARTMENT_INSERT  9, @LOCATION = 'H-BLOCK',     @DeptName = 'MBA';


--6 SP TO UPDATE DATA

UPDATE DEPARTMENT 
SET DeptName='COMPUTER'
WHERE DepTID=1


--------

CREATE OR ALTER PROCEDURE PR_DEPARTMENT_UPDATE
	@dID int,
	@dName varchar(15)
AS
BEGIN
	UPDATE DEPARTMENT
	SET DeptName=@dName
	WHERE DeptID=@dID
END

select * from Department

EXEC PR_DEPARTMENT_UPDATE 6,'ELEC1'

--7 SP TO DELETE DATA
CREATE OR ALTER PROC PR_DEPT_DELETE
	@DID INT
AS
BEGIN
	DELETE FROM Department
	WHERE DeptID=@DID
END


EXEC PR_DEPT_DELETE 8




CREATE TABLE Designation (
    DesignationID INT PRIMARY KEY,
    DESIGNATION VARCHAR(100) 
);

--8 SP TO INESRT DESIGNATION

CREATE OR ALTER PROC PR_DESIGNATION_INSERT
	@DID INT,
	@DNAME VARCHAR(50)
AS
BEGIN
	INSERT INTO Designation
	VALUES (@DID, @DNAME)
END


EXEC PR_DESIGNATION_INSERT 11,	'Jobber'
EXEC PR_DESIGNATION_INSERT 12,	'Welder'
EXEC PR_DESIGNATION_INSERT 13,	'Clerk'
EXEC PR_DESIGNATION_INSERT 14,	'Manager'
EXEC PR_DESIGNATION_INSERT 15,	'CEO'


EXEC PR_DESIGNATION_INSERT 2

SELECT * FROM Designation

--9 SP TO UPDATE FROM DESIGNATION

CREATE OR ALTER PROCEDURE PR_DESIGNATION_UPDATE
	@dID int,
	@dName varchar(15)
AS
BEGIN
	UPDATE DESIGNATION
	SET DesignationName=@dName
	WHERE DesignationID=@dID
END

select * from Department

EXEC PR_DESIGNATION_UPDATE 11,'PROGRAMMAR'

--10 SP TO DELETE DATA

CREATE OR ALTER PROC PR_DESIGNATION_DELETE
	@DID INT
AS
BEGIN
	DELETE FROM DESIGNATION
	WHERE DesignationID=@DID
END

EXEC PR_DESIGNATION_DELETE 11

CREATE TABLE Person (
    PersonID INT PRIMARY KEY IDENTITY(101,1),
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATETIME NOT NULL,
    DepartmentID INT NULL,
    DesignationID INT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DeptID),
    FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

--11 SP TO INSERT IN TO PERSON

CREATE OR ALTER PROCEDURE PR_Person_Insert
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Salary DECIMAL(8, 2),
    @JoiningDate DATETIME,
    @DepartmentID INT = NULL,
    @DesignationID INT = NULL
AS
BEGIN
    INSERT INTO Person (FirstName, LastName, Salary, JoiningDate, DepartmentID, DesignationID)
    VALUES (@FirstName, @LastName, @Salary, @JoiningDate, @DepartmentID, @DesignationID);
END;


SELECT * FROM Department
SELECT * FROM Designation


EXEC PR_Person_Insert	'Rahul',	'Anshu',	56000,'01-JAN-1990',	1,	12
EXEC PR_Person_Insert	'Hardik',	'Hinsu',	18000,'25-SEP-1990',	2,	11
EXEC PR_Person_Insert	'Bhavin',	'Kamani',	25000,'14-MAY-1991',	NULL,	11
EXEC PR_Person_Insert	'Bhoomi',	'Patel',	39000,'20-FEB-2014',	1,	13
EXEC PR_Person_Insert	'Rohit',	'Rajgor',	17000,'23-JUL-1990',	2,	15
EXEC PR_Person_Insert	'Priya',	'Mehta',	25000,'18-OCT-1990',	2,	NULL
EXEC PR_Person_Insert	'Neha',	'Trivedi',	18000,'20-FEB-2014',	3,	15


select * from
Designation
order by DesignationName

--12  Return all designations sorted by name


CREATE or ALTER PROCEDURE PR_Designation_GetAllSorted
AS
BEGIN
    SELECT DesignationID, DesignationName
    FROM Designation
    ORDER BY DesignationName;
END

EXEC PR_Designation_GetAllSorted

--13  Display Persons with salary between two values

CREATE OR ALTER PROCEDURE PR_Person_BySalaryRange
    @MinSalary DECIMAL(8,2),
    @MaxSalary DECIMAL(8,2)
AS
BEGIN
    SELECT *
    FROM Person
    WHERE Salary BETWEEN @MinSalary AND @MaxSalary
    
END


exec PR_Person_BySalaryRange 10000,70000


--14 Display Persons who joined between two dates

CREATE OR ALTER PROCEDURE PR_Person_JoinedBetweenDates
    @FromDate DATETIME,
    @ToDate   DATETIME
AS
BEGIN
    SELECT *
    FROM Person
    WHERE JoiningDate BETWEEN @FromDate AND @ToDate
   
END


exec PR_Person_JoinedBetweenDates '1-jan-2002','1-jan-2024'

select top 3 *
from person
order by salary desc

--15 Top N highest-salary persons (EX: TOP 3 SALARY PERSON'S DATA)

CREATE OR ALTER PROCEDURE PR_GetTopNHighestSalary
    @TopN INT
AS
BEGIN
    SELECT TOP (@TopN) *
    FROM Person 
    ORDER BY Salary DESC;
END


EXEC PR_GetTopNHighestSalary 7

select * from person

--16 Persons with designation or department IS unassigned


CREATE OR ALTER PROCEDURE PR_Person_Unassigned
AS
BEGIN
    SELECT *
    FROM Person
    WHERE DepartmentID IS NULL
	OR DesignationID IS NULL
END

exec PR_Person_Unassigned

--17  Return all persons of a given DepartmentNAME

CREATE OR ALTER PROCEDURE PR_Person_ByDepartment
    @DeptNAME VARCHAR(50)
AS
BEGIN
    SELECT Person.PersonID,
           Person.FirstName,
           Person.LastName,
           Person.Salary,
           Person.JoiningDate,
           Department.DeptName           
    FROM Person 
    INNER JOIN Department 
	ON Person.DepartmentID  = Department.DeptID
	WHERE Department.DeptName = @DeptNAME 
END

EXEC PR_Person_ByDepartment 'ADMIN'

--18 Return all persons with a given Designation 
--(with Deptname & Designation names)


CREATE OR ALTER PROCEDURE PR_Person_ByDesignation
    @DesignationName varchar(50)
AS
BEGIN
    SELECT Person.PersonID,
           Person.FirstName,
           Person.LastName,
           Person.Salary,
           Person.JoiningDate,
           Department.DeptName      ,
           Designation.DesignationName
    FROM Person 
    LEFT JOIN Department   
	ON Person.DepartmentID   = Department.DeptID

    lEFT JOIN Designation  
	ON Person.DesignationID  = Designation.DesignationID

   WHERE Designation.DesignationName = @DesignationName

END


exec PR_Person_ByDesignation 'clerk'


--19 Give Salary summary (MIN, MAX, AVG, TOTAL) OF EACH DEPARTMENT

CREATE OR ALTER PROCEDURE PR_Person_SalarySummaryByDept
AS
BEGIN
    SELECT DeptName,
           MIN(Salary) AS MinSalary,
           MAX(Salary) AS MaxSalary,
           AVG(Salary) AS AvgSalary,
		   SUM(Salary) AS TotalSalary
    FROM Person 
    INNER JOIN Department 
	ON PERSON.DepartmentID = Department.DeptID
    GROUP BY Department.DeptName   
END

EXEC PR_Person_SalarySummaryByDept

--20 for each department display total persons, 
--number of distinct designations

CREATE OR ALTER PROCEDURE PR_Dept_SalaryAndDesignationReport
AS
BEGIN
    SELECT 
        Department.DeptID,
        Department.DeptName,
        COUNT(Person.PersonID) AS PersonCount,
        COUNT(DISTINCT Person.DesignationID) AS DistinctDesignationCount
    FROM Person
    LEFT JOIN Department
        ON Person.DepartmentID = Department.DeptID
    GROUP BY  Department.DeptName
    
END


EXEC PR_Dept_SalaryAndDesignationReport

select * from person where FirstName like 'c%'

--21 Create a stored procedure that accepts the 
--first letter of Departmentname ('A', 'C', 'D') 
--and returns number of person working in that department.

CREATE OR ALTER PROCEDURE PR_FIRSTLETTER
	@LETTER VARCHAR(1)
AS
BEGIN
	SELECT Department.DeptName,
			count(person.personid) 
    FROM Person 
    INNER JOIN Department 
	ON Person.DepartmentID  =Department.DeptID
    WHERE Department.DeptName LIKE @LETTER + '%'
	group by Department.DeptName
END


exec PR_FIRSTLETTER 'c'

--22 Department & Designation wise salary distribution: 
--count person, average, total salary — 
--but only include combinations where there are at least 2 persons

CREATE OR ALTER PROCEDURE PR_DeptDesig_SalaryStats_MinCount
AS
BEGIN
    SELECT
      Department.DeptName      AS DepartmentName,
      Designation.DesignationName AS DesignationName,
      COUNT(Person.PersonID)     AS PersonCount,
      AVG(Person.Salary)         AS AvgSalary,
      SUM(Person.Salary)         AS TotalSalary
    FROM Person
    INNER JOIN Department
    ON Person.DepartmentID = Department.DeptID

    INNER JOIN Designation
    ON Person.DesignationID = Designation.DesignationID

    GROUP BY Department.DeptName, Designation.DesignationName
    HAVING COUNT(Person.PersonID) >= 2
   
END


EXEC PR_DeptDesig_SalaryStats_MinCount



--23 Persons whose salary is greater than average salary 

SELECT Person.FirstName,PERSON.Salary
FROM PERSON
WHERE SALARY>(SELECT AVG(SALARY) FROM Person)


CREATE OR ALTER PROCEDURE PR_Person_AboveAvg
AS
BEGIN
    SELECT 
        Person.PersonID,
        Person.FirstName,
        Person.LastName,
        Person.Salary,
        Department.DeptName
    FROM Person
    INNER JOIN Department
        ON Person.DepartmentID = Department.DeptID
    WHERE Person.Salary > (SELECT AVG(SALARY) FROM Person)
END


EXEC PR_Person_AboveAvg



-------------------OUTPUT PARAMETER--------------------------
--SP WITH RETURN VALUE


---24 CREATE SP THAT COUNT NUMBER OF PERSON OF GIVEN DEPTID
--Count should be returned in a variable.

select * from person

SELECT Count(*)
	FROM PERSON 
	WHERE DEPARTMENTID =1





CREATE OR ALTER PROCEDURE PR_PERSON_GetDEPTIDCOUNT
	@DEPTID		INT , 
	@Count		int OUT
AS
BEGIN
	SELECT @Count = Count(*)
	FROM PERSON 
	WHERE DEPARTMENTID = @DEPTID
END

--HOW TO EXECUTE OUT PROCEDURE
DECLARE @Cnt int
EXEC PR_PERSON_GetDEPTIDCOUNT  1,  @Cnt OUTPUT 
SELECT @Cnt 

select * from person

---without output parameter
CREATE OR ALTER PROCEDURE PR_PERSON_GetDEPTID
	@DEPTID INT
AS
BEGIN
SELECT COUNT(*) AS PersonCount
        FROM PERSON
        WHERE DEPARTMENTID = @DEPTID;
END

EXEC PR_PERSON_GetDEPTID 1
---

SELECT FIRSTNAME,LASTNAME FROM PERSON WHERE PERSONID=103

--25 create SP that takes personID as input
--and returns full name as an output using OUTPUT parameter

CREATE OR ALTER PROC PR_GET_FULLNAME
	@ID INT,
@FULLNAME VARCHAR(50) OUT
AS
BEGIN
	SELECT @FULLNAME=FirstName + LastName FROM Person
	WHERE PersonID=@ID
END

DECLARE @NAME VARCHAR(50) 
EXEC PR_GET_FULLNAME 103,@NAME OUT
SELECT @NAME

SELECT * FROM Person


--26 CREATE SP THAT TAKES 3 SUBJECT MARKS AS AN 
--INPUT AND RETURN AVERAGE OF MARKS
CREATE OR ALTER PROC PR_AVG_MARKS
	@S1 DECIMAL(5,2),
	@S2 DECIMAL(5,2),
	@S3 DECIMAL(5,2),
	@AVG DECIMAL(5,2) OUT
AS
BEGIN
	set @AVG =(@S1+@S2+@S3)/3
END



DECLARE @average decimal(5,2)
EXEC PR_AVG_MARKS  50,60,90,  @average  out
SELECT @average 


DROP TABLE student
------------NULL AS DEFAULT VALUE-----------
create table student
(
	id int,
	name varchar(10),
	address varchar(10)
)
--27 SP WITH NULL
create OR ALTER procedure pr_insertwithNull
	@id	int=null,
	@name varchar(10)=null,
	@address varchar(10)=null
as
begin
	insert into student values(@id,@name,@address)
end

select * from student
exec pr_insertwithNull


exec pr_insertwithNull 1,'a'
exec pr_insertwithNull 2,@address='xyz'
exec pr_insertwithNull 3,NULL,'ABC'


