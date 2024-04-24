CREATE OR REPLACE FUNCTION obtener_ventas_totales_por_local()
RETURNS TABLE (
    Nombre_Local VARCHAR(100),
    Total_Cantidad_Vendida BIGINT,
    Total_Monto_Venta DECIMAL(10,2)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        l.Nombre AS Nombre_Local,
        SUM(vd.Cantidad_Vendida) AS Total_Cantidad_Vendida,
        SUM(vd.Monto_Venta) AS Total_Monto_Venta
    FROM 
        Venta_Diaria vd
    JOIN 
        Local l ON vd.Clave_Local = l.Clave_Local
    GROUP BY 
        Nombre_Local
    ORDER BY 
        Nombre_Local;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_ventas_totales_por_local_drill_down_marca_producto()
RETURNS TABLE (
    Nombre_Local VARCHAR,
	Marca_Producto VARCHAR,
    Total_Cantidad_Vendida BIGINT,
    Total_Monto_Venta DECIMAL
)
AS $$
BEGIN
RETURN QUERY
SELECT
    l.Nombre AS Nombre_Local,
    p.Descripcion_Marca AS Marca_Producto,
    SUM(vd.Cantidad_Vendida) AS Total_Cantidad_Vendida,
    SUM(vd.Monto_Venta) AS Total_Monto_Venta
FROM 
    Venta_Diaria vd
JOIN 
    Local l ON vd.Clave_Local = l.Clave_Local
JOIN 
    Producto p ON vd.Clave_Producto = p.Clave_Producto
GROUP BY 
    Nombre_Local, Marca_Producto
ORDER BY 
    Nombre_Local;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_estadisticas_ventas_por_producto(
    IN p_anio INTEGER,
    IN p_mes INTEGER,
    IN p_dia_desde INTEGER,
    IN p_dia_hasta INTEGER
)
RETURNS TABLE (
    Producto VARCHAR,
    Total_Cantidad_Vendida BIGINT,
    Ganancia_Total DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
	SELECT 
	    p.Descripcion AS Producto,
		SUM(vd.Cantidad_Vendida) AS Total_Cantidad_Vendida,
	    SUM(vd.Monto_Venta) AS Ganancia_Total
	FROM 
	    Venta_Diaria vd
	JOIN 
	    Producto p ON vd.Clave_Producto = p.Clave_Producto
	JOIN 
	    Fecha f ON vd.Clave_Fecha = f.Clave_Fecha
	WHERE 
	    f.anio = p_anio AND
	    f.mes = p_mes AND
	    f.dia BETWEEN p_dia_desde AND p_dia_hasta
	GROUP BY 
	    Producto
	ORDER BY
		Producto;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_estadisticas_ventas_por_producto_drilldown_locales(
    IN p_anio INTEGER,
    IN p_mes INTEGER,
    IN p_dia_desde INTEGER,
    IN p_dia_hasta INTEGER
)
RETURNS TABLE (
    Producto VARCHAR,
	Nombre_Local VARCHAR,
    Total_Cantidad_Vendida BIGINT,
    Ganancia_Total DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
	SELECT 
	    p.Descripcion AS Producto,
		l.Nombre AS Nombre_Local,
		SUM(vd.Cantidad_Vendida) AS Total_Cantidad_Vendida,
	    SUM(vd.Monto_Venta) AS Ganancia_Total
	FROM 
	    Venta_Diaria vd
	JOIN 
	    Producto p ON vd.Clave_Producto = p.Clave_Producto
	JOIN 
	    Fecha f ON vd.Clave_Fecha = f.Clave_Fecha
	JOIN
    	Local l ON vd.Clave_Local = l.Clave_Local
	WHERE 
	    f.anio = p_anio AND
	    f.mes = p_mes AND
	    f.dia BETWEEN p_dia_desde AND p_dia_hasta
	GROUP BY 
	    Producto, Nombre_Local
	ORDER BY
		Producto;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_ganancias_por_dia(
    IN p_anio INTEGER,
    IN p_mes INTEGER,
    IN p_dia_desde INTEGER,
    IN p_dia_hasta INTEGER
)
RETURNS TABLE (
    Dia INTEGER,
    Mes INTEGER,
    Anio INTEGER,
    Ganancia_Total DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.Dia,
        f.Mes,
        f.Anio,
        SUM(vd.Monto_Venta) AS Ganancia_Total
    FROM 
        Venta_Diaria vd
    JOIN 
        Fecha f ON vd.Clave_Fecha = f.Clave_Fecha
    WHERE 
        f.Anio = p_anio AND
        f.Mes = p_mes AND
        f.Dia BETWEEN p_dia_desde AND p_dia_hasta
    GROUP BY 
        f.Dia, f.Mes, f.Anio
    ORDER BY 
        f.Dia;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_ganancias_por_dia_drilldown_locales(
    IN p_anio INTEGER,
    IN p_mes INTEGER,
    IN p_dia_desde INTEGER,
    IN p_dia_hasta INTEGER
)
RETURNS TABLE (
    Dia INTEGER,
    Mes INTEGER,
    Anio INTEGER,
    Nombre_Local VARCHAR,
    Ganancia_Total DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.Dia,
        f.Mes,
        f.Anio,
        l.Nombre AS Nombre_Local,
        SUM(vd.Monto_Venta) AS Ganancia_Total
    FROM 
        Venta_Diaria vd
    JOIN 
        Fecha f ON vd.Clave_Fecha = f.Clave_Fecha
    JOIN 
        Local l ON vd.Clave_Local = l.Clave_Local
    WHERE 
        f.Anio = p_anio AND
        f.Mes = p_mes AND
        f.Dia BETWEEN p_dia_desde AND p_dia_hasta
    GROUP BY 
        f.Dia, f.Mes, f.Anio, Nombre_Local
    ORDER BY 
        f.Dia, Nombre_Local;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_ganancias_por_dia_drilldown_locales_productos(
    IN p_anio INTEGER,
    IN p_mes INTEGER,
    IN p_dia_desde INTEGER,
    IN p_dia_hasta INTEGER
)
RETURNS TABLE (
    Dia INTEGER,
    Mes INTEGER,
    Anio INTEGER,
    Nombre_Local VARCHAR,
    Producto VARCHAR,
    Ganancia_Total DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.Dia,
        f.Mes,
        f.Anio,
        l.Nombre AS Nombre_Local,
        p.Descripcion AS Producto,
        SUM(vd.Monto_Venta) AS Ganancia_Total
    FROM 
        Venta_Diaria vd
    JOIN 
        Fecha f ON vd.Clave_Fecha = f.Clave_Fecha
    JOIN 
        Local l ON vd.Clave_Local = l.Clave_Local
    JOIN 
        Producto p ON vd.Clave_Producto = p.Clave_Producto
    WHERE 
        f.Anio = p_anio AND
        f.Mes = p_mes AND
        f.Dia BETWEEN p_dia_desde AND p_dia_hasta
    GROUP BY 
        f.Dia, f.Mes, f.Anio, l.Nombre, p.Descripcion
    ORDER BY 
        f.Dia, Nombre_Local, Producto;
END;
$$ LANGUAGE plpgsql;
