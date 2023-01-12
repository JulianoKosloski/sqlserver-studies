USE MASTER
DROP DATABASE IF EXISTS AB_TREINAMENTO_JULIANOKOSLOSKI
CREATE DATABASE AB_TREINAMENTO_JULIANOKOSLOSKI
GO
USE AB_TREINAMENTO_JULIANOKOSLOSKI
GO

-- 1) Crie uma base dade dados com o nome: AB_TREINAMENTO_NOME
CREATE TABLE PESSOAS (
	CODPESSOA VARCHAR(3) NOT NULL,
	CPFCNPJ VARCHAR(14) NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	DATANASCIMENTO DATETIME NOT NULL,
	TIPOPESSOA CHAR(1) NOT NULL CONSTRAINT VALIDA_TIPOPESSOA CHECK (TIPOPESSOA IN ('F', 'J')),
	NUMEROFILHOS INT NOT NULL CONSTRAINT DEF_NUMEROFILHOS DEFAULT 0,
	INDCLIENTEBANCO CHAR(1) NOT NULL CONSTRAINT VALIDA_INDCLIENTEBANCO CHECK (INDCLIENTEBANCO IN ('S', 'N')),
	TIPOLOGRADOURO VARCHAR(3),
	LOGRADOURO VARCHAR(100),
	BAIRRO VARCHAR(50),
	CIDADE VARCHAR(50),
	UF VARCHAR(2),
	PAIS VARCHAR(50),
	CEP VARCHAR(8),
	OBSERVACAO VARCHAR(100),
	CONSTRAINT PK_PESSOAS PRIMARY KEY (CODPESSOA),
);
GO

CREATE TABLE CONTAS (
	CODCOLIGADA VARCHAR(3) NOT NULL,
	CODAGENCIA VARCHAR(5) NOT NULL,
	NROCONTA VARCHAR(7) NOT NULL,
	CODPESSOA VARCHAR(3) NOT NULL,
	INDPOUPANCA CHAR(1) NOT NULL CONSTRAINT VALIDA_INDPOUPANCA CHECK (INDPOUPANCA IN ('S','N')),
	USUARIOINCLUSAO VARCHAR(100),
	DATAINCLUSAO DATETIME, 
	USUARIOALTERACAO VARCHAR(100),
	CONSTRAINT PK_CONTAS PRIMARY KEY (CODCOLIGADA, CODAGENCIA, NROCONTA),
	CONSTRAINT FK_CONTAS_PESSOAS FOREIGN KEY (CODPESSOA) REFERENCES PESSOAS (CODPESSOA)
);
GO

CREATE TABLE MOVIMENTOS (
	CODCOLIGADA VARCHAR(3) NOT NULL,
	CODAGENCIA VARCHAR(5) NOT NULL,
	NROCONTA VARCHAR(7) NOT NULL,
	NROMOVIMENTO INT NOT NULL IDENTITY(1,1), 
	DATAMOVIMENTO DATETIME NOT NULL,
	VALOR NUMERIC(17,2),
	MORA NUMERIC(17,2),
	MULTA NUMERIC(17,2),
	DESCONTO NUMERIC(17,2),
	DESCRICAO VARCHAR(100),
	CONSTRAINT PK_MOVIMENTOS PRIMARY KEY (CODCOLIGADA,CODAGENCIA,NROCONTA, NROMOVIMENTO),
	CONSTRAINT FK_MOVIMENTOS_CONTAS FOREIGN KEY (CODCOLIGADA,CODAGENCIA,NROCONTA) REFERENCES CONTAS (CODCOLIGADA,CODAGENCIA,NROCONTA),
);
GO

-- 2) Realize 2 inser��es na tabela PESSOAS, sendo que:
-- O nome da pessoa deve iniciar pelo nome do treinando
-- Para uma pessoa, inserir o TIPOPESSOA 'F' e a outra 'J'
-- Para uma pessoa, inserir o INDCLIENTEBANCO 'S' e a outra 'N'

INSERT INTO PESSOAS (CODPESSOA, CPFCNPJ, NOME, DATANASCIMENTO, TIPOPESSOA, NUMEROFILHOS, INDCLIENTEBANCO, TIPOLOGRADOURO, LOGRADOURO, BAIRRO, CIDADE, UF, PAIS, CEP, OBSERVACAO)
VALUES ('001', '12345678922','JULIANO BRAGANCA DA SILVA','19910127','F',DEFAULT,'S','RUA','RUA DOS PARDAIS, 301','RANCHO VERDE','FAZENDINHA DO SUL','PR','BRASIL','77720-77','NENHUMA OBSERVACAO');

INSERT INTO PESSOAS (CODPESSOA, CPFCNPJ, NOME, DATANASCIMENTO, TIPOPESSOA, NUMEROFILHOS, INDCLIENTEBANCO, TIPOLOGRADOURO, LOGRADOURO, BAIRRO, CIDADE, UF, PAIS, CEP, OBSERVACAO)
VALUES ('002', '11223344551234','JULIANO JOS� SILVEIRA','19780227','J','3','N','AV','AVENIDA DOS CANARIOS, 724','BAIXADA','RIACHO FUNDO','SC','BRASIL','66620-66','NENHUMA OBSERVACAO');

----------- inser��es adicionais

INSERT INTO PESSOAS (CODPESSOA, CPFCNPJ, NOME, DATANASCIMENTO, TIPOPESSOA, NUMEROFILHOS, INDCLIENTEBANCO, TIPOLOGRADOURO, LOGRADOURO, BAIRRO, CIDADE, UF, PAIS, CEP, OBSERVACAO)
VALUES ('004', '15315612622','JULIANO AMARILDO FERREIRA','19690827','F',DEFAULT,'S','RUA','RUA DOS GIRASSOIS, 404','MONTE CLARO','ITARAPANEMA','PR','BRASIL','56220-77','NENHUMA OBSERVACAO');

