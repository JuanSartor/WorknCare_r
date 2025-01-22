
var display_images_form = false;


//funcion que establece los botones y status en OFFLINE cuando no se conecto un miembro
function offline() {

    $("#status").removeClass("icon-doctorplus-check-thin");
    $("#status").addClass("icon-doctorplus-minus");
    $("#status").parent().parent().addClass("yellow");
    $("#status2-offline").show();
    $("#status2-online").hide();
    display_images_form = false;

    $("#callerArea").spin(false);
    $('#btnSendMsg').prop("disabled", true);
    $('#btnAddFile').prop("disabled", true);
    $('#hangupButton').hide();
    socket.emit('notificar_ingreso_consultorio', {tipo_usuario: 'paciente', idpaciente: $("#idpaciente").val(), paciente: $("#paciente_username").val(), idmedico: $("#idmedico").val(), idvideoconsulta: $("#idvideoconsulta").val(), evento: 'salida'});
}


//funcion que establece los botones y status en ONLINE cuando se conecto un miembro
function online() {

    $("#status").removeClass("icon-doctorplus-minus");
    $("#status").addClass("icon-doctorplus-check-thin");
    $("#status").parent().parent().removeClass("yellow");
    $("#status2-offline").hide();
    $("#status2-online").show();
    socket.emit('notificar_ingreso_consultorio', {tipo_usuario: 'paciente', idpaciente: $("#idpaciente").val(), paciente: $("#paciente_username").val(), idmedico: $("#idmedico").val(), idvideoconsulta: $("#idvideoconsulta").val(), evento: 'ingreso'});




}



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


//colgar llamada cuando finaliza el tiempo de videoconsulta
function tiempoTranscurrido() {
    //easyrtc.hangupAll();
    console.log("Tiempo Transcurrido: desconectarse de la sesion");
    session.forceDisconnect(clientId_paciente);
    $('#hangupButton').hide();

    $('#btnSendMsg').prop("disabled", true);
    $('#btnAddFile').prop("disabled", true);
    $('#textoMensaje').prop("disabled", true);
    $("#textoMensaje").attr("placeholder", x_translate("No disponible hasta iniciar VideoConsulta"));
    display_images_form = false;
    $('.audio-reccord-holder').children('.chat-img-upld').slideUp();
    $("#modal-tiempo-transcurrido").modal("show");

}





var first_call = true;








//FUNCIONES JS para el manejo de chat a partir de aqui



//funcion que envia el texto del mensaje al destinatario y concatena el texto a la conversacion
function enviarMensajeChat() {

    //verificamos si esta el remitente conectado


    $("#textoMensaje").tooltip("destroy");
    var text = $('#textoMensaje').val();
    if (text.replace(/\s/g, "").length === 0 && $(".dz-preview").length == 0) { // no enviar mensajes sin texto 
        $("#textoMensaje").data("title", x_translate("Ingrese texto del mensaje")).tooltip("show");
        return;
    }
    //carga de imagenes en proces
    if ($("#dropzone" + " .dz-complete").length != $("#dropzone" + " .dz-preview").length) {
        x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
        return false;

    }


    //Envío el mensaje
    $(".mvc-data-col").spin("large");
    x_sendForm(
            $('#send_mensaje_videoconsulta'),
            true,
            function (data) {
                if (data.result) {


                    //llamamos a la funcion de la API para pasar el msj por socket
                    if (text != "") {
                        //opentok msg
                        session.signal({
                            type: 'msg',
                            data: text
                        }, function (error) {
                            if (error) {
                                console.log('Error sending signal:', error.name, error.message);
                            } else {
                                text = '';
                            }
                        });
                    }

                    //agrego las imagenes si hay
                    if (data.imagenes != null && data.imagenes.length > 0) {
                        //añadimos el msg de la imagen
                        $.each(data.imagenes, function (index, value) {


                            if (value.hasOwnProperty('idarchivosMensajeVideoConsulta')) {
                                var insert_imagen = "<a href='" + value.url + "' data-filename='" + value.nombre + "'  data-ext='" + value.ext + "' class='display-file'><img src='" + value.path_images + "' alt='" + value.nombre + "." + value.ext + "'  title='" + value.nombre + "." + value.ext + "' style='width:100px; height:100px'><div class='mvc-attach-btn'><i class='icon-doctorplus-search'></i></div></a>";


                                //opentok msg
                                session.signal({
                                    type: 'imagen',
                                    data: insert_imagen
                                }, function (error) {
                                    if (error) {
                                        console.log('Error sending signal:', error.name, error.message);
                                    } else {

                                    }
                                });


                            }
                        });
                    }
                    $(".dropzone").removeClass("dz-started");
                    $(".dropzone .dz-preview").remove();
                    $("#btnSendImg").tooltip("destroy");
                    $("#cantidad_adjunto").val(0);
                    $('#textoMensaje').val("");
                    if ($('#div-upload-widget').is(':visible')) {
                        $('#desktop-upload-open').trigger("click");
                    }
                    $(".mvc-data-col").spin(false);



                } else {
                    x_alert(data.msg);
                }
            }
    );
}

