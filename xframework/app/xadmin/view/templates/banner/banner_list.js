$("#modulo").val("banner");
$("#submodulo").val("banner_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Banner', 'Descripción', 'Tipo Banner'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'banner', index: 'banner', width: 150, align: "center"},
        {name: 'descripcion', index: 'descripcion', width: 300, align: "center"},
        {name: 'tipoBanner', index: 'tipoBanner', width: 150, align: "center"}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'banner',
    viewrecords: true,
    sortorder: "asc",
    caption: "Banner",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('banner','banner_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" />";

            $("#list").jqGrid('setRowData', ids[i], {act: be });

        }

    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja de banners?',
        submodulo: 'deletemultiple_banner'
    });

});


$("#btnNew").click(function() {
    x_goTo('banner', 'banner_form', '', 'Main', this);
});
