CREATE OR REPLACE TRIGGER nuevoanuncio AFTER
    INSERT ON anuncios
    FOR EACH ROW
BEGIN
    INSERT INTO TABLE (
        SELECT
            arraycampings
        FROM
            anunciantes anun
        WHERE
            anun.id = deref(:new.refanunciante).id)
    SELECT REF(camp)
    FROM campings camp
    WHERE camp.id = deref(:new.refcamping).id;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20999, 'El anunciante no existe');
END;
/

DROP TRIGGER nuevareserva;

CREATE OR REPLACE TRIGGER nuevareserva AFTER
    INSERT ON reservas
    FOR EACH ROW
BEGIN
    INSERT INTO TABLE (
        SELECT
            arraycampings
        FROM
            clientes cli
        WHERE
            cli.id = deref(:new.refcliente).id)
    SELECT REF(camp)
    FROM campings camp
    WHERE camp.id = deref(:new.refcamping).id;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20999, 'El cliente no existe');
END;
/


/*
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
        camp.column_value.id = deref(:old.refcamping).id;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'El cliente no existe');
END;
/

*/