x_runJS();
$("#modulo").val("contable");
$("#submodulo").val("solicitud_pago_medico_form");

$("#btnGuardar").click(function() {
    x_sendForm(
            $('#f_record'),
            true,
            callback_change
            );
});

var callback_change = function(data) {
    x_alert(data.msg);
    if (data.result) {
        x_loadModule('contable', 'solicitud_pago_medico_list', '', 'Main');
    }
};

$("#back").click(function() {
    x_goTo('contable', 'solicitud_pago_medico_list', '', 'Main', this);
});

$("#btnAdjuntar").click(function(){
    x_loadWindow(this, 'contable', 'solicitud_pago_medico_factura_form', 'id=" + id + "', 800, 400);
})



