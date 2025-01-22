{if $notificacion.notificacionSistema_idnotificacionSistema != ""}
    <div id="item-{$notificacion.idnotificacion}" class="item nt-info " data-idnotificacion="{$notificacion.idnotificacion}">
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
                    <h5>Info DoctorPlus</h5>
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
                    </div>              
                </div>
            </div>                
        </div>
    </div>
{elseif $notificacion.tipoNotificacion_idtipoNotificacion == "5" || $notificacion.tipoNotificacion_idtipoNotificacion == "7"}
    <div  id="item-{$notificacion.idnotificacion}" class="item nt-info " data-idnotificacion="{$notificacion.idnotificacion}">
        <div class="item-wrap">
            <span class="dpp-info item-cat">
                {if $notificacion.leido != 1} 
                    <i class="fa fa-exclamation-circle no-leido" ></i>
                {/if}
            </span>
            <label class="checkbox chk-eliminar" ><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion"></label>

            <div class="row">
                <a href="javascript:;" id="btn_plus_{$notificacion.idnotificacion}" data-idnotificacion="{$notificacion.idnotificacion}" class="icon-toggle item-open" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>	
                <div class="col-md-4 col-sm-4">
                    <h5>Info DoctorPlus</h5>
                    <p>{$notificacion.fechaNotificacion_format}</p>
                </div>	
                <div class="col-md-8 col-sm-8">
                    <div class="item-contenido">
                        <p>
                            {$notificacion.titulo}
                        </p>
                        <p><br><br></p>
                            {if $notificacion.tipoNotificacion_idtipoNotificacion == "5" && $notificacion.estado_invitacion!="1"}
                            <div class="form-content">
                                <p class="text-center">{"Aceptando la solicitud ud. podrá contactar  al Profesional mas fácilmente"|x_translate}</p>
                                <p><br></p>
                                <p class="text-center">		            				
                                    <button class="btn btn-inverse btn-slider respuesta_invitacion_medico" data-idnotificacion="{$notificacion.idnotificacion}" data-estado="1" >{"Aceptar"|x_translate}</button>
                                    <button class="btn btn-inverse btn-slider respuesta_invitacion_medico" data-idnotificacion="{$notificacion.idnotificacion}" data-estado="2" >{"Rechazar"|x_translate}</button>
                                </p>
                            </div>
                        {/if}

                    </div>            			
                </div>
            </div>                
        </div>

    </div>
{elseif $notificacion.tipoNotificacion_idtipoNotificacion == "8"} 
    <!-- MENSAJES-->
    {include file="notificaciones/item-notificacion-mensaje.tpl"}

{/if}