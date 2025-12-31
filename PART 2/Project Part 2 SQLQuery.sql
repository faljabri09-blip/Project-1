---Project part 2 

---Section 1 
--Q1

SELECT 
    l.Library_Name,
    COUNT(b.book_id) AS TotalBooks,
    SUM(CASE WHEN b.Avalability_status = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN b.Avalability_status = 1 THEN 1 ELSE 0 END) AS BooksOnLoan
FROM Library l
LEFT JOIN Book b ON l.library_id = b.library_id
GROUP BY l.Library_Name

---Q2

SELECT 
    m.FullName AS MemberName,
    m.Email,
    b.book_title AS BookTitle,
    lo.loan_date,
    lo.due_date,
    lo.loan_status
FROM Loan lo
JOIN Member m ON lo.member_id = m.member_id
JOIN Book b ON lo.book_id = b.book_id
WHERE lo.loan_status IN ('Issued', 'Overdue')


ALTER TABLE Member
ADD Email nvarchar(50)

----Q3

SELECT 
    m.FullName AS MemberName,
    m.Phone_no,
    b.book_title AS BookTitle,
    l.Library_Name,
    DATEDIFF(DAY, lo.due_date, GETDATE()) AS DaysOverdue,
    lo.FinePaid
FROM Loan lo
JOIN Member m ON lo.member_id = m.member_id
JOIN Book b ON lo.book_id = b.book_id
JOIN Library l ON b.library_id = l.library_id
WHERE lo.loan_status = 'Overdue'

ALTER TABLE Loan
ADD FinePaid DECIMAL(10,2)

---Q4 

SELECT 
       L.Library_Name,
	   f.FullName AS StaffName,
	   f.Position,
	   COUNT(b.book_id) AS BooksManaged
FROM Library L
JOIN Staff f on f.library_id = l.library_id
JOIN Book b on b.library_id = l.library_id
GROUP BY l.Library_Name, f.FullName, f.Position

----Q5

SELECT 
       b.book_title,
	   b.ISBN,
	   b.gener,
	   COUNT(L.loan_id) AS TotalLoan,
	   AVG(r.rating) AS AverageReview
FROM Book b
JOIN Loan l on b.book_id = l.book_id
JOIN Review r on r.book_id = b.book_id
GROUP BY b.book_title, b.ISBN, b.gener
HAVING COUNT(l.loan_id) >= 3

---Q6

SELECT 
       m.FullName AS MemberName,
	   b.book_title,
	   l.loan_date AS LoanDate,
	   l.return_date AS ReturnDate,	
	   r.rating
FROM Member m
JOIN Book b on m.book_id = b.book_id
JOIN Loan l on l.member_id = m.member_id
LEFT JOIN Review r on r.member_id = m.member_id
AND r.book_id = b.book_id

----Q7 

SELECT 
       b.gener,
       COUNT(l.FinePaid) AS BookGenre,
	   SUM(L.FinePaid) AS TotalFinesCollected,
	   AVG(l.FinePaid) AS AverageFinePerLoan      
FROM Loan l 
JOIN Book b on b.loan_id = l.loan_id
GROUP BY b.gener


select * from Book

INSERT INTO Book (book_title, ISBN, gener, Avalability_status,price,shef_location,library_id) VALUES
('SQL Basics', '978-001', 'Fiction',1,222,121,6),
('Advanced SQL', '978-002', 'Non Fiction',0,202,123, 5),
('Python Programming', '978-003', 'Fiction', 1,23,234, 4),
('Java Essentials', '978-004', 'Reference', 1,23,456,3),
('C# Fundamentals', '978-005', 'Children',1,45,789,6),
('Algorithms Unlocked', '978-006', 'Reference',1,23,456,5),
('Data Structures', '978-007', 'Fiction',1,45,567,4),
('Machine Learning', '978-008', 'Non Fiction',1,12,456,3),
('Deep Learning', '978-009', 'Reference',1,34,456,6),
('AI Ethics', '978-010', 'Children',1,21,453,5),
('Web Development', '978-011', 'Fiction',1,76,234,4),
('HTML & CSS', '978-012', 'Non Fiction',1,8,678,3),
('JavaScript Basics', '978-013', 'Reference',1,10,345,6),
('React Guide', '978-014', 'Reference',1,45,897,5),
('Node.js Essentials', '978-015', 'Children',1,32,345,4),
('Cloud Computing', '978-016', 'Fiction',1,34,456,3)

INSERT INTO Member (FullName, member_Email, Phone_no,Mempership,Start_date) VALUES
('Ahmed Ali', 'ahmed.ali@example.com', '9715000','gold','2023-10-10'),
('Sara Hassan', 'sara.hassan@example.com', '9715000','silver','2022-12-11'),
('Omar Khalid', 'omar.khalid@example.com', '97150000','regular','2021-6-5'),
('Fatma Aljabri', 'fatma.aljabri@example.com', '97150000','silver','2023-9-22'),
('Hani Youssef', 'hani.youssef@example.com', '9715000','regular','2022-8-18'),
('Mona Adel', 'mona.adel@example.com', '97150000','gold','2023-11-11')

