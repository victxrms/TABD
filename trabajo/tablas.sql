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

    CREATE TABLE ANUNCIANTES OF TIPOANUNCIANTE(
            CONSTRAINT PK_ANUNCIANTE PRIMARY KEY (id)
        ) NESTED TABLE arrayCampings STORE AS tablaRefCampings;
        /

    CREATE TABLE CLIENTES OF TIPOCLIENTE(
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

        CREATE OR REPLACE TRIGGER NUEVOANUNCIO
            BEFORE INSERT ON ANUNCIOS 
            FOR EACH ROW 
        BEGIN
            INSERT INTO ANUNCIANTES(refCamping)
            SELECT NEW.refCamping
            FROM ANUNCIANTES
            WHERE ANUNCIANTES.id = DEREF(NEW.refAnunciante).id;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                raise_application_error(-20999,'El anunciante no existe');
        END;
        /

        CREATE OR REPLACE TRIGGER NUEVARESERVA
            BEFORE INSERT ON RESERVAS 
            FOR EACH ROW 
        BEGIN
            INSERT INTO CLIENTES(refCamping)
            SELECT NEW.refCamping
            FROM CLIENTES
            WHERE CLIENTES.id = DEREF(NEW.refCliente).id;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                raise_application_error(-20999,'El cliente no existe');
        END;
        /

        CREATE OR REPLACE TRIGGER CANCELARESERVA
            before DELETE ON RESERVAS 
            FOR EACH ROW 
            WHEN (OLD.fechaFin > SYSDATE)
        BEGIN
            DELETE FROM CLIENTES
            WHERE OLD.DEREF(refCliente).id = id;
            
            -- Eliminar referencia del camping en el array de campings del cliente
            DECLARE
                v_index PLS_INTEGER;
            BEGIN
                v_index := NULL;
                FOR i IN 1..arrayCampings.COUNT LOOP
                    IF arrayCampings(i) IS NOT NULL AND arrayCampings(i).id = OLD.DEREF(refCamping).id THEN
                        v_index := i;
                        EXIT;
                    END IF;
                END LOOP;
                IF v_index IS NOT NULL THEN
                    arrayCampings.DELETE(v_index);
                END IF;
            END;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe');
        END;
        /

