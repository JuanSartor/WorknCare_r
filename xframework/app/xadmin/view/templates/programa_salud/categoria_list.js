// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 10, sortable: false, align: 'center'},
        {name: 'programa_categoria', index: 'programa_categoria', width: 150}

    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'orden ASC, programa_categoria',
    viewrecords: true,
    sortorder: "asc",
    caption: "Categorías",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('programa_salud','categoria_form','id=" + id + "&idprograma_salud=" + $("#idprograma_salud").val() + "','Main',this)\"><button>Editar</button></a>";

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
        pregunta: 'Desea eliminar las categorias seleccionadas?',
        submodulo: 'deletemultiple_categoria'
    });

});


$("#btnNew").click(function () {
    x_goTo('programa_salud', 'categoria_form', 'idprograma_salud=' + $("#idprograma_salud").val(), 'Main', this);

});


$("#modulo").val("programa_salud");
$("#submodulo").val("categorias_list");
x_runJS();

