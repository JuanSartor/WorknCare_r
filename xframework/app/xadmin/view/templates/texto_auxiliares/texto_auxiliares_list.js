// JavaScript Document

function reload() {
    $("#listFamilias").jqGrid().trigger("reloadGrid");
}

$("#listFamilias").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Texto FR', 'Texto EN', 'Descripcion'],
    colModel: [
        {name: 'act', index: 'act', width: 40, sortable: false, align: 'center'},
        {name: 'texto_fr', index: 'texto_fr', width: 400},
        {name: 'texto_en', index: 'texto_en', width: 400},
        {name: 'descripcion', index: 'descripcion', width: 400}


    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'texto_fr',
    viewrecords: true,
    sortorder: "asc",
    caption: "Texto Auxiliares",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#listFamilias").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('texto_auxiliares','texto_auxiliares_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

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






$("#btnNew").click(function () {
    x_goTo('texto_auxiliares', 'texto_auxiliares_form', '', 'Main', this);
});


$("#modulo").val("texto_auxiliares");
$("#submodulo").val("texto_auxiliares_list");
//exportar listado medicos
$("#btnExportar").click(function () {
    $("#f_export").submit();

});
x_runJS();

