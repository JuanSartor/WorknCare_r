// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}
/*
 * fecha", "page", "purpose", "data", "link"
 */
var lastsel = false;
$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Fecha', 'Tipo', 'Nombre', 'Email', 'Pag.', 'Accion', 'URL', 'Datos'],
    colModel: [
        {name: 'act', index: 'act', hidden: true, align: 'center'},
        {name: 'fecha', index: 'fecha',  align: 'center'},
        {name: 'usertype', index: 'usertype',  sortable: false, align: 'left'},
        {name: 'nombre', index: 'nombre',  align: 'left'},
        {name: 'email', index: 'email',  sortable: false, align: 'left'},
        {name: 'page', index: 'page',  align: 'left'},
        {name: 'purpose', index: 'purpose',  align: 'left'},
        {name: 'link', index: 'link',  align: 'left'},
        {name: 'data', index: 'data',  align: 'left'}

    ],
    rowNum: 100,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'idlog',
    viewrecords: true,
    sortorder: "desc",
    caption: "Track Log",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function () {
        $('.ui-jqgrid-hdiv').hide();
        $("#list").css("width", "auto");
        $("#list").parent().css("width", "100%");
        $("#list").parent().css("overflow-x", "scroll");
        //var ids = $("#list").jqGrid('getDataIDs');
        //for (var i = 0; i < ids.length; i++) {
        //var id = ids[i];
        //be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'logs', 'log_track_form_win', 'id=" + id + "', 800, 600);\"><button>Ver</button></a>";

        //$("#list").jqGrid('setRowData', ids[i], {act: be});
        //}
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
$("#modulo").val("log_track");
$("#submodulo").val("log_track_list");
x_runJS();

