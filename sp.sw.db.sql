GO
CREATE PROCEDURE sw.SignUpUsuarioLocal
    @Nombre VARCHAR(255),
    @Correo VARCHAR(255),
    @Contrasena VARCHAR(255)
AS
BEGIN
  BEGIN TRY
    DECLARE @ID_Proveedor UNIQUEIDENTIFIER = (SELECT ID_Proveedor FROM sw.Proveedores WHERE Nombre = 'Local');
    INSERT INTO sw.Usuarios (Nombre, Correo, Contrasena_Hash, ID_Proveedor, Fecha_Ultimo_Acceso) 
      VALUES (@Nombre, @Correo, HASHBYTES('SHA2_512', @Contrasena), @ID_Proveedor, GETDATE());
    SELECT 'Usuario registrado correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    THROW 51000, 'Error al registrar usuario', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.SignInUsuarioLocal
    @Correo VARCHAR(255),
    @Contrasena VARCHAR(255)
AS
BEGIN
  BEGIN TRY
    DECLARE @ID_Proveedor UNIQUEIDENTIFIER = (SELECT ID_Proveedor FROM sw.Proveedores WHERE Nombre = 'Local');
    UPDATE sw.Usuarios SET Fecha_Ultimo_Acceso = GETDATE() WHERE Correo = @Correo AND Contrasena_Hash = HASHBYTES('SHA2_512', @Contrasena) AND ID_Proveedor = @ID_Proveedor;
    SELECT ID_Usuario AS IDUsuario, Nombre AS NombreUsuario, Correo AS CorreoUsuario, 
      Identificacion AS IdentificacionUsuario, Telefono AS TelefonoUsuario, 
      Direccion AS DireccionUsuario, Fecha_Nacimiento AS FechaNacimientoUsuario, 
      Fecha_Actualizacion AS FechaActualizacionUsuario, Fecha_Ultimo_Acceso AS FechaUltimoAccesoUsuario, 
      Fecha_Registro AS FechaRegistroUsuario FROM sw.Usuarios 
    WHERE Correo = @Correo AND Contrasena_Hash = HASHBYTES('SHA2_512', @Contrasena) AND ID_Proveedor = @ID_Proveedor;
  END TRY
  BEGIN CATCH
    THROW 51000, 'Error al iniciar sesión', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.SignUpUsuarioProveedor
    @Nombre VARCHAR(255),
    @Correo VARCHAR(255),
    @ID_Proveedor UNIQUEIDENTIFIER,
    @ID_Usuario_Proveedor VARCHAR(255),
    @Identificacion VARCHAR(20) NULL,
    @Telefono VARCHAR(20) NULL,
    @Direccion VARCHAR(255) NULL,
    @Fecha_Nacimiento DATE NULL
AS
BEGIN
  BEGIN TRY
    INSERT INTO sw.Usuarios (Nombre, Correo, ID_Proveedor, ID_Usuario_Proveedor, Identificacion, Telefono, Direccion, Fecha_Nacimiento, Fecha_Ultimo_Acceso) 
      VALUES (@Nombre, @Correo, @ID_Proveedor, @ID_Usuario_Proveedor, @Identificacion, @Telefono, @Direccion, @Fecha_Nacimiento, GETDATE());
    SELECT ID_Usuario AS IDUsuario, Nombre AS NombreUsuario, Correo AS CorreoUsuario FROM sw.Usuarios 
    WHERE ID_Proveedor = @ID_Proveedor AND ID_Usuario_Proveedor = @ID_Usuario_Proveedor;
  END TRY
  BEGIN CATCH
    THROW 51000, 'Error al registrar usuario', 1;
  END CATCH
END;

SELECT * FROM sw.Usuarios;
GO
CREATE PROCEDURE sw.SignInUsuarioProveedor
    @Correo VARCHAR(255),
    @ID_Proveedor UNIQUEIDENTIFIER,
    @ID_Usuario_Proveedor VARCHAR(255)
