###############################################################
###############################################################
-- Guided Project: Mastering SQL Subqueries
###############################################################
###############################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data from tables in the employees database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Subquery in the WHERE clause
-- In this task, we will learn how to use a 
-- subquery in the WHERE clause
#############################

-- 2.1: Retrieve a list of all employees that are not managers
SELECT first_name, last_name FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

--employee: first_name, last_name; where primary key is emp_no; dept_manager emp_no is also primary key

-- 2.2: Retrieve all columns in the sales table for customers above 60 years old

-- Returns the count of customers
SELECT customer_id, COUNT(*)
FROM sales
GROUP BY customer_id
ORDER BY COUNT(*) DESC;

-- Solution
SELECT * FROM customers LIMIT 5;
SELECT * FROM sales LIMIT 5;
--primary key: customer_id
--customers table: age 
SELECT * FROM sales
WHERE customer_id IN (SELECT customer_id FROM customers
WHERE age > 60);
					  
-- 2.3: Retrieve a list of all manager's employees number, first and last names

-- Returns all the data from the dept_manager table
SELECT * FROM dept_manager;
SELECT * FROM employees;
--primary key: emp_no

-- Solution
SELECT emp_no, first_name, last_name FROM employees
WHERE emp_no IN (SELECT emp_no FROM dept_manager);


-- Exercise 2.1: Write a JOIN statement to get the result of 1.3 *(i'll consider 2.3) 
SELECT employees.emp_no, employees.first_name, employees.last_name
FROM employees
INNER JOIN dept_manager ON employees.emp_no=dept_manager.emp_no;

-- Exercise 2.2: Retrieve a list of all managers that were 
-- employed between 1st January, 1990 and 1st January, 1995
SELECT * FROM employees;
SELECT emp_no, first_name, last_name, hire_date FROM employees
WHERE emp_no IN (SELECT emp_no FROM dept_manager)
AND hire_date BETWEEN '1989-12-31' AND '1994-12-31';


#############################
-- Task Three: Subquery in the FROM clause
-- In this task, we will learn how to use a 
-- subquery in the FROM clause
#############################

-- 3.1: Retrieve a list of all customers living in the southern region
SELECT customer_name AS Customers_in_South FROM customers
WHERE region = 'South';

-- 3.2: Retrieve a list of managers and their department names
SELECT * FROM departments;
SELECT * FROM dept_manager;
SELECT * FROM employees;

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON dm.dept_no = d.dept_no;

-- Returns all the data from the dept_manager table
SELECT * FROM dept_manager;

-- Exercise 3.1: Retrieve a list of managers, their first, last, and their department names
SELECT e.first_name, e.last_name, d.dept_no d.dept_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON dm.dept_no = d.dept_no;

-- Returns data from the employees table
SELECT * FROM employees;

#############################
-- Task Four: Subquery in the SELECT clause
-- In this task, we will learn how to use a 
-- subquery in the SELECT clause
#############################

-- 4.1: Retrieve the first name, last name and average salary of all employees
SELECT e.first_name, e.last_name, ROUND(AVG(s.salary),2) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name;

-- Exercise 4.1: Retrieve a list of customer_id, product_id, order_line and the name of the customer
SELECT * FROM customers; --customer_id, customer_name
SELECT * FROM sales; --product_id, order_line, customer_id
-- primary key: customer_id

SELECT s.order_line, c.customer_id, c.customer_name, s.product_id
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id;

-- Returns data from the sales and customers tables
SELECT * FROM sales
ORDER BY customer_id;

SELECT * FROM customers;

#############################
-- Task Five: Subquery Exercises - Part 1
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 5.1: Return a list of all employees who are in Customer Service department
SELECT * FROM employees; --first_name, last_name
SELECT * FROM departments; --dept_name = 'Customer Service'
SELECT * FROM dept_emp;
--primary key = emp_no (employees - dept_emp)
--primary key = dept_no (departments - dept_emp)
SELECT * FROM dept_emp
WHERE dept_no = 'd009';

SELECT (e.first_name||' '|| e.last_name) AS Customer_Service_Team FROM employees e
JOIN dept_emp d ON e.emp_no = d.emp_no
WHERE d.dept_no = 'd009'


-- Returns data from the dept_emp and departments tables
SELECT * FROM dept_emp;
SELECT * FROM departments;

-- Exercise 5.2: Include the employee number, first and last names
SELECT e.emp_no, (e.first_name||' '|| e.last_name) AS Customer_Service_Team FROM employees e
JOIN dept_emp d ON e.emp_no = d.emp_no
WHERE d.dept_no = 'd009'

SELECT first_name FROM employees
WHERE emp_no = '10011';

-- Exercise 5.3: Retrieve a list of all managers who became managers after 
-- the 1st of January, 1985 and are in the Finance or HR department



-- Returns data from the departments and dept_manager tables
SELECT * FROM departments; -- Finance = d002; HR = d003
SELECT * FROM dept_manager
WHERE from_date > '1985-01-01'
AND dept_no IN ('d002', 'd003');

-- Solution
SELECT d.*, dm.* FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
WHERE dm.from_date > '1985-01-01'
AND d.dept_no IN ('d002', 'd003');

-- Exercise 5.4: Retrieve a list of all employees that earn above 120,000
-- and are in the Finance or HR departments

-- Retrieve a list of all employees that earn above 120,000
SELECT emp_no, salary FROM salaries
WHERE salary > 120000;
SELECT * FROM employees;
-- Solution
SELECT s.emp_no, e.first_name, e. last_name, s.salary FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no
WHERE s.salary > 120000
GROUP BY s.emp_no, s. salary, e.first_name, e.last_name
ORDER BY s.salary DESC;

-- Alternative Solution
SELECT emp_no, salary FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
				WHERE dept_no IN ('d002','d003'));

