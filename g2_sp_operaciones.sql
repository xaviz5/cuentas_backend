USE cobis 
GO

IF OBJECT_ID ('dbo.g2_sp_operaciones') IS NOT NULL
	DROP PROCEDURE dbo.g2_sp_operaciones
GO

CREATE PROCEDURE g2_sp_operaciones
   
   	@s_srv           		 varchar(30) = NULL,
   	@s_ssn           		 int         = NULL,
   	@s_ssn_branch    		 int         = 0,
   	@s_date          		 datetime    = NULL,
   	@s_ofi           		 smallint    = NULL,
   	@s_user          		 varchar(30) = NULL,
   	@s_lsrv          		 varchar(30) = NULL,
   	@s_rol           		 smallint    = 1,
   	@s_term          		 varchar(10) = NULL,
   	@s_org           		 char(1)     = NULL,
   	@s_culture       		 varchar(10) = 'NEUTRAL',
   	@t_file          		 varchar(14) = NULL,
   	@i_operacion     		 char(1),
   	@t_trn           		 INT 	     =99,
   	@i_nro_cuenta	 		 VARCHAR(10),
   	@i_nro_cuenta_destino	 VARCHAR(10) =NULL,
   	@i_cantidad		 		 DECIMAL(12,2)=NULL,
   	@i_tipo_cuenta 	 		 CHAR(1)	 =NULL,
   	@i_tipo_cuenta_destino	 CHAR(1)	 =NULL
   
