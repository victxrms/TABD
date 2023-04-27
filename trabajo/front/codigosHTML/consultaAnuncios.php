<!-- Codigo del indice de la página -->
<!-- Ubicacion del archivo: file:///Volumes/v.1TB/programacion/PNET/codigosHTML/index.html -->


<?php
        // Create connection to Oracle
        $conn = oci_connect("ADMIN", "Malayo2001puma", "tcps://adb.eu-madrid-1.oraclecloud.com:1522/g0573e2ee8cd1de_u9zlsa4mr7lpwcm3_high.adb.oraclecloud.com?wallet_location=../Wallet_U9ZLSA4MR7LPWCM3");
        // Liberar recursos

        function getAnuncios($idAnunciante)
        {
            global $conn;
            $query = "SELECT DISTINCT a.usuario,  an.fechainicio AS FechaInicio, an.fechafin AS FechaFin, DEREF(t.column_value).id AS id_camping, tip.nombre AS tipo, sit.nombre AS sitio, sit.comarca AS comarca, DEREF(t.column_value).descripcion AS descripcion, DEREF(t.column_value).servicios AS servicios
            FROM anunciantes a, TABLE(a.arraycampings) t 
            JOIN sitios sit ON sit.id=DEREF(t.column_value).fksitio
            JOIN tipos tip ON tip.id=DEREF(t.column_value).fktipo
            JOIN anuncios an ON DEREF(an.refcamping).id = DEREF(t.column_value).id
            WHERE a.usuario =:id_Anunciante";
                
            $stid=oci_parse($conn, $query);
            oci_bind_by_name($stid, ":id_Anunciante", $idAnunciante);
                oci_execute($stid);

                
            
                while (($row = oci_fetch_array($stid, OCI_ASSOC)) != false) {
                    echo "<p>Id del camping: " . $row['ID_CAMPING'] . "</p>";
                    echo "<p>Fecha de inicio: " . $row['FECHAINICIO'] . "</p>";
                    echo "<p>Fecha de fin: " . $row['FECHAFIN'] . "</p>";
                    echo "<p>Tipo de camping: " . $row['TIPO'] . "</p>";
                    echo "<p>Nombre del camping: " . $row['SITIO'] . "</p>";
                    echo "<p>Comarca del camping: " . $row['COMARCA'] . "</p>";
                    echo "<p>Descripción del camping: " . $row['DESCRIPCION'] . "</p>";
                    echo "<p>Servicios del camping: " . $row['SERVICIOS'] . "</p>";
                    echo "<hr>";
                }
        }
    ?>

<!DOCTYPE HTML>
<head>
    <link rel="stylesheet" href="../codigosCSS/consulta.css">
    <script src="../codigosJS/registro.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <html lang="es"></html>
    
    <title>Reserva tu camping</title>
</head>

<body>
    
    <header>
        <nav>
            <a  href="index.html">
                <img alt="logo de vivac que representa una V como si fuera una tienda de campaña" src="../recursos/imagenes/logoGrande.png"> 
                <h1 class="titulo">Vivac</h1>
            </a>
        </nav>
    </header>

    <hr>

    <div id="datos">

        <div class="imagenCamping">

            <?php
                if(isset($_POST['enviarConsulta']))
                {
                    echo "<script>document.getElementById('datosReservas').style.display = 'none';</script>";
                    getAnuncios(htmlspecialchars($_POST['anunciante']));
                } 
            ?>

            <form id="Form" method="post">
               <label>Nombre de usuario</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="fechaFormInput" name="anunciante">
               <input class="boton" type="submit" name="enviarConsulta" form="Form" value="¡Consulta tus datos!">
               
            </form>  
  
        </div>

    

    

    <footer>
        <div id="footerUp">
            <a class="textoLogo" href="../codigosHTML/index.html"><img alt="logo de vivac que representa una V como si fuera una tienda de campaña" src="../recursos/imagenes/logoGrande.png">Vivac &copy;</a>
            
            <img alt="logo de descarga de AppStore" class="downloadButton" src="../recursos/imagenes/appstore.png">
            <img alt="logo de descarga de PlayStore" class="downloadButton" src="../recursos/imagenes/googleplay.png">
            
        </div>
        <hr>
        <nav id="footerBottom">
            <ul>
                <li><a href="./reserva.php">Acampa</a></li>
                <li><a href="./anuncio.php">Anunciate</a></li>
                <li><a href="./registro.php">Registrate</a></li>
                <li><a href="./consultaReservas.php">Consulta tus reservas</a></li>
                <li><a href="./consultaAnuncios.php">Consulta tus anuncios</a></li>
            </ul>
                
        </nav>
        
    </footer>
</body>


</html>