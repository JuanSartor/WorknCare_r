/******************************************************************************
 *
 *  Funciones de xadmin
 *
 ******************************************************************************/
/**
 * doAdd
 *
 **/
var doAdd = function (json, params) {

    if (!json.result) {
        if (typeof (json.spry_msg) != "undefined") {
            x_assignMsgVars(json.spry_msg);
        } else {
            x_alert(json.msg);
        }
    } else {
        if (json.result) {

            x_alert(json.msg);

            if (typeof (params.modulo) != "undefined" && typeof (params.modulo) != "undefined") {
                x_loadModule(params.modulo, params.modulo, '', 'Main');
            } else {
                x_loadModule($('#modulo').val(), $('#submodulo').val(), '', 'Main');
            }
        } else {
            x_alert("Error, Por favor, intente nuevamente mas tarde.");
        }
    }

}

/**
 * doAddReloadParams
 *
 **/
var doAddReloadParams = function (json) {

    var cadena = x_evalAjaxResponse(responseText);

    if (!json.result) {
        if (typeof (json.spry_msg) != "undefined") {
            x_assignMsgVars(json.spry_msg);
        } else {
            x_alert(json.msg);
        }
        ;
    } else {
        if (json.result) {
            x_alert(json.msg);
            x_loadModule($('#modulo').val(), $('#submodulo').val(), $('#paramsReload'), 'Main');
        } else {
            x_alert("Error, Por favor, intente nuevamente mas tarde.");
        }
    }

}

/**
 * doAddFromWindow
 *
 **/
var doAddFromWindow = function (json, params) {

    //modulo y submodulo

    if (!json.result) {
        if (typeof (json.spry_msg) != "undefined") {
            x_assignMsgVars(json.spry_msg);
        } else {
            x_alert(json.msg);
        }
    } else {
        if (json.result) {
            x_alert(json.msg);

            if ($('#paramsReloadWindow').length > 0) {
                var paramsSend = $('#paramsReloadWindow').val();
            } else {
                var paramsSend = "";
            }

            var container = "Main";

            if (typeof (params.container) != "undefined") {
                container = params.container;
            }

            x_loadModule(params.modulo, params.submodulo, paramsSend, 'Main');

            hs.close();
        } else {
            x_alert("Error, Por favor, intente nuevamente mas tarde.");
        }
    }

}
/**
 * doAddFromCombo
 *
 **/
/*function doAddFromCombo(responseText,params){
 
 //container , manager y metodo
 var mod = params.split(",");
 
 var cadena = x_evalAjaxResponse(responseText);
 
 if (cadena['false']!=""){
 x_assignMsgVars(cadena['false']);
 }else{
 if (cadena['true']!=""){
 var id = cadena['true'];
 var params = "manager="+mod[1]+"&function="+mod[2]+"&id="+id+"&idcombo="+mod[3];
 x_loadModule("combo","combo",params,'select_container_'+mod[0],"common");
 hs.close();
 }else{
 x_alert("Error, Por favor, intente nuevamente mas tarde.");
 }
 }
 
 }*/



/**
 * doModify
 *
 **/
var doModify = function (json, params) {

    if (!json.result) {
        if (typeof (json.spry_msg) != "undefined") {
            x_assignMsgVars(json.spry_msg);
        } else {
            x_alert(json.msg);
        }
    } else {

        if (json.result && json.msg == "ok") {
            x_alert("Modificado con &eacute;xito");
            x_loadModule(params.modulo, params.submodulo, '', 'Main');
        } else {
            if (json.result != "") {
                x_alert(json.msg);
                x_loadModule(params.modulo, params.submodulo, '', 'Main');
            } else
                x_alert("ERror");
        }
    }

}

/**
 * doModifyFromWindow
 *
 **/
var doModifyFromWindow = function (json, params) {


    if (!json.result) {
        if (typeof (json.spry_msg) != "undefined") {
            x_assignMsgVars(json.spry_msg);
        } else {
            x_alert(json.msg);
        }

    } else {

        if ($('#paramsReloadWindow').length > 0) {
            var paramsSend = $('#paramsReloadWindow').val();
        } else {
            var paramsSend = "";
        }

        var container = "Main";

        if (typeof (params.container) != "undefined") {
            container = params.container;
        }

        if (json.msg == "ok") {

            x_alert("Modificado con &eacute;xito");

            x_loadModule(params.modulo, params.submodulo, paramsSend, container);

            hs.close();
        } else {
            if (json.msg != "") {
                x_alert(json.msg);
                x_loadModule(params.modulo, params.submodulo, paramsSend, container);
                hs.close();
            } else {
                x_alert("Error");
            }
        }
    }

}



/**
 * drop
 * parametros 
 * id: id del registro a eliminar
 * modulo: modulo (opcional)
 * submodulo: submodulo (opcional)
 * container: contenedor para regarga (opcional)                         
 *
 **/
