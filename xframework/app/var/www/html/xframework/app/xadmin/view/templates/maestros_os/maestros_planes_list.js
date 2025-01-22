$("#modulo").val("maestros_os");
$("#submodulo").val("maestros_planes_list");
x_runJS();



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}
var idobraSocial=$("#obraSocial_idobraSocial").val();
$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_os&submodulo=maestros_planes_list&obraSocial_idobraSocial="+idobraSocial,
    datatype: "json",
    colNames: ['', 'Nombre Plan'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'nombrePlan', index: 'nombrePlan', width: 150, sortable: false}
    ],
     rowNum: 50,
    pager: '#pager',
    sortname: 'nombrePlan',
    viewrecords: true,
    sortorder: "asc",
    caption: "Planes de Obras Sociales - Prepagas",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    
    
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
			var idobraSocial=$("#obraSocial_idobraSocial").val();	
			
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_os','maestros_planes_form','id=" + id + "&obraSocial_idobraSocial="+idobraSocial+"','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
     
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/los plan/es?',
        submodulo: 'deletemultiple_planes'
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
    x_goTo('maestros_os', 'maestros_planes_form', 'obraSocial_idobraSocial='+idobraSocial, 'Main', this);
});

$("#btnBack").click(function() {
    x_goTo('maestros_os', 'maestros_os_list', '', 'Main', this);
});