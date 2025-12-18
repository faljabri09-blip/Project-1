create database Library 

USE Library


---create library table 

create table Library (
library_id int primary key identity(1,1),
Library_Name varchar(20) NOT NULL UNIQUE,
Location varchar(20) NOT NULL,
Contact_no int NOT NULL,
Estableshed_year int
)


--- create Staff table 

create table Staff(
Staff_id int primary key identity(101,1),
FullName varchar(20) NOT NULL,
Position varchar(30) NOT NULL,
Contact_num int NOT NULL,
library_id int,
CONSTRAINT FK_library_id
FOREIGN KEY (library_id)
REFERENCES Library(library_id)
ON DELETE CASCADE
ON UPDATE CASCADE
)


---Alter staff id in library table

ALTER TABLE Library
ADD Staff_id int FOREIGN KEY REFERENCES Staff(Staff_Id)

---Alter book id in library table

ALTER TABLE Library
ADD book_id int FOREIGN KEY REFERENCES Book(book_id)

---create Book table

create table Book (
book_id int primary key identity(201,1),
book_title varchar(20) NOT NULL,
gener varchar(20) NOT NULL CHECK(gener IN('Fiction','Non fiction','Reference','Children')),
price decimal(3,2) CHECK(price > 0), 
Avalability_status bit default 1,
shef_location varchar(15) NOT NULL,
ISBN varchar(13) NOT NULL UNIQUE,
library_id int,
CONSTRAINT FK_library
FOREIGN KEY (library_id)
REFERENCES Library(library_id)
ON DELETE CASCADE
ON UPDATE CASCADE
)


---Alter review_id in Book table

ALTER TABLE Book
ADD review_id int FOREIGN KEY REFERENCES Review(review_id)

---Alter member_id in Book table

ALTER TABLE Book
ADD member_id int FOREIGN KEY REFERENCES Member(member_id)

---Alter loan_id in Book table

ALTER TABLE Book
ADD loan_id int FOREIGN KEY REFERENCES Loan(loan_id)

---- create loan table

create table Loan(
loan_id int primary key identity(301,1),
loan_status varchar(15) CHECK(loan_status IN('Issued', 'Returned','Overdue')) default 'Issued',
loan_date date NOT NULL,
due_date date NOT NULL,
return_date date,
book_id int,
CONSTRAINT FK_book_id
FOREIGN KEY (book_id)
REFERENCES Book(book_id)
ON DELETE CASCADE
ON UPDATE CASCADE
)

---Alter payment_id in Loan table

ALTER TABLE Loan
ADD payment_id int FOREIGN KEY REFERENCES Payment(payment_id)

---Alter member_id in Book table

ALTER TABLE Loan
ADD member_id int FOREIGN KEY REFERENCES Member(member_id)

---create Payment table 

create table Payment(
payment_id int primary key identity(401,1),
payment_date date NOT NULL,
Amount decimal(10,2) CHECK(Amount > 0),
Method varchar(20),
loan_id int,
CONSTRAINT FK_loan_id
FOREIGN KEY (loan_id)
REFERENCES Loan(loan_id)
ON DELETE CASCADE
ON UPDATE CASCADE
)

