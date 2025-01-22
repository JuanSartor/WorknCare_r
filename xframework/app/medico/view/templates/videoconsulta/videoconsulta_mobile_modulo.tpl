
<input type="hidden" id="room" value="{$room_name}">

<input type="hidden" id="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
<input type="hidden" id="idmedico" value="{$medico.idmedico}">
<input type="hidden" id="idpaciente" value="{$videoconsulta_sala.paciente_idpaciente}">
<input type="hidden" id="myUserName" value="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">
<input type="hidden" id="paciente_username" value="{$paciente.nombre} {$paciente.apellido}">

<form  action="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/" id="link_perfil_salud_form" method="POST" role="form" target="_blank">

</form>
<section class="vcm-container">
    <nav class="vcm-menu">
        <ul>
            <li><a href="javascript:;" id="mvc-video-trg" data-target="video" class="active"><i class="icon-doctorplus-video-cam"></i></a></li>
            <li><a href="javascript:;" id="mvc-profile-trg"  data-target="perfil"><i class="icon-doctorplus-user"></i></a></li>
            <li><a href="javascript:;" id="mvc-chat-trg"  data-target="chat"><i class="icon-doctorplus-chat-comment"></i></a></li>
        </ul>
    </nav>

    <div class="vcm-video-box">
        <div id="callerArea" class="vcm-video-in">
            <video id="callerVideo"  playsinline="playsinline" width="100%" autoplay="autoplay">
            </video>

        </div>      <div class="vcm-video-out">
            <video  playsinline="playsinline" width="100%" autoplay="autoplay" id="selfVideo" class="easyrtcMirror">
            </video>
        </div>
    </div>
    <div id="div_hangup" class="vcm-footer" style="display:none;">
        <div class="vcm-video-footer-holder">
            <!--  colgar-->
            <a href="javascript:;" id="hangupButton" class="vcm-call-action" >
                <figure>
                    <i class="icon-doctorplus-call-close"></i>
                </figure>
            </a>
            <!-- timer de tiempo restante-->
            <div class="vcm-call-info" id="tiempo_restante" style="display:none;">
                <span id="timer-tiempo-restante" class="vcm-time"> min</span>
                <span class="vcm-text">{"Tiempo para finalizar"|x_translate}</span>
            </div>
        </div>
    </div>






    <div id="vcm-perfil" class="vcm-usr-info">
        <div class="vcm-usr-info-box">
            <div class="vcm-usr-picture-box">
                {if $paciente.image.perfil!=""}
                    <img src="{$paciente.image.perfil}" title="{$paciente.nombre} {$paciente.apellido}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                {else}
                    <img src="{$IMGS}extranet/noimage-paciente.jpg" title="{$paciente.nombre} {$paciente.apellido}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                {/if}
            </div>
            <div class="vcm-usr-data-box">
                <span class="vcm-usr-data-name">
                    {$paciente.nombre} {$paciente.apellido}
                </span>
                <span class="vcm-usr-data-fn">
                    DN {$paciente.fechaNacimiento|date_format:"%d/%m/%Y"}
                </span>
            </div>
        </div>

        <div class="vcm-panel-holder-box" style="display:none;">
            <div class="vcm-panel-holder">
                <div class="vcm-usr-action-panel">
                    <ul>
                        <li>
                            <a href="javascript:;" id="perfil-salud-trg" data-id="{$paciente.idpaciente}">
                                <figure>
                                    <i class="icon-doctorplus-pharmaceutics"></i>
                                </figure>
                                <p>{"Perfil de Salud"|x_translate}</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" id="vcm-profesionales">
                                <figure><i class="icon-doctorplus-user-add-like"></i></figure>
                                <p>{"Profesionales frecuentes"|x_translate}</p>
                            </a>

                        </li>
                        <li>
                            <a href="javascript:;">
                                <figure><i class="icon-doctorplus-ficha-tecnica"></i></figure>
                                <p>
                                    {if $paciente.pais_idpais==1}
                                        {"Tarjeta Vitale"|x_translate}<br>
                                        Nº {$paciente.tarjeta_vitale}
                                    {/if}
                                    {if $paciente.pais_idpais==2}
                                        {"Tarjeta CNS"|x_translate}<br>
                                        Nº {$paciente.tarjeta_cns}
                                    {/if}
                                    {if $paciente.pais_idpais==3}
                                        {"Tarjeta eID"|x_translate}<br>
                                        Nº {$paciente.tarjeta_eID}
                                    {/if}
                                    {if $paciente.pais_idpais==4}
                                        {"Pasaporte"|x_translate}<br>
                                        Nº {$paciente.tarjeta_pasaporte}
                                    {/if}
                                </p>
                            </a>
                        </li>
                    </ul>

                    <div class="vcm-usr-tags-panel">
                        <div class="vcm-tags">
                            <div class="mvc-tags-inner">

                                <div class="tagsinput-primary okm-tags-no-margin">
                                    <input name="tagsinput" class="tagsinput" disabled value="{$tags}" />

                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <div id="vcm-medicos-frecuentes" class="vcm-medicos-frecuentes">
        <a href="javascript:;" id="vcm-medicos-frecuentes-close" class="vcm-medicos-frecuentes-header">
            <i class="icon-doctorplus-left-arrow"></i> 
            {"Profesionales frecuentes"|x_translate}
        </a>

        <div class="vcm-medicos-frecuentes-item-holder">

            <div class="vcm-medicos-frecuentes-item-box">	
                <div id="profesionales-frecuentes" class="medico-pacientes-modal profesionales-frecuentes-mobile">
                    <ul>
                        {foreach from=$listado_profesionales_frecuentes item=medico}
                            <li>
                                {if $medico.imagenes.usuario != ""}
                                    <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html" target="doctorplus">
                                        <img class="img-circle" src="{$medico.imagenes.usuario}" alt="{$medico.nombre} {$medico.apellido}">
                                    </a>
                                {else}
                                    <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html" target="doctorplus">
                                        <img class="img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.nombre} {$medico.apellido}">
                                    </a>
                                {/if}
                                <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html" target="doctorplus">
                                    <h3>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</h3>
                                </a>
                                <p><strong>{$medico.mis_especialidades.0.especialidad}</strong> 

                                </p>
                                {if $medico.idmedico!=$idmedicosession}
                                    <a href="javascript:;" class="dp-email " data-id="{$medico.idmedico}"></a>
                                    <div class="enviar-mje">
                                        <textarea name="mensaje" id="text_mensaje_{$medico.idmedico}" class="form-control flat" placeholder="Mensaje"></textarea>
                                        <p id="p_text_area_{$medico.idmedico}" style="display: none"></p>
                                    </div>
                                {/if}
                            </li>
                        {foreachelse}
                            <li>
                                {"No hay profesionales frecuentes"|x_translate}
                            </li>
                        {/foreach}
                    </ul>
                </div>
            </div>
        </div>

    </div>

    <div id="vcm-chat" class="vcm-chat">
        <div  class="vcm-chat-box">
            <div id="conversacion"></div>

        </div>
        <form name="send_mensaje_videoconsulta" action="{$url}send_mensaje_videoconsulta_m.do" id="send_mensaje_videoconsulta" method="POST" role="form" onsubmit="return false;">
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
                <form name="send_imagen_videoconsulta" action="{$url}send_mensaje_videoconsulta_m.do" id="send_imagen_videoconsulta" method="POST" role="form" onsubmit="return false;">
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
                        id_group=$videoconsulta_sala.medico_idmedico selector="#dropzone"  preview="#upload-preview" callback_success="successImg" 
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
                {if $paciente.paciente_titular!=""}
                    <figure class="vcm-avatar-call-in">
                        <span class="vcm-avatar-call-in-user">{$paciente.paciente_titular.relacion|capitalize:true} {"del paciente"|x_translate}</span>
                        <span class="vcm-avatar-call-in-arrow">
                            <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                                 viewBox="0 0 12.3 10.2" enable-background="new 0 0 12.3 10.2" xml:space="preserve">
                            <path fill="#08151B" stroke="#F6F7F7" stroke-linecap="square" stroke-linejoin="round" d="M0.9,0L5,8.2c0,0,0.9,1.2,2.4,0L11.4,0"/>
                            </svg>
                        </span>
                    </figure>
                {/if}



                <div  class="vcm-call-avatar">
                    {if $paciente.paciente_titular!=""}
                        {if $paciente.paciente_titular.image.list!=""}
                            <img src="{$paciente.paciente_titular.image.list}" alt="{$paciente.paciente_titular.nombre} {$paciente.paciente_titular.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.paciente_titular.nombre} {$paciente.paciente_titular.apellido}"/>
                        {/if}
                    {else}
                        {if $paciente.image.list!=""}
                            <img src="{$paciente.image.list}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                        {/if}
                    {/if}
                    <span class="vcm-call-icon-state standby">
                        <i class="icon-doctorplus-minus"></i>
                    </span>
                </div>

                <p class="vcm-call-notification">
                    {"El paciente aún no ingresó al consultorio."|x_translate}
                </p>

            </div>

            <div id="status2-online" style="display:none;">

                {if $paciente.paciente_titular!=""}
                    <figure class="vcm-avatar-call-in">
                        <span class="vcm-avatar-call-in-user">{$paciente.paciente_titular.relacion|capitalize:true} {"del paciente"|x_translate}</span>
                        <span class="vcm-avatar-call-in-arrow">
                            <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                                 viewBox="0 0 12.3 10.2" enable-background="new 0 0 12.3 10.2" xml:space="preserve">
                            <path fill="#08151B" stroke="#F6F7F7" stroke-linecap="square" stroke-linejoin="round" d="M0.9,0L5,8.2c0,0,0.9,1.2,2.4,0L11.4,0"/>
                            </svg>
                        </span>
                    </figure>
                {/if}



                <div  class="vcm-call-avatar">
                    {if $paciente.paciente_titular!=""}
                        {if $paciente.paciente_titular.image.list!=""}
                            <img src="{$paciente.paciente_titular.image.list}" alt="{$paciente.paciente_titular.nombre} {$paciente.paciente_titular.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.paciente_titular.nombre} {$paciente.paciente_titular.apellido}"/>
                        {/if}
                    {else}
                        {if $paciente.image.list!=""}
                            <img src="{$paciente.image.list}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                        {else}
                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                        {/if}
                    {/if}
                    <span class="vcm-call-icon-state ready">
                        <i class="icon-doctorplus-check-thin"></i>
                    </span>
                </div>

                <p class="vcm-call-notification ready">
                    {"¡El paciente ingresó al consultorio!"|x_translate}<br>
                    {"Haga click en llamar para atenderlo."|x_translate}
                </p>

            </div>
        </div>
        <div class="vcm-footer calling ">
            <div class="vcm-video-footer-holder">
                <!--  llamar-->

                <a href="javascript:;" id="btnLlamar" class="vcm-call-action" style="display:none;">
                    <figure>
                        <i class="icon-doctorplus-call-start"></i>
                    </figure>
                </a>
                <div class="vcm-call-info" id="llamando" style="display:none;">
                    <span class="vcm-time calling">{"Llamando"|x_translate}<span>.</span><span>.</span><span>.</span></span>
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
                    <div><img  class="img-responsive" src="" alt="" ></div>
                </div>						
            </div>
        </div>
    </div>
