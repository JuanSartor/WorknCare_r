$("#modulo").val("medicos");
$("#submodulo").val("medicos_generica_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=medicos&submodulo=medicos_generica_list&do_reset=1",
    datatype: "json",
    colNames: ['', 'Nombre', 'Especialidad', 'País', 'Nº Identificación', 'N° Celular', 'Email', 'Email Confirmado', 'Validado', "Activo", "Cuenta", 'Alta'],
    colModel: [
        {name: 'act', index: 'act', align: "center", width: 100, hidden: false, sortable: false},
        {name: 'nombre', index: 'nombre', width: 100, sortable: false},
        {name: 'especialidad', index: 'especialidad', align: "left", width: 100, sortable: false},
        {name: 'pais', index: 'pais', width: 50, align: "center", sortable: false},
        {name: 'nro_identificacion', index: 'nro_identificacion', width: 60, align: "center", sortable: false},
        {name: 'numeroCelular', index: 'numeroCelular', width: 60, align: "center", sortable: false},
        {name: 'email', index: 'email', width: 100, align: "center", sortable: false},
        {name: 'estado', index: 'estado', width: 35, align: "center", sortable: false},
        {name: 'validado', index: 'validado', width: 30, align: "center", sortable: false},
        {name: 'active', index: 'active', width: 30, align: "center", sortable: false},
        {name: 'cuenta', index: 'planProfesional', width: 30, align: "center", sortable: false},
        {name: 'fecha_alta_format', index: 'fecha_alta', width: 50, align: "center", sortable: true}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'idmedico',
    viewrecords: true,
    sortorder: "desc",
    caption: "Médicos",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('medicos','medicos_generica_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

            ic = "<a href=\"javascript:;\" title=\"Ver información Comercial\" onclick=\"x_goTo('medicos','medicos_informacion_comercial','idmedico=" + id + "','Main',this)\"><button>Info Comercial</button></a>";


            $("#list").jqGrid('setRowData', ids[i], {act: be + '  ' + ic});
        }
    }
});


//multiselect
/*
$('<a href="javascript:;" title="Desactivar cuenta" style="padding-right: 20px;">Desactivar cuenta</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: '¿Desea desactivar la cuenta de los médicos seleccionados?',
        submodulo: 'deletemultiple_medico_gen'
    });

});
$('<a href="javascript:;" title="Activar cuenta">Activar cuenta</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: '¿Desea activar la cuenta de los médicos seleccionados?',
        submodulo: 'activemultiple_medico'
    });

});*/


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

$("#especialidad_idespecialidad").change(function () {
    updateComboBox(this, 'subEspecialidad_idsubEspecialidad', 'ManagerSubEspecialidades', 'getCombo', 2);
});

//Exportar el listado a CSV
$("#btnExportar").click(function () {
    $("#f_export input").val("");
    $("#nombre_export").val($("#nombre_input").val());
    $("#apellido_export").val($("#apellido_input").val());
    $("#especialidad_idespecialidad_export").val($("#especialidad_idespecialidad option:selected").val());
    $("#subEspecialidad_idsubEspecialidad_export").val($("#subEspecialidad_idsubEspecialidad option:selected").val());
    $("#validado_export").val($("#validado option:selected").val());
    $("#active_export").val($("#active option:selected").val());
    $("#f_export").submit();

})

