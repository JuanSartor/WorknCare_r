{if $listado_videoconsultas_pendientes_finalizacion.rows && $listado_videoconsultas_pendientes_finalizacion.rows|@count > 0}

    <div class="okm-row">
        <div class="cs-ca-consulta-pendiente-disclaimer">
            <i id="icon_alert_pendientes" class="icon-doctorplus-alert-round" ></i>
            <h3>{"Video Consultas pendientes de registro médico"|x_translate}</h3>
            <p>{"Para que el importe abonado por la consulta sea acreditado en su cuenta debe dejar registro médico de sus conclusiones."|x_translate}</p>
        </div>
    </div>
    <div class="cs-ca-consultas-holder">

        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            {foreach from=$listado_videoconsultas_pendientes_finalizacion.rows key=key item=videoconsulta_pendiente_finalizacion}
                <div id="consulta-finalizada-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="panel panel-default">
                    <div class="panel-heading" role="tab">
                        <div class="ce-ca-toolbar">                         
                            <div class="row consultas-finalizadas video-consulta with-parent">
                                <div class="colx3">
                                    <div class="cs-ca-colx3-inner">
                                        <div class="cs-ca-usr-avatar">
                                            {if $videoconsulta_pendiente_finalizacion.paciente.image}
                                                <img src="{$videoconsulta_pendiente_finalizacion.paciente.image.list}" alt="user"/>
                                            {else}
                                                {if $videoconsulta_pendiente_finalizacion.paciente.animal!=1}
                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                {/if}
                                            {/if}
                                            <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_pendiente_finalizacion.paciente.idpaciente}">
                                                <figure>
                                                    <i class="icon-doctorplus-pharmaceutics"></i>
                                                </figure>
                                            </a>
                                        </div>
                                        <div class="cs-ca-usr-data-holder">
                                            <span>{"Paciente"|x_translate}</span>
                                            <h2>{$videoconsulta_pendiente_finalizacion.paciente.nombre} {$videoconsulta_pendiente_finalizacion.paciente.apellido}</h2>
                                        </div>
                                    </div>
                                </div>


                                <div class="colx3 reembolsar-importe-vc">
                                    <div class="cs-ca-colx3-inner vc-interrumpidas-botonera">
                                        <a href="javascript:;"  data-id="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="reembolsar-importe-rtg">
                                            <figure><i class="icon-doctorplus-refund"></i></figure>
                                            <div>{"Reembolsar importe"|x_translate}<br>
                                                <span>{"de la consulta"|x_translate}</span></div>
                                        </a>
                                    </div>

                                    {*se cambio el paciente titular por el boton de reembolsar*}
                                    {* <div class="cs-ca-colx3-inner">
                                    {if $videoconsulta_pendiente_finalizacion.paciente_titular}

                                    <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                    {if $videoconsulta_pendiente_finalizacion.paciente_titular.image}
                                    <img src="{$videoconsulta_pendiente_finalizacion.paciente_titular.image.perfil}" alt="user"/>
                                    {else}
                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                    {/if}
                                    </div>
                                    <div class="cs-ca-usr-data-holder">
                                    {if $videoconsulta_pendiente_finalizacion.paciente_titular.relacion != ""}
                                    <span>{$videoconsulta_pendiente_finalizacion.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                    {else}
                                    <span>{"propietario"|x_translate}</span>
                                    {/if}
                                    <h2>{$videoconsulta_pendiente_finalizacion.paciente_titular.nombre} {$videoconsulta_pendiente_finalizacion.paciente_titular.apellido}</h2>
                                    </div>
                                    {/if}
                                    </div>
                                    *}
                                </div>
                                <div class="ca-ce-finalizadas-col">

                                    <a class="btn-escribir-conclusiones" data-idpaciente="{$videoconsulta_pendiente_finalizacion.paciente_idpaciente}" data-idvideoconsulta="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}"  data-nombre="{$videoconsulta_pendiente_finalizacion.paciente.nombre|str2seo}" data-apellido="{$videoconsulta_pendiente_finalizacion.paciente.apellido|str2seo}" href="javascript:;">
                                        <figure>
                                            <i class="icon-doctorplus-sheet-edit"></i>
                                            <span class="subcircle"></span>
                                        </figure>
                                        <span>{"Escribir conclusiones"|x_translate}</span>
                                    </a>
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
                                        <span class="cs-ca-numero-consulta-date-label">{"Finalizada"|x_translate}</span>
                                        <span class="cs-ca-fecha">{$videoconsulta_pendiente_finalizacion.fecha_fin_format}</span>
                                        <div class="cs-ca-date-tools-holder">
                                            <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="collapse-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" data-id="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" aria-labelledby="heading-{$videoconsulta_pendiente_finalizacion.idvideoconsulta}">

                        <div class="panel-body">
                            <div class="cs-ca-chat-holder">

                                {foreach from=$videoconsulta_pendiente_finalizacion.mensajes item=mensaje}

                                    {if $mensaje.emisor == "p"}
                                        <div class="row chat-row">
                                            <div class="chat-line-holder pce-dr-chat">
                                                <div class="chat-image-avatar-xn">
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
                                                            {if $videoconsulta_pendiente_finalizacion.paciente.animal != 1}
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
                                            <div class="chat-line-holder pce-paciente-chat">
                                                <div class="chat-image-avatar-xn pcer-chat-image-right">



                                                    <div class="chat-image-avatar-xn-row">
                                                        {if $videoconsulta_pendiente_finalizacion.medico.image.perfil != ""}
                                                            <img src="{$videoconsulta_pendiente_finalizacion.medico.image.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}

                                                    </div>
                                                </div>
                                                <div class="chat-content pcer-chat-right">
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

                                {/foreach}

                            </div>


                            <div class="row">
                                <div class="audio-actions-panel">
                                    <div class="audio-action-holder">
                                        <a class="btn-escribir-conclusiones" data-idpaciente="{$videoconsulta_pendiente_finalizacion.paciente_idpaciente}" data-idvideoconsulta="{$videoconsulta_pendiente_finalizacion.idvideoconsulta}" data-nombre="{$videoconsulta_pendiente_finalizacion.paciente.nombre|str2seo}" data-apellido="{$videoconsulta_pendiente_finalizacion.paciente.apellido|str2seo}" href="javascript:;"><i class="icon-doctorplus-sheet-edit"></i>{"Escribir conclusiones"|x_translate}</a>
                                    </div>
                                </div>
                            </div>



                        </div>
                    </div>
                </div>
            {/foreach}

        </div>

    </div>
    <!--Modal-->
    <div id="vc-modal-refund" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                    <figure class="modal-icon"><i class="icon-doctorplus-refund"></i></figure>
                    <h4 class="modal-title">{"Cancelar Video Consulta"|x_translate}</h4>
                    <p class="modal-title-disclaimer">{"Se reembolsará al paciente el importe de la consulta"|x_translate}</p>
                </div>
                <div class="modal-body">
                    <div class="modal-action-row">
                        <a href="javascript:;" class="btn-alert" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                        <a href="javascript:;" data-id="" class="btn-default btn_devolver_dinero"><i class="icon-doctorplus-check-thin"></i> {"aceptar"|x_translate}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        $(function () {
            if ($("#icon_alert_interrumpidas").length > 0) {
                $("#icon_alert_pendientes").hide();
            }

            //conclusiones de la VC

            $(".btn-escribir-conclusiones").click(function () {

                var idpaciente = $(this).data("idpaciente");
                var idvideoconsulta = $(this).data("idvideoconsulta");
                var nombre = $(this).data("nombre");
                var apellido = $(this).data("apellido");

                if (parseInt(idpaciente) > 0 && parseInt(idvideoconsulta) > 0) {
                    $("body").spin("large");
                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + idpaciente + "-" + nombre + "-" + apellido + "/mis-registros-consultas-medicas/consultanueva-videoconsulta-" + idvideoconsulta + ".html";

                }

            });

            //desplegamos el modal para devolver el dinero
            $('.reembolsar-importe-rtg').on('click', function (e) {

                var id = $(this).data("id");
                e.preventDefault();
                $(".btn_devolver_dinero").data("id", id);
                $('#vc-modal-refund').modal(['show']);
            });
            //boton para devolver el dinero de la Video Consulta y pasarla a vencida
            $(".btn_devolver_dinero").click(function () {
                var id = parseInt($(this).data("id"));
                if (id > 0) {
                    $("body").spin();
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'devolucion_dinero_videoconsulta.do',
                            "idvideoconsulta=" + id,
                            function (data) {
                                $("body").spin(false);
                                $('#vc-modal-refund').modal('hide');
                                if (data.result) {
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }
            });
        });
    </script>

{/if}