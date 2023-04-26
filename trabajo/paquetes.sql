SET SERVEROUTPUT ON
select r.fechaini, r.fechafin from reservas r where deref(r.refcliente).id=3;
select c.id,t.nombre, s.nombre, s.comarca from tipos t JOIN campings c on c.fktipo=t.id JOIN sitios s on s.id=c.fksitio; 
SELECT * FROM (select arraycampings from clientes where clientes.id=3);

 
CREATE SEQUENCE id_usuario INCREMENT BY 1 START WITH 1 NOCACHE;

CREATE OR REPLACE PACKAGE mipa AS
    PROCEDURE creacliente (
        nomusuario IN VARCHAR2,
        nombre     IN VARCHAR2,
        apellido1  IN VARCHAR2,
        apellido2  IN VARCHAR2,
        correo     IN VARCHAR2,
        telefono   IN NUMBER
    );

    PROCEDURE creaanunciante (
        nomusuario IN VARCHAR2,
        nombre     IN VARCHAR2,
        apellido1  IN VARCHAR2,
        apellido2  IN VARCHAR2,
        correo     IN VARCHAR2,
        telefono   IN NUMBER,
        tarjeta    IN VARCHAR2,
        empresa    IN VARCHAR2
    );

    PROCEDURE creaanuncio (
        nomusuario IN VARCHAR2,
        fechain    IN DATE,
        fechafin   IN DATE,
        id_camp    IN NUMBER
    );
    
   
    
    FUNCTION creareserva (
        nomusuario    IN VARCHAR2,
        nninos        IN NUMBER,
        nadultos      IN NUMBER,
        nalojamientos IN NUMBER,
        id_camp       IN NUMBER,
        fechain       IN DATE,
        fechafin      IN DATE
    ) RETURN NUMBER;

    PROCEDURE eliminareserva (
        nomusuario IN VARCHAR2,
        id_camp    IN NUMBER
    );

END mipa;
/