var drop = function (params) {

    var params = $.extend({pregunta: "�Desea eliminar el Registro?", titulo: "Eliminar"}, params);

    jConfirm(
            params.pregunta,
            params.titulo,
            function (r) {
                if (r) {

                    params = $.extend({modulo: $("#modulo").val(), submodulo: "drop", container: "Main"}, params);

                    var url = controller + ".php?";
                    var queryStr = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&id=" + params.id;

                    x_doAjaxCall("POST", url, queryStr, doDrop, params, "", true, true);

                }
            }
    );


}

/**
 * doDrop
 *
 **/
var doDrop = function (json, params) {

    if (!json.result) {

        x_alert(json.msg);

    } else {
        if (json.result) {

            //parametros alternativos
            var params = $.extend({container: "Main", callback: null}, params);

            if (params.callback == null) {

                if ($('#paramsReload').length > 0) {
                    var paramsSend = "&" + $('#paramsReload').val();
                } else {
                    var paramsSend = "";
                }
                x_alert(json.msg);

                x_loadModule($('#modulo').val(), $('#submodulo').val(), 'reload=1' + paramsSend, params.container);
            } else {

                x_alert(json.msg);

                params.callback();
            }

        } else {
            x_alert("Error");
        }
    }
}

/**
 * suspend
 *
 **/
var suspend = function (params) {

    if (confirm('Suspender este registro?')) {

        var params = $.extend({modulo: $("#modulo").val(), submodulo: "suspend", container: "Main"}, params);

        var url = controller + ".php?";
        var params = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&id=" + params.id;
        x_doAjaxCall("POST", url, params, doDrop, params, "", true, true);

    }
}


/**
 * activate
 *
 **/
var activate = function (params) {

    if (confirm('Activar este registro?')) {

        var params = $.extend({modulo: $("#modulo").val(), submodulo: "activate", container: "Main"}, params);

        var url = controller + ".php?";
        var params = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&id=" + params.id;
        x_doAjaxCall("POST", url, params, doDrop, params, "", true, true);

    }
}


/**
 *  -------
 *
 **/
var sortElements = function (secuence, type) {

    var secuenceSorted = $(secuence).sortable("serialize")
    x_doAjaxCall("post", "common.php?action=1&modulo=common&submodulo=sort", secuenceSorted + "&tipo=" + type, {}, {}, "", true, false);

}


/**
 *  Mestra un mensaje.
 *
 **/
var x_alert = function (msg) {
    console.log("traudcciones");
    console.log(translations);
    if(msg==undefined){
        return false;
    }
    if (typeof translations != 'undefined') {

        //verificamos la ocurrencia de los caracteres [[ ]] que indican un texto variable

        if (msg.indexOf("[[") > -1 && msg.indexOf("]]") > -1) {

            //cortamos el texto variable para buscar la traduccion con la mascara [[%s]] en la posicion del texto variable
            var init = msg.indexOf("[[");
            var end = msg.indexOf("]]");
            //guardamos el texto a reemplazar
            var texto_variable = msg.substring(init + 2, end);

            msg = msg.replace(texto_variable, "%s");
            //buscamos la traduccion y reemplazamos el texto variabke
            if (translations[msg] != undefined) {
                var msg = translations[msg];
                msg = msg.replace("[[%s]]", texto_variable);
            }
        } else {
            if (typeof translations[msg] !== 'undefined') {
                var msg = translations[msg];
            }
        }

    }
    jQuery.msg({
        fadeIn: 500,
        fadeOut: 200,
        timeOut: 5000,
        content: msg
    });

}



var showHideForgotPass = function () {
    if ($('#f_forgot').is(":visible")) {
        $('#f_forgot').hide();
        $('#f_login').show();

    } else {
        $('#f_forgot').show();
        $('#f_login').hide();
    }
}



/**
 * REaliz baja de multiples archivos
 *
 *
 */
var x_deleteMultiple = function (params) {


    var params = $.extend({pregunta: "�Desea eliminar los registros seleccionados?", titulo: "Eliminar"}, params);

    jConfirm(
            params.pregunta,
            params.titulo,
            function (r) {
                if (r) {

                    if (params.ids != "") {

                        params = $.extend({modulo: $("#modulo").val(), submodulo: "deletemultiple", container: "Main"}, params);

                        var url = controller + ".php?";
                        var queryStr = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&ids=" + params.ids;

                        x_doAjaxCall("POST", url, queryStr, doDrop, params, "", true, true);
                    } else {
                        x_alert("No hay registros seleccionados");
                    }
                }
            }
    );

    return;

}

/**
 * doDrop
 *
 **/
