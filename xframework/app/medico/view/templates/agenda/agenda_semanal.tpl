<style>
    .agenda-calendar-day-of-week .day-of-week-header figure i{
        font-size: 26px;
        color: #fff;
        top: 10px;
        position: absolute;
        right: 10px;
    }
    .agenda-calendar-day-of-week .day-of-week-header figure span.subcircle {
        display: inline-block !important;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background-color: #f33243;
        margin: 0;
        position: absolute;
        top: 36px;
        right: 6px;
    }
    .dow-confirmado.vc-vencida{
        background-color: #ff6f6f !important
    }

    .btnCancelarDisponibilidad{
        position: absolute;
        right: 20px;
    }
    .btnCancelarDisponibilidad:hover{
        transform: scale(1.3);
    }
</style>
<div id="agenda_semanal_medico">
    <input type="hidden"  id="dia_agenda" value="{$dia_agenda}"/>
    {include file="agenda/agenda_header.tpl"}

    <section class=" hidden-xs agenda-content">

        <div class="agenda-month-selector-box">
            <a href="javascript:;" title="Anterior" id="a_get_dia_previous_week" class="agenda-circle-btn left">
                <i class="icon-doctorplus-left-arrow"></i>							
            </a>
            {*verificamos si la semana corresponde a un cambio de mes*}
            {if $nombre_mes_inicio==$nombre_mes_fin}
                <h3 class="agenda-month">du {$dia_inicio} au {$dia_fin} {$nombre_mes}</h3>
            {else}
                <h3 class="agenda-month">du {$dia_inicio} {$nombre_mes_inicio} au {$dia_fin} {$nombre_mes_fin} </h3>

            {/if}
            <a href="javascript:;" title="Siguiente" id="a_get_dia_next_week" class="agenda-circle-btn right">
                <i class="icon-doctorplus-right-arrow"></i>							
            </a>
        </div>

        <div class="agenda-container">
            <div class="okm-row">
                <div class="agenda-calendario-header">
                    <ul>
                        {foreach from=$fechas_semana item=fecha}
                            <li><span class="agenda-label-lg">{$fecha.dia} {$fecha.numero_dia}</span><span class="agenda-label-sm">{$fecha.dia} {$fecha.numero_dia}</span></li>
                            {/foreach}

                    </ul>
                </div>

                <!--agenda semana-->
                {if $list_agenda_semanal}
                    <div class="agenda-calendario-days">
                        <div class="okm-row agenda-calendar-week-row">



                            {for $foo=1 to 7}
                                <div class="agenda-calendar-week-col">
                                    {foreach from=$list_agenda_semanal.$foo item=turno}

                                        <!-- Turno disponible-->
                                        {if $turno.idpaciente == "" && $turno.turno_pasado!="1" && $turno.estado!="8" && $turno.vacaciones!="1"}

                                            <a href="{$url}panel-medico/agenda/tomar_turno.html?idturno={$turno.idturno}" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-disponible" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                </div>
                                                <div class="day-of-week-paciente">
                                                    {"Disponible"|x_translate}
                                                    <span class="btnCancelarDisponibilidad" data-estado='{$turno.estado}' data-idturno='{$turno.idturno}'><i class="fas fa-trash-alt fa-lg"></i></span>
                                                </div>
                                            </a>
                                            <!-- Turno inactivo -->
                                        {elseif  $turno.idpaciente == "" && $turno.estado=="8"} 
                                            <a href="#" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-inactivo" title={"Activar"|x_translate} >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                </div>
                                                <div class="day-of-week-paciente">{"Inactivo"|x_translate} 
                                                    <span class="btnCancelarDisponibilidad" data-estado='{$turno.estado}' data-idturno='{$turno.idturno}'><i class="fas fa-check-circle fa-lg" ></i></span>
                                                </div>
                                            </a>
                                            <!-- Turno disponible pasado o de vacaciones-->
                                        {elseif  $turno.idpaciente == "" && ($turno.turno_pasado=="1" || $turno.vacaciones=="1")}
                                            <a href="javascript:;" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-default" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>                                   
                                                </div>
                                                {if  $turno.vacaciones=="1"}
                                                    <div class="day-of-week-paciente">
                                                        {"Vacaciones"|x_translate}
                                                    </div>
                                                {/if}
                                            </a>
                                            <!-- Turno pendiente -->
                                        {elseif  $turno.idpaciente != "" && $turno.estado=="0" && $turno.turno_pasado!="1"}
                                            <a href="javascript:;" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-pendiente display-modal" data-modal="modal-turno-pendiente-{$turno.idturno}">
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <figure>{"¡confirmar!"|x_translate}</figure>
                                                </div>
                                                <div class="day-of-week-paciente">{$turno.nombre} {$turno.apellido}</div>
                                            </a>

                                            <!-- Modal Turno pendiente -->
                                            <div class="modal fade modal-turnos" id="modal-turno-pendiente-{$turno.idturno}">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-body">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                                                            <div class="modal-turnos-content">
                                                                <div class="user-avatar">
                                                                    {if $turno.paciente_imagen.list!=""}
                                                                        <img src="{$turno.paciente_imagen.list}" alt="{$turno.nombre} {$turno.apellido}"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$turno.nombre} {$turno.apellido}">
                                                                    {/if}
                                                                </div>
                                                                <div class="user-name">
                                                                    {$turno.nombre} {$turno.apellido}
                                                                </div>
                                                                <div class="okm-row td-slide-turno-action-box">

                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" data-estado="1" class="btnCambiarEstadoTurno confirmar">
                                                                            <figure>
                                                                                <i class="icon-doctorplus-check-thin"></i>
                                                                            </figure>
                                                                            <span>{"Confirmar"|x_translate}</span>
                                                                        </a>

                                                                    </div>
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" data-estado="2" class="cancelar-turno cancelar">
                                                                            <figure>
                                                                                <i class="fas fa-user-times"></i>
                                                                            </figure>
                                                                            <span>{"Cancelar"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}"  data-estado="3" class="declinar-turno declinar">
                                                                            <figure>
                                                                                <i class="fa fa-calendar-times-o"></i>
                                                                            </figure>
                                                                            <span>{"Declinar"|x_translate}</span>
                                                                        </a>
                                                                        <a href="javascript:;" class="td-tooltip-btn" title='{"Decline el turno si por algún motivo no puede atender en ese horario. Este horario quedará fuera de agenda y no podrá ser tomado por otro paciente."|x_translate}'>?</a>
                                                                    </div>

                                                                </div>
                                                                <div class="okm-row mensaje-turno-container"  data-idturno="{$turno.idturno}" style='display:none;'>
                                                                    <textarea name="mensaje" class="form-control text-mensaje" data-idturno="{$turno.idturno}" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}'></textarea>
                                                                    <div class='button-container text-center'>
                                                                        <button  class='btn-xs btn-default btnCambiarEstadoTurno' data-idturno="{$turno.idturno}" data-action="declinar" data-estado="3" style="display:none;" >{"Declinar"|x_translate}&nbsp;<i class='fa fa-chevron-right'></i></button>                        
                                                                        <button  class='btn-xs btn-default btnCambiarEstadoTurno' data-idturno="{$turno.idturno}"  data-action="cancelar" data-estado="2" style="display:none;">{"Cancelar"|x_translate}&nbsp;<i class='fa fa-chevron-right'></i></button>                        
                                                                    </div>

                                                                </div>
                                                                <div class="okm-row modal-turnos-action-box">
                                                                    <a href="javascript:;" data-idturno="{$turno.idturno}" class="btnDetalleTurno">{"Más detalles"|x_translate}</a>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!--Fin modal-->


                                            <!-- Turno pendiente pasado-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado=="0" && $turno.turno_pasado=="1"}
                                            <a href="javascript:;" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-pendiente" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <div class="day-of-week-paciente">{$turno.nombre} {$turno.apellido}</div>
                                                </div>
                                            </a>
                                            <!--Turno confirmado-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==1 && $turno.turno_pasado!="1"}

                                            <a href="javascript:;" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-confirmado display-modal"  data-modal="modal-turno-confirmado-{$turno.idturno}" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <figure><i class="icon-doctorplus-check-circle"></i></figure>
                                                </div>
                                                <div class="day-of-week-paciente">{$turno.nombre} {$turno.apellido}</div>
                                            </a>

                                            <!-- Modal Turno confirmado -->
                                            <div class="modal fade modal-turnos" id="modal-turno-confirmado-{$turno.idturno}">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-body">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                                                            <div class="modal-turnos-content">
                                                                <div class="user-avatar">
                                                                    {if $turno.paciente_imagen.list!=""}
                                                                        <img src="{$turno.paciente_imagen.list}" alt="{$turno.nombre} {$turno.apellido}"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$turno.nombre} {$turno.apellido}">
                                                                    {/if}
                                                                </div>
                                                                <div class="user-name">
                                                                    {$turno.nombre} {$turno.apellido}
                                                                </div>
                                                                <div class="okm-row td-slide-turno-action-box">
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" data-estado="2" class="cancelar-turno cancelar">
                                                                            <figure>
                                                                                <i class="fas fa-user-times"></i>
                                                                            </figure>
                                                                            <span>{"Cancelar"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" data-estado="3" class="declinar-turno declinar">
                                                                            <figure>
                                                                                <i class="fa fa-calendar-times-o"></i>
                                                                            </figure>
                                                                            <span>{"Declinar"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="okm-row mensaje-turno-container"  data-idturno="{$turno.idturno}" style='display:none;'>
                                                                    <textarea name="mensaje" class="form-control text-mensaje" data-idturno="{$turno.idturno}" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}'></textarea>
                                                                    <div class='button-container text-center'>
                                                                        <button  class='btn-xs btn-default btnCambiarEstadoTurno' data-idturno="{$turno.idturno}" data-action="declinar" data-estado="3" style="display:none;" >{"Declinar"|x_translate}&nbsp;<i class='fa fa-chevron-right'></i></button>                        
                                                                        <button  class='btn-xs btn-default btnCambiarEstadoTurno' data-idturno="{$turno.idturno}"  data-action="cancelar" data-estado="2" style="display:none;">{"Cancelar"|x_translate}&nbsp;<i class='fa fa-chevron-right'></i></button>                        
                                                                    </div>

                                                                </div>
                                                                <div class="okm-row modal-turnos-action-box">
                                                                    <a href="javascript:;" data-idturno="{$turno.idturno}" class="btnDetalleTurno">{"Más detalles"|x_translate}</a>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>	
                                            <!--Fin modal-->

                                            <!--Turno confirmado pasado sin conclusion-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==1 && $turno.turno_pasado==1 && $turno.perfilSaludConsulta_idperfilSaludConsulta==""}
                                            <a href="javascript:;"  title='{"Escribir conclusiones"|x_translate}' class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-confirmado display-modal  {if $turno.estadoVideoConsulta_idestadoVideoConsulta=="5"}vc-vencida{/if}" data-modal="modal-turno-pasado-{$turno.idturno}" {if $turno}{/if}>
                                                <div class="day-of-week-header">
                                                    <span>
                                                        {$turno.horarioInicio|date_format:"%H:%M"}
                                                        {if $turno.estadoVideoConsulta_idestadoVideoConsulta=="5"}- <em>{"Paciente ausente"|x_translate}</em>{/if}
                                                    </span>
                                                    <figure>
                                                        <i class="icon-doctorplus-sheet-edit"></i>
                                                        <span class="subcircle"></span>
                                                    </figure>
                                                </div>
                                                <div class="day-of-week-paciente">{$turno.nombre} {$turno.apellido}</div>
                                            </a>

                                            <!-- Modal Turno pasado  sin conclusion-->
                                            <div class="modal fade modal-turnos" id="modal-turno-pasado-{$turno.idturno}">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-body">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                                                            <div class="modal-turnos-content">
                                                                <div class="user-avatar">
                                                                    {if $turno.paciente_imagen.list!=""}
                                                                        <img src="{$turno.paciente_imagen.list}" alt="{$turno.nombre} {$turno.apellido}"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$turno.nombre} {$turno.apellido}">
                                                                    {/if}
                                                                </div>
                                                                <div class="user-name">
                                                                    {$turno.nombre} {$turno.apellido}
                                                                </div>
                                                                <div class="okm-row td-slide-turno-action-box">
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idpaciente="{$turno.idpaciente}" data-idturno="{$turno.idturno}" class="btnEscribirConclusiones conclusiones">
                                                                            <figure>
                                                                                <i class="icon-doctorplus-sheet-edit"></i>
                                                                            </figure>
                                                                            <span>{"Escribir conclusiones"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" data-estado="5" class="btnCambiarEstadoTurno ausente">
                                                                            <figure>
                                                                                <i class="icon-doctorplus-ausente"></i>
                                                                            </figure>
                                                                            <span>{"Paciente ausente"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="okm-row modal-turnos-action-box">
                                                                    <a href="javascript:;" data-idturno="{$turno.idturno}" class="btnDetalleTurno">{"Más detalles"|x_translate}</a>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>	
                                            <!--Fin modal-->

                                            <!--Turno confirmado pasado con conclusion-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==1 && $turno.turno_pasado=="1" && $turno.perfilSaludConsulta_idperfilSaludConsulta!=""}
                                            <a href="javascript:;" title='{"Ver registro de consulta médica"|x_translate}' class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-confirmado btnVerConsultaMedica" data-idperfilsaludconsulta="{$turno.perfilSaludConsulta_idperfilSaludConsulta}" data-idpaciente="{$turno.idpaciente}" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <figure><i class="icon-doctorplus-sheet"></i></figure>
                                                </div>
                                                <div class="day-of-week-paciente">
                                                    {$turno.nombre} {$turno.apellido}
                                                </div>
                                            </a>
                                            <!--Turno declinado-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==3 && $turno.turno_pasado!="1"}
                                            <a href="javascript:;" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-declinado display-modal" data-modal="modal-turno-declinado-{$turno.idturno}" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <figure><i class="fa fa-calendar-times-o"></i></figure>
                                                </div>
                                                <div class="day-of-week-paciente">
                                                    {"Horario no disponible"|x_translate}
                                                </div>
                                            </a>

                                            <!-- Modal Turno declinado -->
                                            <div class="modal fade modal-turnos" id="modal-turno-declinado-{$turno.idturno}">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-body">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                                                            <div class="modal-turnos-content">
                                                                <a href="{$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html">
                                                                    <div class="modal-turnos-text-box">
                                                                        <div class="date">{$turno.fecha_format}</div>
                                                                        <div class="hour">{$turno.horarioInicio|date_format:"%H:%M"} hs</div>
                                                                        <div class="reason">
                                                                            {"Turno declinado"|x_translate}<br>
                                                                            {"Horario no disponible"|x_translate}
                                                                        </div>
                                                                    </div>
                                                                </a>

                                                                <div class="okm-row td-slide-turno-action-box">
                                                                    <div class="td-turno-btn-holder">
                                                                        <a href="javascript:;" data-idturno="{$turno.idturno}" class="btnHabilitarTurno disponible">
                                                                            <figure>
                                                                                <i class="fa fa-calendar-check-o"></i>
                                                                            </figure>
                                                                            <span>{"Habilitar turno"|x_translate}</span>
                                                                        </a>
                                                                    </div>
                                                                </div>


                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>	
                                            <!--Fin modal-->

                                            <!--Turno declinado pasado-->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==3 && $turno.turno_pasado=="1"}
                                            <a href="{$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-declinado" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                                    <figure><i class="fa fa-calendar-times-o"></i></figure>
                                                </div>
                                                <div class="day-of-week-paciente">
                                                    {$turno.nombre} {$turno.apellido}
                                                </div>
                                            </a>
                                            <!--Turno ausente -->
                                        {elseif  $turno.idpaciente != "" && $turno.estado==5 }
                                            <a href="{$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html" class="agenda-calendar-day-of-week {if $turno.turno_actual=="1"}dow-hoy{/if} dow-ausente" >
                                                <div class="day-of-week-header">
                                                    <span>{$turno.horarioInicio|date_format:"%H:%M"} - {"Paciente ausente"|x_translate}</span>
                                                    <figure><i class="icon-doctorplus-ausente"></i></figure>
                                                </div>
                                                <div class="day-of-week-paciente"> 
                                                    {$turno.nombre} {$turno.apellido}
                                                </div>
                                            </a>

                                        {/if}
                                    {foreachelse}
                                        &nbsp;
                                    {/foreach}


                                </div>
                            {/for}


                        </div>
                    </div>

                    <!--agenda semana-->
                {else}
                    {if $agenda_definida}
                        <td colspan="7">
                            <h4 class="msg-generico text-center">{"No se ha definido agenda de turnos para esta semana."|x_translate} </h4>
                        </td>
                    {else}
                        <td colspan="7">
                            <h4 class="msg-generico text-center">{"Ud. aún no ha definido los días y los horarios de su agenda de turnos"|x_translate}</h4>
                        </td>
                    {/if} 
                {/if}

            </div>
        </div>
        {*
        <div class="row-action-up">
        <a href="javascript:;" id="scrollUp">
        <figure>
        <i class="icon-doctorplus-arrow-down"></i>
        </figure>
        </a>
        </div>
        *}
    </section>
    <section class="visible-xs">
        <div class="text-center"style="padding-top:80px;">
            <span>{"La agenda semanal no se encuentra disponible para esta resolución de pantalla"|x_translate}</span>
        </div>
        <div class="clear-fix"><p>&nbsp;</p></div></section>
        {include file="agenda/referencia_estado_turnos.tpl"}
</div>
{x_load_js}
