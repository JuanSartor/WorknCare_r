$("#modulo").val("contable");
$("#submodulo").val("recaudaciones");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Nombre Médico', 'CUIT', 'Método Cobro', 'Nombre Banco', 'Período', 'Importe a pagar','Comisión DP',  'Solicitud pago','Estado Pago'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: false, align: "center", sortable: false},
      
        {name: 'nombre_medico', index: 'nombre_medico', width: 100, align: "center", sortable: false},
        {name: 'CUIT', index: 'CUIT', width: 100, align: "center", sortable: false},
        {name: 'metodo_cobro_format', index: 'metodo_cobro', width: 100, align: "center", sortable: false},
        {name: 'nombre_banco', index: 'nombre_banco', width: 100, align: "center", sortable: false},
        {name: 'date_periodo', index: 'date_periodo', width: 100, align: "center", sortable: false},
        {name: 'importePeriodo', index: 'importePeriodo', width: 100, align: "center", sortable: false},
        {name: 'comisiónPeriodo', index: 'comisiónPeriodo', width: 100, align: "center", sortable: false},
        {name: 'fechaSolicitudPago_format', index: 'fechaSolicitudPago', width: 50, align: "center", sortable: false},
        {name: 'estado_pago', index: 'spm.estado', width: 100, align: "center", sortable: false}  
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'pp.anio desc,pp.mes desc,nombre_medico',
    viewrecords: true,
    sortorder: "desc",
    caption: "Recaudaciones",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    loadComplete: function (data) {
                if (data.total_recaudacion != "undefined") {
                    $("#span_total_recaudacion").html(data.total_recaudacion.toFixed(2));
                }
                if (data.total_pagado != "undefined") {
                    $("#span_total_pagado").html(data.total_pagado.toFixed(2));
                }
                if (data.total_pendiente != "undefined") {
                    $("#span_total_pendiente").html(data.total_pendiente.toFixed(2));
                }        
                if (data.total_retenido != "undefined") {
                    $("#span_total_retenido").html(data.total_retenido.toFixed(2));
                }       
                  if (data.total_comisiones != "undefined") {
                    $("#span_total_comisiones").html(data.total_comisiones.toFixed(2));
                }       
            },
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Ver resumen del período\" onclick=\"ver_periodo_pago_pdf(" + id + ")\"><img src=\"xframework/app/themes/admin/imgs/action_ico_pdf.png\" />";

            $("#list").jqGrid('setRowData', ids[i], {act: be });
        }
    }
}).jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
//funcion para visualizar elresumen del periodo de pago en PDF del medico seleccionado
function ver_periodo_pago_pdf(id){
    $("#idperiodoPago").val(id);
    $("#f_pdf").submit();
}

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