AS
BEGIN
  BEGIN TRY
    UPDATE sw.Usuarios SET Fecha_Ultimo_Acceso = GETDATE() WHERE Correo = @Correo AND ID_Proveedor = @ID_Proveedor AND ID_Usuario_Proveedor = @ID_Usuario_Proveedor;
    SELECT ID_Usuario AS IDUsuario, Nombre AS NombreUsuario, Correo AS CorreoUsuario, 
      Identificacion AS IdentificacionUsuario, Telefono AS TelefonoUsuario, 
      Direccion AS DireccionUsuario, Fecha_Nacimiento AS FechaNacimientoUsuario, 
      Fecha_Actualizacion AS FechaActualizacionUsuario, Fecha_Ultimo_Acceso AS FechaUltimoAccesoUsuario, 
      Fecha_Registro AS FechaRegistroUsuario FROM sw.Usuarios 
    WHERE Correo = @Correo AND ID_Proveedor = @ID_Proveedor AND ID_Usuario_Proveedor = @ID_Usuario_Proveedor;
  END TRY
  BEGIN CATCH
    THROW 51000, 'Error al iniciar sesión', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.UpdateUsuarioByBank
    @ID_Usuario UNIQUEIDENTIFIER,
    @Nombre VARCHAR(255) NULL,
    @Correo VARCHAR(255) NULL,
    @Identificacion VARCHAR(20) NULL,
    @Telefono VARCHAR(20) NULL,
    @Direccion VARCHAR(255) NULL,
    @Fecha_Nacimiento DATE NULL
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    UPDATE sw.Usuarios SET Nombre = ISNULL(@Nombre, Nombre), Correo = ISNULL(@Correo, Correo), 
      Identificacion = ISNULL(@Identificacion, Identificacion), Telefono = ISNULL(@Telefono, Telefono), 
      Direccion = ISNULL(@Direccion, Direccion), Fecha_Nacimiento = ISNULL(@Fecha_Nacimiento, Fecha_Nacimiento), 
      Fecha_Actualizacion = GETDATE(), Fecha_Ultimo_Acceso = GETDATE() WHERE ID_Usuario = @ID_Usuario;
    SELECT 'Usuario actualizado correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al actualizar usuario', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.InsertarSuscripcion
    @ID_Usuario UNIQUEIDENTIFIER,
    @ID_Nivel UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    DECLARE @Fecha_Inicio DATE = GETDATE();
    DECLARE @Fecha_Final DATE = NULL;
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    IF NOT EXISTS (SELECT * FROM sw.Niveles WHERE ID_Nivel = @ID_Nivel)
      THROW 51000, 'El nivel no existe', 1;
    IF @ID_Nivel != '00000000-0000-0000-0000-000000000001' -- Reemplaza con el ID del nivel básico
    BEGIN
        SET @Fecha_Final = DATEADD(MONTH, 1, @Fecha_Inicio);
    END
    INSERT INTO sw.Suscripciones (ID_Usuario, ID_Nivel, Fecha_Inicio, Fecha_Final) VALUES (@ID_Usuario, @ID_Nivel, @Fecha_Inicio, @Fecha_Final);
    SELECT 'Usuario suscrito correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al suscribir usuario', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.InsertarCuentaBancaria
    @ID_Usuario UNIQUEIDENTIFIER,
    @AccountHash VARCHAR(255),
    @ID_Banco UNIQUEIDENTIFIER,
    @ID_TipoCuenta INT,
    @ID_Moneda INT,
    @NumeroCuenta VARCHAR(20),
    @Nombre VARCHAR(255),
    @Saldo DECIMAL(15, 2),
    @Descripcion VARCHAR(255) NULL,
    @LimiteCredito DECIMAL(15,2) NULL,
    @TasaInteres DECIMAL(5,2) NULL
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    IF NOT EXISTS (SELECT * FROM sw.Bancos WHERE BancoID = @ID_Banco)
      THROW 51000, 'El banco no existe', 1;
    IF NOT EXISTS (SELECT * FROM sw.TipoCuentas WHERE TipoCuentaID = @ID_TipoCuenta)
      THROW 51000, 'El tipo de cuenta no existe', 1;
    IF NOT EXISTS (SELECT * FROM sw.Monedas WHERE MonedaID = @ID_Moneda)
      THROW 51000, 'La moneda no existe', 1;
    INSERT INTO sw.CuentaBancaria (ID_Usuario, AccountHash, ID_Banco, ID_TipoCuenta, ID_Moneda, NumeroCuenta, Nombre, Saldo, DescripcionCuenta, LimiteCredito, TasaInteres)
      VALUES (@ID_Usuario, @AccountHash, @ID_Banco, @ID_TipoCuenta, @ID_Moneda, @NumeroCuenta, @Nombre, @Saldo, @Descripcion, @LimiteCredito, @TasaInteres);
    SELECT 'Cuenta bancaria registrada correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al registrar cuenta bancaria', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.ObtenerCuentasBancarias
    @ID_Usuario UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    SELECT * FROM sw.CuentaBancaria WHERE ID_Usuario = @ID_Usuario;
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al obtener cuentas bancarias', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.InsertarCategoria
    @ID_Usuario UNIQUEIDENTIFIER,
    @Nombre VARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    INSERT INTO sw.Categorias (ID_Usuario, Nombre, DescripcionCategoria) VALUES (@ID_Usuario, @Nombre, @Descripcion);
    SELECT 'Categoría registrada correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al registrar categoría', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.EliminarCategoria
    @ID_Categoria UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Categorias WHERE ID_Categoria = @ID_Categoria) 
      THROW 51000, 'La categoría no existe', 1;
    DELETE FROM sw.Categorias WHERE ID_Categoria = @ID_Categoria;
    SELECT 'Categoría eliminada correctamente' AS 'MESSAGE';
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al eliminar categoría', 1;
  END CATCH
