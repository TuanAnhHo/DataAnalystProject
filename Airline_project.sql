/* Having the first look with dataset */
/*The first table is airlinewise which contains 9 columns included: YEAR, MONTH, QUARTER,
AIRLINE NAME, CARRIER TYPE, PASSENGER T0 INDIA, PASSENGER FROM INDIA, FREIGHT TO INDIA,
FREIGHT FROM INDIA*/
SELECT * FROM airlinewise LIMIT 10;

/*The second table is citypairwise which contains 8 columns included: YEAR, QUARTER,
NAME OF CITY1 AND CITY2, NUMBER OF PASSENGERS, FREIGHT FROM CITY1 TO CITY2 AND VICE VERSA*/ 
SELECT * FROM citypairwise LIMIT 10;

/*The last table is countrywise which contains name of countris, number of passengers and freight
from country to another country*/
SELECT * FROM countrywise LIMIT 10;

/* Data contains information of flights from 2015 to 2017*/
SELECT DISTINCT YEAR FROM airlinewise;


/* Summary trend of international flights in INDIA from 2015 to Q1,2017*/
SELECT  YEAR
        ,QUARTER
        ,SUM(`PASSENGERS TO INDIA`) `PASSENGERS TO INDIA`
        ,SUM(`PASSENGERS FROM INDIA`) `PASSENGERS FROM INDIA`
        ,ROUND(SUM(`FREIGHT TO INDIA`), 0)  `FREIGHT TO INDIA`
        ,ROUND(SUM(`FREIGHT FROM INDIA`) ,0) `FREIGHT FROM INDIA` 
FROM countrywise
GROUP BY 1,2 
ORDER BY 1,2;

/* I count the number of airlines which have flights in India 
The result show that there 100 hundred airlines having flights from or to india
between 2015 and 2017*/
SELECT COUNT(uniq_airline) 
FROM (SELECT DISTINCT `AIRLINE NAME` AS uniq_airline FROM airlinewise) table1;

/* The results show that India just only had 5 domestic airlines from 2015 to 2017
and other flights are exploited by 95 foreign airlines*/ 
WITH table1 AS(SELECT DISTINCT `AIRLINE NAME`, `CARRIER TYPE`, COUNT(`AIRLINE NAME`)
                FROM airlinewise 
                GROUP BY `AIRLINE NAME`, `CARRIER TYPE`)
SELECT `CARRIER TYPE`,COUNT(*) 
FROM table1
GROUP BY `CARRIER TYPE`;

/* The frequency distribution of international air traffic from and to India
The most frequency of flights by each airlines' name is 27 and there are many airlanes having 
the same frequency*/
SELECT DISTINCT `AIRLINE NAME`, COUNT(`AIRLINE NAME`) number_of_flights
                FROM airlinewise 
                GROUP BY `AIRLINE NAME`, `CARRIER TYPE`
                ORDER BY 2 DESC;

/* In this statements, I want to find how many airlines having 27 international flights from India 
and to India. There are 77 airlines which satisfy above condtion, included:5 domestic airlines 
and 72 foreign airlines*/ 
WITH table1 AS (SELECT DISTINCT 
                        `AIRLINE NAME` 
                        ,`CARRIER TYPE` 
                        ,COUNT(`AIRLINE NAME`) `NUMBER OF FLIGHTS`
                FROM airlinewise 
                GROUP BY `AIRLINE NAME`, `CARRIER TYPE`
                ORDER BY 2 DESC)
SELECT `CARRIER TYPE`, COUNT(*)
FROM table1
WHERE `NUMBER OF FLIGHTS` = 27
GROUP BY 1;