//////////////////////CODIGO OPEN TOK



//evento disparado por el boton llamar
function llamar() {
    //id del destinatario
    /*  if (otherEasyrtcid != "") {
     $("#callerArea").spin("large");
     performCall(otherEasyrtcid);
     }*/

    $("#callerArea").spin("large");
    console.log("publish");
    //session.publish(publisher, handleError);




}
function iniciar_videollamada(data) {
    console.log("Llamada aceptada:");
    $('#hangupButton').show();

    $('#btnLlamar').hide();

    $("#callerArea").spin(false);


    //habilitamos las funciones de chat

    $('#btnSendMsg').prop("disabled", "");
    $('#btnAddFile').prop("disabled", "");
    $('#textoMensaje').prop("disabled", "");
    $("#textoMensaje").attr("placeholder", x_translate("Escribir mensaje"));
    $("#status2-online").hide();
    display_images_form = true;

    //flag vencimiento_llamada determina si han pasado 5 min sin que se inicie la llamada para mostrar el modal de tiempo de espera finalizado
    vencimiento_llamada = false;
    iniciada = true;
    //mostramos el boton de compartir pantalla si esta disponible la funcionalidad
    if ($('#compartir-pantalla').data("disponible") == 1) {
        if (!$('#compartir-pantalla').hasClass("sharing")) {
            $('#compartir-pantalla').show();
        }
    }

    //setemaos los segundos restantes en el timer
    /*Date.prototype.addSeconds = function (h) {
     this.setSeconds(this.getSeconds() + h);
     return this;
     };*/

    //var date1 = new Date().addSeconds(data.tiempo_restante) / 1000;
    console.log("Seg restantes", data.tiempo_restante);

    // seteamos el tiempo restante para el fin de la VC
    if (data.tiempo_restante !== "") {

        var countDownDate = new Date();
        countDownDate.setSeconds(countDownDate.getSeconds() + data.tiempo_restante);
        countDownDate = countDownDate.getTime();

        // Actualizamos el contador cada segundo
        var x = setInterval(function () {

            //Calculo el tiempo actual
            var now = new Date().getTime();

            // calulamos el tiempo restante
            var distance = countDownDate - now;

            // Calculamos dias, horas, segundos 
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);


            if (minutes < 10) {
                minutes = "0" + minutes;
            }
            if (seconds < 10) {
                seconds = "0" + seconds;
            }

            // Actualizamos el tiempo restante en la consulta
            $("#timer-tiempo-restante,#timer-tiempo-restante-float").text(hours + ":" + minutes + ":" + seconds);

            // cuando finaliza el tiempo ocultamos el timer
            if (distance < 0) {
                clearInterval(x);
                //ocultamos el timer
                $("#timer-tiempo-restante,#timer-tiempo-restante-float").text(x_translate("Tiempo cumplido"));

                tiempoTranscurrido();
            }
        }, 1000);
    }

}
//seteamos en la Bd el inicio de la consulta
function setear_inicio_videollamada() {

    x_doAjaxCall(
            'POST',
            BASE_PATH + 'setear_inicio_videoconsulta.do',
            "idvideoconsulta=" + $("#idvideoconsulta").val(),
            function (data) {
                iniciar_videollamada(data);
                if (data.result) {


                } else {
                    //hangup();
                    x_alert(data.msg);

                }
            }
    );
}

function callback_llamada(error) {
    if (error) {
        console.log("error en llamada");
        console.log(error);
    } else {
        console.log("llamada exitosa. setear inicio llamada");
        setear_inicio_videollamada();
    }

}

