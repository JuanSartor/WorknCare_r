$(function () {

    $("#agregar_programa_grupo").click(function () {
        var idprograma = $("#idprograma").val();
        if (idprograma !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud_grupo_empresa&submodulo=add_programa_grupo_empresa',
                    "programa_salud_idprograma_salud=" + idprograma + "&programa_salud_grupo_empresa_idprograma_salud_grupo_empresa=" + $("#idprograma_salud_grupo_empresa").val(),
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('programa_salud_grupo_empresa', 'listado_programas_empresa', 'idprograma_salud_grupo_empresa=' + $("#idprograma_salud_grupo_empresa").val(), 'container_listado_programas_empresa');
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
                BASE_PATH + 'xadmin.php?action=1&modulo=programa_salud_grupo_empresa&submodulo=delete_programa_grupo_empresa',
                "id=" + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('programa_salud_grupo_empresa', 'listado_programas_empresa', 'idprograma_salud_grupo_empresa=' + $("#idprograma_salud_grupo_empresa").val(), 'container_listado_programas_empresa');
                    }
                }
        );
    });
});