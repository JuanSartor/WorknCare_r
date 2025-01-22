$("#modulo").val("contable");
$("#submodulo").val("comprobante_pago_cuenta_profesional");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_comprobante").attr("action") + "&do_reset=1&" + $("#f_comprobante").serialize(),
    datatype: "json",
    colNames: ['', 'Medico', 'CUIT', 'Inicio suscripcion', 'Fin suscripcion', 'Cuota', 'Fecha pago', 'Estado', 'Comprobante'],
    colModel: [
        {name: 'act', index: 'act', width: 25, hidden: false, align: "center", sortable: false},
        {name: 'nombre_medico', index: 'nombre_medico', width: 150, align: "center", sortable: false},
        {name: 'CUIT', index: 'CUIT', width: 100, align: "center", sortable: false},
        {name: 'inicio_suscripcion_format', index: 'inicio_suscripcion', width: 100, align: "center", sortable: false},
        {name: 'fin_suscripcion_format', index: 'fin_suscripcion', width: 100, align: "center", sortable: false},
        {name: 'cuota', index: 'cuota', width: 100, align: "center", sortable: false},
        {name: 'fecha_pago_format', index: 'fecha_pago', width: 100, align: "center", sortable: false},
        {name: 'estado', index: 'estado', width: 100, align: "center", sortable: false},
        {name: 'posee_file', index: 'posee_file', width: 100, align: "center", sortable: false}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'fecha_pago',
    viewrecords: true,
    sortorder: "desc",
    caption: "Cuotas",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function() {
        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'contable', 'comprobante_pago_form', 'id=" + id + "', 800, 400);\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" />";
            bpdf = "-";
            
            if (parseInt(rowData.posee_file) == 1) {
                bpdf = "<a href=\"" + BASE_PATH + "xframework/files/entities/cuotas/" + id + "/" + id + ".pdf\" target='_blank' title=\"ver_pdf\" ><img src=\"xframework/app/themes/admin/imgs/action_ico_pdf.png\" />";
            }

            $("#list").jqGrid('setRowData', ids[i], {act: be, posee_file: bpdf});
        }
    }
});


$("#btnFilter").click(function() {

    $("#list").jqGrid('setGridParam', {url: $("#f_comprobante").attr("action") + "&do_reset=1&" + $("#f_comprobante").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_comprobante").attr("action") + "&do_reset=0&" + $("#f_comprobante").serialize(), page: 1});
});

$("#btnLimpiar").click(function() {

    $("#f_comprobante").clearForm();


    //actualizo uniform

    $.uniform.update("#f_comprobante :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_comprobante").attr("action") + "&do_reset=1&" + $("#f_comprobante").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_comprobante").attr("action") + "&do_reset=0&" + $("#f_comprobante").serialize(), page: 1});
});