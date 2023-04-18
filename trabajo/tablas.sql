BEGIN

    CREATE OR REPLACE TYPE TIPOARRAYCLIENTE IS TABLE OF REF TIPOCLIENTE;       
    CREATE OR REPLACE TYPE TIPOARRAYCAMPINGS IS TABLE OF REF TIPOCAMPINGS;

    CREATE OR REPLACE TYPE TIPOCAMPING AS OBJECT(
            fkSitio NUMBER,
            fkTipo NUMBER,
            status VARCHAR2(10),
            descripcion VARCHAR2(50),
            capacidad NUMBER,
            servicios VARCHAR(50),
            precio REAL,
            arrayClientes TIPOARRAYCLIENTE        
        );
            
    CREATE OR REPLACE TYPE TIPONOMBRE AS OBJECT(
            usuario VARCHAR2(155),
            apellido1 VARCHAR2(10),
            apellido2 VARCHAR2(10)
        );
    
    CREATE OR REPLACE TYPE TIPOUSUARIO AS OBJECT (
            usuario VARCHAR2(10),
            nombre TIPONOMBRE,
            correo VARCHAR(50),
            telefono NUMBER(9)
        )NOT FINAL;
        
    CREATE OR REPLACE  TYPE TIPOANUNCIANTE UNDER TIPOUSUARIO AS OBJECT(
            empresa VARCHAR2(20),
            tarjetaPago VARCHAR(20),
            arrayCampings TIPOARRAYCAMPINGS
        );
        
    CREATE OR REPLACE TYPE TIPOCLIENTE UNDER TIPOUSUARIO AS OBJECT(
            arrayCampings TIPOARRAYCAMPINGS
        );

    
    CREATE TABLE SITIO (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            nombre VARCHAR2(20),
            comarca VARCHAR2(20),
            CONSTRAINT PK_SITIO PRIMARY KEY(id)
        );
        
    CREATE TABLE TIPO (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            nombre VARCHAR2(20),
            descripcion VARCHAR2(50),
            CONSTRAINT PK_TIPO PRIMARY KEY (id)
        );
      
    CREATE TABLE CAMPINGS OF TIPOCAMPINGS (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_CAMPINGS PRIMARY KEY (id),
            CONSTRAINT fkTablaSitio FOREIGN KEY (fkSitio) REFERENCES SITIO(id),
            CONSTRAINT fkTablaTipo FOREIGN KEY (fkTipo) REFERENCES TIPO(id)
        ) NESTED TABLE arrayClientes STORE AS tablaRefClientes;
       
    CREATE TABLE USUARIOS OF TIPOUSUARIO(
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_USUARIOS PRIMARY KEY (id),
            CONSTRAINT ONLYONE_USUARIOS UNIQUE (usuario)
        );
       
    CREATE TABLE ANUNCIANTE OF TIPOANUNCIANTE(
            CONSTRAINT PK_ANUNCIANTE PRIMARY KEY (id)
        ) NESTED TABLE arrayCampings STORE AS tablaRefCampings;
        
    CREATE TABLE CLIENTE OF TIPOCLIENTE(
            CONSTRAINT PK_CLIENTE PRIMARY KEY (id)
        ) NESTED TABLE arrayCampings STORE AS tablaCampings;
        
        
    CREATE TABLE ANUNCIOS (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_ANUNCIOS PRIMARY KEY (id),
            refAnunciante REF TIPOANUNCIANTE,
            refCamping REF TIPOCAMPINGS,
            fechaInicio DATE,
            fechaFin DATE
        );
        
        CREATE TABLE RESERVAS (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_RESERVAS PRIMARY KEY (id),
            refCliente REF TIPOCLIENTE,
            refCamping REF TIPOCAMPINGS,
            numNinos NUMBER,
            numAdultos NUMBER,
            numAlojamientos NUMBER,
            fechaIni NUMBER,
            fechaFin NUMBER
        );
            


END;