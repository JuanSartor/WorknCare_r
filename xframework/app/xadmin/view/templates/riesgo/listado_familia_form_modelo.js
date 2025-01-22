$(function () {

    $("#listado_cuestionarios .delete_cuestionario").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");
        var idmodelo = $(this).data("idmodelo");
        jConfirm(
                "Confirma que desea eliminar la familia asociada a este modelo? ",
                "Eliminar Familia",
                function (r) {
                    if (r) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'xadmin.php?action=1&modulo=riesgo&submodulo=delete_familia_modelo',
                                "idfamilia_riesgo=" + id + "&idmodelo=" + idmodelo,
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                    if (data.result) {
                                        x_loadModule('riesgo', 'listado_familia_form_modelo', 'idmodelos_riesgos=' + $("#idmodelos_riesgos").val(), 'container_listado_cuestionarios');
                                    }
                                }
                        );
                    }
                }
        );
    });
});