select * from Member

INSERT INTO Loan (book_id, member_id, loan_date, due_date, return_date, loan_status, FinePaid) VALUES
(226, 502, '2025-12-01', '2025-12-10', NULL, 'Issued', 0),
(227, 503, '2025-11-20', '2025-11-30', NULL, 'Overdue', 15)

select * from Member


----section 2

----Q8

SELECT 
    DATENAME(MONTH, loan_date) AS MonthName,
    COUNT(*) AS TotalLoans,
    SUM(CASE WHEN loan_status = 'Returned' THEN 1 ELSE 0 END) AS TotalReturned,
    SUM(CASE WHEN loan_status IN ('Issued', 'Overdue') THEN 1 ELSE 0 END) AS TotalActive
FROM Loan
WHERE YEAR(loan_date) = YEAR(GETDATE())
GROUP BY MONTH(loan_date), DATENAME(MONTH, loan_date)

----Q9

SELECT 
    m.FullName AS MemberName,
    COUNT(l.loan_id) AS TotalBooksBorrowed,
    SUM(CASE WHEN l.loan_status IN ('Issued', 'Overdue') THEN 1 ELSE 0 END) AS TotalBooksOnLoan,
    SUM(l.FinePaid) AS TotalFinesPaid,
    AVG(r.Rating) AS AvgRating
FROM Member m
JOIN Loan l ON m.member_id = l.member_id
LEFT JOIN Review r 
    ON r.member_id = m.member_id AND r.book_id = l.book_id
GROUP BY m.member_id, m.FullName
HAVING COUNT(l.loan_id) > 0

---Q10

SELECT 
    l.Library_Name,
    COUNT(b.book_id) AS TotalBooksOwned,
    COUNT(DISTINCT lo.member_id) AS TotalActiveMembers,
    SUM(lo.FinePaid) AS TotalRevenueFromFines,
    CAST(COUNT(b.book_id) AS FLOAT) / NULLIF(COUNT(DISTINCT lo.member_id), 0) AS AvgBooksPerMember
FROM Library l
LEFT JOIN Book b ON l.library_id = b.library_id
LEFT JOIN Loan lo ON b.book_id = lo.book_id
GROUP BY l.library_id, l.Library_Name

----Q11

SELECT 
     book_title,
     gener,
     Price,
     AVG(Price) AS AvgPrice,
     Price - AVG(Price) AS DifferenceFromAverage
FROM Book 
GROUP BY gener, price,book_title

----Q12

SELECT 
      Method,
	  COUNT(*) NumberTransaction,
	  SUM(Amount) AS TotalAmount,
	  AVG(Amount) AS AvrageAmount,
	  (SUM(Amount) * 100.0 / (SELECT SUM(Amount) FROM Payment)) AS PercentageOfTotalRevenue
FROM Payment
GROUP BY Method

----Section 4 

----Q13

CREATE VIEW vw_CurrentLoans AS
SELECT
    l.loan_id,
    m.member_id,
    m.FullName AS MemberName,
    m.member_Email,
    b.book_id,
    b.book_title AS BookTitle,
    b.ISBN,
    l.due_date,
    l.loan_status,
    DATEDIFF(DAY, GETDATE(), l.due_date) AS DaysUntilOrOverdue
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id
WHERE l.loan_status IN ('Issued', 'Overdue')


----Q14

