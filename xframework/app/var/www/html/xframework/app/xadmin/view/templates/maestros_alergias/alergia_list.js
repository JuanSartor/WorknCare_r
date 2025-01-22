$("#modulo").val("maestros_alergias");
$("#submodulo").val("alergia_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_alergias&submodulo=alergia_list",
    datatype: "json",
    colNames: ['', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'tipoAlergia', index: 'tipoAlergia', width: 150, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'tipoAlergia',
    viewrecords: true,
    sortorder: "asc",
    caption: "Alergias",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            
            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);
            
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_alergias','alergia_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";


            bs = "<a href=\"javascript:;\" title=\"Sub Tipo de alergias\" onclick=\"x_goTo('maestros_alergias','tipo_alergia_list','tipoAlergia_idtipoAlergia=" + id + "','Main',this)\"> Sub Tipo Alergia</a>";
            $("#list").jqGrid('setRowData', ids[i], {act: be + bs});
        }


    }
});

//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/s Alergia/s?',
        submodulo: 'deletemultiple_alergia'
    });

});


$("#btnFilter").click(function() {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function() {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});




$("#btnNew").click(function() {
    x_goTo('maestros_alergias', 'alergia_form', '', 'Main', this);
});
