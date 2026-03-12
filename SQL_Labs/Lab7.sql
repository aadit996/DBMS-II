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
      IF(EXISTS (SELECT inserted.CourseID FROM INSERTED) )
      BEGIN
              PRINT 'INSERT OPERATIONS WAS PERFORMED'
      END
      IF(EXISTS (SELECT inserted.CourseID FROM INSERTED) AND EXISTS (SELECT deleted.CourseID FROM DELETED))
      BEGIN
      PRINT 'UPDATE OPERATIONS WAS PERFORMED'
          
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
    IF UPDATE(EnrollmentYear)
    BEGIN
        PRINT 'students are not allowed to update their enrollment year'
    END
END
GO


--6. Create trigger for student age validation (Min 18). 
--Part – B 
--7. Create trigger for unique faculty’s email check. 
--8. Create trigger for preventing duplicate enrollment. 
--Part - C 
--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment 
--closed. 
--10. Create trigger to Allow only grade change in enrollment (block other updates)