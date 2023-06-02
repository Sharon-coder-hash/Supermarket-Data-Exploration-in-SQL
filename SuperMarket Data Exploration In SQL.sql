select * from Super..SuperB
-- Calculating the item Price
select Product_line, Unit_price, City, Quantity, Total, (Unit_Price* Quantity) as Item_Price from Super..SuperB
where City like '%taw%'
order by 6 desc

-- Looking at the Tax amount vs Total Revenue
select Product_line, Unit_price, City, Quantity, Total, (Tax_5/ Total)*100 as '%Tax' from Super..SuperB
--where City like '%taw%'
order by 2 desc

--Top 10 Product Line with the highest Total Revenue
select TOP 10 Product_line, Total, Quantity, City from Super..SuperB
order by 2 desc

--Selecting Product_line group with the highest Product price and Total revenue
select max(Total) as TotalRevenue, max(Unit_Price*Quantity) as ProductPrice, City, Product_line from Super..SuperB
where City like '%ngon%'
group by Product_line, City
order by 1 desc

--Looking at the Product line of customers who used Ewallet and Cash only for transactions
select B.Product_line, A.Payment, A.cogs, A.gross_income, B.Total
from Super..SuperB B
join Super..SuperA A
on B.Invoice_ID = A.Invoice_ID
where A.Payment in (select distinct(Super..SuperA.Payment)
from Super..SuperA where Payment <> 'Credit card')
order by 3 desc

--To get sum of cost of goods in each city
select B.Product_line, A.Payment, B.City,  A.gross_income, B.Total, sum(A.cogs)
over (partition by B.City order by B.City, A.Payment) AS TotalCOG
from Super..SuperB B
join Super..SuperA A
on B.Invoice_ID = A.Invoice_ID
order by 6 desc

--Using CTE (Temporary Query) to get percentage of TotalRevenue/TotalCOG
with cogVSTotal (ProductLine, Payment, City, Gross_income, TotalRevenue, TotalCOG)
as
(
select B.Product_line, A.Payment, B.City,  A.gross_income, B.Total, sum(A.cogs)
over (partition by B.City order by B.City, A.Payment) AS TotalCOG
from Super..SuperB B
join Super..SuperA A
on B.Invoice_ID = A.Invoice_ID
)
select *, (TotalRevenue/TotalCOG)*100 from cogVSTotal