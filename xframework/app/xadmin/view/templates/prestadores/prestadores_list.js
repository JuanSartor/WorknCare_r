$("#modulo").val("prestadores");
$("#submodulo").val("prestadores_list");
x_runJS();


function reload() {
    $("#list")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=1&"+$("#f_busqueda").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=0&"+$("#f_busqueda").serialize(),page:1});
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=prestadores_list",
    datatype: "json",
    colNames: ['', 'Nombre'],
    colModel: [
        {name: 'act', index: 'act', width: 10, hidden: false, sortable: false,align:"center"},
       {name: 'nombre', index: 'nombre', width: 150, sortable: true},
       // {name: 'razon_social', index: 'razon_social', width: 150, sortable: true},
      // {name: 'cuit', index: 'cuit', width: 150, sortable: true}
    
    ],
     rowNum: 50,
    pager: '#pager',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",
    caption: "Prestadores",
    page: $("#list_actual_page_5").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('prestadores','prestadores_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
			
		
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/los Prestador/es',
        modulo: 'prestadores',
        submodulo: 'deletemultiple_prestadores_gen'
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


$("#btnNew").click(function(){    
    x_goTo('prestadores','prestadores_form','','Main',this);
})


