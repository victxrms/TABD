document.addEventListener('DOMContentLoaded', function() {
    const checkbox1 = document.getElementById("checkbox1");
    const checkbox2 = document.getElementById("checkbox2");
    var nuevosCampos = document.getElementById('nuevosCampos');

    checkbox2.addEventListener('change', function() {
        if (checkbox2.checked) {
        nuevosCampos.style.display = 'block';
        botonAnunciante.style.display = "block";
        botonCliente.style.display = 'none';
        } else {
        nuevosCampos.style.display = 'none';
        botonAnunciante.style.display = 'none';
        }
    });


    checkbox1.addEventListener('change', function() {
        if (checkbox1.checked) {
        nuevosCampos.style.display = 'none';
        botonCliente.style.display = "block";
        botonAnunciante.style.display = 'none';
        } else {
        nuevosCampos.style.display = 'none';
        botonCliente.style.display = 'none';
        }
    });
    
    checkbox1.onclick = () => {
      if (checkbox1.checked) {
        checkbox2.checked = false;
      }
    };
    
    checkbox2.onclick = () => {
      if (checkbox2.checked) {
        checkbox1.checked = false;
      }
    };
  });

