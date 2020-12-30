USE cobis 
GO

IF OBJECT_ID ('dbo.g2_sp_cuenta_ahorros') IS NOT NULL
	DROP PROCEDURE dbo.g2_sp_cuenta_ahorros
GO

CREATE PROCEDURE g2_sp_cuenta_ahorros
	@s_srv           		varchar(30) 	= NULL,
   	@s_ssn           		int         	= NULL,
   	@s_ssn_branch    		int         	= 0,
   	@s_date          		datetime    	= NULL,
   	@s_ofi           		smallint    	= NULL,
   	@s_user          		varchar(30) 	= NULL,
   	@s_lsrv          		varchar(30) 	= NULL,
   	@s_rol           		smallint    	= 1,
   	@s_term          		varchar(10) 	= NULL,
   	@s_org           		char(1)     	= NULL,
   	@s_culture       		varchar(10) 	= 'NEUTRAL',
   	@t_file          		varchar(14) 	= NULL,
   	@i_operacion     		char(1),
   	@t_trn            		INT 			= 99,
   	@i_ca_banco				VARCHAR(10)		= NULL,
   	@i_fecha_creacion		NVARCHAR(10)	= NULL,
   	@i_fecha_modificacion	NVARCHAR(10)	= NULL,
   	@i_cliente				INT				= NULL,
   	@i_saldo				DECIMAL(12,2)	= 0
AS

declare @w_numeroDesde FLOAT = 1000000000 ;
declare @w_numeroHasta FLOAT = 9999999999 ;
DECLARE @w_identificador VARCHAR(10)
DECLARE @w_valor FLOAT

IF @i_operacion='I'
BEGIN
	SELECT @w_valor = (@w_numeroHasta - @w_numeroDesde) * RAND() + @w_numeroDesde
	
	WHILE EXISTS (SELECT ca_banco FROM g2_cuenta_ahorros WHERE ca_banco = @w_valor)
	BEGIN
		SELECT @w_valor = ROUND(((9999999999 - 1000000000) * RAND() + 1000000000), 0)
	END
	
	SELECT @w_identificador = CAST(CAST(@w_valor AS BIGINT) AS VARCHAR(10))

	INSERT INTO g2_cuenta_ahorros
		(ca_banco,			ca_fecha_creacion,	ca_fecha_modificacion,	ca_cliente,ca_saldo)
	VALUES 
		(@w_identificador,	getdate(),			getdate(),				@i_cliente,@i_saldo)
	
END

RETURN 0
GO

