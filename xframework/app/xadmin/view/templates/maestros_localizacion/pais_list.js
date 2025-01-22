// JavaScript Document

function reload(){
    $("#list").jqGrid().trigger("reloadGrid");
}       

$("#list").jqGrid({ 
    url: $("#f_busqueda").attr("action")+"&"+$("#f_busqueda").serialize(), 
    datatype: "json", 
    colNames:[' ','País'], 
    colModel:[  
        {name:'act',index:'act', width:25,sortable:false},
        {name:'pais',index:'pais', width:400}
  
    ], 
    rowNum:25, 
    /*rowList:[10,20,30],*/ 
    pager: '#pager', 
    sortname: 'idpais', 
    viewrecords: true, 
    sortorder: "asc", 
    caption:"Paises" ,
    page:$("#list_actual_page").val(),
    /*width: 900,*/ 
    autowidth:true,
    height: '100%',
    multiselect: true,
    gridComplete: function(){ 
        
        var ids = $("#list").jqGrid('getDataIDs'); 
        
        for(var i=0;i < ids.length;i++){ 
            
            var id = ids[i]; 
            
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_localizacion','pais_form','id="+id+"','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>"; 
            if(id==1 || id==2){
                loc = "<a href=\"javascript:;\" title=\"Localidades\" onclick=\"x_goTo('maestros_localizacion','localidad_list','pais_idpais="+id+"','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_arrow_right.png\" /></a>"; 

            }else{
                loc="";
            }

            $("#list").jqGrid('setRowData',ids[i],{act:be+' '+loc}); 
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
        pregunta:'Desea dar de baja el/los paises/s?',
        submodulo:'deletemultiple_pais'
    });
	
})



$("#modulo").val("maestros_localizacion");
$("#submodulo").val("paises_list");
x_runJS();

