--HANDS ON 1
--task:1 Create tables

CREATE TABLE departments(
department_id SERIAL PRIMARY KEY,
dept_name VARCHAR(100) NOT NULL,
hod_name VARCHAR(100),
budget DECIMAL(12,2)
);

CREATE TABLE students(
student_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
date_of_birth DATE,
department_id INT REFERENCES departments(department_id),
enrollment_year INT
);

CREATE TABLE courses(
course_id SERIAL PRIMARY KEY,
course_name VARCHAR(150) NOT NULL,
course_code VARCHAR(20) UNIQUE,
credits INT,
department_id INT REFERENCES departments(department_id)
);

CREATE TABLE enrollments(
enrollment_id SERIAL PRIMARY KEY,
student_id INT REFERENCES students(student_id),
course_id INT REFERENCES courses(course_id),
enrollment_date DATE,
grade CHAR(2) CHECK (grade IN ('A','B','C','D','F'))
);

CREATE TABLE professors(
professor_id SERIAL PRIMARY KEY,
prof_name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL,
department_id INT REFERENCES departments(department_id),
salary DECIMAL(10,2)
);


--task:2 insert datas & verify normalisation

INSERT INTO departments (dept_name, hod_name, budget)
VALUES  ('Computer Science', 'Dr. Ramesh Kumar', 850000.00), 
('Electronics', 'Dr. Priya Nair', 620000.00),  
('Mechanical', 'Dr. Suresh Iyer', 540000.00),  
('Civil', 'Dr. Ananya Sharma', 430000.00);

INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year)
VALUES  ('Arjun',  'Mehta',    'arjun.mehta@college.edu',    '2003-04-12', 1, 2022),  
('Priya',  'Suresh',   'priya.suresh@college.edu',   '2003-07-25', 1, 2022),  
('Rohan',  'Verma',    'rohan.verma@college.edu',    '2002-11-08', 2, 2021),  
('Sneha',  'Patel',    'sneha.patel@college.edu',    '2004-01-30', 3, 2023),  
('Vikram', 'Das',      'vikram.das@college.edu',     '2003-09-14', 1, 2022),  
('Kavya',  'Menon',    'kavya.menon@college.edu',    '2002-05-17', 2, 2021),  
('Aditya', 'Singh',    'aditya.singh@college.edu',   '2004-03-22', 4, 2023),
('Deepika','Rao',      'deepika.rao@college.edu',    '2003-08-09', 1, 2022);

INSERT INTO courses (course_name, course_code, credits, department_id) 
VALUES  ('Data Structures & Algorithms', 'CS101', 4, 1),  
('Database Management Systems',  'CS102', 3, 1),  
('Object Oriented Programming',  'CS103', 4, 1),  
('Circuit Theory',               'EC101', 3, 2),  
('Thermodynamics',               'ME101', 3, 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) 
VALUES  (1, 1, '2022-07-01', 'A'), 
(1, 2, '2022-07-01', 'B'),  
(2, 1, '2022-07-01', 'B'), 
(2, 3, '2022-07-01', 'A'),  
(3, 4, '2021-07-01', 'A'), 
(4, 5, '2023-07-01', NULL),  
(5, 1, '2022-07-01', 'C'), 
(5, 2, '2022-07-01', 'A'),  
(6, 4, '2021-07-01', 'B'), 
(7, 5, '2023-07-01', NULL),  
(8, 1, '2022-07-01', 'A'), 
(8, 3, '2022-07-01', 'B');

INSERT INTO professors (prof_name, email, department_id, salary) 
VALUES  ('Dr. Anand Krishnan',  'anand.k@college.edu',   1, 95000.00),  
('Dr. Meena Pillai',    'meena.p@college.edu',   1, 88000.00),  
('Dr. Sunil Rajan',     'sunil.r@college.edu',   2, 82000.00),  
('Dr. Latha Gopal',     'latha.g@college.edu',   3, 79000.00),  
('Dr. Kartik Bose',     'kartik.b@college.edu',  4, 76000.00);


-- NORMALIZATION ANALYSIS

-- 1NF: All tables satisfy First Normal Form because each column stores a single atomic value. No column contains multiple values or lists.
-- 2NF: All tables satisfy Second Normal Form because every non-key attribute depends on the whole primary key. In the enrollments table, attributes depend on both student_id and course_id, not on only one part of the composite key.
-- 3NF: All tables satisfy Third Normal Form because there are no transitive dependencies between non-key attributes. For example, storing dept_name directly in the student table would violate 3NF because dept_name depends on dept_id rather than student_id.


