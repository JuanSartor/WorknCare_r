// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 20, sortable: false, align: 'center'},
        {name: 'programa_salud', index: 'programa_salud', width: 400}

    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'idprograma_salud',
    viewrecords: true,
    sortorder: "asc",
    caption: "Programas de salud",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('programa_salud','programa_salud_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

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



//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({
        ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea eliminar los programas de salud seleccionados?',
        submodulo: 'deletemultiple_programa_salud'
    });

});


$("#btnNew").click(function () {
    x_goTo('programa_salud', 'programa_salud_form', '', 'Main', this);
});


$("#modulo").val("programa_salud");
$("#submodulo").val("programa_salud_list");
x_runJS();

