// JavaScript Document

function reload(){
    $("#list").jqGrid().trigger("reloadGrid");
}       

$("#list").jqGrid({ 
    url: $("#f_busqueda").attr("action")+"&"+$("#f_busqueda").serialize(), 
    datatype: "json", 
    colNames:[' ','Directorio','Seo','Tipo'], 
    colModel:[  
                {name:'act',index:'act', width:25,sortable:false},
			 	{name:'directory',index:'directory', width:150},
			 	{name:'seo',index:'seo', width:200},				
			 	{name:'type',index:'type', width:75}								
              ], 
    rowNum:50, 
    /*rowList:[10,20,30],*/ 
    pager: '#pager', 
    sortname: 'directory asc, seo', 
    viewrecords: true, 
    sortorder: "asc", 
    caption:"Seo" ,
	page:$("#list_actual_page").val(),
    /*width: 900,*/ 
    autowidth:true,
    height: '100%',
    multiselect: false,
	gridComplete: function(){ 
        
        var ids = $("#list").jqGrid('getDataIDs'); 
        
        for(var i=0;i < ids.length;i++){ 
            
            var id = ids[i]; 
            
            be = "<a href=\"javascript:;\" title=\"Edit\" onclick=\"x_goTo('seo','seo_form','id="+id+"','Main',this)\"><img src=\"xframework/app/themes/xadmin/imgs/action_ico_edit.png\" /></a>"; 

			bd = "&nbsp;&nbsp;<a href=\"javascript:;\" title=\"Delete\"><img  src=\"xframework/app/themes/xadmin/imgs/action_ico_delete.png\"  onclick=\"drop({id:"+id+",modulo:'seo',callback:reload});\" /></a>";
			
		
            $("#list").jqGrid('setRowData',ids[i],{act:be+bd}); 
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

/*$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function(){
	
	x_deleteMultiple({ ids:$("#list").jqGrid('getGridParam','selarrrow'),
					   callback:reload,
					   pregunta:'Desea dar de baja la/los localidad/es?',
					   submodulo:'deletemultiple_localidad'
					 });
	
})*/

$("#modulo").val("seo");
$("#submodulo").val("seo_list");
x_runJS();

