/*-------------------------------------------------------------------------------------------------------------- 
    Desarrollado por Cristhian Garc�a CR - 26/10/2023 
    Versi�n: 3.0 
    Requerido: Privilegios para crear BD, tabla e inserci�n/actualizaci�n/borrar  
--------------------------------------------------------------------------------------------------------------*/ 
USE bd_crud
GO 
PRINT '... Iniciando la creaci�n de Schemas ...' 
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
		BEGIN TRANSACTION; -- Inicia la transacci�n

		-- Validar los datos, longitud del nombre y descripci�n
		IF (LEN(@nombre) <= 30 AND LEN(@descripcion) <= 500)
		BEGIN
			-- Realizar la inserci�n en la tabla
			INSERT INTO sch_Rrh.tbRoles (nom, det) VALUES (@nombre, @descripcion);

			COMMIT; -- Confirmar la transacci�n
		END
		ELSE
		BEGIN
			-- Los datos no cumplen con las validaciones
			ROLLBACK; -- Deshacer la transacci�n
		END
	END TRY
	BEGIN CATCH
		-- Ocurri� un error, deshacer la transacci�n
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
    DECLARE @expresionRegular nvarchar(50) = N'^[A-Za-z ]+$'; -- Esta expresi�n regular permite letras y espacios

    IF @nombre IS NULL
        RETURN 1; -- Si el nombre es nulo, es v�lido

    IF @nombre LIKE @expresionRegular
        RETURN 1; -- Coincide con la expresi�n regular

    RETURN 0; -- No coincide con la expresi�n regular
END


ALTER TABLE sch_Rrh.tbRoles
ADD CONSTRAINT CK_NombreValido CHECK (dbo.fn_ValidarNombre(nom) = 1);

*/