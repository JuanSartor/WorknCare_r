{*
<script src="{$url_js_libs}/audio/MediaStreamRecorder.min.js?v={$smarty.now|date_format:"%j"}"></script>
<script src="{$url_js_libs}/audio/RecordRTC.min.js?v={$smarty.now|date_format:"%j"}"></script>
<script src="{$url_js_libs}/adapter/adapter-latest.min.js?v={$smarty.now|date_format:"%j"}"></script>
*}
<div id="div_consultasexpress_pendientes" class="relative">


    {include file="consultaexpress/consultaexpress_settings.tpl"}


    <input type="hidden" id="notificacion_consultaexpress" value="{$notificacion_general}">
    {if $consulta_pendiente}
        <div class="cs-nc-section-holder">	
            <section class="container cs-nc-p2">
                <div class="container">
                    <ol class="breadcrum">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                        <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                        <li><a href="{$url}panel-medico/consultaexpress/pendientes.html">{"Recibidas"|x_translate}</a></li>
                        {if $consulta_pendiente}<li class="active">Nº {$consulta_pendiente.numeroConsultaExpress}</li>{/if}

                    </ol>
                </div>
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>
                                {if $cantidad_consulta.pendientes>0}
                                <span>{$cantidad_consulta.pendientes}</span>
                            {/if}
                        </div>
                        <span>{"RECIBIDAS"|x_translate}</span>
                    </div>
                </div>


                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">


                        <div class="panel {if $consulta_pendiente.tomada=="1" &&  $consulta_pendiente.tipo_consulta=="0"} ceprr-accordion {/if} panel-default">
                            <div class="panel-heading" role="tab">
                                <div class="ce-ca-toolbar">                         
                                    <div class="row">
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                <a href="javascript:;"  class="change_miembro" data-id="{$consulta_pendiente.paciente.idpaciente}">
                                                    <div class="cs-ca-usr-avatar">
                                                        {if $consulta_pendiente.paciente.image}
                                                            <img src="{$consulta_pendiente.paciente.image.list}" alt="user"/>
                                                        {else}
                                                            {if $consulta_pendiente.paciente.animal!=1}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                            {/if}
                                                        {/if}

                                                        <figure>
                                                            <i class="icon-doctorplus-pharmaceutics"></i>
                                                        </figure>
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        <span>{"Recibidas"|x_translate}</span>
                                                        <h2>{$consulta_pendiente.paciente.nombre} {$consulta_pendiente.paciente.apellido}</h2>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                {if $consulta_pendiente.paciente_titular}

                                                    <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                        {if $consulta_pendiente.paciente_titular.image}
                                                            <img src="{$consulta_pendiente.paciente_titular.image.perfil}" />
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" />
                                                        {/if}
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        {if $consulta_pendiente.paciente_titular.relacion != ""}
                                                            <span>{$consulta_pendiente.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                        {else}
                                                            <span>{"propietario"|x_translate}</span>
                                                        {/if}
                                                        <h2>{$consulta_pendiente.paciente_titular.nombre} {$consulta_pendiente.paciente_titular.apellido}</h2>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                <span id="cs-ca-tiempo-respuesta-label-{$consulta_pendiente.idconsultaExpress}" class="cs-ca-tiempo-respuesta-label">{"Tiempo de respuesta"|x_translate}</span>
                                                <div class="cs-ca-tiempo-respuesta">
                                                    {if $consulta_pendiente.segundos_diferencia > 0}
                                                        <span class="cs-ca-clock-icon">
                                                            <i class="icon-doctorplus-clock"></i>
                                                        </span>
                                                        <span data-id="{$consulta_pendiente.idconsultaExpress}" data-startsec="{$consulta_pendiente.segundos_diferencia}" {if $consulta_pendiente.tipo_consulta=="0"} data-fecha-vencimiento="{$consulta_pendiente.fecha_vencimiento_toma}" {else} data-fecha-vencimiento="{$consulta_pendiente.fecha_vencimiento}"{/if} class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                    {/if}
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_pendiente.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_pendiente.idconsultaExpress}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$consulta_pendiente.numeroConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$consulta_pendiente.motivoConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta_pendiente.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta_pendiente.idconsultaExpress}" data-id="{$consulta_pendiente.idconsultaExpress}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-{$consulta_pendiente.idconsultaExpress}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">


                                        {foreach from=$consulta_pendiente.mensajes item=mensaje}
                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        <div class="chat-image-avatar-xn">
                                                            {if $consulta_pendiente.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $consulta_pendiente.paciente_titular.image.perfil != ""}
                                                                        <img src="{$consulta_pendiente.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $consulta_pendiente.paciente.image.perfil != ""}
                                                                    <img src="{$consulta_pendiente.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    {if $consulta_pendiente.paciente.animal != 1}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                                    {/if}
                                                                {/if}
                                                                <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                            </div>
                                                        </div>

                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date">
                                                                    {$mensaje.fecha_format} hs
                                                                </div>
                                                                <p>{$mensaje.mensaje} </p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                <div class="chat-content-attach">
                                                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
                                                                        <i class="fui-clip"></i>
                                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                    </a>
                                                                </div>
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}

                                        {/foreach}






                                        <div class="row chat-row" id="div_row_time_{$consulta_pendiente.idconsultaExpress}" {if $consulta_pendiente.segundos_diferencia > 0} style="display: none" {/if}>
                                            <div class="chat-line-holder chat-line-answer">
                                                <div class="chat-content">
                                                    <figure>
                                                        <br>
                                                        <p class="chat-content-rechazada">
                                                            <i class="fa fa-clock-o"></i>
                                                            {"Se excedió el tiempo para responder la consulta."|x_translate}
                                                        </p>
                                                        <span class="chat-content-arrow"></span>
                                                    </figure>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    {if $consulta_pendiente.segundos_diferencia > 0}

                                        <div  id="row_actions_panels_{$consulta_pendiente.idconsultaExpress}" class="row">
                                            <div class="audio-actions-panel">

                                                <div class="audio-reccord-holder-chat">
                                                    <form name="send_mensaje_{$consulta_pendiente.idconsultaExpress}" id="send_mensaje_{$consulta_pendiente.idconsultaExpress}" action="{$url}send_mensaje_consulta_express_m.do" method="POST" role="form" onsubmit="return false">
                                                        <input type="hidden" name="consultaExpress_idconsultaExpress" value="{$consulta_pendiente.idconsultaExpress}"/>
                                                        <input type="hidden" name="cantidad" id="cantidad" value=""/>
                                                        <input type="hidden" name="audio_msg" id="audio_msg" value=""/>
                                                        <div id="container_chat_mic_rec_{$consulta_pendiente.idconsultaExpress}" class="audio-reccord-holder chat_mic_rec_{$consulta_pendiente.idconsultaExpress}">
                                                            <div class="chat-msg-wrapper">
                                                                <div class="chat-msg-holder">
                                                                    <div class="chat-msg-input-holder">
                                                                        <textarea data-autoresize rows="1" name="mensaje" placeholder='{"Escribir mensaje"|x_translate}'></textarea>
                                                                    </div>
                                                                </div>
                                                                <div class="chat-msg-holder-btn-holder">

                                                                    <div class="mic-icon-holder">
                                                                        <a id="chat_mic_rec_{$consulta_pendiente.idconsultaExpress}" data-id="{$consulta_pendiente.idconsultaExpress}" class="chat-mic-rec grabar-audio" href="javascript:;" title='{"Agregar audio"|x_translate}'><i class="icon-doctorplus-microphone"></i></a>
                                                                        <a id="delete_chat_mic_rec_{$consulta_pendiente.idconsultaExpress}" data-id="{$consulta_pendiente.idconsultaExpress}" class="chat-mic-rec delete-audio" href="javascript:;" title='{"Eliminar audio"|x_translate}'><i class="icon-doctorplus-cruz"></i></i></a>
                                                                        <a id="stop_chat_mic_rec_{$consulta_pendiente.idconsultaExpress}" style="display:none;" data-id="{$consulta_pendiente.idconsultaExpress}" class="chat-mic-rec stop-grabacion grabando" href="javascript:;" title='{"Detener grabacion"|x_translate}'><i class="icon-doctorplus-stop"></i></i></a>

                                                                        <p class="chat-mic-rec-label text-center grabar-audio-lbl">{"Agregar audio"|x_translate}</p>
                                                                        <p class="chat-mic-rec-label text-center detener-grabacion-lbl">{"Detener grabacion"|x_translate}</p>
                                                                        <p class="chat-mic-rec-label text-center delete-audio">{"Eliminar audio"|x_translate}</p>
                                                                    </div>
                                                                    <div class="mic-icon-holder">
                                                                        <button class="file-trigger" data-id="{$consulta_pendiente.idconsultaExpress}" type="submit" title='{"Archivos adjuntos"|x_translate}'><i class="fui-clip"></i></button>
                                                                        <p class="chat-mic-rec-label">{"Agregar archivos"|x_translate}</p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <p id="label_audio_component_{$consulta_pendiente.idconsultaExpress}" class="text-center label_audio_component" >
                                                                <em>{"Procesando"|x_translate}</em><span class="recording-label"></span>
                                                            </p>

                                                            {x_component_upload_audio 
                                                           button_id="chat_mic_rec_"|cat:$consulta_pendiente.idconsultaExpress
                                                           content_audio_id="add_audio_"|cat:$consulta_pendiente.idconsultaExpress
                                                           class_stop="grabando"
                                                           class_play=""
                                                           html_into_button_play="<i class='icon-doctorplus-microphone'></i>"
                                                           html_into_button_stop="<i class='icon-doctorplus-stop'></i>"}

                                                        </div>
                                                        <div class="audio-reccord-holder audio-file-holder chat_mic_rec_{$consulta_pendiente.idconsultaExpress}" id="add_audio_{$consulta_pendiente.idconsultaExpress}"></div>

                                                        <div class="audio-reccord-holder">
                                                            <div class="chat-img-upld">
                                                                <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
                                                                    {x_component_upload_multiple  max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" folder="images_mensajes_ce" 
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
                                                                <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>
                                                            </div>


                                                        </div>
                                                        <div class="audio-action-holder btn-send-mensaje-holder">
                                                            <a href="javascript:;" class="ce-ca-cancelar"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</a>
                                                            <a href="javascript:;" data-id="{$consulta_pendiente.idconsultaExpress}"  class="ce-ca-responder btn_send_mensaje" ><i class="icon-doctorplus-right-arrow"></i>{"Responder"|x_translate}</a>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="chat-motivo-rechazo-holder">
                                                    <form name="rechazar_mensaje_{$consulta_pendiente.idconsultaExpress}" id="rechazar_mensaje_{$consulta_pendiente.idconsultaExpress}" action="{$url}rechazar_consulta_express_m.do" method="POST" role="form" onsubmit="return false">
                                                        <input type="hidden" name="consultaExpress_idconsultaExpress" value="{$consulta_pendiente.idconsultaExpress}"/>
                                                        <div class="chat-msg-holder">
                                                            <select class="form-control select select-primary select-block mbl" name="motivoRechazo_idmotivoRechazo" id="motivoRechazo_idmotivoRechazo_{$consulta_pendiente.idconsultaExpress}">
                                                                <option value="">{"Indicar motivo"|x_translate}</option>
                                                                {html_options options=$combo_motivo_rechazo}
                                                            </select>
                                                            <div class="chat-msg-input-holder mensaje-paciente">
                                                                <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}' data-id="{$consulta_pendiente.idconsultaExpress}"></textarea>
                                                            </div>
                                                            <div class="text-center  btn-send-mensaje-holder">
                                                                <button  class="btn_send_motivo btn btn-primary" data-id="{$consulta_pendiente.idconsultaExpress}" style="border:solid 1px; border-radius:5px">{"Enviar"|x_translate}<i class="icon-doctorplus-right-arrow"></i></button>
                                                            </div>

                                                        </div>
                                                    </form>
                                                    <hr>
                                                </div>
                                                <div class="audio-action-holder btn-slide-holder">
                                                    {if $consulta_pendiente.tipo_consulta!="0"} 
                                                        <a href="javascript:;" data-send="0" data-id="{$consulta_pendiente.idconsultaExpress}" class="ce-ca-mdl-rechazo-consulta" style="background: #ff6f6f;">
                                                            <i class="fas fa-user-times"></i>
                                                            {"Declinar consulta"|x_translate}
                                                        </a>
                                                    {/if}
                                                    <a href="javascript:;" data-send="0" data-id="{$consulta_pendiente.idconsultaExpress}" class="ce-ca-enviar-consulta enviar_respuesta"><i class="icon-doctorplus-chat-add"></i>{"Aceptar y enviar respuesta"|x_translate}</a>

                                                </div>
                                            </div>
                                        </div>



                                    {/if}


                                </div>
                            </div>


                        </div>

                    </div>



            </section>
        </div>


        {literal}
            <script>
                $(document).ready(function (e) {
                    //redireccion al perfil salud del paciente
                    $("#div_consultasexpress_pendientes .change_miembro").click(function () {

                        window.sessionStorage.setItem("mostrar_inputs", "1");

                        var id = $(this).data("id");
                        if (parseInt(id) > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'panel-medico/change_member.do',
                                    "id=" + id,
                                    function (data) {
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/";
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                    });


                    /*  $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/
                    //scroll hasta el ultimo mensaje del chat
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        scrollToLastMsg($(".cs-ca-chat-holder"));
                    });

                    /*Metodo que envia el formulario con el mensaje de la consulta*/
                    function sendForm(id) {
                        x_sendForm(
                                $('#send_mensaje_' + id),
                                true,
                                function (data) {
                                    $('body').spin(false);
                                    if (data.result) {
                                        $(".audio-reccord-holder-chat").slideUp();
                                        scrollToEl($("body"));
                                        x_alert(x_translate("Mensaje enviado. Puede ahora finalizar la consulta o seguir el intercambio de mensajes"), function () {
                                            recargar(BASE_PATH + "panel-medico/consultaexpress/abiertas-" + id + ".html");
                                        });
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                    /*Metodo que sube al servidor el archivo de audio grabado, y luego envia en mensaje de la consulta*/
                    function uploadLocalRecording(id) {
                        $("body").spin("large");
                        $("chat_mic_rec_" + id).addClass("uploading-audio");
                        var hash = $('#send_mensaje_' + id).find("input[name='hash_audio']").val();
                        var data = new FormData();
                        data.append('file_' + hash, audioMessageFile);
                        data.append('hash', hash);
                        $.ajax({
                            url: BASE_PATH + "send_audio_file.do",
                            data: data,
                            processData: false,
                            contentType: false,
                            type: 'POST',
                            success: function (data) {
                                console.log(data);
                                if (data.result == true) {
                                    console.log("Fichier chargé avec succès");
                                    $("#audio_msg").val(1);
                                    sendForm(id);
                                } else {
                                    $("body").spin(false);
                                    x_alert("Erreur lors du téléchargement du fichier");
                                }
                            }
                        });
                    }

                    //evento de enviar mensaje
                    $(".btn_send_mensaje").click(function () {
                        if ($(this).hasClass("disabled"))
                            return null;

                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                            $("#send_mensaje_" + id + " textarea").parent().parent().css("border", "none");
                            if ($("textarea[name='mensaje']").val() == "" && $('#send_mensaje_' + id + ' audio').length == 0) {
                                x_alert(x_translate("Ingrese el texto o audio del mensaje"));
                                $("#send_mensaje_" + id + " textarea").parent().parent().css("border", "1px solid red");
                                return false;
                            }
                            //carga de imagenes en proces
                            if ($("#dropzone" + " .dz-complete").length != $("#dropzone" + " .dz-preview").length) {
                                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                                return false;

                            }

                            //borramos input audio si no se graba audio
                            if ($('#send_mensaje_' + id + ' audio').length == 0) {
                                $('#send_mensaje_' + id).find("input[name='hash_audio']").remove();
                            }
                            $('body').spin("large");
                            //verificamos si hay archivo de audio adjunto
                            if (typeof audioMessageFile.name == "string") {
                                uploadLocalRecording(id);
                            } else {
                                //sin audio adjunto
                                sendForm(id);
                            }
                        }
                    });

                    //boton rechazar consulta - seleccionar motivo
                    $(".btn_send_motivo").click(function () {
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                            if ($("#motivoRechazo_idmotivoRechazo_" + id).val() != "") {
                                $(".chat-motivo-rechazo-holder form .chat-msg-holder .select2-choice").css("border-color", "#a9a6a6");
                                $('#div_consultasexpress_pendientes').spin("large");
                                x_sendForm(
                                        $('#rechazar_mensaje_' + id),
                                        true,
                                        function (data) {
                                            $('#div_consultasexpress_pendientes').spin(false);
                                            if (data.result) {
                                                x_alert(data.msg, function () {
                                                    recargar(BASE_PATH + "panel-medico/consultaexpress/declinadas.html");
                                                });
                                            } else {
                                                x_alert(data.msg);
                                            }


                                        }
                                );
                            } else {
                                $(".chat-motivo-rechazo-holder form .chat-msg-holder .select2-choice").css("border-color", "red");
                                x_alert(x_translate("Seleccione el motivo de rechazo de la consulta"));
                                return false;

                            }
                        }
                    });




                    //seteamos como leidas las consultas visualizadas
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        $this = $(this);
                        var id = parseInt($this.data("id"));

                        //Enviar a leer todos los mensajes
                        if (id > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_leido_mensaje_consulta_all_m.do',
                                    "id=" + id,
                                    function (data) {

                                    });
                        }

                    });

                    //boton aceptar para enviar respuesta
                    $('.ce-ca-enviar-consulta').on('click', function (e) {
                        //e.preventDefault();

                        $(this).parent('.btn-slide-holder').hide();

                        $('.chat-motivo-rechazo-holder').removeClass('show');
                        if ($('.audio-reccord-holder-chat').is(':hidden')) {
                            $('.audio-reccord-holder-chat').slideDown();
                        }
                    });

                    //boton rechazar consulta - desplega combo box motivo
                    $('.ce-ca-mdl-rechazo-consulta').on('click', function (e) {
                        //si es una consulta de la red tomada, la devolvemos a la rer
                        var tomada = $(this).data("tomada");
                        if (tomada == "1") {
                            var id = parseInt($(this).data("id"));
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "rechazar_toma_consultaexpress.do",
                                    'id=' + id,
                                    function (data) {
                                        x_alert(data.msg);

                                    }

                            );
                        }//sino desplegamos el combo motivo
                        else {
                            e.preventDefault();
                            var $this = $(this);
                            $this.parent().siblings('.audio-reccord-holder').hide();
                            //                $this.parent().siblings('.audio-reccord-holder').removeClass('show');
                            $this.parent().siblings('.chat-motivo-rechazo-holder').toggleClass('show');
                        }
                    });
                    //boton cancelar envio mensaje texto
                    $('.ce-ca-cancelar').on('click', function (e) {
                        e.preventDefault();
                        $('.audio-reccord-holder-chat').siblings('.btn-slide-holder').fadeIn();

                        $("textarea[name='mensaje']").val("");
                        $('.audio-reccord-holder-chat').slideUp();
                    });

                    /*Eliminar audio grabado*/
                    $('.delete-audio').on('click', function (e) {
                        var id = $(this).data("id");
                        audioMessageFile = "";
                        $("#add_audio_" + id + " audio").remove();
                        $("#container_chat_mic_rec_" + id).removeClass("audio-success");
                        $("#add_audio_" + id).hide();
                        $("#delete_chat_mic_rec_" + id).hide();
                        $("#chat_mic_rec_" + id).show();


                    });

                    $.each($('textarea[data-autoresize]'), function () {
                        var offset = this.offsetHeight - this.clientHeight;

                        var resizeTextarea = function (el) {
                            $(el).css('height', 'auto').css('height', el.scrollHeight + offset);
                        };
                        $(this).on('keyup input', function () {
                            resizeTextarea(this);
                        }).removeAttr('data-autoresize');
                    });

                    $('.file-trigger').on('click', function (e) {
                        e.preventDefault();

                        if ($('.chat-img-upld').is(":hidden")) {
                            $('.chat-img-upld').slideDown();
                            scrollToEl($('.audio-reccord-holder-chat'));
                        } else {
                            $('.chat-img-upld').slideUp();
                        }
                    });

                    // timer tiempo restante
                    $.each($('.timer-1'), function (idx, elem) {

                        if ($(elem).data("fecha-vencimiento") !== "") {
                            var id = $(this).data("id");

                            var [date_part, time_part] = $(elem).data("fecha-vencimiento").split(" ");
                            var date = date_part.split("-");
                            var time = time_part.split(":");
                            var countDownDate = new Date(date[0], date[1] - 1, date[2], time[0], time[1], time[2]).getTime();

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

                                if (hours < 10) {
                                    hours = "0" + hours;
                                }
                                if (minutes < 10) {
                                    minutes = "0" + minutes;
                                }
                                if (seconds < 10) {
                                    seconds = "0" + seconds;
                                }

                                // Actualizamos el tiempo restante en la consulta
                                $(elem).text(hours + "h " + minutes + "mn " + seconds + "s");

                                // cuando finaliza el tiempo ocultamos el timer
                                if (distance < 0) {
                                    clearInterval(x);
                                    $(elem).text(x_translate("Tiempo cumplido"), );
                                    $("#row_actions_panels_" + id).html("");
                                    $("#div_row_time_" + id).show();
                                }
                            }, 1000);
                        }

                    });

                });
            </script>
        {/literal}
    {else}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>

                        </div>
                        <span>{"RECIBIDAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="fas fa-user-clock"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p> <strong>{"Ud. no tiene Consultas Recibidas"|x_translate}</strong>.</p>
                </div>
            </section>
        </div>

    {/if}

</div>
