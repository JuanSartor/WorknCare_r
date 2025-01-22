$("#modulo").val("maestros_especialidades");
$("#submodulo").val("maestros_subespecialidades_list");
x_runJS();



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}


var idespecialidad = $("#especialidad_idespecialidad").val();
$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_especialidades&submodulo=maestros_subespecialidades_list&especialidad_idespecialidad=" + idespecialidad,
    datatype: "json",
    colNames: ['', 'Sub Especialidad'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'subEspecialidad', index: 'subEspecialidad', width: 150, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'subEspecialidad',
    viewrecords: true,
    sortorder: "asc",
    caption: "Planes de Obras Sociales - PrepagasSub Especialidad",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            
            
            var idespecialidad = $("#especialidad_idespecialidad").val();

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_especialidades','maestros_subespecialidades_form','id=" + id + "&especialidad_idespecialidad=" + idespecialidad + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/las subespecialidad/es?',
        submodulo: 'deletemultiple_subespecialidades'
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
    var idespecialidad = $("#especialidad_idespecialidad").val();
    x_goTo('maestros_especialidades', 'maestros_subespecialidades_form', 'especialidad_idespecialidad=' + idespecialidad, 'Main', this);
});

$("#back").click(function() {
    x_goTo('maestros_especialidades', 'maestros_especialidades_list', '', 'Main', this);
});