--task:3 alter and extend schema

ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

ALTER TABLE courses ADD COLUMN max_seats INT DEFAULT 60;

ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;

ALTER TABLE students DROP COLUMN phone_number;

SELECT column_name FROM information_schema.columns WHERE table_name = 'courses';
SELECT column_name FROM information_schema.columns WHERE table_name = 'departments';
SELECT column_name FROM information_schema.columns WHERE table_name = 'enrollments';
SELECT column_name FROM information_schema.columns WHERE table_name = 'professors';
SELECT column_name FROM information_schema.columns WHERE table_name = 'students';




--HANDS ON 2
--task:1 insert,update and delete

INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year)
VALUES  ('Shreya',  'Raj',    'shreya.raj@college.edu',    '2003-08-22', 2, 2022),  
('Sam',  'Vaish',   'sam.vaish@college.edu',   '2003-02-17', 3, 2022); 
SELECT COUNT(*) FROM students;

UPDATE enrollments SET grade = 'B' WHERE student_id = 5 AND course_id = 1;

SELECT * FROM enrollments WHERE grade IS NULL;
DELETE FROM enrollments WHERE grade IS NULL;


--task:2 single table queries and filtering

SELECT * FROM students WHERE enrollment_year = 2022 ORDER BY last_name ASC;

SELECT * FROM courses WHERE credits>3 ORDER BY credits DESC;

SELECT * FROM professors WHERE salary BETWEEN 80000 AND 95000;

SELECT * FROM students WHERE email LIKE '%@college.edu';

SELECT enrollment_year, COUNT(*) AS total_students FROM students GROUP BY enrollment_year ORDER BY enrollment_year;


--task:3 multi table joins

SELECT s.first_name || ' ' || s.last_name AS full_name, d.dept_name
FROM students s JOIN departments d ON s.department_id = d.department_id;

SELECT s.first_name || ' ' || s.last_name AS student_name, c.course_name, e.grade
FROM enrollments e JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT s.student_id, s.first_name, s.last_name
FROM students s LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name ORDER BY c.course_name;

SELECT d.dept_name, p.prof_name, p.salary
FROM departments d LEFT JOIN professors p ON d.department_id = p.department_id 
ORDER BY d.dept_name;


--task:4 Aggregations and grouping

SELECT c.course_name, COUNT(e.student_id) AS enrollment_count
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name ORDER BY c.course_name;

SELECT d.dept_name, ROUND(AVG(p.salary), 2) AS avg_salary
FROM departments d LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.dept_name ORDER BY d.dept_name;

SELECT dept_name, SUM(budget) AS total_budget
FROM departments GROUP BY dept_name
HAVING SUM(budget) > 600000;

SELECT e.grade, COUNT(*) AS grade_count
FROM enrollments e JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101' GROUP BY e.grade ORDER BY e.grade;

SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM departments d JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.dept_name HAVING COUNT(s.student_id) > 2;





--HANDS ON 3
--task:1 

SELECT s.student_id,s.first_name,s.last_name
FROM students s JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(*) >
(
    SELECT AVG(enrollment_count)FROM
    (
        SELECT COUNT(*) AS enrollment_count FROM enrollments GROUP BY student_id
    ) avg_table
);


SELECT c.course_id,c.course_name FROM courses c
WHERE NOT EXISTS
(
    SELECT 1 FROM enrollments e WHERE e.course_id = c.course_id AND e.grade <> 'A'
);


SELECT p.professor_id, p.prof_name,p.department_id,p.salary
FROM professors p WHERE p.salary =
(
    SELECT MAX(p2.salary) FROM professors p2
    WHERE p2.department_id = p.department_id
);


SELECT d.dept_name, da.avg_salary
FROM(
    SELECT department_id, AVG(salary) AS avg_salary
    FROM professors GROUP BY department_id
) da
JOIN departments d ON da.department_id = d.department_id WHERE da.avg_salary > 85000;



--task:2 creating and using views

CREATE VIEW vw_student_enrollment_summary AS
SELECT s.student_id, s.first_name || ' ' || s.last_name AS full_name, d.dept_name,
COUNT(e.course_id) AS total_courses, ROUND(AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
            END
        ), 2) AS gpa
FROM students s JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id,s.first_name, s.last_name,d.dept_name;
SELECT * FROM vw_student_enrollment_summary;


CREATE VIEW vw_course_stats AS
SELECT c.course_name, c.course_code,
COUNT(e.student_id) AS total_enrollments, ROUND(AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
            END
        ), 2) AS avg_gpa
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.course_code;
SELECT * FROM vw_course_stats;


