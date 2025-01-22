$("#modulo").val("maestros_genericos");
$("#submodulo").val("medicamento_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Nombre', 'Forma Farmacéutica', 'Presentación', 'Genérico', 'Laboratorio'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: false, sortable: false},
        {name: 'nombre_comercial', index: 'nombre_comercial', width: 150, sortable: false},
        {name: 'forma_farmaceutica', index: 'forma_farmaceutica', width: 150, sortable: false},
        {name: 'presentacion', index: 'presentacion', width: 150, sortable: false},
        {name: 'generico', index: 'generico', width: 150, sortable: false},
        {name: 'laboratorio', index: 'laboratorio', width: 150, sortable: false}
    ],
    
    rowNum: 50,
    pager: '#pager',
    sortname: 'nombre_comercial',
    viewrecords: true,
    sortorder: "asc",
    caption: "Medicamentos",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_genericos','medicamento_form','id=" + id + "','Main',this)\">Editar</a>";
			
            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el Medicamento?',
        submodulo: 'deletemultiple_medicamento'
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
    x_goTo('maestros_genericos', 'medicamento_form', '', 'Main', this);
});