/* var do_x_deleteMultiple = function(json,params){
 
 params = $.extend({container:"Main"},params);
 
 if (!json.result){
 x_alert(json.msg);
 }else{
 if ( json.result ){
 
 //parametros alternativos
 
 if ($('#paramsReload').length > 0 ){
 var paramsSend = "&"+$('#paramsReload').val();
 }else{
 var paramsSend = "";
 }
 
 x_alert(json.msg);
 
 x_loadModule($('#modulo').val(),$('#submodulo').val(),'reload=1'+paramsSend,params.container);
 
 }else{
 x_alert("Error");
 }
 }
 }*/


/**
 * Order up
 * params
 * id
 * modulo
 * submodulo
 * func_reload                         
 *
 **/
function orderUp(params) {


    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&do_action=up&id=" + params.id;
    x_doAjaxCall("POST", url, queryStr, doOrder, params, "", true, true);

}


/**
 * Order up
 *
 **/
function orderDown(params) {

    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=" + params.modulo + "&submodulo=" + params.submodulo + "&do_action=down&id=" + params.id;
    x_doAjaxCall("POST", url, queryStr, doOrder, params, "", true, true);

}

/*function setOrder(id,order,modulo,submodulo){
 
 if( typeof(modulo)== "undefined"){
 modulo = "usuarios";
 }
 if( typeof(submodulo)== "undefined"){
 submodulo = "order";
 }
 
 var url = "xadmin.php?";
 var params = "action=1&modulo="+modulo+"&submodulo="+submodulo+"&do_action=set_order&id="+id+"&order="+order;
 x_doAjaxCall("POST", url, params, "doOrder" ,"","", true,true );
 
 }*/

function doOrder(json, params) {

    if (!json.result) {

        x_alert(json.msg);

    } else {
        if (json.result) {

            //console.debug(params.func_reload+"()");
            x_alert(json.msg);

            eval(params.func_reload + "()");

        } else {
            x_alert("Error");
        }
    }
}

/******************************************************************************
 *
 *
 *                              LOGIN 
 *
 *
 *****************************************************************************/

/**
 * doForgotPass
 *
 **/
var doForgotPass = function (json) {


    if (!json.result) {
        x_alert(json.msg);
    } else if (json.result) {

        showHideForgotPass();

        $("#f_forgot").each(function () {
            this.reset()
        })

        x_alert("Se ha enviado un email para resetear su contrase&ntilde;a");
    }

}

/**
 * doForgotPass
 *
 **/
var doResetPass = function (json) {


    if (!json.result) {
        x_alert(json.msg);
    } else if (json.result) {
        //oculta el div y muesra el mensaje
        x_alert(json.msg);

        window.location.href = controller + ".php";
    }

}

/**
 * doForgotPass
 *
 **/
var doSignUp = function (responseText) {


}

/**
 * doForgotPass
 *
 **/
var changePass = function (formulario) {

    if (x_validateForm(formulario)) {
        if ($('#newPassword_input').val() != $('#confirm_password_input').val()) {
            x_alert("Las Passwords no coinciden");
            return;
        } else {
            $('#confirm_password_input').val("xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            $('#newPassword_input').val(Base64.encode(SHA1($('#newPassword_input').val())));
            $('#oldPassword_input').val(Base64.encode(SHA1($('#oldPassword_input').val())));
            x_sendForm(formulario, true, doChangePass);
        }
    }
}

/**
 * doForgotPass
 *
 **/
var changePassReset = function (formulario) {

    if (x_validateForm(formulario)) {
        if ($('#newPassword_input').val() != $('#confirm_password_input').val()) {
            x_alert("Las Passwords no coinciden");
            return;
        } else {
            $('#confirm_password_input').val("xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            $('#newPassword_input').val(Base64.encode(SHA1($F('newPassword_input'))));
            x_sendForm(formulario, true, doChangePass);
        }
    }
}

/**
 * doForgotPass
 *
 **/
var doChangePass = function (json) {

    if (!json.result) {

        x_alert(json.msg);

        $('#confirm_password_input').val("");
        $('#newPassword_input').val("");
        if ($('#oldPassword_input').length > 0) {
            $('#oldPassword_input').val("");
        }
        //x_loadModule("xadmin_users","changepass","","content");            
    } else {
        if (json.msg == "ok") {
            x_alert("Contraseña actualizada con éxito");
            window.location.reload();
        }
    }
}

/**
 * @author Sebastian Balestrini <sbalestrini@gmail.com>
 *
 * Cierra la sesi�n de xadmin
 */
var x_LogOut = function () {

    jConfirm(
            "¿Desea cerrar su sesión?",
            "Salir",
            function (r) {
                if (r) {
                    var url = "xadmin.php?";
                    var params = "action=1&modulo=login&submodulo=logout&";
                    x_doAjaxCall("POST", url, params, x_doLogOut, "", "", true, true);
                }
            }
    );


}

var x_doLogOut = function (json) {

    window.location = 'xadmin.php';

}

