/* 
W12D1 - Pratica 2
Corso DataAnalyst EPICODE
DAPT0624
*/

USE sakila;


/* 1. Identificate tutti i clienti che non hanno 
effettuato nessun noleggio a gennaio 2006. */

-- CON SUBQUERY
SELECT 
	customer_id AS ID_Cliente
    , first_name AS NomeCliente
    , last_name AS CognomeCliente
FROM 
	customer
WHERE
	customer_id NOT IN (SELECT DISTINCT customer_id
						FROM rental
                        WHERE rental_date BETWEEN '2006-02-01' AND '2006-02-28');

-- CON JOIN
SELECT 
	c.customer_id AS ID_Cliente
    , first_name AS NomeCliente
    , last_name AS CognomeCliente
FROM
	customer c
LEFT JOIN 
	rental r
ON c.customer_id = r.customer_id AND rental_date BETWEEN '2006-02-01' AND '2006-02-28'
WHERE rental_id IS NULL;

/* 2. Elencate tutti i film che sono stati noleggiati 
più di 10 volte nell’ultimo quarto del 2005 */


SELECT
	f.film_id AS ID_Film
    , title AS TitoloFilm
	, COUNT(*) AS 'Conteggio>10Noleggi2005UltimoTrimestre'
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
WHERE
	QUARTER(rental_date) = 3
    AND
    YEAR(rental_date) = 2005
GROUP BY 
	f.film_id
HAVING
	COUNT(*) > 10
ORDER BY 
	COUNT(*) DESC;
    

/* 3. Trovate il numero totale di noleggi effettuati il giorno 1/1/2006. */

SELECT
	COUNT(*) AS ConteggioNoleggi14Feb2006
FROM
	rental
WHERE
	DATE(rental_date) = '2006-02-14';
    
    
/* 4. Calcolate la somma degli incassi generati nei weekend (sabato e domenica). */

SELECT
	SUM(amount) AS SommaIncassiWeekend
FROM
	payment
WHERE
	DAYOFWEEK(payment_date) = 7
    OR
	DAYOFWEEK(payment_date) = 1;
    
    
/* 5. Individuate il cliente che ha speso di più in noleggi. */

SELECT
	c.customer_id AS ID_Cliente
    , first_name AS NomeCliente
    , last_name AS CognomeCliente
	, SUM(amount) AS SpesaTotale
FROM
	payment p
    JOIN
    customer c
    ON
    p.customer_id = c.customer_id
GROUP BY
	c.customer_id
ORDER BY
	 SUM(amount) DESC
LIMIT 1;


/* 6. Elencate i 5 film con la maggior durata media di noleggio */

SELECT
	f.film_id AS ID_Film
	, title AS TitoloFilm
	, AVG(DATEDIFF(return_date, rental_date)) AS DurataMediaNoleggio
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
GROUP BY 
	f.film_id
ORDER BY
	DurataMediaNoleggio DESC
LIMIT 5;


/* 7. Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente.*/

SELECT
	customer_id AS ID_Cliente
	, MIN(rental_date) AS DataPrimoNoleggio
    , MAX(rental_date) AS DataUltimoNoleggio
    , COUNT(rental_id) AS N_NoleggiTotali
    , TIMESTAMPDIFF(HOUR, MIN(rental_date), MAX(rental_date)) / COUNT(rental_id) AS 'TempoMedioNoleggiConsecutivi(Ore)'
FROM
	rental
GROUP BY
	customer_id
ORDER BY
	customer_id;
    

/* 8. Individuate il numero di noleggi per ogni mese del 2005. */

SELECT
	MONTHNAME(rental_date) AS 'MeseNoleggio(2005)'
	, COUNT(*) AS N_Noleggi
FROM
	rental
WHERE
	YEAR(rental_date) = 2005
GROUP BY
	MONTHNAME(rental_date);


/* 9. Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno. */

SELECT
	Tab.ID_Film AS ID_Film
    , Tab.TitoloFilm AS TitoloFilm
    , COUNT(*) AS N_DateNoleggioMultiplo
FROM
(SELECT
	f.film_id AS ID_Film
    , title AS TitoloFilm
	, DATE(rental_date) AS Data
	, COUNT(*) AS ConteggioNoleggi
FROM rental r 
	JOIN inventory i ON r.inventory_id = i.inventory_id 
    JOIN film f ON f.film_id = i.film_id
GROUP BY
	Data , f.film_id
HAVING
	COUNT(*) > 1) AS Tab
GROUP BY
	Tab.ID_Film;                                            
                                            
/* 10. Calcolate il tempo medio di noleggio. */

SELECT
	AVG(TIMESTAMPDIFF(DAY, rental_date, return_date)) AS DurataMediaNoleggio
FROM
	rental;
