#q1
SELECT e.firstName, e.lastName, m.firstName as manager_firstName, m.lastName as manager_lastname
from employee as e
inner join employee as m
on m.employeeId = e.managerId;

#q2
select firstName, lastName, title, s.salesAmount
from employee as e
left join sales as s
on s.employeeId = e.employeeId
WHERE title='Sales Person'
AND salesAmount IS NULL;

#q3
select c.firstName, c.lastName, s.salesId, s.salesAmount
from customer as c
join sales as s
on c.customerId = s.customerId
UNION
select c.firstName, c.lastName, s.salesId, s.salesAmount
from customer as c
left join sales as s
on c.customerId = s.customerId
WHERE s.salesId IS NULL
UNION
select c.firstName, c.lastName, s.salesId, s.salesAmount
from sales as s
left join customer as c
on c.customerId = s.customerId
WHERE s.salesId IS NULL;

#4
SELECT e.employeeId, e.firstName, e.lastName, count(s.salesId) as NumOfCarsSold
from sales as s
INNER JOIN employee as e
on s.employeeId = e.employeeId
GROUP BY e.employeeId, e.firstName, e.lastName
ORDER BY count(salesId) DESC;

#4
SELECT e.employeeId, e.firstName, e.lastName, s.soldDate,
MIN(s.salesAmount) as min_sales,
MAX(s.salesAmount) as max_sales
from employee as e
INNER JOIN sales as s
on e.employeeId = s.employeeId
WHERE s.soldDate <= date('now','start of year')
group by e.employeeId, e.firstName, e.lastName;

#5
SELECT e.employeeId, e.firstName, e.lastName, count(salesId) as NoOfSales
from employee as e
inner join sales as s
on e.employeeId = s.employeeId
where s.soldDate <= date('now','start of year')
GROUP BY e.employeeId, e.firstName, e.lastName
having count(salesId) >= 5
Order by count(salesId) DESC;

#6
select strftime('%Y', s.soldDate) as year, format('$%.2f', sum(salesAmount)) as  AnnualSale
from employee as e
INNER JOIN sales as s
on e.employeeId = s.employeeId
GROUP BY year;

#7
SELECT e.employeeId, e.firstName, e.lastName, 
strftime('%M', s.soldDate) as month, sum(salesAmount) as salesAmountPerEmployee
from employee as e
inner JOIN sales as s
on e.employeeId = s.employeeId;


#8
SELECT s.salesId, s.salesAmount, i.inventoryId, i.modelID
from Sales as s
JOIN inventory as i
on s.inventoryId = i.inventoryId
WHERE i.modelId in(SELECT modelId FROM Model WHERE EngineType = 'Electric');

#9
SELECT e.firstName, e.lastName, e.title, s.salesAmount, m.modelId,
count(m.model) as NumberSold, rank() OVER (PARTITION by s.employeeId
 ORDER by count(m.model) desc) as Rank
from employee as e
INNER JOIN sales as s
on e.employeeId = s.employeeId
INNER JOIN inventory as i
on i.inventoryId = s.inventoryId
INNER JOIN Model as m
on m.modelId = i.modelId
GROUP BY e.firstName, e.lastName, m.modelId;

#10
WITH sales_report AS (
  SELECT strftime('%Y', soldDate) as Sales_year,
  strftime('%m', soldDate) as Sales_month,
  sum(salesAmount) as SalesAmount
  FROM sales 
  GROUP BY Sales_year, Sales_month
  )
SELECT Sales_year, Sales_month, SalesAmount, 
Sum(salesAmount) OVER (PARTITION BY Sales_year ORDER BY Sales_year, Sales_month) as AnnualSales_runningTotal
FROM sales_report
ORDER BY Sales_year, Sales_month;

#11
SELECT strftime('%Y-%m', soldDate) as MonthSold,
count(*) as NumberOfCarSold,
LAG(count(*),1,0) OVER calMonth as LastMonthCarSold
FROM sales
GROUP by MonthSold
WINDOW calMonth AS (ORDER BY strftime('%Y-%m', soldDate))
ORDER BY MonthSold;