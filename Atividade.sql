USE Microsoft;


-- Crie uma visão que liste todos os funcionários que não são chefes
CREATE VIEW vw_funcionarios_nao_chefes
AS

SELECT E.FirstName, E.LastName, E.ReportsTo
FROM Employees AS E
WHERE E.ReportsTo IS NOT NULL

-- 2 Faça uma visão que liste a quantidade de vendas que cada produto(o quanto cada produto foi vendido)

CREATE VIEW vw_produtos
AS

SELECT P.ProductName ,SUM (O.Quantity) AS QUANTIDADE_VENDIDA, SUM(O.Quantity * P.UnitPrice) AS VALOR_VENDAS
FROM Products as p
INNER JOIN [Order Details] AS O ON (P.ProductID = O.ProductID)
GROUP BY P.ProductName

-- 3 Faça uma visao que liste os territórios e quantos vendedores estão vinculados a ele
CREATE VIEW vw_listar_territorios
AS
SELECT T.TerritoryID,T.TerritoryDescription, COUNT(E.EmployeeID) AS QUANTIDADE_VENDEDORES
FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON (ET.EmployeeID = E.EmployeeID)
INNER JOIN Territories AS T ON (ET.TerritoryID = T.TerritoryID)
GROUP BY T.TerritoryID, T.TerritoryDescription

-- 4 Faça uma visao que retorne o nome do cliente da venda de maior valor

CREATE VIEW vw_maior_venda AS
SELECT TOP 1 C.CompanyName AS NomeCliente, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS ValorTotalVenda
FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
GROUP BY O.OrderID, C.CompanyName
ORDER BY ValorTotalVenda DESC;

-- 5 Faça uma visao que liste os vendedores ordenados pela lucratividade.

CREATE VIEW vw_vendedores_lucratividade
AS
SELECT E.EmployeeID, E.FirstName AS NomeVendedor ,E.Title AS Cargo,
    COUNT(DISTINCT O.OrderID) AS TotalPedidos,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS LucroTotal
FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.Title
ORDER BY LucroTotal DESC;

-- 6 Faça uma visao que retorne os produtos, seu fornecedor, sua categoria, seu preço e a 
-- informação de ele estar descontinuado ou não, para aqueles que possuem estoque

CREATE VIEW vw_produtos_estoque AS
SELECT P.ProductName AS Produto,S.CompanyName AS Fornecedor,C.CategoryName AS Categoria,P.UnitPrice AS Preco,
   CASE P.Discontinued 
     WHEN 1 THEN 'DESCONTINUADO'
        ELSE 'ATIVO'
   END AS Status
FROM Products AS P
JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE P.UnitsInStock > 0;