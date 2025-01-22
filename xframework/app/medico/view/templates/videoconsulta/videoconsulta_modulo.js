//
//Copyright (c) 2016, Skedans Systems, Inc.
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//POSSIBILITY OF SUCH DAMAGE.
//

var selfEasyrtcid = "";

var otherEasyrtcid = "";
var display_images_form = false;


//habilitar y deshabilitar botones
function enable(domId) {
    $(domId).prop("disabled", "");
}
function disable(domId) {
    $(domId).prop("disabled", true);
}

//funcion que establece los botones y status en OFFLINE cuando no se conecto un miembro
function offline() {

    $("#status").removeClass("icon-doctorplus-check-thin");
    $("#status").addClass("icon-doctorplus-minus");
    $("#status").parent().parent().addClass("yellow");
    $("#status2-offline").show();
    $("#status2-online").hide();
    display_images_form = false;
    $("#btnLlamar").hide();



}
;

//funcion que establece los botones y status en ONLINE cuando se conecto un miembro
function online() {

    $("#status").removeClass("icon-doctorplus-minus");
    $("#status").addClass("icon-doctorplus-check-thin");
    $("#status").parent().parent().removeClass("yellow");
    $("#status2-offline").hide();
    $("#status2-online").show();
    //llamar automaticamente si ya esta iniciada anteriormente
    if (inicio_llamada != "") {
        $("#btnLlamar").hide();
        llamar();
    } else {
        $("#btnLlamar").show();
    }

}
;


//funcion encargada de notificar al paciente que el medico esta en la sala
var notificar_medico_ingreso_sala = function () {
    var idvideoconsulta = $("#idvideoconsulta").val();
    x_doAjaxCall(
            'POST',
            BASE_PATH + 'notificar_medico_ingreso_sala.do',
            'idvideoconsulta=' + idvideoconsulta,
            function (data) {

                if (!data.result) {
                    x_alert(data.msg);
                }
            });
};


//funcion para unirse a una sala de videoconsulta establecida entre el paciente y medico
function joinRoom() {
    if ($("#room").val() == "") {
        console.log("No roomName");
        return false;
    }
    roomName = $("#room").val();


    easyrtc.joinRoom(roomName, {},
            function (roomName) {
                console.log(" Conectado a la sala: " + roomName);

            },
            function (errorCode, errorText, roomName) {
                easyrtc.showError(errorCode, errorText + ": room name was(" + roomName + ")");


            });

    return true;

}

//obtener recursos de video
function initMediaSource() {
    easyrtc.initMediaSource(function () {        // success callback
        var selfVideo = document.getElementById("selfVideo");
        easyrtc.setVideoObjectSrc(selfVideo, easyrtc.getLocalStream());

    },
            function (errorCode, errmesg) {
                console.log("MEDIA-ERROR:" + errmesg);
            }  // failure callback
    );
}

//funcion para conectarse al servidor a una sala para la Video Consulta
function connect() {
    var rtd = joinRoom();

    if (rtd) {

        easyrtc.enableDebug(false);
        console.log("Conenctando..");

        //setemos el nombre de cliente local como username
        easyrtc.setUsername($("#myUserName").val());
        //seteamos la funcion listener que escucha cuando ingrega el otro usuario a la sala
        easyrtc.setRoomOccupantListener(occupantsListener);

        //seletamos el listener de los mensajes entrantes
        easyrtc.setPeerListener(addToConversation);

        //cargamos los campos utilies 

        easyrtc.setRoomApiField(roomName, "idmedico", $("#idmedico").val());



        //funcion de conexion de la API 
        easyrtc.connect("easyrtc.instantMessaging", loginSuccess, loginFailure);




        easyrtc.enableAudio(true);
        easyrtc.enableAudioReceive(true);
        initMediaSource();
        easyrtc.muteVideoObject("selfVideo", true);



    }
}



//colgar llamada
function hangup() {
    easyrtc.hangupAll();
    $("#callerArea").spin(false);
    $('#hangupButton').hide();
    //$('#btnLlamar').show();
    $('#btnLlamar').removeClass('calling-label-show');
    disable('#btnSendMsg');
    disable('#btnAddFile');
    disable('#textoMensaje');
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;
    $('.audio-reccord-holder').children('.chat-img-upld').slideUp();

}

//colgar llamada cuando finaliza el tiempo de videoconsulta
function tiempoTranscurrido() {
    easyrtc.hangupAll();
    $('#hangupButton').hide();
    $('#btnLlamar').hide();
    disable('#btnSendMsg');
    disable('#btnAddFile');
    disable('#textoMensaje');
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;
    $('.audio-reccord-holder').children('.chat-img-upld').slideUp();

}




