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

// Preparar la consulta
$array = oci_parse($conn, "BEGIN  :result:=mipa.creareserva('Alemale', 1, 1, 1, 1, '05-MAR-2023', '07-MAR-2023'); END;");
oci_bind_by_name($array, ":result", $result, 10);
oci_execute($array);
echo "Precio:" . $result;

// Liberar recursos

oci_close($conn);
?>
