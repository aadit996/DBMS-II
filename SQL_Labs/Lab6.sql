--Table : Log(LogMessage varchar(100), logDate Datetime) 

--CREATE TABLE LOG(
--				LogMessage varchar(100), 
--				LogDate Datetime
--);


SELECT * FROM LOG


--Part – A 
--1. Create trigger for printing appropriate message after student registration. 

GO
CREATE OR ALTER TRIGGER APP_MSG_ON_STU_REG
ON STUDENT
FOR INSERT
AS
BEGIN
     PRINT 'STUDENT WAS REGISTERED IN STUDENT TABLE'
END
GO

SELECT * FROM STUDENT

INSERT INTO STUDENT VALUES (69,'Aadit Moral','aa@univ.edu','9876543220','IT','2002-08-22',2022)

--2. Create trigger for printing appropriate message after faculty deletion. 

GO
CREATE OR ALTER TRIGGER FAC_DEL_MSG
ON FACULTY
FOR DELETE
AS
BEGIN
     PRINT 'A FACULTY RECORD FROM FACULTY TABLE WAS DELETE'
END
GO



--3. Create trigger for monitoring all events on course table. (print only appropriate message) 

GO
CREATE OR ALTER TRIGGER EVENTS_MONITERING
ON COURSE
FOR INSERT,UPDATE,DELETE
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

--4. Create trigger for logging data on new student registration in Log table. 

GO
CREATE OR ALTER TRIGGER LOG_REGISTRATION
ON STUDENT
AFTER INSERT
AS
BEGIN
    DECLARE @NAME VARCHAR(100)

    SELECT @NAME = inserted.StuName FROM INSERTED
     
     INSERT INTO LOG VALUES (@NAME+' WAS INSERTED INTO THE STUDENT TABLE ON REGISTRATION',GETDATE())
END
GO

INSERT INTO STUDENT VALUES (6967,'Aadit Moral','aa@univ.edu','9876543220','IT','2002-08-22',2022)

SELECT * FROM STUDENT

SELECT * FROM LOG

--5. Create trigger for auto-uppercasing faculty names. 

GO
CREATE OR ALTER TRIGGER FAC_NAME_UPPERCASE
ON FACULTY
AFTER INSERT
AS
BEGIN
       DECLARE @FacultyID INT
       
       SELECT @FacultyID = FacultyID FROM inserted

       UPDATE FACULTY
       SET FacultyName=UPPER(FacultyName)
       WHERE FACULTY.FacultyID=@FacultyID

END
GO

INSERT INTO FACULTY VALUES (67 ,'aadit moral', 'am@univ.edu', 'CSE', 'Professor', '2010-07-15')

select * from faculty

--6. Create trigger for calculating faculty experience (Note: Add required column in faculty table) 

GO
CREATE OR ALTER TRIGGER FAC_NAME_UPPERCASE
ON FACULTY
AFTER INSERT
AS
BEGIN
       DECLARE @FACID INT
       SELECT @FACID = FACULTYID FROM inserted

       UPDATE FACULTY
       SET EXPERIENCE = DATEDIFF(YEAR,FACULTY.FacultyJoiningDate,GETDATE())

END
GO  

INSERT INTO FACULTY VALUES (6969 ,'aadit moral', 'am@univ.edu', 'CSE', 'Professor', '2010-07-15','')

ALTER TABLE FACULTY
ADD EXPERIENCE INT

SELECT * FROM FACULTY

--Part – B 
--7. Create trigger for auto-stamping enrollment dates. 
GO
CREATE OR ALTER TRIGGER AUTO_STAMP_ENRO_DATES
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
    UPDATE E
    SET EnrollmentDate = GETDATE()
    FROM ENROLLMENT E
    INNER JOIN inserted i
        ON E.StudentID = i.StudentID
       AND E.CourseID = i.CourseID;
END
GO



--8. Create trigger for logging data After course assignment - log course and faculty detail. 

GO
CREATE OR ALTER TRIGGER COURSE_A_LOG
ON COURSE_ASSIGNMENT
AFTER INSERT
AS
BEGIN


    INSERT INTO LOG (LogMessage, LogDate)
    SELECT 
        CONCAT(f.FacultyName, ' TEACHES ', c.CourseName),
        GETDATE()
    FROM inserted i
    JOIN COURSE  c ON i.CourseID  = c.CourseID
    JOIN FACULTY f ON i.FacultyID = f.FacultyID;
END
GO


--Part - C 
--9. Create trigger for updating student phone and print the old and new phone number. 

GO
CREATE OR ALTER TRIGGER OLD_NEW_STU_PNO
ON STUDENT
AFTER UPDATE
AS
BEGIN
     DECLARE @OLDPNO VARCHAR(15)
     SELECT @OLDPNO = deleted.StuPhone FROM deleted

     DECLARE @NEWPNO VARCHAR(15)
     SELECT  @NEWPNO = inserted.StuPhone FROM inserted

     PRINT 'New phone number is '+CAST(@NEWPNO AS INT)+' and old phone number is '+ CAST (@OLDPNO AS INT)
END
GO

--10. Create trigger for updating course credit log old and new credits in log table. 

GO
CREATE OR ALTER TRIGGER LOG_COURSE_CREDITS
ON COURSE
AFTER UPDATE
AS
BEGIN
     
     INSERT INTO LOG (LogMessage,LogDate)
     SELECT CONCAT('OLD CC: ', d.CourseCredits, 
               ' NEW CC: ', i.CourseCredits),GETDATE()
               FROM deleted d
               join inserted i
               on d.CourseID=i.CourseID
               where d.CourseCredits not in (i.CourseCredits)

END
GO