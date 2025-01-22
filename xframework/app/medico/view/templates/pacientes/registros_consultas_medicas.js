    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-consulta").parent().addClass("active");
     x_loadModule('perfil_salud', 'mis_registros_pacientes', 'mis_registros_consultas_medicas=1&do_reset=1&idpaciente=' + $("#idpaciente").val(), 'div_mis_registros_paciente', BASE_PATH + "medico");





