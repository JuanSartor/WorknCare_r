x_runJS();


$("#btnGuardar").click(function () {


    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('programa_salud', 'programa_salud_form', 'id=' + data.id, 'Main', this);
    });

});
if ($("#idprograma_salud").val() !== "") {
    x_loadModule('programa_salud', 'categoria_list', 'idprograma_salud=' + $("#idprograma_salud").val(), 'categorias_list_container');
}




