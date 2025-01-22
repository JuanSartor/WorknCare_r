$("#modulo").val("contable");
$("#submodulo").val("solicitud_pago_medico_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Fecha','Nombre Médico', 'CUIT', 'Método Cobro', 'Nombre Banco', 'Período', 'Importe a pagar','Comisión DP',  'Estado Pago'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: false, align: "center", sortable: false},
        {name: 'fechaSolicitudPago_format', index: 'fechaSolicitudPago', width: 50, align: "center", sortable: false},
        {name: 'nombre_medico', index: 'nombre_medico', width: 100, align: "center", sortable: false},
        {name: 'CUIT', index: 'CUIT', width: 100, align: "center", sortable: false},
        {name: 'metodo_cobro_format', index: 'metodo_cobro', width: 100, align: "center", sortable: false},
        {name: 'nombre_banco', index: 'nombre_banco', width: 100, align: "center", sortable: false},
        {name: 'date_periodo', index: 'date_periodo', width: 100, align: "center", sortable: false},
        {name: 'importePeriodo', index: 'importePeriodo', width: 100, align: "center", sortable: false},
        {name: 'comisiónPeriodo', index: 'comisiónPeriodo', width: 100, align: "center", sortable: false},
        {name: 'estado_pago', index: 'spm.estado', width: 100, align: "center", sortable: false}
      
       
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'fechaSolicitudPago',
    viewrecords: true,
    sortorder: "desc",
    caption: "Solicitud Pago",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    loadComplete: function (data) {
                if (data.total_solicitudes != "undefined") {
                    $("#span_total_solicitudes").html(data.total_solicitudes);
                }
                if (data.total_pagado != "undefined") {
                    $("#span_total_pagado").html(data.total_pagado);
                }
                if (data.total_pendiente != "undefined") {
                    $("#span_total_pendiente").html(data.total_pendiente);
                }        
                if (data.total_retenido != "undefined") {
                    $("#span_total_retenido").html(data.total_retenido);
                }       
                  if (data.total_comisiones != "undefined") {
                    $("#span_total_comisiones").html(data.total_comisiones);
                }       
            },
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('contable','solicitud_pago_medico_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" />";

            $("#list").jqGrid('setRowData', ids[i], {act: be });
        }
    }
});


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