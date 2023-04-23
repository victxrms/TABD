

    DROP TYPE TIPONOMBRE;
    DROP TYPE TIPOUSUARIO;
    DROP TYPE TIPOCLIENTE;
    DROP TYPE TIPOANUNCIANTE;
    DROP TYPE TIPOCAMPING;
    DROP TYPE TIPOARRAYCLIENTE;
    DROP TABLE CAMPINGS;
    DROP TYPE TIPOARRAYCAMPINGS;

            
    CREATE TYPE TIPONOMBRE AS OBJECT(
    
    
            usuario VARCHAR2(155),
            apellido1 VARCHAR2(10),
            apellido2 VARCHAR2(10)
        );
        /
    
    CREATE  TYPE TIPOUSUARIO AS OBJECT (
            id NUMBER,
            usuario VARCHAR2(10),
            nombre TIPONOMBRE,
            correo VARCHAR(50),
            telefono NUMBER(9)
        )NOT FINAL;
    /
    
    
    
    CREATE OR REPLACE TYPE TIPOCAMPING AS OBJECT(
            id NUMBER,
            fkSitio NUMBER,
            fkTipo NUMBER,
            status VARCHAR2(10),
            descripcion VARCHAR2(50),
            capacidad NUMBER,
            servicios VARCHAR2(50),
            precio REAL    
        );
     /
    
    CREATE  TYPE TIPOARRAYCAMPINGS IS TABLE OF REF TIPOCAMPING;
    /
    
    CREATE TYPE TIPOANUNCIANTE UNDER TIPOUSUARIO(
    
            empresa VARCHAR2(20),
            tarjetaPago VARCHAR2(20),
            arrayCampings TIPOARRAYCAMPINGS
        );
     /   
    CREATE  TYPE TIPOCLIENTE UNDER TIPOUSUARIO(
            arrayCampings TIPOARRAYCAMPINGS
        );
        /
    
    --CREATE  TYPE TIPOARRAYCLIENTE IS TABLE OF REF TIPOCLIENTE; 
         
    
    
    CREATE TABLE SITIO (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            nombre VARCHAR2(20),
            comarca VARCHAR2(20),
            CONSTRAINT PK_SITIO PRIMARY KEY(id)
        );
        /
    
    
    CREATE TABLE TIPO (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            nombre VARCHAR2(20),
            descripcion VARCHAR2(50),
            CONSTRAINT PK_TIPOTABLA PRIMARY KEY (id)
        );
      /
      
      
     CREATE TABLE CAMPINGS OF TIPOCAMPING;
     /
 
    ALTER TABLE CAMPINGS ADD(
            CONSTRAINT PK_CAMPINGS PRIMARY KEY (id),
            CONSTRAINT fkTablaSitio FOREIGN KEY (fkSitio) REFERENCES SITIO(id),
            CONSTRAINT fkTablaTipo FOREIGN KEY (fkTipo) REFERENCES TIPO(id)
        );
       /
       
    CREATE TABLE USUARIOS OF TIPOUSUARIO(
            CONSTRAINT PK_USUARIOS PRIMARY KEY (id),
            CONSTRAINT ONLYONE_USUARIOS UNIQUE (usuario)
        );
       /
    CREATE TABLE ANUNCIANTE OF TIPOANUNCIANTE(
            CONSTRAINT PK_ANUNCIANTE PRIMARY KEY (id)
        ) NESTED TABLE arrayCampings STORE AS tablaRefCampings;
        /
    CREATE TABLE CLIENTE OF TIPOCLIENTE(
            CONSTRAINT PK_CLIENTE PRIMARY KEY (id)
        ) NESTED TABLE arrayCampings STORE AS tablaCampings;
        /
    CREATE TABLE ANUNCIOS (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_ANUNCIOS PRIMARY KEY (id),
            refAnunciante REF TIPOANUNCIANTE,
            refCamping REF TIPOCAMPING,
            fechaInicio DATE,
            fechaFin DATE
        );
        /
        
        CREATE TABLE RESERVAS (
            id NUMBER GENERATED ALWAYS AS IDENTITY,
            CONSTRAINT PK_RESERVAS PRIMARY KEY (id),
            refCliente REF TIPOCLIENTE,
            refCamping REF TIPOCAMPING,
            numNinos NUMBER,
            numAdultos NUMBER,
            numAlojamientos NUMBER,
            fechaIni DATE,
            fechaFin DATE
        );
         /   


