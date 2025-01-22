
x_runJS();


function reload_pacientes() {
    $("#list_busqueda_paciente").jqGrid().trigger("reloadGrid");
}
$("#list_busqueda_paciente").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=pacientes_list&idprestador="+$("#idprestador_busqueda_pacientes").val(),
    datatype: "json",
    colNames: ['','Nombre','DNI','Paciente titular','Email'],
    colModel: [
     {name: 'act', index: 'act', width: 150, hidden:true},
        {name: 'nombre', index: 'nombre', width: 150, sortable: true},
        {name: 'DNI', index: 'DNI', width: 150, sortable: true},
         {name: 'titular', index: 'titular', width: 150, sortable: true},
           {name: 'email', index: 'email', width: 150, sortable: true}
    
    ],
     rowNum: 20,
    pager: '#pager_busqueda_paciente',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",

    page: $("#list_actual_page_3").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list_busqueda_paciente").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

          //  be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('prestadores','prestadores_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
			
		
         
        }


    }
});

$("#back_hs").click(function() {
    hs.close();
});

$("#btnFilterBusquedaPacientes").click(function(){

	$("#list_busqueda_paciente").jqGrid('setGridParam',{ url: $("#f_busqueda_pacientes").attr("action")+"&do_reset=1&"+$("#f_busqueda_pacientes").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_pacientes").attr("action")+"&do_reset=0&"+$("#f_busqueda_pacientes").serialize(),page:1});	
});

$("#btnLimpiarBusquedaPacientes").click(function(){
    
    $("#f_busqueda_pacientes").clearForm();

	
	//actualizo uniform
	
	$.uniform.update("#f_busqueda_pacientes :input");
	
	$("#list_busqueda_paciente")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_pacientes").attr("action")+"&do_reset=1&"+$("#f_busqueda_pacientes").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_pacientes").attr("action")+"&do_reset=0&"+$("#f_busqueda_pacientes").serialize(),page:1});	
});

$("#btnGuardarPacientePrestador").click(function () {



if($("#list_busqueda_paciente").jqGrid('getGridParam', 'selarrrow')==""){
    x_alert("Seleccione al menos un paciente");
    return false;
}


$("#ids_paciente").val($("#list_busqueda_paciente").jqGrid('getGridParam', 'selarrrow'));
    x_sendForm($('#f_pacientes_prestador'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload_pacientes_prestador();
          
            hs.close();
        }
    });

});




