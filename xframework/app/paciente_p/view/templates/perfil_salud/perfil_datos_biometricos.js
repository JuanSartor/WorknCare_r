x_runJS();

$(document).ready(function() {
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-male").parent().addClass("active");
    
    x_loadModule('perfil_salud', 'modulo_presion_arterial', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_presion_arterial", BASE_PATH + "paciente_p");
    x_loadModule('perfil_salud', 'modulo_miscelaneas', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_miscelaneas", BASE_PATH + "paciente_p");
    
    x_loadModule('perfil_salud', 'modulo_colesterol', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_colesterol", BASE_PATH + "paciente_p");
    
    x_loadModule('perfil_salud', 'modulo_glucemia', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_glucemia", BASE_PATH + "paciente_p");
    

    
    x_loadModule('perfil_salud', 'modulo_masa_corporal', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_masa_corporal", BASE_PATH + "paciente_p");
    
});