END;

GO
CREATE PROCEDURE sw.ObtenerCategorias
    @ID_Usuario UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario) 
      THROW 51000, 'El usuario no existe', 1;
    SELECT * FROM sw.Categorias WHERE ID_Usuario IS NULL OR ID_Usuario = @ID_Usuario;
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al obtener categorías', 1;
  END CATCH
END;
DROP PROCEDURE sw.CrearPresupuestoDesdeCuentas;
-- Procedimiento para insertar un nuevo presupuesto con cuenta asignada 
GO
CREATE PROCEDURE sw.CrearPresupuestoDesdeCuentas -- falta revisar
    @ID_Usuario UNIQUEIDENTIFIER,
    @Nombre VARCHAR(255),
    @MontoTotal DECIMAL(15, 2),
    @Descripcion VARCHAR(255),
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @Cuentas TABLE (ID_Cuenta UNIQUEIDENTIFIER, Monto DECIMAL(15, 2))
        DECLARE @SaldoTotal DECIMAL(15, 2) = 0;
        DECLARE @CuentaID UNIQUEIDENTIFIER;
        DECLARE @Monto DECIMAL(15, 2);
        DECLARE @SaldoCuenta DECIMAL(15, 2);

        -- Calculate total available balance in selected accounts
        DECLARE cuenta_cursor CURSOR FOR SELECT ID_Cuenta, Monto FROM @Cuentas;
        OPEN cuenta_cursor;
        FETCH NEXT FROM cuenta_cursor INTO @CuentaID, @Monto;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @SaldoCuenta = Saldo FROM sw.CuentaBancaria WHERE ID_Cuenta = @CuentaID AND ID_Usuario = @ID_Usuario;
            IF @SaldoCuenta < @Monto
              THROW 51000, 'Saldo insuficiente en una de las cuentas seleccionadas.', 1;
            SET @SaldoTotal += @Monto;
            FETCH NEXT FROM cuenta_cursor INTO @CuentaID, @Monto;
        END
        CLOSE cuenta_cursor;
        DEALLOCATE cuenta_cursor;
        SELECT @SaldoTotal AS 'SaldoTotal'; -- BORRAR DESPUES DE PROBAR
        SELECT @MontoTotal AS 'MontoTotal'; -- BORRAR DESPUES DE PROBAR
        IF @SaldoTotal < @MontoTotal
            THROW 51000, 'Saldo total insuficiente para el presupuesto.', 1;

        -- Deduct from accounts and create budget
        OPEN cuenta_cursor;
        FETCH NEXT FROM cuenta_cursor INTO @CuentaID, @Monto;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE sw.CuentaBancaria SET Saldo = Saldo - @Monto WHERE ID_Cuenta = @CuentaID AND ID_Usuario = @ID_Usuario;

            INSERT INTO sw.Presupuestos (ID_Usuario, NombrePresupuesto, MontoTotal, DescripcionPresupuesto, FechaInicio, FechaFin, ID_Cuenta, MontoAsignado)
            VALUES (@ID_Usuario, @Nombre, @MontoTotal, @Descripcion, @FechaInicio, @FechaFin, @CuentaID, @Monto);

            FETCH NEXT FROM cuenta_cursor INTO @CuentaID, @Monto;
        END
        CLOSE cuenta_cursor;
        DEALLOCATE cuenta_cursor;

        SELECT 'Presupuesto creado y fondos asignados correctamente' AS 'MESSAGE';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51000
            THROW;
        ELSE
            THROW 51000, 'Error al crear presupuesto', 1;
    END CATCH
