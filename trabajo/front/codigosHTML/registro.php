<!-- Codigo del indice de la página -->
<!-- Ubicacion del archivo: file:///Volumes/v.1TB/programacion/PNET/codigosHTML/index.html -->




<!DOCTYPE HTML>
<head>
    <link rel="stylesheet" href="../codigosCSS/registro.css">
    <script src="../codigosJS/registro.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <html lang="es"></html>
    
    <title>Reserva tu camping</title>

    
</head>

<body>

    <?php
        // Create connection to Oracle
        $conn = oci_connect("ADMIN", "Malayo2001puma", "tcps://adb.eu-madrid-1.oraclecloud.com:1522/g0573e2ee8cd1de_u9zlsa4mr7lpwcm3_high.adb.oraclecloud.com?wallet_location=../Wallet_U9ZLSA4MR7LPWCM3");
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
            echo "<div class='mensaje'>Cliente creado correctamente</div>";
        }

        function creaAnunciante($nomUsuario, $nom, $apel1, $apel2, $correo, $telefono, $tarjeta, $empresa){
            global $conn;
            $array = oci_parse($conn, "BEGIN  mipa.creaanunciante('$nomUsuario', '$nom', '$apel1', '$apel2', '$correo', '$telefono', '$tarjeta', '$empresa'); END;");
            oci_execute($array);
            echo "<div class='mensaje'>Anunciante creado correctamente</div>";
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
            $query = "SELECT DISTINCT c.id, r.fechaini AS FechaInicio, r.fechafin AS FechaFin, DEREF(t.column_value).id AS id_camping, tip.nombre AS tipo, sit.nombre AS sitio, sit.comarca AS comarca, DEREF(t.column_value).descripcion AS descripcion, DEREF(t.column_value).servicios AS servicios
            FROM clientes c, TABLE(c.arraycampings) t 
            JOIN sitios sit ON sit.id=DEREF(t.column_value).fksitio
            JOIN tipos tip ON tip.id=DEREF(t.column_value).fktipo
            JOIN reservas r ON DEREF(r.refcamping).id = DEREF(t.column_value).id
            WHERE c.id =:id_Cliente";
                
            $stid=oci_parse($conn, $query);
            oci_bind_by_name($stid, ":id_Cliente", $idCliente);
                oci_execute($stid);
            
                while (($row = oci_fetch_array($stid, OCI_ASSOC)) != false) {
                    echo "<p>Id de reserva: " . $row['ID'] . "</p>";
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

    <header>
        <nav>
            <a  href="index.html">
                <img alt="logo de vivac que representa una V como si fuera una tienda de campaña" src="../recursos/imagenes/logoGrande.png"> 
                <h1 class="titulo">Vivac</h1>
            </a>
        </nav>
    </header>

    <hr>

    <div class="imagenCamping">
        <?php
            if(isset($_POST['botonEnviarCliente']))
            {
                creaCliente(htmlspecialchars($_POST['nomUsuario']), htmlspecialchars($_POST['nome']), htmlspecialchars($_POST['ape1']), htmlspecialchars($_POST['ape2']), htmlspecialchars($_POST['email']), htmlspecialchars($_POST['telf']));
            } 
        ?>

            <form id="Form" method="post">
               <label>Nombre de usuario</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="fechaFormInput" name="nomUsuario">
               
               <div>
                <label>Nombre</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="nombreapellidos" name="nome">
                <label>Primer apellido</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="nombreapellidos" name="ape1"> 
                <label>Segundo apellido</label><input aria-label="Nombre de usuario" type="text" class="inputs"  id="nombreapellidos" name="ape2"> 
               </div>
               
               <label>Correo electronico</label><input aria-label="Correo electronico" type="email" class="inputs" id="horaInicioInput" name="email">
               <label>Telefono</label><input aria-label="Telefono" type="tel" class="inputs" id="horaFinInput" name="telf">

               <div id="checkboxs">
                <label>Cliente</label><input aria-label="Cliente" type="checkbox" class="inputs"  id="checkbox1" name="clien">
                <label>Anunciante</label><input aria-label="Anunciante" type="checkbox" class="inputs"  id="checkbox2" name="anun"> 
               </div>

               <div id="nuevosCampos" style="display: none;">
                <label>Nombre de la empresa</label>
                <input aria-label="Nombre de la empresa" type="text" class="inputs" id="nombreEmpresa" name="nEmp">
                <label>Tarjeta de crédito</label>
                <input aria-label="Tarjeta de crédito" type="text" class="inputs" id="tarjetaCredito" name="tarj">
              </div>
               
               <input class="boton" type="submit" name="botonEnviarCliente" form="Form" value="¡Registrate cliente!">
               <input class="boton" type="submit" name="botonEnviarAnunciante" form="Form" value="¡Registrate anunciante!">
               
            </form>
            
            
            <div id="mensaje-container"></div>

            <script>
                // Inserta el mensaje debajo del formulario
                const mensaje = document.querySelector('.mensaje');
                const mensajeContainer = document.querySelector('#mensaje-container');
                if (mensaje) {
                    mensajeContainer.appendChild(mensaje);
                }
            </script>
  
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