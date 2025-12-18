USE Empresa;

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial, Datanasc, Dnr)
VALUES ('123144325', 'Juca', 'Figueiredo', 'R', '1999-09-29', 5);

-- Exemplo do primeiro Trigger
GO
CREATE OR ALTER TRIGGER trg_InserirFuncionario
ON FUNCIONARIO
INSTEAD OF INSERT 
AS
BEGIN
    DECLARE @nome VARCHAR(100);
    SELECT @nome = Pnome FROM inserted;
    PRINT 'NÃO INSERI NENHUM: ' + @nome;
END
GO

-- Desabilitar o trigger criado
ALTER TABLE FUNCIONARIO
DISABLE TRIGGER trg_InserirFuncionario;

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial)
VALUES ('8486533489', 'Matheus', 'Pichler', 'M');

-- Fazendo update no Pnome
GO
CREATE OR ALTER TRIGGER trigger_afterUpdatePnome
ON FUNCIONARIO
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Pnome)
    BEGIN
        DECLARE @nomeNovo VARCHAR(100);
        DECLARE @nomeAntigo VARCHAR(100);
        SELECT @nomeNovo = PNOME FROM inserted;
        SELECT @nomeAntigo = PNOME FROM deleted;

        PRINT 'Era: ' + @nomeAntigo;
        PRINT 'Alterado para: ' + @nomeNovo;
    END
    ELSE
    BEGIN
        PRINT 'Nome não foi modificado';
    END
END
GO

SELECT * FROM FUNCIONARIO ORDER BY Pnome;

UPDATE FUNCIONARIO
SET Pnome = 'Juliano'
WHERE Cpf = '123144325';

-- Criar um trigger que não deixe inserir um funcionario que tenha o nome completo de um funcionário já existente
GO
CREATE OR ALTER TRIGGER trg_NomesDuplicados
ON FUNCIONARIO
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN FUNCIONARIO f ON i.Pnome = f.Pnome 
                                 AND i.Unome = f.Unome 
                                 AND i.Minicial = f.Minicial
        WHERE i.Cpf != f.Cpf  -- Permite update do mesmo funcionário
    )
    BEGIN
        PRINT 'Já existe um funcionário com esse nome no BD';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT 'Nome completo inserido com sucesso';
    END
END
GO

-- Tabela de log
CREATE TABLE Log_Funcionario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cpf CHAR(11),
    operacao VARCHAR(10),
    dataHora DATETIME DEFAULT GETDATE(),
    detalhes VARCHAR(100)
);

-- Trigger
GO
CREATE OR ALTER TRIGGER trg_logFuncionario
ON FUNCIONARIO
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- INSERT
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Log_Funcionario(cpf, operacao, detalhes)
        SELECT Cpf, 'INSERT', Pnome + ' foi cadastrado'
        FROM inserted;
    END
    
    -- UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Log_Funcionario(cpf, operacao, detalhes)
        SELECT i.Cpf, 'UPDATE', 'Dados alterados'
        FROM inserted i;
    END
    
    -- DELETE
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Log_Funcionario(cpf, operacao, detalhes)
        SELECT Cpf, 'DELETE', Pnome + ' foi removido'
        FROM deleted;
    END
END
GO

-- Simulação:
-- INSERT
INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial, Datanasc, Dnr)
VALUES ('11122233344', 'Gabriel', 'Santos', 'G', '1995-03-15', 3);

-- UPDATE
UPDATE FUNCIONARIO 
SET Pnome = 'Gabriel', Dnr = 4
WHERE Cpf = '11122233344';

-- DELETE
DELETE FROM FUNCIONARIO 
WHERE Cpf = '11122233344';

SELECT * FROM Log_Funcionario;