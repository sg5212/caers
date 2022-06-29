<html lang="en">
<head>
  <h1>CAERS</h1>
  <meta charset="utf-8">
</head>
<body>

<div class="alert alert-info">
Creating, Importing, Exploring, and DDL
</div>

</body>
</html>


## Part 1: Explore the Data 
--1. This output shows that procucts with the code '54' were made the most on 2014-04-15. In the 
-- top 10 results, product code '54' occurs 50% of the time showing that it is a frequent/popular
-- product type made. 

--2. This output shows that 'OVARIAN CANCER' was the most frequent medical condition as it appears as 
-- 50% of the output and has the highest amount of occurrences. In relation to outcomes,  
-- 'OVARIAN CANCER' has a variety of outcomes with 'Medically Important,' the most frequent outcome. 
-- It can also be seen that 'Medically Important,' is one of the highest outcomes. 

--3. This output shows that the outcomes associated with highest average age are mostly related to more serious outcomes such 
-- as 'Death' and 'Hospitalization.'

--4. The outcome shows that the highest occurrences often happen with 'Vit/Min/Prot/Unconv Diet(Human/Animal)' products and 'Cosmetics' products. 
-- The outcomes that are related to these conditions are not too severe and include 'Medically Important,' 'Patient Visited Healthcare Provider', 
-- and 'Hospitalization.' 


## Part 2: Examine a data set and create a normalized data model to store the data

![ER Diagram for 'staging_caers_events'](https://github.com/sg5212/caers/blob/main/img/part2_caers_er_diagram.png)

I created 4 entities each with attributes based on the CSV file. The entities I chose to create were 'Report,' 'Patient,' 'Product,' and 'Age.' I connected the 4 tables through the use of foreign keys by finding the relationship between the entities. 