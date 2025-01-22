
x_runJS();


function reload_usuarios_prestador() {
    $("#list_usuario").jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=1&" + $("#f_busqueda_usuario").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=0&" + $("#f_busqueda_usuario").serialize(), page: 1});
}

$("#list_usuario").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=usuarios_prestador_list&idprestador=" + $("#idprestador").val(),
    datatype: "json",
    colNames: ['', 'Nombre', 'Apellido', 'Username', 'Email','Tipo','Estado'],
    colModel: [
        {name: 'act', index: 'act', width: 50, sortable: false,align:"center"},
        {name: 'nombre', index: 'nombre', width: 100, sortable: true},
        {name: 'apellido', index: 'apellido', width: 100, sortable: true},
        {name: 'username', index: 'username', width: 100, sortable: true},
        {name: 'email', index: 'email', width: 100, sortable: true},
          {name: 'tipo', index: 'tipo', width: 80, sortable: true},
          {name: 'estado', index: 'estado', width: 80, sortable: true}

    ],
    rowNum: 50,
    pager: '#pager_usuario',
    sortname: 'username',
    viewrecords: true,
    sortorder: "asc",
    page: $("#list_actual_page_7").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list_usuario").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'prestadores', 'usuarios_prestador_form_win', 'id=" + id + "&idprestador=" + $("#idprestador").val() + "', 800, 300);\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list_usuario").jqGrid('setRowData', ids[i], {act: be});


        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_usuario_left").click(function () {

    x_deleteMultiple({ids: $("#list_usuario").jqGrid('getGridParam', 'selarrrow'),
        callback: reload_usuarios_prestador,
        pregunta: 'Desea dar de baja el/los usuario/s de este Prestador?',
        modulo: 'prestadores',
        submodulo: 'deletemultiple_usuarios_prestador_gen'
    });

});
;


$("#btnFilter").click(function () {

    $("#list_usuario").jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=1&" + $("#f_busqueda_usuario").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=0&" + $("#f_busqueda_usuario").serialize(), page: 1});
});

$("#btnLimpiar").click(function () {
    $("#f_busqueda_usuario").clearForm();
    //actualizo uniform

    $.uniform.update("#f_busqueda_usuario :input");

    $("#list_usuario")
            .jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=1&" + $("#f_busqueda_usuario").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda_usuario").attr("action") + "&do_reset=0&" + $("#f_busqueda_usuario").serialize(), page: 1});
});

$("#btnAddUsuario").click(function () {
    if ($("#idprestador").val() != "") {
        x_loadWindow(this, 'prestadores', 'usuarios_prestador_form_win', 'idprestador=' + $("#idprestador").val(), 800, 300);
    } else {
        x_alert("Debe crear el Prestador antes de agregar usuarios");
    }
})