</div>

<!-- Modal finalizar videoconsulta -->
<div id="final-consulta-mdl" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-sm modal-action-bool-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p>{"¿Desea colgar y finalizar la Video Consulta?"|x_translate}</p>
            <div class="modal-action-holder">
                <a href="#" data-dismiss="modal" class="modal-action-close">{"cancelar"|x_translate}</a>
                <a href="javascript:;" data-id="{$videoconsulta_sala.idvideoconsulta}" id="a_confirmar_finalizacion" class="modal-action">{"confirmar"|x_translate}</a>
            </div>
        </div>
    </div>
</div>

<!--	Modal tiempo transcurrido	-->


<div id="modal-tiempo-transcurrido" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡La videoconsulta ha terminado!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Ha transcurrido el tiempo máximo de videoconsulta. Debe escribir las conclusiones médicas para finalizar la misma."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">

                    <button id="finalizar_videoconsulta_modal" data-id="{$videoconsulta_sala.idvideoconsulta}"><i class="icon-doctorplus-ficha-check"></i> {"Finalizar videoconsulta"|x_translate}</button>
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
                <h3 class="modal-sub-title">{"El paciente no se presentó en horario. Han transcurrido [[{$VIDEOCONSULTA_VENCIMIENTO_SALA}]] minutos de espera"|x_translate}</h3>


            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="{$url}panel-medico/videoconsulta/" class="btn-default" >{"Salir"|x_translate}</a>
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
                    <h4 class="modal-title">{"No se ha podido establecer la conexión con el servidor de videoconsulta. Intente nuevamente o contacte al administrador"|x_translate}</h3>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="{$url}panel-medico/videoconsulta/" class="btn-default" >{"Salir"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Video Consulta rechazada-->

<div id="modal-videoconsulta-rechazada" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon"><i class="icon-doctorplus-alert-round"></i></figure>
                <h3 class="modal-sub-title">{"No se pudo establecer la comunicación"|x_translate}</h3>
                <h4 class="modal-title">{"El paciente no ha respondido su llamada. Intente nuevamente en unos instantes"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="{$url}panel-medico/videoconsulta/" class="btn-default" data-dismiss="modal" aria-label="Close" >{"cerrar"|x_translate}</a>
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
    var paciente_username = $("#paciente_username").val();
    {if $mensajes_videoconsulta!=""}
    var mensajes_videoconsulta ={$mensajes_videoconsulta};
    {/if}
    var inicio_llamada = "{$videoconsulta_sala.inicio_llamada}";
    var display_images_form = false;
</script>




{*Seteamos variables del tiempo restante si la consulta ya estaba iniciada y se vuelve a ingresar a la sala*}
{if $videoconsulta_sala.estadoVideoConsulta_idestadoVideoConsulta=="7" }
    <script type="text/javascript">
        //flag si ya se realizo la llamada, si ya estaba comenzada se setea en true
        var iniciada = true;

        //si ya estabaa iniciada, no se esperan 5 minutos al paciente para luego vencer la videoconsulta
        var vencimiento_llamada = false;


    </script>
{else}
    <script type="text/javascript">
        //flag si ya se realizo la llamada, se seteara en true cuando se acepte la llamada
        var iniciada = false;

        //minutos de espera al paciente
        var tiempo_espera = {$segundos_espera};
        //si ya estabaa iniciada, no se esperan 5 minutos al paciente para luego vencer la videoconsulta
        var vencimiento_llamada = true;



    </script>
{/if}


{x_load_js}



{literal}
    <script type="text/javascript">


        //funcion que concatena el texto ingresado del lado cliente a la ventana de conversacion cuando ingresa un mensaje
        function addToConversation(who, msgType, content) {
            console.log(content);
            //mostramos la ventana si esta oculto el chat
            if (!$("#mvc-chat-trg").hasClass('active')) {
                $("#mvc-chat-trg").click();
            }


            if (who !== "Yo") {
                if (msgType == "imagen") {
                    var html_mensaje = '<div class="okm-row mvc-chat-line"><div class="mvc-chat-guest"><figure class="mvc-attach"><a href="#" class=" vcm-chat-attach">' + content + '<div class="mvc-attach-btn"><i class="icon-doctorplus-search"></i></div></a></figure><span></span></div></div>';

                    var img_modal_big = content.replace("_usuario.", ".");
                    img_modal_big = img_modal_big.replace("style='width:100px;'", "");
                    var html_modal_big = "<div>" + img_modal_big + "</div>";
                    $(".vcm-attach-slide-master").slick('slickAdd', html_modal_big);
                    console.log($(".vcm-attach-slide-master").slick('setPosition'));
                    var img_modal_min = content.replace("_usuario.", "_perfil.");
                    img_modal_min = img_modal_min.replace("style='width:100px;'", "");

                    var html_modal_min = "<div>" + img_modal_min + "</div>";
                    $(".vcm-attach-slide-control").slick('slickAdd', html_modal_min);
                    $("#conversacion").append($(html_mensaje));

                } else {
                    var html_mensaje = '<div  class="okm-row  mvc-chat-line"><div class="mvc-chat-guest"><figure><span>' + paciente_username + '</span><p></p></figure><span></span></div></div>';
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

            //quitamos el icono remover tags imput
            $('.tagsinput').tagsinput();
            $(".mvc-tags-inner span[data-role='remove']").remove();


            //si luego de 5 minutos no se ha iniciado la videoconsulta mostramos el modal de tiempo vencido
            if (vencimiento_llamada) {
                setTimeout(
                        function () {

                            if (!iniciada) {
                                $("#modal-videoconsulta-tiempo-espera-vencido").modal("show");
                                tiempoTranscurrido();
                                console.log("vencer videoconsulta");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'vencimiento_espera_videoconsulta.do',
                                        'idvideoconsulta=' + $("#idvideoconsulta").val(),
                                        function (data) {

                                        });
                            }

                        }, 1000 * tiempo_espera * 60)//tiempo_espera=milisegundos*minutos para el vencimiento de espera*60


            }




            $(".mvc-chat-box").mCustomScrollbar({
                theme: "dark-3"
            });
            //boton llamar
            $('#btnLlamar').on('click', function (e) {

                e.preventDefault();
                if (!$(this).hasClass('calling-label-show')) {
                    if ($("#selfVideo").attr("src") == undefined) {
                        $("#modal-videoconsulta-compartir-dispositivos").modal("show");
                        initMediaSource();
                    } else {
                        $(this).addClass('calling-label-show');
                        llamar();
                    }
                } else {
                    $(this).removeClass('calling-label-show');
                    hangup();
                }

            });
            //boton finalizar llamada
            $('#hangupButton').on('click', function (e) {
                $('#final-consulta-mdl').modal('show');

            });
            //redireccion a perfil de salud
            $("#perfil-salud-trg").click(function () {
                $("#perfil-salud-trg").data("title", x_translate("Se abrirá en una nueva pestaña")).tooltip("show");

                var id = $(this).data("id");
                if (parseInt(id) > 0) {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-medico/change_member.do',
                            "id=" + id,
                            function (data) {
                                if (data.result) {
                                    $("#link_perfil_salud_form").submit();
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }

            });

            //desplegar modal profesionales frecuentes
            $('#profesionales-frecuentes-trg').on('click', function (e) {
                e.preventDefault();
                $('#profesionales-frecuentes').modal('show');
            });

            //enviar mensaje a profesionales frecuentes
            $('#profesionales-frecuentes .dp-email').on('click', function () {
                var id = $(this).data("id");

                if ($(this).hasClass('show-textarea')) {

                    var $this = $(this);
                    if (parseInt(id) > 0 && $("#text_mensaje_" + id).val() != "") {
                        $("#profesionales-frecuentes").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'enviar_mensaje_from_mis_pacientes.do',
                                "mensaje=" + $("#text_mensaje_" + id).val() + "&idmedico=" + id,
                                function (data) {
                                    $("#text_mensaje_" + id).val("");
                                    $("#profesionales-frecuentes").spin(false);

                                    $("#p_text_area_" + id).html(data.msg);
                                    $("#text_mensaje_" + id).hide();
                                    $("#p_text_area_" + id).show();
                                    setTimeout(
                                            function ()
                                            {
                                                $this.removeClass('show-textarea');
                                                $this.next('.enviar-mje').slideUp();
                                                $this.parent('li').removeClass('show-textarea-box');
                                            }, 3000);
                                }
                        );
                    }

                } else {
                    $("#text_mensaje_" + id).show();
                    $("#p_text_area_" + id).hide();
                    $('.enviar-mje').slideUp();
                    $("#profesionales-frecuentes .dp-email").removeClass('show-textarea');
                    $(this).addClass('show-textarea');
                    $(this).next('.enviar-mje').slideDown();
                    $(this).parent('li').addClass('show-textarea-box');
                    $(this).addClass("btn_send_mensaje");
                }
            });
            //boton finalizar videoconsulta



            $("#a_confirmar_finalizacion,#finalizar_videoconsulta_modal").click(function () {
                //colgamos la llamada cuando transcurre el tiempo
                tiempoTranscurrido();
                var id = parseInt($(this).data("id"));

                if (id > 0) {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'terminar_videoconsulta.do',
                            "idvideoconsulta=" + id,
                            function (data) {
                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/mis-registros-consultas-medicas/consultanueva-videoconsulta-" + id + ".html";
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }
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

                var img = $(this).parent().find("img").attr("src");
                img = img.replace("_usuario.", ".");
                $('#ver-archivo img').attr("src", img);
                $('#ver-archivo').modal('show');
                /*
                 e.preventDefault();
                 
                 if (!$('#vcm-attach-widget').hasClass('open')) {
                 $('#vcm-attach-widget').addClass('open');
                 }
                 
                 if($("#conversacion .vcm-chat-attach").length>0){ 
                 var index=$("#conversacion .vcm-chat-attach").index($(this));
                 $(".vcm-attach-slide-control").slick('slickGoTo',index);
                 
                 }else{
                 $(".vcm-attach-slide-master").slick('setPosition');
                 }
                 */
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


            var perfil = $('#vcm-perfil');
            var medicos = $('#vcm-medicos-frecuentes');
            var chat = $('#vcm-chat');
            var btns = $('.vcm-menu').find('a');

            var profesionales = $('#vcm-profesionales');
            var medicosFrecuentes = $('#vcm-medicos-frecuentes');
            var medicosFrecuentesClose = $('#vcm-medicos-frecuentes-close');

            var uploadWidgetOpen = $('#vcm-upload-btn');
            var uploadWidgetClose = $('#vcm-upload-widget-close');
            var uploadWidget = $('#vcm-upload-widget');

            function removeActive() {
                btns.removeClass('active');
            }

            btns.on('click', function (e) {
                e.preventDefault();

                var target = $(this).data('target');


                if (target == 'video') {
                    //si se inicio la conexion o no, mostramos el footer para cortar o el status del paciente
                    if (display_images_form) {
                        $("#div_hangup").show();
                    } else {
                        $("#div_llamar").show();
                    }

                    removeActive();
                    $(this).addClass('active');

                    if (perfil.hasClass('open')) {
                        perfil.removeClass('open');
                    }
                    if (medicos.hasClass('open')) {
                        medicos.removeClass('open');
                    }
                    if (chat.hasClass('open')) {
                        chat.removeClass('open');
                    }
                    $(".vcm-panel-holder-box ").hide();
                }

                if (target == 'perfil') {
                    $(".vcm-llamada").hide();
                    removeActive();
                    $(this).addClass('active');

                    if (medicos.hasClass('open')) {
                        medicos.removeClass('open');
                    }
                    if (chat.hasClass('open')) {
                        chat.removeClass('open');
                    }
                    if (!perfil.hasClass('open')) {
                        perfil.addClass('open');
                    }
                    $(".vcm-panel-holder-box ").show();
                }

                if (target == 'chat') {
                    $(".vcm-llamada").hide();
                    removeActive();
                    $(this).addClass('active');

                    if (perfil.hasClass('open')) {
                        perfil.removeClass('open');
                    }
                    if (medicos.hasClass('open')) {
                        medicos.removeClass('open');
                    }

                    if (!chat.hasClass('open')) {
                        chat.addClass('open');
                    }
                    $(".vcm-panel-holder-box ").hide();
                }


            });


            profesionales.on('click', function (e) {
                e.preventDefault();
                if (!medicosFrecuentes.hasClass('open')) {
                    medicosFrecuentes.addClass('open');
                }
            });
            medicosFrecuentesClose.on('click', function (e) {
                e.preventDefault();
                if (medicosFrecuentes.hasClass('open')) {
                    medicosFrecuentes.removeClass('open');
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
            $(".vcm-medicos-frecuentes-item-box").mCustomScrollbar({
                theme: "dark-3",
                autoHideScrollbar: false,
                autoDraggerLength: true
            });


            //agregamos los mensajes al chat
            if (typeof mensajes_videoconsulta != "undefined") {
                mensajes_videoconsulta.forEach(function (elem, indice) {
                    console.log(elem)
                    if (elem.emisor == "m") {
                        var emisor = "Yo";
                    } else {
                        var emisor = "Paciente";
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
            //dejamos seleccionado el menu de video
            $("#mvc-video-trg").click();

        });
    </script>		
{/literal}


