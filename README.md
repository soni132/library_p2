# Library Management System

A comprehensive SQL-based library management system designed to handle book inventory, member management, employee administration, and book lending operations across multiple library branches.

## 📋 Table of Contents

- [Overview](#overview)
- [Database Schema](#database-schema)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Key Queries](#key-queries)
- [Sample Data](#sample-data)
- [Contributing](#contributing)

## 🔍 Overview

This Library Management System provides a complete solution for managing library operations including:

- **Multi-branch support** with branch-specific management
- **Book inventory management** with rental pricing and availability tracking
- **Member registration and management** with registration date tracking
- **Employee management** with position-based hierarchy
- **Book issuing and return tracking** with comprehensive audit trails
- **Automated reporting** for rental income, member activity, and book availability

## 🗄️ Database Schema

<img width="1101" height="631" alt="library_erd" src="https://github.com/user-attachments/assets/f9c0f185-0b50-4e33-950d-369402e058a3" />



The system consists of 6 main tables with well-defined relationships:

### Core Tables

#### 🏢 `branch`
| Column | Type | Constraint |
|--------|------|------------|
| `branch_id` | VARCHAR(10) | PRIMARY KEY |
| `manager_id` | VARCHAR(10) | References employees |
| `branch_address` | VARCHAR(30) | - |
| `contact_no` | VARCHAR(15) | - |

#### 👥 `employees`
| Column | Type | Constraint |
|--------|------|------------|
| `emp_id` | VARCHAR(10) | PRIMARY KEY |
| `emp_name` | VARCHAR(30) | - |
| `position` | VARCHAR(30) | - |
| `salary` | DECIMAL(10,2) | - |
| `branch_id` | VARCHAR(10) | FOREIGN KEY → branch(branch_id) |

#### 📖 `books`
| Column | Type | Constraint |
|--------|------|------------|
| `isbn` | VARCHAR(50) | PRIMARY KEY |
| `book_title` | VARCHAR(80) | - |
| `category` | VARCHAR(30) | - |
| `rental_price` | DECIMAL(10,2) | - |
| `status` | VARCHAR(10) | - |
| `author` | VARCHAR(30) | - |
| `publisher` | VARCHAR(30) | - |

#### 🎫 `members`
| Column | Type | Constraint |
|--------|------|------------|
| `member_id` | VARCHAR(10) | PRIMARY KEY |
| `member_name` | VARCHAR(30) | - |
| `member_address` | VARCHAR(30) | - |
| `reg_date` | DATE | - |

#### 📋 `issued_status`
| Column | Type | Constraint |
|--------|------|------------|
| `issued_id` | VARCHAR(10) | PRIMARY KEY |
| `issued_member_id` | VARCHAR(30) | FOREIGN KEY → members(member_id) |
| `issued_book_name` | VARCHAR(80) | - |
| `issued_date` | DATE | - |
| `issued_book_isbn` | VARCHAR(50) | FOREIGN KEY → books(isbn) |
| `issued_emp_id` | VARCHAR(10) | FOREIGN KEY → employees(emp_id) |

#### 🔄 `return_status`
| Column | Type | Constraint |
|--------|------|------------|
| `return_id` | VARCHAR(10) | PRIMARY KEY |
| `issued_id` | VARCHAR(30) | References issued_status |
| `return_book_name` | VARCHAR(80) | - |
| `return_date` | DATE | - |
| `return_book_isbn` | VARCHAR(50) | FOREIGN KEY → books(isbn) |

### 🔗 Entity Relationships

The database follows a normalized structure with the following key relationships:

- **One-to-Many**: Branch → Employees (Each branch has multiple employees)
- **One-to-Many**: Books → Issued Status (Each book can be issued multiple times)
- **One-to-Many**: Members → Issued Status (Each member can issue multiple books)
- **One-to-Many**: Employees → Issued Status (Each employee can process multiple issues)
- **One-to-One**: Issued Status → Return Status (Each issue has at most one return)

## ✨ Features

### 📚 Book Management
- Complete book inventory with ISBN tracking
- Category-based organization (Classic, Fiction, History, Fantasy, etc.)
- Rental pricing management
- Availability status tracking

### 👥 Member Management
- Member registration with address tracking
- Registration date monitoring for membership analytics
- Member activity tracking through issued books

### 🏢 Branch Operations
- Multi-branch support with individual management
- Employee assignment to specific branches
- Branch-specific contact information

### 📊 Reporting & Analytics
- **Rental Income Analysis**: Track revenue by book category
- **Member Activity**: Monitor recent registrations and active members
- **Book Popularity**: Analyze most frequently issued books
- **Outstanding Returns**: Track unreturned books
- **Employee Performance**: Monitor book issuance by employee

## 🚀 Installation

1. **Setup Database**
   ```sql
   -- Run the schema creation script
   SOURCE p2_schema.sql;
   ```

2. **Insert Sample Data**
   ```sql
   -- Populate tables with initial data
   SOURCE insertion_query_p2.sql;
   ```

3. **Verify Installation**
   ```sql
   -- Check all tables are created and populated
   SHOW TABLES;
   SELECT COUNT(*) FROM books;
   SELECT COUNT(*) FROM members;
   ```

## 💻 Usage

### Basic Operations

**View All Books**
```sql
SELECT * FROM books;
```

**Find Books by Category**
```sql
SELECT * FROM books WHERE category = 'Classic';
```

**Check Member Registration**
```sql
SELECT * FROM members WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

### Advanced Queries

**Rental Income by Category**
```sql
SELECT 
    b.category,
    SUM(b.rental_price) as rental_income
FROM books AS b
JOIN issued_status AS st ON b.isbn = st.issued_book_isbn
GROUP BY b.category;
```

**Books Not Yet Returned**
```sql
SELECT ist.*
FROM issued_status AS ist
LEFT JOIN return_status AS rs ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

**Employee Details with Branch Manager**
```sql
SELECT 
    em.emp_id,
    em.emp_name,
    e.emp_name AS manager,
    b.*
FROM branch AS b
JOIN employees AS e ON b.manager_id = e.emp_id
JOIN employees AS em ON em.branch_id = b.branch_id;
```

## 🔧 Key Queries

### Summary Tables Creation
The system includes functionality to create summary tables for reporting:

```sql
-- Book issuance summary
CREATE TABLE summary AS 
SELECT issued_book_isbn, COUNT(issued_id)
FROM issued_status
GROUP BY issued_book_isbn;

-- Detailed book summary with titles
CREATE TABLE book_summary AS
SELECT
    b.isbn,
    book_title,
    COUNT(st.issued_id) as issue_count
FROM books AS b
JOIN issued_status AS st ON b.isbn = st.issued_book_isbn
GROUP BY b.isbn, book_title;
```

### High-Value Books Filter
```sql
-- Create table for books with rental price above threshold
CREATE TABLE books_price AS
SELECT * FROM books
WHERE rental_price > 7;
```

## 📊 Sample Data

The system includes comprehensive sample data:

- **35 Books** across multiple categories (Classic, Fiction, Fantasy, History, etc.)
- **12 Members** with registration dates from 2021-2024
- **11 Employees** across 5 branches with different positions
- **35 Book Issues** with tracking from March-April 2024
- **18 Returns** with proper return date tracking

### Book Categories Available
- Classic Literature
- Fiction
- Fantasy
- History
- Mystery
- Dystopian
- Horror
- Children's Books
- Science Fiction

## 🔄 Data Relationships

The system maintains referential integrity through:

- **Branch → Employees**: Each employee belongs to a branch
- **Books → Issued Status**: Track which books are issued
- **Members → Issued Status**: Track member borrowing history
- **Employees → Issued Status**: Track which employee processed the issue
- **Issued Status → Return Status**: Track book returns

## 📈 Business Intelligence

The system supports various analytical queries:

1. **Revenue Analysis**: Track rental income by category and time period
2. **Member Engagement**: Identify active vs. inactive members
3. **Book Popularity**: Analyze most/least popular books and categories
4. **Branch Performance**: Compare activity across different branches
5. **Employee Productivity**: Monitor book processing by staff members

## 🛠️ Maintenance

### Regular Tasks
- Monitor unreturned books using the outstanding returns query
- Update book availability status based on returns
- Generate periodic reports for management review
- Clean up old issued/return records as per retention policy

### Performance Optimization
- Index frequently queried columns (ISBN, member_id, issued_date)
- Regular statistics updates for query optimization
- Archive old transaction data to maintain performance

## 🤝 Contributing

To contribute to this project:

1. Follow the existing naming conventions
2. Maintain referential integrity in all modifications
3. Test queries thoroughly before implementation
4. Document any new features or schema changes
5. Ensure backward compatibility with existing data

## 📝 Notes

- All dates use standard SQL DATE format (YYYY-MM-DD)
- ISBN numbers follow standard ISBN-13 format
- Employee and member IDs use alphanumeric codes for easy identification
- Rental prices are stored as DECIMAL(10,2) for precise currency handling

---

**Version**: 1.0  
**Last Updated**: August 2024  
**Database**: SQL Compatible (MySQL, PostgreSQL, etc.)