AS

	DECLARE @w_result_cuenta INT=0,
			@w_error INT=0,
			@cod_cliente INT=0,
			@saldo_anterior DECIMAL(12,2),
			@saldo_destino  DECIMAL(12,2)
			
	--Recuperar Informacion de la Cuenta
	IF @i_operacion = 'S'
	
	BEGIN
	
		IF (SELECT COUNT(*) from g2_cuenta_ahorros WHERE ca_banco = @i_nro_cuenta)<>0
		
		BEGIN
		
			SET	@cod_cliente = (SELECT [ca_cliente] FROM g2_cuenta_ahorros WHERE ca_banco = @i_nro_cuenta)
			
			SELECT ca_banco,
			       ca_saldo,
			       cl_cedula,
			       cl_nombre,
			       cl_apellido,
			       'A' AS tipo_cuenta
			       
		 	FROM g2_cuenta_ahorros INNER JOIN cliente_taller ON cl_id=@cod_cliente
		 	
		END

		ELSE IF (SELECT COUNT(*) from g2_cuenta_corriente WHERE cc_banco = @i_nro_cuenta)<>0
		
		BEGIN
		 	
		 	SET	@cod_cliente = (SELECT [cc_cliente] FROM g2_cuenta_corriente WHERE cc_banco = @i_nro_cuenta)
		 	
			SELECT cc_banco,
			       cc_saldo,
			       cl_cedula,
			       cl_nombre,
			       cl_apellido,
			       'C' AS tipo_cuenta
			       
		 	FROM g2_cuenta_corriente INNER JOIN cliente_taller ON cl_id=@cod_cliente	 	
		 		
			
			
		END
		
		ELSE
		
		BEGIN
		
			SELECT @w_error=0712
		
			exec cobis..sp_cerror
         
         	@t_debug = 'n',
         	@t_file  = null,
         	@t_from  = 'g2_sp_operaciones',
         	@i_num   = @w_error
         
         	return @w_error
         
         END
	
	END
	
	IF	@i_operacion = 'C'
	
	BEGIN 
	
		IF @i_tipo_cuenta = 'A'
		
		BEGIN
		
			PRINT 'Entro a ahorros'
		
			SET @saldo_anterior = (SELECT [ca_saldo] FROM g2_cuenta_ahorros WHERE ca_banco=@i_nro_cuenta)
			PRINT @saldo_anterior
		
			UPDATE g2_cuenta_ahorros 
			SET ca_fecha_modificacion=getdate(),
				ca_saldo			 =(@saldo_anterior+@i_cantidad)
				
			WHERE ca_banco = @i_nro_cuenta
		
		END
		
		ELSE IF @i_tipo_cuenta='C'
		
		BEGIN
			
			PRINT 'Entro a corriente'
			
			SET @saldo_anterior = (SELECT [cc_saldo] FROM g2_cuenta_corriente WHERE cc_banco=@i_nro_cuenta)
		
			UPDATE g2_cuenta_corriente
			SET cc_fecha_modificacion=getdate(),
				cc_saldo			 =(@saldo_anterior+@i_cantidad)
				
			WHERE cc_banco = @i_nro_cuenta

		END
	
	END
	
	
	IF @i_operacion = 'R'
	
	BEGIN
	
		IF @i_tipo_cuenta ='A'
		
		BEGIN
		
			SET @saldo_anterior = (SELECT [ca_saldo] FROM g2_cuenta_ahorros WHERE ca_banco=@i_nro_cuenta)
		
			UPDATE g2_cuenta_ahorros 
			SET ca_fecha_modificacion=getdate(),
				ca_saldo			 =(@saldo_anterior-@i_cantidad)
				
			WHERE ca_banco = @i_nro_cuenta		
		
		END
		
		ELSE IF @i_tipo_cuenta='C'
		
		BEGIN
		
			SET @saldo_anterior = (SELECT [cc_saldo] FROM g2_cuenta_corriente WHERE cc_banco=@i_nro_cuenta)
		
			UPDATE g2_cuenta_corriente 
			SET cc_fecha_modificacion=getdate(),
				cc_saldo			 =(@saldo_anterior-@i_cantidad)
				
			WHERE cc_banco = @i_nro_cuenta			 
		
		END
	
	END
	
	IF	@i_operacion = 'T'
	
	BEGIN
	
		IF @i_tipo_cuenta = 'A'
		
		BEGIN
		
			SET @saldo_anterior = (SELECT [ca_saldo] FROM g2_cuenta_ahorros WHERE ca_banco=@i_nro_cuenta)
			
			IF @i_tipo_cuenta_destino = 'A'
			
			BEGIN
			
				SET @saldo_destino = (SELECT [ca_saldo] FROM g2_cuenta_ahorros WHERE ca_banco=@i_nro_cuenta_destino)
				
				UPDATE g2_cuenta_ahorros SET
				ca_fecha_modificacion = getdate(),
				ca_saldo			  = (@saldo_destino+@i_cantidad)
				WHERE ca_banco=@i_nro_cuenta_destino
			
			END
			
			ELSE IF @i_tipo_cuenta_destino = 'C'
			
			BEGIN
			
				SET @saldo_destino = (SELECT [cc_saldo] FROM g2_cuenta_corriente WHERE cc_banco=@i_nro_cuenta_destino)
				
				UPDATE g2_cuenta_corriente SET
				cc_fecha_modificacion = getdate(),
				cc_saldo			  = (@saldo_destino+@i_cantidad)
				WHERE cc_banco=@i_nro_cuenta_destino
				
			
			END
			
			--Actualizacion de Cuenta origen
			UPDATE g2_cuenta_ahorros SET
				ca_fecha_modificacion = getdate(),
				ca_saldo			  = (@saldo_anterior-@i_cantidad)
				WHERE ca_banco=@i_nro_cuenta
		
		END
		
		
		
		ELSE IF	@i_tipo_cuenta = 'C'
		
		BEGIN
		
			SET @saldo_anterior = (SELECT [cc_saldo] FROM g2_cuenta_corriente WHERE cc_banco=@i_nro_cuenta)
			
			IF @i_tipo_cuenta_destino = 'A'
			
			BEGIN
			
				SET @saldo_destino = (SELECT [ca_saldo] FROM g2_cuenta_ahorros WHERE ca_banco=@i_nro_cuenta_destino)
				
				UPDATE g2_cuenta_ahorros SET
				ca_fecha_modificacion = getdate(),
				ca_saldo			  = (@saldo_destino+@i_cantidad)
				WHERE ca_banco=@i_nro_cuenta_destino
			
			END
			
			ELSE IF @i_tipo_cuenta_destino = 'C'
			
			BEGIN
			
				SET @saldo_destino = (SELECT [cc_saldo] FROM g2_cuenta_corriente WHERE cc_banco=@i_nro_cuenta_destino)
				
				UPDATE g2_cuenta_corriente SET
				cc_fecha_modificacion = getdate(),
				cc_saldo			  = (@saldo_destino+@i_cantidad)
				WHERE cc_banco=@i_nro_cuenta_destino
				
			
			END
			
			--Actualizacion de Cuenta origen
			UPDATE g2_cuenta_corriente SET
				cc_fecha_modificacion = getdate(),
				cc_saldo			  = (@saldo_anterior-@i_cantidad)
				WHERE cc_banco=@i_nro_cuenta
		
		END		
	
	END
	
	RETURN 0
	
