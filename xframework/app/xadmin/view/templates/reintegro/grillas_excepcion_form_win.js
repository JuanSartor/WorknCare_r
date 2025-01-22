
$("#back_hs").click(function () {
    hs.close();
});

$("#btnGuardarExcepcion").click(function () {

    if ($("#especialidad_idespecialidad").val() == "") {
        x_alert("Seleccione una especialidad");
        return false;
    }
    if ($("#excepcion_codigo_input").val() == "") {
        x_alert("Complete el código");
        return false;
    }
    if ($("#excepcion_sector1").val() == 1 && $("#excepcion_valor_sector1_input").val() == "") {
        x_alert("Complete tarifa de Sector 1");
        return false;
    }
    if ($("#excepcion_sector2").val() == 1 && $("#excepcion_valor_sector2_input").val() == "") {
        x_alert("Complete tarifa de Sector 2");
        return false;
    }
    if ($("#excepcion_optam").val() == 1 && $("#excepcion_valor_optam_input").val() == "") {
        x_alert("Complete tarifa de Optam");
        return false;
    }
    
    $("#grilla_idgrilla").val($("#idgrilla").val());
    x_sendForm(
            $('#f_record_excepcion'),
            true,
            function (data) {
                x_alert(data.msg);
                if (data.result) {
                    reload() 
                    hs.close();

                }
            }
    );

});


$("#excepcion_sector1").change(function () {
    if ($("#excepcion_sector1 option:selected").val() == 1) {
        $("#div_excepcion_condicion_sector1").show();
        $("#div_excepcion_tarifa_sector1").show();
    } else {
        $("#div_excepcion_condicion_sector1").hide();
        $("#div_excepcion_tarifa_sector1").hide();
        $("#excepcion_valor_sector1_input").val("");
    }
})


$("#excepcion_sector2").change(function () {
    if ($("#excepcion_sector2 option:selected").val() == 1) {
        $("#div_excepcion_condicion_sector2").show();
        $("#div_excepcion_tarifa_sector2").show();
    } else {
        $("#div_excepcion_condicion_sector2").hide();
        $("#div_excepcion_tarifa_sector2").hide();
        $("#excepcion_valor_sector2_input").val("");
    }
})


$("#excepcion_optam").change(function () {
    if ($("#excepcion_optam option:selected").val() == 1) {
        $("#div_excepcion_condicion_optam").show();
        $("#div_excepcion_tarifa_optam").show();
    } else {
        $("#div_excepcion_condicion_optam").hide();
        $("#div_excepcion_tarifa_optam").hide();
        $("#excepcion_valor_optam_input").val("");
    }
})
