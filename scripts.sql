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
ORDER BY rn.worldwide_gross ; 
--ANS Semi-Tough,1977,37187139

--2. What year has the highest average imdb rating?

SELECT s.release_year
      ,AVG(rt.imdb_rating) AS avg_imdb_rating
FROM specs AS s
     JOIN rating AS rt
	 ON s.movie_id=rt.movie_id
GROUP BY s.release_year
ORDER BY avg_imdb_rating DESC;
--ANS 1991,7.45

--3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT s.film_title
      ,s.mpaa_rating
	  ,db.company_name
	  ,MAX(worldwide_gross) AS highest_gross	  
FROM specs AS s
     JOIN distributors AS db
	 ON s.domestic_distributor_id=db.distributor_id
	 JOIN revenue
	 ON s.movie_id=revenue.movie_id
WHERE s.mpaa_rating ILIKE 'G'	 	 
GROUP BY s.film_title,s.mpaa_rating,db.company_name;	 

--ANS "The Lion King","G","Walt Disney ",763455561

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.company_name
       , COUNT(specs.film_title) AS total_movies
FROM distributors
      LEFT JOIN specs   
	  ON distributors.distributor_id=specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY total_movies DESC;	  

--5. Write a query that returns the five distributors with the highest average movie budget.


	 