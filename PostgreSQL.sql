-- Ahmed Mokhtar 
-- Assignment 1
-- Question 1
SELECT
	id,
    first || ' ' || last AS "first & last", -- this combines the names into one column
-- what I'm doing below is creating an age column and subtracting the end date from the birth date.
-- Some research on Stack Overflow was done to figure out how to subract dates.
    EXTRACT(YEAR FROM DATE '2023-12-31') - EXTRACT(YEAR FROM TO_DATE(birthdate, 'YYYY-MM-DD')) AS "Age",
    birthdate
FROM patients 
ORDER BY birthdate -- this orders the age in descending order
LIMIT 10; -- just getting the top 10
 
-- Question 2
WITH Age_CTE AS ( -- the first CTE is being made to get the age using a similar way to what was done in Q1.
SELECT
	id,
    first || ' ' || last AS "first & last", -- this combines the names into one column
    EXTRACT(YEAR FROM DATE '2023-12-31') - EXTRACT(YEAR FROM TO_DATE(birthdate, 'YYYY-MM-DD')) AS "age",
    birthdate
from patients
)
,Count_CTE AS ( -- the second CTE is made to get the total encounters for each patient
    SELECT 
        patient,
        COUNT(encounter) AS total_encounters
    FROM procedures
  	GROUP BY patient --this groups all the procedures by patient, so the number we get is per patient.
)
SELECT COUNT(id) --this just counts the total number of ids that fit the conditions below
FROM Count_CTE
JOIN Age_CTE ON Age_CTE.id = Count_CTE.patient -- joining by ids from each CTE
WHERE age >= 18 AND total_encounters > 5; --the conditions we are looking for.

-- Question 3
SELECT CASE -- I'm going to start by categorizing the levels of coverage as per the instructions using case when.
WHEN healthcare_coverage < 2000 then 'LOW'
WHEN healthcare_coverage >= 2000 and healthcare_coverage <= 5000 THEN 'MEDIUM'
WHEN healthcare_coverage >=5000 THEN 'HIGH'
END AS level_of_coverage,
AVG(healthcare_expenses) AS average_expense
from patients 
group by level_of_coverage order by average_expense;
-- I then grouped by the level of coverage and got the average expense for each level of coverage.demo

-- Question 4

SELECT 
    description,  
    COUNT(DISTINCT patient) AS total_patients,  -- this counts the total number of unique patients per procedure
    COUNT(patient) AS total_procedures  --this counts the total number of patients overall, giving us the total number of procedures that were done overall.
FROM procedures
JOIN patients ON patients.id = procedures.patient --left joining patients since the procedures table is where patient ids are repeated in multiple rows
WHERE healthcare_coverage < 2000 --this is only to include patients with low coverage as instructed
GROUP BY description --here we are grouping by the procedure that was done, which is crucial 
ORDER BY total_patients DESC , total_procedures DESC --ordering as necessary, first by unique patients then by total occurences
LIMIT 10; --only showing top 10

