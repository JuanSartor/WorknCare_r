$(function () {

    $("#agregar_medico_complementario").click(function () {
        var idmedico = $("#complementario_medico_idmedico").val();
        if (idmedico !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=add_medico_complementario',
                    "medico_idmedico=" + idmedico + "&programa_categoria_idprograma_categoria=" + $("#idprograma_categoria").val(),
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('programa_salud', 'listado_medicos_complementarios', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_complementarios');
                            x_loadModule('programa_salud', 'listado_medicos_referentes', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_referentes');
                        }
                    }
            );
        }

    });

    $("#listado_medicos_complementario .delete_medico").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=delete_medico_complementario',
                "idprograma_medico_complementario=" + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('programa_salud', 'listado_medicos_complementarios', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_complementarios');
                        x_loadModule('programa_salud', 'listado_medicos_referentes', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_referentes');

                    }
                }
        );


    });

});