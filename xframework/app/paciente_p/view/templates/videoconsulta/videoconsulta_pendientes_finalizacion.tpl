<div id="div_videoconsulta_pendientes_finalizacion" class="relative">

    {if $listado_videoconsultas_pendientes_finalizacion.rows && $listado_videoconsultas_pendientes_finalizacion.rows|@count > 0}
        <div class="cs-nc-section-holder">	
            <section class="vc-interrumpidas">
                <div class="okm-container">
                    <div class="vc-interrumpidas-header">	
                        <i class="icon-doctorplus-alert-round"></i>
                        <h1>{"Video Consultas pendientes de finalización"|x_translate}</h1>
                    </div>
                    <p class="vc-interrumpidas-aviso-importante paciente">
                        {"Si por inconvenientes técnicos se le ha interrumpido la transmisión de su Video Consulta aguarde a que le notifiquemos la decisión del profesional. ¡Esté atento!"|x_translate}
                    </p>
                </div>


                <div class="okm-container">
                    <div class="cs-ca-consultas-holder">
                        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                            {foreach from=$listado_videoconsultas_pendientes_finalizacion.rows key=key item=videoconsulta_pendiente_finalizacion}
                                <div class="panel  panel-default">
                                    <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                        <div class="ce-ca-toolbar cv-ca-toolbar">                         
                                            <div class="row">

                                                {*header medico consulta*}
                                                {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$videoconsulta_pendiente_finalizacion} 

                                                {*header tipo consulta*}
                                                {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$videoconsulta_pendiente_finalizacion} 

                                                <div class="cs-ca-tiempo-respuesta-holder">
                                                    {if  $videoconsulta_pendiente_finalizacion.cant_llamadas_perdidas>0}
                                                        <a href="javascript:;" class="vc-llamadas-perdidas-btn">
                                                            <div class="vc-llamadas-perdidas-box">
                                                                <figure class="vc-llamadas-perdidas-icon-box">
                                                                    <i class="icon-doctorplus-cam-rss"></i>
                                                                    <span class="vc-llamadas-perdidas-icon-line"></span>
                                                                </figure>
                                                                <p>
                                                                    {$videoconsulta_pendiente_finalizacion.cant_llamadas_perdidas} LLAMADA{if  $videoconsulta_pendiente_finalizacion.cant_llamadas_perdidas>1}S{/if} PERDIDA{if  $videoconsulta_pendiente_finalizacion.cant_llamadas_perdidas>1}S{/if}
                                                                </p>
                                                            </div>
                                                        </a>
                                                    {/if}
                                                </div>
                                            </div>
                                            <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}">
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-numero-consulta-holder">
                                                        <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                        <span class="cs-ca-numero-consulta">Nº {$videoconsulta_pendiente_finalizacion.numeroVideoConsulta}</span>
                                                    </div>
                                                </div>
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-numero-consulta-holder">
                                                        <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                        <span class="cs-ca-numero-consulta">{$videoconsulta_pendiente_finalizacion.motivoVideoConsulta}</span>
                                                    </div>
                                                </div>
                                                <div class="pce-colx3">
                                                    <div class="cs-ca-date-tools">
                                                        <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                        <span class="cs-ca-fecha">{$videoconsulta_pendiente_finalizacion.fecha_inicio_format}</span>
                                                        <div class="cs-ca-date-tools-holder">
                                                            <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="collapse-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" data-id="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}">
                                        <div class="panel-body">
                                            <div class="cs-ca-chat-holder">


                                                {foreach from=$videoconsulta_pendiente_finalizacion.mensajes item=mensaje}

                                                    {if $mensaje.emisor == "dp"}
                                                        <div class="row chat-row">
                                                            <div class="chat-line-holder pce-dr-chat">
                                                                {if $videoconsulta_pendiente_finalizacion.medico.imagen.list != ""}
                                                                    <img src="{$videoconsulta_pendiente_finalizacion.medico.imagen.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                                <div class="chat-content">
                                                                    <figure>
                                                                        <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                        <div class="vc-llamada-perdida">
                                                                            <figure>
                                                                                <span></span>
                                                                                <i class="icon-doctorplus-cam-rss"></i>
                                                                            </figure>
                                                                            <span>{"Llamada perdida"|x_translate}</span>
                                                                        </div>
                                                                        {*<p class="chat-content-rechazada">{$mensaje.mensaje} </p>*}
                                                                        <span class="chat-content-arrow"></span>
                                                                    </figure>                                                       
                                                                </div>
                                                            </div>
                                                        </div>
                                                    {else}
                                                        {if $mensaje.emisor == "p"}
                                                            <div class="row chat-row">
                                                                <div class="chat-line-holder pce-paciente-chat">
                                                                    <div class="chat-image-avatar-xn pcer-chat-image-right">
                                                                        {if $videoconsulta_pendiente_finalizacion.paciente_titular}
                                                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                                {if $videoconsulta_pendiente_finalizacion.paciente_titular.image.perfil != ""}
                                                                                    <img src="{$videoconsulta_pendiente_finalizacion.paciente_titular.image.perfil}" alt="user"/>
                                                                                {else}
                                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                                {/if}
                                                                            </div>
                                                                        {/if}
                                                                        <div class="chat-image-avatar-xn-row">
                                                                            {if $videoconsulta_pendiente_finalizacion.paciente.image.perfil != ""}
                                                                                <img src="{$videoconsulta_pendiente_finalizacion.paciente.image.perfil}" alt="user"/>
                                                                            {else}
                                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                            {/if}
                                                                            <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                                        </div>
                                                                    </div>

                                                                    <div class="chat-content pcer-chat-right">
                                                                        <figure>
                                                                            <div class="chat-content-date">
                                                                                {if $videoconsulta_pendiente_finalizacion.paciente_titular.relacion != ""}
                                                                                    <span>{$videoconsulta_pendiente_finalizacion.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                                                {/if}
                                                                                {$mensaje.fecha_format} hs
                                                                            </div>
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
                                                        {else}
                                                            <div class="row chat-row">
                                                                <div class="chat-line-holder pce-dr-chat">
                                                                    {if $videoconsulta_pendiente_finalizacion.medico.imagen.list != ""}
                                                                        <img src="{$videoconsulta_pendiente_finalizacion.medico.imagen.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
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
                                                    {/if}

                                                {/foreach}

                                            </div>

                                            <div  id="row_actions_panels_{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="row">
                                                <div class="audio-actions-panel">

                                                    <div class="audio-reccord-holder-chat">

                                                    </div>

                                                    <div class="audio-action-holder btn-slide-holder">
                                                        <a href="javascript:;" data-id="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="btn-light ce-ca-cancelar-consulta btn_cancelar_videoconsulta"><i class="icon-doctorplus-cruz"></i>{"Cancelar videoconsulta"|x_translate}</a>                                                 
                                                    </div>
                                                </div>

                                            </div>

                                        </div>
                                    </div>
                                </div>
                            {/foreach}

                        </div>

                    </div>
                </div>



            </section>
        </div>

        {literal}
            <script>
                $(document).ready(function (e) {

                    /* $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/
                    renderUI2("div_videoconsulta_pendientes_finalizacion");


                    //accion de cancer la Video Consulta y acreditar el dinero al medico. la consulta pasa a estaado vencido

                    $('.btn_cancelar_videoconsulta').click(function (e) {
                        var idvideoconsulta = parseInt($(this).data("id"));


                        if (idvideoconsulta > 0) {


                            jConfirm({
                                title: x_translate("Cancelar videoconsulta"),
                                text: x_translate("Desea cancelar la Video Consulta en este momento?"),
                                confirm: function () {
                                    $("#div_videoconsulta_pendientes_finalizacion").spin("large");
                                    x_doAjaxCall(
                                            'POST',
                                            BASE_PATH + 'cancelar_videoconsulta_pendiente_finalizacion.do',
                                            "idvideoconsulta=" + idvideoconsulta,
                                            function (data) {
                                                $("#div_videoconsulta_pendientes_finalizacion").spin(false);

                                                if (data.result) {
                                                    x_alert(data.msg, recargar);
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
                        } else {
                            return false;
                        }

                    });

                });
            </script>
        {/literal}


    {/if}

</div>
