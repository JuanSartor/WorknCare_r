$("#modulo").val("maestros_especialidades");
$("#submodulo").val("maestros_especialidades_list");
x_runJS();
function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_especialidades&submodulo=maestros_especialidades_list",
    datatype: "json",
    colNames: ['', 'Nombre', 'Tipo', '€ Max VC turno', 'Acceso directo', 'Identificación', 'Número AM', 'Sector', 'Modo Facturación'],
    colModel: [
        {name: 'act', index: 'act', width: 40, hidden: false, align: 'center', sortable: false},
        {name: 'especialidad', index: 'especialidad', width: 200, sortable: true},
        {name: 'tipo', index: 'tipo', width: 150,  align: 'center',sortable: true},
        {name: 'max_vc_turno', index: 'max_vc_turno', width: 150,  align: 'center',sortable: true},
        {name: 'acceso_directo', index: 'acceso_directo', width: 100, align: 'center', sortable: true},
        {name: 'tipo_identificacion', index: 'tipo_identificacion', width: 100, align: 'center', sortable: true},
        {name: 'requiere_numero_am', index: 'requiere_numero_am', width: 100, align: 'center', sortable: true},
        {name: 'requiere_sector', index: 'requiere_sector', width: 100, align: 'center', sortable: true},
        {name: 'requiere_modo_facturacion', index: 'requiere_modo_facturacion', width: 100, align: 'center', sortable: true}

    ],
    rowNum: 100,
    pager: '#pager',
    sortname: 'especialidad',
    viewrecords: true,
    sortorder: "asc",
    caption: "Especialidades",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');
        for (var i = 0; i < ids.length; i++) {


            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_especialidades','maestros_especialidades_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});
function accion_destacar(id, valor) {
    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=maestros_especialidades&submodulo=destacar&idespecialidad=" + id + "&destacado=" + valor;
    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    reload();
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);
}


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/s Especialidad/es?',
        submodulo: 'deletemultiple_especialidades'
    });
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
$("#btnNew").click(function () {
    x_goTo('maestros_especialidades', 'maestros_especialidades_form', '', 'Main', this);
});
