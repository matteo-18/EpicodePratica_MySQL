/* 
W10D1 - Pratica
Corso DataAnalyst EPICODE
DAPT0624
*/


USE AdventureWorksDW;

/* RICHIESTA N_1 - Esplora la tabelle dei prodotti (DimProduct) */

SELECT
	*
FROM
	dimproduct;


/* RICHIESTA N_2 - Interroga la tabella dei prodotti (DimProduct) 
ed esponi in output i campi ProductKey, ProductAlternateKey, EnglishProductName, 
Color, StandardCost, FinishedGoodsFlag. 
Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno. */

SELECT
	ProductKey AS ID_Prodotto
    , ProductAlternateKey AS ID_Modello
    , EnglishProductName AS NomeProdotto
    , Color AS Colore
    , StandardCost AS CostoStandard
    , FinishedGoodsFlag AS ProdottoFinito
FROM
	dimproduct;
    

/* RICHIESTA N_3 - Partendo dalla query scritta nel passaggio precedente, 
esponi in output i soli prodotti finiti cioè 
quelli per cui il campo FinishedGoodsFlag è uguale a 1.*/

SELECT
	ProductKey AS ID_Prodotto
    , ProductAlternateKey AS ID_Prodotto_Secondario
    , EnglishProductName AS NomeProdotto
    , Color AS Colore
    , StandardCost AS CostoStandard
    , FinishedGoodsFlag AS ProdottoFinito
FROM
	dimproduct
WHERE
	FinishedGoodsFlag = 1;
    
    
/* RICHIESTA N_4 - Scrivi una nuova query al fine di esporre in output 
i prodotti il cui codice modello (ProductAlternateKey) comincia con FR oppure BK. 
Il result set deve contenere il codice prodotto (ProductKey), 
il modello, il nome del prodotto, il costo standard (StandardCost) e il prezzo di listino (ListPrice). */

SELECT
	ProductKey AS ID_Prodotto
    , ProductAlternateKey AS ID_Modello
    , EnglishProductName AS NomeProdotto
    , Color AS Colore
    , StandardCost AS CostoStandard
    , ListPrice AS PrezzoListino
FROM
	dimproduct
WHERE
	ProductAlternateKey LIKE 'BK%' 
OR 
    ProductAlternateKey LIKE'FR%';
    
    
/* RICHIESTA N_5 - Arricchisci il risultato della query 
scritta nel passaggio precedente del Markup 
applicato dall’azienda (ListPrice - StandardCost) */

SELECT
	ProductKey AS ID_Prodotto
    , ProductAlternateKey AS ID_Modello
    , EnglishProductName AS NomeProdotto
    , Color AS Colore
    , StandardCost AS CostoStandard
    , ListPrice AS PrezzoListino
    , ListPrice- StandardCost AS Markup_applicato
FROM
	dimproduct
WHERE
	ProductAlternateKey LIKE 'BK%' 
OR 
    ProductAlternateKey LIKE'FR%';
    
    
/* RICHIESTA N_6 - Scrivi un’altra query al fine di 
esporre l’elenco dei prodotti finiti il cui prezzo 
di listino è compreso tra 1000 e 2000. */

SELECT
	EnglishProductName AS NomeProdotto
    , ListPrice AS PrezzoListino
FROM
	dimproduct
WHERE
	FinishedGoodsFlag = 1
    AND
	ListPrice <= 2000
    AND
    ListPrice >= 1000;


/* RICHIESTA N_7 - Esplora la tabella degli impiegati aziendali (DimEmployee) */

SELECT
	*
FROM
	dimemployee;
    

/* RICHIESTA N_8 - Esponi, interrogando la tabella degli impiegati aziendali, 
l’elenco dei soli agenti. Gli agenti sono i dipendenti 
per i quali il campo SalespersonFlag è uguale a 1. */

SELECT
	EmployeeKey AS ID_Impiegato
    , FirstName AS NomeImpiegato
    , LastName AS CognomeImpiegato
FROM
	dimemployee
WHERE
	SalesPersonFlag = 1;
    
    
/* RICHIESTA N_9 - Interroga la tabella delle vendite (FactResellerSales). 
Esponi in output l’elenco delle transazioni registrate a partire 
dal 1 gennaio 2020 dei soli codici prodotto: 597, 598, 477, 214. 
Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost). */

SELECT
	SalesOrderNumber AS N_Ordine
    , SalesOrderLineNumber AS N_RigaOrdine
	, ProductKey AS ID_Prodotto
    , OrderDate AS DataOrdine
    , SalesAmount - TotalProductCost AS Profitto
FROM
	factresellersales
WHERE
	OrderDate >= '2020-01-01'
    AND 
    ProductKey IN (597,598,477,214);