<input type="hidden" id="room" value="{$room_name}">

<input type="hidden" id="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
<input type="hidden" id="idpaciente" value="{$paciente.idpaciente}">
<input type="hidden" id="idmedico" value="{$videoconsulta_sala.medico_idmedico}">
{if $paciente.paciente_titular!=""}
    <input type="hidden" id="myUserName" value="{$paciente.paciente_titular.relacion|capitalize:true} del paciente">
{else}
    <input type="hidden" id="myUserName" value="{$paciente.nombre} {$paciente.apellido}">
{/if}
<input type="hidden" id="medico_username" value="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">

<section class="vcm-container">
    <nav class="vcm-menu paciente">
        <ul>
            <li><a href="javascript:;" id="mvc-video-trg" data-target="video" class="active"><i class="icon-doctorplus-video-cam"></i></a></li>
            <li><a href="javascript:;" id="mvc-chat-trg"  data-target="chat"><i class="icon-doctorplus-chat-comment"></i></a></li>
        </ul>
    </nav>

    <div class="vcm-video-box">
        <div id="callerArea" class="vcm-video-in">
            <video id="callerVideo"  playsinline="playsinline" width="100%" autoplay="autoplay" >
            </video>

        </div>
        <div class="vcm-video-out">
            <video  playsinline="playsinline" width="100%" autoplay="autoplay"  id="selfVideo" class="easyrtcMirror">
            </video>
        </div>
    </div>






    <div id="vcm-chat" class="vcm-chat">
        <div class="vcm-chat-box">

            <div id="conversacion">

            </div>
        </div>
        <form name="send_mensaje_videoconsulta" action="{$url}send_mensaje_videoconsulta.do" id="send_mensaje_videoconsulta" method="POST" role="form" onsubmit="return false;">
            <input type="hidden" id="idvideoconsulta" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">

            <div class="vcm-chat-controls">
                <div class="vcm-chat-controls-holder">
                    <a href="javascript:;" id="vcm-upload-btn" class="mvc-chat-upload-btn"><i class="icon-doctorplus-camera"></i></a>
                    <figure class="mvc-chat-input">
                        <input type="text" id="textoMensaje"  name="mensaje" placeholder='{"No disponible hasta iniciar VideoConsulta"|x_translate}' maxlength="250" disabled="true"/>
                    </figure>
                    <button id="btnSendMsg" onclick="enviarMensajeChat()" disabled="true" class="mvc-chat-send"><i class="icon-doctorplus-right-arrow"></i></button>
                </div>
            </div>
        </form>




        <div id="vcm-upload-widget" class="vcm-upload-widget">
            <div id="vcm-upload-widget-close" class="vcm-upload-header-box">
                <a href="#" class="vcm-upload-close"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <div class="vcm-upload-content-box">
                <form name="send_imagen_videoconsulta" action="{$url}send_mensaje_videoconsulta.do" id="send_imagen_videoconsulta" method="POST" role="form" onsubmit="return false;">
                    <input type="hidden" id="idvideoconsulta_img" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
                    {literal}
                        <script>


                            //callbacks de la imagen
                            var successImg = function (file, responseText) {
                                $("#vcm-upload-widget").spin(false);
                                if (file.previewElement && responseText.status == 1) {
                                    return file.previewElement.classList.add("dz-success");
                                } else {
                                    //x_alert(responseText.error);
                                    errorImg(file, responseText.error);
                                }

                            };


                            var stopImg = function (file) {
                                $("#vcm-upload-widget").spin(false);

                                if (file.previewElement) {
                                    return file.previewElement.classList.add("dz-complete");
                                }
                                //$("#dropzone").spin(false);
                            };
                            var errorImg = function (file, message) {
                                $("#vcm-upload-widget").spin(false);
                                if (typeof message !== "String" && message.error) {
                                    message = message.error;
                                }
                                if ((file.size / 1024 / 1024) > 8) {
                                    message = x_translate("Error. Tamaño máximo de archivo 8 MB.");

                                }
                                x_alert(message);
                                Dropzone.forElement("#dropzone").removeFile(file);
                                var node, _i, _len, _ref, _results;
                                if (file.previewElement) {
                                    file.previewElement.classList.add("dz-error");
                                    if (typeof message !== "String" && message.error) {
                                        message = message.error;
                                    }
                                    _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]");
                                    _results = [];
                                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                                        node = _ref[_i];
                                        _results.push(node.textContent = message);
                                    }
                                    return _results;
                                }
                            };
                            var startImg = function (file) {

                                if (file.previewElement) {
                                    file.previewElement.classList.add("dz-processing");
                                    if (file._removeLink) {
                                        return file._removeLink.textContent = this.options.dictCancelUpload;
                                    }
                                }


                                $("#vcm-upload-widget").spin("large");
                            };
                        </script> 
                    {/literal}
                    <div  class="vcm-upload-controls ">

                        {x_component_upload_multiple_img manager="ManagerArchivosMensajeVideoConsulta" 
                        id_group=$videoconsulta_sala.paciente_idpaciente selector="#dropzone"  preview="#upload-preview" callback_success="successImg" 
                        callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png"  from_videoconsulta="1" addRemoveLinks="false" createImageThumbnails="true" }
                        <div class="vcm-upload-content-box">
                            <div class="vcm-upload-controls">
                                <div  class="vcm-upload-holder ">

                                    <i class="icon-doctorplus-camera"></i>
                                    <span>{"Agregar exámen, estudio o foto"|x_translate}</span>
                                    <p>{"Las fotos o archivos no deben pesar más de 8 MB."|x_translate} 
                                        {"Los mismos quedarán almacenados en el Perfil de Salud del paciente."|x_translate}</p>
                                    <div id="dropzone"  class="mobile-upload-widget"></div>

                                </div>
                                <button id="btnSendImg" class=" btn-default" onclick="enviarImagenChat()" >{"enviar"|x_translate}</button>
                                <div class="vcm-upload-slide-control-box">
                                    <div id="upload-preview" class="mobile-upload-preview desktop" >

                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </form>
            </div>
        </div>

    </div>
    <div id="vcm-attach-widget" class="vcm-upload-widget">
        <div  class="vcm-upload-header-box">
            <a href="javascript:;" id="vcm-attach-widget-close" class="vcm-upload-close"><i class="icon-doctorplus-cruz"></i></a>
        </div>

        <div class="vcm-attach-widget-img-box">
            <div class="vcm-attach-slide-master-box">
                <div class="vcm-attach-slide-master">
                </div>
            </div>
            <div class="vcm-attach-slide-control-box">
                <div   class="vcm-attach-slide-control">
                </div>
            </div>

        </div>
    </div>
    <div id="div_llamar" class="vcm-llamada">
        <div class="vcm-llamada-box">

            <div id="status2-offline" >
                <div  class="vcm-call-avatar">
                    {if $medico.imagen.list!=""}
                        <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {else}
                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {/if}
                    <span class="vcm-call-icon-state standby">
                        <i class="icon-doctorplus-minus"></i>
                    </span>
                </div>

                <p class="vcm-call-notification">
                    {"El médico no se encuentra en el consultorio virtual."|x_translate}
                </p>

            </div>


            <div id="status2-online" style="display:none;">

                <div  class="vcm-call-avatar">
                    {if $medico.imagen.list!=""}
                        <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {else}
                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {/if}
                    <span class="vcm-call-icon-state ready">
                        <i class="icon-doctorplus-check-thin"></i>
                    </span>
                </div>

                <p class="vcm-call-notification ready">
                    {"¡El médico ingresó al consultorio!"|x_translate}<br>
                    {"Aguarde su llamado..."|x_translate}
                </p>

            </div>
            <!-- Llamando-->
            <div id="status2-llamando"  style="display:none;">
                <figure class="vcm-avatar-call-in">
                    <span class="vcm-avatar-call-in-user">{"Video llamada entrante..."|x_translate}</span>
                    <span class="vcm-avatar-call-in-arrow">
                        <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                             viewBox="0 0 12.3 10.2" enable-background="new 0 0 12.3 10.2" xml:space="preserve">
                        <path fill="#08151B" stroke="#F6F7F7" stroke-linecap="square" stroke-linejoin="round" d="M0.9,0L5,8.2c0,0,0.9,1.2,2.4,0L11.4,0"
                              />
                        </svg>
                    </span>
                </figure>



                <div  class="vcm-call-avatar">
                    {if $medico.imagen.list!=""}
                        <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {else}
                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                    {/if}
                    <span class="vcm-call-icon-state ready">
                        <i class="icon-doctorplus-check-thin"></i>
                    </span>
                </div>

                <div class="vcm-call-user-controls">
                    <a href="javascript:;" id="callAcceptButton" class="vcm-call-user-controls-on">
                        <figure>
                            <i class="icon-doctorplus-call-start"></i>
                        </figure>
                    </a>

                    <div class="vcm-call-user-controls-msg calling-text">
                        <span class="vcm-time calling">{"Responder"|x_translate}<span>.</span><span>.</span><span>.</span></span>
                    </div>


                    <a href="javascript:;" id="callRejectButton" class="vcm-call-user-controls-off">
                        <figure>
                            <i class="icon-doctorplus-call-close"></i>
                        </figure>
                    </a>
                </div>

            </div>
        </div>

    </div>

</section>

<!-- Modal VER Archivo -->
<div class="modal fade modal-type-1" id="ver-archivo">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>


            </div>
            <div class="modal-body">
                <div class="mvc-video-modal">
                    <div><img class="img-responsive"  src="" alt="" ></div>
                </div>						
            </div>
        </div>
    </div>
</div>

<!-- Modal Video Consultas error -->

<div id="modal-videoconsulta-error-conexion" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon"><i class="icon-doctorplus-alert-round"></i></figure>
                <h3 class="modal-sub-title">{"Error de conexión"|x_translate}</h4>
                    <h4 class="modal-title">{"No se ha podido establecer la conexión con el servidor de Video Consulta. Intente nuevamente o contacte al administrador"|x_translate}</h3>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="{$url}panel-paciente/videoconsulta/" class="btn-default" >{"Salir"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!--	Modal videoconsulta finalizada	-->
<div id="modal-videoconsulta-finalizada" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡La Video Consulta ha finalizado!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Podrá ver las conclusiones de la misma en el Registro de Consultas Médicas desde su Perfil de Salud."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Video Consultas Compartir dispotivos -->
<div class="modal fade bs-example-modal-lg modal-perfil-completo" id="modal-videoconsulta-compartir-dispositivos" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <h4 class="modal-title">{"Compartir dispositivos"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Debe compartir su cámara y micrófono para iniciar la Video Consulta"|x_translate}
                </p>
                <div align="center">
                    <img src="{$IMGS}video-consulta/camera-firefox.png" alt="Compartir dispositivos"/>
                </div>        
            </div>
        </div>
    </div>
</div>

<script>
    var camera_firefox = "{$IMGS}video-consulta/camera-firefox.png";
    var camera_chrome = "{$IMGS}video-consulta/camera-chrome.png";
    var medico_username = $("#medico_username").val();
    {if $mensajes_videoconsulta!=""}
    var mensajes_videoconsulta ={$mensajes_videoconsulta};
    {/if}
    var inicio_llamada = "{$videoconsulta_sala.inicio_llamada}";
    var display_images_form = false;
</script>



{x_load_js}
{literal}
    <script type="text/javascript">

        //funcion que concatena el texto ingresado del lado cliente a la ventana de conversacion
        function addToConversation(who, msgType, content) {

            //mostramos la ventana si esta oculto el chat
            if (!$("#mvc-chat-trg").hasClass('active')) {
                $("#mvc-chat-trg").click();
            }

            if (who !== "Yo") {
                if (msgType == "imagen") {
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-guest"><figure class="mvc-attach"><a href="javascript:;" class="vcm-chat-attach">' + content + '<div class="mvc-attach-btn"><i class="icon-doctorplus-search"></i></div></a></figure><span></span></div></div>';
                    var img_modal_big = content.replace("_usuario.", ".");
                    img_modal_big = img_modal_big.replace("style='width:100px;'", "");
                    var html_modal_big = "<div>" + img_modal_big + "</div>";
                    $(".vcm-attach-slide-master").slick('slickAdd', html_modal_big);
                    console.log($(".vcm-attach-slide-master").slick('setPosition'));


                    var img_modal_min = content.replace("_usuario.", "_perfil.");
                    img_modal_min = img_modal_min.replace("style='width:100px;'", "");

                    var html_modal_min = "<div>" + img_modal_min + "</div>";
                    $(".vcm-attach-slide-control").slick('slickAdd', html_modal_min);
                    $(".vcm-attach-slide-control").slick('setPosition');
                    $("#conversacion").append($(html_mensaje));
                } else {
                    var html_mensaje = '<div  class="okm-row  mvc-chat-line"><div class="mvc-chat-guest"><figure><span>' + medico_username + '</span><p></p></figure><span></span></div></div>';
                    $("#conversacion").append($(html_mensaje));
                    $("#conversacion p:last").text(content);
                }
            } else {
                if (msgType == "imagen") {
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-host"><figure class="mvc-attach"><a href="javascript:;" class="vcm-chat-attach">' + content + '<div class="mvc-attach-btn"><i class="icon-doctorplus-search"></i></div></a></figure><span></span></div></div>';
                    var img_modal_big = content.replace("_usuario.", ".");
                    img_modal_big = img_modal_big.replace("style='width:100px;'", "");
                    var html_modal_big = "<div>" + img_modal_big + "</div>";
                    $(".vcm-attach-slide-master").slick('slickAdd', html_modal_big);
                    $(".vcm-attach-slide-master").slick('setPosition');
                    var img_modal_min = content.replace("_usuario.", "_perfil.");
                    img_modal_min = img_modal_min.replace("style='width:100px;'", "");
                    var html_modal_min = "<div>" + img_modal_min + "</div>";
                    $(".vcm-attach-slide-control").slick('slickAdd', html_modal_min);
                    $(".vcm-attach-slide-control").slick('setPosition');
                    $("#conversacion").append($(html_mensaje));
                } else {
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-host"><figure><span></span><p></p></figure><span></span></div></div>';
                    $("#conversacion").append($(html_mensaje));
                    $("#conversacion p:last").text(content);
                }
            }
            //vamos al aultimo mensaje
            $(".mvc-chat-box").mCustomScrollbar("scrollTo", "bottom");
        }



        $(document).ready(function () {

            $(".mvc-chat-box").mCustomScrollbar({
                theme: "dark-3"
            });

            //boton finalizar llamada
            $('#hangupButton').on('click', function (e) {
                $('#final-consulta-mdl').modal('show');

            });


            $('#mvc-video-btn').on('click', function (e) {
                e.preventDefault();
                $(this).toggleClass('mvc-llamada-terminada');
            });







            //al cerrar el modal de compartir dispositivos solicitamos nuevamente el recurso
            $('#modal-videoconsulta-compartir-dispositivos').on('hidden.bs.modal', function () {
                if ($("#selfVideo").attr("src") == undefined) {

                    initMediaSource();
                }
            });
            //al mostrar el modal de compartir dispositivos seteamos la imagen del alerta correspondiente al navegador
            $('#modal-videoconsulta-compartir-dispositivos').on('show.bs.modal', function () {
                if (navigator.userAgent.indexOf('Chrome') == -1) {
                    var src = camera_firefox;
                } else {
                    var src = camera_chrome;
                }

                $('#modal-videoconsulta-compartir-dispositivos img').attr("src", src);
            });
            //al transucrrir la videoconsulta cuando cerramos el modal salimos de la sala
            $("#modal-tiempo-transcurrido").on('hidden.bs.modal', function () {
                window.location.href = BASE_PATH;
            });

            /**MOBILE*/
            //modal desplegable con imagenes del chat

            $('#conversacion').on('click', '.vcm-chat-attach', function (e) {

                e.preventDefault();
                var img = $(this).parent().find("img").attr("src");
                img = img.replace("_usuario.", ".");
                $('#ver-archivo img').attr("src", img);
                $('#ver-archivo').modal('show');
                /*
                 if (!$('#vcm-attach-widget').hasClass('open')) {
                 $('#vcm-attach-widget').addClass('open');
                 }
                 if($("#conversacion .vcm-chat-attach").length>0){ 
                 var index=$("#conversacion .vcm-chat-attach").index($(this));
                 $(".vcm-attach-slide-control").slick('slickGoTo',index);
                 }else{
                 $(".vcm-attach-slide-master").slick('setPosition');
                 }*/
            });
            $('#vcm-attach-widget-close').on('click', function (e) {
                e.preventDefault();
                if ($('#vcm-attach-widget').hasClass('open')) {
                    $('#vcm-attach-widget').removeClass('open');
                }
            });


            $('.vcm-attach-slide-master').slick({
                slidesToShow: 1,
                slidesToScroll: 1,
                arrows: false,
                fade: true,
                dots: false,
                centerMode: false,
                asNavFor: '.vcm-attach-slide-control'
            });
            $('.vcm-attach-slide-control').slick({
                asNavFor: '.vcm-attach-slide-master',
                arrows: false,
                dots: false,
                variableWidth: true,
                focusOnSelect: true,
                centerMode: false,
                infinite: false
            });




            var chat = $('#vcm-chat');
            var btns = $('.vcm-menu').find('a');




            var uploadWidgetOpen = $('#vcm-upload-btn');
            var uploadWidgetClose = $('#vcm-upload-widget-close');
            var uploadWidget = $('#vcm-upload-widget');

            function removeActive() {
                btns.removeClass('active');
            }

            btns.on('click', function (e) {
                // e.preventDefault();

                var target = $(this).data('target');


                if (target == 'video') {
                    //si se inicio la conexion o no, mostramos el footer para cortar o el status del paciente
                    if (display_images_form) {
                        $("#div_llamar").hide();
                    } else {
                        $("#div_llamar").show();
                    }

                    removeActive();
                    $(this).addClass('active');


                    if (chat.hasClass('open')) {
                        chat.removeClass('open');
                    }
                }



                if (target == 'chat') {
                    console.log("chat");
                    $(".vcm-llamada").hide();
                    removeActive();
                    $(this).addClass('active');

                    if (!chat.hasClass('open')) {
                        chat.addClass('open');
                    }
                }


            });





            uploadWidgetOpen.on('click', function (e) {
                if (display_images_form) {


                    e.preventDefault();
                    if (!uploadWidget.hasClass('open')) {
                        uploadWidget.addClass('open');
                    }
                }
            });

            uploadWidgetClose.on('click', function (e) {
                e.preventDefault();
                if (uploadWidget.hasClass('open')) {
                    uploadWidget.removeClass('open');
                }
            });


            $(".vcm-chat-box").mCustomScrollbar({
                theme: "dark-3",
                autoDraggerLength: true,
                setTop: "-999999px"
            });
            $(".vcm-panel-holder").mCustomScrollbar({
                theme: "dark-3",
                autoHideScrollbar: false,
                autoDraggerLength: true
            });

            //al terminar la videoconsulta cuando cerramos el modal salimos de la sala
            $("#modal-videoconsulta-finalizada").on('hidden.bs.modal', function () {
                var notificar_conclusion_vc_pendiente = localStorage.getItem('notificar_conclusion_vc_pendiente');
                localStorage.setItem('notificar_conclusion_vc_pendiente', '1');
                window.location.href = BASE_PATH;
            });


            //agregamos los mensajes al chat
            if (typeof mensajes_videoconsulta != "undefined") {
                mensajes_videoconsulta.forEach(function (elem, indice) {
                    console.log(elem)
                    if (elem.emisor == "p") {
                        var emisor = "Yo";
                    } else {
                        var emisor = "Medico";
                    }

                    if (elem.is_imagen == 1) {
                        var tipo = "imagen";
                        var contenido = "<img src=' " + elem.imagen.path_images_usuario + "' alt='" + elem.imagen.nombre + "." + elem.imagen.ext + "'  title='" + elem.imagen.nombre + "." + elem.imagen.ext + "' style='width:100px;'>";

                    } else {
                        var tipo = "Texto";
                        var contenido = elem.mensaje;
                    }

                    addToConversation(emisor, tipo, contenido);
                });
            }
            //dejamos seleccionado el menu de video
            $("#mvc-video-trg").click();

        });
    </script>		
{/literal}
