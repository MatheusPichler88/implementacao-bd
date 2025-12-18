Nome: Matheus Dias Pichler

1) Transação é uma sequencia de operações de insert, update e delete, garantindo se o método é executado com sucesso ou nada aplicado, é o "tudo ou nada".
	Atomicidade: Garante que a transação seja executada ou não "tudo ou nada"
	Consistencia: Garante que a transação saia de um estado válido para outro estado válido
	Isolamento: Garante que a transação seja executada de forma isolada, sem que outras operações afetem.
	Durabilidade: Garante que a transação seja confirmada.


-- 2)
GO
Begin Transaction;

UPDATE Produtos 
SET PrecoVenda = 5.00
WHERE CodigoBarras = 7891360643734

IF @@ERROR <> 0 
	ROLLBACK TRANSACTION;
ELSE
	COMMIT TRANSACTION;
GO


3) Trigger são gatilhos a serem executados, eles são lançados após uma ação 
	After: After é depois da execução do bloco de código, primeiro ele executa e depois verifica.
	Instead of: é realizado durante a execução do código, realiza a verificação se vai executar ou não.

-- 4)
CREATE TRIGGER trg_estoque
ON Produtos
AFTER UPDATE
AS
BEGIN
-- a) Verificação de estoque
IF Quantidade > QuantidadeEstoque
BEGIN
	PRINT 'A quantidade de produtos vendidos é maior que a quantidade contida em estoque'
				RAINSERROR ('Erro: Estoque insuficiente para um ou mais produtos');
		ROLLBACK;
END
ELSE IF Quantidade = QuantidadeEstoque
BEGIN 
	PRINT'A quantidade de produtos vendidos é igual a quantidade contida em estoque'
END
ELSE
BEGIN
	PRINT 'Estoque suficiente!'
	
	UPDATE PRODUTOS 
	SET QuantidadeEstoque = (QuantidadeEstoque -1)
	
	UPDATE ItensVenda
	SET Quantidade = (Quantidade+1)

	UPDATE Vendas
	SET ValorTotal = ValorTotal + (Quantidade * PrecoUnitario)

-- 5)
CREATE TABLE tabela_log (
logID INT IDENTITY(1,1) PRIMARY KEY,
produtoID INT,
tipoOperacao CHAR(1) NOT NULL,
DataOperacao DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_log_up
ON PRODUTOS
AFTER UPDATE
AS
BEGIN

UPDATE Produtos
SET 

SELECT

END


-- 6)
CREATE TRIGGER trg_InativarCliente
ON CLIENTES
INSTEAD OF DELETE

IF DELETE FROM Clientes
BEGIN
UPDATE Clientes
SET Status = 'I'
END
ELSE
BEGIN
	PRINT 'O Cliente continua ativo'
END




7) Declarativas: são instruções realizadas no momento de criação da tabela, utilizando restrições como FK, Identity, Primary Key, NOT NULL.
	Proceduais: são instruções realizadas através de Transaction e Triggers, como regras de negócio.

-- 8)
SELECT *
FROM PRODUTOS AS P
INNER JOIN ItensVenda AS IV ON (P.CodigoBarras = IV.CodigoBarras)

UPDATE PRODUTOS
SET CodigoBarras = '123456798763422'
WHERE CodigoBarras = '7891027142474'

-- quando é ajustada a restrição nas tabelas, fazemos a alteração de atualização no código de barras acontece o efeito 'cascata', onde todas outras tabelas que contém o codigo de barras são alteradas


9) Views são tabelas virtuais, utilizada para evitar repetição de códigos que são utilizados com frequência e simplifica a consulta.

-- 10)
CREATE VIEW vw_RelatorioDetalhadoVendas

SELECT V.VendaID, V.DataVenda, C.Nome,P.Nome, CT.Nome , IV.Quantidade, IV.PrecoUnitario
FROM VENDAS AS V
INNER JOIN Clientes AS C ON (V.ClienteID = C.ClienteID)
INNER JOIN ItensVenda AS IV ON (V.VendaID = IV.VendaID)
INNER JOIN Produtos AS P ON (IV.CodigoBarras = P.CodigoBarras)
INNER JOIN Categorias AS CT ON (CT.CategoriaID = P.CategoriaID) 
INNER JOIN Fornecedores AS F ON (F.FornecedorID = P.FornecedorID)


11) Conceder permissão: Grant
	Restringir: Deny

--13)
CREATE VIEW vw_ProductCatalog

	SELECT P.Nome AS Nome_Produto, C.Nome AS Nome_Categoria, p.PrecoVenda AS Preço_Venda
	FROM Produtos AS P
	INNER JOIN Categorias AS C ON(P.CategoriaID = C.CategoriaID)
