$(function () {

    $("#agregar_medico_referente").click(function () {
        var idmedico = $("#referente_medico_idmedico").val();
        if (idmedico !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=add_medico_referente',
                    "medico_idmedico=" + idmedico + "&programa_categoria_idprograma_categoria=" + $("#idprograma_categoria").val(),
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('programa_salud', 'listado_medicos_referentes', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_referentes');
                            x_loadModule('programa_salud', 'listado_medicos_complementarios', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_complementarios');

                        }
                    }
            );
        }

    });

    $("#listado_medicos_referente .delete_medico").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=delete_medico_referente',
                "idprograma_medico_referente=" + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('programa_salud', 'listado_medicos_referentes', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_referentes');
                        x_loadModule('programa_salud', 'listado_medicos_complementarios', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_complementarios');

                    }
                }
        );


    });
});