
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


<section class="mvc-top">
    <div class="mvc-top">
        <div class="mvc-top-inner">

            <ul class="mvc-top-left">
                <li><h1>{"Consultorio Virtual"|x_translate}</h1></li>
                <li class="mvc-conexion-segura">
                    <i class="icon-doctorplus-lock"></i>
                    <span>{"Conexión segura"|x_translate}</span>
                </li>
            </ul>

            <div class="mvc-logo">
                <img src="{$IMGS}extranet/logo_doctorplus_extranet.png" alt="DoctorPlus"/>
            </div>
            <ul class="mvc-top-right">
                <li class="mvc-video-cam">
                    <i class="icon-doctorplus-video-cam"></i>
                </li>
                <li>
                <li>
                    <div class="okm-img-with-icon yellow">
                        {if $medico.imagen.perfil!=""}
                            <img src="{$medico.imagen.perfil}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {/if}
                        <figure><i id="status" class="icon-doctorplus-minus"></i></figure>
                    </div>
                    <span>{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</span>

                </li>

            </ul>

        </div>
    </div>
</section>	



<section class="mvc-video">
    <div class="mvc-video-row">
        <div class="mvc-video-col">
            <div id="callerArea" class="relative mvc-video-box">
                <video autoplay="autoplay"  playsinline="playsinline"  style="display:block; width:100%" id="callerVideo"></video>
            </div>
            <div class="mvc-video-thumb" style="z-index:601;">
                <video autoplay="autoplay" id="selfVideo"  playsinline="playsinline"  class="easyrtcMirror" style="display:block; width:100%"></video>
            </div>

            <div id="vcp-llamada" class="vcp-llamada" >
                <!--online -->		
                <div id="status2-online" class="vcm-llamada-box" style="display:none;">
                    <figure class="mvc-video-espera-img-box">
                        {if $medico.imagen.list!=""}
                            <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {/if}
                        <span class="mvc-video-espera-ingreso"><i class="icon-doctorplus-check-thin"></i></span>
                    </figure>
                    <p class="mvc-video-espera-text">{"¡El médico ingresó al consultorio!"|x_translate}
                        {"Aguarde su llamada."|x_translate}</p>
                </div>
                <!--offline -->
                <div id="status2-offline" class="vcm-llamada-box"  style="display:block;">
                    <figure class="mvc-video-espera-img-box">
                        {if $medico.imagen.list!=""}
                            <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {/if}
                        <span class="mvc-video-espera-no-ingreso"><i class="icon-doctorplus-minus"></i></span>
                    </figure>
                    <p class="mvc-video-espera-text">{"El médico no se encuentra en el consultorio virtual."|x_translate}</p>
                </div>

                <!-- Llamando-->
                <div id="status2-llamando" class="vcm-llamada-box"  style="display:none;">

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

                    <div class="vcp-call-avatar">
                        {if $medico.imagen.list!=""}
                            <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}"/>
                        {/if}
                        <span class="vcm-call-icon-state ready">
                            <i class="icon-doctorplus-check-thin"></i>
                        </span>
                    </div>

                    <div class="vcm-call-user-controls desktop-user-controls">
                        <a href="javascript:;" id="callAcceptButton" class="vcm-call-user-controls-on">
                            <figure>
                                <i class="icon-doctorplus-call-start"></i>
                            </figure>
                        </a>

                        <div class="vcm-call-user-controls-msg calling-text">
                            <span class="vcm-time calling">{"Responder"|x_translate}<span>.</span><span>.</span><span>.</span></span>
                        </div>


                        <a href="javascript:;"id="callRejectButton" class="vcm-call-user-controls-off">
                            <figure>
                                <i class="icon-doctorplus-call-close"></i>
                            </figure>
                        </a>
                    </div>
                </div>
            </div>







        </div>
        <div class="mvc-data-col">
            <div class="mvc-data-top mvp-perfil-btn">
                <ul>
                    {*<li><a href="javascript:;" id="mvc-profile-trg" class="active"><i class="icon-doctorplus-user"></i></a></li>*}
                    <li><a href="javascript:;" id="mvc-chat-trg" ><i class="icon-doctorplus-chat-comment"></i></a></li>
                </ul>
            </div>


            <div id="mvc-chat" style="display:block" >
                <div class="mvc-data-box">

                    <div  class="mvc-chat-box">
                        <div id="conversacion">

                        </div>




                    </div>
                </div>
                <div class="okm-row">
                    <form name="send_mensaje_videoconsulta" action="{$url}send_mensaje_videoconsulta.do" id="send_mensaje_videoconsulta" method="POST" role="form" onsubmit="return false">
                        <input type="hidden" id="idvideoconsulta" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
                        <div class="mvc-chat-input-box">
                            <textarea data-autoresize rows="1" id="textoMensaje"  name="mensaje" maxlength="250" disabled="true" placeholder='{"No disponible hasta iniciar VideoConsulta"|x_translate}'></textarea>
                        </div>
                        <div class="mvc-chat-btns">
                            <a href="javascript:;" id="desktop-upload-open"><i class="icon-doctorplus-camera"></i></a>
                            <button id="btnSendMsg" onclick="enviarMensajeChat()" class="btn-default" disabled="true"><i class="icon-doctorplus-right-arrow"></i></button>

                        </div>
                    </form>
                </div>
                <div id="vcm-upload-widget" class="vcm-upload-widget mvc-upload-widget">
                    <div id="vcm-upload-widget-close" class="vcm-upload-header-box">
                        <a href="javascript:;" class="vcm-upload-close"><i class="icon-doctorplus-cruz"></i></a>
                    </div>
                    <div class="vcm-upload-content-box">
                        <form name="send_imagen_videoconsulta" action="{$url}send_mensaje_videoconsulta.do" id="send_imagen_videoconsulta" method="POST" role="form" onsubmit="return false">
                            <input type="hidden" id="idvideoconsulta_img" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">

                            <!--script uploader imagenes-->

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
                                id_group=$videoconsulta_sala.paciente_idpaciente selector="#dropzone" preview="#upload-preview"  callback_success="successImg" 
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
                                            <div id="upload-preview" class="mobile-upload-preview desktop">

                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                        </form>
                    </div>
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
                    <div><img  src="" alt="" ></div>
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
                    <a href="javascript:;" data-dismiss="modal"  class="btn-default" >{"Salir"|x_translate}</a>
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
                    <img src="{$IMGS}video-consulta/camera-firefox.png"/>
                </div>        
            </div>
        </div>
    </div>
