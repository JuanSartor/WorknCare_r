$("#modulo").val("banner");
$("#submodulo").val("tipo_banner_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=banner&submodulo=tipo_banner_list",
    datatype: "json",
    colNames: ['', 'Tipo Banner', 'Descripción'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'tipoBanner', index: 'tipoBanner', width: 150, align: "center"},
        {name: 'descripcion', index: 'descripcion', width: 300, align: "center"}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'tipoBanner',
    viewrecords: true,
    sortorder: "asc",
    caption: "Tipo Banner",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('banner','tipo_banner_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" />";

            $("#list").jqGrid('setRowData', ids[i], {act: be });

        }

    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja Tipos de banners?',
        submodulo: 'deletemultiple_tipo_banner'
    });

});




$("#btnNew").click(function() {
    x_goTo('banner', 'tipo_banner_form', '', 'Main', this);
});
