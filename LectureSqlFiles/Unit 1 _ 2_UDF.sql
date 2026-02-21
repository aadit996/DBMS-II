USE DBMS_II_2026

------------SYSTEM DEFINED FUNTIONS–––––––––


--1) AGGREGRATE
--2) MATHS
--3) STRING
--4) CASTING FUNCTION


SELECT PI() AS PI_VALUE

SELECT POWER(2,3) AS POW

SELECT DATEDIFF(MONTH,'2024-06-1','2024-08-1') AS MONTH_DIFF

-----------UDF-------
---1) welcome message

CREATE OR ALTER FUNCTION FN_WELCOME()


	RETURNS VARCHAR(50)
AS
BEGIN

	RETURN 'WELCOME TO DBMS-II'
END


-----HOW TO CALL UDF??

--ERROR


select FN_WELCOME()



--dbo stands for Database Owner.

SELECT dbo.FN_WELCOME()


--2) ADDITION OF TWO NUMBER


CREATE OR ALTER FUNCTION FN_ADDITION(@N1 INT,@N2 INT)
RETURNS INT
AS
BEGIN
	declare @sum int

	set @sum= @N1+@N2

	return @sum
END
---
SELECT dbo.FN_ADDITION(10,20) as addition


--3) SIMPLE INTEREST

CREATE OR ALTER FUNCTION FN_SIMPLE_INTEREST
(@P decimal(5,2),
@N decimal(5,2), 
@R decimal(5,2))

RETURNS decimal(5,2)
AS
BEGIN
	DECLARE @SI decimal(5,2)
	SET @SI=(@P*@N*@R)/100.0
	RETURN @SI
END

--4) Convert Celsius to Fahrenheit
--	F=(C*9.0*5.0)/32

CREATE OR ALTER FUNCTION FN_CEL_TO_FER(@C DECIMAL(5,2))
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @F DECIMAL(5,2)
	SET @F=(@C*9.0*5.0)/32
	RETURN @F
END

--5) Get the Length of a String

CREATE OR ALTER FUNCTION FN_GETLENGTH(@STR VARCHAR(25))
RETURNS INT
AS
BEGIN
	RETURN(LEN(@STR))
END
--
SELECT dbo.FN_GETLENGTH('DARSHAN UNIVERSITY')

--6) Function to Get Difference in Days Between Two Dates



CREATE OR ALTER FUNCTION fn_DateDifference(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate);
END;

SELECT dbo.fn_DateDifference('2024-01-01', '2024-01-31');


SELECT * FROM PERSON

SELECT SALARY FROM PERSON WHERE PERSONID=103

--7) Function to Return Sum of SALARY for Two GIVEN PERSON
CREATE OR ALTER FUNCTION FN_SumSALARY(@S1 INT, @S2 INT)
RETURNS INT
AS
BEGIN
    DECLARE @Sum INT;
	DECLARE @T1 INT,@T2 INT;


		(SELECT @T1 =SALARY FROM PERSON WHERE PERSONID= @S1);
		(SELECT @T2 =SALARY FROM PERSON WHERE PERSONID= @S2);

	SET @Sum=@T1+@T2
    RETURN @Sum;
END;

SELECT DBO.fnSumSALARY(103,110)

SELECT * FROM PERSON
---8) Function to Sum salary for All person of GIVEN deptid




CREATE OR ALTER FUNCTION fn_TotalsalarybydeptID(@DEPTID INT)
RETURNS INT
AS
BEGIN

    RETURN (SELECT SUM(salary) FROM person WHERE DepartmentID = @DEPTID);
END;

select dbo.fn_TotalsalarybydeptID(1)



--9) Check if a Number is Positive, Negative, or Zero


CREATE OR ALTER FUNCTION FN_CHECKNO(@NO INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @MSG VARCHAR(50)
	IF @NO>0
		SET @MSG= 'POSITIVE NUMBER'
	ELSE IF @NO<0
		SET @MSG= 'NEGATIVE NUMBER'
	ELSE
		SET @MSG= 'ZERO'
	RETURN @MSG
END

select dbo.FN_CHECKNO(-10)

--10) check even odd
CREATE OR ALTER FUNCTION FN_CHECKEVENODD(@NO INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @MSG VARCHAR(50)
	IF (@NO%2=0)
		SET @MSG='EVEN'
	ELSE
		SET @MSG='ODD'
	RETURN @MSG
END

SELECT dbo.FN_CHECKEVENODD(12)
SELECT dbo.FN_CHECKEVENODD(11)
----

---last statement must be a RETURN statement to ensure a value is always returned.

---error
CREATE or alter FUNCTION dbo.fn_CheckOddEven1 (@num INT)
RETURNS VARCHAR(10)
AS
BEGIN
    IF @num % 2 = 0
        RETURN 'EVEN'
    ELSE
        RETURN 'ODD'
END



CREATE or ALTER FUNCTION FN_CHECKEVENODD2(@NO INT)
RETURNS VARCHAR(50)
AS
BEGIN
    IF (@NO % 2 = 0)
        RETURN 'EVEN';
    
    RETURN 'ODD';

END;

select dbo.FN_CHECKEVENODD2(13)


--11)Write a UDF that calculates a discount based on purchase amount:
-- > 500: 10% discount
-- > 200: 5% discount
-- <= 200: No discount





CREATE OR ALTER FUNCTION FN_CAL_DISCOUNT(@AMT INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @DISCOUNT DECIMAL(5,2)

	IF(@AMT>500)
		SET @DISCOUNT=(@AMT*10)/100
	ELSE IF(@AMT>200)
		SET @DISCOUNT=(@AMT*5)/100
	ELSE 
		SET @DISCOUNT=0.0
	RETURN @DISCOUNT
END

SELECT DBO.FN_CAL_DISCOUNT(550)

--12) Write a UDF that assigns grades based on marks:
/*
>= 90: A
>= 75: B
>= 50: C
< 50: Fail
*/




