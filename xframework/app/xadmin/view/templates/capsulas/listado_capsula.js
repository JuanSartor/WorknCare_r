$(function () {

    $("#listado_capsulas .delete_capsula").on("click", function () {
        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");

        jConfirm(
                "Confirma que desea eliminar la capsula? ",
                "Eliminar Capsula",
                function (r) {
                    if (r) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'xadmin.php?action=1&modulo=capsulas&submodulo=deletemultiple_capsulas',
                                "ids=" + id,
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                    if (data.result) {
                                        x_loadModule('capsulas', 'listado_capsula', 'contenedorcapsula_idcontenedorcapsula=' + $("#contenedorcapsula_idcontenedorcapsula").val(), 'container_listado_capsulas');
                                    }
                                }
                        );
                    }
                }
        );
    });
});