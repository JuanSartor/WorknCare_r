$("#modulo").val("vacunas");
$("#submodulo").val("vacuna_edad_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Edad/Grupo', 'Valor Unidad', 'Unidad',"Tiempo en meses"],
    colModel: [
        {name: 'act', index: 'act', width: 25, align: "center", hidden: false, sortable: false},
        {name: 'edad', index: 'edad', width: 200, sortable: false},
        {name: 'valor_unidad', index: 'valor_unidad', width: 50, sortable: false},
        {name: 'unidadTemporal', index: 'unidadTemporal', width: 50, sortable: false},
        {name: 'tiempo_meses', index: 'tiempo_meses', width: 50, sortable: false}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'tiempo_meses',
    viewrecords: true,
    sortorder: "asc",
    caption: "Vacunas por Edad / Grupo",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('vacunas','vacuna_edad_form','id=" + id + "', 'Main', this)\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\"/></a>";

            bd = "<a href=\"javascript:;\" onclick=\"drop({id:" + id + ", modulo:'vacunas', submodulo:'drop_vacuna_edad', callback:reload});\" title=\"Eliminar\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_delete.png\"/></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be + bd});
        }
    }
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




$("#btnNew").click(function () {
    x_goTo('vacunas', 'vacuna_edad_form', '', 'Main', this);
});
