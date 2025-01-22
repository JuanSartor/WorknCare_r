$("#modulo").val("contable");
$("#submodulo").val("consultas_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Nombre Médico', 'Nombre Paciente', 'Tipo Consulta', 'Nº', 'Fecha', 'Importe','Comisión','Importe prestador','Comisión prestador', 'Estado'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: true, align: "center", sortable: false},
      
        {name: 'nombre_medico', index: 'nombre_medico', width: 100, align: "left", sortable: false},
        {name: 'nombre_medico', index: 'nombre_medico', width: 100, align: "left", sortable: false},
        {name: 'tipo_consulta', index: 'tipo_consulta', width: 100, align: "center", sortable: false},
        {name: 'numero_consulta', index: 'nombre_banco', width: 100, align: "center", sortable: false},
        {name: 'fecha_str', index: 'fecha_inicio', width: 100, align: "center", sortable: false},
        {name: 'importe', index: 'importe', width: 100, align: "right", sortable: false},
        {name: 'comision_dp', index: 'comision_dp', width: 100, align: "right", sortable: false},
      {name: 'importe_prestador', index: 'importe_prestador', width: 100, align: "right", sortable: false},
        {name: 'comision_prestador', index: 'comision_prestador', width: 100, align: "right", sortable: false},
        {name: 'estado_consulta', index: 'estado_consulta', width: 100, align: "center", sortable: false}  
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'fecha_inicio',
    viewrecords: true,
    sortorder: "desc",
    caption: "Listado de consultas",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
   
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

        }
    }
}).jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});

$("#btnFilter").click(function() {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function() {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});