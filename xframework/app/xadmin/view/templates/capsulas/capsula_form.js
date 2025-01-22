x_runJS();


$("#btnGuardar").click(function () {


    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('cuestionarios', 'cuestionario_form', 'id=' + data.id, 'Main', this);
    });

});


$("#tipoCapsula").change(function () {
    tipo = $("#tipoCapsula").val();
    if (tipo == '1') {
        $('#filediv').css('display', 'block');
        $('#linkdiv').css('display', 'none');
        $('#videodiv').css('display', 'none');
        $('#grabaciondiv').css('display', 'none');
    } else if (tipo == '2') {
        $('#filediv').css('display', 'none');
        $('#linkdiv').css('display', 'block');
        $('#videodiv').css('display', 'none');
        $('#grabaciondiv').css('display', 'none');
    } else if (tipo == '3') {
        $('#filediv').css('display', 'none');
        $('#linkdiv').css('display', 'none');
        $('#videodiv').css('display', 'block');
        $('#grabaciondiv').css('display', 'none');
    } else {
        $('#filediv').css('display', 'none');
        $('#linkdiv').css('display', 'none');
        $('#videodiv').css('display', 'none');
        $('#grabaciondiv').css('display', 'block');
    }
});