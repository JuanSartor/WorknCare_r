<div class="item nt-renovacion-receta" >
    <div id="item-{$notificacion.idnotificacion}" class="item-wrap" data-idnotificacion="{$notificacion.idnotificacion}">
        <span class="dpp-renovar-receta item-cat">
            {if $notificacion.leido != 1} 
                <i class="fa fa-exclamation-circle no-leido" ></i>
            {/if}
        </span>
        <label class="checkbox chk-eliminar" ><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" ></label>

        <div class="row">
            <a href="javascript:;" id="btn_plus_renovacion_{$notificacion.idnotificacion}"  class="icon-toggle item-open"  data-idnotificacion="{$notificacion.idnotificacion}" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>	
            <div class="col-md-4">
                <h5>{"Solicitud de Renovación de Receta"|x_translate}</h5>
                <p>{$notificacion.fechaNotificacion_format}</p>
            </div>	
            <div class="col-md-8">
                <div class="item-contenido">
                    {if $notificacion.aceptado == 1}
                        <p><strong>{"Su renovación de receta fue aceptada"|x_translate}</strong>.
                            <br> 
                            <br> 
                            {"La misma podrá ser retirada en el horario de consultorio del profesional"|x_translate}
                        </p>
                    {else}
                        <p>
                            <span class="text-danger">{"Su renovación de receta fue rechazada."|x_translate}</span>
                        </p>
                    {/if}

                    <div class="table-responsive " >
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
                                {if $notificacion.aceptado != 1}
                                    <tr>
                                        <td>{"Motivo"|x_translate}</td>
                                        <td>{$notificacion.motivo}</td>
                                    </tr> 	
                                {/if}
                            </tbody>            				
                        </table>
                    </div>



                </div>
            </div>
        </div>                
    </div>
</div>