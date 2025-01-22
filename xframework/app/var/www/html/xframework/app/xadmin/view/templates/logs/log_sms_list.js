// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}
var lastsel = false;
$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Fecha', 'Tipo usuario', 'Nombre usuario', 'Email', 'Celular','Motivo','Texto', 'Envío', 'Estado'],
    colModel: [
        {name: 'act', index: 'act', width: 30, sortable: false,align:'center'},
        {name: 'fecha', index: 'fecha', width: 100,align:'center'},
        {name: 'dirigido', index: 'dirigido', width: 70,align:'center'},
        {name: 'nombre_usuario', index: 'nombre_usuario', width: 100},
        {name: 'email', index: 'email', width: 100},
        {name: 'numero_cel', index: 'numero_cel', width: 100},
        {name: 'contexto', index: 'contexto', width: 100},
        {name: 'texto', index: 'texto', width: 300},
        {name: 'ultimo_envio', index: 'ultimo_envio', width: 100,align:'center'},
        {name: 'estado', index: 'estado', width: 50,align:'center'}
    ],
    rowNum: 100,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'fecha',
    viewrecords: true,
    sortorder: "desc",
    caption: "Log de SMS",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');
        for (var i = 0; i < ids.length; i++) {
            var id = ids[i];
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'logs', 'log_sms_form_win', 'id=" + id + "', 800, 600);\"><button>Ver</button></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }
    }

}).jqGrid("setGridParam", {

}).jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});


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



$("#modulo").val("log_sms");
$("#submodulo").val("log_sms_list");
x_runJS();