END;

-- Procedimiento para insertar una nueva meta de ahorro sin transferencia programada
GO
CREATE PROCEDURE sw.InsertarMetaAhorro
    @ID_Usuario UNIQUEIDENTIFIER,
    @NombreMeta VARCHAR(255),
    @MontoObjetivo DECIMAL(15, 2),
    @ID_Prioridad UNIQUEIDENTIFIER,
    @FechaInicio DATE,
    @FechaMeta DATE,
    @DescripcionMeta VARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
      IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario)
        THROW 51000, 'El usuario no existe', 1;
      IF NOT EXISTS (SELECT * FROM sw.Prioridades WHERE ID_Prioridad = @ID_Prioridad)
        THROW 51000, 'La prioridad no existe', 1;

        INSERT INTO sw.MetasAhorro (ID_Usuario, NombreMeta, MontoObjetivo, FechaInicio, FechaMeta, DescripcionMeta, ID_Prioridad)
        VALUES (@ID_Usuario, @NombreMeta, @MontoObjetivo, @FechaInicio, @FechaMeta, @DescripcionMeta, @ID_Prioridad);
        SELECT 'Meta de ahorro creada correctamente' AS 'MESSAGE';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51000
            THROW;
        ELSE
            THROW 51000, 'Error al crear meta de ahorro', 1;
    END CATCH
END;

GO
CREATE PROCEDURE sw.ProgramarTransferenciaMetaAhorro
    @ID_Usuario UNIQUEIDENTIFIER,
    @ID_Meta UNIQUEIDENTIFIER,
    @ID_CuentaOrigen UNIQUEIDENTIFIER,
    @ID_Frecuencia UNIQUEIDENTIFIER,
    @Monto DECIMAL(15, 2),
    @FechaInicio DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @SaldoCuenta DECIMAL(15, 2);
        SELECT @SaldoCuenta = Saldo FROM sw.CuentaBancaria WHERE ID_Cuenta = @ID_CuentaOrigen AND ID_Usuario = @ID_Usuario;

        IF @SaldoCuenta < @Monto
            THROW 51000, 'Saldo insuficiente en la cuenta de origen.', 1;

        UPDATE sw.MetasAhorro
        SET ID_Frecuencia = @ID_Frecuencia, MontoTransferencia = @Monto, 
            FechaProximaTransferencia = @FechaInicio, ID_CuentaOrigen = @ID_CuentaOrigen
        WHERE ID_Meta = @ID_Meta AND ID_Usuario = @ID_Usuario;

        SELECT 'Transferencia programada correctamente' AS 'MESSAGE';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51000
            THROW;
        ELSE
            THROW 51000, 'Error al programar transferencia de meta de ahorro', 1;
    END CATCH
END;

