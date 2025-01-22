
x_runJS();


function reload_medicos_prestador() {
    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=medicos_prestador_list&idprestador=" + $("#idprestador").val(),
    datatype: "json",
    colNames: ['', 'Nombre', 'CUIT', 'Email', 'Celular', '', 'Especialidad', 'Estado', ''],
    colModel: [
        {name: 'act', index: 'act', width: 15, hidden: true},
        {name: 'nombre', index: 'nombre', width: 150, sortable: true},
        {name: 'CUIT', index: 'CUIT', width: 150, sortable: true},
        {name: 'email', index: 'email', width: 150, sortable: true},
        {name: 'numeroCelular', index: 'numeroCelular', width: 100, hidden: true},
        {name: 'idmedico', index: 'idmedico', width: 100, hidden: true},
        {name: 'especialidad', index: 'especialidad', width: 100, sortable: true},
        {name: 'estado', index: 'estado', width: 50, align: 'center', sortable: true},
        {name: 'aceptar', index: 'aceptar', width: 15, align: 'center', hidden: false, sortable: false}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",
    page: $("#list_actual_page_2").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {
        var ids = $("#list").jqGrid('getDataIDs');
        for (var i = 0; i < ids.length; i++) {
            var id = ids[i];
            var data = $("#list").jqGrid('getRowData', id);
            if (data.estado == "Pendiente") {
                var ba = "<a href=\"javascript:;\" title=\"Aceptar\" onclick=\"aceptar_medico(" + id + ")\"><img src=\"xframework/app/themes/admin/imgs/action_ico_accept.png\" /></a>";
            } else {
                var ba = "";
            }
            $("#list").jqGrid('setRowData', ids[i], {aceptar: ba});

        }

    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload_medicos_prestador,
        pregunta: 'Desea dar de baja el/los M&eacute;dico/s de este Prestador?',
        modulo: 'prestadores',
        submodulo: 'deletemultiple_medicos_prestador_gen'
    });

});
//cambia el estado de la relacion medico con prestador
var aceptar_medico = function (id) {
    jConfirm(
            "Desea acpetar al profesional seleccionado?",
            "Cambiar estado",
            function (r) {
                if (r) {
                    x_doAjaxCall(
                            "POST",
                            controller + ".php?action=1&modulo=prestadores&submodulo=cambiar_estado_medico_prestador",
                            "id=" + id,
                            function (data) {
                                x_alert(data.msg);
                                if (data.result) {
                                    reload_medicos_prestador();
                                }
                            }
                    )
                }
            }
    );

}


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
$("#back").click(function () {
    x_goTo('prestadores', 'prestadores_form', 'id=' + $("#idprestador").val(), 'Main', this);
});


$("#btnAddMedico").click(function () {
    if ($("#idprestador").val() != "") {
        x_loadWindow(this, 'prestadores', 'medicos_prestador_form_win', 'idprestador=' + $("#idprestador").val(), 800, 800);
    } else {
        x_alert("Debe crear el Prestador antes de agregar m&eacute;dicos");
    }
})



