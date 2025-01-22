
x_runJS();


function reload_planes_prestador() {
    $("#list_planes").jqGrid('setGridParam', {url: BASE_PATH + "xadmin.php?action=1&modulo=prestadores&submodulo=planes_prestador_list&do_reset=1&idprestador=" + $("#idprestador").val(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: BASE_PATH + "xadmin.php?action=1&modulo=prestadores&submodulo=planes_prestador_list&do_reset=0&idprestador=" + $("#idprestador").val(), page: 1});
}

$("#list_planes").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=planes_prestador_list&idprestador=" + $("#idprestador").val(),
    datatype: "json",
    colNames: ['', 'Nombre', 'Cantidad CE', 'Cantidad VC'],
    colModel: [
        {name: 'act', index: 'act', width: 50, sortable: false, align: "center"},
        {name: 'nombre', index: 'nombre', width: 100, sortable: true},
        {name: 'cantidad_ce', index: 'cantidad_ce', width: 100, sortable: true},
        {name: 'cantidad_vc', index: 'cantidad_vc', width: 100, sortable: true}


    ],
    rowNum: 50,
    pager: '#pager_planes',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",
    page: $("#list_actual_page_8").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list_planes").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'prestadores', 'planes_prestador_form_win', 'id=" + id + "&idprestador=" + $("#idprestador").val() + "', 800, 300);\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list_planes").jqGrid('setRowData', ids[i], {act: be});


        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_planes_left").click(function () {

    x_deleteMultiple({ids: $("#list_planes").jqGrid('getGridParam', 'selarrrow'),
        callback: reload_planes_prestador,
        pregunta: 'Desea dar de baja el/los planes/s de este Prestador?',
        modulo: 'prestadores',
        submodulo: 'deletemultiple_planes_prestador_gen'
    });

});



$("#btnAddPlan").click(function () {
    if ($("#idprestador").val() != "") {
        x_loadWindow(this, 'prestadores', 'planes_prestador_form_win', 'idprestador=' + $("#idprestador").val(), 800, 300);
    } else {
        x_alert("Debe crear el Prestador antes de agregar planes");
    }
})



