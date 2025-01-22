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
                    <a href="{$url}panel-medico/videoconsulta/" class="btn-default">{"volver"|x_translate}</a>
                </div>
            </div>
        </section>
    </body>
{else}
    <body class="vcm-body">

        <input type="hidden" id="room" value="{$room_name}">

        <input type="hidden" id="idvideoconsulta" value="{$videoconsulta_sala.idvideoconsulta}">
        <input type="hidden" id="idmedico" value="{$medico.idmedico}">
        <input type="hidden" id="idpaciente" value="{$videoconsulta_sala.paciente_idpaciente}">
        <input type="hidden" id="myUserName" value="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">
        <input type="hidden" id="paciente_username" value="{$paciente.nombre} {$paciente.apellido}">

        <form  action="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/" id="link_perfil_salud_form" method="POST" role="form" target="_blank">

        </form>

        <div class="mvc-video-float">
            <a href="javascript:;" id="video-btn-float">
                <figure>
                    <i class="icon-doctorplus-video-cam"></i>
                </figure>
                <div class="mvc-video-float-label">
                    <span id="timer-tiempo-restante-float">&nbsp;</span>
                </div>
            </a>
        </div>

        <section class="vcm-container">

            <nav class="vcm-menu">
                <a href="{$url}panel-medico/videoconsulta/sala-espera.html">
                    <div class="mvc-top-left volver-sala">

                        <figure> 
                            <i class="fa fa-chevron-left"></i>
                        </figure>

                        <label>{"Salir"|x_translate}</label>

                    </div>
                </a>
                <ul>
                    <li><a href="javascript:;" id="mvc-video-trg" data-target="video" class="active"><i class="icon-doctorplus-video-cam"></i></a></li>
                    <li><a href="javascript:;" id="mvc-profile-trg"  data-target="perfil"><i class="icon-doctorplus-user"></i></a></li>
                    <li>
                        <a href="javascript:;"  data-target="chat" id="mvc-chat-trg">
                            <i class="icon-doctorplus-chat-comment"></i>
                            <div id="chat-counter" style="display:none;">
                                <span class="chat-counter">0</span>
                            </div>
                        </a>
                    </li>
                </ul>

            </nav>

            <div class="vcm-video-box">
                <div id="callerArea" class="vcm-video-in">
                    <div id="callerVideo"></div>
                </div>    
                <div class="vcm-video-out">
                    <div  id="selfVideo" class="easyrtcMirror"></div>
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
                    <!-- compartir pantalla-->
                    <a href="javascript:;" class="vcm-compartir-pantalla" title='{"Compartir pantalla"|x_translate}' id="compartir-pantalla" style="z-index: 20000; display:none;">
                        <figure>
                            <i class="fa fa-share-square-o"></i>
                        </figure>
                    </a>
                    <!-- timer de tiempo restante-->
                    <div class="vcm-call-info" id="tiempo_restante" >
                        <span id="timer-tiempo-restante" class="vcm-time">&nbsp;</span>
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
                            {if $paciente.animal!=1}
                                <img src="{$IMGS}extranet/noimage-paciente.jpg" title="{$paciente.nombre} {$paciente.apellido}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                            {else}
                                <img src="{$IMGS}extranet/noimage-animal.jpg" title="{$paciente.nombre} {$paciente.apellido}" alt="{$paciente.nombre} {$paciente.apellido}"/>
                            {/if}
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
                                {if $account.medico.acceso_perfil_salud=="1"}
                                    <li>
                                        <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/" id="perfil-salud-trg" data-id="{$paciente.idpaciente}" target="_blank" data-placement="bottom" rel="noopener noreferrer">
                                            <figure>
                                                <i class="icon-doctorplus-pharmaceutics"></i>
                                            </figure>
                                            <p>{"Informes médicos"|x_translate}<i class="fa fa-chevron-right" style="margin-left: 10px;"></i></p>
                                        </a>
                                    </li>
                                {/if}
                                <li>
                                    <a href="javascript:;" id="vcm-profesionales">
                                        <figure><i class="icon-doctorplus-user-add-like"></i></figure>
                                        <p>{"Profesionales"|x_translate}<i class="fa fa-chevron-right" style="margin-left: 10px;"></i></p>
                                    </a>

                                </li>
                                {include file="videoconsulta/videoconsulta_info_paciente_mobile.tpl"}
                            </ul>
                            {if $account.medico.acceso_perfil_salud=="1"}
                                <div class="vcm-usr-tags-panel">
                                    <div class="vcm-tags">
                                        <div class="mvc-tags-inner">
                                            {if $tags !=""}
                                                <div class="tagsinput-primary okm-tags-no-margin">
                                                    <input name="tagsinput" class="tagsinput" disabled value="{$tags}" />
                                                </div>
                                            {else}
                                                <div class="empty-tagsinput">
                                                    <p class="text-center"> {"Registros de salud no completados"|x_translate}</p>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            {/if}

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
                                                <textarea name="mensaje" id="text_mensaje_{$medico.idmedico}" class="form-control flat" placeholder='{"Mensaje"|x_translate}'></textarea>
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
                            <a href="javascript:;" id="desktop-upload-open" class="mvc-chat-upload-btn"><i class="fui-clip"></i></a>
                            <figure class="mvc-chat-input">
                                <input type="text" id="textoMensaje"  name="mensaje" placeholder='{"No disponible hasta iniciar VideoConsulta"|x_translate}' maxlength="250" disabled="true"/>
                            </figure>
                            <button id="btnSendMsg" onclick="enviarMensajeChat();" disabled="true" class="mvc-chat-send"><i class="fa fa-paper-plane"></i></button>
                        </div>
                    </div>



                    <div id="div-upload-widget" class="okm-row" style="display:none">

                        <div class="vcm-upload-content-box">
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

            <div id="vcm-attach-widget" class="div-upload-widget">
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
            <div id="recordatorio-recargar-pagina" class="alert-recargar-wrapper" style="z-index:401;">
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
            <div id="div_llamar" class="vcm-llamada">
                <div class="vcm-llamada-box">


                    <div id="status2-offline" >
                        {if $paciente.paciente_titular!=""}
                            <figure class="vcm-avatar-call-in">
                                <span class="vcm-avatar-call-in-user">
                                    {if $paciente.animal=="1"}
                                        {"propietario"|x_translate}
                                    {else}
                                        {$paciente.paciente_titular.relacion|capitalize:true} {"del paciente"|x_translate}
                                    {/if}
                                </span>
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
                                    {if $paciente.animal!=1}
                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                                    {else}
                                        <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                                    {/if}
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
                                <span class="vcm-avatar-call-in-user">
                                    {if $paciente.animal=="1"}
                                        {"propietario"|x_translate}
                                    {else}
                                        {$paciente.paciente_titular.relacion|capitalize:true} {"del paciente"|x_translate}
                                    {/if}
                                </span>
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
                                    {if $paciente.animal!=1}
                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                                    {else}
                                        <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$paciente.nombre} {$paciente.apellido}"/>
                                    {/if}
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

        {include file="home/modal_display_file.tpl"}

        <script>
            var camera_firefox = "{$IMGS}video-consulta/camera-firefox.png";
            var camera_chrome = "{$IMGS}video-consulta/camera-chrome.png";
            var paciente_username = $("#paciente_username").val();
            var mensajes_videoconsulta = {$mensajes_videoconsulta};
            var inicio_llamada = "{$videoconsulta_sala.inicio_llamada}";
            var display_images_form = false;

            //varibales open tok
            var apiKey = "{$videoconsulta_session.apiKey}";
            var sessionId = "{$videoconsulta_session.session}";
            var token = "{$videoconsulta_session.token_medico}";
            var eventStream;
            var clientId_paciente;
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

                    //mostramos la ventana si esta oculto el chat
                    if (!$("#mvc-chat-trg").hasClass('active')) {
                        //$("#mvc-chat-trg").click();
                        if ($("#mvc-chat-trg #chat-counter").is(":visible")) {
                            $("#mvc-chat-trg .chat-counter").text(parseInt($("#mvc-chat-trg .chat-counter").text()) + 1);
                        } else {
                            $("#mvc-chat-trg .chat-counter").text(1);
                        }
                        if (parseInt($("#mvc-chat-trg .chat-counter").text()) > 0) {
                            $("#mvc-chat-trg #chat-counter").slideDown();
                        }

                    }

                    if (who !== "Yo") {
                        if (msgType == "imagen") {
                            var html_mensaje = '<div class="file mvc-chat-line guest"><div class="mvc-chat-guest"><figure class="mvc-attach">' + content + '</figure><span></span></div></div>';
                            $("#conversacion").append($(html_mensaje));

                        } else {
                            var html_mensaje = '<div  class="okm-row  mvc-chat-line guest"><div class="mvc-chat-guest"><figure><span>' + paciente_username + '</span><p></p></figure><span></span></div></div>';
                            $("#conversacion").append($(html_mensaje));
                            $("#conversacion p:last").text(content);
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
                    $(".vcm-chat-box").mCustomScrollbar("scrollTo", "bottom");
                }

                $(document).ready(function () {

                    //quitamos el icono remover tags imput
                    $('.tagsinput').tagsinput();
                    $(".mvc-tags-inner span[data-role='remove']").remove();
                    $('#mvc-chat-trg').on('click', function (e) {
                        e.preventDefault();
                        $("#mvc-chat-trg #chat-counter").slideUp();
                        setTimeout(
                                function () {
                                    $(".vcm-chat-box").mCustomScrollbar("scrollTo", "bottom");
                                }
                        , 200);
                    });

                    //recordatorio recargar pagina
                    if (localStorage.getItem('hide-recordatorio-recargar-pagina') != "1") {
                        $("#recordatorio-recargar-pagina").fadeIn();
                    }
                    $(".cerrar_alert_recargar").click(function () {
                        $("#recordatorio-recargar-pagina").slideUp();
                        localStorage.setItem('hide-recordatorio-recargar-pagina', "1");
                    });

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

                                }, 1000 * tiempo_espera * 60);//tiempo_espera=milisegundos*minutos para el vencimiento de espera*60


                    }




                    $(".vmc-chat-box").mCustomScrollbar({
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
                    $("#perfil-salud-trg").click(function (e) {
                        e.preventDefault();
                        e.stopPropagation();

                        var href = $(this).attr("href");
                        var windowReference = window.open("about:blank", "_blank");

                        var id = $(this).data("id");
                        if (parseInt(id) > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'panel-medico/change_member.do',
                                    "id=" + id,
                                    function (data) {

                                        if (data.result) {
                                            windowReference.location = href;
                                            //$("#link_perfil_salud_form").submit();
                                        } else {
                                            x_alert(data.msg);
                                        }
                                        return true;
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

                                            $("#p_text_area_" + id).html(x_translate(data.msg));
                                            $("#text_mensaje_" + id).hide();
                                            $("#p_text_area_" + id).show();
                                            x_alert(data.msg);
                                            setTimeout(
                                                    function () {
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

                        var id = parseInt($(this).data("id"));

                        if (id > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'terminar_videoconsulta.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {
                                        if (data.result) {
                                            session.forceDisconnect(clientId_paciente);
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
                    var btns = $('.vcm-menu ul').find('a');

                    var profesionales = $('#vcm-profesionales');
                    var medicosFrecuentes = $('#vcm-medicos-frecuentes');
                    var medicosFrecuentesClose = $('#vcm-medicos-frecuentes-close');


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

                    $('#desktop-upload-open').on('click', function (e) {
                        e.preventDefault();
                        var chatHeight = parseInt($(".vcm-chat-box").css("height"));
                        if (display_images_form) {
                            if ($('#div-upload-widget').is(':visible')) {
                                $('#div-upload-widget').slideUp();

                                $(".vcm-chat-box").css("height", chatHeight + 300);
                            } else {
                                $('#div-upload-widget').slideDown();
                                $(".vcm-chat-box").css("height", chatHeight - 300);

                            }
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
                    mensajes_videoconsulta.forEach(function (elem, indice) {
                        console.log(elem)
                        if (elem.emisor == "m") {
                            var emisor = "Yo";
                        } else {
                            var emisor = "Paciente";
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

                        //agregamos path del nuevo archivo
                        $("#modal-display-file object").attr("data", src);
                        $("#modal-display-file embed").attr("src", src);
                        $("#modal-display-file .download").attr("href", src);

                        $("#modal-display-file object").attr("type", type);
                        $("#modal-display-file embed").attr("type", type);
                        $("#modal-display-file").modal("show");
                    });


                    //dejamos seleccionado el menu de video
                    $("#mvc-video-trg").click();

                });
            </script>		
        {/literal}



    </body>

{/if}