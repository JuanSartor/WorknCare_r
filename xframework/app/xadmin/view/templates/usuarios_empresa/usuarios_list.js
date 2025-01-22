// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Nombre', 'Apellido', 'Email', 'Empresa / Particular', 'Plan', 'Fecha adhesion', 'Suscripción', 'Fecha alta', 'Usuario', 'Email confirmado', 'Verificar Pago', "Cuenta"],
    colModel: [
        {name: 'act', index: 'act', width: 75, sortable: false, align: 'center'},
        {name: 'nombre', index: 'nombre', width: 100},
        {name: 'apellido', index: 'apellido', width: 100},
        {name: 'email', index: 'email', width: 100},
        {name: 'empresa', index: 'empresa', width: 100},
        {name: 'nombre_plan', index: 'psp.nombre', width: 100, align: 'center'},
        {name: 'fecha_adhesion', index: 'fecha_adhesion', width: 100, align: 'center'},
        {name: 'estado_suscripcion', index: 'estado_suscripcion', width: 100, align: 'center'},
        {name: 'fecha_alta', index: 'fecha_alta', width: 100, align: 'center'},
        {name: 'email_confirmado', index: 'email_confirmado', width: 100, align: 'center'},
        {name: 'pagopendiente', index: 'pagopendiente', width: 100, align: 'center'},
        {name: 'activo', index: 'activo', width: 100, align: 'center'},
        {name: 'cuenta_empresa', index: 'cuenta_empresa', width: 100, align: 'center'}
    ],
    rowNum: 25,
    pager: '#pager',
    sortname: 'idusuario_empresa',
    viewrecords: true,
    sortorder: "desc",
    caption: "Usuarios del WorknCare",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('usuarios_empresa','usuarios_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";


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

    $("#activo").prop("selectedIndex", 1);

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});

});





$("#modulo").val("usuarios");
$("#submodulo").val("usuarios_list");
x_runJS();

