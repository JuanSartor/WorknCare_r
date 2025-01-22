{*<script src="{$url_js_libs}/audio/MediaStreamRecorder.js?v={$smarty.now|date_format:"%j"}"></script>
<script src="{$url_js_libs}/audio/RecordRTC.js?v={$smarty.now|date_format:"%j"}"></script>
<script type="text/javascript" src="{$url_js_libs}/audio/mp3recorder.js"></script>
<script src="{$url_js_libs}/adapter/adapter-latest.min.js?v={$smarty.now|date_format:"%j"}"></script>
*}


<div id="div_consultasexpress_abiertas" class="relative cs-nc-section-holder">
    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/consultaexpress/abiertas.html">{"Abiertas"|x_translate}</a></li>
            {if $consulta_abierta}<li class="active">Nº {$consulta_abierta.numeroConsultaExpress}</li>{/if}

        </ol>
    </div>
    {if $consulta_abierta}
        <input type="hidden" id="idconsultaExpress" value="{$consulta_abierta.idconsultaExpress}"/>
        <section class="container cs-nc-p2">
            <div class="">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/abiertas.html" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>
                            {if $cantidad_consulta.abiertas>0} <span id='cant_consulta_abiertas'>{$cantidad_consulta.abiertas}</span>{/if}
                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>

                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">



                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar">
                                    <div class="row">
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                <a href="javascript:;"  class="change_miembro" data-id="{$consulta_abierta.paciente.idpaciente}">
                                                    <div class="cs-ca-usr-avatar">
                                                        {if $consulta_abierta.paciente.image}
                                                            <img src="{$consulta_abierta.paciente.image.list}" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}"/>
                                                        {else}
                                                            {if $consulta_abierta.paciente.animal!=1}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}"/>
                                                            {/if}
                                                        {/if}

                                                        <figure>
                                                            <i class="icon-doctorplus-pharmaceutics"></i>
                                                        </figure>
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        <span>{"Paciente"|x_translate}</span>
                                                        <h2>{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}</h2>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                {if $consulta_abierta.paciente_titular}

                                                    <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                        {if $consulta_abierta.paciente_titular.image}
                                                            <img src="{$consulta_abierta.paciente_titular.image.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        {if $consulta_abierta.paciente_titular.relacion != ""}
                                                            <span>{$consulta_abierta.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                        {else}
                                                            <span>{"propietario"|x_translate}</span>
                                                        {/if}
                                                        <h2>{$consulta_abierta.paciente_titular.nombre} {$consulta_abierta.paciente_titular.apellido}</h2>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-consultas-abiertas-holder">
                                                <div id="cont_mensajes_noleidos_{$consulta_abierta.idconsultaExpress}" class="cs-ca-consultas-abiertas-spacer">	
                                                    {if $consulta_abierta.mensajes_noleidos>0}
                                                        <span>{"Mensajes sin leer"|x_translate}</span>
                                                        <figure>{$consulta_abierta.mensajes_noleidos}</figure>
                                                        {/if}
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_abierta.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_abierta.idconsultaExpress}">

                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$consulta_abierta.numeroConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$consulta_abierta.motivoConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta_abierta.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta_abierta.idconsultaExpress}" class="panel-collapse collapse in" role="tabpanel" data-id="{$consulta_abierta.idconsultaExpress}" aria-labelledby="heading-{$consulta_abierta.idconsultaExpress}">
                                <div class="panel-body">
                                    <!-- INICIO MENSAJES-->
                                    <div class="cs-ca-chat-holder">

                                        {foreach from=$consulta_abierta.mensajes item=mensaje}
                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        <div class="chat-image-avatar-xn">
                                                            {if $consulta_abierta.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $consulta_abierta.paciente_titular.image.perfil != ""}
                                                                        <img src="{$consulta_abierta.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $consulta_abierta.paciente.image.perfil != ""}
                                                                    <img src="{$consulta_abierta.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    {if $consulta_abierta.paciente.animal != 1}
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
                                            {else}

                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-image-avatar-xn pcer-chat-image-right">



                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $consulta_abierta.medico.imagen.perfil != ""}
                                                                    <img src="{$consulta_abierta.medico.imagen.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}

                                                            </div>
                                                        </div>
                                                        <div class="chat-content  pcer-chat-right">
                                                            <figure>
                                                                <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                <p>{$mensaje.mensaje} </p>
                                                                {if $mensaje.mensaje_audio != ""}
                                                                    <div class="chat-audio-holder">
                                                                        <audio controls preload="true" src="{$mensaje.mensaje_audio}"></audio>
                                                                    </div>
                                                                {/if}
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
                                    </div>

                                    <!-- FIN MENSAJES-->

                                    <div class="row">
                                        <div class="audio-actions-panel">

                                            <div class="audio-reccord-holder-chat">
                                                <form name="send_mensaje_{$consulta_abierta.idconsultaExpress}" id="send_mensaje_{$consulta_abierta.idconsultaExpress}" action="{$url}send_mensaje_consulta_express_m.do" method="POST" role="form" onsubmit="return false">
                                                    <input type="hidden" name="consultaExpress_idconsultaExpress" value="{$consulta_abierta.idconsultaExpress}"/>
                                                    <input type="hidden" name="cantidad" id="cantidad" value=""/>
                                                    <input type="hidden" name="audio_msg" id="audio_msg" value=""/>

                                                    <div id="container_chat_mic_rec_{$consulta_abierta.idconsultaExpress}" class="audio-reccord-holder chat_mic_rec_{$consulta_abierta.idconsultaExpress}">
                                                        <div class="chat-msg-wrapper">
                                                            <div class="chat-msg-holder">
                                                                <div class="chat-msg-input-holder">
                                                                    <textarea data-autoresize rows="1" name="mensaje" placeholder='{"Escribir mensaje"|x_translate}'></textarea>
                                                                </div>
                                                            </div>

                                                            <div class="chat-msg-holder-btn-holder">

                                                                <div class="mic-icon-holder">
                                                                    <a id="chat_mic_rec_{$consulta_abierta.idconsultaExpress}" data-id="{$consulta_abierta.idconsultaExpress}" class="chat-mic-rec grabar-audio" href="javascript:;"  title='{"Agregar audio"|x_translate}'><i class="icon-doctorplus-microphone"></i></a>
                                                                    <a id="delete_chat_mic_rec_{$consulta_abierta.idconsultaExpress}" data-id="{$consulta_abierta.idconsultaExpress}" class="chat-mic-rec delete-audio" href="javascript:;" title='{"Eliminar audio"|x_translate}'><i class="icon-doctorplus-cruz"></i></i></a>
                                                                    <a id="stop_chat_mic_rec_{$consulta_abierta.idconsultaExpress}" style="display:none;" data-id="{$consulta_abierta.idconsultaExpress}" class="chat-mic-rec stop-grabacion grabando" href="javascript:;"  title='{"Detener grabacion"|x_translate}' ><i class="icon-doctorplus-stop"></i></i></a>

                                                                    <p class="chat-mic-rec-label text-center grabar-audio-lbl">{"Agregar audio"|x_translate}</p>
                                                                    <p class="chat-mic-rec-label text-center detener-grabacion-lbl">{"Detener grabacion"|x_translate}</p>
                                                                    <p class="chat-mic-rec-label text-center delete-audio">{"Eliminar audio"|x_translate}</p>
                                                                </div>
                                                                <div class="mic-icon-holder">
                                                                    <button class="file-trigger" data-id="{$consulta.idconsultaExpress}" type="submit" title='{"Archivos adjuntos"|x_translate}'><i class="fui-clip"></i></button>
                                                                    <p class="chat-mic-rec-label">{"Agregar archivos"|x_translate}</p>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <p id="label_audio_component_{$consulta_abierta.idconsultaExpress}" class="text-center label_audio_component" >
                                                            <em>{"Procesando"|x_translate}</em><span class="recording-label"></span>
                                                        </p>


                                                        {x_component_upload_audio 
                                                        button_id="chat_mic_rec_"|cat:$consulta_abierta.idconsultaExpress
                                                        content_audio_id="add_audio_"|cat:$consulta_abierta.idconsultaExpress
                                                        class_stop="grabando"
                                                        class_play=""
                                                        html_into_button_play="<i class='icon-doctorplus-microphone'></i>"
                                                        html_into_button_stop="<i class='icon-doctorplus-stop'></i>"}

                                                    </div>

                                                    <div class="audio-reccord-holder audio-file-holder chat_mic_rec_{$consulta_abierta.idconsultaExpress}" id="add_audio_{$consulta_abierta.idconsultaExpress}"></div>

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
                                                        <a href="javascript:;" data-id="{$consulta_abierta.idconsultaExpress}"  class="ce-ca-responder btn_send_mensaje" ><i class="icon-doctorplus-right-arrow"></i>{"Responder"|x_translate}</a>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="audio-action-holder btn-slide-holder">
                                                <a href="javascript:;" data-idpaciente="{$consulta_abierta.paciente_idpaciente}" data-id="{$consulta_abierta.idconsultaExpress}" data-nombre="{$consulta_abierta.paciente.nombre|str2seo}" data-apellido="{$consulta_abierta.paciente.apellido|str2seo}" class="ce-ca-mdl-fin-consulta"><i class="icon-doctorplus-ficha-check"></i>{"Finalizar consulta"|x_translate}</a>
                                                <a href="javascript:;" class="ce-ca-enviar-consulta"><i class="icon-doctorplus-chat-add"></i>{"Enviar respuesta"|x_translate}</a>
                                            </div>
                                        </div>
                                    </div>


                                </div>

                            </div>
                        </div>



                    </div>

                </div>
            </div>
            <!-- Modal desbloquear -->
            <div id="final-consulta-mdl" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
                <div class="modal-dialog modal-sm modal-action-bool-sm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
                        <p>{"¿Desea finalizar la Consulta Express?"|x_translate}</p>
                        <div class="modal-action-holder">
                            <a href="#" data-dismiss="modal" class="modal-action-close">{"cancelar"|x_translate}</a>
                            <a href="javascript:;" data-id="" data-idpaciente="" data-nombre="" data-apellido="" id="a_confirmar_finalizacion" class="modal-action">{"confirmar"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>

        </section>



        {literal}
            <script>
                //Enviar a leer todos los mensajes
                var marcar_leida_consulta_express = function (id) {
                    if (parseInt(id) > 0) {


                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'marcar_leido_mensaje_consulta_all_m.do',
                                "id=" + id,
                                function (data) {

                                    if (data.result) {

                                        $("#cont_mensajes_noleidos_" + id).hide();
                                        //descontamos la notificacion si no se leyó anteriormente ya
                                        /*if (data.leido_anteriormente == 0) {
                                         //actualizamos el contador de notificaciones generales superior
                                         var notif_CE = parseInt($("#notificacion_consultaexpress").val()) - 1;
                                         $("#notificacion_consultaexpress").val(notif_CE);
                                         if (notif_CE > 0) {
                                         $("#div_shorcuts_cant_consultaexpress").html("<span>" + notif_CE + "</span>");
                                         } else {
                                         $("#div_shorcuts_cant_consultaexpress").html("");
                                         }
                                         //actualizamos el contador de abiertas
                                         var notif_abiertas = parseInt($("#cant_consulta_abiertas").html()) - 1;
                                         if (notif_abiertas > 0) {
                                         $("#cant_consulta_abiertas").html(notif_abiertas);
                                         } else {
                                         $("#cant_consulta_abiertas").hide();
                                         }
                                         
                                         }*/

                                    }
                                }
                        );
                    }
                }
                $(document).ready(function (e) {

                    //Enviar a leer todos los mensajes
                    marcar_leida_consulta_express($("#idconsultaExpress").val());
                    //Enviar a leer todos los mensajes

                    $('.ce-ca-mdl-fin-consulta').on('click', function (e) {
                        $this = $(this);
                        var id = parseInt($this.data("id"));
                        var idpaciente = parseInt($this.data("idpaciente"));
                        var nombre = $this.data("nombre");
                        var apellido = $this.data("apellido");
                        if (id > 0) {
                            $("#a_confirmar_finalizacion").data("id", id);
                            $("#a_confirmar_finalizacion").data("idpaciente", idpaciente);
                            $("#a_confirmar_finalizacion").data("nombre", nombre);
                            $("#a_confirmar_finalizacion").data("apellido", apellido);
                            console.log(nombre + apellido);
                            e.preventDefault();
                            $('#final-consulta-mdl').modal('show');
                        }
                    });
                    $("#a_confirmar_finalizacion").click(function () {

                        var idpaciente = $(this).data("idpaciente");
                        var idconsultaexpress = $(this).data("id");
                        var nombre = $(this).data("nombre");
                        var apellido = $(this).data("apellido");
                        if (parseInt(idpaciente) > 0 && parseInt(idconsultaexpress) > 0) {

                            x_doAjaxCall('POST',
                                    BASE_PATH + "panel-medico/finalizar_consultaexpress.do",
                                    "id=" + idconsultaexpress,
                                    function (data) {
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + idpaciente + "-" + nombre + "-" + apellido + "/mis-registros-consultas-medicas/consultanueva-express-" + idconsultaexpress + ".html";
                                        } else {
                                            x_alert(data.msg);
                                        }

                                    });
                        }
                    });
                    //desplegar campo de mensaje
                    $('.ce-ca-enviar-consulta').on('click', function (e) {

                        e.preventDefault();
                        $(this).parent('.btn-slide-holder').hide();
                        if ($('.audio-reccord-holder-chat').is(':hidden')) {
                            $('.audio-reccord-holder-chat').slideDown();
                        }

                    });
                    /*Metodo que envia el formulario con el mensaje de la consulta*/
                    function sendForm(id) {
                        x_sendForm(
                                $('#send_mensaje_' + id),
                                true,
                                function (data) {
                                    $('body').spin(false);
                                    if (data.result) {
                                        scrollToEl($("body"));
                                        $('.audio-actions-panel').slideUp();
                                        x_alert(data.msg, recargar);
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
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
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
                    /* $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/
                    //scroll hasta el ultimo mensaje del chat
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        scrollToLastMsg($(".cs-ca-chat-holder"));
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
                    $('.ce-ca-cancelar').on('click', function (e) {
                        e.preventDefault();
                        $('.audio-reccord-holder-chat').siblings('.btn-slide-holder').fadeIn();
                        if ($('.chat-img-upld').is(":visible")) {
                            $('.chat-img-upld').slideUp();
                        }
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
                });
            </script>
        {/literal}
    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/abiertas.html"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>

                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Abiertas"|x_translate}</p>
            </section>
        </div>
    {/if}
</div>
