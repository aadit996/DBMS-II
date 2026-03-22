--Table : Log(LogMessage varchar(100), logDate Datetime)

SELECT * FROM LOG

--Part – A 
--1. Create trigger for blocking student deletion. 

GO
CREATE OR ALTER TRIGGER BLOCKING_STUDENT_DEL
ON STUDENT
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'STUDENT CANNOT BE DELETED'
END
GO

SELECT * FROM STUDENT

DELETE FROM STUDENT WHERE STUDENT.StudentID=69

DROP TRIGGER BLOCKING_STUDENT_DEL

--2. Create trigger for making course read-only. 

GO
CREATE OR ALTER TRIGGER COURSE_READ_ONLY
ON COURSE
INSTEAD OF UPDATE,INSERT,DELETE
AS
BEGIN
      
      IF(EXISTS (SELECT inserted.CourseID FROM INSERTED) AND EXISTS (SELECT deleted.CourseID FROM DELETED))
      BEGIN
      PRINT 'UPDATE OPERATIONS WAS PERFORMED'
          
      END

      ELSE IF(EXISTS (SELECT inserted.CourseID FROM INSERTED) )
      BEGIN
              PRINT 'INSERT OPERATIONS WAS PERFORMED'
      END
      
      ELSE
      BEGIN
                 PRINT 'DELETE OPERATIONS WAS PERFORMED'
      END     
END
GO

SELECT * FROM COURSE

DELETE FROM COURSE WHERE CourseID = 'CS101'

DROP TRIGGER COURSE_READ_ONLY

--3. Create trigger for preventing faculty removal. 

GO
CREATE OR ALTER TRIGGER FAC_NOT_REMOVE
ON FACULTY
INSTEAD OF DELETE
AS
BEGIN
      PRINT 'FACULTY CANNOT BE DELETED'
END
GO

SELECT * FROM FACULTY

DELETE FROM FACULTY WHERE FACULTYID = 67

DROP TRIGGER  FAC_NOT_REMOVE

--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE) into Log table. 
--(Example: INSERT/UPDATE/DELETE operations are blocked for you in course table) 

GO
CREATE OR ALTER TRIGGER LOG_COURSE_OPS
ON COURSE
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN

    -- UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG 
        VALUES ('UPDATE OPERATION WAS PERFORMED', GETDATE())
    END

    -- INSERT
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG 
        VALUES ('INSERT OPERATION WAS PERFORMED', GETDATE())
    END

    -- DELETE
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG 
        VALUES ('DELETE OPERATION WAS PERFORMED', GETDATE())
    END

END
GO

SELECT * FROM COURSE

DELETE FROM COURSE WHERE CourseID = 'CS101'
SELECT * FROM LOG
DROP TRIGGER LOG_COURSE_OPS

--5. Create trigger to Block student to update their enrollment year and print message ‘students are not 
--allowed to update their enrollment year’ 

GO
CREATE OR ALTER TRIGGER TR_BLOCK_ENROLLMENT_YEAR_UPDATE
ON STUDENT
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(StuEnrollmentYear)
    BEGIN
        PRINT 'students are not allowed to update their enrollment year'
    END
END
GO

UPDATE STUDENT
SET StuEnrollmentYear = 6767
WHERE StudentID = 67

SELECT * FROM STUDENT

DROP TRIGGER TR_BLOCK_ENROLLMENT_YEAR_UPDATE


--6. Create trigger for student age validation (Min 18).

GO
CREATE OR ALTER TRIGGER AGE_18_MIN_VALD
ON STUDENT
INSTEAD OF INSERT
AS 
BEGIN
       DECLARE @DOB DATE 
       
       SELECT @DOB = inserted.StuDateOfBirth FROM inserted

       IF((DATEPART(YEAR,GETDATE()) - DATEPART(YEAR,@DOB))<18)
       BEGIN 
                  PRINT 'MINIMUM AGE MUST BE 18'
       END 
       ELSE 
       BEGIN 
           INSERT INTO STUDENT
           SELECT * FROM inserted
       END 

END
GO


INSERT INTO STUDENT VALUES (6767	,'Aadit Moral','aa@univ.edu',9876543220,'IT','2020 -08-22'	,2022)

SELECT * FROM STUDENT                                    


DROP TRIGGER AGE_18_MIN_VALD



--Part – B 
--7. Create trigger for unique faculty’s email check. 

GO
CREATE OR ALTER TRIGGER FAC_UNIQUE_ID
ON FACULTY
INSTEAD OF INSERT,UPDATE
AS
BEGIN
       DECLARE @FAC_EM VARCHAR(100)
       DECLARE @FAC_ID INT = 0
       
       SELECT @FAC_EM = FacultyEmail FROM inserted
       SELECT @FAC_ID = FacultyID FROM inserted

       IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
              IF (EXISTS(SELECT * FROM FACULTY WHERE FacultyEmail = @FAC_EM AND FacultyID <> @FAC_ID))
              BEGIN
              PRINT 'PLEASE ENTER UNIQUE FACULTY EMAIL'
              END

              ELSE
              BEGIN
                    UPDATE FACULTY
                    SET FacultyEmail = @FAC_EM
                    WHERE FacultyID = @FAC_ID
              END
    END

    -- INSERT
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN

                IF (EXISTS(SELECT * FROM FACULTY WHERE FacultyEmail = @FAC_EM))
              BEGIN
              PRINT 'PLEASE ENTER UNIQUE FACULTY EMAIL'
              END

              ELSE
              BEGIN
                    INSERT INTO FACULTY
                    SELECT * FROM inserted
              END
        
    END