create table Member(
member_id int primary key identity(501,1),
member_Email varchar(50) NOT NULL UNIQUE,
FullName varchar(50),
Start_date date NOT NULL,
Mempership varchar(30) NOT NULL,
loan_id int,
book_id int,
CONSTRAINT FK_Loan
FOREIGN KEY (loan_id)
REFERENCES Loan(loan_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT FK_Book_member
FOREIGN KEY (book_id)
REFERENCES Book(book_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION

)

---Alter review_id in Member table

ALTER TABLE Member
ADD review_id int FOREIGN KEY REFERENCES Review(review_id)

create table Review(
review_id int primary key identity(601,1),
review_date date NOT NULL,
rating decimal(10,2) CHECK(rating between 1 and 5) NOT NULL,
comments varchar(50) default 'NO comments',
member_id int,
book_id int,
CONSTRAINT FK_member_id
FOREIGN KEY (member_id)
REFERENCES Member(member_id)
ON DELETE CASCADE
ON UPDATE CASCADE,


CONSTRAINT FK_Book_review
FOREIGN KEY (book_id)
REFERENCES Book(book_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION

)

----insert into Library table

INSERT INTO Library(Library_Name,Location,Contact_no,Estableshed_year,Staff_id,book_id) VALUES 
('Central Library', 'Muscat', '24567890', 2010),
('City Knowledge', 'Salalah', '23214567', 2015), 
('University Library', 'Nizwa', '25478963', 2008),
('Public Reading Hall', 'Sohar', '26894512', 2020)

UPDATE Library
SET Staff_id = 101 , book_id= 226
WHERE Library_Name = 'Central Library';

UPDATE Library
SET Staff_id = 102 , book_id= 227
WHERE Library_Name = 'City Knowledge';

UPDATE Library
SET Staff_id = 103 , book_id= 228
WHERE Library_Name = 'University Library';

UPDATE Library
SET Staff_id = 104 , book_id= 229
WHERE Library_Name = 'Public Reading Hall';

select * from Library

-----INSERT INTO Staff table

INSERT INTO Staff(FullName,Position,Contact_num,library_id) VALUES
('Ahmed Al-Jabri', 'Librarian', '91234567', 3),
('Fatma Al-Jabri', 'Assistant Librarian', '92345678', 4),
('Mhammed Al-Nayadi', 'Archivist', '93456789', 5),
('Aisha Al-Mammari', 'Library Manager', '94567890', 6)

select * from Staff

----INSERT INTO Book table 

INSERT INTO Book(book_title,gener,price,Avalability_status,shef_location,ISBN,library_id,loan_id) VALUES 
('Database Systems', 'Fiction', 1.55, 1, 'A1-S3', '9780073523323', 3,305),
('SQL Introduction', 'Non fiction', 3.25, 1, 'B2-S1', '9780131873254', 4,306),
('Clean Code', 'Reference', 9.99, 1, 'C3-S2', '9780132350884', 5,307),
('Data Modeling ', 'Children', 22.1, 1, 'A2-S4', '9780123742255', 6,308)
 
--- insert loan_id forign key because ISBN UNIQUE must use UPDATE to insert loan_id 
UPDATE Book
SET loan_id = 305 ,review_id= 601, member_id= 502
WHERE ISBN = 9780073523323;

UPDATE Book
SET loan_id = 306 , review_id= 602, member_id= 503
WHERE ISBN = 9780131873254;

select * from member
UPDATE Book
SET loan_id = 307, review_id= 603, member_id= 504
WHERE ISBN = 9780132350884;

UPDATE Book
SET loan_id = 308 ,review_id= 604, member_id= 505
WHERE ISBN = 9780123742255;

select * from Book

----INSERT INTO Loan table

INSERT INTO Loan(loan_status,loan_date,due_date,return_date,book_id,member_id,payment_id) VALUES
('Overdue', '2025-11-01', '2025-11-10','2025-11-20',226,502,401),
('Returned', '2025-11-05', '2025-11-20', '2025-11-18',227,503,402),
('Issued', '2025-12-10', '2025-12-25','2025-11-20',228,504,403),
('Returned', '2025-11-10', '2025-11-25', '2025-11-23',229,505,404)

select * from Loan

-----insert into Payment table

INSERT INTO Payment(payment_date,Amount,Method,loan_id) VALUES
('2025-12-01', 50.00, 'Cash',301),
('2025-12-01', 50.00, 'Cash',302),
('2025-12-01', 50.00, 'Cash',304),
('2025-12-01', 50.00, 'Cash',305)

select * from Payment

---INSERT INTO Member table 

INSERT INTO Member(FullName,member_Email,Start_date,Mempership,loan_id,book_id,Phone_no) VALUES 
('Fatma Aljabri','fatma.aljabri@gimal.com', '2025-12-01', 'Regular', 301, 226 , '99123456'),
('Ahmed Al-Harthy','ahmed.harthy@gimal.com', '2025-11-15', 'Gold', 302, 227, '99887766'),
('Sara Al-Mahri',  'sara.almahri@gimal.com','2025-12-05', 'Silver', 303, 228, '99775544'),
('Omar Al-Kindi',  'Omar.Kindi@gimal.com','2025-12-10', 'Regular', 304, 229, '99664433')

UPDATE Member
SET review_id = 601
WHERE member_Email = 'fatma.aljabri@gimal.com';

UPDATE Member
SET review_id = 602
WHERE member_Email = 'ahmed.harthy@gimal.com';

UPDATE Member
SET review_id = 603
WHERE member_Email = 'sara.almahri@gimal.com';

UPDATE Member
SET review_id = 604
WHERE member_Email = 'Omar.Kindi@gimal.com';

select * from Member

-----insert into Review

Insert into Review(review_date,rating,member_id,book_id) VALUES
('2025-12-01', 4.5,502,226),
('2025-12-01', 3.0,503,227),
('2025-12-01', 5.00,504,228),
('2025-12-01', 4.0,505,229)

select * from Review


-----DQL 

--Q1
select * from Book

--Q2

SELECT book_title, gener , Avalability_status FROM Book  

---Q3 

select FullName, member_Email , Mempership, Start_date FROM Member


---Q4

select book_title , price AS BookPrice From Book

---Q5

select  book_title ,price AS BookPrice
from Book
where price > 250

---Q6

select FullName , Start_date
from Member 
where Start_date > '2023'  


---Q7

SELECT Library_Name, Estableshed_year AS books_published
from Library
WHERE Estableshed_year > 2018   


---Q8

select book_title , price
FROM Book
order by price desc                 

---Q9

select MAX(price), MIN(price), AVG(price) AS BookPrice     
FROM Book

---Q10 

select COUNT(*) AS Book_Number FROM Book    


---Q11

select FullName , member_Email
FROM Member
WHERE member_Email is NULL          


---Q12

select book_title
FROM Book
where book_title LIKE '%Data%'       


----DML 

---Q1
---- Can not but member id = 405 because it is identety

INSERT INTO Member(member_id,member_Email,Start_date,Mempership,loan_id,book_id,Phone_no) VALUES 
(405,'Fatma Aljabri','fatma.aljabri@gimal.com', '1995-12-25', 'Regular', 301, 226 , '93397328')

----Q2
---Email cant not be NULL
INSERT INTO Member(member_id,member_Email,Start_date,Mempership,loan_id,book_id,Phone_no) 
VALUES 
(405,'Fatma Aljabri',NULL, '1995-12-25', 'Regular', 301, 226 , NULL)

----Q3

UPDATE Loan
SET return_date = GETDATE()


----Q4

UPDATE Book
SET price = price * 1.05
WHERE price < 200


----Q5

SELECT FullName, Start_date
FROM Member
WHERE Start_date >= DATEADD(MONTH, -1, GETDATE())  


----Q6

DELETE FROM Member
WHERE loan_id IS NULL    
