/********************************************************************
Name    : School Database Script
Author  : imran imtiaz

Purpose : This script will create the School database and its tables
          to store information about the school, courses, students, 
          and enrollments.

**********************************************************************/

-- Create School database
CREATE DATABASE School;
GO
USE School;
GO

-- Create CourseMaster table
CREATE TABLE CourseMaster (
    CID INT PRIMARY KEY,
    CourseName VARCHAR(40) NOT NULL,
    Category CHAR(1) NULL CHECK (Category IN ('B', 'M', 'A')),
    Fee SMALLMONEY NOT NULL CHECK (Fee > 0)
);
GO

-- Display CourseMaster schema
EXEC sp_help 'CourseMaster';
GO

-- Insert data into CourseMaster
INSERT INTO CourseMaster (CID, CourseName, Category, Fee) VALUES
(10, 'Java', 'B', 5000),
(20, 'Adv Java', 'A', 25000),
(30, 'Big Data', 'A', 40000),
(40, 'Sql Server', 'M', 20000),
(50, 'Oracle', 'M', 15000),
(60, 'Python', 'M', 15000),
(70, 'MSBI', 'A', 35000),
(80, 'Data Science', 'A', 90000),
(90, 'Data Analyst', 'A', 120000),
(100, 'Machine Learning', 'A', 125000),
(110, 'Basic C++', 'B', 10000),
(120, 'Intermediate C++', 'M', 15000),
(130, 'Dual C & C++', 'M', 20000),
(140, 'Azure', 'B', 35000),
(150, 'Microsoft Office Intermediate', 'B', 22000);
GO

-- Select data from CourseMaster
SELECT * FROM CourseMaster;
GO

-- Create StudentMaster table
CREATE TABLE StudentMaster (
    SID TINYINT PRIMARY KEY,
    Name VARCHAR(40) NOT NULL,
    Origin CHAR(1) NOT NULL CHECK (Origin IN ('L', 'F')),
    Type CHAR(1) NOT NULL CHECK (Type IN ('U', 'G'))
);
GO

-- Insert data into StudentMaster
INSERT INTO StudentMaster (SID, Name, Origin, Type) VALUES
(1, 'Bilen Haile', 'F', 'G'),
(2, 'Durga Prasad', 'L', 'U'),
(3, 'Geni', 'F', 'U'),
(4, 'Gopi Krishna', 'L', 'G'),
(5, 'Hemanth', 'L', 'G'),
(6, 'K Nitish', 'L', 'G'),
(7, 'Amit', 'L', 'G'),
(8, 'Aman', 'L', 'U'),
(9, 'Halen', 'F', 'G'),
(10, 'John', 'F', 'U'),
(11, 'Anil', 'L', 'U'),
(12, 'Mike', 'F', 'G'),
(13, 'Suman', 'L', 'U'),
(14, 'Angelina', 'F', 'G'),
(15, 'Bhavik', 'L', 'U'),
(16, 'Bob Tyson', 'F', 'G'),
(17, 'Salman', 'L', 'U'),
(18, 'Selina', 'F', 'G'),
(19, 'Rajkummar', 'L', 'U'),
(20, 'Pooja', 'L', 'U');
GO

-- Select data from StudentMaster
SELECT * FROM StudentMaster;
GO

-- Create EnrollmentMaster table
CREATE TABLE EnrollmentMaster (
    CID INT NOT NULL FOREIGN KEY REFERENCES CourseMaster(CID),
    SID TINYINT NOT NULL FOREIGN KEY REFERENCES StudentMaster(SID),
    DOE DATETIME NOT NULL,
    FWF BIT NOT NULL,
    Grade CHAR(1) NULL CHECK (Grade IN ('O', 'A', 'B', 'C'))
);
GO

-- Insert data into EnrollmentMaster
INSERT INTO EnrollmentMaster (CID, SID, DOE, FWF, Grade) VALUES
(40, 1, '2020-11-19', 0, 'O'),
(70, 1, '2020-11-21', 0, 'O'),
(30, 2, '2020-11-22', 1, 'A'),
(60, 4, '2020-11-25', 1, 'O'),
(40, 5, '2020-12-02', 1, 'C'),
(50, 7, '2020-12-05', 0, 'B'),
(50, 4, '2020-12-10', 0, 'A'),
(80, 3, '2020-11-11', 1, 'O'),
(80, 4, '2020-12-22', 0, 'B'),
(70, 6, '2020-12-25', 0, 'A'),
(60, 7, '2021-01-01', 0, 'A'),
(40, 8, '2021-01-02', 1, 'O'),
(80, 9, '2021-01-03', 0, 'B'),
(20, 4, '2021-01-04', 0, 'A'),
(40, 9, '2021-04-01', 1, 'O'),
(90, 4, '2021-04-05', 0, 'A'),
(30, 11, '2021-04-08', 0, 'A'),
(110, 11, '2021-04-11', 1, 'B'),
(30, 18, '2021-04-12', 1, 'A'),
(130, 12, '2021-04-13', 0, 'B'),
(40, 10, '2021-04-18', 1, 'O'),
(150, 12, '2021-04-22', 1, 'A'),
(70, 17, '2021-04-25', 0, 'B'),
(120, 1, '2021-04-30', 0, 'O'),
(90, 8, '2021-05-02', 0, 'A'),
(100, 18, '2021-05-05', 0, 'B'),
(90, 10, '2021-05-12', 1, 'O'),
(110, 15, '2021-05-15', 0, 'B'),
(120, 5, '2021-05-20', 1, 'A'),
(130, 6, '2021-05-25', 1, 'O'),
(140, 15, '2021-05-28', 0, 'A'),
(120, 6, '2021-05-31', 0, 'B'),
(150, 5, '2021-06-12', 1, 'A'),
(80, 8, '2021-06-15', 1, 'B'),
(140, 14, '2021-06-20', 0, 'O'),
(90, 3, '2021-06-23', 1, 'O'),
(100, 3, '2021-07-02', 0, 'A'),
(40, 13, '2021-07-22', 0, 'B');
GO

-- Select data from EnrollmentMaster
SELECT * FROM EnrollmentMaster;
GO

-- Update DOE in EnrollmentMaster
UPDATE EnrollmentMaster
SET DOE = '2022-09-12'
WHERE DOE > '2021-05-01';
GO
