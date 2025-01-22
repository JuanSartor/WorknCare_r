// JavaScript Document

function reload() {
    $("#listFamilias").jqGrid().trigger("reloadGrid");
}

$("#listFamilias").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 20, sortable: false, align: 'center'},
        {name: 'nombre', index: 'nombre', width: 400}

    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'orden, nombre',
    viewrecords: true,
    sortorder: "asc",
    caption: "Familia de Cuestionarios",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#listFamilias").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('cuestionarios','familia_cuestionario_grupo_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

            $("#listFamilias").jqGrid('setRowData', ids[i], {act: be});
        }
    }

});

$("#btnFilter").click(function () {

    $("#listFamilias").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function () {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda :input");

    $("#listFamilias")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});



//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({
        ids: $("#listFamilias").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea eliminar las familias seleccionadas, eliminara los cuestionarios y preguntas asociadas?',
        submodulo: 'deletemultiple_familia_cuestionario_grupo'
    });

});


$("#btnNew").click(function () {
    x_goTo('cuestionarios', 'familia_cuestionario_grupo_form', '', 'Main', this);
});


$("#modulo").val("cuestionarios");
$("#submodulo").val("familia_cuestionario_grupo_list");
//exportar listado medicos
$("#btnExportar").click(function () {
    $("#f_export").submit();

});
x_runJS();

