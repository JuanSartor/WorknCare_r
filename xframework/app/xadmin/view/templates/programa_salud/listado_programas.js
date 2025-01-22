$(function () {

    $("#agregar_programa_grupo").click(function () {
        var idprograma = $("#idprograma").val();
        if (idprograma !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=add_programa_grupo',
                    "programa_salud_idprograma_salud=" + idprograma + "&programa_salud_grupo_idprograma_salud_grupo=" + $("#idprograma_salud_grupo").val(),
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('programa_salud', 'listado_programas', 'idprograma_salud_grupo=' + $("#idprograma_salud_grupo").val(), 'container_listado_programas');
                        }
                    }
            );
        }

    });

    $("#listado_programas .delete_programa").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud&submodulo=delete_programa_grupo',
                "id=" + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('programa_salud', 'listado_programas', 'idprograma_salud_grupo=' + $("#idprograma_salud_grupo").val(), 'container_listado_programas');
                    }
                }
        );
    });
});