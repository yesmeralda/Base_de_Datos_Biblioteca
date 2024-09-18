create database tarea5;
use tarea5;

-- creaci�n de tabla libros, la disponibilidad tendra un valor por default de disponible(true)
create table Libros(
ID_Libro int primary key identity, 
Titulo nvarchar(100) not null,
Autor nvarchar(100) not null,
A�o_Publicacion int not null,
--ISBN, 
Disponibilidad bit not null default(1)
);

-- creaci�n de tabla miembros, la fecha e registro tendr� como valor por defecto la fecha actual
-- y el n�mero de tel�fono tendra un valor �nico
create table Miembros(
ID_Miembro int primary key identity,
Nombre nvarchar(100) not null, 
Direccion nvarchar(100) not null,
Tel�fono int unique not null,
Fecha_Registro datetime not null default(getdate())
);

-- Creaci�n de tabla miembros, tendra dos llaves foraneas (libro y miembro) y la fecha del prestamo por 
-- default ser� la fecha actual.
create table Prestamos(
ID_Prestamo int primary key identity,
ID_Libro int references Libros(ID_Libro),
ID_Miembro int references Miembros(Id_Miembro),
Fecha_Prestamo datetime not null default(getdate()), 
Fecha_Devolucion datetime not null
);

