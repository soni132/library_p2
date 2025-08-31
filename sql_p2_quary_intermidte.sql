select* from books;
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
create table summery as 
select issued_book_isbn,count(issued_id)
from
issued_status
group by issued_book_isbn;

select *
from summery;

create table sumer as
select
b.isbn,book_title,count(st.issued_id)
from
books as b
join issued_status as st
on b.isbn=st.issued_book_isbn
group by 1,2;

select * from sumer;

create table summary
(isbn vaechar primary key,
book_issued_cnt int);

--The following SQL queries were used to address specific questions:
--Task 7. Retrieve All Books in a Specific Category:
select* from books;
select * from books
where category='Classic';

--Task 8: Find Total Rental Income by Category:
select 
b.category,
sum(b.rental_price) as rental_income
from
books as b
join 
issued_status as st
on b.isbn=st.issued_book_isbn
group by b.category;

--List Members Who Registered in the Last 180 Days:
select* from members
where reg_date>=current_date - interval ' 180 days';

-- List Employees with Their Branch Manager's Name and their branch details:
select 
em.emp_id,em.emp_name,e.emp_name as manager,
b.*
from branch as b
join employees as e
on b.manager_id=e.emp_id
join
 employees as em
 on em.branch_id=b.branch_id;
-- Task 11. Create a Table of Books with Rental
-- Price Above a Certain Threshold: 
create table books_price as
select * from books
where rental_price>7
;
select* from books_price;
-- Task 12: Retrieve the List of Books Not Yet Returned
select* from return_status;
select* from issued_status;

select* from issued_status as ist
left
join return_status as rs
on ist.issued_id=rs.issued_id
where rs.return_id is null;

select* from 