END
GO

update FACULTY
set FacultyEmail = 'patel@univ.edu'
where FacultyID = 104

drop trigger FAC_UNIQUE_ID

--GO
--CREATE OR ALTER TRIGGER FAC_UNIQUE_EMAIL
--ON FACULTY
--INSTEAD OF INSERT, UPDATE
--AS
--BEGIN

--    IF EXISTS (
--        SELECT 1
--        FROM inserted i
--        JOIN FACULTY f
--        ON i.FacultyEmail = f.FacultyEmail AND i.FacultyID <> f.FacultyID
--        checkes same email exists with differenet id
--    )
--    BEGIN
--        PRINT 'PLEASE ENTER UNIQUE FACULTY EMAIL'
--        RETURN
--    END

--    -- INSERT
--    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
--    BEGIN
--        INSERT INTO FACULTY
--        SELECT * FROM inserted
--    END

--    -- UPDATE
--    ELSE IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
--    BEGIN
--        UPDATE FACULTY
--        SET FacultyEmail = i.FacultyEmail
--        FROM inserted i
--        WHERE FACULTY.FacultyID = i.FacultyID
--    END

--END
--GO

DROP TRIGGER FAC_UNIQUE_ID

--8. Create trigger for preventing duplicate enrollment. 


GO
CREATE OR ALTER TRIGGER PREV_DUP_ENRO
ON ENROLLMENT
INSTEAD OF INSERT, UPDATE
AS
BEGIN

    DECLARE @CID VARCHAR(10)
    DECLARE @SID INT
    DECLARE @EID INT

    SELECT @CID = CourseID, 
           @SID = StudentID, 
           @EID = EnrollmentID
    FROM inserted

    -- Check duplicate enrollment
    IF EXISTS (
        SELECT *
        FROM ENROLLMENT
        WHERE StudentID = @SID 
        AND CourseID = @CID
        AND EnrollmentID <> @EID
    )
    BEGIN
        PRINT 'SAME STUDENT CANNOT BE ENROLLED IN THE SAME COURSE TWICE'
    END

    -- UPDATE
    ELSE IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE ENROLLMENT
        SET StudentID = @SID,
            CourseID = @CID
        WHERE EnrollmentID = @EID
    END

    -- INSERT
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO ENROLLMENT
        SELECT * FROM inserted
    END

END
GO

--SELECT COUNT(STUDENTID)
--FROM ENROLLMENT
--WHERE StudentID = 1 AND CourseID='CS101'

DROP TRIGGER PREV_DUP_ENRO

--Part - C 
--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment 
--closed. 

GO
CREATE OR ALTER TRIGGER ENRO_DATE
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
           DECLARE @ED DATE

           SELECT @ED = EnrollmentDate FROM inserted

           IF(DATEPART(MONTH,@ED) BETWEEN 1 AND 8)
           BEGIN
                 INSERT INTO ENROLLMENT
                 SELECT * FROM inserted
           END
           
           ELSE
           BEGIN
                 PRINT 'ENROLLMENT CLOSE'
           END

END
GO

--10. Create trigger to Allow only grade change in enrollment (block other updates)

GO
CREATE OR ALTER TRIGGER GRADE_CHANGE_ONLY
ON ENROLLMENT
INSTEAD OF UPDATE
AS
BEGIN
       DECLARE @G VARCHAR(2)
       DECLARE @EID INT

       SELECT @EID = EnrollmentID FROM INSERTED
       SELECT @G = Grade FROM inserted

       UPDATE ENROLLMENT
       SET Grade = @G
       WHERE EnrollmentID=@EID


END
GO


--GO
--CREATE OR ALTER TRIGGER GRADE_CHANGE_ONLY
--ON ENROLLMENT
--INSTEAD OF UPDATE
--AS
--BEGIN

--    IF UPDATE(StudentID) OR UPDATE(CourseID) 
--       OR UPDATE(EnrollmentDate) OR UPDATE(EnrollmentStatus)
--    BEGIN
--        PRINT 'ONLY GRADE CAN BE UPDATED'
--    END

--    ELSE
--    BEGIN
--        UPDATE ENROLLMENT
--        SET Grade = i.Grade
--        FROM inserted i
--        WHERE ENROLLMENT.EnrollmentID = i.EnrollmentID
--    END

--END
--GO


SELECT name
FROM sys.triggers
WHERE parent_id = OBJECT_ID('ENROLLMENT');