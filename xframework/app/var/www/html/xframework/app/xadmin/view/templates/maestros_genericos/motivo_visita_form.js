x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'maestros_genericos', 'submodulo': 'motivo_visita_list'});

});

$("#back").click(function () {
    x_goTo('maestros_genericos', 'motivo_visita_list', '', 'Main', this);
});


$("#agregar_especialidad").click(function () {
    if ($("#especialidad_idespecialidad").val() == "") {
        x_alert("Seleccione especialidad");
        return false;
    }
    //verificamos si ya existe
       var idespecialidad = $("#especialidad_idespecialidad").val();
    if ($("#listado_especialidades li[data-especialidad='"+idespecialidad+"']").length > 0) {
        x_alert("Ya se ha agregado esta especialidad");
        return false;
    }
    var nombre_especialidad = $("#especialidad_idespecialidad option:selected").text();
 
    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivovisita_especialidad_add&especialidad_idespecialidad=" + $("#especialidad_idespecialidad").val() + "&motivoVisita_idmotivoVisita=" + $("#idmotivoVisita").val();

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //agregar especialidad
                    $("#listado_especialidades").show();
                    $("#listado_especialidades ul").append($('<li data-id="' + data.id + '" data-especialidad="' + idespecialidad + '" class="especialidad"><span class="delete_especialidad" data-id="' + data.id + '" title="Eliminar"> X </span> ' + nombre_especialidad + '</li>'));

                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});

$("#listado_especialidades").on("click", ".delete_especialidad", function () {
    if ($(this).data("id") == "") {
        x_alert("Error");
        return false;
    }
    var id = $(this).data("id");

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivovisita_especialidad_delete&id=" + id;

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //eliminar especialidad
                    $("li.especialidad[data-id='" + id + "']").remove();
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});
