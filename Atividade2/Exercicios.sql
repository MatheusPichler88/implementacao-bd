-- 1) Autocommit × Transação Explícita 
-- Inserção 1:
INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Qualidade', 60);

BEGIN TRANSACTION;
    -- Inserção 2:
    INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Logística', 61);
ROLLBACK; 

-- Verificação

SELECT * FROM DEPARTAMENTO WHERE Dnumero IN (60, 61);

-- 2) SAVEPOINT e ROLLBACK 

BEGIN TRANSACTION;
    -- Inserindo Departamento Jurídico
    INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Jurídico', 62);
    -- Criando save
    SAVE TRANSACTION ponto_salvo;
    -- Inserindo o departamento compras
    INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Compras', 63);
    -- Rollback
    ROLLBACK TRANSACTION ponto_salvo;
COMMIT;
PRINT 'COMMIT realizado com sucesso - Jurídico permanece, Compras foi descartado';

-- Verificação
SELECT * FROM DEPARTAMENTO WHERE Dnumero IN (62, 63);

-- 3) UPDATE com Conferência e 

-- Estado antes da transação
SELECT Cpf, Pnome, Unome, Endereco FROM FUNCIONARIO WHERE Cpf = '12345678966';

BEGIN TRANSACTION;
    UPDATE FUNCIONARIO 
    SET Endereco = 'Av. João Batista da Cruz Jobim, 3, Santa Maria, RS' 
    WHERE Cpf = '12345678966';

    -- Verificando
    SELECT Cpf, Pnome, Unome, Endereco FROM FUNCIONARIO WHERE Cpf = '12345678966';
    
    PRINT 'COMMIT - Transação realizada com sucesso';
    COMMIT;

-- Estado final
SELECT Cpf, Pnome, Unome, Endereco FROM FUNCIONARIO WHERE Cpf = '12345678966';