/* Top 5 arlines having the largest number of passenger to india in between 2015 and 2017 */
WITH CTE1 AS (SELECT DISTINCT 
                YEAR
                ,`AIRLINE NAME`
                ,`CARRIER TYPE`
                ,SUM(`PASSENGERS TO INDIA`) `PASSENGERS TO INDIA`
            FROM airlinewise 
            GROUP BY 1,2,3
            ORDER BY 1,4 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/* Top 5 airlines having the largest number of passenger from India from 2015 to 2017 */
WITH CTE1 AS (SELECT DISTINCT 
                YEAR
                ,`AIRLINE NAME`
                ,`CARRIER TYPE`
                ,SUM(`PASSENGERS FROM INDIA`) `PASSENGERS FROM INDIA`
            FROM airlinewise 
            GROUP BY 1,2,3
            ORDER BY 1,4 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/* Total number of passengers from and to INDIA from 2015 to Q1,2017 by QUARTER */
SELECT 	QUARTER
		,SUM(`PASSENGERS FROM INDIA`) `PASSENGERS FROM INDIA`
        ,SUM(`PASSENGERS TO INDIA`) `PASSENGERS TO INDIA`
FROM airlinewise
GROUP BY 1;

/* Total number of passengers from and to INDIA from 2015 to Q1,2017 by MONTH */
SELECT 	MONTH
		,SUM(`PASSENGERS FROM INDIA`) `PASSENGERS FROM INDIA`
        ,SUM(`PASSENGERS TO INDIA`) `PASSENGERS TO INDIA`
FROM airlinewise
GROUP BY 1;

/* Total number of passengers from and to INDIA from 2015 to Q1,2017 by YEAR */
SELECT 	YEAR
		,SUM(`PASSENGERS FROM INDIA`) `PASSENGERS FROM INDIA`
        ,SUM(`PASSENGERS TO INDIA`) `PASSENGERS TO INDIA`
FROM airlinewise
GROUP BY 1;

/* Find airlines which do not work in India */
SELECT  YEAR
        ,MONTH
        ,COUNT(*)
FROM airlinewise
WHERE   `PASSENGERS TO INDIA` = 0 
        AND `PASSENGERS FROM INDIA` = 0
        AND `FREIGHT TO INDIA` = 0
        AND `FREIGHT FROM INDIA` = 0
GROUP BY 1,2;

/*Find the number of passengers travel to India and from India by QUARTER*/
SELECT  YEAR
        ,QUARTER 
        ,ROUND(SUM(`PASSENGERS TO INDIA`),1) `PASSENGERS TO INDIA`
        ,ROUND(SUM(`PASSENGERS FROM INDIA`),1) `PASSENGERS FROM INDIA`
        ,ROUND(SUM(`FREIGHT TO INDIA`),1) `FREIGHT TO INDIA`
        ,ROUND(SUM(`FREIGHT FROM INDIA`),1) `FREIGHT FROM INDIA`
FROM airlinewise
GROUP BY 1,2
ORDER BY 1,2;

/* How many passengers have flight routes from NEW DELHI (Capital of INDIA) and other CITY on the world by year*/ 
WITH CTE1 AS (SELECT 
                YEAR 
                ,CITY1
                ,CITY2
                ,SUM(`PASSENGERS FROM CITY2 TO CITY1`) `TOTAL PASSENGERS FROM NEW DELHI`
        FROM citypairwise
        WHERE CITY2 = 'DELHI'
        GROUP BY 1,2,3
        ORDER BY 1 ASC, 4 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);


/* Top 5 international flight routes which have the largest number of passengers from India by year*/
WITH CTE1 AS (SELECT    YEAR
                        ,CITY1 `NON-INDA CITY`  
                        ,CITY2 `INDIA CITY`
                        ,SUM(`PASSENGERS FROM CITY2 TO CITY1`) `TOTAL PASSENGERS FROM INDIA`
            FROM citypairwise
            GROUP BY 1,2,3
            ORDER BY 1, 4 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/* Top 5 international flight routes which have the largest number of passengers to India by year */
WITH CTE1 AS (SELECT    YEAR
                        ,CITY1 `NON-INDA CITY`  
                        ,CITY2 `INDIA CITY`
                        ,SUM(`PASSENGERS FROM CITY1 TO CITY2`) `TOTAL PASSENGERS TO INDIA`
            FROM citypairwise
            GROUP BY 1,2,3
            ORDER BY 1, 4 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/* Flights routes between HO CHI MINH CITY and INDA by year*/
SELECT  YEAR
        ,CITY1
        ,CITY2
        ,SUM(`PASSENGERS FROM CITY1 TO CITY2`) `FROM HCM CITY`
        ,SUM(`PASSENGERS FROM CITY2 TO CITY1`) `TO HCM CITY`
        ,SUM(`FREIGHT FROM CITY1 TO CITY2`) `FREIGHT FROM TO INDIA`
        ,SUM(`FREIGHT FROM CITY2 TO CITY1`) `FREIGHT FROM INDIA CITY`
FROM citypairwise
WHERE CITY1 = 'HO CHI MINH CITY' 
GROUP BY 1,3
ORDER BY 1;

/* Top 10 flight routes had the largest number of passengers to India*/
SELECT 	`COUNTRY NAME`
        ,SUM(`PASSENGERS TO INDIA`) 'PASSENGERS TO INDIA'
FROM countrywise
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
 /*Top 5 airlines transport the largest freight to India by YEAR*/ 
WITH CTE1 AS (SELECT  YEAR
		,`AIRLINE NAME`
        ,ROUND(SUM(`FREIGHT TO INDIA`), 0)  `FREIGHT TO INDIA`
FROM airlinewise
GROUP BY 1,2 
ORDER BY 1,3 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

 /*Top 5 airlines transport the largest freight from India by YEAR*/ 
 WITH CTE1 AS (SELECT  YEAR
		,`AIRLINE NAME`
        ,ROUND(SUM(`FREIGHT FROM INDIA`), 0)  `FREIGHT TO INDIA`
FROM airlinewise
GROUP BY 1,2 
ORDER BY 1,3 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/*The amount of freight by month-year*/
WITH CTE1 AS (SELECT  YEAR
		,QUARTER
        ,ROUND(SUM(`FREIGHT TO INDIA`), 0)  `FREIGHT TO INDIA`
FROM airlinewise
GROUP BY 1,2 
ORDER BY 1,3 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 5)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 5);

/* Which countries have the largest freight from India */
WITH CTE1 AS (SELECT  YEAR
		,`COUNTRY NAME`
        ,ROUND(SUM(`FREIGHT FROM INDIA`), 0)  `FREIGHT FROM INDIA`
FROM countrywise
GROUP BY 1,2 
ORDER BY 1,3 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 3)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 3)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 3);

/* Which countries have the largest freight to India */
WITH CTE1 AS (SELECT  YEAR
		,`COUNTRY NAME`
        ,ROUND(SUM(`FREIGHT TO INDIA`), 0)  `FREIGHT TO INDIA`
FROM countrywise
GROUP BY 1,2 
ORDER BY 1,3 DESC)
(SELECT * FROM CTE1 WHERE YEAR = 2015 LIMIT 3)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2016 LIMIT 3)
UNION
(SELECT * FROM CTE1 WHERE YEAR = 2017 LIMIT 3);