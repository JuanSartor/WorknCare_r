$("#modulo").val("maestros_os");
$("#submodulo").val("maestros_os_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_os&submodulo=maestros_os_list",
    datatype: "json",
    colNames: ['', 'Nombre', 'Tipo'],
    colModel: [
        {name: 'act', index: 'act', width: 20, hidden: false, align: "center",sortable: false},
        {name: 'nombre', index: 'nombre', width: 200, sortable: false},
    
        {name: 'tipo', index: 'tipo', width: 100, sortable: true}
    
    ],
    
    rowNum: 50,
    pager: '#pager',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",
    caption: "Obras Sociales ",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_os','maestros_os_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
			
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/s Obra/s Social/es - Prepaga/s?',
        submodulo: 'deletemultiple_os'
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
    x_goTo('maestros_os', 'maestros_os_form', '', 'Main', this);
});
