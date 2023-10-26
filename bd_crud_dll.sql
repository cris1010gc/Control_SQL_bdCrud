/*-------------------------------------------------------------------------------------------------------------- 
    Desarrollado por Cristhian Garc�a CR - 26/10/2023 
    Versi�n: 3.0 
    Requerido: Privilegios para crear BD, tabla e inserci�n/actualizaci�n/borrar  
--------------------------------------------------------------------------------------------------------------*/ 
USE master
GO
PRINT '... Iniciando el proceso de creaci�n de la BD ...'
GO
--ALTER DATABASE bd_crud SET SINGLE_USER WITH ROLLBACK IMMEDIATE -- base de datos definida por el usuario en modo de usuario �nico
-- Valido si la BD existe
IF ( EXISTS ( SELECT * FROM SYSDATABASES WHERE name = 'bd_crud'))
	BEGIN TRY  
		PRINT ' - Eliminando BD previa -  '
		DROP DATABASE bd_crud -- Si existe la elimino
	END TRY  
	BEGIN CATCH  
		-- Detalles del error --code to run if error occurs
		PRINT ' - La BD no se pudo eliminar, detalles...'
		PRINT '		Error Number    : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_NUMBER()), ' - ')
		PRINT '		Error State     : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_STATE()), ' - ')
		PRINT '		Error Severity  : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_SEVERITY()), ' - ')
		print '		Error Procedure : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_PROCEDURE()), ' - ')
		PRINT '		Error Line      : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_LINE()), ' - ')
		PRINT '		Error Message   : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_MESSAGE()), ' - ')
		/*SELECT
			ERROR_NUMBER() AS ErrorNumber,		-� Devuelve el n�mero interno del error
			ERROR_STATE() AS ErrorState,		-� Devuelve la informaci�n sobre la fuente
			ERROR_SEVERITY() AS ErrorSeverity,  -- Devuelve la informaci�n sobre cualquier cosa, desde errores informativos hasta errores que el usuario de DBA puede corregir, etc.
			ERROR_PROCEDURE() AS ErrorProcedure,-� Devuelve el nombre del procedimiento almacenado o la funci�n
			ERROR_LINE() AS ErrorLine,			-- Devuelve el n�mero de l�nea en el que ocurri� un error
			ERROR_MESSAGE() AS ErrorMessage*/   -- Devuelve la informaci�n m�s esencial y ese es el mensaje de texto del error
		PRINT '	 ** Posible soluci�n: Si no ha modificado el script, habilite el ALTER de la l�nea 5'
		--PRINT '		Error Message   : ' + ISNULL(CONVERT(NVARCHAR(MAX), ERROR_MESSAGE()), ' - ')
	END CATCH
GO
PRINT '... Creando base de datos ...'
CREATE DATABASE bd_crud -- Crea la BD
GO
USE bd_crud
GO 
PRINT '... Iniciando la creaci�n de Schemas ...' 
GO
---------------------------------------------------------------------------------------------------------------
---------------------------------------- Creando Schemas ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
CREATE SCHEMA sch_Gen -- SELECT * FROM sys.schemas --where name = 'bd_SisVent'
GO
CREATE SCHEMA sch_Rrh
GO
CREATE SCHEMA sch_Sac
GO
-- SELECT * FROM bd_SisVent.sys.schemas --WHERE principal_id = 1
PRINT '... Iniciando la creaci�n de las tablas ... Espere por favor ... ' 
---------------------------------------------------------------------------------------------------------------
----------------------------------------- Creando Tablas ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
/*********************************************************************************************************** */
IF OBJECT_ID('sch_Rrh.tbRoles', 'U') IS NOT NULL
BEGIN
    -- La tabla 'sch_Rrh.tbRoles' ya existe, por lo que la eliminamos
    DROP TABLE sch_Rrh.tbRoles;
END
CREATE TABLE sch_Rrh.tbRoles
(
	idRol	int IDENTITY (1, 1) NOT NULL,   -- Identificador autoincremental
	--COLLATE Latin1_General_BIN -> para que la comparaci�n sea sensible a may�sculas y min�sculas
	nom		nvarchar(30) COLLATE Latin1_General_BIN UNIQUE NOT NULL ,	-- Nombre
	det		nvarchar(500),					-- Descripci�n
	fecReg	datetime DEFAULT GETDATE(),		-- Fecha de inserci�n

	CONSTRAINT pk_tbRoles PRIMARY KEY (idRol),
	CONSTRAINT CK_NombreValido CHECK (nom NOT LIKE '%[^A-Za-z ]%')
)
GO
--ALTER TABLE tbClientes ADD CONSTRAINT pk_Cli PRIMARY KEY (idCli) 
-- SELECT * FROM sys.key_constraints ->  PARA VER LOS CONSTRAIN
/*********************************************************************************************************** */
/*IF OBJECT_ID('sch_Gen.tbDir_Provincia') IS NOT NULL
	DROP TABLE sch_Gen.tbDir_Provincia
GO
CREATE TABLE sch_Gen.tbDir_Provincia
(
	idDir_Pro	int IDENTITY (1, 1)				  NOT NULL,	-- Identificador autoincremental
	nomDir_Pro	nvarchar(100) UNIQUE			  NOT NULL,	-- Nombre
	idIso		nvarchar(10)  UNIQUE			  NOT NULL,	-- Codigo ISO
	totHab		int			  CHECK (totHab >= 0) NOT NULL ,-- Total de Habitantes
	extKm2		float		  CHECK (extKm2 >= 0) NOT NULL,	-- Extensi�n en Km2
	fecReg		datetime	  DEFAULT GETDATE()   NOT NULL, -- Fecha de inserci�n

	CONSTRAINT pk_TbDir_Pro PRIMARY KEY (idDir_Pro) 
)
GO
-- Agregamos descripci�n a la tabla
EXEC sp_addextendedproperty 
    @name = N'MS_Description_tbDir_Provincia',	@value = 'Detalla las provincias del pa�s', 
    @level0type = N'Schema',/**/	@level0name = 'sch_Gen', 
    @level1type = N'Table',		@level1name = 'tbDir_Provincia'	*/
-- SELECT *  FROM sys.tables -- PARA SABER EL object_id -- tomarlo porque se ocupa en la siguiente tabla
-- SELECT * FROM sys.extended_properties WHERE major_id = 309576141 -- PARA VER LOS COMENTARIOS/DESCRIPCION DE LA TABLA
-- major_id = object_id
GO
/* -- Ejemplo Eliminar en cascada
BEGIN TRAN

SELECT * FROM [bd_SisVent].[sch_Gen].[tbDir_Provincia] WHERE idDir_Pro = 2

SELECT * FROM [bd_SisVent].[sch_Gen].[tbDir_Canton] WHERE idDir_Pro = 2 AND idDir_Can = 36

SELECT * FROM [bd_SisVent].[sch_Gen].[tbDir_Distrito] WHERE idDir_Can = 36

DELETE [bd_SisVent].[sch_Gen].[tbDir_Provincia] WHERE idDir_Pro = 2

SELECT * FROM [bd_SisVent].[sch_Gen].[tbDir_Provincia] WHERE idDir_Pro = 2

--ROLLBACK TRAN
*/