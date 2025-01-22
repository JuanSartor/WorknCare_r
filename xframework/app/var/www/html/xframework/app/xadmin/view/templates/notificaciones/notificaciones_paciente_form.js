x_runJS();
$("#modulo").val("notificaciones");
$("#submodulo").val("notificaciones_paciente_form");

$("#btnGuardar").click(function () {

    var ids = $("#list").jqGrid('getGridParam', 'selarrrow');

    if (ids.length > 0 || $("#idnotificacionSistema").val() != "") {
        $("#ids").val(ids);

        x_sendForm(
                $('#f_record'),
                true,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('notificaciones', 'notificaciones_paciente_list', '', 'Main')
                    }
                }
        );
    } else {
        x_alert("No ha seleccionado pacientes para enviar la notificación");
    }
});

$("#back").click(function () {
    x_goTo('notificaciones', 'notificaciones_paciente_list', '', 'Main', this);
});



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Nombre', 'Apellido', 'Email', 'N° Celular'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: true, sortable: false},
        {name: 'email', index: 'nombre', width: 100, sortable: false},
        {name: 'nombre', index: 'nombre', width: 100, sortable: false},
        {name: 'apellido', index: 'nombre', width: 100, sortable: false},
        {name: 'numeroCelular', index: 'numeroCelular', width: 50, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'email',
    viewrecords: true,
    sortorder: "asc",
    caption: "Pacientes a notificar",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('notificaciones','notificaciones_paciente_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


$("#btnFilter").click(function () {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function () {
    $("#f_busqueda").clearForm();

    //actualizo uniform
    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});