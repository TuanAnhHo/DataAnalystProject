-- Graph 1
-- Education level and marital status of customers
SELECT education , marital_status, count(*)
FROM marketing 
GROUP BY 1,2
ORDER BY 1;

-- Calculate the average age of customers. The resutl is 53.1796
SELECT AVG(2022-year_birth) FROM marketing;

-- Graph 2
/*
INCOME GROUP 
Low income : Less than $32,048 per year
Lower-middle class : $32,048 - $53,413
Middle class : $53,413 - $106,827
Upper-middle class : $106,827 - $373,894
Rich : $373,894 and up 
*/
-- Classify customers into 3 groups including Young, Middle_aged, Old
WITH cte1 AS (SELECT id, kidhome + teenhome dependents,
			CASE 
				WHEN 2022-year_birth >= 18 AND 2022-year_birth <= 39 THEN 'Young' 
				WHEN 2022-year_birth >= 40 AND 2022-year_birth <= 59 THEN 'Middle_aged'
				WHEN 2022-year_birth >= 60 THEN 'Old' END AS age_gr
			FROM marketing),
	 cte2 AS (SELECT id, income,
			CASE 
				WHEN income < 32048 THEN 'Low income'
				WHEN income >= 32048 AND income < 53413 THEN 'Lower-middle class'
				WHEN income >= 53413 AND income < 106827 THEN 'Middle Class'
				WHEN income >= 106827 AND income < 373894 THEN 'Upper-middle class'
				WHEN income >= 373894 THEN 'Rich' END AS income_gr
			FROM marketing)
SELECT age_gr, dependents, income_gr, COUNT(*) num_customers
FROM cte1 JOIN cte2 ON cte1.id = cte2.id
GROUP BY 1,2,3
ORDER BY 1 ASC, 2 ASC;

-- Graph 3
-- RECENCY ANALYSIS
-- Number of days since the last purchase by income groups
WITH cte1 AS (SELECT id, CASE
				WHEN recency >= 0 AND recency < 30  THEN 'In a month'
				WHEN recency >= 30 AND recency < 60 THEN 'In two months'
				WHEN recency >= 60 AND recency < 90 THEN 'In three months'
				WHEN recency >= 90 THEN 'More than three months'
				END AS recency_gr
			FROM marketing),
	cte2 AS (SELECT id,
			CASE 
				WHEN income < 32048 THEN 'Low income'
				WHEN income >= 32048 AND income < 53413 THEN 'Lower-middle class'
				WHEN income >= 53413 AND income < 106827 THEN 'Middle Class'
				WHEN income >= 106827 AND income < 373894 THEN 'Upper-middle class'
				WHEN income >= 373894 THEN 'Rich' END AS income_gr
			FROM marketing)
SELECT recency_gr, income_gr, COUNT(*)
FROM cte1 JOIN cte2 ON cte1.id = cte2.id
GROUP BY 1,2
ORDER BY 1;

-- Graph 4
-- Amount spent on different products in the last 2 years according to number of dependents 
SELECT 	teenhome + kidhome dependents,
		SUM(mntwines) 'Spent on wine', 
		SUM(mntfruits) 'Spent on fruits',
        SUM(mntmeatproducts) 'Spent on meat',
        SUM(mntfishproducts) 'Spent on fish',
        SUM(mntsweetproducts) 'Spent on sweet products',
        SUM(mntgoldprods) 'Spent on gold'
FROM marketing 
GROUP BY 1
ORDER BY 1 ASC;

-- Graph 5
-- Amount spent on different products in last 2 years according to age of customers
WITH cte1 AS (SELECT id, kidhome + teenhome dependents, mntwines, 
						mntfruits, mntmeatproducts, mntfishproducts, mntsweetproducts, mntgoldprods,
			CASE 
				WHEN 2022-year_birth >= 18 AND 2022-year_birth <= 39 THEN 'Young' 
				WHEN 2022-year_birth >= 40 AND 2022-year_birth <= 59 THEN 'Middle_aged'
				WHEN 2022-year_birth >= 60 THEN 'Old' END AS age_gr
			FROM marketing)
SELECT 	age_gr,
		SUM(mntwines) 'Spent on wine', 
		SUM(mntfruits) 'Spent on fruits',
        SUM(mntmeatproducts) 'Spent on meat',
        SUM(mntfishproducts) 'Spent on fish',
        SUM(mntsweetproducts) 'Spent on sweet products',
        SUM(mntgoldprods) 'Spent on gold'
FROM cte1
GROUP BY 1
ORDER BY 1 ASC;

-- Graph 6
-- Amount spent on different products in last 2 years according to income group
WITH cte1 AS (SELECT id, kidhome + teenhome dependents, mntwines, 
						mntfruits, mntmeatproducts, mntfishproducts, mntsweetproducts, mntgoldprods,
			CASE 
				WHEN income < 32048 THEN 'Low income'
				WHEN income >= 32048 AND income < 53413 THEN 'Lower-middle class'
				WHEN income >= 53413 AND income < 106827 THEN 'Middle Class'
				WHEN income >= 106827 AND income < 373894 THEN 'Upper-middle class'
				WHEN income >= 373894 THEN 'Rich' END AS income_gr
			FROM marketing)
