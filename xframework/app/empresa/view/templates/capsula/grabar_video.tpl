<style>
    .dim-rec-punteado{
        width: 70% !important;
        height: 250px !important;
    }
    .mensaje-upload{
        position: relative;
        bottom: 30px;
    }
    .span-aviso{
        position: relative;
        right: 100px;
    }
    .video-dim{
        width: 550px;
        position: relative;
        bottom: 230px;
        height: 350px;
        margin-bottom: 15px;
    }
    .label-titulos{
        font-size: 15px;
        font-weight: 600;
    }
    .color-btn-detener{
        background: #c03d4f !important;
    }
    .color-btn-detener:hover { 
        background: #dd7684 !important;

    }
    .color-btn-detener:active { 
        background: #c03d4f !important;

    }
    .color-btn-detener:visited { 
        background: #c03d4f !important;

    }
    .color-btn-detener:after { 
        background: #c03d4f !important;

    }
    .link-video{
        position: relative;
        top: 50px;
        left: 10px;
        display: none;
        width: 250px;
        background: #82B9EE;
        height: 70px;
        border-radius: 60px;
        color: white;
        font-size: 20px;
        align-items: center;
        justify-content: center;

    }
    .link-video:hover {
        color: white !important;   
        background: #b2cee9;
    }
    .link-video:active {
        color: white !important;   
    }
    .link-video:visited {
        color: white !important;   
    }


</style>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

</head>
<div  class="col-xs-12 ">
    <div  class="col-xs-6 ">
        <a href="javascript:;" class="mvc-video-btn llamada-end" id="hangupButton" style="z-index: 20000; position: relative; top: 30px; left: 130px; display: none; width: 250px; ">
            <figure style="transform: rotate(0deg);">

                <i  class="fa fa-video"></i>
            </figure>
            <div class="mvc-video-end-label">
                <span class="mvc-video-end-time">
                    <span class="cs-ca-tiempo-respuesta-num" id="timer-tiempo-restante"> <p style="margin-bottom: 0px;" id="duracion"></p></span>
                </span>
                <span class="mvc-video-end-text">{"Tiempo de grabacion"|x_translate}</span>
            </div>
        </a>

        <a class="link-video"  target="_blank" id="rept"><i style="margin-right: 10px; margin-top: 5px; font-size: 28px;" class="fa fa-film"></i> {"Ver grabacion"|x_translate} </a>
    </div>

    <div style="position: relative; bottom: 140px;"  class="col-xs-6 ">

        <label hidden  class="label-titulos" for="dispositivosDeAudio">{"Micrófono:"|x_translate}</label><br>
        <select name="dispositivosDeAudio" id="dispositivosDeAudio"></select>
        <br><br>
        <label hidden class="label-titulos" for="dispositivosDeVideo">{"Cámara:"|x_translate}</label><br>
        <select  name="dispositivosDeVideo" id="dispositivosDeVideo"></select>
        <br>

        <div style="position: relative; bottom: 220px; margin-bottom: 15px;">
            <button class="btn btn-default" id="btnComenzarGrabacion"><i class="fa fa-play-circle"></i>{"Comenzar"|x_translate}</button>
            <button  class="btn btn-default color-btn-detener" id="btnDetenerGrabacion"><i class="fa fa-stop-circle"></i>{"Detener"|x_translate}</button>
        </div>

        <video  class="video-dim"   id="v"></video>
        <video class="video-dim"  muted="muted" id="video"></video>
        <button  style="position: relative; bottom: 250px; display: none; margin-inline: auto;"   id="btnSiguiente" type="submit" class="btn-default btn-siguiente btn-default-iban">{"Siguiente"|x_translate}</button>
    </div>
</div>




<div  class="col-xs-6">

</div>

<input   hidden  id="idGrabacion" name="idGrabacion">


