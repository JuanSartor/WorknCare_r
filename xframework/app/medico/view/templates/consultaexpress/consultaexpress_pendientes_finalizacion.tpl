<div class="okm-row">
    <div class="cs-ca-consulta-pendiente-disclaimer">
        <i class="icon-doctorplus-alert-round"></i>
        <h3>{"Consultas Express pendientes de registro médico"|x_translate}</h3>
        <p>{"Para que el importe abonado por la consulta sea acreditado en su cuenta debe dejar registro médico de sus conclusiones."|x_translate} </p>
    </div>
</div>
<div class="cs-ca-consultas-holder">

    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        {foreach from=$listado_consultas_pendientes_finalizacion.rows key=key item=consulta_pendiente_finalizacion}
            <div id="consulta-finalizada-{$consulta_pendiente_finalizacion.idconsultaExpress}" class="panel panel-default">
                <div class="panel-heading" role="tab">
                    <div class="ce-ca-toolbar">                         
                        <div class="row consultas-finalizadas with-parent highlight">
                            <div class="colx3">
                                <div class="cs-ca-colx3-inner">
                                    <div class="cs-ca-usr-avatar">
                                        {if $consulta_pendiente_finalizacion.paciente.image}
                                            <img src="{$consulta_pendiente_finalizacion.paciente.image.list}" title="user"/>
                                        {else}
                                            {if $consulta_pendiente_finalizacion.paciente.animal!=1}
                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" title="user"/>
                                            {else}
                                                <img src="{$IMGS}extranet/noimage-animal.jpg" title="user"/>
                                            {/if}
                                        {/if}
                                        <a href="javascript:;"  class="change_miembro" data-id="{$consulta_pendiente_finalizacion.paciente.idpaciente}">
                                            <figure>
                                                <i class="icon-doctorplus-pharmaceutics"></i>
                                            </figure>
                                        </a>
                                    </div>
                                    <div class="cs-ca-usr-data-holder">
                                        <span>{"Paciente"|x_translate}</span>
                                        <h2>{$consulta_pendiente_finalizacion.paciente.nombre} {$consulta_pendiente_finalizacion.paciente.apellido}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="colx3">
                                <div class="cs-ca-colx3-inner">
                                    {if $consulta_pendiente_finalizacion.paciente_titular}

                                        <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                            {if $consulta_pendiente_finalizacion.paciente_titular.image}
                                                <img src="{$consulta_pendiente_finalizacion.paciente_titular.image.perfil}" title="user"/>
                                            {else}
                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" title="user"/>
                                            {/if}
                                        </div>
                                        <div class="cs-ca-usr-data-holder">
                                            {if $consulta_pendiente_finalizacion.paciente_titular.relacion != ""}
                                                <span>{$consulta_pendiente_finalizacion.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                            {else}
                                                <span>{"propietario"|x_translate}</span>
                                            {/if}
                                            <h2>{$consulta_pendiente_finalizacion.paciente_titular.nombre} {$consulta_pendiente_finalizacion.paciente_titular.apellido}</h2>
                                        </div>
                                    {/if}
                                </div>
                            </div>
                            <div class="ca-ce-finalizadas-col">

                                <a class="btn-escribir-conclusiones" data-idpaciente="{$consulta_pendiente_finalizacion.paciente_idpaciente}" data-idconsultaexpress="{$consulta_pendiente_finalizacion.idconsultaExpress}"  data-nombre="{$consulta_pendiente_finalizacion.paciente.nombre|str2seo}" data-apellido="{$consulta_pendiente_finalizacion.paciente.apellido|str2seo}" href="javascript:;">
                                    <figure>
                                        <i class="icon-doctorplus-sheet"></i>
                                        <span class="subcircle"></span>
                                    </figure>
                                    <span>{"Escribir conclusiones"|x_translate}</span>
                                </a>
                            </div>
                        </div>
                        <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_pendiente_finalizacion.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_pendiente_finalizacion.idconsultaExpress}">
                            <div class="pce-colx3">
                                <div class="cs-ca-numero-consulta-holder">
                                    <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                    <span class="cs-ca-numero-consulta">Nº {$consulta_pendiente_finalizacion.numeroConsultaExpress}</span>
                                </div>
                            </div>
                            <div class="pce-colx3">
                                <div class="cs-ca-numero-consulta-holder">
                                    <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                    <span class="cs-ca-numero-consulta">{$consulta_pendiente_finalizacion.motivoConsultaExpress}</span>
                                </div>
                            </div>
                            <div class="pce-colx3">
                                <div class="cs-ca-date-tools">
                                    <span class="cs-ca-numero-consulta-date-label">{"Finalizada"|x_translate}</span>
                                    <span class="cs-ca-fecha">{$consulta_pendiente_finalizacion.fecha_fin_format}</span>
                                    <div class="cs-ca-date-tools-holder">
                                        <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="collapse-{$consulta_pendiente_finalizacion.idconsultaExpress}" class="panel-collapse collapse" role="tabpanel" data-id="{$consulta_pendiente_finalizacion.idconsultaExpress}" aria-labelledby="heading-{$consulta_pendiente_finalizacion.idconsultaExpress}">

                    <div class="panel-body">
                        <div class="cs-ca-chat-holder">

                            {foreach from=$consulta_pendiente_finalizacion.mensajes item=mensaje}

                                {if $mensaje.emisor == "p"}
                                    <div class="row chat-row">
                                        <div class="chat-line-holder pce-dr-chat">
                                            <div class="chat-image-avatar-xn">
                                                {if $consulta_pendiente_finalizacion.paciente_titular}
                                                    <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                        {if $consulta_pendiente_finalizacion.paciente_titular.image.perfil != ""}
                                                            <img src="{$consulta_pendiente_finalizacion.paciente_titular.image.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                    </div>
                                                {/if}
                                                <div class="chat-image-avatar-xn-row">
                                                    {if $consulta_pendiente_finalizacion.paciente.image.perfil != ""}
                                                        <img src="{$consulta_pendiente_finalizacion.paciente.image.perfil}" alt="user"/>
                                                    {else}
                                                        {if $consulta_pendiente_finalizacion.paciente.animal != 1}
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
                                                    {if $consulta_pendiente_finalizacion.medico.image.perfil != ""}
                                                        <img src="{$consulta_pendiente_finalizacion.medico.image.perfil}" alt="user"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                    {/if}

                                                </div>
                                            </div>
                                            <div class="chat-content pcer-chat-right">
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


                        <div class="row">
                            <div class="audio-actions-panel">
                                <div class="audio-action-holder">
                                    <a class="btn-escribir-conclusiones" data-idpaciente="{$consulta_pendiente_finalizacion.paciente_idpaciente}" data-idconsultaexpress="{$consulta_pendiente_finalizacion.idconsultaExpress}" data-nombre="{$consulta_pendiente_finalizacion.paciente.nombre|str2seo}" data-apellido="{$consulta_pendiente_finalizacion.paciente.apellido|str2seo}" href="javascript:;"><i class="icon-doctorplus-sheet"></i>{"Escribir conclusiones"|x_translate}</a>
                                </div>
                            </div>
                        </div>



                    </div>
                </div>
            </div>
        {/foreach}

    </div>

</div>
{literal}
    <script>
        $(function () {

            //conclusiones de la CE
            $(".btn-escribir-conclusiones").click(function () {

                var idpaciente = $(this).data("idpaciente");
                var idconsultaexpress = $(this).data("idconsultaexpress");
                var nombre = $(this).data("nombre");
                var apellido = $(this).data("apellido");

                if (parseInt(idpaciente) > 0 && parseInt(idconsultaexpress) > 0) {
                    $("body").spin("large");
                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + idpaciente + "-" + nombre + "-" + apellido + "/mis-registros-consultas-medicas/consultanueva-express-" + idconsultaexpress + ".html";

                }


            });


            /*  $(".cs-ca-chat-holder").mCustomScrollbar({
             theme: "dark-3"
             });*/
            //scroll hasta el ultimo mensaje del chat
            $('.panel-collapse').on('show.bs.collapse', function () {
                scrollToLastMsg($(".cs-ca-chat-holder"));
            });
        });

    </script>
{/literal}