-- Assignment 1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
-- 1_a.	Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to employee with employeenumber 1102 (Refer employee table)

use classicmodels;
show tables;
select distinct employeenumber,firstname,lastname
from employees
where jobTitle like 'sales rep'
And reportsTo=1102;

-- 1_b. Show the unique productline values containing the word cars at the end from the products table.

select * from products;
select productline
from productlines
where productLine like '%cars';




-- Assignment 2. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)

select * from customers;
select customerNumber,customerName,case country
     when 'USA' then 'North America'
     when 'Canada' then 'North America'
     when 'UK' then 'Europe'
     when 'France' then 'Europe'
     when 'Germany' then 'Europe'
else
     'other'
end as CustomerSegment
from customers
limit 14;




-- Assignment 3. Group By with Aggregation functions and Having clause, Date and Time functions
-- 3_a. Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.

select * from orderdetails;
select productCode,sum(quantityOrdered) as total_ordered
from orderdetails
group by productCode
having total_ordered
order by total_ordered desc
limit 10;

-- 3_b. Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number of payments for each month and include only those months with a payment count exceeding 20. Sort the results by total number of payments in descending order.  (Refer Payments table). 

select * from payments;
select monthname(paymentDate) as payment_month,count(*) as num_payments
from payments
group by monthname(paymentDate)
having count(*) > 20
order by num_payments desc;





-- Assignment 4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
-- 4_a.	Create a table named Customers to store customer information. Include the following columns

create database customers_orders;

create table customers(customer_id int Auto_increment primary key,
                       first_name varchar(50) Not Null,
                       last_name varchar(50) Not Null,
                       email varchar(255) unique,
                       phone_number varchar(20)
                       );
                       
-- 4_b.	Create a table named Orders to store information about customer orders. Include the following columns

 create table orders(orders_id int Auto_increment primary key,
                     customer_id int,
                     foreign key (customer_id) references customers(customer_id),
                     orders_date date,
                     total_amount decimal(10,2) check (total_amount>0)
                     );
                     
                     
                     
                     
-- Assignment 5.JOINS
-- a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)

select customers.country,count(orders.ordernumber) as order_count
from customers inner join orders
on customers.customerNumber=orders.customerNumber
group by customers.country
order by order_count desc
limit 5;




-- Assignment 6.alter
-- Create a table project with below fields.

create table project(employeeID int auto_increment primary key,
                     fullname varchar(50) Not Null,
                     gender varchar(10) check(Gender in ('Male','Female')),
                     managerID int 
                     );
                     
insert into project values("1","Pranaya","Male","3"),
                           ("2","Priyanka","Female","1"),
                           ("3","Preety","Female",Null),
                           ("4","Anurag","Male","1"),
                           ("5","Sambit","Male","1"),
                           ("6","Rajesh","Male","3"),
                           ("7","Hina","Female","3");
select * from project;
select M1.fullname as 'Manager name',E1.fullname as 'Emp name'
from project M1 join project E1
on E1.managerID=M1.employeeID;




-- Assignment 7. DDL Commands: Create, Alter, Rename
-- Create table facility. Add the below fields into it.

create table facility(facilityId int,
                      Name varchar(100),
                      State varchar(100),
                      country varchar(100)
                      );
alter table facility modify facilityId int auto_increment primary key;
alter table facility add city varchar(100) Not Null after Name;
show columns from facility;




-- Assignment 8. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following information

 create view product_category_sales as
 select pl.productline,sum(od.quantityordered*od.priceeach) as total_sales,
 count(distinct o.ordernumber) as number_of_orders
 from productlines pl join products p
 on pl.productLine=p.productLine join orderdetails od
 on p.productCode=od.productCode join orders o
 on od.ordernumber=o.orderNumber
 group by pl.productline;
 
 select * from product_category_sales;
 
 
 
 
 -- Assignment 9. Stored Procedures in SQL with parameters
-- Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)

 call classicmodels.Get_country_payments(2003,'france');




-- Assignment 10. Window functions - Rank, dense_rank, lead and lag
-- 10_a. Using customers and orders tables, rank the customers based on their order frequency

select c.customername,count(o.ordernumber) order_count,
rank() over (order by count(o.ordernumber) desc) as order_frequency_rnk
from customers c inner join orders o
on c.customerNumber=o.customerNumber
group by c.customerNumber,customername
limit 9;

-- 10_b. Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.

SELECT year(orderDate) as year,
monthname(orderDate) as month,
count(orderNumber) as `Total Orders`,
concat(
round(
((COUNT(orderNumber) -lag(COUNT(orderNumber)) over (order by year(orderDate), month(orderDate)))
/ lag(COUNT(orderNumber)) over (order by year(orderDate), month(orderDate))
) * 100),'%') as `% YoY Change`
from orders
group by year(orderDate), month(orderDate), monthname(orderDate)
order by year(orderDate), month(orderDate)
limit 14;




-- Assignment 11. Subqueries and their applications
-- Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

select productline,count(*) as Total
from products
where buyPrice>(select avg(buyprice)
				from products
                )
group by productLine
order by total desc;




-- Assignment 12. ERROR HANDLING in SQL
-- Create the table Emp_EH. Below are its fields

create table Emp_EH(emp_id int primary key,
                     empname varchar(50),
                     emailAddress varchar(50)
                     );
                     
  call classicmodels.insertEmp_EH('121','siddu','sai@gmail.com');                  
                     
                     
-- Assignment 13. TRIGGERS
-- Create the table Emp_BIT. Add below fields in it.

create table Emp_BIT(Name varchar(100),
				      Occupation varchar(100),
                      Working_date date,
                      Working_hours time
                      );
insert into Emp_BIT values('Robin', 'Scientist', '2020-10-04', 12),  
						  ('Warner', 'Engineer', '2020-10-04', 10),
                          ('Raj','Farmer','2023-09-30',-20),
                          ('Peter', 'Actor', '2020-10-04', 13),
                          ('Marco', 'Doctor', '2020-10-04', 14),
                          ('Brayden', 'Teacher', '2020-10-04', 12),
                          ('siddu','Actor','2022-12-23',-15),
                          ('Antonio', 'Business', '2020-10-04', 11);  
select * from Emp_BIt;



