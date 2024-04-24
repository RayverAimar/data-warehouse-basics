-- create_schema.sql

-- Create Fecha table
CREATE TABLE IF NOT EXISTS Fecha (
    Clave_Fecha SERIAL PRIMARY KEY,
    Dia INTEGER,
    Mes INTEGER,
    Anio INTEGER,
    Dia_Semana VARCHAR(20)
);

-- Create Local table
CREATE TABLE IF NOT EXISTS Local (
    Clave_Local SERIAL PRIMARY KEY,
    Nombre VARCHAR(100),
    Direccion VARCHAR(200),
    Distrito VARCHAR(100),
    Ciudad VARCHAR(100),
    Region VARCHAR(100)
);

-- Create Producto table
CREATE TABLE IF NOT EXISTS Producto (
    Clave_Producto SERIAL PRIMARY KEY,
    Descripcion VARCHAR(100),
    SKU VARCHAR(50),
    Descripcion_Marca VARCHAR(100),
    Descripcion_Categoria VARCHAR(100),
    Descripcion_Tipo_Paquete VARCHAR(100),
    Tamano_Paquete VARCHAR(50)
);

-- Create Venta_Diaria table
CREATE TABLE IF NOT EXISTS Venta_Diaria (
    Cantidad_Vendida INTEGER,
    Monto_Venta DECIMAL(10, 2),
    Clave_Local INTEGER,
    Clave_Fecha INTEGER,
    Clave_Producto INTEGER,
    FOREIGN KEY (Clave_Local) REFERENCES Local(Clave_Local),
    FOREIGN KEY (Clave_Fecha) REFERENCES Fecha(Clave_Fecha),
    FOREIGN KEY (Clave_Producto) REFERENCES Producto(Clave_Producto)
);
