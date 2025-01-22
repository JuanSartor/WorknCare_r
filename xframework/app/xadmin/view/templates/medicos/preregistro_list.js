$("#modulo").val("medicos");
$("#submodulo").val("preregistro_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=medicos&submodulo=preregistro_list&do_reset=1",
    datatype: "json",
    colNames: ['','Fecha', 'Email', 'Registrado','Teaser', 'Nombre del profesional'],
    colModel: [
        {name: 'act', index: 'act', align: "center", width: 20, hidden: true, sortable: false},
        {name: 'fecha_format', index: 'fecha', width: 50,align: "center", sortable: true},
        {name: 'email', index: 'email', width: 150, sortable: true},
        {name: 'completado', index: 'completado', align: "center",width: 70, sortable: true},
        {name: 'teaser', index: 'teaser', align: "center",width: 70, sortable: true},
        {name: 'nombre', index: 'nombre', width: 100,align: "center", sortable: true}
        
        
    
    ],
     rowNum: 50,
    pager: '#pager',
    sortname: 'fecha',
    viewrecords: true,
    sortorder: "desc",
    caption: "Preregistros",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

           
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

//Exportar el listado a CSV
$("#btnExportar").click(function(){
    
    $("#f_export input").val("");
    $("#nombre_export").val($("#nombre_input").val());
    $("#email_export").val($("#email_input").val());
    $("#completado_export").val($("#completado option:selected").val());
    $("#f_export").submit();
})

