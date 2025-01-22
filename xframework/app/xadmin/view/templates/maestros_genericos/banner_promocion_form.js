x_runJS();

$("#btnGuardar").click(function () {
    x_sendForm($('#f_record'), true, function (data) {
        x_alert(data.msg);
        if (data.result) {

            x_goTo('maestros_genericos', 'banner_promocion_form', 'idbanner_promocion=' + data.id, 'Main', this);
        }
        ;
    });
});