GO
CREATE PROCEDURE sw.EjecutarTransferenciasProgramadas
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Meta UNIQUEIDENTIFIER;
        DECLARE @ID_CuentaOrigen UNIQUEIDENTIFIER;
        DECLARE @Monto DECIMAL(15, 2);
        DECLARE @FechaProximaTransferencia DATETIME;
        DECLARE @SaldoCuenta DECIMAL(15, 2);

        DECLARE transferencia_cursor CURSOR FOR 
        SELECT ID_Meta, ID_CuentaOrigen, MontoTransferencia, FechaProximaTransferencia
        FROM sw.MetasAhorro
        WHERE FechaProximaTransferencia <= GETDATE();

        OPEN transferencia_cursor;
        FETCH NEXT FROM transferencia_cursor INTO @ID_Meta, @ID_CuentaOrigen, @Monto, @FechaProximaTransferencia;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @SaldoCuenta = Saldo FROM sw.CuentaBancaria WHERE ID_Cuenta = @ID_CuentaOrigen;

            IF @SaldoCuenta >= @Monto
            BEGIN
                UPDATE sw.CuentaBancaria
                SET Saldo = Saldo - @Monto
                WHERE ID_Cuenta = @ID_CuentaOrigen;

                UPDATE sw.MetasAhorro
                SET MontoAhorrado = MontoAhorrado + @Monto,
                    FechaProximaTransferencia = DATEADD(MONTH, 1, @FechaProximaTransferencia) -- Update next transfer date (assuming monthly)
                WHERE ID_Meta = @ID_Meta;
            END

            FETCH NEXT FROM transferencia_cursor INTO @ID_Meta, @ID_CuentaOrigen, @Monto, @FechaProximaTransferencia;
        END

        CLOSE transferencia_cursor;
        DEALLOCATE transferencia_cursor;

        SELECT 'Transferencias programadas ejecutadas correctamente' AS 'MESSAGE';
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error al ejecutar transferencias programadas', 1;
    END CATCH
END;


-- Procedimiento para agregar un seguimiento a una meta de ahorro
-- GO
-- CREATE PROCEDURE sw.AgregarSeguimientoMeta -- falta revisar
--     @ID_Meta UNIQUEIDENTIFIER,
--     @MontoAhorrado DECIMAL(15, 2)
-- AS
-- BEGIN
--     BEGIN TRY
--         INSERT INTO sw.SeguimientoMetas (ID_Meta, MontoAhorrado)
--         VALUES (@ID_Meta, @MontoAhorrado);
--         UPDATE sw.MetasAhorro
--         SET MontoAhorrado = MontoAhorrado + @MontoAhorrado, FechaActualizacion = GETDATE()
--         WHERE ID_Meta = @ID_Meta;
--         SELECT 'Seguimiento de meta registrado correctamente' AS 'MESSAGE';
--     END TRY
--     BEGIN CATCH
--         THROW 51000, 'Error al agregar seguimiento de meta', 1;
--     END CATCH
-- END;

-- Procedimiento para obtener el estado de las metas de ahorro de un usuario
GO
CREATE PROCEDURE sw.ObtenerEstadoMetasAhorro
    @ID_Usuario UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        SELECT ma.ID_Meta, ma.NombreMeta, ma.MontoObjetivo, ma.FechaMeta, ma.DescripcionMeta, p.Nombre AS Prioridad, ma.FechaInicio
        FROM sw.MetasAhorro ma INNER JOIN sw.Prioridades p ON ma.ID_Prioridad = p.ID_Prioridad
        WHERE ma.ID_Usuario = @ID_Usuario;
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error al obtener estado de metas de ahorro', 1;
    END CATCH
END;
DROP PROCEDURE sw.ObtenerEstadoMetasAhorro;
-- Procedimiento para obtener el estado de los presupuestos de un usuario
GO
CREATE PROCEDURE sw.ObtenerEstadoPresupuestos
    @ID_Usuario UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        SELECT p.ID_Presupuesto, p.NombrePresupuesto, p.MontoTotal, p.MontoGastado, p.FechaInicio, p.FechaFin,
            (p.MontoTotal - p.MontoGastado) AS MontoRestante, p.FechaActualizacion
        FROM sw.Presupuestos
        WHERE p.ID_Usuario = @ID_Usuario;
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error al obtener estado de presupuestos', 1;
    END CATCH