-- Exercise 5.5: Retrieve the average salary of these employees
SELECT s.emp_no, e.first_name, e. last_name, ROUND(AVG(s.salary),2) AS AVG_Salary FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no
WHERE s.salary > 120000
GROUP BY s.emp_no, s. salary, e.first_name, e.last_name
ORDER BY s.salary DESC;


#############################
-- Task Six: Subquery Exercises - Part Two
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 6.1: Return a list of all employees number, first and last name.
-- Also, return the average salary of all the employees and average salary
-- of each employee

-- Retrieve all the records in the salaries table
SELECT * FROM salaries;

-- Return the employee number, first and last names and average
-- salary of all employees
SELECT e.emp_no, e.first_name, e.last_name, 
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- Returns the employee number and average salary of each employee
SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no;

-- Solution
SELECT e.emp_no, e.first_name, e.last_name,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary,
ROUND(AVG(salary), 2) AS emp_avg_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no
ORDER BY e.emp_no;


-- Exercise 6.2: Find the difference between an employee's average salary
-- and the average salary of all employees
SELECT e.first_name, e.last_name,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary,
ROUND(AVG(salary), 2) AS emp_avg_salary,
(ROUND(AVG(salary), 2) - (SELECT ROUND(AVG(salary), 2) FROM salaries)) AS difference
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no
ORDER BY difference DESC;


-- Exercise 6.3: Find the difference between the maximum salary of employees
-- in the Finance or HR department and the maximum salary of all employees

SELECT e.emp_no, e.first_name, e.last_name, a.emp_max_salary,
(SELECT MAX(salary) max_salary FROM salaries), 
(SELECT MAX(salary) max_salary FROM salaries) - a.emp_max_salary salary_diff
FROM employees e
JOIN (SELECT s.emp_no, MAX(salary) AS emp_max_salary
				   FROM salaries s
				   GROUP BY s.emp_no
				   ORDER BY s.emp_no) a
ON e.emp_no = a.emp_no
WHERE e.emp_no IN (SELECT emp_no FROM dept_emp WHERE dept_no IN ('d002', 'd003'))
ORDER BY emp_no;


#############################
-- Task Seven: Subquery Exercises - Part Three
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 7.1: Retrieve the salary that occured most

-- Returns a list of the count of salaries
SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary;


-- Solution
SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary
ORDER BY count DESC
LIMIT 1;

-- Exercise 7.2: Find the average salary excluding the highest and
-- the lowest salaries
SELECT salary FROM salaries
ORDER BY salary
LIMIT 1;
-- Returns the average salary of all employees
SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries

-- Solution
SELECT ROUND(AVG(salary), 2) AS average FROM salaries
WHERE salary NOT IN (
(SELECT MAX(salary) FROM salaries),
(SELECT MIN(salary) FROM salaries)	
);

-- Exercise 7.3: Retrieve a list of customers id, name that have
-- bought the most from the store

-- Returns a list of customer counts
SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC;
	 
-- Solution
SELECT s.customer_id, c.customer_name, COUNT(s.*) AS cust_count FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.customer_id, c.customer_name
ORDER BY cust_count DESC;

SELECT * FROM sales;
SELECT customer_name FROM customers WHERE customer_id = 'WB-21850';

-- Exercise 7.4: Retrieve a list of the customer name and segment
-- of those customers that bought the most from the store and
-- had the highest total sales

-- Returns a list of customer counts and total sales
SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC;

SELECT * FROM customers;
SELECT * FROM sales;

-- Solution
SELECT s.customer_id, c.customer_name, c.segment, COUNT(s.*) AS cust_count, SUM(s.sales) total_sales
FROM sales s
JOIN customers c ON c.customer_id = s.customer_id
GROUP BY s.customer_id, c.customer_name, c.segment
ORDER BY total_sales DESC, cust_count DESC;

