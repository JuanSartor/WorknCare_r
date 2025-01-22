$(function () {

    $("#agregar_item_check").click(function () {
        var texto = $("#texto").val();
        var texto_en = $("#texto_en").val();
        var orden_ch = $("#orden_ch").val();

        if (texto !== "") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'xadmin.php?action=1&modulo=riesgo&submodulo=add_itemcheck_itemriesgo',
                    "texto=" + texto + "&texto_en=" + texto_en + "&orden=" + orden_ch + "&item_riesgo_iditemriesgo=" + $("#idItemRiesgo").val(),
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('riesgo', 'listado_check_item', 'item_riesgo_iditemriesgo=' + $("#idItemRiesgo").val(), 'container_listado_check');
                        }
                    }
            );
        } else {
            x_alert("Check invalide!");
        }

    });

    $("#listado_preguntas .delete_pregunta").on("click", function () {

        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");




        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=riesgo&submodulo=delete_itemcheck_itemriesgo',
                "id_check_itemriesgo=" + id,
                function (data) {
                    $("body").spin(false);
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('riesgo', 'listado_check_item', 'item_riesgo_iditemriesgo=' + $("#idItemRiesgo").val(), 'container_listado_check');
                    }
                }
        );
    });
});