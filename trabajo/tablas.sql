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


