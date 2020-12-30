IF OBJECT_ID ('dbo.g2_cuenta_corriente') IS NOT NULL
	DROP TABLE dbo.g2_cuenta_corriente
GO

CREATE TABLE dbo.g2_cuenta_corriente
	(
	cc_banco              VARCHAR (10) NOT NULL,
	cc_fecha_creacion     NVARCHAR (11) NOT NULL,
	cc_fecha_modificacion NVARCHAR (11) NOT NULL,
	cc_cliente            INT NOT NULL,
	cc_saldo              DECIMAL (12,2) NOT NULL,
	CONSTRAINT PK__g2_cuent__927F35098E139758 PRIMARY KEY (cc_banco)
	)
GO