END;

GO
CREATE PROCEDURE sw.findUserByOid
    @ID_Usuario_Proveedor VARCHAR(255)
AS
BEGIN
  BEGIN TRY
    IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario_Proveedor = @ID_Usuario_Proveedor OR ID_Usuario = @ID_Usuario_Proveedor)
      SELECT 'Usuario no encontrado' AS 'MESSAGE';
    ELSE
      SELECT ID_Usuario AS IDUsuario, Nombre AS NombreUsuario, Correo AS CorreoUsuario FROM sw.Usuarios
      WHERE ID_Usuario_Proveedor = @ID_Usuario_Proveedor;
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 51000
      THROW;
    ELSE
      THROW 51000, 'Error al buscar usuario', 1;
  END CATCH
END;

EXEC sw.findUserByOid '8213f38f-1530-41a8-b3fc-64830f7ca199';

GO
CREATE PROCEDURE sw.getPrioridades
AS
BEGIN
  BEGIN TRY
    SELECT * FROM sw.Prioridades;
  END TRY
  BEGIN CATCH
    THROW 51000, 'Error al obtener prioridades', 1;
  END CATCH
END;

-- SP PARA TRAER UNA META DE AHORRO POR ID CON TADA LA INFORMACION POSIBLE
GO
CREATE PROCEDURE sw.ObtenerMetaAhorroPorID
    @ID_Meta UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM sw.MetasAhorro WHERE ID_Meta = @ID_Meta)
          THROW 51000, 'La meta de ahorro no existe', 1;

        SELECT ma.ID_Meta, ma.NombreMeta, ma.MontoObjetivo, ma.FechaInicio, ma.FechaMeta, ma.DescripcionMeta, ma.FechaProximaTransferencia,
            ma.MontoTransferencia, ma.MontoAhorrado, ma.FechaCreacion, p.Nombre AS Prioridad, ma.FechaActualizacion, cb.NumeroCuenta AS CuentaOrigen, cb.Nombre AS NombreCuentaOrigen
        FROM sw.MetasAhorro ma INNER JOIN sw.Prioridades p ON ma.ID_Prioridad = p.ID_Prioridad INNER JOIN sw.CuentaBancaria cb ON ma.ID_CuentaOrigen = cb.ID_Cuenta
        WHERE ma.ID_Meta = @ID_Meta;
        
        IF @@ROWCOUNT = 0
          SELECT ma.ID_Meta, ma.NombreMeta, ma.MontoObjetivo, ma.FechaInicio, ma.FechaMeta, ma.DescripcionMeta, ma.FechaProximaTransferencia,
              ma.MontoTransferencia, ma.MontoAhorrado, ma.FechaCreacion, p.Nombre AS Prioridad, ma.FechaActualizacion
          FROM sw.MetasAhorro ma INNER JOIN sw.Prioridades p ON ma.ID_Prioridad = p.ID_Prioridad
          WHERE ma.ID_Meta = @ID_Meta;
    END TRY
    BEGIN CATCH
      IF ERROR_NUMBER() = 51000
        THROW;
      ELSE
        THROW 51000, 'Error al obtener meta de ahorro', 1;
    END CATCH
END;
DROP PROCEDURE sw.ObtenerMetaAhorroPorID;
SELECT * FROM sw.Prioridades
SELECT * FROM sw.MetasAhorro;

SELECT cb.ID_Cuenta, b.Nombre AS NombreBanco, cb.NumeroCuenta, cb.Nombre, cb.Saldo
        FROM sw.CuentaBancaria cb INNER JOIN sw.Bancos b ON cb.ID_Banco = b.BancoID
        WHERE cb.ID_Usuario = '8213f38f-1530-41a8-b3fc-64830f7ca199';

-- Procedimiento para obtener las cuentas bancarias de un usuario por ID del usuario

