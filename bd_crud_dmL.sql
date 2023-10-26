/*-------------------------------------------------------------------------------------------------------------- 
    Desarrollado por Cristhian García CR - 26/10/2023 
    Versión: 3.0 
    Requerido: Privilegios para crear BD, tabla e inserción/actualización/borrar  
--------------------------------------------------------------------------------------------------------------*/ 
USE bd_crud
GO 
PRINT '... Iniciando la creación de Schemas ...' 
GO
---------------------------------------------------------------------------------------------------------------
------------------------------------------- Procedimientos almacenados ----------------------------------------
---------------------------------------------------------------------------------------------------------------
GO
--IF ( EXISTS ( SELECT * FROM sys.schemas WHERE name = 'sch_sp'))
IF (SCHEMA_ID('sch_sp') IS NOT NULL)
BEGIN
    -- El esquema 'sch_sp' ya existe, por lo que lo eliminamos
    DROP SCHEMA sch_sp;
END
GO	
CREATE SCHEMA sch_sp
GO
/*********************************************************************************************************** */
IF OBJECT_ID('sch_sp.InsertarRol', 'P') IS NOT NULL
BEGIN
    -- El procedimiento 'sch_sp.InsertarRol' ya existe, por lo que lo eliminamos
    DROP PROCEDURE sch_sp.InsertarRol;
END
GO
CREATE PROCEDURE sch_Rrh.InsertarRol
(
	@nombre nvarchar(30),
	@descripcion nvarchar(500)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION; -- Inicia la transacción

		-- Validar los datos, longitud del nombre y descripción
		IF (LEN(@nombre) <= 30 AND LEN(@descripcion) <= 500)
		BEGIN
			-- Realizar la inserción en la tabla
			INSERT INTO sch_Rrh.tbRoles (nom, det) VALUES (@nombre, @descripcion);

			COMMIT; -- Confirmar la transacción
		END
		ELSE
		BEGIN
			-- Los datos no cumplen con las validaciones
			ROLLBACK; -- Deshacer la transacción
		END
	END TRY
	BEGIN CATCH
		-- Ocurrió un error, deshacer la transacción
		ROLLBACK;
	END CATCH
END
GO
EXEC sch_Rrh.InsertarRol 'admin', 'Super usuario';



/*
CREATE FUNCTION dbo.fn_ValidarNombre(@nombre nvarchar(30))
RETURNS bit
AS
BEGIN
    DECLARE @expresionRegular nvarchar(50) = N'^[A-Za-z ]+$'; -- Esta expresión regular permite letras y espacios

    IF @nombre IS NULL
        RETURN 1; -- Si el nombre es nulo, es válido

    IF @nombre LIKE @expresionRegular
        RETURN 1; -- Coincide con la expresión regular

    RETURN 0; -- No coincide con la expresión regular
END


ALTER TABLE sch_Rrh.tbRoles
ADD CONSTRAINT CK_NombreValido CHECK (dbo.fn_ValidarNombre(nom) = 1);

*/