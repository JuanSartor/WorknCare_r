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

var otherEasyrrcid = "";
var accepted = false;
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
    $("#status2-llamando").hide();
    $("#vcp-llamada").show();
}
;

//funcion que establece los botones y status en ONLINE cuando se conecto un miembro
function online() {

    $("#status").removeClass("icon-doctorplus-minus");
    $("#status").addClass("icon-doctorplus-check-thin");
    $("#status").parent().parent().removeClass("yellow");
    $("#status2-offline").hide();
    $("#status2-online").show();
    $("#status2-llamando").hide();
    $("#vcp-llamada").show();
}
;

//funcion para u nirse a  una sala de video co nsu lta establecida entre el paciente y medico
function joinRoom() {
    if ($("#room").val() == "") {
        console.log("No roomName");
        return false;
    }

    roomName = $("#room").val();
    easyrtc.joinRoom(roomName, {},
            function (roomName) {
                console.log("Conectado a la sala:" + roomName);
                return true;
            },
            function (errorCode, errorText, roomName) {
                easyrtc.showError(errorCode, errorText + ": room name was(" + roomName + ")");
                return false;
            });
    return true;
}

//obtener recursos de video
function initMediaSource() {
    easyrtc.initMediaSource(function () {        // success callback
        var selfVideo = document.getElementById("selfVideo");
        easyrtc.setVideoObjectSrc(selfVideo, easyrtc.getLocalStream());
        // easyrtc.conne ct("easyrtc.videoOnly", loginSuccess, loginFailure);
    },
            function (errorCode, errmesg) {
                console.log(errmesg);
                console.log("error de conexion");
                easyrtc.showError("MEDIA-ERROR", errmesg);
            }  // failure callback
    );
}

//funcion para conectarse al servidor a una sala pa r a la Video Consulta
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

        easyrtc.setRoomApiField(roomName, "idpaciente", $("#idpaciente").val());
        //funcion de conexion de la API 
        easyrtc.connect("easyrtc.instantMessaging", loginSuccess, loginFailure);
        easyrtc.enableAudio(true);
        easyrtc.enableAudioReceive(true);
        initMediaSource();
        easyrtc.muteVideoObject("selfVideo", true);
        /*
         //habilitamos el uso de recursos de audio
         easyrtc.enableAudio(true);
         easyrtc.enableAudioReceive(true);
         //seteamos la funcion listener que escucha cuando ingrega el otro usuario a la sala
         easyrtc.setRoomOccupantListener(occupantsListener);
         easyrtc.initMediaSource(
         function(){        // success callback
         var selfVideo = document.getElementById("selfVideo");
         easyrtc.setVideoObjectSrc(selfVideo, easyrtc.getLocalStream());
         easyrtc.connect("easyrtc.videoOnly", loginSuccess, loginFailure);
         },
         function(errorCode, errmesg){
         easyrtc.showError("MEDIA-ERROR", errmesg);
         }  // failure callback
         );
         */
    }
}


//colgar llamada
function hangup() {
    easyrtc.hangupAll();

    disable('#btnSendMsg');
    disable('#btnAddFile');
    disable('#textoMensaje');
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;

    $('.audio-reccord-holder').children('.chat-img-upld').slideUp();
}




//funcion aplicada  a los usuarios en la sala cuando se conectan
function occupantsListener(roomName, occupants, isPrimary) {

    console.log("Usuarios conectados en " + roomName + ": " + Object.keys(occupants).length);
    //iteramos sobre los ocupantes de la sala
    if (Object.keys(occupants).length > 0) {
        $.each(occupants, function (index, value) {
            console.log(value);
            if (value.hasOwnProperty('apiField') && value.apiField.idmedico.fieldValue != undefined && value.apiField.idmedico.fieldValue == $("#idmedico").val()) {
                medico_username = value.username;
                console.log("Id: " + value.easyrtcid);
                console.log("User: " + value.username);
                otherEasyrtcid = value.easyrtcid;
                online();

            }

        });
    } else {
        offline("#status");

        disable('#btnSendMsg');
        disable('#btnAddFile');
        display_images_form = false;

    }


}


