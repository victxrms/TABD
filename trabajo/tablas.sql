DROP TYPE tiponombre;

DROP TYPE tipousuario;

DROP TYPE tipocliente;

DROP TYPE tipoanunciante;

DROP TYPE tipocamping;

DROP TYPE tipoarraycliente;

DROP TABLE campings;

DROP TYPE tipoarraycampings;

CREATE TYPE tiponombre AS OBJECT (
        usuario   VARCHAR2(155),
        apellido1 VARCHAR2(10),
        apellido2 VARCHAR2(10)
);
/

CREATE TYPE tipousuario AS OBJECT (
        id       NUMBER,
        usuario  VARCHAR2(10),
        nombre   tiponombre,
        correo   VARCHAR(50),
        telefono NUMBER(9)
) NOT FINAL;
/

CREATE OR REPLACE TYPE tipocamping AS OBJECT (
        id          NUMBER,
        fksitio     NUMBER,
        fktipo      NUMBER,
        status      VARCHAR2(10),
        descripcion VARCHAR2(50),
        capacidad   NUMBER,
        servicios   VARCHAR2(50),
        precio      REAL
);
/

CREATE TYPE tipoarraycampings IS
    TABLE OF REF tipocamping;
/

CREATE TYPE tipoanunciante UNDER tipousuario (
        empresa       VARCHAR2(20),
        tarjetapago   VARCHAR2(20),
        arraycampings tipoarraycampings
);
/

CREATE TYPE tipocliente UNDER tipousuario (
    arraycampings tipoarraycampings
);
/
        
        --CREATE  TYPE TIPOARRAYCLIENTE IS TABLE OF REF TIPOCLIENTE; 


CREATE TABLE sitios (
    id      NUMBER
        GENERATED ALWAYS AS IDENTITY,
    nombre  VARCHAR2(20),
    comarca VARCHAR2(20),
    CONSTRAINT pk_sitio PRIMARY KEY ( id )
);
/

CREATE TABLE tipos (
    id          NUMBER
        GENERATED ALWAYS AS IDENTITY,
    nombre      VARCHAR2(20),
    descripcion VARCHAR2(50),
    CONSTRAINT pk_tipotabla PRIMARY KEY ( id )
);
/

CREATE TABLE campings OF tipocamping;
/

ALTER TABLE campings ADD (
    CONSTRAINT pk_campings PRIMARY KEY ( id ),
    CONSTRAINT fktablasitio FOREIGN KEY ( fksitio )
        REFERENCES sitios ( id ),
    CONSTRAINT fktablatipo FOREIGN KEY ( fktipo )
        REFERENCES tipos ( id )
);
/

CREATE TABLE usuarios OF tipousuario (
    CONSTRAINT pk_usuarios PRIMARY KEY ( id ),
    CONSTRAINT onlyone_usuarios UNIQUE ( usuario )
);
/

CREATE TABLE anunciantes OF tipoanunciante (
    CONSTRAINT pk_anunciante PRIMARY KEY ( id )
)
NESTED TABLE arraycampings STORE AS tablarefcampings;
/

CREATE TABLE clientes OF tipocliente (
    CONSTRAINT pk_cliente PRIMARY KEY ( id )
)
NESTED TABLE arraycampings STORE AS tablacampings;
/

CREATE TABLE anuncios (
    id            NUMBER
        GENERATED ALWAYS AS IDENTITY,
    CONSTRAINT pk_anuncios PRIMARY KEY ( id ),
    refanunciante REF tipoanunciante,
    refcamping    REF tipocamping,
    fechainicio   DATE,
    fechafin      DATE
);
/

CREATE TABLE reservas (
    id              NUMBER
        GENERATED ALWAYS AS IDENTITY,
    CONSTRAINT pk_reservas PRIMARY KEY ( id ),
    refcliente      REF tipocliente,
    refcamping      REF tipocamping,
    numninos        NUMBER,
    numadultos      NUMBER,
    numalojamientos NUMBER,
    fechaini        DATE,
    fechafin        DATE
);
/

CREATE OR REPLACE TRIGGER nuevoanuncio AFTER
    INSERT ON anuncios
    FOR EACH ROW
BEGIN
    INSERT INTO TABLE (
        SELECT
            arraycampings
        FROM
            anunciantes
        WHERE
            id = deref(:new.refanunciante).id
    ) VALUES ( :new.refcamping );

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20999, 'El anunciante no existe');
END;
/

CREATE OR REPLACE TRIGGER nuevareserva BEFORE
    INSERT ON reservas
    FOR EACH ROW
BEGIN
    INSERT INTO TABLE (
        SELECT
            arraycampings
        FROM
            clientes
        WHERE
            id = deref(:new.refcliente).id
    ) VALUES ( :new.refcamping );

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20999, 'El cliente no existe');
END;
/

CREATE OR REPLACE TRIGGER cancelareserva BEFORE
    DELETE ON reservas
    FOR EACH ROW
    WHEN ( old.fechafin > sysdate )
BEGIN
    DELETE FROM TABLE (
        SELECT
            arraycampings
        FROM
            clientes
        WHERE
            clientes.id = deref(:old.refcliente).id
    ) camp
    WHERE
        deref(camp.column_value).id = deref(:old.refcamping).id;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'El cliente no existe');
END;
/
