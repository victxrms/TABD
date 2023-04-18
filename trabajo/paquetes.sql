CREATE OR REPLACE PACKAGE MIPA AS

    PROCEDURE creaUsuario (nomUsuario VARCHAR2(20) IN, nombre VARCHAR2(20) IN, apellido1 VARCHAR2(20) IN, apellido2 VARCHAR2(20) IN, correo VARCHAR2(20) IN, telefono NUMBER IN);
    PROCEDURE creaCliente (nomUsuario VARCHAR2(20) IN);
    PROCEDURE creaAnunciante (nomUsuario VARCHAR2(20) IN, NUMBER tarjeta IN, VARCHAR2(20) empresa IN);

    PROCEDURE creaAnuncio(nomUsuario VARCHAR2(20) IN, costo REAL IN, fecha DATE IN);
    FUNCTION creaReserva(nomUsuario VARCHAR2(20) IN, nNinos NUMBER IN, nAdultos NUMBER IN, nAlojamientos NUMBER IN) RETURNS REAL;

    PROCEDURE eliminaReserva(nomUsuario VARCHAR2(20) IN, nombreCamping VARCHAR2(20) IN, fechaReserva DATE IN);

    
END MIPA;

CREATE OR REPLACE PACKAGE BODY MIPA AS 

    PROCEDURE creaUsuario (nomUsuario VARCHAR2(20) IN, nombre VARCHAR2(20) IN, apellido1 VARCHAR2(20) IN, apellido2 VARCHAR2(20) IN, correo VARCHAR2(20) IN, telefono NUMBER IN) IS

    BEGIN 

    END;

END MIPA;