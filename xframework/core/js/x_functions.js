/******************************************************************************
 *
 *  Funciones globales
 *
 ******************************************************************************/

var x_evaluateIntroKey = function (e) {

    if (e && e.which) { //mozilla
        e = e
        characterCode = e.which
    } else {
        if (typeof event == "undefined")
            return;
        e = event
        characterCode = e.keyCode //IE
    }

    if (characterCode == 13)
        return true;
    else
        return false;

}
function getScrollBarWidth() {
    var inner = document.createElement('p');
    inner.style.width = "100%";
    inner.style.height = "200px";

    var outer = document.createElement('div');
    outer.style.position = "absolute";
    outer.style.top = "0px";
    outer.style.left = "0px";
    outer.style.visibility = "hidden";
    outer.style.width = "200px";
    outer.style.height = "150px";
    outer.style.overflow = "hidden";
    outer.appendChild(inner);

    document.body.appendChild(outer);
    var w1 = inner.offsetWidth;
    outer.style.overflow = 'scroll';
    var w2 = inner.offsetWidth;
    if (w1 == w2)
        w2 = outer.clientWidth;

    document.body.removeChild(outer);

    return (w1 - w2);
}


function getViewportWidth() {
    return $(window).width() + getScrollBarWidth();
}

// va directo al elemento sin el top
var scrollToEl = function (trgObj) {
    var trgObjHeight = trgObj.outerHeight();
    $('html, body').animate({
        scrollTop: trgObj.offset().top - 150
    }, 1000);

}


/**
 * valida un CBU
 * devuelve true o false, según cómo resulta la validación
 */
function validarCBU(cbu) {

    if (cbu.length < 22) {
        //alert('Por favor, ingrese el CBU correctamente');
        return false;
    }

    var ponderador;
    ponderador = '97139713971397139713971397139713';

    var i;
    var nDigito;
    var nPond;
    var bloque1;
    var bloque2;

    var nTotal;
    nTotal = 0;

    bloque1 = '0' + cbu.substring(0, 7);

    for (i = 0; i <= 7; i++) {
        nDigito = bloque1.charAt(i);
        nPond = ponderador.charAt(i);
        nTotal = nTotal + (nPond * nDigito) - ((Math.floor(nPond * nDigito / 10)) * 10);
    }

    i = 0;

    while (((Math.floor((nTotal + i) / 10)) * 10) != (nTotal + i)) {
        i = i + 1;
    }

    // i = digito verificador

    if (cbu.substring(7, 8) != i) {
        //alert('Por favor, ingrese un CBU válido');
        return false;
    }

    nTotal = 0;

    bloque2 = '000' + cbu.substring(8, 21);

    for (i = 0; i <= 15; i++) {
        nDigito = bloque2.charAt(i);
        nPond = ponderador.charAt(i);
        nTotal = nTotal + (nPond * nDigito) - ((Math.floor(nPond * nDigito / 10)) * 10);
    }

    i = 0;

    while (((Math.floor((nTotal + i) / 10)) * 10) != (nTotal + i)) {
        i = i + 1;
    }

    // i = digito verificador

    if (cbu.substring(21, 22) != i) {
        //alert('Por favor, ingrese un CBU válido');
        return false;
    }

    return true;
}//fin validarCBU

//scroll hasta el ultimo mensaje de la VC o CE
function scrollToLastMsg(trgObj) {
    var element = 120;
    var cant = trgObj.find(".chat-row").length - 2;

    trgObj.find(".mCSB_container").css("top", '-' + cant * element + 'px');
    trgObj.find(".mCSB_dragger mCSB_dragger_onDrag").css("top", "400px");
}
/**
 * Método que redirgige al usuario a la seccion especifica del sitio indicado en la data de la notificacion
 * @param {type} data informacion de tipo de notificacion para redirigir
 * @returns {undefined}
 */
function redireccion_notify(data) {

    //redireccion conclusion onclick
    if ((data.type == "ce_finalizada" || data.type == "vc_finalizada") && data.id != "") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "patient/profil-de-sante/consultations-realisees-detail/" + data.id;
        });
    }
    //redireccion paciente a consultorio virutal
    if (data.type == "ingreso_sala") {
        $(".notifyjs-wrapper").first().click(function () {
            window.location.href = BASE_PATH + "patient/video-consultation/salle-virtuelle/";
        });
    }

    //redireccion nueva ce medico
    if (data.type == "nueva-ce" && data.id != "") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-medico/consultaexpress/pendientes-" + data.id + ".html";
        });
    }
    //redireccion nueva ce medico
    if (data.type == "nueva-ce-red") {
        $(".notifyjs-wrapper").first().click(function () {
            window.location.href = BASE_PATH + "panel-medico/consultaexpress/red.html";
        });
    }
    //redireccion nueva vc medico
    if (data.type == "nueva-vc" && data.id != "") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-medico/videoconsulta/pendientes-" + data.id + ".html";
        });
    }
    //redireccion nueva ce medico
    if (data.type == "nueva-vc-red") {
        $(".notifyjs-wrapper").first().click(function () {
            window.location.href = BASE_PATH + "panel-medico/videoconsulta/red.html";
        });
    }

    //redireccion vc acpetada - paciente sala espera
    if (data.type == "vc_aceptada") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-paciente/videoconsulta/sala-espera.html";
        });
    }

    //redireccion nuevo msj CE paciente
    if (data.type == "mensaje-ce-paciente" && data.id != "") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-paciente/consultaexpress/abiertas-" + data.id + ".html";
        });
    }

    //redireccion nuevo msj CE medico
    if (data.type == "mensaje-ce-medico" && data.id != "") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-medico/consultaexpress/abiertas-" + data.id + ".html";
        });
    }
    //redireccion a listado mis paciente

    if (data.type == "respuesta-invitacion-paciente") {
        $(".notifyjs-wrapper").first().click(function () {

            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/";
        });
    }

    //redireccion a notificaciones
    if (data.type == "notificacion") {
        $(".notifyjs-wrapper").first().click(function () {
            if (controller == "medico") {
                window.location.href = BASE_PATH + "panel-medico/notificaciones/";
            }
            if (controller == "paciente_p") {
                window.location.href = BASE_PATH + "panel-paciente/notificaciones/";
            }
        });

    }

    //Redireccion a sala espera cuando paciente está en sala
    if (data.type == "paciente_consultorio" || data.type == "recordatorio-proxima-vc") {
        if (submodulo !== "videoconsulta_sala_espera") {
            $(".notifyjs-wrapper").first().click(function () {
                if (controller == "medico") {
                    window.location.href = BASE_PATH + "panel-medico/videoconsulta/sala-espera.html";
                }
                if (controller == "paciente_p") {
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/sala-espera.html";
                }
            });
        }
    }
}

