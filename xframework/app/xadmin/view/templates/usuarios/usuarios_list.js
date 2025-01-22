// JavaScript Document

function reload(){
    $("#list").jqGrid().trigger("reloadGrid");
}       

$("#list").jqGrid({ 
    url: $("#f_busqueda").attr("action")+"&"+$("#f_busqueda").serialize(), 
    datatype: "json", 
    colNames:[' ','Usuario','Email','Nombre','Apellido','Estado'], 
    colModel:[  
                {name:'act',index:'act', width:75,sortable:false,align:'center'},
                {name:'username',index:'username', width:100},
                {name:'email',index:'email', width:100},
                {name:'nombre',index:'nombre', width:100},
                {name:'apellido',index:'apellido', width:200},    				
                {name:'activo',index:'activo', width:100, align:'center'}
              ], 
    rowNum:25, 
    pager: '#pager', 
    sortname: 'username', 
    viewrecords: true, 
    sortorder: "asc", 
    caption:"Usuarios" ,
	page:$("#list_actual_page").val(),
    autowidth:true,
    height: '100%',
    multiselect: true,
	gridComplete: function(){ 
        
        var ids = $("#list").jqGrid('getDataIDs'); 
        
        for(var i=0;i < ids.length;i++){ 
            
            var id = ids[i]; 
            
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('usuarios','usuarios_form','id="+id+"','Main',this)\"><button>Editar</button></a>"; 
                       
            
            $("#list").jqGrid('setRowData',ids[i],{act:be}); 
        } 
    }
    
});


$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function(){
	
	x_deleteMultiple({ ids:$("#list").jqGrid('getGridParam','selarrrow'),
					   callback:reload,
					   pregunta:'Desea dar de baja el/los usuario/s?',
					   submodulo:'deletemultiple'
					 });
	
})



$("#btnFilter").click(function(){

	$("#list").jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=1&"+$("#f_busqueda").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=0&"+$("#f_busqueda").serialize(),page:1});	
});

$("#btnLimpiar").click(function(){
    
    $("#f_busqueda").clearForm();
	
	$("#activo").prop("selectedIndex",1);
	
	$.uniform.update("#f_busqueda :input");
	
	$("#list")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=1&"+$("#f_busqueda").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda").attr("action")+"&do_reset=0&"+$("#f_busqueda").serialize(),page:1});	

});





$("#modulo").val("usuarios");
$("#submodulo").val("usuarios_list");
x_runJS();

