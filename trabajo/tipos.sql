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