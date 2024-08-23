CREATE TABLE sw.Proveedores (
    ID_Proveedor UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Nombre VARCHAR(255) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE sw.Usuarios (
    ID_Usuario UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(), 
    Nombre VARCHAR(255) NOT NULL,
    Correo VARCHAR(255) NOT NULL UNIQUE,
    Contrasena_Hash VARCHAR(MAX), 
    ID_Proveedor UNIQUEIDENTIFIER NOT NULL, 
    ID_Usuario_Proveedor VARCHAR(255) NULL UNIQUE, 
    Identificacion VARCHAR(20) NULL UNIQUE, 
    Telefono VARCHAR(20) NULL UNIQUE, 
    Direccion VARCHAR(255) NULL,
    Fecha_Nacimiento DATE NULL,
    Fecha_Actualizacion DATETIME NULL,
    Fecha_Ultimo_Acceso DATETIME NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (ID_Proveedor) REFERENCES sw.Proveedores(ID_Proveedor)
);
SELECT * FROM sw.Usuarios;
CREATE TABLE sw.Niveles (
    ID_Nivel UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Nombre VARCHAR(255) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE sw.Suscripciones (
    ID_Suscripcion UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ID_Usuario UNIQUEIDENTIFIER NOT NULL,
    ID_Nivel UNIQUEIDENTIFIER NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Final DATE NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES sw.Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Nivel) REFERENCES sw.Niveles(ID_Nivel)
);

CREATE TABLE sw.Bancos (
    BancoID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Nombre VARCHAR(100) NOT NULL,
    CodigoSwift VARCHAR(20),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20)
);

CREATE TABLE sw.TipoCuentas (
    TipoCuentaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    DescripcionTipoCuenta VARCHAR(255)
);

CREATE TABLE sw.Monedas (
    MonedaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Simbolo VARCHAR(5),
    Pais VARCHAR(100),
    DescripcionMoneda VARCHAR(255)
);

CREATE TABLE sw.CuentaBancaria (
    ID_Cuenta UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ID_Usuario UNIQUEIDENTIFIER NOT NULL,
    AccountHash VARCHAR(255) NOT NULL UNIQUE,
    ID_Banco UNIQUEIDENTIFIER NOT NULL,
    ID_TipoCuenta INT NOT NULL,
    ID_Moneda INT DEFAULT 1,
    NumeroCuenta VARCHAR(20) NOT NULL UNIQUE,
    Nombre VARCHAR(255) NOT NULL,
    Saldo DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    LimiteCredito DECIMAL(15,2) NULL,
    TasaInteres DECIMAL(5,2) NULL,
    DescripcionCuenta VARCHAR(255) NULL,
    FechaApertura DATE DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES sw.Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Banco) REFERENCES sw.Bancos(BancoID),
    FOREIGN KEY (ID_TipoCuenta) REFERENCES sw.TipoCuentas(TipoCuentaID),
    FOREIGN KEY (ID_Moneda) REFERENCES sw.Monedas(MonedaID)
);

CREATE TABLE sw.Categorias (
    ID_Categoria UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ID_Usuario UNIQUEIDENTIFIER NULL,
    Nombre VARCHAR(255) NOT NULL,
    DescripcionCategoria VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES sw.Usuarios(ID_Usuario)
);

CREATE TABLE SW.TipoTransacciones (
    TipoTransaccionID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    DescripcionTipoTransac VARCHAR(255)
);

CREATE TABLE SW.Transacciones (
    TransaccionID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CuentaID UNIQUEIDENTIFIER NOT NULL,
    TipoTransaccionID INT NOT NULL,
    Monto DECIMAL(15,2) NOT NULL,
    FechaTransaccion DATETIME DEFAULT GETDATE(),
    DescripcionTransac VARCHAR(255),
    FOREIGN KEY (CuentaID) REFERENCES sw.CuentaBancaria(ID_Cuenta),
    FOREIGN KEY (TipoTransaccionID) REFERENCES sw.TipoTransacciones(TipoTransaccionID)
);

CREATE TABLE SW.Prestamos (
    PrestamoID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CuentaID UNIQUEIDENTIFIER NOT NULL,
    MontoPrestamo DECIMAL(15,2) NOT NULL,
    TasaInteres DECIMAL(5,2) NOT NULL,
    PlazoMeses INT NOT NULL,
    FechaDesembolso DATE,
    FechaVencimiento DATE,
    SaldoPendiente DECIMAL(15,2) DEFAULT 0.00,
    FOREIGN KEY (CuentaID) REFERENCES sw.CuentaBancaria(ID_Cuenta)
);

CREATE TABLE sw.Presupuestos (
    ID_Presupuesto UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ID_Usuario UNIQUEIDENTIFIER NOT NULL,
    ID_Cuenta UNIQUEIDENTIFIER,
    MontoAsignado DECIMAL(15, 2),
    NombrePresupuesto VARCHAR(255) NOT NULL,
    MontoTotal DECIMAL(15, 2) NOT NULL,
    MontoGastado DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    DescripcionPresupuesto VARCHAR(255) NULL,
    FechaCreacion DATETIME DEFAULT GETDATE() NOT NULL,
    FechaActualizacion DATETIME NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES sw.Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Cuenta) REFERENCES sw.CuentaBancaria(ID_Cuenta)
);

CREATE TABLE sw.Frecuencias (
    ID_Frecuencia UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Nombre NVARCHAR(255) NOT NULL,
    Descripcion NVARCHAR(255) NOT NULL
);

CREATE TABLE sw.Prioridades (
    ID_Prioridad UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Nombre NVARCHAR(255) NOT NULL,
    Descripcion NVARCHAR(255) NOT NULL
);

CREATE TABLE sw.MetasAhorro (
    ID_Meta UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ID_Usuario UNIQUEIDENTIFIER NOT NULL,
    ID_CuentaOrigen UNIQUEIDENTIFIER,
    ID_Frecuencia UNIQUEIDENTIFIER NULL,
    ID_Prioridad UNIQUEIDENTIFIER NOT NULL,
    MontoTransferencia DECIMAL(15, 2),
    FechaProximaTransferencia DATETIME,
    NombreMeta VARCHAR(255) NOT NULL,
    MontoObjetivo DECIMAL(15, 2) NOT NULL,
    MontoAhorrado DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    FechaInicio DATE NOT NULL,
    FechaMeta DATE NOT NULL,
    DescripcionMeta VARCHAR(255) NULL,
    FechaCreacion DATETIME DEFAULT GETDATE() NOT NULL,
    FechaActualizacion DATETIME NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES sw.Usuarios(ID_Usuario),
    FOREIGN KEY (ID_CuentaOrigen) REFERENCES sw.CuentaBancaria(ID_Cuenta),
    FOREIGN KEY (ID_Frecuencia) REFERENCES sw.Frecuencias(ID_Frecuencia),
    FOREIGN KEY (ID_Prioridad) REFERENCES sw.Prioridades(ID_Prioridad)
);
