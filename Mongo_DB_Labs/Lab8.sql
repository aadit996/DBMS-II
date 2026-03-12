--Part – A 
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error. 

BEGIN TRY
    DECLARE @A INT = 10
    DECLARE @B INT = 0
    DECLARE @C INT
    SET @C = @A/@B

    PRINT 'Result = ' + CAST(@C AS VARCHAR)

END TRY
BEGIN CATCH
     PRINT 'Error occurs that is - Divide by zero error.'
END CATCH


--2. Try to convert string to integer and handle the error using try…catch block. 

BEGIN TRY
       DECLARE @name VARCHAR(100) = 'AADIT'-- WORKS FOR NUMBER
       PRINT CAST(@name as INT)
END TRY
BEGIN CATCH
          PRINT 'CANNOT CAST STRING TO INT'
END CATCH

--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result.   

GO
CREATE OR ALTER PROCEDURE TWO_NUM_SUM
@A VARCHAR(20),@B VARCHAR(20)
AS
BEGIN
       DECLARE @SUM INT = 0

       BEGIN TRY
           SET @SUM = CAST(@A AS INT)+CAST(@B AS INT)
           PRINT 'RESULT : '+CAST(@SUM AS VARCHAR)
       END TRY
       BEGIN CATCH
             PRINT 'NUMBERS CANNOT BE STRING'
       END CATCH

END
GO

EXEC TWO_NUM_SUM 1,'EFOI'

--4. Handle a Primary Key Violation while inserting data into student table and print the error details such 
--as the error message, error number, severity, and state. 


BEGIN TRY
         INSERT INTO STUDENT VALUES(1, 'Raj Patel', '@univ.edu', 9876543210, 'CSE' ,'2003-05-15', 2021 )
END TRY
BEGIN CATCH 

      PRINT 'PK VIOLATION'
      SELECT ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE()     
END CATCH

SELECT * FROM STUDENT


--5. Throw custom exception using stored procedure which accepts StudentID as input & that throws 
--Error like no StudentID is available in database. 
--6. Handle a Foreign Key Violation while inserting data into Enrollment table and print appropriate error 
--message. 
--Part – B 
--7. Handle Invalid Date Format 
--8. Procedure to Update faculty’s Email with Error Handling. 
--9. Throw custom exception that throws error if the data is invalid. 
--Part – C 
--10. Write a script that checks if a faculty’s salary is NULL. If it is, use RAISERROR to show a message with a 
--severity of 16. (Note: Do not use any table)