GO
CREATE PROCEDURE sw.ObtenerCuentasBancariasPorIDUsuario
    @ID_Usuario UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario)
            THROW 51000, 'El usuario no existe', 1;

        IF NOT EXISTS (SELECT * FROM sw.CuentaBancaria WHERE ID_Usuario = @ID_Usuario)
            THROW 51000, 'El usuario no tiene cuentas bancarias registradas', 1;
        
        SELECT cb.ID_Cuenta, b.Nombre AS NombreBanco, cb.NumeroCuenta, cb.Nombre, cb.Saldo
        FROM sw.CuentaBancaria cb INNER JOIN sw.Bancos b ON cb.ID_Banco = b.BancoID
        WHERE cb.ID_Usuario = @ID_Usuario;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51000
            THROW;
        ELSE
            THROW 51000, 'Error al obtener cuentas bancarias', 1;
    END CATCH
END;
DROP PROCEDURE sw.ObtenerCuentasBancariasPorIDUsuario;
EXEC sw.ObtenerCuentasBancariasPorIDUsuario '8213F38F-1530-41A8-B3FC-64830F7CA199';


GO
CREATE PROCEDURE sw.TransferirFondosMetaAhorro
    @ID_Usuario UNIQUEIDENTIFIER,
    @ID_Meta UNIQUEIDENTIFIER,
    @ID_CuentaOrigen UNIQUEIDENTIFIER,
    @Monto DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRY
        DECLARE @SaldoCuenta DECIMAL(15, 2);
        DECLARE @MontoAhorrado DECIMAL(15, 2);
        DECLARE @MontoObjetivo DECIMAL(15, 2);

        IF NOT EXISTS (SELECT * FROM sw.Usuarios WHERE ID_Usuario = @ID_Usuario)
            THROW 51000, 'El usuario no existe', 1;
        IF NOT EXISTS (SELECT * FROM sw.CuentaBancaria WHERE ID_Cuenta = @ID_CuentaOrigen AND ID_Usuario = @ID_Usuario)
            THROW 51000, 'La cuenta de origen no existe', 1;
        IF NOT EXISTS (SELECT * FROM sw.MetasAhorro WHERE ID_Meta = @ID_Meta AND ID_Usuario = @ID_Usuario)
            THROW 51000, 'La meta de ahorro no existe', 1;

        SELECT @SaldoCuenta = Saldo FROM sw.CuentaBancaria WHERE ID_Cuenta = @ID_CuentaOrigen AND ID_Usuario = @ID_Usuario;

        IF @SaldoCuenta < @Monto
            THROW 51000, 'Saldo insuficiente en la cuenta de origen.', 1;

        SELECT @MontoAhorrado = MontoAhorrado, @MontoObjetivo = MontoObjetivo
        FROM sw.MetasAhorro WHERE ID_Meta = @ID_Meta AND ID_Usuario = @ID_Usuario;

        IF @MontoAhorrado + @Monto > @MontoObjetivo
            THROW 51000, 'La cantidad a transferir excede el monto objetivo de la meta de ahorro.', 1;

        UPDATE sw.MetasAhorro SET MontoAhorrado = MontoAhorrado + @Monto WHERE ID_Meta = @ID_Meta AND ID_Usuario = @ID_Usuario;
        UPDATE sw.CuentaBancaria SET Saldo = Saldo - @Monto WHERE ID_Cuenta = @ID_CuentaOrigen AND ID_Usuario = @ID_Usuario;

        INSERT sw.Transacciones (CuentaID, TipoTransaccionID, Monto, DescripcionTransac)
        VALUES (@ID_CuentaOrigen, 5, @Monto, 'AHORRO PROTEGIDO');

        SELECT 'Fondos transferidos correctamente' AS 'MESSAGE';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51000
            THROW;
        ELSE
            THROW 51000, 'Error al transferir fondos', 1;
    END CATCH
END;
DROP PROCEDURE sw.TransferirFondosMetaAhorro;
EXEC sw.TransferirFondosMetaAhorro '8213f38f-1530-41a8-b3fc-64830f7ca199', 'E12469EF-F1F1-4273-925B-09A7D08492D5', '205CA2CA-C16E-4AF4-9F81-9C21049501E7', 100.00;

SELECT * FROM sw.MetasAhorro;