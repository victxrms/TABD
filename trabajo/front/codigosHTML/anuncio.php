<!-- Codigo del indice de la página -->
<!-- Ubicacion del archivo: file:///Volumes/v.1TB/programacion/PNET/codigosHTML/index.html -->

<?php
        // Create connection to Oracle
        $conn = oci_connect("ADMIN", "Malayo2001puma", "tcps://adb.eu-madrid-1.oraclecloud.com:1522/g0573e2ee8cd1de_u9zlsa4mr7lpwcm3_high.adb.oraclecloud.com?wallet_location=../Wallet_U9ZLSA4MR7LPWCM3");
            
        // Liberar recursos

        function creaAnuncio($nomUsuario, $fechaIni, $fechaFin, $idcamp)
        {
            global $conn;
            $array = oci_parse($conn, "BEGIN  mipa.creaanuncio('$nomUsuario', '$fechaIni', '$fechaFin', '$idcamp'); END;");
            oci_execute($array);
            echo "<div class='mensaje'>Anunciado creado con exito.</div>";
        }
    ?>



<!DOCTYPE HTML>
<head>
    <link rel="stylesheet" href="../codigosCSS/reserva.css">
    <script src="../codigosJS/reserva.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <html lang="es"></html>
    <title>Reserva tu camping</title>
</head>

<body>
        <?php
            if(isset($_POST['enviaAnuncio']))
            {
                creaAnuncio(htmlspecialchars($_POST['nombreUsuario']), htmlspecialchars($_POST['fIni']), htmlspecialchars($_POST['fFin']), htmlspecialchars($_POST['nombreCamping']));
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
        <img alt="imagen del sitio" src="../recursos/imagenesSitios/fotoCampingNum1.jpg">

        <aside>
            

            <form id="Form">
                <label>Usuario</label><input aria-label="Nombre de usuario" type="text"  class="inputHorFech"  id="fechaFormInput" name="nombreUsuario">
                
                <label>Nombre de campings</label>
                    <select id="campingsName" name="nombreCamping" class="inputHorFech">
                        <option value="0">Selecciona un camping</option>
                        <option value="1">Cerromulera</option>
                        <option value="2">Kandersteg</option>
                        <option value="3">Griebal</option>
                        <option value="4">Bermejales</option>
                    </select>
                
                <label>Fecha Inicio</label><input aria-label="Fecha" type="date" class="inputHorFech"  id="fechaFormInput" name="fIni">

                <label>Fecha Fin</label><input aria-label="Fecha" type="date" class="inputHorFech"  id="fechaFormInput" name="fFin">
                
             </form>
            
            
            
            <input class="boton" type="submit" form="Form" value="¡Reserva ya!" name="enviaAnuncio">

            <div id="mensaje-container"></div>

            <script>
                // Inserta el mensaje debajo del formulario
                const mensaje = document.querySelector('.mensaje');
                const mensajeContainer = document.querySelector('#mensaje-container');
                if (mensaje) {
                    mensajeContainer.appendChild(mensaje);
                }
            </script>
        </aside>
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