CREATE OR REPLACE PACKAGE BODY mipa AS

    PROCEDURE creacliente (
        nomusuario IN VARCHAR2,
        nombre     IN VARCHAR2,
        apellido1  IN VARCHAR2,
        apellido2  IN VARCHAR2,
        correo     IN VARCHAR2,
        telefono   IN NUMBER
    ) AS
    BEGIN
        INSERT INTO usuarios (
            id,
            usuario,
            nombre,
            correo,
            telefono
        ) VALUES (
            id_usuario.NEXTVAL,
            nomusuario,
            tiponombre(nombre, apellido1, apellido2),
            correo,
            telefono
        );

        INSERT INTO clientes (
            id,
            usuario,
            nombre,
            correo,
            telefono,
            arrayCampings
        ) VALUES (
            id_usuario.currval,
            nomusuario,
            tiponombre(nombre, apellido1, apellido2),
            correo,
            telefono,
            tipoarraycampings()
        );

    EXCEPTION
        WHEN dup_val_on_index THEN
            raise_application_error(-20303, 'Esta cogido');
        WHEN others THEN
            raise_application_error(-20500, 'que me cago');
    END creacliente;

    PROCEDURE creaanunciante (
        nomusuario IN VARCHAR2,
        nombre     IN VARCHAR2,
        apellido1  IN VARCHAR2,
        apellido2  IN VARCHAR2,
        correo     IN VARCHAR2,
        telefono   IN NUMBER,
        tarjeta    IN VARCHAR2,
        empresa    IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO usuarios (
            id,
            usuario,    
            nombre,
            correo,
            telefono
        ) VALUES (
            id_usuario.NEXTVAL,
            nomusuario,
            tiponombre(nombre, apellido1, apellido2),
            correo,
            telefono
        );

        INSERT INTO anunciantes (
            id,
            usuario,
            nombre,
            correo,
            telefono,
            empresa,
            tarjetapago,
            arrayCampings
        ) VALUES (
            id_usuario.currval,
            nomusuario,
            tiponombre(nombre, apellido1, apellido2),
            correo,
            telefono,
            empresa,
            tarjeta,
            tipoarraycampings()
        );

    EXCEPTION
        WHEN dup_val_on_index THEN
            raise_application_error(-20303, 'Esta cogido');
        WHEN others THEN
            raise_application_error(-20500, 'me cago!!');
    END creaanunciante;

    PROCEDURE creaanuncio (
        nomusuario IN VARCHAR2,
        fechain    IN DATE,
        fechafin   IN DATE,
        id_camp IN NUMBER
    ) AS
        anun_ref    REF tipoanunciante;
        camping_ref REF tipocamping;
    BEGIN
        --un switch o algo
        SELECT
            ref(anun)
        INTO anun_ref
        FROM
            anunciantes anun
        WHERE
            anun.usuario = nomusuario;

        SELECT
            ref(camp)
        INTO camping_ref
        FROM
            campings camp
        WHERE
            camp.id = id_camp;

        INSERT INTO anuncios (
            refanunciante,
            refcamping,
            fechainicio,
            fechafin
        ) VALUES (
            anun_ref,
            camping_ref,
            fechain,
            fechafin
        );

    END creaanuncio;

    PROCEDURE eliminareserva (
        nomusuario IN VARCHAR2,
        id_camp    IN NUMBER
    ) AS
    BEGIN
        DELETE FROM reservas
        WHERE
            ( deref(reservas.refcliente).usuario = nomusuario
              AND deref(reservas.refcamping).id = id_camp );

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(404, 'Datos no encontrados');
        WHEN OTHERS THEN
            raise_application_error(-20500, 'me cago');
    END eliminareserva;

    
    


    FUNCTION creareserva (
        nomusuario    IN VARCHAR2,
        nninos        IN NUMBER,
        nadultos      IN NUMBER,
        nalojamientos IN NUMBER,
        id_camp       IN NUMBER,
        fechain       IN DATE,
        fechafin      IN DATE
    ) RETURN NUMBER IS

        preciofinal   NUMBER;
        cliente_ref   REF tipocliente;
        camping_ref   REF tipocamping;
        --numero_dias   INTERVAL DAY TO SECOND := fechafin - fechain;
        dias          NUMBER;
        preciocamping NUMBER;
    BEGIN
        SELECT
            ref(cli)
        INTO cliente_ref
        FROM
            clientes cli
        WHERE
            cli.usuario = nomusuario;

        SELECT
            ref(camp)
        INTO camping_ref
        FROM
            campings camp
        WHERE
            camp.id = id_camp;

        INSERT INTO reservas (
            refcliente,
            refcamping,
            numninos,
            numadultos,
            numalojamientos,
            fechaini,
            fechafin
        ) VALUES (
            cliente_ref,
            camping_ref,
            nninos,
            nadultos,
            nalojamientos,
            fechain,
            fechafin
        );

        SELECT
            camp.precio
        INTO preciocamping
        FROM
            campings camp
        WHERE
            camp.id = id_camp;

        dias := trunc(fechafin-fechain);
    
        preciofinal := ( ( preciocamping * 0.5 * nninos + preciocamping * nadultos ) * nalojamientos ) * ( dias );

        RETURN preciofinal;
    END;

END mipa;
/

DECLARE
CURSOR mickey IS
SELECT * FROM (select arraycampings from clientes where clientes.id=3) ;

BEGIN
    for i in 1..mickey.count loop
     dbms_output.put_line(mickey(i));
     end loop;

    --mipa.creacliente('Alemale', 'Alejandro', 'Jimenez', 'Garcia','aleelmaquina@gmail.es' ,'12345678');
    --mipa.creaanunciante('KBasilisk', 'Alejandro', 'Jimenez', 'Garcia','aleelmaquina@gmail.es' ,'12345678',1234567,'VIVAC entertaiment');
    --mipa.creaanuncio('KBasilisk', '27-MAR-2023', '28-MAR-2023', 1);
    --DBMS_output.put_line('PRECIO:'|| mipa.creareserva('Tupu', 2, 2, 2, 1, '27-MAY-2023', '28-MAY-2023'));
    --mipa.eliminareserva('Alemale',1);
     --cursoralgo:=mipa.getreservas(3);
     
     
END;
/
