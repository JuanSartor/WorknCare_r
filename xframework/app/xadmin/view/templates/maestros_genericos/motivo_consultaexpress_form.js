x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'maestros_genericos', 'submodulo': 'motivo_consultaexpress_list'});

});

$("#back").click(function () {
    x_goTo('maestros_genericos', 'motivo_consultaexpress_list', '', 'Main', this);
});



$("#agregar_especialidad").click(function () {
    if ($("#especialidad_idespecialidad").val() == "") {
        x_alert("Seleccione especialidad");
        return false;
    }
    //verificamos si ya existe
    var idespecialidad = $("#especialidad_idespecialidad").val();
    if ($("#listado_especialidades li[data-especialidad='" + idespecialidad + "']").length > 0) {
        x_alert("Ya se ha agregado esta especialidad");
        return false;
    }
    var nombre_especialidad = $("#especialidad_idespecialidad option:selected").text();

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivoconsultaexpress_especialidad_add&especialidad_idespecialidad=" + $("#especialidad_idespecialidad").val() + "&motivoConsultaExpress_idmotivoConsultaExpress=" + $("#idmotivoConsultaExpress").val();

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
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivoconsultaexpress_especialidad_delete&id=" + id;

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

$("#listado_programas_categorias").on("click", ".delete_programa_categoria", function () {
    if ($(this).data("id") == "") {
        x_alert("Error");
        return false;
    }
    var id = $(this).data("id");

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivoconsultaexpress_programa_categoria_delete&id=" + id;

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //eliminar especialidad
                    $("li.programa_categoria[data-id='" + id + "']").remove();
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});

$("#agregar_programa_categoria").click(function () {
    if ($("#idprograma_categoria").val() == "") {
        x_alert("Seleccione un programa");
        return false;
    }
    //verificamos si ya existe
    var idprograma_categoria = $("#idprograma_categoria").val();
    if ($("#listado_programas_categorias li[data-programa_categoria='" + idprograma_categoria + "']").length > 0) {
        x_alert("Ya se ha agregado este programa");
        return false;
    }
    var nombre_programa_categoria = $("#idprograma_categoria option:selected").text();

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_genericos&submodulo=motivoconsultaexpress_programa_categoria_add&idprograma_categoria=" + $("#idprograma_categoria").val() + "&motivoConsultaExpress_idmotivoConsultaExpress=" + $("#idmotivoConsultaExpress").val();

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //agregar especialidad
                    $("#listado_programas_categorias").show();
                    $("#listado_programas_categorias ul").append($('<li data-id="' + data.id + '" data-programa_categoria="' + idprograma_categoria + '" class="programa_categoria"><span class="delete_programa_categoria" data-id="' + data.id + '" title="Eliminar"> X </span> ' + nombre_programa_categoria + '</li>'));

                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});
