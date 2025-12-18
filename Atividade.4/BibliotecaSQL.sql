-- Exercicio 1:
CREATE OR ALTER TRIGGER trg_duplicados
ON Livro
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Livro WHERE titulo IN (SELECT titulo FROM inserted))
    BEGIN
        RAISERROR('Já existe um livro com este título!', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        INSERT INTO Livro (isbn, titulo, ano, fk_editora, fk_categoria)
        SELECT isbn, titulo, ano, fk_editora, fk_categoria
        FROM inserted
    END
END
GO

-- Exercicio 2:
CREATE OR ALTER TRIGGER trg_AtualizaAno
ON Livro
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Livro (isbn, titulo, ano, fk_editora, fk_categoria)
    SELECT isbn, titulo, YEAR(GETDATE()), fk_editora, fk_categoria
    FROM inserted
END
GO

-- Exercicio 3: 
CREATE OR ALTER TRIGGER trg_ExcluirAutor
ON Livro
AFTER DELETE
AS
BEGIN
    DELETE FROM LivroAutor 
    WHERE fk_livro IN (SELECT isbn FROM deleted)
END
GO

-- Exercicio 5:
CREATE OR ALTER TRIGGER trg_ImpedirExclusao
ON Categoria
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Livro WHERE fk_categoria IN (SELECT id FROM deleted))
    BEGIN
        RAISERROR('Não é possível excluir categorias que possuem dependências.', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE FROM Categoria WHERE id IN (SELECT id FROM deleted)
    END
END
GO

-- Exercicio 8:
CREATE OR ALTER TRIGGER trg_ImpedirAlteracao
ON Livro
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(isbn)
    BEGIN
        RAISERROR('Não é permitido alterar o ISBN do livro!', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        UPDATE Livro 
        SET titulo = i.titulo, 
            ano = i.ano, 
            fk_editora = i.fk_editora, 
            fk_categoria = i.fk_categoria
        FROM Livro l
        INNER JOIN inserted i ON l.isbn = i.isbn
    END
END
GO

-- Tabela de log:
CREATE TABLE LogExclusaoLivros (
    id INT IDENTITY PRIMARY KEY,
    isbn_livro VARCHAR(50),
    titulo_livro VARCHAR(100),
    data_exclusao DATETIME DEFAULT GETDATE(),
    usuario VARCHAR(100) DEFAULT SYSTEM_USER
)
GO

-- Exercicio 14:
CREATE OR ALTER TRIGGER trg_RegistraExclusao
ON Livro
AFTER DELETE
AS
BEGIN
    INSERT INTO LogExclusaoLivros (isbn_livro, titulo_livro)
    SELECT isbn, titulo FROM deleted
END
GO