//funcion aplicada a los usuarios en la sala cuando se conectan
function occupantsListener(roomName, occupants, isPrimary) {

    console.log("Usuarios en " + roomName + ": " + Object.keys(occupants).length);

    //iteramos sobre los ocupantes de la sala
    if (Object.keys(occupants).length > 0) {
        $.each(occupants, function (index, value) {
            console.log(value);
            if (value.hasOwnProperty('apiField') && value.apiField.idpaciente.fieldValue != undefined && value.apiField.idpaciente.fieldValue == $("#idpaciente").val()) {
                paciente_username = value.username;
                console.log("Id: " + value.easyrtcid);
                console.log("User: " + value.username);
                otherEasyrtcid = value.easyrtcid;
                online();
                //  $('#btnLlamar').show();
                // $('#btnLlamar').removeClass('calling-label-show');
                $('#hangupButton').hide();

            }

        });
    } else {
        offline();
        $("#callerArea").spin(false);
        disable('#btnSendMsg');
        disable('#btnAddFile');
        display_images_form = false;
        $('#btnLlamar').hide();
        $('#hangupButton').hide();


    }


}
//
var first_call = true;

//funcion para realizar la llamada al contacto disparada por la funcion "llamar() "
function performCall(otherEasyrtcid) {
    easyrtc.hangupAll();

    var acceptedCB = function (accepted, easyrtcid) {

        //si se rechaza la llamada
        if (!accepted) {

            $("#modal-videoconsulta-rechazada").modal("show");
            $("#callerArea").spin(false);
            $("#btnLlamar").removeClass("calling-label-show");
            disable('#hangupButton');
            enable('#btnLlamar');
            display_images_form = false;
            easyrtc.showError("RECHAZADA", "No se pudo comunicar con el destinatario");

        }

    };

    //llamada exitosa
    var successCB = function (otherEasyrtcid) {


        //almacenamos el inicio de la Video Consulta
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'setear_inicio_videoconsulta.do',
                "idvideoconsulta=" + $("#idvideoconsulta").val(),
                function (data) {
                    if (data.result) {
                        console.log("Llamada aceptada: " + otherEasyrtcid);
                        $('#hangupButton').show();
                        $('#btnLlamar').hide();

                        $("#callerArea").spin(false);

                        //habilitamos las funciones de chat

                        enable('#btnSendMsg');
                        enable('#btnAddFile');
                        enable('#textoMensaje');
                        $("#textoMensaje").attr("placeholder", x_translate("Escribir mensaje"));
                        display_images_form = true;

                        //flag vencimiento_llamada determina si han pasado 5 min sin que se inicie la llamada para mostrar el modal de tiempo de espera finalizado
                        vencimiento_llamada = false;
                        iniciada = true;

                        //setemaos los segundos restantes en el timer
                        Date.prototype.addSeconds = function (h) {
                            this.setSeconds(this.getSeconds() + h);
                            return this;
                        };

                        var date1 = new Date().addSeconds(data.tiempo_restante) / 1000;
                        console.log(data.tiempo_restante);

                        $('#timer-tiempo-restante').countid({
                            clock: true,
                            dateTime: date1,
                            dateTplRemaining: "%M:%S",
                            dateTplElapsed: x_translate("Tiempo cumplido"),
                            complete: function (el) {
                                el.css({color: '#fff'});
                                el.siblings('.min-unit').hide();
                                tiempoTranscurrido();
                                $("#modal-tiempo-transcurrido").modal("show");
                            }
                        });
                        //timer flotante
                        $('#timer-tiempo-restante-float').countid({
                            clock: true,
                            dateTime: date1,
                            dateTplRemaining: "%M:%S",
                            dateTplElapsed: '',
                            complete: function (el) {
                                el.css({color: '#fff'});
                                el.siblings('.min-unit').hide();
                            }
                        });

                    } else {
                        hangup();
                        x_alert(data.msg);

                    }
                }
        );




    };
    var failureCB = function () {
        console.log("llamada fallida");
        $("#callerArea").spin(false);
        $('#btnLlamar').show();
        display_images_form = false;
        $('#btnLlamar').removeClass('calling-label-show');
        $('#hangupButton').hide();

    };
    easyrtc.call(otherEasyrtcid, successCB, failureCB, acceptedCB);
}

//evento disparado por el boton llamar
function llamar() {
    //id del destinatario


    if (otherEasyrtcid != "") {
        $("#callerArea").spin("large");
        performCall(otherEasyrtcid);
    }
}

//funcion disparada cuando se logra conectar a la sala el cliente
function loginSuccess(easyrtcid) {
    if ($("#modal-videoconsulta-error-conexion").is(":visible")) {
        $("#modal-videoconsulta-error-conexion").modal("hide");
    }
    selfEasyrtcid = easyrtcid;
    console.log("Conectado! Mi id es: " + easyrtcid);

    //notificamos al paciente que el medico ingreso
    notificar_medico_ingreso_sala();
    if ($("#modal-videoconsulta-error-conexion").is(":visible")) {
        $("#modal-videoconsulta-error-conexion").modal("show");

    }


}

//funcion disparada cuando se produce un error al intentar conectarse a la sala el cliente
function loginFailure(errorCode, message) {

    //mostramos la alerta de error

    if (!$("#modal-videoconsulta-error-conexion").is(":visible")) {
        $("#modal-videoconsulta-error-conexion").modal("show");

    }
    console.log("No se ha podido establecer la conexión con el servidor de videoconsulta");
}

