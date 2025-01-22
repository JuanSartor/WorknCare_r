// JavaScript Document

function reload(){
    $("#list").jqGrid().trigger("reloadGrid");
}       

$("#list").jqGrid({ 
    url: $("#f_busqueda").attr("action")+"&"+$("#f_busqueda").serialize(), 
    datatype: "json", 
    colNames:[' ','Provincia','Pa&iacute;s'], 
    colModel:[  
                {name:'act',index:'act', width:25,sortable:false},
				{name:'provincia',index:'provincia', width:200},
                {name:'pais',index:'pais', width:200},
              ], 
    rowNum:25, 
    /*rowList:[10,20,30],*/ 
    pager: '#pager', 
    sortname: 'provincia', 
    viewrecords: true, 
    sortorder: "asc, pais asc", 
    caption:"Provincias" ,
	page:$("#list_actual_page").val(),
    /*width: 900,*/ 
    autowidth:true,
    height: '100%',
    multiselect: true,
	gridComplete: function(){ 
        
        var ids = $("#list").jqGrid('getDataIDs'); 
        
        for(var i=0;i < ids.length;i++){ 
            
            var id = ids[i]; 
            
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_localizacion','provincia_form','id="+id+"','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>"; 
		
            $("#list").jqGrid('setRowData',ids[i],{act:be}); 
        } 
    }
    
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



//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function(){
	
	x_deleteMultiple({ ids:$("#list").jqGrid('getGridParam','selarrrow'),
					   callback:reload,
					   pregunta:'Desea dar de baja la/las provincias/s?',
					   submodulo:'deletemultiple_provincia'
					 });
	
})


$("#modulo").val("maestros_localizacion");
$("#submodulo").val("provincia_list");
x_runJS();

