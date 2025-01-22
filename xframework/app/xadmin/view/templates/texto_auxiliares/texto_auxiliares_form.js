x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('texto_auxiliares', 'texto_auxiliares_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});


