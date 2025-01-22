{if  !$videoconsulta_sala || $videoconsulta_sala.idvideoconsulta==""}
    <body class="pe-body">
        <section class="pe-container">
            <div class="pe-error-holder">
                <div class="pe-card">
                    <img src="{$IMGS}doctorplus_logo_200.png" alt="DoctorPlus"/>
                    <h3>{"Consultorio virtual no habilitado"|x_translate}</h3>
                    {if $tiempo_proxima!=""}
                        <p>{"Su próxima Video Consulta inicia:"|x_translate} {$tiempo_proxima}</p>
                    {else}
                        <p>{"Ud. no posee Video Consultas próximamente"|x_translate}</p>
                    {/if}
                    <a href="{$url}panel-paciente/videoconsulta/" class="btn-default">{"volver"|x_translate}</a>
                </div>
            </div>
        </section>
    </body>
{else}
    <body class="mvc-body">

        <input type="hidden" id="room" value="{$room_name}">

        <input type="hidden" id="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
        <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}">
        <input type="hidden" id="idmedico" value="{$videoconsulta_sala.medico_idmedico}">
        {if $paciente.paciente_titular!=""}
            <input type="hidden" id="myUserName" value="{$paciente.paciente_titular.relacion|capitalize:true} {"del paciente"|x_translate}">
        {else}
            <input type="hidden" id="myUserName" value="{$paciente.nombre} {$paciente.apellido}">
        {/if}

        <input type="hidden" id="medico_username" value="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">
        <input type="hidden" id="paciente_username" value="{$paciente.nombre} {$paciente.apellido}">

        <section class="mvc-top">
            <div class="mvc-top">
                <div class="mvc-top-inner ">
                    <a href="{$url}panel-paciente/videoconsulta/sala-espera.html">
                        <div class="mvc-top-left volver-sala">

                            <figure> 
                                <i class="fa fa-chevron-left"></i>
                            </figure>

                            <label>{"Salir"|x_translate}</label>

                        </div>
                    </a>
                    <div class="dp-logo">
                        <a href="{$url}">
                            <img src="{$IMGS}doctorplus_logo_mobile.png" alt="DoctorPlus"/>
                        </a>
                    </div>
                    <ul class="mvc-top-right">

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
                    <div id="callerArea" class="relative mvc-video-box" style="display: flex;">
                        <div  id="callerVideo" style="display:block; width:100%; height: 100%" ></div>
                        <div  id="screensVideo" style="display:none; width:100%; height: 100%" ></div>
                        <button id='toggle-full-screen' class='toggle-full-screen' style="display:none;"><i class='fa fa-expand'></i></button>
                    </div>
                    <div class="mvc-video-thumb" style="z-index:601;">
                        <div  id="selfVideo"   class="easyrtcMirror" style="display:block; width:100%"></div>
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

                        <div id="recordatorio-recargar-pagina" class="alert-recargar-wrapper">
                            <div class="alert-recargar ">
                                <div class="">
                                    <i class="fa fa-info bounce"></i>
                                </div>
                                <label>
                                    {"No te olvides de recargar la página para solucionar problemas de conexión."|x_translate}
                                </label>
                                <a href="javascript:;" class="cerrar_alert_recargar" title='{"cerrar"|x_translate}'><i class="fa fa-times"></i></a>

                            </div>
                        </div>

                    </div>    
                    <i class="icon-doctorplus-chat-comment icon-chat-emergente box-chat bounce-6" data-msje="false"></i>
                    <div class="btn-minimizar-maximizar-chat" data-btn="right">
                        <a href="javascript:;" ><i class="fa fa-chevron-right btn-acordion" title="Minimiser" aria-hidden="true"></i></a>
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
                        <form name="send_mensaje_videoconsulta" action="{$url}send_mensaje_videoconsulta.do" id="send_mensaje_videoconsulta" method="POST" role="form" onsubmit="return false;">

                            <div class="okm-row">
                                <input type="hidden" id="idvideoconsulta" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
                                <div class="mvc-chat-input-box">
                                    <textarea data-autoresize rows="1" id="textoMensaje"  name="mensaje" maxlength="250" disabled="true" placeholder='{"No disponible hasta iniciar VideoConsulta"|x_translate}'></textarea>
                                </div>
                                <div class="mvc-chat-btns">
                                    <a href="javascript:;" id="desktop-upload-open"><i class="fui-clip"></i></a>
                                    <button id="btnSendMsg" onclick="enviarMensajeChat();" class="btn-transparent btn-send-msg" disabled="true"><i class="fa fa-paper-plane"></i></button>

                                </div>
                                </>
                            </div>

                            <div id="div-upload-widget" class="okm-row" style="display:none">

                                <div class="">
                                    <input type="hidden" id="idvideoconsulta_img" name="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
                                    <input type="hidden" name="cantidad" id="cantidad" value=""/>
                                    {literal}
                                        <script>


                                            //callbacks de la imagen
                                            var successImg = function (file, responseText) {
                                                $("#cantidad_adjunto").val(parseInt($("#cantidad_adjunto").val()) + 1);
                                                $("#cantidad").val($("#cantidad_adjunto").val());
                                                $("#div-upload-widget").spin(false);
                                                if (file.previewElement && responseText.status == 1) {
                                                    return file.previewElement.classList.add("dz-success");
                                                } else {
                                                    //x_alert(responseText.error);
                                                    errorImg(file, responseText.error);
                                                }

                                            };


                                            var stopImg = function (file) {
                                                $("#div-upload-widget").spin(false);

                                                if (file.previewElement) {
                                                    return file.previewElement.classList.add("dz-complete");
                                                }
                                                //$("#dropzone").spin(false);
                                            };
                                            var errorImg = function (file, message) {
                                                $("#div-upload-widget").spin(false);
                                                if (typeof message !== "String" && message.error) {
                                                    message = message.error;
                                                }
                                                if ((file.size / 1024 / 1024) > 8) {
                                                    message = x_translate("Error. Tamaño máximo de archivo 8 MB.");

                                                }
                                                x_alert(message);
                                                if (file.previewElement) {
                                                    file.previewElement.remove();
                                                }
                                                if ($(".dropzone .dz-preview").length == 0) {
                                                    $(".dropzone").removeClass("dz-started");
                                                }
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
                                                //agregar icono para pdf
                                                if (file.type == "application/pdf") {
                                                    file.previewElement.classList.add("dz-pdf");
                                                    $(".dropzone .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_pdf.png");
                                                }
                                                if (file.previewElement) {
                                                    file.previewElement.classList.add("dz-processing");
                                                    if (file._removeLink) {
                                                        return file._removeLink.textContent = this.options.dictCancelUpload;
                                                    }
                                                }



                                                $("#div-upload-widget").spin("large");
                                            };
                                        </script> 
                                    {/literal}
                                    <div  class="upload-controls-container ">
                                        <div class="chat-img-upld">
                                            <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone" >
                                                {x_component_upload_multiple  max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" folder="images_mensajes_vc" 
                                                                    callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf"}

                                                <div class="dz-message needsclick">
                                                    <i class="fui-clip"></i>
                                                    <h3>{"Archivos adjuntos"|x_translate}</h3>
                                                    <small>{"Ud. podrá subir archivos en formato:"|x_translate}&nbsp; JPG, PNG, PDF</small>
                                                    <div class="add-more-container">
                                                        <div class="add-more-btn"> 
                                                            <i class="fa fa-plus-circle"></i>
                                                            <span>{"Agregar más"|x_translate}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>
                                    </div>

                                </div>
                            </div>
                        </form>

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
                            <h4 class="modal-title">{"No se ha podido establecer la conexión con el servidor de Video Consulta. Intente nuevamente o contacte al administrador"|x_translate}</h4>
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

        <!-- Modal Consultorio Virtual Otra Sala -->
        <div id="modal-videoconsulta-otra-sala" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <figure class="modal-icon"><i class="icon-doctorplus-video-cam"></i></figure>
                        <h3 class="modal-sub-title">{"Consultorio Virtual abierto en otra ventana"|x_translate}</h4>
                            <h4 class="modal-title">{"Has click en usar aqui para realizar la Video Consulta en esta ventana"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <div class="modal-action-row">
                            <a href=""  class="btn-default" >{"Usar aquí"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Video Consultas tiempo vencido -->
        <div id="modal-videoconsulta-medico-demorado" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <figure class="modal-icon"><i class="fa fa-clock-o"></i></figure>
                        <h3 class="modal-sub-title">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}&nbsp;{"se encuentrá demorado"|x_translate}</h3>
                        <h4 class="modal-title">{"Ya hemos notificado al profesional. Aún puedes continuar esperando en su Consultorio Virtual. Quedan [[REMAINING]] minutos de espera"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <div class="modal-action-row">
                            <a href="javascript:;" data-dismiss="modal"  class="btn-default" >{"Seguir esperando"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Video Consultas tiempo vencido -->

        <div id="modal-videoconsulta-tiempo-espera-vencido" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <figure class="modal-icon"><i class="icon-doctorplus-alert-round"></i></figure>
                        <h4 class="modal-title">{"Tiempo de espera concluido"|x_translate}</h4>
                        <h3 class="modal-sub-title">{"El profesional no se presentó en horario. Han transcurrido [[{$VIDEOCONSULTA_VENCIMIENTO_SALA}]] minutos de espera. El importe de la misma ha sido devuelto a su cuenta"|x_translate}</h3>


                    </div>
                    <div class="modal-body">
                        <div class="modal-action-row">
                            <a href="{$url}panel-paciente/videoconsulta/" class="btn-default" >{"Salir"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="div_videoconsulta_script">
    </div>
    {include file="home/modal_display_file.tpl"}
    <script>
        var camera_firefox = "{$IMGS}video-consulta/camera-firefox.png";
        var camera_chrome = "{$IMGS}video-consulta/camera-chrome.png";
        var medico_username = $("#medico_username").val();
        var mensajes_videoconsulta = {$mensajes_videoconsulta};
        var inicio_llamada = "{$videoconsulta_sala.inicio_llamada}";
        var inicio_sala = "{$videoconsulta_sala.inicio_sala}";

        //config tokbox
        var apiKey = "{$videoconsulta_session.apiKey}";
        var sessionId = "{$videoconsulta_session.session}";
        var token = "{$videoconsulta_session.token_paciente}";
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
                        var html_mensaje = '<div class="file mvc-chat-line guest"><div class="mvc-chat-guest"><figure class="mvc-attach">' + content + '</figure><span></span></div></div>';
                        $("#conversacion").append($(html_mensaje));

                    } else {
                        var html_mensaje = '<div  class="okm-row  mvc-chat-line guest"><div class="mvc-chat-guest"><figure><span>' + medico_username + '</span><p></p></figure><span></span></div></div>';
                        $("#conversacion").append($(html_mensaje));
                        $("#conversacion p:last").text(content);
                    }
                    if ($(".btn-minimizar-maximizar-chat").data("btn") == "left") {
                        $(".icon-chat-emergente").css({"visibility": "visible"});
                    }
                    
                } else {
                    if (msgType == "imagen") {
                        var html_mensaje = '<div class="file mvc-chat-line host"><div class="mvc-chat-host"><figure class="mvc-attach">' + content + '</figure><span></span></div></div>';
                        $("#conversacion").append($(html_mensaje));

                    } else {
                        var html_mensaje = '<div class="okm-row mvc-chat-line host"><div class="mvc-chat-host"><figure><span></span><p></p></figure><span></span></div></div>';
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


            function getViewportWidth() {
                return $(window).width() + getScrollBarWidth();
            }

            function notificarMedicoDemorado() {
                console.log("médico demorado");
                //calculamos horario fin
                actual_time = new Date();
                var [date_part, time_part] = inicio_sala.split(" ");
                var date = date_part.split("-");
                var time = time_part.split(":");
                venciminto_videoconsulta = new Date(date[0], date[1] - 1, date[2], time[0], time[1], time[2]);
                venciminto_videoconsulta.setMinutes(venciminto_videoconsulta.getMinutes() + VIDEOCONSULTA_VENCIMIENTO_SALA);
                miliseg_restantes = venciminto_videoconsulta.getTime() - actual_time;
                console.log("miliseg_restantes", miliseg_restantes);
                min_restantes = parseInt(miliseg_restantes / 1000 / 60);
                console.log("min_restantes", min_restantes);


                //seteamos el tiempo en el modal
                $("#modal-videoconsulta-medico-demorado .modal-title").text($("#modal-videoconsulta-medico-demorado .modal-title").text().replace("REMAINING", min_restantes));
                $("#modal-videoconsulta-medico-demorado .modal-title").text($("#modal-videoconsulta-medico-demorado .modal-title").text().replace(/[0-9]+/, min_restantes));
                $("#modal-videoconsulta-medico-demorado").modal("show");
                //emitimos la notificacion
                console.log('notificar_ingreso_consultorio');
                socket.emit('notificar_ingreso_consultorio', {tipo_usuario: 'paciente', idpaciente: $("#idpaciente").val(), paciente: $("#paciente_username").val(), idmedico: $("#idmedico").val(), idvideoconsulta: $("#idvideoconsulta").val(), evento: 'ingreso'});
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


                //recordatorio recargar pagina
                if (localStorage.getItem('hide-recordatorio-recargar-pagina') != "1") {
                    $("#recordatorio-recargar-pagina").fadeIn();
                }
                $(".cerrar_alert_recargar").click(function () {
                    $("#recordatorio-recargar-pagina").slideUp();
                    localStorage.setItem('hide-recordatorio-recargar-pagina', "1");
                });

                $(':radio, :checkbox').radiocheck();
                $('.switch-checkbox').bootstrapSwitch();

                //quitamos el icono remover tags imput
                $(".mvc-tags-inner span[data-role='remove']").remove();

                //desplegable drozpone imagenes
                $('#desktop-upload-open').on('click', function (e) {
                    e.preventDefault();
                    var chatHeight = parseInt($(".mvc-chat-box").css("height"));
                    if (display_images_form) {
                        if ($('#div-upload-widget').is(':visible')) {
                            $('#div-upload-widget').slideUp();

                            $(".mvc-chat-box").css("height", chatHeight + 300);
                        } else {
                            $('#div-upload-widget').slideDown();
                            $(".mvc-chat-box").css("height", chatHeight - 300);

                        }
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
                    sessionStorage.setItem('notificar_conclusion_vc_pendiente', '1');
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                });
                //al transucrrir la videoconsulta cuando cerramos el modal salimos de la sala
                $("#modal-videoconsulta-tiempo-espera-vencido").on('hidden.bs.modal', function () {
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                });


                //agregamos los mensajes al chat
                mensajes_videoconsulta.forEach(function (elem, indice) {
                    console.log(elem)
                    if (elem.emisor == "p") {
                        var emisor = "Yo";
                    } else {
                        var emisor = "Medico";
                    }

                    if (elem.is_imagen == 1) {
                        var tipo = "imagen";
                        var contenido = "<a href='" + elem.imagen.url + "' data-filename='" + elem.imagen.nombre + "' data-ext='" + elem.imagen.ext + "'  class='display-file'><img src=' " + elem.imagen.path_images + "' alt='" + elem.imagen.nombre + "." + elem.imagen.ext + "'  title='" + elem.imagen.nombre + "." + elem.imagen.ext + "' style='width:100px; height:100px'><div class='mvc-attach-btn'><i class='icon-doctorplus-search'></i></div></a>";

                    } else {
                        var tipo = "Texto";
                        var contenido = elem.mensaje;
                    }

                    addToConversation(emisor, tipo, contenido);
                });


                //mostrar modal para ver archivos
                $("#conversacion").on("click", "a.display-file", function (e) {
                    e.preventDefault();
                    var ext = $(this).data("ext");
                    var type = "";
                    switch (ext) {
                        case "pdf":
                            type = "application/pdf";
                            break;
                        case "jpeg":
                            type = " image/jpeg";
                            break;
                        case "jpg":
                            type = "image/jpeg";
                            break;
                        case "png":
                            type = "image/png";
                            break;
                        case "gif":
                            type = "image/gif";
                            ;
                            break;
                        case "bmp":
                            type = "image/bmp";
                            ;
                            break;
                        case "webp":
                            type = "image/webp";
                            ;
                            break;
                    }

                    var src = $(this).attr("href") + "?" + new Date().getTime();
                    //quitamos el archivo anterios
                    $("#modal-display-file .modal-body").empty();
                    $("#modal-display-file .modal-body").append("<object><embed></embed></object>");
                    $("#modal-display-file .modal-body object embed").addClass("img-responsive");
                    $("#modal-display-file .modal-body object embed").addClass("embed");

                    //agregamos path del nuevo archivo
                    $("#modal-display-file object").attr("data", src);
                    $("#modal-display-file embed").attr("src", src);
                    $("#modal-display-file .download").attr("href", src);

                    $("#modal-display-file object").attr("type", type);
                    $("#modal-display-file embed").attr("type", type);
                    $("#modal-display-file").modal("show");
                });


                /*Notificamos médico demorado*/
                //si luego de 5 minutos no se ha iniciado la videoconsulta mostramos el modal de tiempo vencido
                var delay = 1000 * VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO * 60;
                var firstCheck = true;
                function checkMedicoDemorado()
                {
                    if (!iniciada && !firstCheck) {
                        notificarMedicoDemorado();
                    }
                    firstCheck = false;
                    setTimeout(checkMedicoDemorado, delay);
                }

                checkMedicoDemorado();

            });
        </script>		
    {/literal}



</body>

{/if}