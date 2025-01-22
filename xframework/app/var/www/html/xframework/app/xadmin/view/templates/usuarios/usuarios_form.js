x_runJS();


$("#btnGuardar").click(function () {

    if ($("#idperfil").val() == "") {
        x_alert("Debe seleccionar el perfil del usuario");
        return false;
    }


    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'usuarios', 'submodulo': 'usuarios_list'});

});



$("#agregar_usuario_menu").click(function () {
    if ($("#usuario_menu_idusuario_menu").val() == "") {
        x_alert("Seleccione acceso");
        return false;
    }
    //verificamos si ya existe
    var idusuario_menu = $("#usuario_menu_idusuario_menu").val();
    if ($("#listado_usuario_acceso li[data-usuario-menu='" + idusuario_menu + "']").length > 0) {
        x_alert("Ya se ha agregado este acceso");
        return false;
    }
    var nombre_menu = $("#usuario_menu_idusuario_menu option:selected").text();

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=usuarios&submodulo=usuario_acceso_add&usuario_menu_idusuario_menu=" + $("#usuario_menu_idusuario_menu").val() + "&usuario_idusuario=" + $("#idusuario").val();

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //agregar especialidad
                    $("#listado_usuario_acceso").show();
                    $("#listado_usuario_acceso ul").append($('<li data-id="' + data.id + '" data-usuario-menu="' + idusuario_menu + '" class="usuario_acceso"><span class="delete_menu" data-id="' + data.id + '" title="Eliminar"> X </span> ' + nombre_menu + '</li>'));

                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});

$("#listado_usuario_acceso").on("click", ".delete_menu", function () {
    if ($(this).data("id") == "") {
        x_alert("Error");
        return false;
    }
    var id = $(this).data("id");

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=usuarios&submodulo=usuario_acceso_delete&id=" + id;

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    //eliminar especialidad
                    $("li.usuario_acceso[data-id='" + id + "']").remove();
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);

});






