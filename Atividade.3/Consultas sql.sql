USE EMPRESA;

SELECT F.PNOME, F.UNOME, D.DNOME
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
ON F.DNR = D.Dnumero
WHERE D.Dnome = 'PESQUISA';

SELECT F.PNOME, F.UNOME, P.Projnome
FROM FUNCIONARIO AS F
INNER JOIN TRABALHA_EM AS TE
ON TE.Fcpf = F.Cpf
INNER JOIN PROJETO AS P
ON TE.Pnr = P.Projnumero
WHERE P.Projnome = 'PRODUTOX';

SELECT P.Projnumero, D.DNUMERO, F.Unome, F.Endereco,F.Datanasc
FROM PROJETO AS P
INNER JOIN DEPARTAMENTO AS D
ON P.Dnum = D.Dnumero
INNER JOIN FUNCIONARIO AS F
ON D.Cpf_gerente = F.Cpf
WHERE P.Projlocal = 'MAUÁ';

-- LEFT JOIN
SELECT F.Pnome AS 'F_NOME',
F.UNOME AS 'F_SOBRENOME',
S.PNOME AS 'SUPERVISOR'
FROM FUNCIONARIO AS F
LEFT JOIN FUNCIONARIO AS S -- TABELA DOS SUPERVISORES
ON F.Cpf = S.Cpf_supervisor;

-- DEPARTAMENTOS QUE NÃO POSSUEM FUNCIONARIOS CADASTRADOS.
SELECT *
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
ON D.Dnumero = F.DNR
WHERE F.CPF IS NULL;

--FUNCIONARIO QUE NÃO POSSUEM DEPARTAMENTOS CADASTRADOS
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Dnr IS NULL;

--FULL JOIN
SELECT *
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;

-- UNION
SELECT F.Pnome, F.Sexo, F.Datanasc
FROM FUNCIONARIO AS F
UNION
SELECT D.Nome_dependente, D.Sexo, D.Datanasc
FROM DEPENDENTE AS D

SELECT P.Projlocal
FROM PROJETO AS P
UNION
SELECT L.Dlocal
FROM LOCALIZACAO_DEP AS L;

--UNION ALL
SELECT P.Projlocal
FROM PROJETO AS P
UNION ALL
SELECT L.Dlocal
FROM LOCALIZACAO_DEP AS L;

-- EXCEPT
SELECT F.Cpf
FROM FUNCIONARIO AS F
EXCEPT
SELECT D.Cpf_gerente
FROM DEPARTAMENTO AS D;

-- Funcionários que não são supervisores
SELECT F.Pnome, F.Unome
FROM FUNCIONARIO AS F
WHERE F.Cpf IN (
SELECT F.Cpf
FROM FUNCIONARIO AS F
EXCEPT
SELECT F.Cpf_supervisor
FROM FUNCIONARIO AS F
);

-- INTERSECT
-- Encontre os funcionários que são supervisores
SELECT F.Cpf_supervisor 
FROM FUNCIONARIO AS F
INTERSECT 
SELECT F.Cpf
FROM FUNCIONARIO AS F;

--GROUP BY
SELECT D.Dnome AS 'DEPARTAMENTO', COUNT (F.Cpf) AS 'N_FUNCIONARIOS'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
;

-- Soma os salários por departamentos
SELECT D.Dnome AS 'DEPARTAMENTO', SUM(F.Salario) AS 'S_FUNCIONARIOS'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
;

--Média de horas trabalhadas por projetos.
SELECT p.Projnome AS 'Projetos', AVG(T.Horas) AS 'HORAS TRABALHADAS'
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P
ON P.Projnumero = T.Pnr
GROUP BY P.Projnome
;

--Quantidade de funcionários por sexo.
SELECT COUNT(F.CPF), F.SEXO
FROM FUNCIONARIO AS F
GROUP BY F.SEXO

--Maior salário de cada departamento
SELECT D.Dnome AS 'DEPARTAMENTO', MAX(F.Salario) AS 'S_FUNCIONARIOS'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome

--Encontrar departamento com mais de 3 funcionários
SELECT D.Dnome AS 'DEPARTAMENTO', COUNT(F.CPF) AS 'N_FUNCIONARIOS'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
HAVING COUNT(F.CPF) >3;

--Listar projetos que exigem no minímo 50 horas de trabalho
SELECT P.Projnome AS 'Projeto', SUM(T.Horas) AS 'Horas'
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P
  ON T.Pnr = P.Projnumero