CREATE VIEW vw_LibraryStatistics 
AS
SELECT
    
    li.Library_Name,
    COUNT(b.book_id) AS TotalBooks,
    SUM(CASE WHEN b.Avalability_status = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    COUNT(m.member_id) AS TotalMembers,
    COUNT(l.loan_id) AS ActiveLoans,
    COUNT(s.Staff_id) AS TotalStaff,
    SUM(l.FinePaid) AS TotalFineRevenue
FROM Library li
LEFT JOIN Book b ON li.library_id = b.library_id
LEFT JOIN Staff s ON li.library_id = s.library_id
LEFT JOIN Loan l ON l.book_id = li.book_id
AND l.loan_status IN ('Issued', 'Overdue')
LEFT JOIN Member m ON m.loan_id = l.loan_id
GROUP BY li.library_id, li.Library_Name

----Q15

CREATE VIEW vw_BookDetailsWithReviews AS
SELECT
    b.book_id,
    b.book_title,
    b.Avalability_status AS AvailabilityStatus,
    COUNT(r.review_id) AS TotalReviews,
    AVG(r.Rating) AS AverageRating,
    MAX(r.review_date) AS LatestReviewDate
FROM Book b
LEFT JOIN Review r 
ON b.book_id = r.book_id
GROUP BY b.book_id,b.book_title,b.Avalability_status

select * from vw_BookDetailsWithReviews

----Section 4

---Q16 

CREATE PROCEDURE sp_IssueBook
    @member_id INT,
    @book_id INT,
    @dueDate DATE
AS
BEGIN
    -- Check book availability
        IF NOT EXISTS (
        SELECT 1 FROM Book 
        WHERE book_id = @book_id AND Avalability_status = 1
        )
    BEGIN
        PRINT 'Error: Book is not available'
        RETURN
    END

    -- Check overdue loans for member
    IF EXISTS (
        SELECT 1 FROM Loan
        WHERE member_id = @member_id
          AND loan_status = 'Overdue'
    )
    BEGIN
        PRINT 'Error: Member has overdue loans';
        RETURN;
    END

    BEGIN TRANSACTION;

    -- Create loan
    INSERT INTO Loan (member_id, book_id, loan_date, due_date, loan_status)
    VALUES (@member_id, @book_id, GETDATE(), @dueDate, 'Issued');

    -- Update book status
    UPDATE Book
    SET Avalability_status = 1
    WHERE book_id = book_id;

    COMMIT TRANSACTION;

    PRINT 'Book issued successfully';
END

---run 

EXEC sp_IssueBook @member_id = 514, 
                  @book_id=237, 
                  @dueDate='2025-11-10'

----Q17

CREATE PROCEDURE sp_ReturnBook
    @loan_id INT,
    @return_date DATE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @book_id INT, @dueDate DATE,@FinePaid DECIMAL(10,2),@DaysOverdue INT

    SELECT 
        @book_id = @book_id,
        @dueDate = @dueDate
    FROM Loan
    WHERE loan_id = @loan_id

    SET @DaysOverdue = DATEDIFF(DAY, @dueDate, @return_date);

    SET @FinePaid =
        CASE 
            WHEN @DaysOverdue > 0 THEN @DaysOverdue * 2
            ELSE 0
        END;

    BEGIN TRANSACTION;

    -- Update loan
    UPDATE Loan
    SET loan_status = 'Returned',
        return_date = @return_date
    WHERE loan_id = @loan_id;

    -- Update book availability
    UPDATE Book
    SET Avalability_status = 1
    WHERE book_id = @book_id

    -- Create fine 
    IF @FinePaid > 0
    BEGIN
        INSERT INTO Loan(loan_id, FinePaid, loan_status, loan_date)
        VALUES (@loan_id, @FinePaid, 'Pending', GETDATE());
    END

    COMMIT TRANSACTION;

    SELECT @FinePaid AS TotalFine;
END

---run
EXEC sp_ReturnBook @loan_id = 316, @return_date = '2025-11-30'

----Q18

CREATE PROCEDURE sp_GetMemberReport
    @member_id INT
AS
BEGIN
    SET NOCOUNT ON;

	---member information
    SELECT *
    FROM Member
    WHERE member_id = @member_id

    --Current Loans
    SELECT l.*, b.book_id
    FROM Loan l
    JOIN Book b ON l.book_id = b.book_id
    WHERE l.member_id = @member_id
      AND l.loan_status IN ('Issued', 'Overdue','Returned')
	  
    --Loan History
    SELECT l.*, b.book_title
    FROM Loan l
    JOIN Book b ON l.book_id = b.book_id
	WHERE loan_status = 'Returned'

    --Total Fines 
    SELECT
        SUM(CASE WHEN loan_status = 'Paid' THEN FinePaid ELSE 0 END) AS TotalPaid
    FROM Loan l
    WHERE l.member_id = @member_id

    --Reviews Written
    SELECT r.*, b.book_title
    FROM Review r
    JOIN Book b ON r.book_id = b.book_id
    WHERE r.member_id = @member_id
END

EXEC sp_GetMemberReport @member_id 

----Q19

CREATE PROCEDURE sp_MonthlyLibraryReport
    @library_id INT,
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Total loans 
    SELECT COUNT(*) AS TotalLoansIssued
    FROM Loan l
	INNER JOIN Book B 
	ON b.library_id = @library_id
    WHERE b.library_id = @library_id
      AND MONTH(l.loan_date) = @Month
      AND YEAR(l.loan_date) = @Year

	  
    -- Total books returned
    SELECT COUNT(*) AS TotalBooksReturned
    FROM Book b
	JOIN Loan L
	ON b.book_id = l.book_id
    WHERE b.book_id = @library_id
      AND MONTH(l.loan_date) = @Month
      AND YEAR(l.loan_id) = @Year

    -- Total revenue collected
    SELECT SUM(FinePaid) AS TotalRevenue
    FROM Loan
    WHERE loan_id = @library_id
      

    -- Most borrowed genre
    SELECT TOP 1 b.gener, COUNT(*) AS BorrowCount
    FROM Loan l
    JOIN Book b ON l.book_id = b.book_id
    WHERE l.loan_id = @library_id
    GROUP BY b.gener
    

    -- Top 3 active members
    SELECT TOP 3 m.FullName, COUNT(*) AS LoanCount
    FROM Loan l
    JOIN Member m ON l.member_id = m.member_id
    WHERE l.loan_id = @library_id
    GROUP BY m.FullName
   
END


EXEC sp_MonthlyLibraryReport @library_id=3, @Month =10 ,@Year = 2020



