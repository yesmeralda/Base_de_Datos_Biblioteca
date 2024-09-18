CREATE PROCEDURE ReporteLibrosPrestados
AS
BEGIN
    SELECT 
        L.ID_Libro,
        L.Titulo,
        L.Autor,
        L.A�o_Publicacion,
        CASE 
            WHEN P.ID_Libro IS NOT NULL THEN 'Prestado'
            ELSE 'Disponible'
        END AS Estado
    FROM Libros L
    LEFT JOIN Prestamos P
    ON L.ID_Libro = P.ID_Libro
    AND P.Fecha_Devolucion IS NULL
    ORDER BY L.Titulo;
END;

CREATE PROCEDURE LibrosMasSolicitadosUltimoMes
AS
BEGIN
    SELECT 
        L.ID_Libro,
        L.Titulo,
        L.Autor,
        L.A�o_Publicacion,
        COUNT(P.ID_Prestamo) AS Numero_De_Prestamos
    FROM Libros L
    JOIN Prestamos P
    ON L.ID_Libro = P.ID_Libro
    WHERE P.Fecha_Prestamo >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY L.ID_Libro, L.Titulo, L.Autor, L.A�o_Publicacion
    ORDER BY Numero_De_Prestamos DESC;
END;


CREATE PROCEDURE MiembrosConMasPrestamosActivos
AS
BEGIN
    SELECT 
        M.ID_Miembro,
        M.Nombre,
        M.Direccion,
        M.Tel�fono,
        COUNT(P.ID_Prestamo) AS Numero_De_Prestamos_Activos
    FROM Miembros M
    JOIN Prestamos P
    ON M.ID_Miembro = P.ID_Miembro
    WHERE P.Fecha_Devolucion IS NULL
    GROUP BY M.ID_Miembro, M.Nombre, M.Direccion, M.Tel�fono
    ORDER BY Numero_De_Prestamos_Activos DESC;
END;


CREATE PROCEDURE LibrosNoPrestadosUltimoAno
AS
BEGIN
    SELECT 
        L.ID_Libro,
        L.Titulo,
        L.Autor,
        L.A�o_Publicacion
    FROM Libros L
    LEFT JOIN Prestamos P
    ON L.ID_Libro = P.ID_Libro
    AND P.Fecha_Prestamo >= DATEADD(YEAR, -1, GETDATE())
    WHERE P.ID_Prestamo IS NULL
    ORDER BY L.Titulo;
END;

-- Obtener el reporte de los libros prestados y su estado
EXEC ReporteLibrosPrestados;

-- Listar los libros m�s solicitados en el �ltimo mes
EXEC LibrosMasSolicitadosUltimoMes;

-- Consultar miembros con m�s pr�stamos activos
EXEC MiembrosConMasPrestamosActivos;

-- Identificar libros que no han sido prestados en el �ltimo a�o
EXEC LibrosNoPrestadosUltimoAno;