GROUP BY P.Projnome
HAVING SUM(T.Horas) >= 50;

--EXISTS
SELECT F.Pnome, F.Unome, F.Cpf
FROM FUNCIONARIO AS F
WHERE EXISTS(
SELECT 1
FROM DEPARTAMENTO AS D
WHERE D.Cpf_gerente = F.Cpf
)
-- Listar departamentos que possuem projetos associados
SELECT D.Dnome, d.Dnumero
FROM DEPARTAMENTO AS D
WHERE EXISTS (
SELECT *
FROM PROJETO AS P 
WHERE P.Dnum = D.Dnumero
)
--ALL
--Encontrar funcionarios que ganham mais do que qualquer funcionario do departamento "Administração"
SELECT F.Pnome, F.Unome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.SALARIO > ALL(
SELECT F.Salario
FROM FUNCIONARIO as F 
INNER JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Administração'
);

--Encontrar projetos que exigem mais horas do que todos os projetos no local 'Itu ou Santo André'

SELECT P.Projnome, SUM(TE.Horas)
FROM PROJETO AS P
INNER JOIN TRABALHA_EM AS TE ON TE.Pnr = P.Projnumero
GROUP BY P.Projnome
HAVING SUM(TE.Horas) > ALL (
	SELECT P.Projlocal, SUM(TE.Horas)
	FROM PROJETO AS P
	INNER JOIN TRABALHA_EM AS TE ON( TE.Pnr = P.Projnumero)
	WHERE P.Projlocal = 'Itu' OR P.Projlocal = 'Santo André'
	GROUP BY P.Projlocal
	)

-- Recuperando o nome do departamento = 4
DECLARE @nome Varchar(100)
SELECT @nome = d.Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4

SELECT @nome as 'Nome do Departamento'
PRINT @nome

-- Calculando o novo salário com um aumento de 10% para a Jennifer

DECLARE @nome_funcionario VARCHAR(100),
		@salario DECIMAL(10,2),
		@aumento DECIMAL(10,2),
		@novo_salario DECIMAL (10,2)

SET @nome_funcionario = 'Jennifer'
SET @aumento = 10
SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome_funcionario
SET @novo_salario = @salario*(1+@aumento/100)
SELECT @nome_funcionario AS 'Nome', @salario AS 'Salario',
	   @aumento AS '%', @novo_salario AS 'Novo Salário'

--Calculando a idade da Jennifer

DECLARE @nome_funcionario Varchar(100),
		@idade INT,
		@salario DECIMAL(10,2)
SET @nome_funcionario = 'Jennifer'

SELECT @idade = YEAR(GETDATE()) - YEAR(F.Datanasc)
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome_funcionario


--Cast

--Convert
SELECT F.Pnome, CONVERT(VARCHAR(10), F.Datanasc, 103) AS 'Data nascimento'
FROM FUNCIONARIO AS F

-- IF AND ELSE

--Verificar se um funcionário recebe abaixo da média salarial

DECLARE @Salario_Func DECIMAL (10,2),
		@Media_salario DECIMAL (10,2),
		@nome_func VARCHAR(100) = 'Joice';

SELECT @Media_salario = AVG(F.Salario)
FROM FUNCIONARIO AS F;

SELECT @Salario_Func = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome_func

IF @Salario_Func < @Media_salario
	print @nome_func + ' recebe abaixo da média'
ELSE
	PRINT @nome_func + ' recebe na média ou acima'

--Verificar se um funcionário está proximo da aposentadoria, considerar a idade para aposentadoria de 60 anos.

SELECT F.Pnome, YEAR(GETDATE()) - YEAR(F.Datanasc) AS 'Idade'
FROM FUNCIONARIO AS F

DECLARE @nome_aposentadoria VARCHAR(100) = 'Ronaldo',
		@idade_aposentadoria INT;
	
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome_aposentadoria;

IF @idade_aposentadoria > 55 AND @idade_aposentadoria <= 65
	PRINT 'Aposentadoria chegando'
ELSE IF @idade_aposentadoria > 61 AND @idade_aposentadoria <80
	PRINT 'Devia estar aposentado'
ELSE IF	@idade_aposentadoria > 80
	PRINT 'Passou da hora'
ELSE
	PRINT 'Vai trabalhar rapaz'

-- Idade do funcinário exata
SELECT F.Pnome, YEAR(GETDATE()) - (YEAR(F.Datanasc)+1) AS 'Idade'
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Paulo'
