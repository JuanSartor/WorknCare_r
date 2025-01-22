$("#modulo").val("cirugia_ocular");
$("#submodulo").val("cirugia_ocular_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Cirugía Ocular'],
    colModel: [
        {name: 'act', index: 'act', width: 25, align: "center",hidden: false, sortable: false},
        {name: 'cirugia_ocular', index: 'cirugia_ocular', width: 100, sortable: true}
        
        
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'cirugia_ocular',
    viewrecords: true,
    sortorder: "asc",
    caption: "Cirugías Oculares",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('cirugia_ocular','cirugia_ocular_form','id=" + id + "','Main',this)\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\"/></a>";
            
            bd = "<a href=\"javascript:;\"  onclick=\"drop({id:" + id + ",modulo:'cirugia_ocular', submodulo:'drop_cirugia_ocular',callback:reload});\" title=\"Eliminar\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_delete.png\"/></a>";
			
            $("#list").jqGrid('setRowData', ids[i], {act: be + bd});
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




$("#btnNew").click(function() {
    x_goTo('cirugia_ocular', 'cirugia_ocular_form', '', 'Main', this);
});
