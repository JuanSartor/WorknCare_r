$(function () {


    $("#listado_preguntas .delete_pregunta").on("click", function () {

        if ($(this).data("id") == "") {
            x_alert("Error");
            return false;
        }
        var id = $(this).data("id");


        x_doAjaxCall(
                'POST',
                BASE_PATH + 'xadmin.php?action=1&modulo=riesgo&submodulo=delete_itemRiesgo',
                "idItemRiesgo=" + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_loadModule('riesgo', 'listado_item_familia', 'familia_riesgo_idfamiliariesgo=' + $("#idfamilia_riesgo").val(), 'container_listado_items');
                    }
                }
        );
    });
});