$("#modulo").val("reintegro");
$("#submodulo").val("grillas_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=reintegro&submodulo=grillas_list&do_reset=1",
    datatype: "json",
    colNames: ['', 'Grilla', 'Código','Sector 1','Sector 2','Optam'],
    colModel: [
        {name: 'act', index: 'act', align: "center", width: 20, hidden: false, sortable: false},
        {name: 'grilla', index: 'grilla', width: 100, sortable: true},
        {name: 'codigo', index: 'codigo', width: 100, sortable: true},
        {name: 'sector1', index: 'sector1', width: 100, sortable: true},
        {name: 'sector2', index: 'sector2', width: 100, sortable: true},
        {name: 'optam', index: 'optam', width: 100, sortable: true}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'CAST(grilla as INTEGER)',
    viewrecords: true,
    sortorder: "asc",
    caption: "Grillas de tarifas",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('reintegro','grillas_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";



            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }
    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar" >Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: '¿Desea eliminar las grillas seleccionadas?',
        submodulo: 'deletemultiple_grillas'
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

$("#btnNew").click(function() {
    x_goTo('reintegro', 'grillas_form', '', 'Main', this);
});
