/* 
W10D4 - Pratica
Corso DataAnalyst EPICODE
DAPT0624
*/


USE AdventureWorksDW;

/* 1.Esponi l’anagrafica dei prodotti indicando per ciascun prodotto
 anche la sua sottocategoria (DimProduct, DimProductSubcategory). */
 
 SELECT
	ProductKey AS ID_Prodotto
	, EnglishProductName AS NomeProdotto
    , sub.ProductSubcategoryKey AS ID_Sottocategoria
    , EnglishProductSubcategoryName AS NomeSottocategoria
FROM
	dimproduct  p
	INNER JOIN 
	dimproductsubcategory sub
	ON
	p.ProductSubcategoryKey = sub.ProductSubcategoryKey;
 
 
 /* 2.Esponi l’anagrafica dei prodotti indicando per 
 ciascun prodotto la sua sottocategoria e la sua categoria 
 (DimProduct, DimProductSubcategory, DimProductCategory). */
 
SELECT
	ProductKey AS ID_Prodotto
	, EnglishProductName AS NomeProdotto
    , cat.ProductCategoryKey AS ID_Categoria
    , EnglishProductCategoryName AS NomeCategoria
    , sub.ProductSubcategoryKey AS ID_Sottocategoria
    , EnglishProductSubcategoryName AS NomeSottocategoria
FROM
	dimproduct p
	INNER JOIN 
	dimproductsubcategory sub
	ON
	p.ProductSubcategoryKey = sub.ProductSubcategoryKey
		INNER JOIN
		dimproductcategory cat
		ON
		sub.ProductCategoryKey = cat.ProductCategoryKey;
        

/* 3.Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales). */
 
-- mediante SUBQUERY
SELECT
	EnglishProductName AS ElencoProdottiVenduti
FROM
	dimproduct
WHERE
	ProductKey IN 
				(SELECT
					ProductKey
				 FROM
					factresellersales);
                    
-- mediante JOIN
SELECT DISTINCT
	p.ProductKey, 
	EnglishProductName
FROM
	dimproduct p
	INNER JOIN
    factresellersales s
	ON
    s.ProductKey = p.ProductKey;
    

/* 4.Esponi l’elenco dei prodotti non venduti 
(considera i soli prodotti finiti cioè quelli 
per i quali il campo FinishedGoodsFlag è uguale a 1). */
    
SELECT
	EnglishProductName AS ElencoProdottiNonVenduti
FROM
	dimproduct
WHERE
	ProductKey NOT IN 
				(SELECT
					ProductKey
				 FROM
					factresellersales)
AND
	FinishedGoodsFlag = 1;
    

/* 5.Esponi l’elenco delle transazioni di vendita (FactResellerSales) 
    indicando anche il nome del prodotto venduto (DimProduct) */

SELECT 
	SalesOrderNumber AS N_Ordine
	, SalesOrderLineNumber AS N_RigaOrdine
	, EnglishProductName AS NomeProdotto
FROM
	factresellersales s
	INNER JOIN
	dimproduct p
	ON
	s.ProductKey = p.ProductKey
ORDER BY
		SalesOrderNumber
        , SalesOrderLineNumber;


/* 6.Esponi l’elenco delle transazioni di vendita indicando 
la categoria di appartenenza di ciascun prodotto venduto. */


SELECT
	SalesOrderNumber AS N_Ordine
	, SalesOrderLineNumber AS N_RigaOrdine
	, EnglishProductName AS NomeProdotto
	, EnglishProductCategoryName AS NomeCategoria
FROM
	factresellersales s
	INNER JOIN
	dimproduct p
	ON
	s.ProductKey = p.ProductKey
		INNER JOIN 
		dimproductsubcategory sub
		ON
		p.ProductSubcategoryKey = sub.ProductSubcategoryKey
			INNER JOIN
			dimproductcategory cat
			ON
			sub.ProductCategoryKey = cat.ProductCategoryKey
ORDER BY
	SalesOrderNumber
    , SalesOrderLineNumber;


/* 7.Esplora la tabella DimReseller. */
SELECT
	*
fROM
	dimreseller;
    
    
/* 8.Esponi in output l’elenco dei reseller indicando,
    per ciascun reseller, anche la sua area geografica. */

SELECT
	ResellerName AS NomeRivenditore
	, EnglishCountryRegionName AS AreaGeografica
FROM
	dimreseller r
	JOIN
	dimgeography g
	ON
	r.GeographyKey = g.GeographyKey;
    
/* 9-Esponi l’elenco delle transazioni di vendita. 
Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, 
OrderDate, UnitPrice, Quantity, TotalProductCost. 
Il result set deve anche indicare il nome del prodotto, 
il nome della categoria del prodotto, il nome del reseller e l’area geografica. */

SELECT DISTINCT
	SalesOrderNumber AS N_Ordine
	, SalesOrderLineNumber AS N_RigaOrdine
	, OrderDate AS DataOrdine
    , EnglishProductName AS NomeProdotto
    , EnglishProductCategoryName AS NomeCategoria
    , UnitPrice AS PrezzoUnitario
    , OrderQuantity AS Quantità
    , TotalProductCost AS CostoTotProduzione
    , ResellerName AS NomeRivenditore
    , EnglishCountryRegionName AS AreaGeografica
FROM
	factresellersales s
	INNER JOIN
	dimproduct p
	ON
	s.ProductKey = p.ProductKey
		INNER JOIN 
		dimproductsubcategory sub
		ON
		p.ProductSubcategoryKey = sub.ProductSubcategoryKey
			INNER JOIN
			dimproductcategory cat
			ON
			sub.ProductCategoryKey = cat.ProductCategoryKey
				INNER JOIN
                dimgeography g
                ON
                s.SalesTerritoryKey = g.SalesTerritoryKey
					INNER JOIN 
                    dimreseller r
                    ON
                    s.ResellerKey = r.ResellerKey
ORDER BY
	SalesOrderNumber
    , SalesOrderLineNumber;