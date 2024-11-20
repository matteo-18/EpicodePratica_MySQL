/* 
W11D1 - Pratica
Corso DataAnalyst EPICODE
DAPT0624
*/

USE AdventureWorksDW;


/* 1.Scrivi una query per verificare che il campo ProductKey 
nella tabella DimProduct sia una chiave primaria. 
Quali considerazioni/ragionamenti è necessario che tu faccia? */

SELECT
	COUNT(ProductKey) AS ConteggioValoriProductKey
    , COUNT((SELECT DISTINCT ProductKey)) AS ConteggioValoriUnivociProductKey
FROM
		dimproduct;
        
/* CONSIDERAZIONI; SELECT DISTINCT è una clausola che restituisce
in output tutti i valori della colonna selezionata rimuovendone i duplicati.
Per definizione, una chiave primaria è una colonna che contiene solo valori univoci,
quindi seguendo questo ragionamento ci aspettiamo che la colonna di output 
SELECT DISTINCT sia uguale all'originale e quindi abbia lo stesso n° di valori. */


 /* 2.Scrivi una query per verificare che la combinazione 
 dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK. */
 
SELECT
	COUNT(
		CONCAT
			(SalesOrderNumber, '-', SalesOrderLineNumber)) AS ConteggioCombSON_SOLN
    , COUNT(
		(SELECT DISTINCT(
			CONCAT
				(SalesOrderNumber, '-', SalesOrderLineNumber)))) AS ConteggioValUnivCombSON_SOLN
FROM
	factresellersales;
    

/* 3.Conta il numero transazioni (SalesOrderLineNumber) 
realizzate ogni giorno a partire dal 1 Gennaio 2020. */

SELECT
	OrderDate AS DataOrdine
	, COUNT(SalesOrderLineNumber) AS N_tot_transazioni
FROM
	factresellersales
WHERE
	OrderDate >= '2020-01-01'
GROUP BY
	OrderDate;
    
    
/* 4.Calcola il fatturato totale (FactResellerSales.SalesAmount), 
la quantità totale venduta (FactResellerSales.OrderQuantity) e 
il prezzo medio di vendita (FactResellerSales.UnitPrice) 
per prodotto (DimProduct)  a partire dal 1 Gennaio 2020. 
Il result set deve esporre pertanto il nome del prodotto, 
il fatturato totale, la quantità totale venduta e il prezzo medio
 di vendita. I campi in output devono essere parlanti! */
 
SELECT
	p.ProductKey AS ID_Prodotto
	, EnglishProductName AS NomeProdotto
    , CONCAT('$ ', SUM(SalesAmount)) AS FatturatoTotale
	, SUM(OrderQuantity) AS QuantitàVenduta
    , CONCAT('$ ', AVG(UnitPrice)) AS PrezzoMedio
FROM
	factresellersales s
    JOIN
    dimproduct p
    ON
    s.ProductKey = p.ProductKey
WHERE 
	OrderDate >= '2020-01-01'
GROUP BY
	p.ProductKey;
    
    
/* 5.Calcola il fatturato totale (FactResellerSales.SalesAmount) 
e la quantità totale venduta (FactResellerSales.OrderQuantity) 
per Categoria prodotto (DimProductCategory). Il result set deve esporre 
pertanto il nome della categoria prodotto, il fatturato totale e 
la quantità totale venduta. I campi in output devono essere parlanti! */

SELECT
	c.ProductCategoryKey AS ID_Categoria
	, EnglishProductCategoryName AS NomeCategoria
    , CONCAT('$ ', SUM(SalesAmount)) AS FatturatoTotale
	, SUM(OrderQuantity) AS QuantitàVenduta
FROM
	factresellersales s
    JOIN
    dimproduct p
    ON
    s.ProductKey = p.ProductKey
		JOIN
        dimproductsubcategory sub
        ON
        p.ProductSubcategoryKey = sub.ProductSubcategoryKey
			JOIN
            dimproductcategory c
            ON
            sub.ProductCategoryKey = c.ProductCategoryKey        
GROUP BY
	c.ProductCategoryKey;
    
/* 6.Calcola il fatturato totale per area città (DimGeography.City) 
realizzato a partire dal 1 Gennaio 2020. Il result set deve esporre 
l’elenco delle città con fatturato realizzato superiore a 60K. */
    
SELECT
	City AS Città
    , CONCAT('$ ', SUM(SalesAmount)) AS FatturatoTotale
FROM
	factresellersales s
    JOIN
    dimreseller r
    ON
    s.ResellerKey = r.ResellerKey
		JOIN
        dimgeography g
        ON
        r.GeographyKey = g.GeographyKey
GROUP BY
	City
HAVING
	SUM(SalesAmount) > 60000;