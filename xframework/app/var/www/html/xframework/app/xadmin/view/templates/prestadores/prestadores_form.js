x_runJS();
$("#modulo").val("prestadores");
$("#submodulo").val("prestadores_form");

$("#cuit_input").inputmask("99-99999999-9");
if ($("#descuento_input").val() != "") {
    $("#div_configurar_valores").hide();
    $("#div_descuento").show();
} else {
    $("#div_configurar_valores").show();
    $("#div_descuento").hide();
}
$("#costos_servicios_yes").change(function () {

    if ($("#costos_servicios_yes").is(":checked")) {
        $("#div_configurar_valores").hide();
        $("#div_descuento").show();
    }
})

$("#costos_servicios_no").change(function () {
    if ($("#costos_servicios_no").is(":checked")) {
        $("#div_configurar_valores").show();
        $("#div_descuento").hide();
    }
})

$("#btnGuardar").click(function () {

    if ($("#nombre_input").val() == "") {
        x_alert("Ingrese nombre del prestador");
        return;
    }


if ($("#descuento_input").val() == ""&&$("#costos_servicios_yes").is(":checked")) {
    x_alert("Ingrese el procentaje de descuento en los servicios");
        return;
}

    x_sendForm($('#f_record'), true, function (data) {
        x_alert(data.msg);
        if (data.result) {
            $("#idprestador").val(data.id);

        }
    });

});

$("#back").click(function () {
    x_goTo('prestadores', 'prestadores_list', '', 'Main', this);
});

$("#btnListadoMedicos").click(function () {
    if($("#idprestador").val()!=""){
    x_goTo('prestadores', 'medicos_prestador_list', 'idprestador=' + $("#idprestador").val(), 'Main', this);
}else{
    x_alert("Debe crear el Prestador antes de agregar m&eacute;dicos");
}
    
});
$("#btnListadoPacientes").click(function () {
    if($("#idprestador").val()!=""){
    x_goTo('prestadores', 'pacientes_prestador_list', 'idprestador=' + $("#idprestador").val(), 'Main', this);
}else{
    x_alert("Debe crear el Prestador antes de agregar pacientes");
}
    
});
x_loadModule('prestadores', 'planes_prestador_list', 'idprestador=' + $("#idprestador").val(), 'div_listado_planes_prestador');
x_loadModule('prestadores', 'usuarios_prestador_list', 'idprestador=' + $("#idprestador").val(), 'div_listado_usuarios_prestador');