SELECT 	income_gr,
		SUM(mntwines) 'Spent on wine', 
		SUM(mntfruits) 'Spent on fruits',
        SUM(mntmeatproducts) 'Spent on meat',
        SUM(mntfishproducts) 'Spent on fish',
        SUM(mntsweetproducts) 'Spent on sweet products',
        SUM(mntgoldprods) 'Spent on gold'
FROM cte1
GROUP BY income_gr;

-- Graph 7
-- Number of purchases made by different kinds by education level
SELECT education, 	SUM(numdealspurchases) pur_with_disc, 
					SUM(numstorepurchases) pur_in_store,
                    SUM(numwebpurchases) pur_through_web,
					SUM(numcatalogpurchases) pur_using_catalogue
FROM marketing 
GROUP BY 1;

-- Graph 8 
-- Number of purchases made by different kinds by age groups
SELECT 
	CASE 
		WHEN 2022-year_birth >= 18 AND 2022-year_birth <= 39 THEN 'Young' 
		WHEN 2022-year_birth >= 40 AND 2022-year_birth <= 59 THEN 'Middle_aged'
		WHEN 2022-year_birth >= 60 THEN 'Old' END AS age_gr,
		SUM(numdealspurchases) pur_with_disc, 
		SUM(numstorepurchases) pur_in_store,
		SUM(numwebpurchases) pur_through_web,
		SUM(numcatalogpurchases) pur_using_catalogue
FROM marketing
GROUP BY age_gr;	

-- Graph 9 
-- Number of visits to website by age group
SELECT 	CASE
		WHEN 2022-year_birth >= 18 AND 2022-year_birth <= 39 THEN 'Young' 
		WHEN 2022-year_birth >= 40 AND 2022-year_birth <= 59 THEN 'Middle_aged'
		WHEN 2022-year_birth >= 60 THEN 'Old' 
        END AS age_gr,
		SUM(numwebvisitsmonth)
FROM marketing 
GROUP BY age_gr;

-- Graph 10
-- Number of visits to website by income group
SELECT 	CASE 
		WHEN income < 32048 THEN 'Low income'
		WHEN income >= 32048 AND income < 53413 THEN 'Lower-middle class'
		WHEN income >= 53413 AND income < 106827 THEN 'Middle Class'
		WHEN income >= 106827 AND income < 373894 THEN 'Upper-middle class'
		WHEN income >= 373894 THEN 'Rich' END AS income_gr,
		SUM(numwebvisitsmonth) num_visits_web
FROM marketing 
GROUP BY income_gr;

-- Graph 11 
-- Number of customers accepted marketing campaign
WITH cte1 AS (SELECT 
				CASE
					WHEN acceptedcmp1 = 1 THEN 'Accept'
					WHEN acceptedcmp1 = 0 THEN 'Reject'
					END AS decision,
					COUNT(*) campaign1
			FROM marketing
			GROUP BY 1),
	cte2 AS (SELECT 
				CASE
					WHEN acceptedcmp2 = 1 THEN 'Accept'
					WHEN acceptedcmp2 = 0 THEN 'Reject'
				END AS decision,
				COUNT(*) campaign2
                FROM marketing
				GROUP BY 1),
	cte3 AS (SELECT 
				CASE
					WHEN acceptedcmp3 = 1 THEN 'Accept'
					WHEN acceptedcmp3 = 0 THEN 'Reject'
				END AS decision,
				COUNT(*) campaign3
                FROM marketing
				GROUP BY 1),
	cte4 AS (SELECT 
				CASE
					WHEN acceptedcmp4 = 1 THEN 'Accept'
					WHEN acceptedcmp4 = 0 THEN 'Reject'
				END AS decision,
				COUNT(*) campaign4
                FROM marketing
				GROUP BY 1),
	cte5 AS (SELECT 
				CASE
					WHEN acceptedcmp5 = 1 THEN 'Accept'
					WHEN acceptedcmp5 = 0 THEN 'Reject'
				END AS decision,
				COUNT(*) campaign5
                FROM marketing
				GROUP BY 1)
SELECT cte1.decision,	campaign1/(SELECT COUNT(ID) FROM marketing) campaign1, 
						campaign2/(SELECT COUNT(ID) FROM marketing) campaign2, 
                        campaign3/(SELECT COUNT(ID) FROM marketing) campaign3, 
                        campaign4/(SELECT COUNT(ID) FROM marketing) campaign4, 
                        campaign5/(SELECT COUNT(ID) FROM marketing) campaign5 
FROM cte1 
JOIN cte2 ON cte1.decision = cte2.decision
JOIN cte3 ON cte2.decision = cte3.decision
JOIN cte4 ON cte3.decision = cte4.decision
JOIN cte5 ON cte4.decision = cte5.decision;

-- Graph 12
-- Complain of customer 
SELECT 
	CASE 
	WHEN complain = 1 THEN 'YES'
    WHEN complain = 0 THEN 'NO'
    END AS complain,
    COUNT(*) number_of_complains
FROM marketing
GROUP BY complain; 