//funcion disparada cuando se logra conectar a la sala el cliente
function loginSuccess(easyrtcid) {

    selfEasyrtcid = easyrtcid;
    console.log("Conectado! Mi id es: " + easyrtcid);

    if ($("#modal-videoconsulta-error-conexion").is(":visible")) {
        $("#modal-videoconsulta-error-conexion").modal("hide");
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
    console.log("Desconectando. Error de conexion");
    disconnect();
    x_loadModule('videoconsulta', 'videoconsulta_modulo', '', 'div_videoconsulta_modulo');

}

//funcion cua ndo se obtiene el stream del otro usuario
easyrtc.setStreamAcceptor(function (easyrtcid, stream) {
    var video = document.getElementById('callerVideo');
    easyrtc.setVideoObjectSrc(video, stream);
    console.log("Conexion establecida con: " + easyrtcid);

    //ocultamos el status
    $(".mvc-video-espera-box").hide();

});
//funcion cuando se pierde el stream
easyrtc.setOnStreamClosed(function (easyrtcid) {
    easyrtc.setVideoObjectSrc(document.getElementById('callerVideo'), "");
    easyrtc.hangupAll();
    console.log("Conexion terminada");
//deabilitamos el chat
    disable('#btnSendMsg');
    disable('#btnAddFile');
    disable('#textoMensaje');
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;


    x_doAjaxCall(
            'POST',
            BASE_PATH + 'get_estado_videoconsulta.do',
            'idvideoconsulta=' + $("#idvideoconsulta").val(),
            function (data) {
                if (data.result && data.estado == 8) {
                    $("#modal-videoconsulta-finalizada").modal("show");
                }
            }

    );

});
//chequear llamada entrante del remitente
easyrtc.setAcceptChecker(function (easyrtcid, callback) {

    /*
     if (easyrtc.getConnectionCount() > 0) {
     document.getElementById('acceptCallLabel').innerHTML = "Rechazar llamada de " + medico_username + " ?";
     }
     else {
     document.getElementById('acceptCallLabel').innerHTML = "Aceptar llamada de " + medico_username + " ?";
     }*/

    $("#status2-online").hide();
    $("#status2-offline").hide();
    $("#status2-llamando").show();
    //funcion para aceptar/rechazar llamada
    acceptTheCall = function (wasAccepted) {

        if (wasAccepted) {
            accepted = true;
            easyrtc.hangupAll();

            console.log("llamada aceptada");
            //habilitamos las funciones de chat

            enable('#btnSendMsg');
            enable('#btnAddFile');
            enable('#textoMensaje');
            $("#textoMensaje").attr("placeholder", x_translate("Escribir mensaje"));
            display_images_form = true;

        } else {
            accepted = false;
            display_images_form = false;


        }

        $(".vcp-llamada").hide();
        $("#status2-online").hide();
        $("#status2-offline").hide();
        $("#status2-llamando").hide();


        callback(wasAccepted);
    };

    //aceptar automaticamente si ya esta iniciada anteriormente
    if (inicio_llamada != "") {
        acceptTheCall(true);
    }


});


//acceptTheCall(true);
$("#callAcceptButton").click(function () {
    //si no se compartio la camara mostramos una alerta
    //no se puede aceptar hasta que comparta la camara
    $("#callAcceptButton").tooltip("destroy");
    if ($("#selfVideo").attr("src") == undefined) {
        $("#callAcceptButton").data("title", "Debe permitir compartir su cámara y micrófono para aceptar la llamada").tooltip("show");
        initMediaSource();
    } else {
        acceptTheCall(true);
    }
});
$("#callRejectButton").click(function () {
    acceptTheCall(false);
});


//FUNCIONES JS para el manejo de chat a partir de aqui




//funcion que envia el texto del mensaje al destinatario y concatena el texto a la conversacion
function enviarMensajeChat() {

//verificamos si esta el remitente conectado

    if (otherEasyrtcid == "") {
        return;
    }

    $("#textoMensaje").tooltip("destroy");
    var text = document.getElementById('textoMensaje').value;
    if (text.replace(/\s/g, "").length === 0) { // no enviar mensajes sin texto 
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

                    //limpiamos las imagenes del dropzone
                    Dropzone.forElement("#dropzone").removeAllFiles(true);
                    //llamamos a la funcion de la API para pasar el msj por socket
                    if (text != "") {
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
                                var insert_imagen = "<img src='" + value.path_images_usuario + "' alt='" + value.nombre + "." + value.ext + "'  title='" + value.nombre + "." + value.ext + "' style='width:100px;' >";

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
    // disconnect();
//conectamos a servidor cuando ingresamos
    connect();

});
