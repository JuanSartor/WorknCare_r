$(function () {

    $("#listado_cuestionarios .delete_cuestionario").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        jConfirm(
                "Confirma que desea eliminar el cuestionario y sus respectivas preguntas? ",
                "Eliminar Cuestionario",
                function (r) {
                    if (r) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'xadmin.php?action=1&modulo=cuestionarios&submodulo=delete_cuestionario',
                                "idcuestionario=" + id,
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                    if (data.result) {
                                        x_loadModule('cuestionarios', 'listado_cuestionarios', 'id_familia_cuestionarios=' + $("#id_familia_cuestionarios").val(), 'container_listado_cuestionarios');
                                    }
                                }
                        );
                    }
                }
        );
    });
});