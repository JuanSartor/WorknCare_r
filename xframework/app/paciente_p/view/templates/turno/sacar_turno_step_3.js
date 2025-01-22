
$(document).ready(function () {
    scrollToEl($("body"));
    $(".ce-nc-steps li.ce-nc-step").eq(2).addClass("actual");
    $("#Main").spin(false);

    $("#btnEnviarComentario").click(function () {
        if ($("#txt_comentario").val() == "") {
            x_alert(x_translate("Ingrese en texto del comentario"));
            return false;
        }
        $("#Main").spin("large");
        x_sendForm(
                $('#f_comentario'),
                true,
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        $("#comentario_send").html($("#txt_comentario").val());
                        $("#div_comentario").html("");
                        x_alert(x_translate("Se envió el comentario correctamente. Gracias por utilizar nuestros servicios"), function () {

                            recargar(BASE_PATH + "panel-paciente/home.html");
                        });
                        $("#comentario_send").parent().slideDown();
                    } else {
                        x_alert(x_translate("Se produjo un error al enviar el comentario. Intente nuevamente"));
                    }
                }
        );
    });

});