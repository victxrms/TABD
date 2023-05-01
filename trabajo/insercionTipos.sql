INSERT INTO TIPOS (nombre, descripcion) VALUES ('Pernocta', 'Solo para dormir');
INSERT INTO TIPOS (nombre, descripcion) VALUES ('Zona recreativa', 'Para pasar el dia con tus amigos');
INSERT INTO TIPOS (nombre, descripcion) VALUES ('Zona de acampada', 'Permite pasar mas de 5 dias');
INSERT INTO TIPOS (nombre, descripcion) VALUES ('Centro Scout Mundial', 'Alberga scouts de todo el mundo');
INSERT INTO TIPOS (nombre, descripcion) VALUES ('Centro Scout', 'Alberga scouts de toda España');

INSERT INTO SITIOS (nombre, comarca) VALUES ('Cerromulera', 'Sierra de Cadiz');
INSERT INTO SITIOS (nombre, comarca) VALUES ('Kandersteg', 'Bern');
INSERT INTO SITIOS (nombre, comarca) VALUES ('Griebal', 'La Ribagorza');
INSERT INTO SITIOS (nombre, comarca) VALUES ('Bermejales', 'Alhama');

INSERT INTO CAMPINGS (id, fksitio, fktipo, status, descripcion, capacidad, servicios, precio) VALUES (1, 1, 2, 'Privado', 'Hace mucho calor pero te divertiras', 120, 'Ducha, piscina, cocina completa', 5);
INSERT INTO CAMPINGS (id, fksitio, fktipo, status, descripcion, capacidad, servicios, precio) VALUES (2, 2, 4, 'Privado', 'Crearas recuerdos inolvidables', 700, 'Duchas, Piscina, Catering, Rutas, Montañismo', 25);
INSERT INTO CAMPINGS (id, fksitio, fktipo, status, descripcion, capacidad, servicios, precio) VALUES (3, 3, 3, 'Publico', 'Conoceras gente increible', 500, 'Duchas, Piscina, Catering, Zonas de acampada', 15);
INSERT INTO CAMPINGS (id, fksitio, fktipo, status, descripcion, capacidad, servicios, precio) VALUES (4, 4, 5, 'Publico', 'Estaras con gente de toda España', 200, 'Duchas, Piscina, Cocina equipada, Lagos', 5);

INSERT INTO CLIENTES (id, usuario, nombre, correo, telefono, arraycampings) VALUES (id_usuario.nextval, 'victxrms', TIPONOMBRE('Victor', 'Moreno', 'Sola'), 'vmoso2002@gmail.com', 655464789, TIPOARRAYCAMPINGS());
INSERT INTO CLIENTES (id, usuario, nombre, correo, telefono, arraycampings) VALUES (id_usuario.nextval, 'kBasilisk', TIPONOMBRE('Alejandro', 'Jimenez', 'Garcia'), 'kbasliskelmejor@gmail.com', 643569874, TIPOARRAYCAMPINGS());

INSERT INTO ANUNCIANTES (id, usuario, nombre, correo, telefono, empresa, tarjetapago, arraycampings) VALUES (id_usuario.nextval, 'riojano', TIPONOMBRE('Charles', 'River', 'Ha'), 'funnyrivercharles@gmail.com', 64098781, 'ucaCoin', '31231045', TIPOARRAYCAMPINGS() );
