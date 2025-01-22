{if $notificacion.idsolicitudRenovacionPerfilSaludMedicamento != ""}
    <div id="item-{$notificacion.idnotificacion}" class="item nt-renovacion-receta">
        <div class="item-wrap">
            <span class="dpp-renovar-receta item-cat">
                {if $notificacion.leido != 1} 
                    <i class="fa fa-exclamation-circle no-leido" ></i>
                {/if}
            </span>
            <label class="checkbox chk-eliminar" >
                <input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" />
            </label>

            <div class="row">
                <a href="javascript:;"  data-idnotificacion="{$notificacion.idnotificacion}" class="icon-toggle item-open" data-click-state="0">
                    <i class="fa fa-plus" aria-hidden="true"></i>
                </a>	
                <div class="col-md-4">
                    <h5>{"Solicitud de Renovación de Receta"|x_translate}</h5>
                    <p>{$notificacion.fechaNotificacion_format}</p>
                </div>	
                <div class="col-md-8">
                    <div class="item-contenido">
                        <p>{"Paciente"|x_translate}: {$notificacion.nombre_paciente_renovacion} {$notificacion.apellido_paciente_renovacion}</p>
                        <p><i>"{$notificacion.mensajePaciente}"</i></p>

                        <div id="div_opcion_renovacion_{$notificacion.idnotificacion}" class="opcion-renovacion">
                            <div class="table-responsive">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <td>{"Medicamento"|x_translate}</td>
                                            <td>{$notificacion.nombre_medicamento}</td>
                                        </tr>
                                        <tr>
                                            <td>{"Posología"|x_translate}</td>
                                            <td>{$notificacion.posologia}</td>
                                        </tr>
                                        <tr>
                                            <td>{"Observaciones"|x_translate}</td>
                                            <td>{$notificacion.tipo_toma_medicamentos.tipoTomaMedicamentos}</td>
                                        </tr>  
                                        {if $notificacion.aceptado==1}
                                            <tr>
                                                <td>{"Estado"|x_translate}</td>
                                                <td>{"Su renovación de receta fue aceptada"|x_translate}</td>
                                            </tr>

                                        {/if}
                                        {if $notificacion.aceptado==2}
                                            <tr>
                                                <td>{"Estado"|x_translate}</td>
                                                <td>{"Su renovación de receta fue rechazada."|x_translate}</td>
                                            </tr>
                                        {/if}                                        
                                    </tbody>            				
                                </table>
                            </div>
                            {if $notificacion.aceptado==0}
                                <div class="form-content">
                                    <p>
                                        <button class="btn btn-primary btn-slider" data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}"  data-idnotificacion="{$notificacion.idnotificacion}"  data-target="opcion-renovar-receta">{"renovar receta"|x_translate}</button>
                                        <button class="btn btn-danger btn-slider" data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}"  data-idnotificacion="{$notificacion.idnotificacion}"  data-target="opcion-rechazar-renovacion">{"rechazar solicitud"|x_translate}</button>
                                    </p>
                                </div>
                            {/if}
                        </div>
                        {if $notificacion.aceptado==0}
                            <div id="div_renovar_{$notificacion.idnotificacion}"  style="display:none"  class="opcion-receta opcion-renovar-receta">
                                <div class="table-responsive">
                                    <table class="table">
                                        <tbody>
                                            <tr>
                                                <td>{"Medicamento"|x_translate}</td>
                                                <td>{$notificacion.nombre_medicamento}</td>
                                            </tr>
                                            <tr>
                                                <td>{"Posología"|x_translate}</td>
                                                <td>{$notificacion.posologia}</td>
                                            </tr>
                                            <tr>
                                                <td>{"Observaciones"|x_translate}</td>
                                                <td>{$notificacion.tipo_toma_medicamentos.tipoTomaMedicamentos}</td>
                                            </tr>            					            					
                                        </tbody>            				
                                    </table>
                                </div>
                                <div class="form-content" >
                                    <form role="form" id="renovar_receta_{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" action="{$url}renovar_receta.do" method="post"  onsubmit="return false;">
                                        <input type="hidden" name="idsolicitudRenovacionPerfilSaludMedicamento" value="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" />
                                        <input type="hidden" name="idnotificacion" value="{$notificacion.idnotificacion}" />
                                        <div class="date-holder">
                                            <span>
                                                {if $notificacion.aceptado == "0"}
                                                    <input placeholder='{"Fecha de inicio"|x_translate}' type="text" class="fecha_inicio_class" name="fecha_inicio" data-date-format="DD/MM/YYYY" value="{$smarty.now|date_format:'%d/%m/%Y'}">
                                                {else}
                                                    <input placeholder='{"Fecha de inicio"|x_translate}' type="text" class="fecha_inicio_class" name="fecha_inicio" data-date-format="DD/MM/YYYY" value="" disabled>
                                                {/if}
                                                <img class="ui-datepicker-trigger" src="{$IMGS}icons/icon-calendar.svg" alt="Calendario">
                                            </span>

                                            <span>
                                                {if $notificacion.aceptado == "0"}
                                                    <input placeholder='{"Fecha de fin"|x_translate}' class="fecha_fin_class" name="fecha_fin" data-date-format="DD/MM/YYYY" type="text" value="{$smarty.now|date_format:'%d/%m/%Y'}">
                                                {else}
                                                    <input placeholder='{"Fecha de fin"|x_translate}' class="fecha_fin_class" name="fecha_fin" data-date-format="DD/MM/YYYY" type="text" disabled value="">
                                                {/if}
                                                <img class="ui-datepicker-trigger" src="{$IMGS}icons/icon-calendar.svg" alt="Calendario">
                                            </span>
                                        </div>
                                        <p><label class="checkbox" for="retirar-check"><input type="checkbox" value="1" name="notificarRetiroReceta" id="retirar-check" {if $solicitud.notificarRetiroReceta === "1"}checked {/if}>{"Notificar al paciente que puede retirar su receta en horario de consultorio"|x_translate}</label>
                                        </p>
                                        <br>
                                        <p>
                                            {if $notificacion.aceptado == 0}
                                                <button data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" class="btn btn-primary btn_renovar_receta" style="min-width:150px">{"renovar"|x_translate}</button>
                                            {/if}
                                            <a href="javascript:;" data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}"  data-idnotificacion="{$notificacion.idnotificacion}" class="btn btn-inverse btn-slider cancelar_accion" data-target="opcion-renovacion">{"cancelar"|x_translate}</a>
                                        </p>
                                    </form>
                                </div>
                            </div>
                            <!-- /opcion-renovar-receta -->

                            <div id="div_cancelar_{$notificacion.idnotificacion}" style="display:none" class="opcion-receta opcion-rechazar-renovacion">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>{"Medicamento"|x_translate}</td>
                                            <td>{$notificacion.nombre_medicamento}</td>
                                        </tr>
                                        <tr>
                                            <td>{"Posología"|x_translate}</td>
                                            <td>{$notificacion.posologia}</td>
                                        </tr>
                                        <tr>
                                            <td>{"Observaciones"|x_translate}</td>
                                            <td>{$notificacion.tipo_toma_medicamentos.tipoTomaMedicamentos}</td>
                                        </tr>            					            					
                                    </tbody>            				
                                </table>
                                <div class="form-content">
                                    <form role="form"  id="send_motivo_{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" action="{$url}send_motivo_cancelacion.do" method="post"  onsubmit="return false;">
                                        <input type="hidden" name="idsolicitudRenovacionPerfilSaludMedicamento" value="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" />
                                        <textarea name="motivo" placeholder='{"Motivo"|x_translate}' style="height: auto; resize: vertical;">{$notificacion.motivo}</textarea>

                                        <br><br>
                                        <p>
                                            {if $notificacion.aceptado == 0}
                                                <button class="btn btn-primary enviar_motivo"  data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" style="min-width:150px">{"enviar"|x_translate}</button>
                                            {/if}
                                            <a  href="javascript:;" data-id="{$notificacion.idsolicitudRenovacionPerfilSaludMedicamento}" data-idnotificacion="{$notificacion.idnotificacion}" class="btn btn-inverse btn-slider" data-target="opcion-renovacion">{"cancelar"|x_translate}</a>

                                        </p>
                                    </form>
                                </div>
                            </div>
                            <!-- /opcion-rechazar-renovacion -->
                        {/if}
                    </div>
                </div>
            </div>                
        </div>

    </div>


{/if}