$("#modulo").val("notificaciones");
$("#submodulo").val("notificaciones_paciente_list");
x_runJS();



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Título', 'Fecha Creación', 'Text', 'URL'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: false, align:'center', sortable: false},
        {name: 'titulo', index: 'titulo', width: 50, sortable: true},
        {name: 'fechaCreacion_format', align:'center', index: 'fechaCreacion', width: 40, sortable: true},
        {name: 'texto', index: 'texto', width: 150, sortable: false},
        {name: 'url', index: 'url', width: 75, sortable: true}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'fechaCreacion',
    viewrecords: true,
    sortorder: "asc",
    caption: "Notificaciones de los pacientes",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    
    
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
			
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('notificaciones','notificaciones_paciente_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
     
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja las notificaciones a los pacientes?',
        submodulo: 'deletemultiple_notificaciones_paciente'
    });

});


$("#btnFilter").click(function(){

	$("#list").jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=1&"+$("#f_busqueda").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=0&"+$("#f_busqueda").serialize(),page:1});	
});

$("#btnLimpiar").click(function(){
    
    $("#f_busqueda").clearForm();

	
	//actualizo uniform
	
	$.uniform.update("#f_busqueda :input");
	
	$("#list")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=1&"+$("#f_busqueda").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=0&"+$("#f_busqueda").serialize(),page:1});	
});




$("#btnNew").click(function() {
    x_goTo('notificaciones', 'notificaciones_paciente_form', '', 'Main', this);
});
