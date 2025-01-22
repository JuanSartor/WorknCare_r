<!-- mensajes-->
{if $consulta.consulta_express|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="chat">
        <div class="pps-chat-content">
            <div class="pps-chat-content-top">
                <div class="okm-row">
                    <div class="pps-chat-content-consulta">
                        {"Consulta Express Nº"|x_translate} {$consulta.numeroConsultaExpress}
                    </div>
                    <div class="pps-chat-content-motivo">
                        {"Motivo"|x_translate}: {$consulta.motivoConsultaExpress}
                    </div>
                </div>
            </div>

            <div class="pps-chat-content-chat-box">
                <div class="cs-ca-chat-holder">
                    {foreach from=$consulta.consulta_express.mensajes item=mensaje}

                        {if $mensaje.emisor == "m"}
                            <div class="row chat-row">
                                <div class="chat-line-holder pce-dr-chat">
                                    {if $consulta.medico_imagen.list != ""}
                                        <img src="{$consulta.medico_imagen.perfil}" alt="user"/>
                                    {else}
                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                    {/if}
                                    <div class="chat-content">
                                        <figure>
                                            <div class="chat-content-date">{$mensaje.fecha_format}</div>
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
                                                    <small>
                                                        <i class="fui-clip"></i>
                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                    </small>
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
                                        {if $consulta.consulta_express.paciente_titular}
                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                {if $consulta.consulta_express.paciente_titular.image.perfil != ""}
                                                    <img src="{$consulta.consulta_express.paciente_titular.image.perfil}" alt="user"/>
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                {/if}
                                            </div>
                                        {/if}
                                        <div class="chat-image-avatar-xn-row">
                                            {if $consulta.consulta_express.paciente.image.perfil != ""}
                                                <img src="{$consulta.consulta_express.paciente.image.perfil}" alt="user"/>
                                            {else}
                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                            {/if}
                                            <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                        </div>
                                    </div>
                                    <div class="chat-content pcer-chat-right">
                                        <figure>
                                            <div class="chat-content-date">{$mensaje.fecha_format}</div>
                                            <p>{$mensaje.mensaje}</p>
                                            <span class="chat-content-arrow"></span>
                                        </figure>
                                        {if $mensaje.cantidad_archivos_mensajes > 0}
                                            <div class="chat-content-attach">
                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
                                                    <small>
                                                        <i class="fui-clip"></i>
                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                    </small>
                                                </a>
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                </div>
            </div>
        </div>						
    </div>
{/if}
<!-- fin mensajes-->
<!-- mensajes vc-->
{if $consulta.videoconsulta|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="chat">
        <div class="pps-chat-content">
            <div class="pps-chat-content-top">
                <div class="okm-row">
                    <div class="pps-chat-content-consulta">
                        {"Videoconsulta Nº"|x_translate} {$consulta.numeroVideoConsulta}
                    </div>
                    <div class="pps-chat-content-motivo">
                        {"Motivo"|x_translate}: {$consulta.motivoVideoConsulta}
                    </div>
                </div>
            </div>

            <div class="pps-chat-content-chat-box">
                <div class="cs-ca-chat-holder">
                    {foreach from=$consulta.videoconsulta.mensajes item=mensaje}

                        {if $mensaje.emisor == "m"}
                            <div class="row chat-row">
                                <div class="chat-line-holder pce-dr-chat">
                                    {if $consulta.medico_imagen.list != ""}
                                        <img src="{$consulta.medico_imagen.perfil}" alt="user"/>
                                    {else}
                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                    {/if}
                                    <div class="chat-content">
                                        <figure>
                                            <div class="chat-content-date">{$mensaje.fecha_format}</div>
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
                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                    <small>
                                                        <i class="fui-clip"></i>
                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                    </small>
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
                                        {if $consulta.videoconsulta.paciente_titular}
                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                {if $consulta.videoconsulta.paciente_titular.image.perfil != ""}
                                                    <img src="{$consulta.videoconsulta.paciente_titular.image.perfil}" alt="user"/>
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                {/if}
                                            </div>
                                        {/if}
                                        <div class="chat-image-avatar-xn-row">
                                            {if $consulta.videoconsulta.paciente.image.perfil != ""}
                                                <img src="{$consulta.videoconsulta.paciente.image.perfil}" alt="user"/>
                                            {else}
                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                            {/if}
                                            <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                        </div>
                                    </div>
                                    <div class="chat-content pcer-chat-right">
                                        <figure>
                                            <div class="chat-content-date">{$mensaje.fecha_format}</div>
                                            <p>{$mensaje.mensaje}</p>
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
                        {/if}
                    {/foreach}
                </div>
            </div>
        </div>						
    </div>
{/if}
<!-- fin mensajes vc-->