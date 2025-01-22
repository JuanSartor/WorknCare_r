
{if $detalle_turno.idturno!=""}
    <input type="hidden" id="idturno" value="{$detalle_turno.idturno}"/>
    <input type="hidden" id="estado_turno" value="{$detalle_turno.estado}"/>
    <input type="hidden" id="fecha_turno" value="{$detalle_turno.fecha|date_format:'%m/%d/%Y'}"/>


    <div class="okm-row td-slide-holder">
        <div class="td-slide-box">

            <div class="td-slide-item">
                <h2 class="td-slide-title-consultorio">
                    {if $detalle_turno.is_virtual=="1"}
                        {"Consultorio Virtual"|x_translate}
                    {else}
                        {"Consultorio Físico"|x_translate}
                    {/if}
                    <span>/</span> {"Turno Nº"|x_translate}{$detalle_turno.nroturno}
                </h2>
                {if $detalle_turno.estado == 1}
                    <h3 class="td-slide-title confirmado">{"Turno confirmado"|x_translate} <i class="icon-doctorplus-check-thin"></i></h3>
                    {else if $detalle_turno.estado === "0"}
                    <h3 class="td-slide-title confirmacion">{"Turno pendiente de confirmación"|x_translate} <i class="icon-doctorplus-alert"></i></h3>
                    {else if $detalle_turno.estado == 2}
                    <h3 class="td-slide-title cancelado">{"Turno cancelado"|x_translate} <i class="icon-doctorplus-cruz"></i></h3>
                    {else if $detalle_turno.estado == 3}
                    <h3 class="td-slide-title declinado">{"Turno declinado"|x_translate} <i class="fa fa-calendar-times-o"></i></h3>
                    {else if $detalle_turno.estado == 5}
                    <h3 class="td-slide-title ausente">{"Paciente ausente"|x_translate} <i class="icon-doctorplus-ausente"></i></h3>
                    {/if}

                <div class="okm-row">
                    {if $detalle_turno.estado != 3}

                        <div class="td-slide-paciente-row">
                            <figure>
                                {if $detalle_turno.paciente_imagen.list != ""}
                                    <img src="{$detalle_turno.paciente_imagen.list}" alt="{$detalle_turno.nombre} {$detalle_turno.apellido}"/>
                                {else}
                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$detalle_turno.nombre} {$detalle_turno.apellido}">
                                {/if}
                            </figure>

                            <h4>{$detalle_turno.nombre} {$detalle_turno.apellido}</h4>
                            <span class="td-slide-paciente-fn">{if $detalle_turno.sexo=="0"}<i class="icon-doctorplus-fem-symbol"></i>{else}<i class="icon-doctorplus-masc-symbol"></i>{/if} DN {$detalle_turno.fechaNacimiento|date_format:"%d/%m/%Y"}</span>

                        </div>

                        <div class="td-slide-turno-row">
                            <figure>
                                <i class="icon-doctorplus-calendar"></i>
                            </figure>
                            <span class="td-slide-turno-fecha">{$nombre_dia} {$detalle_turno.fecha|date_format:"%d"} {$nombre_mes} {$detalle_turno.fecha|date_format:"%Y"}</span>
                            <span class="td-slide-turno-hora">{$detalle_turno.horarioInicio|date_format:"%H:%M"} hs</span>
                        </div>
                    {else}
                        <div class="td-slide-declinado-box">
                            <h4 class="td-slide-declinado-fecha">{$nombre_dia} {$detalle_turno.fecha|date_format:"%d"} {$nombre_mes} {$detalle_turno.fecha|date_format:"%Y"}</h4>
                            <div class="td-slide-declinado-hora">{$detalle_turno.horarioInicio|date_format:"%H:%M"} hs</div>
                            <div class="td-slide-declinado-disclaimer">
                                {"Turno declinado"|x_translate}<br>
                                {"Horario no disponible"|x_translate}
                            </div>
                        </div>
                    {/if}

                    <div class="okm-row td-slide-turno-action-box">
                        {*turno pendiente *}
                        {if $detalle_turno.estado === "0" && $detalle_turno.turno_pasado!="1" }
                            <div class="td-turno-btn-holder">
                                <a href="javascript:;" class="confirmar btnCambiarEstadoTurno" data-estado="1">
                                    <figure>
                                        <i class="icon-doctorplus-check-thin"></i>
                                    </figure>
                                    <span>{"Confirmar"|x_translate}</span>
                                </a>

                            </div>
                            <div class="td-turno-btn-holder">
                                <a href="javascript:;" class="cancelar btnCambiarEstadoTurno" data-estado="2">
                                    <figure>
                                        <i class="fas fa-user-times"></i>
                                    </figure>
                                    <span>{"Cancelar"|x_translate}</span>
                                </a>
                            </div>
                            <div class="td-turno-btn-holder">
                                <a href="javascript:;" class="declinar btnCambiarEstadoTurno" data-estado="3">
                                    <figure>
                                        <i class="fa fa-calendar-times-o"></i>
                                    </figure>
                                    <span>{"Declinar"|x_translate}</span>
                                </a>
                                <a href="javascript:;" class="td-tooltip-btn" title='{"Decline el turno si por algún motivo no puede atenderlo. Le notificaremos al paciente por mail y por SMS y le ofreceremos un nuevo turno."|x_translate}'>?</a>
                            </div>
                        {/if}
                        {*turno confirmado*}
                        {if $detalle_turno.estado === "1"}
                            {if $detalle_turno.turno_pasado=="1"}
                                {if  $detalle_turno.perfilSaludConsulta_idperfilSaludConsulta==""}
                                    <div class="td-turno-btn-holder">
                                        <a href="javascript:;" data-idpaciente="{$detalle_turno.idpaciente}" data-idturno="{$detalle_turno.idturno}" class="btnEscribirConclusiones conclusiones">
                                            <figure>
                                                <i class="icon-doctorplus-sheet-edit"></i>
                                            </figure>
                                            <span>{"Escribir conclusiones"|x_translate}</span>
                                        </a>
                                    </div>
                                    <div class="td-turno-btn-holder">
                                        <a href="javascript:;" class="ausente btnCambiarEstadoTurno" tabindex="-1" data-estado="5">
                                            <figure>
                                                <i class="icon-doctorplus-ausente"></i>
                                            </figure>
                                            <span>{"Paciente ausente"|x_translate}</span>
                                        </a>

                                    </div>
                                {else}
                                    <div class="td-turno-btn-holder">
                                        <a href="javascript:;" title='{"Ver registro de consulta médica"|x_translate}' class="conclusiones btnVerConsultaMedica" data-idperfilsaludconsulta="{$detalle_turno.perfilSaludConsulta_idperfilSaludConsulta}" data-idpaciente="{$detalle_turno.idpaciente}">
                                            <figure>
                                                <i class="icon-doctorplus-sheet-edit"></i>
                                            </figure>
                                            <span>{"Ver conclusiones"|x_translate}</span>
                                        </a>
                                    </div>
                                {/if}

                            {else}
                                <div class="td-turno-btn-holder">
                                    <a href="javascript:;" class="cancelar btnCambiarEstadoTurno" data-estado="2" tabindex="-1">
                                        <figure>
                                            <i class="fas fa-user-times"></i>
                                        </figure>
                                        <span>{"Cancelar"|x_translate}</span>
                                    </a>
                                </div>


                                <div class="td-turno-btn-holder">
                                    <a href="javascript:;" class="declinar btnCambiarEstadoTurno" data-estado="3">
                                        <figure>
                                            <i class="fa fa-calendar-times-o"></i>
                                        </figure>
                                        <span>{"Declinar"|x_translate}</span>
                                    </a>
                                    <a href="javascript:;" class="td-tooltip-btn" title='{"Decline el turno si por algún motivo no puede atenderlo. Le notificaremos al paciente por mail y por SMS y le ofreceremos un nuevo turno."|x_translate}'>?</a>
                                </div>
                            {/if}
                        {/if}

                        {*turno declinado*}
                        {if $detalle_turno.estado === "3"}
                            {if $detalle_turno.turno_pasado!="1"}

                                <div class="td-turno-btn-holder">
                                    <a href="javascript:;" data-idturno="{$detalle_turno.idturno}" class="btnHabilitarTurno disponible">
                                        <figure>
                                            <i class="fa fa fa-calendar-check-o"></i>
                                        </figure>
                                        <span>{"Habilitar turno"|x_translate}</span>
                                    </a>
                                </div>
                            {/if}
                        {/if}

                    </div>


                </div>

                <div class="okm-row td-turno-datos-paciente-box">
                    <a href="javascript:;" class="td-turno-datos-paciente-trg">
                        <h4><i class="icon-doctorplus-user"></i> {"Datos del paciente"|x_translate} <span class="arrow rotate"></span></h4>
                    </a>

                    <div class="td-turno-datos-paciente-collapse" style="display:block">
                        <div class="okm-row">
                            <div class="td-turno-datos-paciente-collapse-col-1">
                                <label><span class="td-label">{"Email"|x_translate}</span><span class="td-icon"><i class="icon-doctorplus-envelope"></i></span></label>
                                <p>
                                    {$detalle_turno.email}
                                </p>
                            </div>
                            <div class="td-turno-datos-paciente-collapse-col-2">
                                <label><span class="td-label">{"Celular"|x_translate}</span><span class="td-icon"><i class="icon-doctorplus-cel"></i></span></label>
                                <p>
                                {if $detalle_turno.numeroCelular!=""}{$detalle_turno.numeroCelular}{else} - {/if}
                            </p>
                        </div>
                    </div>


                </div>

                <div class="td-turno-datos-paciente">
                    <div class="okm-row">
                        <div class="td-turno-datos-paciente-motivo">
                            <label><strong>{"Motivo de la consulta:"|x_translate}</strong></label>
                            <p>
                        {if $detalle_turno.idservicio_medico=="3"}{$detalle_turno.motivoVisita}{else}{$detalle_turno.motivoVideoConsulta}{/if}
                    </p>
                </div>
            </div>
            {if $detalle_turno.mensaje_turno.mensaje!=""}
                <div class="okm-row">
                    <div class="td-turno-datos-paciente-comentarios">
                        <label><strong>{"Comentarios del paciente:"|x_translate}</strong></label>
                        <p>

                            {$detalle_turno.mensaje_turno.mensaje|escape}
                        </p>
                        {if $detalle_turno.mensaje_turno.cantidad_archivos_mensajes > 0}
                            <div class="chat-content-attach">
                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$detalle_turno.mensaje_turno.idmensajeTurno}" data-target="#ver-archivo">
                                    <i class="fui-clip"></i>
                                    &nbsp;{$detalle_turno.mensaje_turno.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                </a>
                            </div>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>

    </div>

</div>


</div>
{if $idturno_previo!=""}
    <a href="javascript:;" data-idturno="{$idturno_previo}" id="btnTurnoPrevio" class="td-slide-arrow left"><i class="icon-doctorplus-left-arrow"></i></a>
    {/if}
    {if $idturno_siguiente!=""}
    <a href="javascript:;" data-idturno="{$idturno_siguiente}" id="btnTurnoSiguiente" class="td-slide-arrow right"><i class="icon-doctorplus-right-arrow"></i></a>
    {/if}
</div>
{include file="home/modal_display_file.tpl"}
<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>
{x_load_js}
{else}
    <div class="okm-row td-slide-holder">
        <div class="clearofix"><p>&nbsp;</p></div>
        <div class="clearofix"><p>&nbsp;</p></div>

        <h4 align="center">{"No se pudo recuperar el Turno solicitado"|x_translate}</h3>

    </div>
    <div class="clearofix"><p>&nbsp;</p></div>
    <div class="clearofix"><p>&nbsp;</p></div>
{/if}

{literal}
    <script>

        $(function () {
            $("#Main").spin(false);
            $('#ver-archivo').on('hidden.bs.modal', function () {
                $(this)
                        .removeData('bs.modal')
                        .find(".modal-content").html('');
            });
        });
    </script>
{/literal}