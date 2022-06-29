-- Part 1: Create the table on a PostgreSQL database

DROP TABLE IF EXISTS staging_caers_events;

CREATE TABLE staging_caers_events(
   -- artificial primary key
    caers_event_id serial primary key,
    report_id varchar(255),
    created_date date,
    event_date date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age integer,
    age_units varchar(255),
    sex varchar(255),
    terms text,
    outcomes text
); 

-- Part 2: Import the data

copy staging_caers_events (
	report_id, created_date, event_date,
	product_type, product, product_code,
	description, patient_age, age_units,
	sex, terms, outcomes)
    from '/CAERS_ASCII_11_14_to_12_17.csv'
    (format csv, header, encoding 'LATIN1');


-- Part 3: Explore the data with various queries

--1. This query tries to determine how many of each type of products were created on each day
-- by counting the product code occurences and arranging this in descending order
SELECT created_date, product_code, COUNT(*) AS how_many_created
FROM staging_caers_events
GROUP BY created_date, product_code
ORDER BY COUNT(*) DESC
LIMIT 10;

--  created_date | product_code | how_many_created 
-- --------------+--------------+------------------
--  2014-04-15   | 54           |              196
--  2017-04-18   | 25           |              173
--  2014-04-14   | 54           |              163
--  2016-08-19   | 54           |              137
--  2016-08-04   | 53           |              135
--  2016-08-03   | 53           |              126
--  2017-03-22   | 53           |              126
--  2017-06-28   | 54           |              122
--  2016-07-29   | 53           |              118
--  2016-08-03   | 54           |              112
-- (10 rows)

-- This output shows that procucts with the code '54' were made the most on 2014-04-15. In the 
-- top 10 results, product code '54' occurs 50% of the time showing that it is a frequent/popular
-- product type made. 


--2. This query tries to see if there is a relationship between the terms and outcomes 
-- by counting the number of outcomes in each term and arranging the data in ascending 
-- order to see which term and outcom was the highest result 
SELECT terms, outcomes, COUNT(*) AS how_many
FROM staging_caers_events
GROUP BY terms, outcomes
ORDER BY COUNT(*) DESC
LIMIT 10;

--          terms         |                          outcomes                          | how_many 
-- -----------------------+------------------------------------------------------------+----------
--  OVARIAN CANCER        | Medically Important,                                       |     3145
--  OVARIAN CANCER        | Patient Visited Healthcare Provider, Medically Important,  |     2670
--  CHOKING               | Medically Important,                                       |      630
--  OVARIAN CANCER        | Death,                                                     |      533
--  ALOPECIA              | Medically Important,                                       |      428
--  ALOPECIA              | Other Outcome                                              |      368
--  OVARIAN CANCER        | Death, Patient Visited Healthcare Provider,                |      309
--  OVARIAN CANCER, DEATH | Death,                                                     |      291
--  DIARRHOEA             | Other Outcome                                              |      242
--  CHOKING, DYSPHAGIA    | Medically Important,                                       |      218
-- (10 rows)

-- This output shows that 'OVARIAN CANCER' was the most frequent medical condition as it appears as 
-- 50% of the output and has the highest amount of occurrences. In relation to outcomes,  
-- 'OVARIAN CANCER' has a variety of outcomes with 'Medically Important,' the most frequent outcome. 
-- It can also be seen that 'Medically Important,' is one of the highest outcomes. 

--3. Calculated the average age for each medical outcome to see if there was any relationship
-- between age and outcome
SELECT outcomes, ROUND(AVG(patient_age),2) AS avg_age 
FROM staging_caers_events
WHERE patient_age IS NOT NULL
GROUP BY outcomes
ORDER BY ROUND(AVG(patient_age),0) DESC
LIMIT 10;

--                                                   outcomes                                                   | avg_age 
-- -------------------------------------------------------------------------------------------------------------+---------
--  Death, Hospitalization, Required Intervention,                                                              |   81.00
--  Death, Hospitalization, Patient Visited Healthcare Provider, Patient Visited ER, Required Intervention,     |   78.00
--  Hospitalization, Patient Visited Healthcare Provider, Other Seriousness, Patient Visited ER,                |   76.00
--  Death, Hospitalization, Patient Visited Healthcare Provider, Required Intervention,                         |   76.00
--  Hospitalization, Disability, Patient Visited Healthcare Provider, Medically Important, Patient Visited ER,  |   75.00
--  Medically Important, Other Seriousness, Patient Visited ER,                                                 |   72.50
--  Hospitalization, Patient Visited Healthcare Provider, Medically Important, Required Intervention,           |   73.33
--  Medically Important, Patient Visited ER, Required Intervention,                                             |   72.14
--  Hospitalization, Patient Visited Healthcare Provider, Other Seriousness,                                    |   72.00
--  Life Threatening, Hospitalization, Patient Visited Healthcare Provider,                                     |   68.18
-- (10 rows)


-- This output shows that the outcomes associated with highest average age are mostly related to more serious outcomes such 
-- as 'Death' and 'Hospitalization.'

--4. Counted the occurrences of each product description and outcome to see if there which combination 
-- was the highest number of occurrences

SELECT description, outcomes, COUNT(*) AS how_many
FROM staging_caers_events
WHERE description IS NOT NULL
GROUP BY description, outcomes
ORDER BY COUNT(*) DESC
LIMIT 10;

--                description               |                          outcomes                          | how_many 
-- -----------------------------------------+------------------------------------------------------------+----------
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Medically Important,                                       |     9215
--   Cosmetics                              | Medically Important,                                       |     4822
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Patient Visited Healthcare Provider, Medically Important,  |     3517
--   Cosmetics                              | Patient Visited Healthcare Provider, Medically Important,  |     3419
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Hospitalization,                                           |     2949
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Other Outcome                                              |     2015
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Medically Important, Patient Visited ER,                   |     1573
--   Cosmetics                              | Other Outcome                                              |     1471
--   Cosmetics                              | Death,                                                     |     1321
--   Vit/Min/Prot/Unconv Diet(Human/Animal) | Hospitalization, Patient Visited ER,                       |     1099
-- (10 rows)

-- The outcome shows that the highest occurrences often happen with 'Vit/Min/Prot/Unconv Diet(Human/Animal)' products and 'Cosmetics' products. 
-- The outcomes that are related to these conditions are not too severe and include 'Medically Important,' 'Patient Visited Healthcare Provider', 
-- and 'Hospitalization.' 


-- Part 4: DDL


CREATE TABLE Report (
  report_key numeric,
  report_id varchar(255),
  created_date date,
  patient_id numeric,
  product_key text,a
  outcome text,
  PRIMARY KEY (report_key)
);

CREATE TABLE Patient (
  patient_id numeric,
  patient_age numeric,
  patient_gender varchar(255),,
  patient_condition text,
  PRIMARY KEY (patient_id)
);

CREATE TABLE Age (
  age_key numeric,
  age_units varchar(255),
  PRIMARY KEY (age_key)
);

CREATE TABLE Product (
  product_key numeric,
  product_type text,
  product text,
  product_code text,
  description text,
  PRIMARY KEY (product_key)
);