//desconectar del servidor y liberar recurso
function disconnect() {

    easyrtc.disconnect();
    console.log("disconnecting from server");
    easyrtc.setVideoObjectSrc(document.getElementById('selfVideo'), "");
}

//funcion recargar ante un error
function callback_error(error) {
    console.log("Desconectando. Error de conexion")
    disconnect();
    x_loadModule('videoconsulta', 'videoconsulta_modulo', '', 'div_videoconsulta_modulo');

}



//funcion cuando se obtiene el stream del otro usuario
easyrtc.setStreamAcceptor(function (easyrtcid, stream) {
    iniciada = true;
    var video = document.getElementById('callerVideo');
    easyrtc.setVideoObjectSrc(video, stream);
    console.log("Conexion establecida con: " + easyrtcid);
    //cambiamos el estado de los botones
    $("hangupButton").show();
    if (inicio_llamada != "") {
        $("#btnLlamar").hide();
    }

    $('#btnLlamar').removeClass('calling-label-show');

    //ocultamos el status
    $(".mvc-video-espera-box").hide();
});


//funcion cuando se pierde el stream
easyrtc.setOnStreamClosed(function (easyrtcid) {
    easyrtc.setVideoObjectSrc(document.getElementById('callerVideo'), "");
    $("hangupButton").hide();
    $("#btnLlamar").show();

    $('#btnLlamar').removeClass('calling-label-show');
    easyrtc.hangupAll();
    console.log("Conexion terminada");

    //deabilitamos el chat
    disable('#btnSendMsg');
    disable('#btnAddFile');
    disable('#textoMensaje');
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;
    $('.audio-reccord-holder').children('.chat-img-upld').slideUp();
});



//FUNCIONES JS para el manejo de chat a partir de aqui



//funcion que envia el texto del mensaje al destinatario y concatena el texto a la conversacion
function enviarMensajeChat() {

    //verificamos si esta el remitente conectado

    if (otherEasyrtcid === "") {
        return;
    }

    $("#textoMensaje").tooltip("destroy");
    var text = $('#textoMensaje').val();
    if (text.replace(/\s/g, "").length === 0) { // no enviar mensajes sin texto o sin fotos
        $("#textoMensaje").data("title", "Ingrese texto del mensaje").tooltip("show");
        return;
    }


    //Envío el mensaje
    $("#sendMessageArea").spin("large");
    x_sendForm(
            $('#send_mensaje_videoconsulta'),
            true,
            function (data) {
                $("#sendMessageArea").spin(false);
                if (data.result) {

                    console.log("text1" + text);
                    //llamamos a la funcion de la API para pasar el msj por socket
                    if (text != "") {
                        console.log("text2" + text);
                        easyrtc.sendDataWS(otherEasyrtcid, "message", text);

                        //Agrego mi texto a la ventana de conversacion 
                        addToConversation("Yo", "message", text);
                        $('#textoMensaje').val("");
                    }


                } else {
                    x_alert(data.msg);
                }
            }
    );
}

//funcion que envia la imagen del mensaje al destinatario y concatena la imagen a la conversacion
function enviarImagenChat() {

    //verificamos si esta el remitente conectado

    if (otherEasyrtcid === "") {
        return;
    }

    $("#btnSendImg").tooltip("destroy");

    if ($(".dz-image-preview").length == 0) { // no enviar mensajes  sin fotos
        $("#btnSendImg").data("title", "Adjunte al menos una imagen").tooltip("show");
        return;
    }

    $("#cantidad_image").val($(".dz-image-preview.dz-success").length);
    //Envío el mensaje
    $("#dropzone").spin("large");
    x_sendForm(
            $('#send_imagen_videoconsulta'),
            true,
            function (data) {
                $("#dropzone").spin(false);
                if (data.result) {
                    $("#vcm-upload-widget").removeClass("open");
                    //limpiamos las imagenes del dropzone
                    Dropzone.forElement("#dropzone").removeAllFiles(true);

                    //agrego las imagenes si hay
                    if (data.imagenes != null && data.imagenes.length > 0) {
                        //añadimos el msg de la imagen
                        $.each(data.imagenes, function (index, value) {


                            if (value.hasOwnProperty('idarchivosMensajeVideoConsulta')) {
                                var insert_imagen = "<img src='" + value.path_images_usuario + "' alt='" + value.nombre + "." + value.ext + "'  title='" + value.nombre + "." + value.ext + "' style='width:100px;'>";

                                easyrtc.sendDataWS(otherEasyrtcid, "imagen", insert_imagen);
                                addToConversation("Yo", "imagen", insert_imagen);

                            }
                        });


                        $("#cantidad_images").val(0);

                    }

                } else {
                    x_alert(data.msg);
                }
            }
    );
}


//document ready functions
$(function () {
    //conectamos a servidor cuando ingresamos
    connect();


});