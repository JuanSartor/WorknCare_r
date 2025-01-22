{if $notificacion.tipoNotificacion_idtipoNotificacion == "4"}
    <div id="item-{$notificacion.idnotificacion}" class="item nt-info ">
        <div class="item-wrap">
            <span class="dpp-info item-cat">
                {if $notificacion.leido != 1} 
                    <i class="fa fa-exclamation-circle no-leido" ></i>
                {/if}
            </span>
            <label class="checkbox chk-eliminar"><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" ></label>

            <div class="row">
                <a href="javascript:;" class="icon-toggle item-open" data-idnotificacion="{$notificacion.idnotificacion}" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>	            	
                <div class="col-md-4 col-sm-4">
                    <h5>{"Info DoctorPlus"|x_translate}</h5>
                    <p>{$notificacion.fechaNotificacion_format}</p>
                </div>	
                <div class="col-md-8 col-sm-8">
                    <div class="item-contenido " id="div_cut_class_{$notificacion.notificacionSistema_idnotificacionSistema}">
                        <p>
                            {$notificacion.titulo}
                        </p>
                        <p>
                            <span  class="esp_list">
                                {$notificacion.descripcion|escape}
                            </span>
                        </p>
                        {if $notificacion.url != ""}
                            <br>
                            <br>
                            <p>
                                <a target="_blank" href="{$notificacion.url}">{"Ver Más"|x_translate}</a>
                            </p>
                        {/if}

                        {if $notificacion.prestador_idprestador!=""}
                            <div class="form-content">
                                <p class="text-center"></p>
                                <p><br></p>
                                <p class="text-center">		            				
                                    <button class="btn btn-inverse btn-slider respuesta_invitacion_prestador" data-idprestador="{$notificacion.prestador_idprestador}" data-estado="1" >{"Aceptar"|x_translate}</button>
                                    <button class="btn btn-inverse btn-slider respuesta_invitacion_prestador" data-idprestador="{$notificacion.prestador_idprestador}" data-estado="2" >{"Rechazar"|x_translate}</button>
                                </p>
                            </div>
                        {/if}
                    </div>              
                </div>
            </div>                
        </div>

    </div>

{else}
    <div id="item-{$notificacion.idnotificacion}"  class="item nt-info ">
        <div class="item-wrap">
            <span class="dpp-info item-cat" data-click-state="0">
                {if $notificacion.leido != 1} 
                    <i class="fa fa-exclamation-circle no-leido" ></i>
                {/if}
            </span>
            <label class="checkbox chk-eliminar" ><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" /></label>

            <div class="row">
                <a href="javascript:;" class=" item-open" data-idnotificacion="{$notificacion.idnotificacion}" data-click-state="0">
                    <div class="col-md-4">
                        <h5>{"Info DoctorPlus"|x_translate}</h5>
                        <p>{$notificacion.fechaNotificacion_format}</p>
                    </div>	
                    <div class="col-md-8">

                        <div class="item-contenido " >
                            <h5>
                                {$notificacion.titulo}
                            </h5>
                            <p>
                                {$notificacion.descripcion|escape}
                            </p>
                        </div>  
                    </div>
                </a>
            </div>  

        </div>
    </div>
{/if}