--LOOP
--13) PRINT 1 TO N



CREATE OR ALTER FUNCTION FN_1TON(@NO INT)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @MSG VARCHAR(200),@COUNT INT
	SET @MSG=''

	SET @COUNT=1
	
	WHILE(@COUNT<=@NO)
	BEGIN
		SET @MSG=@MSG+ ' ' +CAST(@COUNT AS VARCHAR)--1 2 3
		SET @COUNT=@COUNT+1
	END
	RETURN @MSG
END

SELECT dbo.FN_1TON(15)

--14) sum of even no from 1 to 50
CREATE OR ALTER FUNCTION FN_even_1TO50()
RETURNS int
AS
BEGIN
	DECLARE @sum int,@I INT
	SET @sum=0
	SET @I=1
	WHILE(@I<=50)
	BEGIN
		IF(@I%2=0)
			SET @sum=@sum+@I
		SET @I=@I+1
	END
	RETURN @sum
END


SELECT DBO.FN_even_1TO50()

--15) FIND FACTORIAL 


CREATE or alter FUNCTION dbo.CalculateFactorial (@Number INT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @Result INT  = 1;

    WHILE @Number > 1
    BEGIN
        SET @Result = @Result * @Number;
        SET @Number = @Number - 1;
    END;

    RETURN @Result; 
END;


SELECT dbo.CalculateFactorial(5)

--16) check palindrome number
CREATE OR ALTER FUNCTION FN_PALINDROME(@NO INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @REV INT, @MSG VARCHAR(100)
	SET @MSG=''
	SET @REV=REVERSE(@NO)
	IF(@REV=@NO)
		SET @MSG='PALINDROME'
	ELSE
		SET @MSG='NON PALINDROME'
	RETURN @MSG
END


SELECT DBO.FN_PALINDROME(121)
SELECT DBO.FN_PALINDROME(120)

--CASE STATEMENT
--17) Function to Compare Two Integers Using CASE Statement
CREATE OR ALTER FUNCTION fn_CompareIntegers(@Num1 INT, @Num2 INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE 
               WHEN @Num1 > @Num2 THEN 'First is greater' 
               WHEN @Num1 < @Num2 THEN 'Second is greater' 
               ELSE 'Both are equal' 
           END
END;

Select dbo.fn_CompareIntegers(2,4)


CREATE OR ALTER FUNCTION fn_CompareIntegers1(@Num1 INT, @Num2 INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Result VARCHAR(20);

    SET @Result = CASE 
                     WHEN @Num1 > @Num2 THEN 'First is greater'
                     WHEN @Num1 < @Num2 THEN 'Second is greater'
                     ELSE 'Both are equal'
                 END;

    RETURN @Result;
END;

select dbo.fn_CompareIntegers1(20,20)


--18) RETURN DAY NAME BASED ON DAY NUMBER USING CASE STATEMENT
CREATE OR ALTER FUNCTION fn_Dayname(@dayno int)
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN CASE
				WHEN @dayno=1 THEN 'MONDAY'
				WHEN @dayno=2 THEN 'TUESDAY'
				WHEN @dayno=3 THEN 'WEDNESDAY'
				WHEN @dayno=4 THEN 'THRUSDAY'
				WHEN @dayno=5 THEN 'FRIDAY'
				WHEN @dayno=6 THEN 'SATURDAY'
				WHEN @dayno=7 THEN 'SUNDAY'
			END
END

SELECT dbo.fn_Dayname(2)


----Inline table valued functions----
--Return a table
--NO BEGIN–END block


--19) get person detail
CREATE OR ALTER FUNCTION fn_PERSONDETAIL()
RETURNS TABLE
AS
	RETURN(SELECT * FROM Person)



----how to call?
SELECT * from dbo.fn_PERSONDETAIL()


 select * from person
 select * from Department

--20) GIVE Persons Whose Names Start With a Given Letter
CREATE or ALTER FUNCTION fn_personByLetter(@Letter CHAR(1))
RETURNS TABLE
AS
RETURN
(
    SELECT * 
    FROM person
    WHERE FirstName LIKE @Letter + '%'
);

SELECT * FROM dbo.fn_personByLetter('h');

--21) GIVE Unique Department Names from department table
CREATE OR ALTER FUNCTION dbo.fn_UniqueDepartments()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT DeptName
    FROM Department
);


------MULTILINE TABLE VALUED FUNCTIONS-------
--22) GIVE PERSON NAME WITH DEPT NAME
CREATE OR ALTER FUNCTION FN_PERSONDEPT()
RETURNS @T1 TABLE(NAME VARCHAR(50), DEPTNAME VARCHAR(50))
AS
BEGIN
	INSERT INTO @T1
	
	SELECT PERSON.FirstName,
			Department.DeptName
	FROM PERSON
	INNER JOIN Department
	ON PERSON.DepartmentID=Department.DeptID
	RETURN
END

SELECT * FROM DBO.FN_PERSONDEPT()


---23) PRINT 1 TO N NUMBERS IN TABLE (MULTILINE TABLE VALUE FUNCTION)
CREATE OR ALTER FUNCTION fn_NumbersLoop(@n INT)
RETURNS @Numbers TABLE (num INT)
AS
BEGIN
    DECLARE @counter INT = 1;

    WHILE @counter <= @n
    BEGIN
        INSERT INTO @Numbers VALUES (@counter);
		SET @counter = @counter + 1;
    END

    RETURN;
END


SELECT num FROM dbo.fn_NumbersLoop(10); 
