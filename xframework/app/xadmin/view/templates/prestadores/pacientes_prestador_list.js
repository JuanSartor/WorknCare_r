
x_runJS();


function reload_pacientes_prestador() {
    $("#list_paciente").jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=1&" + $("#f_busqueda_paciente").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=0&" + $("#f_busqueda_paciente").serialize(), page: 1});
}

$("#list_paciente").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=pacientes_prestador_list&idprestador=" + $("#idprestador").val(),
    datatype: "json",
    colNames: ['', 'Nombre', 'DNI', 'Paciente titular', 'Email', 'Plan','Nro. afiliado','Suscripción desde','Suscripción hasta', '', 'Perfil de Salud'],
    colModel: [
        {name: 'act', index: 'act', width: 150, hidden: true},
        {name: 'nombre', index: 'nombre', width: 150, sortable: true},
        {name: 'DNI', index: 'DNI', width: 50, sortable: true},
        {name: 'titular', index: 'titular', width: 150, sortable: true},
        {name: 'email', index: 'email', width: 150, sortable: true},
        {name: 'plan', index: 'plan', width: 80, sortable: true},
        {name: 'nro_afiliado', index: 'nro_afiliado', width: 80,align: 'right', sortable: true},
        {name: 'suscripcion_desde_format', index: 'suscripcion_desde', width: 60,align: 'center', sortable: true},
        {name: 'suscripcion_hasta_format', index: 'suscripcion_hasta', width: 60,align: 'center', sortable: true},
        {name: 'idpaciente', index: 'idpaciente', hidden: true},
        {name: 'perfil_salud_completo', width: 100, align: "center", hidden: false, sortable: false}


    ],
    rowNum: 50,
    pager: '#pager_paciente',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",
    page: $("#list_actual_page_4").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list_paciente").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            var data = $("#list_paciente").jqGrid('getRowData', id);
            if (data.perfil_salud_completo == 1) {
                var bps = "Completo";

            } else {
                var bps = "Incompleto";
            }
            $("#list_paciente").jqGrid('setRowData', ids[i], {perfil_salud_completo: bps});

        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_paciente_left").click(function () {

    x_deleteMultiple({ids: $("#list_paciente").jqGrid('getGridParam', 'selarrrow'),
        callback: reload_pacientes_prestador,
        pregunta: 'Desea dar de baja el/los Paciente/s de este Prestador?',
        modulo: 'prestadores',
        submodulo: 'deletemultiple_pacientes_prestador_gen'
    });

});

//multiselect de cambiar planes

$('&nbsp;&nbsp;&nbsp;<a href="javascript:;" title="Cambiar plan">Cambiar plan</a>').appendTo("#pager_paciente_left").click(function () {

    if ($("#list_paciente").jqGrid('getGridParam', 'selarrrow') == "") {
        x_alert("Seleccione al menos un paciente");
        return false;
    }else{
            x_loadWindow(this, 'prestadores', 'cambiar_plan_pacientes_form_win', 'idprestador=' + $("#idprestador").val(), 800, 200);
    }

});


$("#btnFilter").click(function () {

    $("#list_paciente").jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=1&" + $("#f_busqueda_paciente").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=0&" + $("#f_busqueda_paciente").serialize(), page: 1});
});

$("#btnLimpiar").click(function () {

    $("#f_busqueda_paciente").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda_paciente :input");

    $("#list_paciente")
            .jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=1&" + $("#f_busqueda_paciente").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_paciente").attr("action") + "&do_reset=0&" + $("#f_busqueda_paciente").serialize(), page: 1});
});
$("#back").click(function () {
   x_goTo('prestadores','prestadores_form','id='+$("#idprestador").val(),'Main',this);
});

$("#btnAddPaciente").click(function () {
    if ($("#idprestador").val() != "") {
        x_loadWindow(this, 'prestadores', 'pacientes_prestador_form_win', 'idprestador=' + $("#idprestador").val(), 800, 800);
    } else {
        x_alert("Debe crear el Prestador antes de agregar pacientes");
    }
})



