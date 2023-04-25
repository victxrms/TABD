<?php
// Create connection to Oracle
$conn = oci_connect("System", "malayo2001", "//localhost:1521/XE");
if (!$conn) {
   $m = oci_error();
   echo $m['message'], "\n";
   exit;
}
else {
   print "Connected to Oracle!";
}
// Liberar recursos

//oci_close($conn);
?>

<?php

function creaCliente($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono){
   $array = oci_parse($conn, "BEGIN  mipa.creacliente($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono); END;");
   oci_execute($array);
}

function creaAnunciante($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono, $tarjeta, $empresa){
   $array = oci_parse($conn, "BEGIN  mipa.creaanunciante($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono, $tarjeta, $empresa); END;");
   oci_execute($array);
}

function creaAnuncio($nomUsuario, $fechaIni, $fechaFin)
{
   $array = oci_parse($conn, "BEGIN  mipa.creaanuncio($nomUsuario, $fechaIni, $fechaFin); END;");
   oci_execute($array);
}

function creareserva($nomUsuario, $ninos, $adultos, $alojamientos, $idcamp, $fechaIni, $fechaFin)
{
   $array = oci_parse($conn, "BEGIN  mipa.creareserva($nomUsuario, $ninos, $adultos, $alojamientos, $idcamp, $fechaIni, $fechaFin); END;");
   oci_bind_by_name($array, ":result", $result, 10);
   oci_execute($array);
   echo "Precio:" . $result;
}

function getReservas($idCliente)
{

    $query = 'SELECT c.id, s.nombre AS sitio_nombre, s.comarca, t.nombre 
    AS tipo_nombre, t.descripcion AS tipo_descripcion, c.status, 
    c.descripcion, c.capacidad, c.servicios, c.precio 
         FROM clientes cl JOIN TABLE(cl.arraycampings) ac 
            ON 1=1 
               JOIN campings c 
               ON ac.id = c.id JOIN sitios s 
               ON c.fksitio = s.id JOIN tipos t 
               ON c.fktipo = t.id 
         WHERE cl.id = :id';
    $stid = oci_parse($conn, $query);

    oci_bind_by_name($stid, ':id', $id);

    oci_execute($stid);

    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        echo "<h4>" . $row['ID'] . "</h4>";
        echo "<p>Sitio: " . $row['SITIO_NOMBRE'] . "</p>";
        echo "<p>Comarca: " . $row['COMARCA'] . "</p>";
        echo "<p>Tipo: " . $row['TIPO_NOMBRE'] . "</p>";
        echo "<p>Descripcion del tipo: " . $row['TIPO_DESCRIPCION'] . "</p>";
        echo "<p>Status: " . $row['STATUS'] . "</p>";
        echo "<p>Descripcion: " . $row['DESCRIPCION'] . "</p>";
        echo "<p>Capacidad: " . $row['CAPACIDAD'] . "</p>";
        echo "<p>Servicios: " . $row['SERVICIOS'] . "</p>";
        echo "<p>Precio: " . $row['PRECIO'] . "</p>";
    }

    oci_free_statement($stid);
    oci_close($conn);

}





?>
