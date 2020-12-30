USE cobis
go
IF OBJECT_ID ('dbo.g2_sp_cuenta_corriente') IS NOT NULL
	DROP PROCEDURE dbo.g2_sp_cuenta_corriente
GO

CREATE PROCEDURE g2_sp_cuenta_corriente
   @s_srv                        varchar(30)           = NULL,
   @s_ssn                        int                   = NULL,
   @s_ssn_branch                 int                   = 0,
   @s_date                       datetime              = NULL,
   @s_ofi                        smallint              = NULL,
   @s_user                       varchar(30)           = NULL,
   @s_lsrv                       varchar(30)           = NULL,
   @s_rol                        smallint              = 1,
   @s_term                       varchar(10)           = NULL,
   @s_org                        char(1)               = NULL,
   @s_culture                    varchar(10)           = 'NEUTRAL',
   @t_file                       varchar(14)           = NULL,
   @i_operacion					 char(1),
   @t_trn            			 INT				   = 99,
   @i_cc_cliente				 INT				   = NULL,
   @i_cc_saldo					 DECIMAL(12,2)		   = NULL
AS
   declare  @w_sp_name       varchar(14),
			@w_cc_banco		 varchar(10),
			@w_numero		 float,
			@NumeroDesde	 float = 1000000000,
			@NumeroHasta	 float = 9999999999
            
   select @w_sp_name = 'g2_sp_cuenta_corriente'

   

   IF @i_operacion='I'
   BEGIN
   		SELECT @w_numero = ROUND(((@NumeroHasta - @NumeroDesde) * RAND() + @NumeroDesde), 0)

	    WHILE EXISTS (SELECT * FROM g2_cuenta_corriente WHERE cc_banco = @w_numero)
	    Begin
			SELECT @w_numero = ROUND(((@NumeroHasta - @NumeroDesde) * RAND() + @NumeroDesde), 0)
	    END
	
	    SELECT @w_cc_banco = CAST(CAST(@w_numero AS BIGINT) AS VARCHAR(10))
   		
    	INSERT INTO g2_cuenta_corriente 
    		(cc_banco, 		cc_fecha_creacion,		cc_fecha_modificacion,  cc_cliente,		cc_saldo)
    	VALUES 
    		(@w_cc_banco,	GETDATE(),				GETDATE(),				@i_cc_cliente,	@i_cc_saldo)
   END
    
   return 0


GO