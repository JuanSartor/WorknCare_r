$("#modulo").val("vacunas");
$("#submodulo").val("vacuna_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reser=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Vacuna', 'Descripción', 'Activo', 'Notificación'],
    colModel: [
        {name: 'act', index: 'act', width: 25, align: "center", hidden: false, sortable: false},
        {name: 'vacuna', index: 'vacuna', width: 100, sortable: false},
        {name: 'descripcion', index: 'descripcion', width: 250, sortable: false},
        {name: 'activo', index: 'activo', width: 50, align: "center", sortable: false},
        {name: 'genera_notificacion', index: 'genera_notificacion', width: 50, align: "center", sortable: false}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'vacuna',
    viewrecords: true,
    sortorder: "asc",
    caption: "Vacunas",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('vacunas','vacuna_form','id=" + id + "','Main',this)\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\"/></a>";

            bd = "<a href=\"javascript:;\"  onclick=\"drop({id:" + id + ",modulo:'vacunas', submodulo:'drop_vacuna',callback:reload});\" title=\"Eliminar\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_delete.png\"/></a>";

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
    x_goTo('vacunas', 'vacuna_form', '', 'Main', this);
});
