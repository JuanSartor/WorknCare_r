$("#modulo").val("maestros_enfermedades");
$("#submodulo").val("tipo_enfermedad_list");
x_runJS();



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}


var idenfermedad = $("#enfermedad_idenfermedad").val();
$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_enfermedades&submodulo=tipo_enfermedad_list&enfermedad_idenfermedad=" + idenfermedad,
    datatype: "json",
    colNames: ['', 'Tipo Enfermedad'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'tipoEnfermedad', index: 'tipoEnfermedad', width: 150, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'tipoEnfermedad',
    viewrecords: true,
    sortorder: "asc",
    caption: "Tipo Enfermedad",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            
            
            var idenfermedad = $("#enfermedad_idenfermedad").val();

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_enfermedades','tipo_enfermedad_form','id=" + id + "&enfermedad_idenfermedad=" + idenfermedad + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/los Tipo/s Enfermedad/es?',
        submodulo: 'deletemultiple_tipo_enfermedad'
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
    var idenfermedad = $("#enfermedad_idenfermedad").val();
    x_goTo('maestros_enfermedades', 'tipo_enfermedad_form', 'enfermedad_idenfermedad=' + idenfermedad, 'Main', this);
});

$("#back").click(function() {
    x_goTo('maestros_enfermedades', 'enfermedad_list', '', 'Main', this);
});