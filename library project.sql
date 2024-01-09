create database asslibrary;
use asslibrary;

CREATE TABLE PUBLISHER (
	publisher_PublisherName VARCHAR(50) primary key,
	publisher_PublisherAddress VARCHAR(50) not NULL,
	publisher_PublisherPhone VARCHAR(50) NOT NULL
);
CREATE TABLE BOOK (
	book_BookID INT primary key,
	book_Title VARCHAR (50) NOT NULL,
	book_PublisherName VARCHAR (50) NOT NULL,
	FOREIGN KEY (book_PublisherName) REFERENCES PUBLISHER(publisher_PublisherName) on delete cascade on update cascade
);
CREATE TABLE BOOK_AUTHORS (
	book_authors_BookID INT NOT NULL,
	book_authors_AuthorName VARCHAR(50) NOT NULL,
    book_authors_AuthorID int primary key auto_increment,
	FOREIGN KEY (book_authors_BookID) REFERENCES BOOK(book_BookID)  on delete cascade on update cascade
);
CREATE TABLE LIBRARY_BRANCH (
	library_branch_BranchName VARCHAR(50) NOT NULL,
	library_branch_BranchAddress VARCHAR(50) NOT NULL,
    library_branch_BranchID INT primary key auto_increment
);
CREATE TABLE BOOK_COPIES (
	book_copies_BookID INT NOT NULL,
	book_copies_BranchID INT NOT NULL,
	book_copies_No_Of_Copies INT NOT NULL,
    book_copies_CopiesID int primary key auto_increment,
	FOREIGN KEY (book_copies_BookID) REFERENCES BOOK(book_BookID) on delete cascade on update cascade,
	FOREIGN KEY (book_copies_BranchID) REFERENCES LIBRARY_BRANCH(library_branch_BranchID) on delete cascade on update cascade
);
CREATE TABLE BORROWER (
	borrower_BorrowerName VARCHAR(50) NOT NULL,
	borrower_BorrowerAddress VARCHAR(50) NOT NULL,
	borrower_BorrowerPhone VARCHAR(50) NOT NULL,
	borrower_CardNo INT primary key auto_increment
);
CREATE TABLE BOOK_LOANS (
	book_loans_BookID INT NOT NULL,
	book_loans_BranchID INT NOT NULL,
	book_loans_CardNo INT NOT NULL,
	book_loans_DateOut varchar(20) NOT NULL,
	book_loans_DueDate varchar(20) NOT NULL,
	book_loans_LoanID int primary key auto_increment,
	FOREIGN KEY (book_loans_BookID) REFERENCES BOOK(book_BookID) on delete cascade on update cascade,
	FOREIGN KEY (book_loans_BranchID) REFERENCES LIBRARY_BRANCH(library_branch_BranchID) on delete cascade on update cascade,
	FOREIGN KEY (book_loans_CardNo) REFERENCES BORROWER(borrower_CardNo) on delete cascade on update cascade
    );
    
select * from book_authors;
select * from book_copies;
select * from book_loans;
select * from borrower;
select * from library_branch;
select * from publisher;
select * from book;

# How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT book_copies_No_Of_Copies
FROM BOOK_COPIES
INNER JOIN BOOK ON BOOK.book_BookID = BOOK_COPIES.book_copies_BookID
INNER JOIN LIBRARY_BRANCH ON LIBRARY_BRANCH.library_branch_BranchID = BOOK_COPIES.book_copies_BranchID
WHERE book_Title = 'The Lost Tribe'
AND library_branch_BranchName = 'Sharpstown';

# How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT library_branch_BranchName, book_copies_No_Of_Copies
FROM LIBRARY_BRANCH
INNER JOIN BOOK_COPIES ON LIBRARY_BRANCH.library_branch_BranchID = BOOK_COPIES.book_copies_BranchID
INNER JOIN BOOK ON BOOK_COPIES.book_copies_BookID = BOOK.book_BookID
WHERE book_Title = 'The lost tribe';
#_________________  OR  _______________________
select library_branch_BranchName, book_copies_No_Of_Copies
from book_copies
INNER JOIN BOOK ON BOOK.book_BookID = BOOK_COPIES.book_copies_BookID
INNER JOIN LIBRARY_BRANCH ON LIBRARY_BRANCH.library_branch_BranchID = BOOK_COPIES.book_copies_BranchID
WHERE book_Title = 'The lost tribe';

#Retrieve the names of all borrowers who do not have any books checked out.
select distinct borrower_BorrowerName
from borrower
left join book_loans on borrower.borrower_CardNo =book_loans.book_loans_CardNo
where book_loans_CardNo is null;

#For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select book_Title, borrower_borrowerName ,borrower_borrowerAddress
from book_loans 
inner join borrower on borrower.borrower_cardNo=book_loans.book_loans_CardNo
inner join library_branch on library_branch.library_branch_BranchId=book_loans.book_loans_branchid
inner join book on book.book_bookid=book_loans.book_loans_bookid
where library_branch_BranchName="Sharpstown" and book_loans_DueDate='2/3/18';

#For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT library_branch_BranchName AS BranchName, COUNT(book_loans_BookID) AS TotalBooksLoaned
FROM LIBRARY_BRANCH
LEFT JOIN BOOK_LOANS ON LIBRARY_BRANCH.library_branch_BranchID = BOOK_LOANS.book_loans_BranchID
GROUP BY LIBRARY_BRANCH.library_branch_BranchName;

#Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT borrower_BorrowerName AS Name, borrower_BorrowerAddress AS Address, COUNT(book_loans_BookID) AS NumberOfBooksCheckedOut
FROM BORROWER 
LEFT JOIN BOOK_LOANS ON BORROWER.borrower_CardNo = BOOK_LOANS.book_loans_CardNo
GROUP BY BORROWER.borrower_BorrowerName, BORROWER.borrower_BorrowerAddress
HAVING COUNT(BOOK_LOANS.book_loans_BookID) > 5;

#For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT book_Title AS Title, book_copies_No_Of_Copies AS NumberOfCopies
FROM BOOK
LEFT JOIN BOOK_AUTHORS ON BOOK.book_BookID = BOOK_AUTHORS.book_authors_BookID
LEFT JOIN BOOK_COPIES ON BOOK.book_BookID = BOOK_COPIES.book_copies_BookID
LEFT JOIN LIBRARY_BRANCH ON BOOK_COPIES.book_copies_BranchID = LIBRARY_BRANCH.library_branch_BranchID
WHERE BOOK_AUTHORS.book_authors_AuthorName = 'Stephen King' AND LIBRARY_BRANCH.library_branch_BranchName = 'Central';