</div>
<div id="div_videoconsulta_script">
</div>
<script>
    var camera_firefox = "{$IMGS}video-consulta/camera-firefox.png";
    var camera_chrome = "{$IMGS}video-consulta/camera-chrome.png";
    var medico_username = $("#medico_username").val();
    {if $mensajes_videoconsulta!=""}
    var mensajes_videoconsulta ={$mensajes_videoconsulta};
    {/if}
    var inicio_llamada = "{$videoconsulta_sala.inicio_llamada}";

</script>

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
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-guest"><figure class="mvc-attach"><a href="#" class="mvc-video-attach-modal">' + content + '<div class="mvc-attach-btn"><i class="icon-doctorplus-search"></i></div></a></figure><span></span></div></div>';
                    $("#conversacion").append($(html_mensaje));

                } else {
                    var html_mensaje = '<div  class="okm-row  mvc-chat-line"><div class="mvc-chat-guest"><figure><span>' + medico_username + '</span><p></p></figure><span></span></div></div>';
                    $("#conversacion").append($(html_mensaje));
                    $("#conversacion p:last").text(content);
                }
            } else {
                if (msgType == "imagen") {
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-host"><figure class="mvc-attach"><a href="#" class="mvc-video-attach-modal">' + content + '<div class="mvc-attach-btn"><i class="icon-doctorplus-search"></i></div></a></figure><span></span></div></div>';
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
        ;

        function getViewportWidth() {
            return $(window).width() + getScrollBarWidth();
        }


        $(document).ready(function () {

            //video ajustes de alto

            var topH = $('.paciente-nav').outerHeight();
            var videoTopH = $('.mvc-top').outerHeight();

            var topTotalH = topH + videoTopH;

            var windowH = $(window).height();

            var resH = windowH - topTotalH;




            //		$('.mvc-video-col').outerHeight(resH);
            //		$('.mvc-data-col').outerHeight(resH);
            $('.mvc-video-col').outerHeight(resH);
            $('.mvc-data-col').outerHeight(resH);

            var inputBoxH = $('.mvc-input-box').outerHeight();

            var chatTopH = $('.mvc-data-top').outerHeight();

            var chatH = (resH - (topTotalH + inputBoxH + chatTopH + 22));


            if (chatH > 300) {
                $('.mvc-chat-box').outerHeight(chatH);
            } else {
                $('.mvc-chat-box').css('height', chatH + 'px');
            }




            $(':radio, :checkbox').radiocheck();
            $('.switch-checkbox').bootstrapSwitch();

            //quitamos el icono remover tags imput
            $(".mvc-tags-inner span[data-role='remove']").remove();


            //desplegable drozpone imagenes
            $('#desktop-upload-open').on('click', function (e) {
                e.preventDefault();
                if (display_images_form) {
                    $('#vcm-upload-widget').addClass('open');
                }
            });
            //cerrar desplegable de imagenes
            $('.vcm-upload-close').on('click', function (e) {
                e.preventDefault();
                if ($('#vcm-upload-widget').hasClass('open')) {
                    $('#vcm-upload-widget').removeClass('open');
                }
            });



            if ($('.mvc-video').length > 0) {


                $(".mvc-chat-box").mCustomScrollbar({
                    theme: "dark-3"
                });

                jQuery.each(jQuery('textarea[data-autoresize]'), function () {


                    var offset = this.offsetHeight - this.clientHeight;

                    var resizeTextarea = function (el) {
                        jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
                    };
                    jQuery(this).on('keyup input', function () {
                        resizeTextarea(this);
                    }).removeAttr('data-autoresize');
                });


                if (getViewportWidth() >= 801) {

                    $('#mvc-profile-trg').on('click', function (e) {


                        if (!$(this).hasClass('active')) {
                            $('#mvc-chat-trg').removeClass('active');
                            $(this).addClass('active');

                            $('#mvc-chat').slideUp();
                            $('#mvc-profile').slideDown();
                        }

                    });


                    $('#mvc-chat-trg').on('click', function (e) {


                        if (!$(this).hasClass('active')) {
                            $('#mvc-profile-trg').removeClass('active');
                            $(this).addClass('active');

                            $('#mvc-profile').slideUp();
                            $('#mvc-chat').slideDown();

                        }

                    });

                } else if (getViewportWidth() <= 800) {




                    $('#mvc-profile-trg').on('click', function (e) {

                        scrollToEl($('.mvc-profile-box'));
                    });

                    $('#mvc-chat-trg').on('click', function (e) {

                        scrollToEl($('.mvc-data-box'));
                    });

                }


                $('#mvc-video-btn').on('click', function (e) {
                    e.preventDefault();
                    $(this).toggleClass('mvc-llamada-terminada');
                });

                //evento desplegar modal ver imagen 
                $('#conversacion').on('click', '.mvc-video-attach-modal', function (e) {
                    e.preventDefault();
                    var img = $(this).parent().find("img").attr("src");
                    img = img.replace("_usuario.", ".");
                    $('#ver-archivo img').attr("src", img);
                    $('#ver-archivo').modal('show');
                });
            }


            if ($('.mvc-guia-grid').length > 0) {

                if (getViewportWidth() >= 601) {

                    var $grid = $('.mvc-guia-grid').masonry({
                        columnWidth: '.mvc-grid-sizer',
                        gutter: '.mvc-grid-gutter',
                        itemSelector: '.mvc-guia-item',
                        percentPosition: true
                    });

                } else if (getViewportWidth() <= 800) {

                    $('.mvc-guia-holder-trg').on('click', function (e) {
                        e.preventDefault();

                        if (!($(this).siblings('.mvc-guia-holder').hasClass('open'))) {
                            function close_all_cards() {
                                $('.mvc-guia-holder').each(function () {
                                    if ($(this).hasClass('open')) {
                                        $(this).removeClass('open');
                                        $(this).slideUp();
                                    }
                                });
                            }
                            close_all_cards();

                            $(this).siblings('.mvc-guia-holder').slideToggle().addClass('open');
                        } else {
                            $(this).siblings('.mvc-guia-holder').slideToggle().removeClass('open');
                        }
                    });

                }
            }

            //al terminar la videoconsulta cuando cerramos el modal salimos de la sala
            $("#modal-videoconsulta-finalizada").on('hidden.bs.modal', function () {
                var notificar_conclusion_vc_pendiente = localStorage.getItem('notificar_conclusion_vc_pendiente');
                localStorage.setItem('notificar_conclusion_vc_pendiente', '1');
                window.location.href = BASE_PATH + "panel-paciente/";
            });
            //recaergamos la sala si se pierde la conexion
            $("#modal-videoconsulta-error-conexion").on('hidden.bs.modal', function () {
                x_loadModule('videoconsulta', 'videoconsulta_modulo', '', 'div_videoconsulta_modulo');
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
                })
            }
        });
    </script>		
{/literal}


