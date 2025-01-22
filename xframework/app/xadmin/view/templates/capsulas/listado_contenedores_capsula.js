$(function () {

    $("#listado_contenedores .delete_cuestionario").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        jConfirm(
                "Confirma que desea eliminar el contenedor y sus respectivas capsulas? ",
                "Eliminar Ccontenedor",
                function (r) {
                    if (r) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'xadmin.php?action=1&modulo=capsulas&submodulo=deletemultiple_contenedor_capsula_grupo',
                                "ids=" + id,
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                    if (data.result) {
                                        x_loadModule('capsulas', 'listado_contenedores_capsula', 'id_familia_capsula=' + $("#id_familia_capsula").val(), 'container_listado_contenedores_capsulas');
                                    }
                                }
                        );
                    }
                }
        );
    });
});