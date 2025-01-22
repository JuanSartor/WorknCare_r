$(document).ready(function () {
    renderUI2("Main");

    x_loadModule('cuenta', 'detalle_periodo', "idperiodoPago=" + $("#idperiodoPago").val(), 'cont_periodo');

});




$("#p_pagos").click(function () {
    //Llamar aa módulo de pagos
    $("#p_pagos").hide();
    $("#p_periodos").show();
    x_loadModule('cuenta', 'pagos', "do_reset=1&idperiodoPago=" + $("#idperiodoPago").val(), 'cont_periodo');

});
$("#p_periodos").click(function () {
    //Llamar aa módulo de detalle de ultimo período
    $("#p_periodos").hide();
    $("#p_pagos").show();
    x_loadModule('cuenta', 'detalle_periodo', "idperiodoPago=" + $("#idPeriodoActual").val(), 'cont_periodo');

});

$("#select_periodo").change(function () {
    if ($("#select_periodo").val() != "") {
        $("#p_periodos").hide();
        $("#p_pagos").show();
        //Si cambia el período cambio la pantalla...
        x_loadModule('cuenta', 'detalle_periodo', "idperiodoPago=" + $("#select_periodo").val(), 'cont_periodo');

        //Cambio el valor del Input Oculto
        $("#idperiodoPago").val($("#select_periodo").val());
    }
});

