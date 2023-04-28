document.addEventListener('DOMContentLoaded', function() {
    const checkbox1 = document.getElementById("checkbox1");
    var nuevosCampos = document.getElementById('nuevosCampos');

    checkbox1.addEventListener('change', function() {
        if (checkbox1.checked) {
        nuevosCampos.style = 'display: flex; justify-content: space-around; align-items: center; flex-direction: column; ';
        
        } else {
        nuevosCampos.style.display = 'none';
        }
    });
    
  });

