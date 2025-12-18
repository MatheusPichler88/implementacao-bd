--TRY CATCH E TRANSAÇÃO
-- mudança de departamento de um funcionario

SELECT * FROM FUNCIONARIO;

BEGIN TRY
	BEGIN TRAN;
	
	UPDATE FUNCIONARIO
	SET Dnr = 1
	WHERE cpf = '98765432168';

	COMMIT TRAN;
	PRINT 'Alteração de departamento realizada';
END TRY
BEGIN CATCH
	-- XACT_STATE() retorna o estado da transação
	-- 1 transacao aberta
	-- 0 nao existe transação em aberto
	-- -1 transação em estado de erro
	
	IF XACT_STATE() <> 0
		ROLLBACK TRAN;
		
	PRINT 'NUMERO: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'MENSAGEM: ' + ERROR_MESSAGE();
END CATCH