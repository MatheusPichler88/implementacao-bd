DECLARE @idade INT,
		@nome Varchar(50),
		@data DATE,
		@dinheiro MONEY;
		
SET @nome = 'Matheus Dias Pichler';
SET @data = '2002-09-29'; --AAAA-MM_DD
SET @dinheiro = 3;
SET @idade = YEAR(GETDATE()) - YEAR(@data)

SELECT  @nome as 'Nome', @data as 'Data_Nasc',
		@dinheiro as 'Dinheiro', @idade as 'Idade'

PRINT 'Meu nome é: ' +@nome+
', nascido em: ' + CAST(@data AS Varchar(10));


