<style>
    @media (min-width: 601px){
        .agd-estado {
            position: absolute;
            display: inline-block;
            top: 0px;
            right: 0px;
            padding: 20px 16px;
            border-radius: 0px;
            font-size: 14px;
            height: 100%;
            min-width: 230px;
            text-align: center;
        }
        .agd-row.agd-confirmado .agd-estado span {
            color: #fff;
            margin-left: 30px;
        }


        .agd-estado i {
            display: inline;
            font-size: 24px;
            position: absolute;
            top: 15px;
            left: 15px;
            color: #fff !important;
        }
    }
    .agd-row.agd-confirmado .agd-estado span.subcircle {
        display: inline-block !important;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background-color: #f33243;
        margin: 0;
        position: absolute;
        bottom: 11px;
        left: 32px;
    }
    .agd-confirmado.vc-vencida .agd-estado{
        background-color: #ff6f6f !important
    }
    .agd-row.agd-ausente .agd-descripcion {
        color:  #415b70; 
        font-style: normal; 
    }
    .btnCancelarDisponibilidad{
        position: absolute;
        right: 50px;
    }
    .btnCancelarDisponibilidad:hover{
        transform: scale(1.3);
    }

</style>
<div id="agenda_diaria_medico">
    <input type="hidden"  id="dia_agenda" value="{$dia_agenda}"/>
    {include file="agenda/agenda_header.tpl"}

    <section class="agenda-content">

        <div class="agenda-month-selector-box">
            <a href="javascript:;" title="Anterior" id="a_get_dia_previous_day" class="agenda-circle-btn left">
                <i class="icon-doctorplus-left-arrow"></i>							
            </a>
            <h3 class="agenda-month">{$nombre_dia} {$dia} {$nombre_mes}</h3>
            <a href="javascript:;" title="Siguiente" id="a_get_dia_next_day" class="agenda-circle-btn right">
                <i class="icon-doctorplus-right-arrow"></i>							
            </a>
        </div>

        <div class="agenda-container">
            <div class="okm-row">

                <div class="agenda-diaria-box">
                    <!-- verificamos si es un dia de vacaciones-->
                    {if $vacaciones=="1"}
                        <td colspan="7">
                            <h4 class="msg-generico text-center">{"Vacaciones"|x_translate} </h4>
                        </td>
                    {else if $listado_turnos_diarios}
                        {foreach from=$listado_turnos_diarios item=turno name="foo"}

                            {if $posicion_cambio_config_agenda[$smarty.foreach.foo.index]!=""}
                                <div class="okm-row agd-row agd-libre">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$posicion_cambio_config_agenda[$smarty.foreach.foo.index].desde|date_format:"%H:%M"} a {$posicion_cambio_config_agenda[$smarty.foreach.foo.index].hasta|date_format:"%H:%M"}</span>
                                        </div>
                                        <span>{"Tiempo libre"|x_translate}</span>
                                    </div>

                                </div>
                            {/if}

                            <!-- Turno disponible-->
                            {if $turno.idpaciente == "" && $turno.turno_pasado!="1" && $turno.estado!="8"}

                                <a href="{$url}panel-medico/agenda/tomar_turno.html?idturno={$turno.idturno}" class="okm-row agd-row agd-disponible {if $turno.turno_actual=="1"}agd-hoy{/if}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {"Turno disponible"|x_translate}
                                        <span class="btnCancelarDisponibilidad" data-estado='{$turno.estado}' data-idturno='{$turno.idturno}'><i class="fas fa-trash-alt fa-lg"></i></span>
                                    </div>
                                </a>
                                <!-- Turno disponible pasado-->
                            {elseif  $turno.idpaciente == "" && $turno.turno_pasado=="1"}
                                <a href="javascript:;" class="okm-row agd-row agd-pasado {if $turno.turno_actual=="1"}agd-hoy{/if}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>

                                        </div>
                                        &nbsp;
                                    </div>
                                </a>
                                <!-- Turno inactivo-->
                            {elseif  $turno.idpaciente == "" && $turno.estado=="8"}
                                <a href="#" class="okm-row agd-row agd-inactivo {if $turno.turno_actual=="1"}agd-hoy{/if}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {"Turno inactivo"|x_translate}
                                        <span class="btnCancelarDisponibilidad" data-estado='{$turno.estado}' data-idturno='{$turno.idturno}'><i class="fas fa-check-circle fa-lg" ></i></span>
                                    </div>
                                </a>
                                <!-- Turno pendiente -->
                            {elseif  $turno.idpaciente != "" && $turno.estado=="0" && $turno.turno_pasado!="1"}
                                <a href="javascript:;" class="okm-row agd-row agd-pendiente {if $turno.turno_actual=="1"}agd-hoy{/if} display-modal" data-modal="modal-turno-pendiente-{$turno.idturno}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>
                                    <figure class="agd-estado">
                                        <i class="icon-doctorplus-pendiente"></i>
                                        <span>{"¡debe confirmar!"|x_translate}</span>
                                    </figure>

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
                                <a href="javascript:;" class="okm-row agd-row agd-pendiente {if $turno.turno_actual=="1"}agd-hoy{/if} display-modal" data-modal="modal-turno-pendiente-{$turno.idturno}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>


                                </a>
                                <!--Turno confirmado-->
                            {elseif  $turno.idpaciente != "" && $turno.estado==1 && $turno.turno_pasado!="1"}

                                <a href="javascript:;" class="okm-row agd-row agd-confirmado {if $turno.turno_actual=="1"}agd-hoy{/if} display-modal" data-modal="modal-turno-confirmado-{$turno.idturno}" >
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>
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
                                <a href="javascript:;"  title='{"Escribir conclusiones"|x_translate}' class="okm-row agd-row agd-confirmado {if $turno.turno_actual=="1"}agd-hoy{/if} display-modal  {if $turno.estadoVideoConsulta_idestadoVideoConsulta=="5"}vc-vencida{/if}" data-modal="modal-turno-pasado-{$turno.idturno}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido}
                                        {if $turno.estadoVideoConsulta_idestadoVideoConsulta=="5"}- <em>{"Paciente ausente"|x_translate}</em>{/if}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>
                                    <figure class="agd-estado">
                                        <i class="icon-doctorplus-sheet-edit"></i>
                                        <span class="subcircle"></span>
                                        <span>{"Escribir conclusiones"|x_translate}</span>
                                    </figure>
                                </a>

                                <!-- Modal Turno confirmado pasado  sin conclusion-->
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
                                <a href="javascript:;" title='{"Ver registro de consulta médica"|x_translate}'  class="okm-row agd-row agd-confirmado {if $turno.turno_actual=="1"}agd-hoy{/if} btnVerConsultaMedica" data-idperfilsaludconsulta="{$turno.perfilSaludConsulta_idperfilSaludConsulta}" data-idpaciente="{$turno.idpaciente}" >
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>

                                    <figure class="agd-estado">
                                        <i class="icon-doctorplus-sheet"></i>
                                        <span>{"Ver conclusiones"|x_translate}</span>
                                    </figure>
                                </a>
                                <!--Turno declinado-->
                            {elseif  $turno.idpaciente != "" && $turno.estado==3 && $turno.turno_pasado!="1"}
                                <a href="javascript:;" class="okm-row agd-row agd-declinado {if $turno.turno_actual=="1"}agd-hoy{/if} display-modal" data-modal="modal-turno-declinado-{$turno.idturno}" >
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {"Declinado - Horario no disponible"|x_translate}
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
                                <a href={$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html" class="okm-row agd-row agd-declinado {if $turno.turno_actual=="1"}agd-hoy{/if}">
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {"Declinado - Horario no disponible"|x_translate}
                                    </div>

                                </a>
                                <!--Turno ausente -->
                            {elseif  $turno.idpaciente != "" && $turno.estado==5 }
                                <a href="{$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html" class="okm-row agd-row agd-ausente {if $turno.turno_actual=="1"}agd-hoy{/if}" >
                                    <div class="agd-usuario">
                                        <div class="agd-hora">
                                            <span>{$turno.horarioInicio|date_format:"%H:%M"}</span>
                                        </div>
                                        {$turno.nombre} {$turno.apellido} -  {"Paciente ausente"|x_translate}
                                    </div>
                                    <div class="agd-descripcion hidden-xs">
                                        {$turno.motivoVisita} 
                                    </div>
                                </a>

                            {/if}

                        {/foreach}
                    {else}
                        {if $agenda_definida}
                            <td colspan="7">
                                <h4 class="msg-generico text-center">{"No se ha definido agenda de turnos para este día."|x_translate} </h4>
                            </td>
                        {else}
                            <td colspan="7">
                                <h4 class="msg-generico text-center">{"Ud. aún no ha definido los días y los horarios de su agenda de turnos"|x_translate}</h4>
                            </td>
                        {/if}


                    {/if}







                    <!--agenda diaria-->
                </div>

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
    {include file="agenda/referencia_estado_turnos.tpl"}
</div>
{x_load_js}