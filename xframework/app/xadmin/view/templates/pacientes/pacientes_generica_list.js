$("#modulo").val("medicos");
$("#submodulo").val("medicos_generica_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=pacientes&submodulo=pacientes_generica_list",
    datatype: "json",
    colNames: ['', 'Nombre', 'Pais', 'Trabaja otro país', 'Sexo', 'N° Celular', 'Email', 'Alta', 'Email confirmado', 'Estado'],
    colModel: [
        {name: 'act', index: 'act', width: 70, hidden: false, sortable: false, align: "center"},
        {name: 'nombre', index: 'nombre', width: 150, sortable: true},
        {name: 'pais', index: 'pais', width: 70, sortable: true},
        {name: 'trabaja_luxemburgo', index: 'trabaja_luxemburgo', width: 70, sortable: true, align: "center"},
        {name: 'sexo', index: 'sexo', align: "center", width: 70, sortable: true},
        {name: 'numeroCelular', index: 'numeroCelular', width: 100, align: "center", sortable: true},
        {name: 'email', index: 'email', width: 100, align: "center", sortable: true},
        {name: 'fecha_alta_format', index: 'fecha_alta', width: 100, align: "center", sortable: true},
        {name: 'mail_confirmado', index: 'mail_confirmado', align: "center", width: 100, sortable: true},
        {name: 'activo', index: 'activo', align: "center", width: 100, sortable: true}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'fecha_alta',
    viewrecords: true,
    sortorder: "desc",
    caption: "Pacientes",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('pacientes','pacientes_generica_form','id=" + id + "','Main',this)\"><button> Editar</button></a>";


            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect
/*
 $('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {
 
 x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
 callback: reload,
 pregunta: 'Desea dar de baja el/los Pacientes/s',
 modulo: 'pacientes',
 submodulo: 'deletemultiple_paciente_gen'
 });
 
 });
 */

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



//Exportar el listado a CSV
$("#btnExportar").click(function () {
    $("#f_export input").val("");
    $("#nombre_export").val($("#nombre_input").val());
    $("#apellido_export").val($("#apellido_input").val());
    $("#DNI_export").val($("#DNI_input").val());
    $("#sexo_export").val($("#sexo option:selected").val());

    $("#f_export").submit();

})
