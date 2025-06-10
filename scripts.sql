--SELECT * FROM distributors
--SELECT * FROM rating 
--SELECT * FROM revenue
--SELECT * FROM specs

--1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT s.film_title
      ,s.release_year
	  ,rn.worldwide_gross
FROM specs AS s
 JOIN revenue AS rn
      ON s.movie_id=rn.movie_id
ORDER BY rn.worldwide_gross
LIMIT 1; 
--ANS Semi-Tough,1977,37187139

--2. What year has the highest average imdb rating?

SELECT s.release_year
      ,ROUND(AVG(rt.imdb_rating),2) AS avg_imdb_rating
FROM  specs AS s
 JOIN rating AS rt
	 ON s.movie_id=rt.movie_id
GROUP BY s.release_year
ORDER BY avg_imdb_rating DESC
LIMIT 1;
--ANS 1991,7.45

--3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	 s.film_title
   	,s.mpaa_rating
	,db.company_name
	,MAX(worldwide_gross) AS highest_gross	  
FROM specs AS s
JOIN distributors AS db	 
	ON s.domestic_distributor_id = db.distributor_id
JOIN revenue
	 ON s.movie_id = revenue.movie_id
WHERE  
	s.mpaa_rating ILIKE 'G'	
GROUP BY s.film_title, s.mpaa_rating, db.company_name
LIMIT 1;	

--ANS "The Lion King","G","Walt Disney ",763455561

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.company_name
      , COUNT(specs.film_title) AS total_movies
FROM   distributors
LEFT JOIN specs   
	  ON distributors.distributor_id=specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY total_movies DESC;	  

--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT 
	 company_name
	,ROUND(AVG(film_budget),2) AS avg_movie_budget
FROM distributors
JOIN specs
	ON distributors.distributor_id=specs.domestic_distributor_id
JOIN revenue
  	ON specs.movie_id=revenue.movie_id
GROUP BY distributors.company_name
ORDER BY avg_movie_budget DESC
LIMIT 5

/*
"company_name"	"avg_movie_budget"
"Walt Disney "	148735526.32
"Sony Pictures"	139129032.26
"Lionsgate"	122600000.00
"DreamWorks"	121352941.18
"Warner Bros."	103430985.92
*/

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT company_name,COUNT(film_title) AS total_movies,MAX(imdb_rating) AS highest_imdb_rating
FROM  distributors
JOIN  specs
  ON  distributors.distributor_id=specs.domestic_distributor_id
JOIN  rating
USING (movie_id)
WHERE headquarters NOT ILIKE('%CA')
GROUP BY company_name
ORDER BY highest_imdb_rating DESC
--LIMIT 1

 
/*ANS
"company_name"	"total_movies"	"highest_imdb_rating"
"Vestron Pictures"	1	7.0
"IFC Films"	1	6.5
*/

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT 'movies < 2 hours' AS movie_time, AVG(imdb_rating)
FROM specs
JOIN rating
	USING(movie_id)
WHERE  length_in_min <120
--UNION
SELECT 'movies > 2 hours' AS movie_time ,AVG(imdb_rating)
FROM specs
JOIN rating
	USING(movie_id)
WHERE  length_in_min >120
--GROUP BY film_title