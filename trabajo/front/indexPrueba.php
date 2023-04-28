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

function creaCliente($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono){
   global $conn;
   $array = oci_parse($conn, "BEGIN  mipa.creacliente('$nomUsuario', '$nom', '$apel1', '$apel2', '$correo', '$telefono'); END;");
   oci_execute($array);
}

function creaAnunciante($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono, $tarjeta, $empresa){
   global $conn;
   $array = oci_parse($conn, "BEGIN  mipa.creaanunciante('$nomUsuario', '$nom', '$apel1', '$apel2', '$correo', '$telefono', '$tarjeta', '$empresa'); END;");
   oci_execute($array);
}

function creaAnuncio($nomUsuario, $fechaIni, $fechaFin, $idcamp)
{
   global $conn;
   $array = oci_parse($conn, "BEGIN  mipa.creaanuncio('$nomUsuario', '$fechaIni', '$fechaFin', '$idcamp'); END;");
   oci_execute($array);
}

function creareserva($nomUsuario, $ninos, $adultos, $alojamientos, $idcamp, $fechaIni, $fechaFin)
{
   global $conn;
   $array = oci_parse($conn, "BEGIN  :result:=mipa.creareserva('$nomUsuario', '$ninos', '$adultos', '$alojamientos', '$idcamp', '$fechaIni', '$fechaFin'); END;");
   oci_bind_by_name($array, ":result", $result, 10);
   oci_execute($array);
   echo "Precio:" . $result;
}

function getReservas($idCliente)
{
	global $conn;
	$query = "SELECT c.id, r.fechaini AS FechaInicio, r.fechafin AS FechaFin, DEREF(t.column_value).id AS id_camping, tip.nombre AS tipo, sit.nombre AS sitio, sit.comarca AS comarca, DEREF(t.column_value).descripcion AS descripcion, DEREF(t.column_value).servicios AS servicios
FROM clientes c, TABLE(c.arraycampings) t 
JOIN sitios sit ON sit.id=DEREF(t.column_value).fksitio
JOIN tipos tip ON tip.id=DEREF(t.column_value).fktipo
JOIN reservas r ON DEREF(r.refcamping).id = DEREF(t.column_value).id
WHERE c.id =:id_Cliente";
	
   $stid=oci_parse($conn, $query);
   oci_bind_by_name($stid, ":id_Cliente", $idCliente);
	oci_execute($stid);


   while (($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS))) {
      echo $row['FECHAINICIO']  ;
	echo $row['ID'];
   }
}

getReservas(3);
//oci_close($conn);
?>