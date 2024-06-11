use WalmartSalesData;
show databases;
 
CREATE TABLE walmartsalesdata(
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(30),
    customer_type VARCHAR(30),
    gender VARCHAR(10),
    product_line VARCHAR(100),
    unit_price double,
    quantity INT,
    VAT DOUBLE,
    total double,
    Date DATE,
    Time TIME,
    payment_method VARCHAR(30),
    cogs double,
    gross_margin_percentage double,
    gross_income double,
    rating double
);
 
 
-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made
-- 2. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest
-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
 
select * from walmartsalesdata;
alter table walmartsalesdata
add Time_of_day varchar(30),
add day_name varchar(30),
add month_name varchar(30);
 
SELECT * from walmartsalesdata;
 
set sql_safe_updates = 0;
 
update walmartsalesdata
set Time_of_day =
case
    when  Time >= "00:00:00" and Time <= "11:59:00"THEN 'Morning'
    when  Time >= "12:00:00" and Time <= "17:59:00" THEN 'Afternoon'
    else 'Evening'
end;
 
 
update walmartsalesdata
set day_name =  dayname(Date);
 
update walmartsalesdata
set month_name =  monthname(Date);
 
 
-- BusinessQuestions To Answer GenericQuestion
 
-- 1. How many unique cities does the data have?
 
select count(distinct city) as unique_cities
from walmartsalesdata;
 
-- 2. In which city is each branch?
 
select city, group_concat(distinct branch) AS city_branch
from walmartsalesdata
group by city
order by branch;
 
select * from walmartsalesdata;
-- Product
 
-- 1. How many unique product lines does the data have?
 
select count(distinct product_line) as unique_product_lines
from walmartsalesdata;
 
-- 2. What is the most common payment method?
 
select payment_method as max_payment_method_used
from walmartsalesdata
group by payment_method
order by count(*) desc
limit 1;
 
-- 3. What is the most selling product line?
 
select product_line as max_product_line
from walmartsalesdata
group by product_line
order by count(*) desc
limit 1;
 
-- 4. What is the total revenue by month?
 
select month_name as month,
sum(cogs) AS total_revenue
from walmartsalesdata
group by month_name
order by month_name;
 
-- 5. What month had the largest COGS?
 
select month_name as largest_cogs_month
from walmartsalesdata
order by cogs desc
limit 1;
 
-- 6. What product line had the largest revenue?
 
select product_line as largest_revenue_product_line
from walmartsalesdata
order by cogs desc
limit 1;
 
-- 7. What is the city with the largest revenue?
 
select city as largest_revenue_city
from walmartsalesdata
order by cogs desc
limit 1;
 
-- 8. What product line had the largest VAT?
 
select product_line as largest_VAT_product_line
from walmartsalesdata
order by VAT desc
limit 1;
 
-- 9. Fetch each product line and add a column to those product line showing "Good","Bad". Good if its greater than average sales
 
select product_line,
case 
when avg(quantity) > quantity then "Bad"
else "Good"
end as quality_of_product_line
from walmartsalesdata
group by product_line;
 
-- 10. Which branch sold more products than average product sold?
 
select branch, sum(quantity) as total_quantity_sold
from walmartsalesdata
group by branch
having total_quantity_sold > avg(quantity)
limit 1;
 
-- 11. What is the most common product line by gender?
 
select product_line, gender
from walmartsalesdata
group by product_line, gender
order by count(gender) desc
limit 1;
 
-- 12. What is the average rating of each product line?
 
select product_line, avg(rating) as average_rating
from walmartsalesdata
group by product_line;
 
-- Sales
 
-- 1. Number of sales made in each time of the day per weekday
 
select day_name as weekday,  time_of_day, COUNT(*) AS number_of_sales
from walmartsalesdata
group by weekday, time_of_day
order by 
    FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    FIELD(time_of_day, 'Morning', 'Afternoon', 'Evening');
 
-- 2. Which of the customer types brings the most revenue?
select customer_type, sum(cogs) as most_revenue
from walmartsalesdata
group by customer_type
order by most_revenue desc
limit 1;
-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
 
select city
from walmartsalesdata
group by city
order by sum(VAT) desc
limit 1;
 
-- 4. Which customer type pays the most in VAT?
 
select customer_type
from walmartsalesdata
group by customer_type
order by sum(VAT) desc
limit 1;
 
-- Customer
 
-- 1. How many unique customer types does the data have?
 
select count(distinct customer_type) as unique_customer_type
from walmartsalesdata;
 
-- 2. How many unique payment methods does the data have?
 
select count(distinct payment_method) as unique_payment_methods
from walmartsalesdata;
 
-- 3. What is the most common customer type?
 
select customer_type
from walmartsalesdata
group by customer_type
order by count(customer_type) desc
limit 1;
 
-- 4. Which customer type buys the most?
 
select customer_type, sum(quantity) as purchase
from walmartsalesdata
group by customer_type
order by purchase desc
limit 1;
 
-- 5. What is the gender of most of the customers?
 
select gender
from walmartsalesdata
group by gender
order by count(gender) desc
limit 1;
 
-- 6. What is the gender distribution per branch?
 
select branch, gender, count(gender) as gender_distribution
from walmartsalesdata
group by branch, gender
order by branch asc;
 
-- 7. Which time of the day do customers give most ratings?
 
select time_of_day
from walmartsalesdata
group by time_of_day
order by count(rating) desc
limit 1;
 
-- 8. Which time of the day do customers give most ratings per branch?
 
select branch, time_of_day, count(rating)
from walmartsalesdata
group by branch, time_of_day
order by count(rating) desc
limit 3;
 
 
-- 9. Which day of the week has the best avg ratings?
 
select day_name
from walmartsalesdata
group by day_name
order by avg(rating) desc
limit 1;
 
-- 10. Which day of the week has the best average ratings per branch?
 
select branch,avg(rating) as best_avg_rating
from walmartsalesdata
group by branch
order by branch asc;
 
/***********************************************************************************************************
 
Conclusion:
Based on the analysis of the provided questions, the conclusion would involve a holistic understanding of sales performance,
customer behavior, and operational insights. It would involve leveraging the findings to drive strategic decisions,
optimize resources, and enhance customer satisfaction. Additionally, ongoing monitoring and analysis of key metrics 
are crucial for adapting to changing market dynamics and maintaining competitiveness.
 
***********************************************************************************************************/