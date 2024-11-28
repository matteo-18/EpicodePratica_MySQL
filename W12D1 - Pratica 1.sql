/* 
W12D1 - Pratica 1
Corso DataAnalyst EPICODE
DAPT0624
*/


USE sakila;


/* 2. Scoprite quanti clienti si sono registrati nel 2006. */

SELECT 
	COUNT(*) AS Clienti2006
FROM
	customer
WHERE
	YEAR(create_date) = 2006;
    
    
 /* 3. Trovate il numero totale di noleggi effettuati il giorno 1/1/2006. */   
    
SELECT 
	COUNT(*) AS TotNoleggi
FROM
	rental
WHERE
	DATE(rental_date) = '2006-02-14';
    
    
 /* 4. Elencate tutti i film noleggiati nell’ultima settimana 
 e tutte le informazioni legate al cliente che li ha noleggiati. */  
 
SELECT
	rental_id AS ID_Noleggio
    , rental_date AS DataNoleggio
	, title AS TitoloFilm
    , first_name AS NomeCliente
    , last_name AS CognomeCliente
    , email AS Indirizzo_email
FROM
	rental r
    JOIN
    inventory i
    ON
    r.inventory_id = i.inventory_id
		JOIN
        film f
        ON
        f.film_id = i.film_id
			JOIN
            customer c
            ON
            c.customer_id = r.customer_id
WHERE
	rental_date BETWEEN 
					(SELECT SUBDATE(max(rental_date), INTERVAL 1 WEEK) FROM rental) 
                    AND 
                    (SELECT max(rental_date) FROM rental);


/* 5. Calcolate la durata media del noleggio per ogni categoria di film. */

SELECT
	name AS NomeCategoria
	, AVG(TIMESTAMPDIFF(DAY, rental_date, return_date)) AS DurataMediaNoleggio
FROM
	rental r
    JOIN
    inventory i
    ON
    r.inventory_id = i.inventory_id
		JOIN
		film_category fc
		ON
		fc.film_id = i.film_id
			JOIN
            category c
            ON
            c.category_id = fc.category_id
GROUP BY 
	name;
    

/* 6. Trovate la durata del noleggio più lungo */

-- in giorni
SELECT
	rental_id AS ID_Noleggio
    , DATEDIFF(return_date, rental_date) AS DurataNoleggioGiorni
FROM
	rental
ORDER BY 2 DESC;

-- in ore
SELECT
	rental_id AS ID_Noleggio
    , TIMEDIFF(return_date, rental_date) AS DurataNoleggioOre
FROM
	rental
ORDER BY 2 DESC;
    
