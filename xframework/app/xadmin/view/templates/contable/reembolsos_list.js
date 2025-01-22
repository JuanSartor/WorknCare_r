$("#modulo").val("contable");
$("#submodulo").val("reembolsos_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Programa', 'Beneficiario', 'IBAN', 'Empresa', 'Estado'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, align: "center", sortable: false},
        {name: 'programa', index: 'programa', width: 100, align: "centter", sortable: false},
        {name: 'nombre', index: 'nombre', width: 100, align: "center", sortable: false},
        {name: 'iban', index: 'iban', width: 100, align: "center", sortable: false},
        {name: 'empresa', index: 'empresa', width: 100, align: "center", sortable: false},
        {name: 'estado', index: 'estado', width: 100, align: "center", sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'programa',
    viewrecords: true,
    sortorder: "desc",
    caption: "Listado de reembolsos",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,

    gridComplete: function () {

        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);

            be = "<a href=\"javascript:;\" title=\"Chequear\" onclick=\"x_goTo('contable','reembolso_form','id=" + id + "','Main',this)\">CHEQUEAR</a>";

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