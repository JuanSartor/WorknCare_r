$(function () {

    $("#agregar_pregunta_grupo").click(function () {
        var inputpregunta = $("#inputpregunta").val();
        var inputpregunta_en = $("#inputpregunta_en").val();
          var orden = $("#orden").val();
        var cerrada;
        if ($("#cerrada_yes").is(":checked")) {
            cerrada = 1;
        }
        if ($("#cerrada_no").is(":checked")) {
            cerrada = 0;
        }

        if (inputpregunta !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=cuestionarios&submodulo=add_pregunta_cuestionario',
                    "pregunta=" + inputpregunta + "&cuestionarios_idcuestionario=" + $("#idcuestionario").val() + "&cerrada=" + cerrada + "&pregunta_en=" + inputpregunta_en
                    + "&orden=" + orden,
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('cuestionarios', 'listado_preguntas', 'cuestionarios_idcuestionario=' + $("#idcuestionario").val(), 'container_listado_preguntas');
                        }
                    }
            );
        } else {
            x_alert("Question invalide!");
        }

    });

    $("#listado_preguntas .delete_pregunta").on("click", function () {

        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");


        if ($(this).data("cerrada") == "") {
            cerrada = 0;
        } else {
            cerrada = $(this).data("cerrada");
        }

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=cuestionarios&submodulo=delete_pregunta_cuestionario',
                "idpregunta=" + id + "&cerrada=" + cerrada,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('cuestionarios', 'listado_preguntas', 'cuestionarios_idcuestionario=' + $("#idcuestionario").val(), 'container_listado_preguntas');
                    }
                }
        );
    });
});