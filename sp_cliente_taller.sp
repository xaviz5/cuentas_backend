USE cobis
GO
IF OBJECT_ID ('dbo.sp_cliente_taller') IS NOT NULL
	DROP PROCEDURE dbo.sp_cliente_taller
GO

CREATE PROCEDURE sp_cliente_taller
   @s_srv           varchar(30) = NULL,
   @s_ssn           int         = NULL,
   @s_ssn_branch    int         = 0,
   @s_date          datetime    = NULL,
   @s_ofi           smallint    = NULL,
   @s_user          varchar(30) = NULL,
   @s_lsrv          varchar(30) = NULL,
   @s_rol           smallint    = 1,
   @s_term          varchar(10) = NULL,
   @s_org           char(1)     = NULL,
   @s_culture       varchar(10) = 'NEUTRAL',
   @t_file          varchar(14) = NULL,
   @i_operacion     char(1),
   @t_trn            INT =99,
   @i_nombre		VARCHAR(30) = NULL,
   @i_apellido		VARCHAR(30) = NULL,     
   @i_telefono		VARCHAR(30) = NULL,
   @i_cedula		VARCHAR(30) = NULL,
   @i_nacionalidad	VARCHAR(30) = NULL,
   @i_id			INT			= NULL
   
  
AS
    declare @w_sp_name       varchar(14)
            
   select @w_sp_name = 'sp_cliente_taller'
   
    
    if @i_operacion='C'
    begin
       SELECT 	cl_id,
	   			cl_nombre,
	   			cl_apellido,
	   			cl_telefono,
	   			cl_cedula,
	   			pa_nacionalidad 
	   
	   			FROM cliente_taller 
	   			INNER JOIN cl_pais 
	   			ON cliente_taller.cl_nacionalidad = cl_pais.pa_pais

       
    END
    
    IF @i_operacion='I'
    BEGIN
    	INSERT INTO cliente_taller 
    		(cl_nombre, 	cl_apellido, cl_telefono, cl_cedula,cl_nacionalidad)
    	VALUES 
    		(@i_nombre,		@i_apellido, @i_telefono, @i_cedula,@i_nacionalidad)
    END
       
    IF @i_operacion='U'
    BEGIN
    
    	UPDATE cliente_taller
		SET 
			cl_nombre = @i_nombre,
			cl_apellido = @i_apellido,
			cl_telefono = @i_telefono,
			cl_cedula = @i_cedula,
			cl_nacionalidad = @i_nacionalidad
			
		WHERE
			cl_id= @i_id

    END
    
    if @i_operacion='S'
    begin
       SELECT 	cl_id,
	   			cl_nombre,
	   			cl_apellido,
	   			cl_cedula
	   
	   			FROM cliente_taller 
	   			WHERE cl_cedula = @i_cedula
	   			
    END
    
   return 0
   




GO