function handleError(error) {
    if (error) {
        console.log("error");
        console.error(error);
    } else {
        console.log("exito");

    }
}
var connectionId = "";
function initializeSession() {
    session = OT.initSession(apiKey, sessionId);

    // Subscribe to a newly created stream

    //el medico se conecta al stream luego de que el paciente recibe la llamada
    session.on('streamCreated', function streamCreated(event) {
        eventStream = event;
        var subscriberOptions = {
            insertMode: 'append',
            width: '100%',
            height: '100%'
        };
        console.log("steam creado");
        console.log("subscribe");

        session.subscribe(eventStream.stream, 'callerVideo', subscriberOptions, callback_llamada);
    });

//desconexion de la session
    session.on('sessionDisconnected', function sessionDisconnected(event) {
        console.log('Desconectado de la sesion', event.reason);
        if (event.connection.data == "tipo=paciente") {
            offline();
        }
    });

//conexion y desconexion de los usuarios
    session.on({
        connectionCreated: function (event) {

            console.log("event1", event);
            console.log("session1", session);
            //guardo mi ID
            if (connectionId == "" && event.connection.data == "tipo=medico") {
                connectionId = event.connection.connectionId;
            }
            //si es el paciente que se conecta
            if (event.connection.data == "tipo=paciente") {
                console.log('el otro usuario está en la sala:', event.connection);
                clientId_paciente = event.connection.connectionId;
                online();
            } else {
                if (connectionId != event.connection.connectionId) {
                    $("#modal-videoconsulta-otra-sala").modal("show");
                    console.log('Consultorio virtual abierto en otra pesataña');
                    console.log('Desconectando');
                    session.disconnect();
                }

            }
        },
        connectionDestroyed: function connectionDestroyedHandler(event) {
            console.log("event", event);
            if (event.connection.data == "tipo=paciente") {
                console.log('el otro usuario salió de la sala');
                console.log("razon:");
                console.log(event.reason);
                offline();
            }
        }
    });

    // initialize the publisher
    publisherOptions = {
        insertMode: 'append',
        width: '100%',
        height: '100%'
    };
    function publisherError(error) {
        if (error) {
            console.log("publish con error ");
            console.error(error);
            if (error.name == "OT_USER_MEDIA_ACCESS_DENIED") {
                x_alert(x_translate("ATENCIÓN: No detectamos su cámara/micrófono.<br>Por favor, asegúrese de estar permitiendo el acceso a los mismos desde la configuración de su navegador"));
            } else if (error.name == "OT_MEDIA_ERR_ABORTED") {
                x_alert(x_translate("Su explorador está desactualizado o no es compatible con la tecnología WebRTC requerida para iniciar la consulta. En iOS recomendamos que utilice Safari en sus últimas versiones."));
            } else {
                x_alert(error.name + ":" + error.message);
            }
        } else {
            console.log("publish con exito");

        }
    }
    publisher = OT.initPublisher('selfVideo', publisherOptions, publisherError);

    // Connect to the session
    session.connect(token, function callback(error) {
        if (error) {
            console.log(error);
            $("#modal-videoconsulta-error-conexion").modal("show");
            console.log("No se ha podido establecer la conexión con el servidor de videoconsulta");

        } else {
            // If the connection is successful, publish the publisher to the session
            session.publish(publisher, handleError);
        }
    });
    //enevento mensajes de chat recibidos
    session.on('signal:msg', function (event) {

        var contenido = event.data;
        var emisor = event.from.connectionId === session.connection.connectionId ? 'Yo' : 'Otro';
        addToConversation(emisor, "text", contenido);


    });
    //evento imagenes de chat recibidos
    session.on('signal:imagen', function (event) {

        var contenido = event.data;
        var emisor = event.from.connectionId === session.connection.connectionId ? 'Yo' : 'Otro';
        addToConversation(emisor, "imagen", contenido);


    });

}
//metodo que chequea si se puede compartir pantalla en el dispositivo
function checkScreenSharing() {
    // check for screen-sharing support:
    console.log("check for screen-sharing support:");
    OT.checkScreenSharingCapability(function (response) {
        if (!response.supported || response.extensionRegistered === false) {
            $("#compartir-pantalla").data("disponible", 0);
            $("#compartir-pantalla").remove();
            // This browser does not support screen sharing
            console.error("This browser does not support screen sharing", response);
        } else if (response.extensionInstalled === false) {
            // Prompt to install the extension.

        } else {
            //se puede compartir pantalla
            console.log("Screen sharing supported", response);
            $("#compartir-pantalla").data("disponible", 1);

        }
    });
}
//metodo que inicia la funcionalidad de compartir pantalla
function initializeScreenSharing() {
    // Screen sharing is available. Publish the screen.
    var screen_preview = document.createElement('div');
    publisher_screen = OT.initPublisher(screen_preview,
            {videoSource: 'screen', maxResolution: {width: 800, height: 600}},
            function (error) {
                if (error) {
                    console.error("Error Publishing screen", error);
                    // Look at error.message to see what went wrong.
                } else {

                    session.publish(publisher_screen, function (error) {
                        if (error) {
                            console.error("Error Publishing screen", error);
                            // Look error.message to see what went wrong.
                        } else {
                            console.log("Start Sharing screen");
                            $("#compartir-pantalla").addClass("sharing");
                            //$("#compartir-pantalla").hide();
                        }
                    });
                }
            }
    );
    //Evento para detectar cuando cambian las dimensiones de la pantalla compartida
    publisher_screen.on('videoDimensionsChanged', function (event) {
        publisher_screen.element.style.width = event.newValue.width + 'px';
        publisher_screen.element.style.height = event.newValue.height + 'px';
    });

    publisher_screen.on('mediaStopped', function (event) {
        console.log("mediaStopped sharing");
        $("#compartir-pantalla").show();
        $("#compartir-pantalla").removeClass("sharing");
    });

    publisher_screen.on('streamDestroyed', function (event) {
        $("#compartir-pantalla").show();
        $("#compartir-pantalla").removeClass("sharing");
        if (event.reason === 'mediaStopped') {
            // User clicked stop sharing
            console.log("User clicked stop sharing.");
        } else if (event.reason === 'forceUnpublished') {
            // A moderator forced the user to stop sharing.
            console.log("A moderator forced the user to stop sharing.");
        }
    });
}


