x_runJS();

$(document).ready(function() {
      $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-male").parent().addClass("active");
    
  x_loadModule('perfil_salud', 'modulo_presion_arterial', 'print='+$("#print").val()+'&idpaciente=' + $("#paciente_idpaciente").val(), "div_presion_arterial", BASE_PATH + "medico");
    
    x_loadModule('perfil_salud', 'modulo_colesterol', 'print='+$("#print").val()+'&idpaciente=' + $("#paciente_idpaciente").val(), "div_colesterol", BASE_PATH + "medico");
    
   x_loadModule('perfil_salud', 'modulo_glucemia', 'print='+$("#print").val()+'&idpaciente=' + $("#paciente_idpaciente").val(), "div_glucemia", BASE_PATH + "medico");
    
    x_loadModule('perfil_salud', 'modulo_miscelaneas', 'print='+$("#print").val()+'&idpaciente=' + $("#paciente_idpaciente").val(), "div_miscelaneas", BASE_PATH + "medico");
    
  x_loadModule('perfil_salud', 'modulo_masa_corporal', 'print='+$("#print").val()+'&idpaciente=' + $("#paciente_idpaciente").val(), "div_masa_corporal", BASE_PATH + "medico");
    
});



