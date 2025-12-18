use empresa

-- Classificar funcionarios por faixa salarial
-- Até 20k - Baixo
-- Entre 20 - 40K - Médio
-- Acima de 40K - Alto
SELECT 
	Pnome, Unome, Salario,
	CASE
		WHEN Salario < 20000 THEN 'Baixo'
		WHEN Salario BETWEEN 20000 AND 40000 THEN 'Médio'
		WHEN Salario > 40000 THEN 'Alto'
		ELSE 'Sem Registro'
	END AS 'Categoria'
from FUNCIONARIO

-- Verifica se o funcionario foi contratado nos ultimos 1000 dias

SELECT 
    PNOME,
    UNOME,
    DATA_ADMISSAO,
    CAST(GETDATE() AS DATE) AS 'Hoje',
    CASE
        WHEN DATEDIFF(DAY, DATA_ADMISSAO, GETDATE()) <= 10000
            THEN 'Funcionario contratado recentemente'
        ELSE 'Funcionario com mais de 6 meses'
    END AS 'ADMISSAO'
FROM FUNCIONARIO AS F

-- UPDATE no salário do Carlos

UPDATE FUNCIONARIO
SET Salario = 50000
WHERE PNOME = 'Carlos'
    
SELECT * FROM
FUNCIONARIO AS F
    


-- EX: AUMENTO PARA O DEPARTAMENTO DE PESQUISA