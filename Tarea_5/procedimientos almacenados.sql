
--creaci�n de proceso de agregar libro
CREATE PROCEDURE AgregarLibro --proceso para agregar libro
    @Titulo NVARCHAR(100),
    @Autor NVARCHAR(100),
    @Ano_Publicacion INT  
AS
BEGIN
    INSERT INTO Libros (Titulo, Autor, A�o_Publicacion)  
    VALUES (@Titulo, @Autor, @Ano_Publicacion);
END;

CREATE PROCEDURE ActualizarLibro --proceso para actualizar un libro
    @ID_Libro INT,
    @Titulo NVARCHAR(100) = NULL,
    @Autor NVARCHAR(100) = NULL,
    @A�o_Publicacion INT = NULL
AS
BEGIN
    UPDATE Libros
    SET 
        Titulo = COALESCE(@Titulo, Titulo),
        Autor = COALESCE(@Autor, Autor),
        A�o_Publicacion = COALESCE(@A�o_Publicacion, A�o_Publicacion)
    WHERE ID_Libro = @ID_Libro;
END;

CREATE PROCEDURE ConsultarLibrosDisponibles --proceso para consulta de libros
AS
BEGIN
    SELECT * FROM Libros
    WHERE Disponibilidad = 1;
END;

CREATE PROCEDURE EliminarLibro
    @ID_Libro INT
AS
BEGIN
    DELETE FROM Libros
    WHERE ID_Libro = @ID_Libro;
END;

CREATE PROCEDURE RegistrarMiembro
    @Nombre NVARCHAR(100),
    @Direccion NVARCHAR(100),
    @Telefono INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Miembros (Nombre, Direccion, Tel�fono)
        VALUES (@Nombre, @Direccion, @Telefono);
    END TRY
    BEGIN CATCH
        PRINT 'Error: El n�mero de tel�fono ya est� registrado.';
    END CATCH;
END;

CREATE PROCEDURE ActualizarMiembro
    @ID_Miembro INT,
    @Nombre NVARCHAR(100) = NULL,
    @Direccion NVARCHAR(100) = NULL,
    @Telefono INT = NULL
AS
BEGIN
    UPDATE Miembros
    SET 
        Nombre = COALESCE(@Nombre, Nombre),
        Direccion = COALESCE(@Direccion, Direccion),
        Tel�fono = COALESCE(@Telefono, Tel�fono)
    WHERE ID_Miembro = @ID_Miembro;
END;

CREATE PROCEDURE EliminarMiembro
    @ID_Miembro INT
AS
BEGIN
    DELETE FROM Miembros
    WHERE ID_Miembro = @ID_Miembro;
END;



CREATE PROCEDURE RegistrarPrestamo
    @ID_Libro INT,
    @ID_Miembro INT,
    @Fecha_Devolucion DATETIME
AS
BEGIN
    -- Verificar disponibilidad del libro
    IF EXISTS (SELECT 1 FROM Libros WHERE ID_Libro = @ID_Libro AND Disponibilidad = 1)
    BEGIN
        -- Registrar el pr�stamo
        INSERT INTO Prestamos (ID_Libro, ID_Miembro, Fecha_Devolucion)
        VALUES (@ID_Libro, @ID_Miembro, @Fecha_Devolucion);
        
        -- Actualizar la disponibilidad del libro a no disponible (0)
        UPDATE Libros
        SET Disponibilidad = 0
        WHERE ID_Libro = @ID_Libro;
    END
    ELSE
    BEGIN
        PRINT 'Error: El libro no est� disponible.';
    END
END;

CREATE PROCEDURE ActualizarPrestamo
    @ID_Prestamo INT,
    @ID_Libro INT = NULL,
    @ID_Miembro INT = NULL,
    @Fecha_Devolucion DATETIME = NULL
AS
BEGIN
    UPDATE Prestamos
    SET 
        ID_Libro = COALESCE(@ID_Libro, ID_Libro),
        ID_Miembro = COALESCE(@ID_Miembro, ID_Miembro),
        Fecha_Devolucion = COALESCE(@Fecha_Devolucion, Fecha_Devolucion)
    WHERE ID_Prestamo = @ID_Prestamo;
END;


CREATE PROCEDURE DevolverLibro
    @ID_Libro INT,
    @ID_Prestamo INT
AS
BEGIN
    -- Marcar la devoluci�n del pr�stamo
    UPDATE Prestamos
    SET Fecha_Devolucion = GETDATE()
    WHERE ID_Prestamo = @ID_Prestamo;

    -- Actualizar la disponibilidad del libro a disponible (1)
    UPDATE Libros
    SET Disponibilidad = 1
    WHERE ID_Libro = @ID_Libro;
END;

EXEC AgregarLibro 'El Principito', 'Antoine de Saint-Exup�ry', 1943;

EXEC RegistrarMiembro 'Juan P�rez', 'San Juan 123', 12345678;

EXEC RegistrarPrestamo 1, 1, '2024-10-01';



select * from Prestamos
