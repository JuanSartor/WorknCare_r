
x_runJS();


$("#back_hs").click(function() {
    hs.close();
});




$("#btnGuardarUsuarioPrestador").click(function () {
    x_sendForm($('#f_usuarios_prestador'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload_usuarios_prestador();
          
            hs.close();
        }
    });

});
//cambiar contraseña, generar y enviar por mail
$("#btnShowPassword").click(function () {
    $("#div_password_usuario").show();
    $("#btnResetPassword").show();
    $("#btnShowPassword").hide();
    
});
$("#btnShowPassword").show();
$("#div_password_usuario").hide();
   $("#btnResetPassword").hide();


//cambiar contraseña, generar y enviar por mail
$("#btnResetPassword").click(function () {
    if($("#password_usuario_input").val()==""){
        x_alert("Ingrese una nueva contraseña");
        return false;
    }
    jConfirm(
            "Desea gener una nueva contraseña y enviarla al usuario?",
            "Cambiar contraseña",
            function (r) {
                if (r) {
                     var password = $.trim($('#password_usuario_input').val());
                  
                  
                    var url = "xadmin.php?";
                    var queryStr = "action=1&modulo=prestadores&submodulo=change_password&idusuario_prestador=" + $("#idusuario_prestador").val()+"&password="+password;
                    x_doAjaxCall("POST",
                            url,
                            queryStr,
                            function (data) {

                                x_alert(data.msg);
                            },
                            "",
                            "",
                            true,
                            true);
                }
            }
    );
});




