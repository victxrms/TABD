<!-- Codigo del indice de la página -->
<!-- Ubicacion del archivo: file:///Volumes/v.1TB/programacion/PNET/codigosHTML/index.html -->


<?php
        // Create connection to Oracle
        $conn = oci_connect("ADMIN", "Malayo2001puma", "tcps://adb.eu-madrid-1.oraclecloud.com:1522/g0573e2ee8cd1de_u9zlsa4mr7lpwcm3_high.adb.oraclecloud.com?wallet_location=../Wallet_U9ZLSA4MR7LPWCM3");
        // Liberar recursos

        function eliminaReservas($cliente, $idCamping)
        {
            global $conn;
            $array = oci_parse($conn, "BEGIN  mipa.eliminareserva('$cliente', '$idCamping'); END;");
            oci_execute($array);
            echo "<div class='mensaje'>Reservas eliminadas correctamente</div>";
        }

        function getReservas($idCliente)
        {
            global $conn;
            $query = "SELECT DISTINCT cl.usuario,  r.fechaini AS FechaInicio, r.fechafin AS FechaFin, c.id AS id_camping, t.nombre AS tipo, s.nombre AS sitio, s.comarca AS comarca, c.descripcion AS descripcion, c.servicios AS servicios        
            FROM reservas r
            JOIN clientes cl ON REF(cl) = r.refcliente
            JOIN campings c ON REF(c) = r.refcamping
            JOIN sitios s ON s.id = c.fksitio
            JOIN tipos t ON t.id = c.fktipo
            WHERE cl.usuario =:id_Cliente";

                
            $stid=oci_parse($conn, $query);
            oci_bind_by_name($stid, ":id_Cliente", $idCliente);
                oci_execute($stid);

                while (($row = oci_fetch_array($stid, OCI_ASSOC)) != false) {
                    echo "<div>
                <p> <b>Nombre del camping: </b> " . $row['SITIO'] . "</p>
                <p> <b>Id del camping: </b> " . $row['ID_CAMPING'] . "</p>
                <p> <b>Fecha de inicio: </b> " . $row['FECHAINICIO'] . "</p>
                <p> <b>Fecha de fin: </b>" . $row['FECHAFIN'] . "</p>
                <p> <b>Tipo de camping: </b>" . $row['TIPO'] . "</p>
                <p> <b>Comarca del camping: </b>" . $row['COMARCA'] . "</p>
                <p> <b>Descripción del camping: </b>" . $row['DESCRIPCION'] . "</p>
                <p> <b>Servicios del camping: </b>" . $row['SERVICIOS'] . "</p>
                <hr style='height: 1px; background-color: black; border: none; margin: 10px 0;'>
                        </div>"  ;  

                    
                }
        }
    ?>

<!DOCTYPE HTML>
<head>
    <link rel="stylesheet" href="./codigosCSS/consulta.css">
    <script src="./codigosJS/consultas.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <html lang="es"></html>
    
    
    <title>Reserva tu camping</title>
</head>

<body>
    
    <header>
        <nav>
            <a  href="index.html">
                <img alt="logo de vivac que representa una V como si fuera una tienda de campaña" src="./recursos/imagenes/logoGrande.png"> 
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
                    getReservas(htmlspecialchars($_POST['cliente']));
                } 

                if(isset($_POST['borrarReserva']))
                {
                    echo "<script>document.getElementById('datosReservas').style.display = 'none';</script>";
                    eliminaReservas(htmlspecialchars($_POST['clienteBorrar']), htmlspecialchars($_POST['idCamping']));
                } 
            ?>

            <form id="Form" method="post">
               <label>Nombre de usuario</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="fechaFormInput" name="cliente">
               <input class="boton" type="submit" name="enviarConsulta" form="Form" value="¡Consulta tus reservas!">
               
               <div id="checkboxs">
                <label>ELIMINAR RESERVA</label><input aria-label="Cliente" type="checkbox" class="inputs"  id="checkbox1" name="clien">
               </div>

                <div id="nuevosCampos" style="display: none;">
                <label>Nombre de usuario</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="fechaFormInput" name="clienteBorrar">
                <label>Id del camping</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="fechaFormInput" name="idCamping">
                
                <input class="boton" type="submit" id="botonBorrar" name="borrarReserva" form="Form" value="¡Elimina las reservas de este camping!">
                
                </div>  

            </form>  

            
  
        </div>

    </div>

    

    

    <footer>
        <div id="footerUp">
            <a class="textoLogo" href="./codigosHTML/index.html"><img alt="logo de vivac que representa una V como si fuera una tienda de campaña" src="./recursos/imagenes/logoGrande.png">Vivac &copy;</a>
            
            <img alt="logo de descarga de AppStore" class="downloadButton" src="./recursos/imagenes/appstore.png">
            <img alt="logo de descarga de PlayStore" class="downloadButton" src="./recursos/imagenes/googleplay.png">
            
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