SELECT * FROM vw_student_enrollment_summary WHERE gpa > 3.0;

UPDATE vw_student_enrollment_summary SET full_name = 'Test Student' WHERE student_id = 1;
--ERROR:  cannot update view "vw_student_enrollment_summary"
--Views containing GROUP BY are not automatically updatable. 
--SQL state: 55000
--Detail: Views containing GROUP BY are not automatically updatable.
--Hint: To enable updating the view, provide an INSTEAD OF UPDATE trigger or an unconditional ON UPDATE DO INSTEAD rule.


DROP VIEW vw_course_stats;
DROP VIEW vw_student_enrollment_summary;
SELECT * FROM pg_views WHERE viewname LIKE 'vw%';

CREATE VIEW vw_active_students AS SELECT * FROM students
WHERE enrollment_year >= 2022 WITH CHECK OPTION;



--task-3 stored procedures and transactions

CREATE OR REPLACE FUNCTION fn_enroll_student(
    p_student_id INT,
    p_course_id INT,
    p_enrollment_date DATE
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN

    IF EXISTS (
        SELECT 1
        FROM enrollments
        WHERE student_id = p_student_id
          AND course_id = p_course_id
    ) THEN
        RAISE EXCEPTION
        'Student % is already enrolled in course %',
        p_student_id,
        p_course_id;
    END IF;
    INSERT INTO enrollments(
        student_id,
        course_id,
        enrollment_date
    )
    VALUES (
        p_student_id,
        p_course_id,
        p_enrollment_date
    );
END;
$$;

SELECT fn_enroll_student(1,2,'2025-01-01');



CREATE TABLE department_transfer_log (
    log_id SERIAL PRIMARY KEY,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_transfer_student(
    p_student_id INT,
    p_new_department_id INT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_department INT;
BEGIN

    SELECT department_id
    INTO v_old_department
    FROM students
    WHERE student_id = p_student_id;

    UPDATE students
    SET department_id = p_new_department_id
    WHERE student_id = p_student_id;

    INSERT INTO department_transfer_log(
        student_id,
        old_department_id,
        new_department_id
    )
    VALUES (
        p_student_id,
        v_old_department,
        p_new_department_id
    );

END;
$$;



SELECT student_id,
       department_id
FROM students
WHERE student_id = 1;

SELECT fn_transfer_student(
    1,
    9999
);



BEGIN;
INSERT INTO enrollments(
    student_id,
    course_id,
    enrollment_date
)
VALUES (
    2,
    1,
    CURRENT_DATE
);
SAVEPOINT first_enrollment;
INSERT INTO enrollments(
    student_id,
    course_id,
    enrollment_date
)
VALUES (
    9999,
    2,
    CURRENT_DATE
);
ROLLBACK TO SAVEPOINT first_enrollment;
COMMIT;




--Hands on 4
--task 1:Baseline Performance

EXPLAIN
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- ==============================
-- Baseline Performance Analysis
-- ==============================

-- Query analyzed using EXPLAIN:
-- SELECT s.first_name, s.last_name, c.course_name
-- FROM enrollments e
-- JOIN students s ON s.student_id = e.student_id
-- JOIN courses c ON c.course_id = e.course_id
-- WHERE s.enrollment_year = 2022;

-- PostgreSQL execution plan showed a Seq Scan on enrollments.
-- Estimated cost for enrollments scan: cost=0.00..24.50.

-- PostgreSQL execution plan showed a Seq Scan on students.
-- Estimated cost for students scan: cost=0.00..12.00.
-- The filter applied was enrollment_year = 2022.

-- PostgreSQL used an Index Scan on courses via courses_pkey.
-- This indicates the primary key index was used for course lookup.

-- Overall estimated query cost: cost=12.16..42.16.

-- Sequential scans are acceptable for small tables,
-- but may become a performance bottleneck as table size increases.




--task 2: Add indexes and compare plans

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);
SELECT *
FROM pg_indexes
WHERE tablename = 'students';


CREATE UNIQUE INDEX idx_enrollments_student_course
ON enrollments(student_id, course_id);
INSERT INTO enrollments(student_id, course_id)
VALUES (1,1);


CREATE INDEX idx_courses_course_code
ON courses(course_code);


CREATE INDEX idx_enrollments_null_grade
ON enrollments(student_id)
WHERE grade IS NULL;
SELECT *
FROM enrollments
WHERE grade IS NULL;






