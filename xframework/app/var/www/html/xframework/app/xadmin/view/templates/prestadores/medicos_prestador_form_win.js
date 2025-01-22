
x_runJS();


function reload_medicos() {
    $("#list_busqueda_medico").jqGrid().trigger("reloadGrid");
}
$("#list_busqueda_medico").jqGrid({
    url: "xadmin.php?action=1&modulo=prestadores&submodulo=medicos_list&idprestador="+$("#idprestador_busqueda_medicos").val(),
    datatype: "json",
    colNames: ['','Nombre','Especialidad','Email'],
    colModel: [
     {name: 'act', index: 'act', width: 150, hidden:true},
        {name: 'nombre', index: 'nombre', width: 150, sortable: true},
        {name: 'especialidad', index: 'especialidad', width: 150, sortable: true},
           {name: 'email', index: 'email', width: 150, sortable: true}
    
    ],
     rowNum: 20,
    pager: '#pager_busqueda_medico',
    sortname: 'nombre',
    viewrecords: true,
    sortorder: "asc",

    page: $("#list_actual_page_1").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list_busqueda_medico").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

          //  be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('prestadores','prestadores_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";
			    
        }


    }
});

$("#back_hs").click(function() {
    hs.close();
});

$("#btnFilterBusquedaMedicos").click(function(){

	$("#list_busqueda_medico").jqGrid('setGridParam',{ url: $("#f_busqueda_medicos").attr("action")+"&do_reset=1&"+$("#f_busqueda_medicos").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_medicos").attr("action")+"&do_reset=0&"+$("#f_busqueda_medicos").serialize(),page:1});	
});

$("#btnLimpiarBusquedaMedicos").click(function(){
    
    $("#f_busqueda_medicos").clearForm();

	
	//actualizo uniform
	
	$.uniform.update("#f_busqueda_medicos :input");
	
	$("#list_busqueda_medico")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_medicos").attr("action")+"&do_reset=1&"+$("#f_busqueda_medicos").serialize(),page:1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam',{ url: $("#f_busqueda_medicos").attr("action")+"&do_reset=0&"+$("#f_busqueda_medicos").serialize(),page:1});	
});

$("#btnGuardarMedicoPrestador").click(function () {

   

if($("#list_busqueda_medico").jqGrid('getGridParam', 'selarrrow')==""){
    x_alert("Seleccione al menos un m&eacute;dico");
    return false;
}
$("#ids_medico").val($("#list_busqueda_medico").jqGrid('getGridParam', 'selarrrow'));
    x_sendForm($('#f_medicos_prestador'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload_medicos_prestador();
          
            hs.close();
        }
    });

});