/**Metodo que despliga una notificacion emerfente 
 * 
 * @param {type} data
 * @returns {Boolean}
 */
function notify(data) {

    if (!data.hasOwnProperty('title') || !data.hasOwnProperty('text')) {
        return false;
    }
    console.log(data);
    if (data.hasOwnProperty('style') && typeof data.style != "undefined") {
        var style = data.style;
    } else {
        var style = 'sistema';
    }


    if (data.hasOwnProperty('position')) {
        var position = data.position;
    } else {
        var position = 'top right';
    }

    if (data.hasOwnProperty('duration')) {
        var duration = data.duration;
        var hide = true;
    } else {
        var hide = false;
        var duration = 0;
    }
    /*
     if(style == "error"){
     icon = "fa fa-exclamation";
     }else if(style == "warning"){
     icon = "fa fa-warning";
     }else if(style == "success"){
     icon = "fa fa-check";
     }else if(style == "info"){
     icon = "fa fa-question";
     }else{
     icon = "fa fa-circle-o";
     }*/
    /* $.notify({
     title: data.title,
     text: data.text
     
     }, {
     style: style,
     
     globalPosition:position,
     showAnimation: "show",
     showDuration: 0,
     hideDuration: 0,
     autoHide: hide,
     clickToHide: true
     });*/
    // console.log(utf8_decode("¡El profesional está esperando en el Consultorio Virtual!"));
    $.notify({
        title: data.title,
        content: data.text
    }, {
        style: data.style,
        position: 'top right',
        autoHide: false
    });

    //redirigimos al usuario a la seccion correspondiente
    redireccion_notify(data);
}

/**
 * Traduce un string recibido con parametro, que m,atchea con un registro en el archivo de traducciones
 * @param {type} email
 * @returns {unresolved}
 */
var x_translate = function (msg) {



    if (typeof translations !== 'undefined') {
        //verificamos la ocurrencia de los caracteres [[ ]] que indican un texto variable
        if (msg.indexOf("[[") > 0 && msg.indexOf("]]") > 0) {

            //cortamos el texto variable para buscar la traduccion con la mascara [[%s]] en la posicion del texto variable
            var init = msg.indexOf("[[");
            var end = msg.indexOf("]]");
            //guardamos el texto a reemplazar
            var texto_variable = msg.substring(init + 2, end);
            console.log(texto_variable);
            msg = msg.replace(texto_variable, "%s");
            //buscamos la traduccion y reemplazamos el texto variabke
            if (translations[msg] != undefined) {
                var msg = translations[msg];
                msg = msg.replace("[[%s]]", texto_variable);
            }
        } else {
            if (typeof translations[msg] != 'undefined') {
                var msg = translations[msg];
            }
        }

    } else {
        console.log("Archivo de traducciones no encontrado");
    }
    if (controller === "medico" && typeof traducir_txt_clientes !== "undefined" && traducir_txt_clientes === 1) {
        msg = msg.replace(/Patient/g, "Client");
        msg = msg.replace(/patient/g, "client");
        msg = msg.replace(/PATIENT/g, "CLIENT");
    }
    return msg;
};
/**
 * Método que valida el formato de una fecha entrada
 * @param {type} inputText
 * @returns {Boolean}
 */
function validatedate(dateText) {
    var dateformat = /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/;
    // Match the date format through regular expression
    if (dateText.match(dateformat)) {

        //Test which seperator is used '/' or '-'
        var opera1 = dateText.split('/');
        var opera2 = dateText.split('-');
        lopera1 = opera1.length;
        lopera2 = opera2.length;
        // Extract the string into month, date and year
        if (lopera1 > 1) {
            var pdate = dateText.split('/');
        } else if (lopera2 > 1) {
            var pdate = dateText.split('-');
        }

        var dd = parseInt(pdate[0]);
        var mm = parseInt(pdate[1]);
        var yy = parseInt(pdate[2]);
        // Create list of days of a month [assume there is no leap year by default]
        var ListofDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (mm == 1 || mm > 2) {
            if (dd > ListofDays[mm - 1]) {

                return false;
            }
        }
        if (mm == 2) {
            var lyear = false;
            if ((!(yy % 4) && yy % 100) || !(yy % 400))
            {
                lyear = true;
            }
            if ((lyear == false) && (dd >= 29))
            {
                return false;
            }
            if ((lyear == true) && (dd > 29))
            {
                return false;
            }
        }
        return true;
    } else {
        return false;
    }
}