{*TEST RTC*}
<link rel="stylesheet" href="{$url}xframework/app/themes/dp02/css/checkrtc.css">
<script type="text/javascript" src="https://static.opentok.com/v2/js/opentok.min.js"></script>
<script src="{$url}xframework/files/session_conectividad.js"></script>
<script src="{$url}xframework/core/libs/libs_js/bundle_test_conectividad_2.js"></script>
<div id="run-checkrtc" class="modal fade " tabindex="-1" role="dialog"  data-backdrop="static" data-keyboard="false" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-dialog-centered" role="document" >
        <div class="modal-content" id="checkRTC_container">
        </div>
    </div>
</div>

{x_load_js}
{literal}
    <script>


        $(function () {
            titulo = $("#input_titulo").val();

            $("#input_titulo").keypress(function () {
                if ($("#input_titulo").val().length >= 0) {
                    $("#input_titulo").css('border', '1px solid #ccc');

                } else {
                    $("#input_titulo").css('border', 'solid 2px red');
                }
            });


            $("#btnSiguiente").click(function () {

                idGrabacion = $("#idGrabacion").val();

                if ($("#cant_capsulas_lista").val() < 1) {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=actualizar_columna_estado_capsula_grabacion",
                            'idGrabacion=' + idGrabacion,
                            function (data) {
                                if (data.result) {
                                    hs = $("#btnSiguiente").data("hash");
                                    //  console.log(hs);
                                    window.location.href = BASE_PATH + "entreprises/capsuleresready/" + hs + ".html";
                                    //  console.log($("#btnSiguiente").data("hash")); 
                                }
                            }

                    );

                } else {
                    x_alert(x_translate('Solo puede tener una capsula para ser compartida'));
                }
            });

        });


        const init = () => {
            const tieneSoporteUserMedia = () =>
                !!(navigator.mediaDevices.getUserMedia);

            // Si no soporta...
            // Amable aviso para que el mundo comience a usar navegadores decentes ;)
            if (typeof MediaRecorder === "undefined" || !tieneSoporteUserMedia())
                return x_alert(x_translate("Tu navegador web no cumple los requisitos; por favor, actualiza a un navegador decente como Firefox o Google Chrome"));


            // Declaración de elementos del DOM
            const $dispositivosDeAudio = document.querySelector("#dispositivosDeAudio"),
                    $dispositivosDeVideo = document.querySelector("#dispositivosDeVideo"),
                    $duracion = document.querySelector("#duracion"),
                    $reproducir = document.querySelector("#reproducir"),
                    $video = document.querySelector("#video"),
                    $vvideo = document.querySelector("#v"),
                    $btnComenzarGrabacion = document.querySelector("#btnComenzarGrabacion"),
                    $btnDetenerGrabacion = document.querySelector("#btnDetenerGrabacion"),
                    $hangupButton = document.querySelector("#hangupButton");


            // Algunas funciones útiles
            const limpiarSelect = elemento => {
                for (let x = elemento.options.length - 1; x >= 0; x--) {
                    elemento.options.remove(x);
                }
            }

            const segundosATiempo = numeroDeSegundos => {
                let horas = Math.floor(numeroDeSegundos / 60 / 60);
                numeroDeSegundos -= horas * 60 * 60;
                let minutos = Math.floor(numeroDeSegundos / 60);
                numeroDeSegundos -= minutos * 60;
                numeroDeSegundos = parseInt(numeroDeSegundos);
                if (horas < 10)
                    horas = "0" + horas;
                if (minutos < 10)
                    minutos = "0" + minutos;
                if (numeroDeSegundos < 10)
                    numeroDeSegundos = "0" + numeroDeSegundos;

                return `${horas}:${minutos}:${numeroDeSegundos}`;
            };
            // Variables "globales"
            let tiempoInicio, mediaRecorder, idIntervalo;
            const refrescar = () => {
                $("#hangupButton").css("display", "block");
                $duracion.textContent = segundosATiempo((Date.now() - tiempoInicio) / 1000);
            }

            // Consulta la lista de dispositivos de entrada de audio y llena el select
            const llenarLista = () => {
                navigator
                        .mediaDevices
                        .enumerateDevices()
                        .then(dispositivos => {
                            limpiarSelect($dispositivosDeAudio);
                            limpiarSelect($dispositivosDeVideo);
                            dispositivos.forEach((dispositivo, indice) => {
                                if (dispositivo.kind === "audioinput") {
                                    const $opcion = document.createElement("option");
                                    // Firefox no trae nada con label, que viva la privacidad
                                    // y que muera la compatibilidad
                                    $opcion.text = dispositivo.label || `Micrófono ${indice + 1}`;
                                    $opcion.value = dispositivo.deviceId;
                                    $dispositivosDeAudio.appendChild($opcion);
                                } else if (dispositivo.kind === "videoinput") {
                                    const $opcion = document.createElement("option");
                                    // Firefox no trae nada con label, que viva la privacidad
                                    // y que muera la compatibilidad
                                    $opcion.text = dispositivo.label || `Cámara ${indice + 1}`;
                                    $opcion.value = dispositivo.deviceId;
                                    $dispositivosDeVideo.appendChild($opcion);
                                }
                            })
                        })
            };
            // Ayudante para la duración; no ayuda en nada pero muestra algo informativo
            const comenzarAContar = () => {
                tiempoInicio = Date.now();
                idIntervalo = setInterval(refrescar, 500);
            };

            // Comienza a grabar el audio con el dispositivo seleccionado
            const comenzarAGrabar = () => {
                $("#v").css('display', 'none');
                $('#dispositivosDeAudio').val(0);
                $('#dispositivosDeVideo').val(0);
                titulo = $("#input_titulo").val();
                if (titulo < 1) {
                    x_alert(x_translate("Debe completar un titulo"));
                    $("#input_titulo").css('border', 'solid 2px red');
                    return false;
                }
                if (!$dispositivosDeAudio.options.length)
                    return x_alert(x_translate("No hay micrófono"));
                if (!$dispositivosDeVideo.options.length)
                    return x_alert(x_translate("No hay cámara"));
                // No permitir que se grabe doblemente
                if (mediaRecorder)
                    return x_alert(x_translate("Ya se está grabando"));

                navigator.mediaDevices.getUserMedia({
                    audio: {
                        deviceId: $dispositivosDeAudio.value, // Indicar dispositivo de audio
                    },
                    video: {
                        deviceId: $dispositivosDeAudio.value, // Indicar dispositivo de vídeo
                    }
                })
                        .then(stream => {
                            // Poner stream en vídeo
                            $video.srcObject = stream;
                            $video.play();
                            // Comenzar a grabar con el stream
                            mediaRecorder = new MediaRecorder(stream, {mimeType: 'video/webm'});
                            mediaRecorder.start();
                            comenzarAContar();
                            // En el arreglo pondremos los datos que traiga el evento dataavailable
                            const fragmentosDeAudio = [];
                            // Escuchar cuando haya datos disponibles
                            mediaRecorder.addEventListener("dataavailable", evento => {
                                // Y agregarlos a los fragmentos
                                fragmentosDeAudio.push(evento.data);
                            });
                            // Cuando se detenga (haciendo click en el botón) se ejecuta esto
                            mediaRecorder.addEventListener("stop", () => {
                                // Pausar vídeo
                                $video.pause();
                                // Detener el stream
                                stream.getTracks().forEach(track => track.stop());
                                // Detener la cuenta regresiva
                                detenerConteo();
                                // Convertir los fragmentos a un objeto binario
                                const blobVideo = new Blob(fragmentosDeAudio, {type: "video/webm"});

                                const formData = new FormData();

                                // Enviar el BinaryLargeObject con FormData
                                idGrabacion = $("#idGrabacion").val();
                                titulo = $("#input_titulo").val();
                                formData.append("idGrabacion", idGrabacion);
                                formData.append("titulo", titulo);
                                formData.append("video", blobVideo);
                                const RUTA_SERVIDOR = "cargar_grabacion.do";
                                //  $duracion.textContent = alert("Cargando video");


                                fetch(RUTA_SERVIDOR, {
                                    method: "POST",
                                    body: formData,
                                })
                                        .then(respuestaRaw => respuestaRaw.text()) // Decodificar como texto
                                        .then(respuestaComoTexto => {
                                            // Aquí haz algo con la respuesta ;)
                                            //  console.log(respuestaComoTexto);
                                            //    console.log(respuestaComoTexto);
                                            porciones = respuestaComoTexto.split('hash');
                                            porcionesF = porciones[1].split(',');
                                            // console.log(porciones[0]);
                                            hashFinal = porcionesF[0].slice(3, -1);
                                            //   console.log(hashFinal);
                                            arrelink = porciones[0].split('{');

                                            param = $.trim(arrelink[0]);
                                            porcionesid = respuestaComoTexto.split('idGrabacion');
                                            cadP = param.split('xframework');
                                            idGr = porcionesid[1].slice(2, -1);
                                            //  console.log(idGr);
                                            if ($("#idGrabacion").val() == '') {
                                                $("#idGrabacion").val(idGr);
                                            }

                                            $("#rept").css("display", "flex");
                                            $("#rept").prop("href", BASE_PATH + "xframework" + cadP[1]);

                                            // console.log(hashFinal);
                                            // Abrir el archivo, es opcional y solo lo pongo como demostración
                                            //      $reproducir.innerHTML = `<a style="position: relative; top: 100px;" target="_blank" href="{$url}${param}">Open</a>`
                                            $("body").spin(false);
                                            $("#btnSiguiente").css("display", "block");
                                            $('#btnSiguiente').data('hash', hashFinal);

                                        })
                            });
                        })
                        .catch(error => {
                            // Aquí maneja el error, tal vez no dieron permiso
                            console.log(error);
                        });
            };


            const detenerConteo = () => {
                clearInterval(idIntervalo);
                tiempoInicio = null;
                //  $duracion.textContent = "";
            }

            const detenerGrabacion = () => {
                if (!mediaRecorder)
                    return x_alert(x_translate("No se está grabando"));
                $("body").spin("large");
                mediaRecorder.stop();
                mediaRecorder = null;
            };


            $btnComenzarGrabacion.addEventListener("click", comenzarAGrabar);
            $btnDetenerGrabacion.addEventListener("click", detenerGrabacion);
            $hangupButton.addEventListener("click", detenerGrabacion);


            // Cuando ya hemos configurado lo necesario allá arriba llenamos la lista

            llenarLista();
        }

        // Esperar a que el documento esté listo...
        document.addEventListener("DOMContentLoaded", init);


        $(document).ready(function () {
            $('#dispositivosDeVideo').hide();
            $('#dispositivosDeAudio').hide();
            var hide_checkrtc_modal_paciente = localStorage.getItem('hide_checkrtc_modal_paciente');
            if (hide_checkrtc_modal_paciente == "1") {
                $("#checkRTC_container").empty();
                $("#checkRTC_container").spin("large");
                $("#run-checkrtc").modal("show");

                x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                    $("#checkRTC_container").spin(false);
                });
            } else {

            }
        });


        window.addEventListener('load', initt);
        function initt() {
            $dispositivosDeVideo = document.querySelector("#dispositivosDeVideo"),
                    $dispositivosDeAudio = document.querySelector("#dispositivosDeAudio"),
                    $vvideo = document.querySelector("#v");


            navigator.mediaDevices.getUserMedia({

                video: {
                    deviceId: $dispositivosDeAudio.value, // Indicar dispositivo de vídeo
                }
            })
                    .then(stream => {
                        // Poner stream en vídeo
                        $vvideo.srcObject = stream;
                        $vvideo.play();
                    })
                    .catch(error => {
                        // Aquí maneja el error, tal vez no dieron permiso
                        console.log(error);
                    });

        }

    </script> 
{/literal}