$(function () {
    //notificamos al paciente que el medico ingreso

    notificar_medico_ingreso_sala();

    //realizamos la conexion
    initializeSession();

    //chequeamos si el navegador permite la funcionalidad de compartir pantalla
    checkScreenSharing();

    //listener boton finalizar llamada
    $('#hangupButton').on('click', function (e) {
        $('#final-consulta-mdl').modal('show');

    });
    //listener compartir pantalla

    $('#compartir-pantalla').on('click', function (e) {
        //activamos la opcion de compartir pantalla si esta disponible
        if ($(this).data("disponible") == 1) {
            //si ya esta compartiendo, al clickear devuelta detenemos compartir pantalla
            if ($(this).hasClass("sharing")) {
                session.unpublish(publisher_screen);
            } else {
                //inicializamos compartir pantalla
                initializeScreenSharing();
            }

        }

    });
    $("#detener-compartir-pantalla").on('click', function (e) {

    });
    //si otro paciente se conecta
    socket.on('notificar_paciente_consultorio', function (data) {

        console.log("Ingreso consultorio", data);
        //si otro paciente lo está esperando en su consultorio para otra videoconsulta, notificamos al médico
        if (data.idvideoconsulta != $("#idvideoconsulta").val() && data.evento == "ingreso") {
            console.log($("#paciente_username").val() + " + " + x_translate("Consultorio virtual"));
            notify({title: $("#paciente_username").val() + " + " + x_translate("Consultorio virtual"), text: x_translate("¡El paciente te está esperando en la sala!"), style: "video-consulta", id: data.idvideoconsulta});
        }

    });

    //Escuchamos cuando llega un mensaje de proxima VC a iniciar - mostramos notify
    socket.on('show_notify', function (data) {
        console.log("show_notify", data);
        if ($("#idvideoconsulta").val() != data.id && data.type == "recordatorio-proxima-vc") {
            console.log("recordatorio-proxima-vc");
            notify({title: data.title, text: data.text, style: data.style});
        }

    });

    //detecto click sobre el miniminzar/maximizar chat
    $(".btn-minimizar-maximizar-chat").on('click', function (e) {
        if ($(this).data("btn") == "right") {
            $(".mvc-data-col").css({"visibility": "hidden"});
            $(".mvc-data-col").css({"width": "0%"});
            $('.btn-acordion')
                    .removeClass('fa-chevron-right')
                    .addClass('fa-chevron-left')
                    .attr('title', 'Maximiser');
            $(this).data("btn", "left");
            $(".mvc-video-col").css({"width": "99%"});
          
        } else {
            $('.btn-acordion')
                    .removeClass('fa-chevron-left')
                    .addClass('fa-chevron-right')
                    .attr('title', 'Minimiser');
            $(this).data("btn", "right");
            $(".mvc-video-col").css({"width": "70%"});
            $(".mvc-data-col").css({"visibility": "visible"});
            $(".mvc-data-col").css({"width": "30%"});
            $(".icon-chat-emergente").css({"visibility": "hidden"});
            
        }
    });
});
