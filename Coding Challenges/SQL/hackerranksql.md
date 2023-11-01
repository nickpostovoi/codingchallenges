URL: https://www.hackerrank.com/domains/sql

**Challenge 1: Revising the Select Query I**

Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.

The CITY table is described as follows:
<br />
![Alt text](assets/1449729804-f21d187d0f-CITY.jpg)

*Solution:*
<br />
```sql
SELECT *
FROM city
WHERE population > 100000 
    AND countrycode = 'USA';
```

**Challenge 2: Revising the Select Query II**

Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.

*Solution:*
<br />
```sql
SELECT name
FROM city
WHERE population > 120000 
    AND countrycode = 'USA';
```

