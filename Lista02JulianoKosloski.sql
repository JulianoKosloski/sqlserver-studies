USE AB_TREINAMENTO_JULIANOKOSLOSKI
GO

-- LISTA 02

-- 1) Crie uma stored procedure que receba por par�metro os dados da tabela MOVIMENTOS, exceto o
-- n�mero e a data de movimento, e inclua o registro desde que:
-- Exista a conta passada por par�metro na tabela CONTAS (ver pela chave prim�ria inteira e n�o apenas pelo n�mero da conta)
-- Ao incluir, para a data do movimento, passar a data corrente.

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME = 'P_INSERE_MOVIMENTO')
BEGIN
	EXEC('CREATE PROCEDURE dbo.[P_INSERE_MOVIMENTO] AS BEGIN RETURN END');
END;
GO

ALTER PROC [dbo].[P_INSERE_MOVIMENTO] (
	@P_CODCOLIGADA VARCHAR(3),
	@P_CODAGENCIA VARCHAR(5),
	@P_NROCONTA VARCHAR(7),
	@P_VALOR NUMERIC(17,2),
	@P_MORA NUMERIC(17,2),
	@P_MULTA NUMERIC(17,2),
	@P_DESCONTO NUMERIC(17,2),
	@P_DESCRICAO VARCHAR(100))
AS 

DECLARE
@VALIDA VARCHAR(3), 
@DATA DATETIME = GETDATE();

BEGIN TRY
	
	SELECT @VALIDA = C.CODCOLIGADA 
		FROM CONTAS C 
		WHERE C.CODCOLIGADA = @P_CODCOLIGADA 
		AND C.CODAGENCIA = @P_CODAGENCIA 
		AND C.NROCONTA = @P_NROCONTA;

	IF @VALIDA IS NOT NULL
	BEGIN
		INSERT INTO MOVIMENTOS (CODCOLIGADA,CODAGENCIA,NROCONTA,DATAMOVIMENTO,VALOR, MORA, MULTA, DESCONTO, DESCRICAO) 
		VALUES(@P_CODCOLIGADA, @P_CODAGENCIA, @P_NROCONTA,@DATA,@P_VALOR, @P_MORA, @P_MULTA, @P_DESCONTO,@P_DESCRICAO)
	END
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH;
GO

-- Execute a procedure de forma que insira o registro.

EXEC P_INSERE_MOVIMENTO '001', '003', '1234599', 177.20, 3.20, 1.45, 9.99, 'Pagamento de boleto';

-- Realize uma consulta que retorne apenas o registro inserido pela procedure.
SELECT * FROM MOVIMENTOS M WHERE M.CODCOLIGADA = '001' AND M.CODAGENCIA = '003' AND M.NROCONTA = '1234599';

-- 2) Realize uma nova inser��o utilizando a stored procedure criada no exerc�cio 14, por�m, para outra conta.

EXEC P_INSERE_MOVIMENTO '002', '003', '8001204', 345.60, 8.20, 3.45, 7.88, 'Pagamento de boleto';
EXEC P_INSERE_MOVIMENTO '002', '003', '8001204', 689.00, 15.20, 20.45, 9.99, 'Pagamento de boleto';
EXEC P_INSERE_MOVIMENTO '001', '003', '1234599', 280.30, 68.30, 1.45, 9.99, 'Pagamento de boleto';
EXEC P_INSERE_MOVIMENTO '001', '003', '1234599', 934.67, 1.11, 6.45, 54.00, 'Pagamento de boleto';
EXEC P_INSERE_MOVIMENTO '002', '002','8221204', 33.80, 6.00, 1.05, 9.99, 'Pagamento de boleto';
EXEC P_INSERE_MOVIMENTO '002', '002','8221204', 203.20, 8.80, 1.45, 27.39, 'Pagamento de boleto';

-- 3) Insira uma check nos campos VALOR, MORA, MULTA e DESCONTO da tabela MOVIMENTOS para n�o permitir valores negativos

ALTER TABLE MOVIMENTOS ADD CONSTRAINT VALIDA_VALOR CHECK (VALOR >= 0);
ALTER TABLE MOVIMENTOS ADD CONSTRAINT VALIDA_MORA CHECK (MORA >= 0); 
ALTER TABLE MOVIMENTOS ADD CONSTRAINT VALIDA_MULTA CHECK (MULTA >= 0); 
ALTER TABLE MOVIMENTOS ADD CONSTRAINT VALIDA_DESCONTO CHECK (DESCONTO >= 0);

-- 4) Realize um consulta que retorne o menor, o maior e a m�dia do campo VALOR da tabela MOVIMENTOS

SELECT MIN(M.VALOR) VALOR_MINIMO, MAX(M.VALOR) VALOR_MAXIMO, AVG(M.VALOR) VALOR_MEDIO FROM MOVIMENTOS M

-- 5) Realize uma consulta que retorne os campos CPFCNPJ, NOME da tabela PESSOA, e o campo
-- DATAMOVIMENTO da tabela MOVIMENTOS, desde que seja o maior valor, que a conta seja do tipo
-- poupan�a (INDPOUPANCA = S) e que a pessoa seja cliente (INDCLIENTEBANCO = 'S')

SELECT P.CPFCNPJ, P.NOME, M.DATAMOVIMENTO, MAX(M.VALOR) VALOR_MAXIMO
FROM PESSOAS P 
	INNER JOIN CONTAS C ON (P.CODPESSOA = C.CODPESSOA)
	INNER JOIN MOVIMENTOS M ON (C.CODCOLIGADA = M.CODCOLIGADA 
								AND C.CODAGENCIA = M.CODAGENCIA
								AND C.NROCONTA = M.NROCONTA)
WHERE C.INDPOUPANCA = 'S' AND P.INDCLIENTEBANCO = 'S'
GROUP BY P.CPFCNPJ, P.NOME, M.DATAMOVIMENTO;