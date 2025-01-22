$("#modulo").val("maestros_enfermedades");
$("#submodulo").val("enfermedad_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_enfermedades&submodulo=enfermedad_list",
    datatype: "json",
    colNames: ['', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'enfermedad', index: 'enfermedad', width: 150, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'enfermedad',
    viewrecords: true,
    sortorder: "asc",
    caption: "Enfermedades",
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
            
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_enfermedades','enfermedad_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";


            bs = "<a href=\"javascript:;\" title=\"Tipo de Enfermedad\" onclick=\"x_goTo('maestros_enfermedades','tipo_enfermedad_list','enfermedad_idenfermedad=" + id + "','Main',this)\"> Tipo Enfermedad</a>";
            $("#list").jqGrid('setRowData', ids[i], {act: be + bs});
        }


    }
});

//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/s enfermedad/es?',
        submodulo: 'deletemultiple_enfermedad'
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
    x_goTo('maestros_enfermedades', 'enfermedad_form', '', 'Main', this);
});
