

var accepted = false;
var display_images_form = false;



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



//FUNCIONES JS para el manejo de chat a partir de aqui



//funcion que envia el texto del mensaje al destinatario y concatena el texto a la conversacion
function enviarMensajeChat() {

    $("#textoMensaje").tooltip("destroy");
    var text = document.getElementById('textoMensaje').value;
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

///////////////////////////////CODIGO OPENTOK

var eventStream;
var iniciada = false;

function handleError(error) {
    if (error) {
        console.error(error);
    }
}
function callback_llamada(error) {
    if (error) {
        console.log("error en llamada");
        console.log(error);
    } else {
        console.log("llamada exitosa. setear inicio llmada");
        iniciada = true;

    }

}
var connectionId = "";
function initializeSession() {
    session = OT.initSession(apiKey, sessionId);


    //cuando se crea el stram el paciente atiende llamada
    session.on('streamCreated', function streamCreated(event) {
        eventStream = event;

        console.log("stream creado");
        var subscriberOptions = {
            insertMode: 'append',
            width: '100%',
            height: '100%'
        };
        console.log("subscribe");
        if (event.stream.videoType === 'screen') {
            console.log("suscribiendose a screen stream");

            subscriber = session.subscribe(event.stream, 'screensVideo', subscriberOptions);
            //mostramos el contendor de pantalla compartida
            $("#screensVideo").show();
            //mostramos el icono de expandir la pantalla
            $("#toggle-full-screen").show();
            if ($("#toggle-full-screen").hasClass("fa-compress")) {
                $("#toggle-full-screen").find("i").removeClass("fa-compress");
                $("#toggle-full-screen").find("i").addClass("fa-expand");
            }

            subscriber.on('videoDimensionsChanged', function (event) {
                console.log("videoDimensionsChanged");
                subscriber.element.style.width = event.newValue.width + 'px';
                subscriber.element.style.height = event.newValue.height + 'px';
            });
        } else {
            console.log("suscribiendose a video stream");
            $("#callerVideo").show();
            session.subscribe(eventStream.stream, 'callerVideo', subscriberOptions, callback_llamada);
        }
        console.log("aceptar_llamada");
        aceptar_llamada();


    });

    session.on('streamDestroyed', function streamDestroyed(event) {
        console.log("streamDestroyed", event);
        if (event.stream.videoType == "screen") {
            $("#screensVideo").hide();
            $("#toggle-full-screen").hide();
            $("#callerVideo").show();
        }
        console.log("Reason:" + event.reason);
    });



    session.on('sessionDisconnected', function sessionDisconnected(event) {
        console.log('Desconectado de la sesion', event.reason);
        if (event.reason == "forceDisconnected") {
            console.log("Consulta finalizada");
            $("#modal-videoconsulta-finalizada").modal("show");
        }
        offline();
    });

//conexion y desconexion de los usuarios
    session.on({
        connectionCreated: function (event) {
            //si no soy yo
            console.log("event", event);
            console.log("session", session);
            //guardo mi ID
            if (connectionId == "" && event.connection.data == "tipo=paciente") {
                connectionId = event.connection.connectionId;
                console.log('notificar_ingreso_consultorio');
                socket.emit('notificar_ingreso_consultorio', {tipo_usuario: 'paciente', idpaciente: $("#idpaciente").val(), paciente: $("#paciente_username").val(), idmedico: $("#idmedico").val(), idvideoconsulta: $("#idvideoconsulta").val(), evento: 'ingreso'});
            }
            if (event.connection.data == "tipo=medico") {
                console.log('el otro usuario está en la sala:', event.connection);
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
            if (event.connection.data == "tipo=medico") {
                console.log('el otro usuario salió de la sala');
                console.log("razon:");
                console.log(event.reason);
                offline();
            }
        }
    });

    // initialize the publisher
    var publisherOptions = {
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

    // check for screen-sharing support:
    OT.checkScreenSharingCapability(function (response) {
        if (!response.supported || response.extensionRegistered === false) {
            // This browser does not support screen sharing
            console.error("This browser does not support screen sharing", response);
        } else {
            console.log("Screen sharing supported", response);
        }
    });
}
function aceptar_llamada() {


    accepted = true;


    console.log("llamada aceptada");
    //habilitamos las funciones de chat

    $('#btnSendMsg').prop("disabled", "");
    $('#btnAddFile').prop("disabled", "");
    $('#textoMensaje').prop("disabled", "");
    $("#textoMensaje").attr("placeholder", x_translate("Escribir mensaje"));
    display_images_form = true;



    $(".vcp-llamada").hide();
    $("#status2-online").hide();
    $("#status2-offline").hide();
    $("#status2-llamando").hide();
    console.log("publish");
    //session.publish(publisher, handleError);

}

$(function () {
    initializeSession();
    //cuando llega una solicitud de reporte de estado en el consultorio virtual - el paciente emite un mensaje de que se encuentra en el consultorio
    socket.on('get_status_ingreso_consultorio', function (data) {
        console.log("get_status_ingreso_consultorio", data);
        if ($("#idvideoconsulta").val() == data.idvideoconsulta) {
            console.log('notificar_ingreso_consultorio');
            socket.emit('notificar_ingreso_consultorio', {tipo_usuario: 'paciente', paciente: $("#paciente_username").val(), idpaciente: $("#idpaciente").val(), idmedico: $("#idmedico").val(), idvideoconsulta: $("#idvideoconsulta").val(), evento: 'ingreso'});
        }

    });
    //Escuchamos cuando llega un mensaje de que venció el tiempo de la VC y mostramos el modal
    socket.on('show_notify', function (data) {
        console.log('show_notify', data);
        if ($("#idvideoconsulta").val() == data.id && data.type == "vencimiento-vc") {
            console.log("videoconsulta vencida");
            $("#modal-videoconsulta-tiempo-espera-vencido").modal("show");
        }

    });

    $("#toggle-full-screen").click(function () {
        if ($(this).find("i").hasClass("fa-expand")) {
            $("#callerVideo").hide();
            $(this).find("i").removeClass("fa-expand");
            $(this).find("i").addClass("fa-compress");
        } else {
            $("#callerVideo").show();
            $(this).find("i").removeClass("fa-compress");
            $(this).find("i").addClass("fa-expand");
        }

    });

});





