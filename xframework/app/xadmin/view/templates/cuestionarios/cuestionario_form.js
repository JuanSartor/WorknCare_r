x_runJS();


$("#btnGuardar").click(function () {


    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('cuestionarios', 'cuestionario_form', 'id=' + data.id, 'Main', this);
    });

});


if ($("#idcuestionario").val() !== "") {
    x_loadModule('cuestionarios', 'listado_preguntas', 'cuestionarios_idcuestionario=' + $("#idcuestionario").val(), 'container_listado_preguntas');
}