<div id="div_videoconsulta_espera" class="relative cs-nc-section-holder">
    <form  action="{$url}panel-medico/videoconsulta/sala/" id="link_sala" method="POST" role="form" >
    </form>

    <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
        <div class="modal-dialog">
            <div class="modal-content"></div>
        </div>
    </div>
    <script>
        $(document).ready(function (e) {
            $('#ver-archivo').on('hidden.bs.modal', function () {
                $(this)
                        .removeData('bs.modal')
                        .find(".modal-content").html('');
            });
        });


    </script> 

    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {*<li class="active">{"Consultas en Sala de Espera"|x_translate}</li>*}
        </ol>
    </div>
    {if $videoconsulta_proxima!="" || $listado_videoconsultas_espera.rows && $listado_videoconsultas_espera.rows|@count > 0}

        <section class="container cs-nc-p2">

            <div class="okm-row">
                <div class="ce-ca-toobar vc-toolbar-x2">
                    <a href="{$url}panel-medico/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="icon-doctorplus-video-sheet"></i></figure>
                            {if $cantidad_consulta.abiertas>0}
                            <span>{$cantidad_consulta.abiertas}</span>
                        {/if}
                    </div>
                    <span>{"SALA DE ESPERA"|x_translate}</span>
                </div>
                <div class="vc-toolbar-x2">
                    <div class="vc-sala-num-pacientes-holder">
                        <figure class="vc-sala-num-pacientes-box">
                            <span>{$listado_videoconsultas_espera.rows|@count}</span> {"pacientes más por atender"|x_translate}
                        </figure>
                    </div>
                </div>
            </div>
            {*La primer videoconsulta aparece separada como proxima*}
            <!--Proxima videoconsulta a en la sala-->
            {assign var=videoconsulta_proxima value=$listado_videoconsultas_espera.rows[0]}
            {if $videoconsulta_proxima!=""}

                <div class="okm-container">
                    <div class="okm-row">
                        <h2 class="vc-sala-proximo-paciente"><i class="icon-doctorplus-user"></i> {"Su próximo paciente"|x_translate}</h2>
                    </div>
                </div>
                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">


                        <div class="panel  panel-default">
                            <div class="panel-heading" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar">                         
                                    <div class="row">
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner status-paciente">
                                                <div class="cs-ca-usr-avatar">
                                                    {if $videoconsulta_proxima.paciente.image}
                                                        <img src="{$videoconsulta_proxima.paciente.image.list}" alt="user"/>
                                                    {else}
                                                        {if $videoconsulta_proxima.paciente.animal!=1}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                        {/if}
                                                    {/if}
                                                    <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_proxima.paciente.idpaciente}">
                                                        <figure class="status-paciente-consultorio-icon paciente-online" data-idpaciente="{$videoconsulta_proxima.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}" style="display:none;">
                                                            <i class="icon-doctorplus-check-thin"></i>
                                                        </figure>
                                                        <figure class="status-paciente-consultorio-icon paciente-offline" data-idpaciente="{$videoconsulta_proxima.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}" {if $videoconsulta_proxima.segundos_diferencia > 0} style="display:none;"{/if} >
                                                            <i class="fa fa-minus"></i>
                                                        </figure>
                                                    </a>
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    <span>{"Paciente"|x_translate}</span>
                                                    <h2>{$videoconsulta_proxima.paciente.nombre} {$videoconsulta_proxima.paciente.apellido}</h2>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="colx3 paciente-sala-status">
                                            <div class="cs-ca-colx3-inner status-container">
                                                <div class="status-paciente-consultorio paciente-online " data-idpaciente="{$videoconsulta_proxima.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}" style="display:none;"> 
                                                    {"Disponible en el consultorio"|x_translate}
                                                </div>
                                                <div class="status-paciente-consultorio paciente-offline" data-idpaciente="{$videoconsulta_proxima.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}" {if $videoconsulta_proxima.segundos_diferencia > 0} style="display:none;"{/if}> 
                                                    {"No se encuentra en el consultorio"|x_translate}
                                                </div>
                                                <div class="timer-tiempo-transcurrido" data-inicio="{$videoconsulta_proxima.inicio_sala}"></div>
                                            </div>
                                        </div>

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="va-atender-paciente-card-container proximo-atender">
                                                <div class="va-atender-card">
                                                    {if $videoconsulta_proxima.segundos_diferencia > 0}
                                                        <div class="va-atender-paciente-tiempo front" data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}">
                                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                                <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_proxima.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Horario de atención"|x_translate}:</span>
                                                                <div class="cs-ca-tiempo-respuesta">
                                                                    <span class="cs-ca-clock-icon"><i class="fa fa-calendar-o"></i></span>
                                                                    <span class="vc-paciente-fecha">{$videoconsulta_proxima.fecha_futura_format} {$videoconsulta_proxima.inicio_sala|date_format:"%H:%M"}hs</span>
                                                                </div>
                                                                {if $videoconsulta_proxima.fecha_futura!=1}
                                                                    <div class="cs-ca-tiempo-respuesta timer-wrapper">
                                                                        <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span>
                                                                        <span data-id="{$videoconsulta_proxima.idvideoconsulta}" data-startsec="{$videoconsulta_proxima.segundos_diferencia}"  data-inicio-sala="{$videoconsulta_proxima.inicio_sala}" class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                                    </div>   
                                                                {/if}

                                                            </div>
                                                        </div>
                                                    {/if}
                                                    <div class="va-atender-paciente-btn back"  data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}" style="transform:none; {if $videoconsulta_proxima.segundos_diferencia > 0} display:none;{/if}">
                                                        <a href="{$url}panel-medico/videoconsulta/sala/?id={$videoconsulta_proxima.idvideoconsulta}" data-idvideoconsulta="{$videoconsulta_proxima.idvideoconsulta}"  class="btn-default pasar_consultorio"><i class="icon-doctorplus-video-cam"></i> {"atender al paciente"|x_translate}</a>	
                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_proxima.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_proxima.idvideoconsulta}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_proxima.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_proxima.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-fecha">{"Ver consulta"|x_translate}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$videoconsulta_proxima.idvideoconsulta}" data-id="{$videoconsulta_proxima.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_proxima.idvideoconsulta}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">


                                        {foreach from=$videoconsulta_proxima.mensajes item=mensaje}


                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        <div class="chat-image-avatar-xn">
                                                            {if $videoconsulta_proxima.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $videoconsulta_proxima.paciente_titular.image.perfil != ""}
                                                                        <img src="{$videoconsulta_proxima.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_proxima.paciente.image.perfil != ""}
                                                                    <img src="{$videoconsulta_proxima.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    {if $videoconsulta_proxima.paciente.animal != 1}
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
                                                                {*archivos videoconsulta*}
                                                                {if $mensaje.idmensajeVideoConsulta!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                                {*archivos turno*}
                                                                {if $mensaje.idmensajeTurno!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeTurno}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                <p>{$mensaje.mensaje} </p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                <div class="chat-content-attach">
                                                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                        <i class="fui-clip"></i>
                                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                    </a>
                                                                </div>
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}
                                        {foreachelse}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"No se registraron mensajes"|x_translate}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/foreach}

                                        {if $videoconsulta_proxima.mensajes|@count>0 }
                                            <div class="row text-center">
                                                <a href="javascript:;" class="btn btn-secondary btn_responder_mensaje" data-id="{$videoconsulta_proxima.idvideoconsulta}"><i class="icon-doctorplus-chat-add"></i>{"Enviar respuesta"|x_translate}</a>
                                            </div>
                                        {/if}
                                    </div>
                                    {*contenedor escribir mensaje*}
                                    <!--  Form mensaje-->
                                    <div class="row enviar-mesaje-container" data-id="{$videoconsulta_proxima.idvideoconsulta}" style="display:none;">
                                        <div class="audio-actions-panel">
                                            <!--slide-->
                                            <div class="audio-reccord-holder">

                                                <form  id="send_mensaje_{$videoconsulta_proxima.idvideoconsulta}">
                                                    <input type="hidden" name="idvideoconsulta" value="{$videoconsulta_proxima.idvideoconsulta}"/>
                                                    <input type="hidden" name="repuesta_desde_consulta" value="1"/>
                                                    <div class="audio-reccord-holder">
                                                        <div class="chat-msg-holder">
                                                            <div class="chat-msg-input-holder">
                                                                <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Escriba aqui su mensaje"|x_translate}'></textarea>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </form>

                                                <div class="text-center  btn-send-mensaje-holder">
                                                    <a href="javascript:;" class="btn btn-white btn-cancelar" data-id="{$videoconsulta_proxima.idvideoconsulta}"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</a>
                                                    <a href="javascript:;"  class="btn btn-default btn_send_mensaje" data-id="{$videoconsulta_proxima.idvideoconsulta}"><i class="icon-doctorplus-chat-add"></i>{"Enviar"|x_translate}</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div  id="row_actions_panels_{$videoconsulta_proxima.idvideoconsulta}" class="row">
                                        <div class="audio-actions-panel">
                                            <div class="chat-motivo-rechazo-holder">
                                                <form name="rechazar_mensaje_{$videoconsulta_proxima.idvideoconsulta}" id="rechazar_mensaje_{$videoconsulta_proxima.idvideoconsulta}" action="{$url}rechazar_videoconsulta_m.do" method="POST" role="form" onsubmit="return false">
                                                    <input type="hidden" name="videoconsulta_idvideoconsulta" value="{$videoconsulta_proxima.idvideoconsulta}"/>
                                                    <div class="chat-msg-holder">
                                                        <select class="form-control select select-primary select-block mbl" name="motivoRechazo_idmotivoRechazo" id="motivoRechazo_idmotivoRechazo_{$videoconsulta_proxima.idvideoconsulta}">
                                                            <option value="">{"Indicar motivo"|x_translate}</option>
                                                            {html_options options=$combo_motivo_rechazo}
                                                        </select>
                                                        <div class="chat-msg-input-holder mensaje-paciente">
                                                            <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}' data-id="{$videoconsulta_proxima.idvideoconsulta}"></textarea>
                                                        </div>
                                                        <div class="text-center  btn-send-mensaje-holder">
                                                            <button  class="btn_send_motivo btn btn-primary" data-id="{$videoconsulta_proxima.idvideoconsulta}" style="border:solid 1px; border-radius:5px">{"Enviar"|x_translate}<i class="icon-doctorplus-right-arrow"></i></button>

                                                        </div>

                                                    </div>
                                                </form>
                                                <hr>
                                            </div>
                                            <div class="audio-action-holder btn-slide-holder">
                                                <a href="javascript:;" data-send="0" data-id="{$videoconsulta_proxima.idvideoconsulta}" {if $videoconsulta_proxima.tomada=="1" &&  $videoconsulta_proxima.tipo_consulta=="0"} data-tomada="1" {/if} class="ce-ca-mdl-rechazo-consulta" style="background: #ff6f6f;"><i class="fas fa-user-times"></i>{"Declinar consulta"|x_translate}</a>
                                                    {if $videoconsulta_proxima.turno_idturno==""}
                                                    <div class="cv-consulta-select">
                                                        <select name="price"   class="form-control select select-primary  cv-consulta-select-trg">
                                                            <option value="">{"Posponer consulta"|x_translate}</option>
                                                            <option data-id="{$videoconsulta_proxima.idvideoconsulta}" value="0">{"Lo atenderé ya mismo"|x_translate}</option>
                                                            {foreach from=$aceptar_consulta_rangos item=rango}
                                                                <option  data-id="{$videoconsulta_proxima.idvideoconsulta}" value="{$rango.format}" data-quarters='{$rango.quarters|@json_encode nofilter}' >
                                                                    {$rango.format}
                                                                </option>
                                                            {/foreach}

                                                        </select>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="vc-registro-lista-disclaimer">

                                            <p class="vc-registro-lista-txt-1">{"¡Hemos notificado al paciente!"|x_translate}</p>
                                            <p class="vc-registro-lista-txt-2"><strong>{"A la hora acordada ingrese al Consultorio Virtual o tome la consulta desde sus registros en -Sala de espera-"|x_translate}</strong></p>

                                            <div class="vc-registro-lista-msg-box">
                                                <h4>{"IMPORTANTE"|x_translate}</h4>
                                                <p class="vc-registro-lista-msg-box-txt-1">{"Recuerde que los pacientes valoran positivamente que ud. los atienda a la hora acordada."|x_translate}</p>
                                                <p class="vc-registro-lista-msg-box-txt-2">{"¡Genere un vínculo perdurable con ellos! Cuide estos detalles."|x_translate}</p>
                                            </div>
                                            <div class="vc-registro-lista-action-box">
                                                <a href="{$url}panel-medico/videoconsulta/" class="btn-default">{"volver"|x_translate}</a>
                                                <a href="{$url}panel-medico/videoconsulta/sala/?id={$videoconsulta_proxima.idvideoconsulta}"  class="btn-default btn_sala" style="display:none;">{"Ingresar al Consultorio Virtual"|x_translate}</a>
                                                <a href="{$url}panel-medico/videoconsulta/sala-espera.html" class="btn-default btn_espera" style="display:none;">{"Ingresar a Sala de espera"|x_translate}</a>

                                            </div>
                                        </div>
                                        {if $videoconsulta_proxima.turno_idturno!=""}
                                            <div class="videoconsulta-turno-disclaimer">
                                                <p>
                                                    {"Las citas de consulta por video no se pueden mover. Rechace la cita eligiendo un motivo si ya no está disponible"|x_translate}                   
                                                </p>
                                            </div>
                                        {/if}
                                    </div>




                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            {/if}

            {*De la segunda videoconsulta a la ultima aparecen en el listado de espera*}
            <!-- Listado de consultas abiertas en espera-->
            {if $listado_videoconsultas_espera.rows && $listado_videoconsultas_espera.rows|@count > 1}
                <div class="okm-container">
                    <div class="okm-row">
                        <h2 class="vc-sala-proximo-paciente"><i class="icon-doctorplus-pacientes"></i> {"Lista de espera"|x_translate}</h2>
                    </div>
                </div>

                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                        {foreach from=$listado_videoconsultas_espera.rows key=key item=videoconsulta_espera name=foo}
                            {if !$smarty.foreach.foo.first}
                                <div class="panel  panel-default">
                                    <div class="panel-heading" role="tab">
                                        <div class="ce-ca-toolbar cv-ca-toolbar">                         
                                            <div class="row">
                                                <div class="colx3">
                                                    <div class="cs-ca-colx3-inner status-paciente">
                                                        <div class="cs-ca-usr-avatar">
                                                            {if $videoconsulta_espera.paciente.image}
                                                                <img src="{$videoconsulta_espera.paciente.image.list}" alt="user"/>
                                                            {else}
                                                                {if $videoconsulta_espera.paciente.animal!=1}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                                {/if}
                                                            {/if}
                                                            <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_espera.paciente.idpaciente}">
                                                                <figure class="status-paciente-consultorio-icon paciente-online" data-idpaciente="{$videoconsulta_espera.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" style="display:none;">
                                                                    <i class="icon-doctorplus-check-thin"></i>
                                                                </figure>
                                                                <figure class="status-paciente-consultorio-icon paciente-offline" data-idpaciente="{$videoconsulta_espera.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" {if $videoconsulta_espera.segundos_diferencia > 0} style="display:none;"{/if} >
                                                                    <i class="fa fa-minus"></i>
                                                                </figure>
                                                            </a>
                                                        </div>
                                                        <div class="cs-ca-usr-data-holder">
                                                            <span>{"Paciente"|x_translate}</span>
                                                            <h2>{$videoconsulta_espera.paciente.nombre} {$videoconsulta_espera.paciente.apellido}</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="colx3 paciente-sala-status">
                                                    <div class="cs-ca-colx3-inner status-container">
                                                        <div class="status-paciente-consultorio paciente-online " data-idpaciente="{$videoconsulta_espera.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" style="display:none;"> 
                                                            {"Disponible en el consultorio"|x_translate}
                                                        </div>
                                                        <div class="status-paciente-consultorio paciente-offline" data-idpaciente="{$videoconsulta_espera.paciente.idpaciente}"  data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" {if $videoconsulta_espera.segundos_diferencia > 0} style="display:none;"{/if}> 
                                                            {"No se encuentra en el consultorio"|x_translate}
                                                        </div>
                                                        <div class="timer-tiempo-transcurrido" data-inicio="{$videoconsulta_espera.inicio_sala}"></div>
                                                    </div>
                                                </div>

                                                <div class="cs-ca-tiempo-respuesta-holder">
                                                    <div class="va-atender-paciente-card-container">
                                                        <div class="va-atender-card ">
                                                            {if $videoconsulta_espera.segundos_diferencia > 0}
                                                                <div class="va-atender-paciente-tiempo front" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}">
                                                                    <div class="cs-ca-tiempo-respuesta-inner">
                                                                        <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_espera.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Horario de atención"|x_translate}:</span>
                                                                        <div class="cs-ca-tiempo-respuesta">
                                                                            <span class="cs-ca-clock-icon"><i class="fa fa-calendar-o"></i></span>
                                                                            <span class="vc-paciente-fecha">{$videoconsulta_espera.fecha_futura_format} {$videoconsulta_espera.inicio_sala|date_format:"%H:%M"}hs</span>
                                                                        </div>
                                                                        {if $videoconsulta_espera.fecha_futura!=1}
                                                                            <div class="cs-ca-tiempo-respuesta timer-wrapper">

                                                                                {if $videoconsulta_espera.segundos_diferencia > 0}
                                                                                    <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span><span data-id="{$videoconsulta_espera.idvideoconsulta}" data-startsec="{$videoconsulta_espera.segundos_diferencia}" data-inicio-sala="{$videoconsulta_espera.inicio_sala}"  class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                                                    {/if}
                                                                            </div>
                                                                        {/if}
                                                                    </div>
                                                                </div>
                                                            {/if}

                                                            <div class="va-atender-paciente-btn back" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" style="transform:none; {if $videoconsulta_espera.segundos_diferencia > 0} display:none;{/if}">
                                                                <a  href="{$url}panel-medico/videoconsulta/sala/?id={$videoconsulta_espera.idvideoconsulta}" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" class="btn-default pasar_consultorio"><i class="icon-doctorplus-video-cam"></i> {"atender al paciente"|x_translate}</a>	
                                                            </div>

                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_espera.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_espera.idvideoconsulta}">
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-numero-consulta-holder">
                                                        <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                        <span class="cs-ca-numero-consulta">Nº {$videoconsulta_espera.numeroVideoConsulta}</span>
                                                    </div>
                                                </div>
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-numero-consulta-holder">
                                                        <span class="cs-ca-numero-consulta-motivo-label">{"Motivo"|x_translate}:</span>
                                                        <span class="cs-ca-numero-consulta">{$videoconsulta_espera.motivoVideoConsulta}</span>
                                                    </div>
                                                </div>
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-date-tools">
                                                        <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                        <span class="cs-ca-fecha">{$videoconsulta_espera.fecha_inicio_format}</span>
                                                        <div class="cs-ca-date-tools-holder">
                                                            <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="collapse-{$videoconsulta_espera.idvideoconsulta}" data-id="{$videoconsulta_espera.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_espera.idvideoconsulta}">
                                        <div class="panel-body">
                                            <div class="cs-ca-chat-holder">


                                                {foreach from=$videoconsulta_espera.mensajes item=mensaje}


                                                    {if $mensaje.emisor == "p"}
                                                        <div class="row chat-row">
                                                            <div class="chat-line-holder pce-dr-chat">
                                                                <div class="chat-image-avatar-xn">
                                                                    {if $videoconsulta_espera.paciente_titular}
                                                                        <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                            {if $videoconsulta_espera.paciente_titular.image.perfil != ""}
                                                                                <img src="{$videoconsulta_espera.paciente_titular.image.perfil}" alt="user"/>
                                                                            {else}
                                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                            {/if}
                                                                        </div>
                                                                    {/if}
                                                                    <div class="chat-image-avatar-xn-row">
                                                                        {if $videoconsulta_espera.paciente.image.perfil != ""}
                                                                            <img src="{$videoconsulta_espera.paciente.image.perfil}" alt="user"/>
                                                                        {else}
                                                                            {if $videoconsulta_espera.paciente.animal != 1}
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
                                                                        {*archivos videoconsulta*}
                                                                        {if $mensaje.idmensajeVideoConsulta!=""}
                                                                            <div class="chat-content-attach">
                                                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                                    <i class="fui-clip"></i>
                                                                                    &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                                </a>
                                                                            </div>
                                                                        {/if}
                                                                        {*archivos turno*}
                                                                        {if $mensaje.idmensajeTurno!=""}
                                                                            <div class="chat-content-attach">
                                                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeTurno}" data-target="#ver-archivo">
                                                                                    <i class="fui-clip"></i>
                                                                                    &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                                </a>
                                                                            </div>
                                                                        {/if}

                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    {else}
                                                        <div class="row chat-row">
                                                            <div class="chat-line-holder pce-paciente-chat">
                                                                <div class="chat-content">
                                                                    <figure>
                                                                        <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                        <p>{$mensaje.mensaje} </p>
                                                                        <span class="chat-content-arrow"></span>
                                                                    </figure>
                                                                    {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                        <div class="chat-content-attach">
                                                                            <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                                <i class="fui-clip"></i>
                                                                                &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                            </a>
                                                                        </div>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    {/if}
                                                {foreachelse}
                                                    <div class="row chat-row chat-date-divider">
                                                        <span class="chat-date"><small>{"No se registraron mensajes"|x_translate}</small></span>
                                                        <div class="chat-line-divider"></div>
                                                    </div>
                                                {/foreach}
                                                {if $videoconsulta_espera.mensajes|@count>0 }
                                                    <div class="row text-center">
                                                        <a href="javascript:;" class="btn btn-secondary btn_responder_mensaje" data-id="{$videoconsulta_espera.idvideoconsulta}"><i class="icon-doctorplus-chat-add"></i>{"Enviar respuesta"|x_translate}</a>
                                                    </div>
                                                {/if}
                                            </div>
                                            {*contenedor escribir mensaje*}
                                            <!--  Form mensaje-->
                                            <div class="row enviar-mesaje-container" data-id="{$videoconsulta_espera.idvideoconsulta}" style="display:none;">
                                                <div class="audio-actions-panel">
                                                    <!--slide-->
                                                    <div class="audio-reccord-holder">

                                                        <form  id="send_mensaje_{$videoconsulta_espera.idvideoconsulta}">
                                                            <input type="hidden" name="idvideoconsulta" value="{$videoconsulta_espera.idvideoconsulta}"/>
                                                            <input type="hidden" name="repuesta_desde_consulta" value="1"/>
                                                            <div class="audio-reccord-holder">
                                                                <div class="chat-msg-holder">
                                                                    <div class="chat-msg-input-holder">
                                                                        <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Escriba sus horarios disponibles para realizar la videoconsulta"|x_translate}'></textarea>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </form>

                                                        <div class="text-center  btn-send-mensaje-holder">
                                                            <a href="javascript:;" class="btn btn-white btn-cancelar" data-id="{$videoconsulta_espera.idvideoconsulta}"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</a>
                                                            <a href="javascript:;"  class="btn btn-default btn_send_mensaje" data-id="{$videoconsulta_espera.idvideoconsulta}"><i class="icon-doctorplus-chat-add"></i>{"Enviar"|x_translate}</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div  id="row_actions_panels_{$videoconsulta_espera.idvideoconsulta}" class="row">
                                                <div class="audio-actions-panel">
                                                    <div class="chat-motivo-rechazo-holder">
                                                        <form name="rechazar_mensaje_{$videoconsulta_espera.idvideoconsulta}" id="rechazar_mensaje_{$videoconsulta_espera.idvideoconsulta}" action="{$url}rechazar_videoconsulta_m.do" method="POST" role="form" onsubmit="return false">
                                                            <input type="hidden" name="videoconsulta_idvideoconsulta" value="{$videoconsulta_espera.idvideoconsulta}"/>
                                                            <div class="chat-msg-holder">
                                                                <select class="form-control select select-primary select-block mbl" name="motivoRechazo_idmotivoRechazo" id="motivoRechazo_idmotivoRechazo_{$videoconsulta_espera.idvideoconsulta}">
                                                                    <option value="">{"Indicar motivo"|x_translate}</option>
                                                                    {html_options options=$combo_motivo_rechazo}
                                                                </select>
                                                                <div class="chat-msg-input-holder mensaje-paciente">
                                                                    <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}' data-id="{$videoconsulta_espera.idvideoconsulta}"></textarea>
                                                                </div>
                                                                <div class="text-center  btn-send-mensaje-holder">
                                                                    <button  class="btn_send_motivo btn btn-primary" data-id="{$videoconsulta_espera.idvideoconsulta}" style="border:solid 1px; border-radius:5px">{"Enviar"|x_translate}<i class="icon-doctorplus-right-arrow"></i></button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                        <hr>
                                                    </div>
                                                    <div class="audio-action-holder btn-slide-holder">
                                                        <a href="javascript:;" data-send="0" data-id="{$videoconsulta_espera.idvideoconsulta}" {if $videoconsulta_espera.tomada=="1" &&  $videoconsulta_espera.tipo_consulta=="0"} data-tomada="1" {/if} class="ce-ca-mdl-rechazo-consulta" style="background: #ff6f6f;"><i class="fas fa-user-times"></i>{"Declinar consulta"|x_translate}</a>
                                                            {if $videoconsulta_espera.turno_idturno==""}
                                                            <div class="cv-consulta-select">
                                                                <select name="price"   class="form-control select select-primary  cv-consulta-select-trg">
                                                                    <option value="">{"Posponer consulta"|x_translate}</option>
                                                                    <option data-id="{$videoconsulta_espera.idvideoconsulta}" value="0">{"Lo atenderé ya mismo"|x_translate}</option>
                                                                    {foreach from=$aceptar_consulta_rangos item=rango}
                                                                        <option  data-id="{$videoconsulta_espera.idvideoconsulta}" value="{$rango.format}" data-quarters='{$rango.quarters|@json_encode nofilter}' >
                                                                            {$rango.format}
                                                                        </option>
                                                                    {/foreach}

                                                                </select>
                                                            </div>
                                                        {/if}
                                                    </div>
                                                </div>
                                                <div class="vc-registro-lista-disclaimer">

                                                    <p class="vc-registro-lista-txt-1">{"¡Hemos notificado al paciente!"|x_translate}</p>
                                                    <p class="vc-registro-lista-txt-2"><strong>{"A la hora acordada ingrese al Consultorio Virtual o tome la consulta desde sus registros en -Sala de espera-"|x_translate}</strong></p>

                                                    <div class="vc-registro-lista-msg-box">
                                                        <h4>{"IMPORTANTE"|x_translate}</h4>
                                                        <p class="vc-registro-lista-msg-box-txt-1">{"Recuerde que los pacientes valoran positivamente que ud. los atienda a la hora acordada."|x_translate}</p>
                                                        <p class="vc-registro-lista-msg-box-txt-2">{"¡Genere un vínculo perdurable con ellos! Cuide estos detalles."|x_translate}</p>
                                                    </div>
                                                    <div class="vc-registro-lista-action-box">
                                                        <a href="{$url}panel-medico/videoconsulta/" class="btn-default">{"volver"|x_translate}</a>
                                                        <a href="{$url}panel-medico/videoconsulta/sala/?id={$videoconsulta_espera.idvideoconsulta}"  class="btn-default btn_sala" style="display:none;">{"Ingresar al Consultorio Virtual"|x_translate}</a>
                                                        <a href="{$url}panel-medico/videoconsulta/sala-espera.html" class="btn-default btn_espera" style="display:none;">{"Ingresar a Sala de espera"|x_translate}</a>

                                                    </div>
                                                </div>
                                                {if $videoconsulta_espera.turno_idturno!=""}
                                                    <div class="videoconsulta-turno-disclaimer">
                                                        <p>
                                                            {"Las citas de consulta por video no se pueden mover. Rechace la cita eligiendo un motivo si ya no está disponible"|x_translate}                   
                                                        </p>
                                                    </div>
                                                {/if}
                                            </div>



                                        </div>
                                    </div>
                                </div>
                            {/if}
                        {/foreach}

                    </div>

                </div>



                <div class="row">
                    <div class="col-xs-12">
                        {if $listado_videoconsultas_espera.rows && $listado_videoconsultas_espera.rows|@count > 1}
                            <div class="paginas">
                                {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_sala_espera" container_id="div_videoconsulta_espera"}
                            </div>
                        {/if}
                    </div>
                </div>
            {/if}
        </section>


        <!--	ALERTAS - Modal consulta vencida	-->
        <div id="pasar_consultorio_consulta_vencida" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">{"¡Acceso al consultorio virtual no habilitado!"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            {"Han pasado los 5 minutos de espera desde el horario de inicio de su Video Consulta."|x_translate}
                        </p>
                        <div class="modal-perfil-completo-action-holder">
                            <button onclick="window.location.href = '{$url}panel-medico/videoconsulta/vencidas.html'"><i class="far fa-calendar-times"></i> {"videoconsultas vencidas"|x_translate}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>	
        <!-- Modal Horarios atender Video Consulta -->
        <div id="modal-seleccionar-horario-consulta" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" data-load="no" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button"   class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">{"Seleccione el horario de inicio de la Video Consulta"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            {"La solicitud se coloca en la sala de espera virtual y se notifica al paciente"|x_translate}
                        </p>
                        <div class="modal-perfil-completo-action-holder">
                            <button class="btn select-inicio-sala" data-slot="0" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="15" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="30" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="45" data-time=""></button>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        {literal}

            <script>
                var flipCard = function (e) {
                    e.velocity({
                        rotateX: "180deg",
                        delay: 500,
                        duration: 2000
                    });
                };
                $(document).ready(function (e) {

                    renderUI2();
                    /*  $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/

                    /*
                     * Obtener estado de pacientes consultorio virutal*
                     * recorremos todos los pacientes que figuaran ofline - consulta iniciada- emitimos peticion status
                     */
                    $(".status-paciente-consultorio.paciente-offline:visible").each(function (idx, elem) {
                        socket.emit('get_status_ingreso_consultorio', {tipo_usuario: 'medico', idpaciente: $(elem).data("idpaciente"), idvideoconsulta: $(elem).data("idvideoconsulta")});
                    });

                    //al pasar al consultorio verificamos que siga disponible
                    $(".pasar_consultorio").click(function (e) {
                        $element = $(this);
                        var idvideoconsulta = $(this).data("idvideoconsulta");
                        if (parseInt(idvideoconsulta) > 0) {
                            e.stopPropagation();
                            x_doAjaxCall('POST',
                                    BASE_PATH + "acceder_consultorio_virtual_m.do",
                                    "idvideoconsulta=" + idvideoconsulta,
                                    function (data) {
                                        if (data.result) {

                                        } else {
                                            e.preventDefault();
                                            $("#pasar_consultorio_consulta_vencida").modal("show");
                                            $element.hide();
                                        }
                                    },
                                    null,
                                    true
                                    );
                        } else {
                            e.preventDefault();
                        }



                    });


                    //redireccion al perfil salud del paciente
                    $("#div_videoconsulta_espera .change_miembro").click(function () {

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

                    // timers
                    /*Date.prototype.addSeconds = function (h) {
                     this.setSeconds(this.getSeconds() + h);
                     return this;
                     };*/

                    //seteamos cronometro de tiempo restante
                    $.each($('.timer-1'), function (idx, elem) {
                        /* $this = $(this);
                         $start_sec = $this.data("startsec");
                         
                         
                         var date1 = new Date().addSeconds($start_sec) / 1000;
                         
                         
                         if (parseInt($start_sec) > 0) {
                         $this.countid({
                         clock: true,
                         dateTime: date1,
                         dateTplRemaining: "%H:%M:%S",
                         dateTplElapsed: '',
                         complete: function (el) {
                         
                         var idvideoconsulta = el.data("id");
                         
                         //ocultamos el timer
                         $(".va-atender-paciente-tiempo.front[data-idvideoconsulta=" + idvideoconsulta + "]").slideUp();
                         //mostramos el boton ingreso a la sala
                         $(".va-atender-paciente-btn.back[data-idvideoconsulta=" + idvideoconsulta + "]").slideDown();
                         $(".paciente-offline[data-idvideoconsulta=" + idvideoconsulta + "]").slideDown();
                         
                         return;
                         }
                         });
                         }*/

                        // seteamos el tiempo restante para el inicio de la VC
                        if ($(elem).data("inicio-sala") !== "") {
                            var idvideoconsulta = $(elem).data("id");
                            var [date_part, time_part] = $(elem).data("inicio-sala").split(" ");
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
                                    $(elem).text("");

                                    //ocultamos el timer
                                    $(".va-atender-paciente-tiempo.front[data-idvideoconsulta=" + idvideoconsulta + "]").slideUp();
                                    //mostramos el boton ingreso a la sala
                                    $(".va-atender-paciente-btn.back[data-idvideoconsulta=" + idvideoconsulta + "]").slideDown();
                                    $(".paciente-offline[data-idvideoconsulta=" + idvideoconsulta + "]").slideDown();
                                }
                            }, 1000);
                        }
                    });


                    //accion de aceptar la Video Consulta e informar al paciente que se habilita la sala
                    $('.cv-consulta-select-trg').change(function (e) {
                        var idvideoconsulta = parseInt($(this).find("option:selected").data("id"));
                        var inicio = $(this).find("option:selected").val();
                        var inicio_txt = $(this).find("option:selected").text();

                        $element = $(this);
                        $lista_disclaimer = $(".vc-registro-lista-disclaimer");

                        if (idvideoconsulta > 0 && inicio != "") {
                            //resetamos los botones de horarios
                            $(".select-inicio-sala").attr("disabled", false);
                            $(".select-inicio-sala").removeClass("disabled");
                            $(".select-inicio-sala").data("idvideoconsulta", idvideoconsulta);
                            //si no se responde inmediatamentes ->mostramos modal con horarios
                            if (inicio != 0) {
                                var quarters = $(this).find("option:selected").data("quarters");
                                //seteamos los textos de horarios en los botones
                                $(".select-inicio-sala[data-slot=0]").text(quarters["label-0"]);
                                $(".select-inicio-sala[data-slot=15]").text(quarters["label-15"]);
                                $(".select-inicio-sala[data-slot=30]").text(quarters["label-30"]);
                                $(".select-inicio-sala[data-slot=45]").text(quarters["label-45"]);
                                //seteamos los valores de horario en los botones 
                                $(".select-inicio-sala[data-slot=0]").data("time", quarters["time-0"]);
                                $(".select-inicio-sala[data-slot=15]").data("time", quarters["time-15"]);
                                $(".select-inicio-sala[data-slot=30]").data("time", quarters["time-30"]);
                                $(".select-inicio-sala[data-slot=45]").data("time", quarters["time-45"]);

                                //deshabilitamos los horarios no disponibles
                                if (!quarters["min-0"]) {
                                    $(".select-inicio-sala[data-slot=0]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=0]").addClass("disabled");
                                }
                                if (!quarters["min-15"]) {
                                    $(".select-inicio-sala[data-slot=15]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=15]").addClass("disabled");
                                }
                                if (!quarters["min-30"]) {
                                    $(".select-inicio-sala[data-slot=30]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=30]").addClass("disabled");
                                }
                                if (!quarters["min-45"]) {
                                    $(".select-inicio-sala[data-slot=45]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=45]").addClass("disabled");
                                }




                                //mostramos el modal de horarios
                                $("#modal-seleccionar-horario-consulta").modal("show");

                            } else {
                                jConfirm({
                                    title: x_translate("Aceptar consulta"),
                                    text: x_translate('Desea aceptar la Video Consulta en este momento?'),
                                    confirm: function () {
                                        $("#div_videoconsulta_espera").spin("large");
                                        x_doAjaxCall(
                                                'POST',
                                                BASE_PATH + 'posponer_videoconsulta.do',
                                                "idvideoconsulta=" + idvideoconsulta + "&inicio=" + inicio,
                                                function (data) {
                                                    $("#div_videoconsulta_espera").spin(false);

                                                    if (data.result) {
                                                        //$element.parent().parent().slideUp();
                                                        // $lista_disclaimer.slideDown();
                                                        // scrollToEl($lista_disclaimer);
                                                        window.location.href = "";
                                                    } else {
                                                        x_alert(data.msg);
                                                    }
                                                }
                                        );
                                    },
                                    cancel: function () {

                                    },
                                    confirmButton: x_translate("Si"),
                                    cancelButton: x_translate("No")
                                });
                            }
                        } else {
                            return false;
                        }

                    });

                    /*Al cerrar modal de horario limpiamos la seleccion*/
                    $('#modal-seleccionar-horario-consulta').on('hidden.bs.modal', function () {
                        $(".cv-consulta-select-trg").val(null).trigger('change');

                    });
                    /*Al mostrar modal ocultamos horarios pasados*/
                    $('#modal-seleccionar-horario-consulta').on('show.bs.modal', function () {
                        $("#modal-seleccionar-horario-consulta .select-inicio-sala").each(function (idx, elem) {
                            //si ya pasó, añadimos disabled
                            if (new Date() > new Date($(elem).data("time"))) {
                                $(elem).addClass("disabled");
                                $(elem).prop("disabled", true);
                            }
                        });

                    });
                    //accion de aceptar la Video Consulta en un horario en particular
                    $(".select-inicio-sala").click(function () {
                        var idvideoconsulta = parseInt($(this).data("idvideoconsulta"));
                        var $lista_disclaimer = $(".vc-registro-lista-disclaimer");
                        var inicio = $(this).data("time");
                        var inicio_format = $(this).text();
                        jConfirm({
                            title: x_translate("Aceptar consulta"),
                            text: x_translate('Desea aceptar la Video Consulta a las') + "&nbsp;" + inicio_format + "hs?",
                            confirm: function () {
                                $("#modal-seleccionar-horario-consulta").modal("hide");
                                $("#div_videoconsulta_espera").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'posponer_videoconsulta.do',
                                        "idvideoconsulta=" + idvideoconsulta + "&inicio=" + inicio,
                                        function (data) {
                                            $("#div_videoconsulta_espera").spin(false);
                                            x_alert(data.msg);
                                            if (data.result) {
                                                window.location.href = "";
                                            }
                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    });

                    //boton rechazar videoconsulta - seleccionar motivo
                    $(".btn_send_motivo").click(function () {
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                            $("#rechazar_mensaje_" + id + " .select2-choice").css("border-color", "#a9a6a6");
                            if ($("#motivoRechazo_idmotivoRechazo_" + id).val() != "") {
                                $('#div_videoconsulta_espera').spin("large");
                                x_sendForm(
                                        $('#rechazar_mensaje_' + id),
                                        true,
                                        function (data) {
                                            $('#div_videoconsulta_espera').spin(false);
                                            if (data.result) {
                                                x_alert(data.msg, function () {
                                                    recargar(BASE_PATH + "panel-medico/videoconsulta/sala-espera.html");
                                                });
                                            } else {
                                                x_alert(data.msg);
                                            }
                                        }
                                );
                            } else {
                                $("#rechazar_mensaje_" + id + " .select2-choice").css("border-color", "red");
                                x_alert(x_translate("Seleccione el motivo de rechazo de la consulta"));
                                return false;

                            }
                        }
                    });

                    //boton rechazar consulta - desplega combo box motivo
                    $('.ce-ca-mdl-rechazo-consulta').on('click', function (e) {
                        e.preventDefault();
                        var $this = $(this);
                        $this.parent().siblings('.audio-reccord-holder').hide();
                        $this.parent().siblings('.chat-motivo-rechazo-holder').toggleClass('show');
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

                    /*Reloj de tiempo transucrrido*/
                    function relojTiempoTranscurrido() {
                        $.each($('.timer-tiempo-transcurrido'), function (idx, elem) {

                            if ($(elem).data("inicio") != "") {
                                var date_inicio = new Date($(elem).data("inicio"));
                                miliseg_pasados = new Date() - date_inicio.getTime();
                                min_pasados = parseInt(miliseg_pasados / 1000 / 60);
                                if (min_pasados > 0) {
                                    $(elem).html(min_pasados + "&nbsp;" + x_translate("min desde el inicio!"));
                                }


                            }

                        });
                    }
                    relojTiempoTranscurrido();
                    setInterval(function () {
                        relojTiempoTranscurrido();

                    }, 60000);

                    /**
                     * proponer otro turno - mensaje
                     */
                    //listener desplegar form enviar mensaje
                    $(".btn_responder_mensaje").click(function () {
                        var id = $(this).data("id");

                        $(".btn_responder_mensaje[data-id=" + id + "]").hide();
                        $("#row_actions_panels_" + id).hide();
                        $(".enviar-mesaje-container[data-id=" + id + "]").slideDown();
                    });
                    //listener ocultar form enviar mensaje
                    $(".btn-cancelar").click(function () {
                        var id = $(this).data("id");
                        $(".enviar-mesaje-container[data-id=" + id + "]").hide();
                        $(".btn_responder_mensaje[data-id=" + id + "]").show();
                        $("#row_actions_panels_" + id).slideDown();

                    });
                    //enviar mensaje
                    $(".btn_send_mensaje").click(function (e) {

                        e.preventDefault();
                        var id = $(this).data("id");
                        console.log("data-id" + id);
                        if ($("#send_mensaje_" + id + " textarea").val() === "") { // no enviar mensajes sin texto 
                            x_alert(x_translate("Ingrese texto del mensaje"));
                            return false;
                        }
                        $("body").spin();
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'send_mensaje_videoconsulta_m.do',
                                $('#send_mensaje_' + id).serialize(),
                                function (data) {
                                    $("body").spin(false);

                                    if (data.result) {
                                        $(".enviar-mesaje-container[data-id=" + id + "]").hide();
                                        $("#row_actions_panels_" + id).slideDown();
                                        $("#send_mensaje_" + id + " textarea").val("");
                                        x_alert(data.msg, recargar);
                                    } else {
                                        x_alert(data.msg);
                                    }
                                });

                    });
                });
            </script>
        {/literal}
    {else}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-video-sheet"></i></figure>

                        </div>
                        <span>{"SALA DE ESPERA"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-video-sheet"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas en Sala de Espera"|x_translate}</p>
                </div>
            </section>
        </div>

    {/if}

</div>
