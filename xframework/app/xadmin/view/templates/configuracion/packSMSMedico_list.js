$("#modulo").val("configuracion");
$("#submodulo").val("packSMSMedico_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=configuracion&submodulo=packSMSMedico_list",
    datatype: "json",
    colNames: ['', 'Cantidad de SMS', 'Precio Pack'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'cantidadSMS', index: 'cantidadSMS', width: 150, align: "center", sortable: false},
        {name: 'precioPack', index: 'precioPack', width: 100, align: "center", sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'cantidadSMS',
    viewrecords: true,
    sortorder: "asc",
    caption: "Packs SMS de Médicos",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('configuracion','packSMSMedico_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" />";

            $("#list").jqGrid('setRowData', ids[i], {act: be });

        }

    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/los plan/es?',
        submodulo: 'deletemultiple_packSMS'
    });

});




$("#btnNew").click(function() {
    x_goTo('configuracion', 'packSMSMedico_form', '', 'Main', this);
});