INSERT INTO PESSOAS (CODPESSOA, CPFCNPJ, NOME, DATANASCIMENTO, TIPOPESSOA, NUMEROFILHOS, INDCLIENTEBANCO, TIPOLOGRADOURO, LOGRADOURO, BAIRRO, CIDADE, UF, PAIS, CEP, OBSERVACAO)
VALUES ('005', '11227890558634','JULIANO HAUSSTRAUSER BOCH','19660527','J','9','S','AV','AVENIDA DOS CORAIS, 102','RIO AZUL','TERESOPOLIS DO LESTE','RS','BRASIL','98020-62','OUTRA OBSERVACAO');

-----------

-- 3) Realize uma nova inser��o na tabela pessoas

INSERT INTO PESSOAS (CODPESSOA, CPFCNPJ, NOME, DATANASCIMENTO, TIPOPESSOA, NUMEROFILHOS, INDCLIENTEBANCO, TIPOLOGRADOURO, LOGRADOURO, BAIRRO, CIDADE, UF, PAIS, CEP, OBSERVACAO)
VALUES ('003', '77883344551234','JULIANO MAGREB KOZASKI','19920327','J',DEFAULT,'S','RUA','RUA DOS CISNES, 385','GRANDE VISTA','GUARAQUETUBA','SP','BRASIL','99620-35','OUTRA OBSERVACAO');

-- 4) Altere o TIPOPESSOA, LOGRADOURO E DATANASCIMENTO da pessoa inserida no t�pico 3

UPDATE PESSOAS SET TIPOPESSOA = 'F', LOGRADOURO = 'RUA DOS GANSOS, 385', DATANASCIMENTO = '19950327'
WHERE CODPESSOA = '003';

-- 5) Exclua a pessoa inserida no t�pico 3

DELETE PESSOAS WHERE CODPESSOA = '003';

-- 6) Realize 2 inser��es na tabela CONTAS, sendo que a conta seja para pessoas diferentes

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('001', '003','1234599','001', 'S', 'JOSELDA', GETDATE(), NULL);

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('002', '003','8001204','002', 'N', 'JOSELDA', GETDATE(), NULL);

------ inser��es adiconais

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('001', '003','1756199','001', 'S', 'JOSELDA', GETDATE(), NULL);

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('002', '002','8221204','002', 'N', 'MARILDA', GETDATE(), NULL);

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('002', '004','9014599','004', 'S', 'JOSELDA', GETDATE(), NULL);

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('003', '005','8004560','004', 'N', 'ROBERTO', GETDATE(), NULL);

INSERT INTO CONTAS (CODCOLIGADA, CODAGENCIA, NROCONTA, CODPESSOA, INDPOUPANCA, USUARIOINCLUSAO, DATAINCLUSAO, USUARIOALTERACAO)
VALUES ('003', '006','8444704','005', 'S', 'ROBERTO', GETDATE(), NULL);

------

-- 7) Realize uma consulta que retorne quantas pessoas est�o cadastradas

SELECT COUNT(CODPESSOA) AS QTD_PESSOAS_CADASTRADAS FROM PESSOAS;

-- 8) Realize um select na tabela clientes que exiba o nome do cliente e:
-- Se TIPOPESSOA = 'J', exiba Jur�dica
-- Se TIPOPESSOA = 'F', exiba F�sica

SELECT P.NOME,
		CASE P.TIPOPESSOA
		WHEN 'F' THEN 'F�SICA'
		WHEN 'J' THEN 'JUR�DICA'
		END AS TIPO_DE_PESSOA
FROM PESSOAS P

-- 9) Realize uma consulta que retorne a pessoa que possui a menor DATANASCIMENTO

-- Adicionei o 'TOP 1' para caso houvessem datas de nascimento repetidas mostrar apenas a primeira pessoa encontrada (testei em ambos os casos)
SELECT TOP 1 P.NOME, P.DATANASCIMENTO AS MENOR_DATANASCIMENTO FROM PESSOAS P 
WHERE P.DATANASCIMENTO = (SELECT MIN(DATANASCIMENTO) FROM PESSOAS);

-- 10) Realize uma consulta que retorne as pessoas ordenadas por UF e CIDADE, desde que a UF e a CIDADE sejam diferentes de nulo ou vazio

SELECT P.NOME, P.CIDADE, P.UF FROM PESSOAS P 
WHERE ISNULL(P.CIDADE, '') <> '' 
AND ISNULL(P.UF, '') <> ''
ORDER BY P.UF, P.CIDADE; 

-- 11) Realize uma consulta que retorne apenas o nome e o n�mero da conta dos clientes

SELECT P.NOME, C.NROCONTA FROM PESSOAS P INNER JOIN CONTAS C ON P.CODPESSOA=C.CODPESSOA;

-- 12) Realize uma consulta que traga apenas as contas dos clientes que tem mais de uma conta

SELECT P.NOME, C.NROCONTA FROM PESSOAS P, CONTAS C
WHERE C.CODPESSOA = P.CODPESSOA
AND P.CODPESSOA IN (SELECT C.CODPESSOA FROM CONTAS C
					GROUP BY CODPESSOA HAVING COUNT(CODPESSOA)>1);

-- 13) Realize uma consulta que traga apenas as contas dos clientes que o TIPOPESSOA seja 'F'

SELECT C.NROCONTA, P.TIPOPESSOA FROM CONTAS C, PESSOAS P
WHERE P.TIPOPESSOA = 'F' AND C.CODPESSOA = P.CODPESSOA;
