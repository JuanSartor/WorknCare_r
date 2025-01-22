<style>
    .notificaciones-container .item.nt-turno .item-options i{
        font-size: 16px;
        position: relative;
        top: -1px;
        line-height: 1;
    }
    .notificaciones-container .item.nt-turno .item-options i:before {
        color: #415b70;
        font-size: 16px;
        margin-right: 3px;
    }
</style>
<div id="item-{$notificacion.idnotificacion}" class="item nt-turno">
    <div class="item-wrap">

        <span class="dpp-turnos item-cat item-open" data-click-state="0">
            {if $notificacion.leido != 1} 
                <i class="fa fa-exclamation-circle no-leido" ></i>
            {/if}
        </span>
        <label class="checkbox chk-eliminar" ><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" /></label>

        <div class="row ">
            {if $notificacion.mensajes.mensaje!="" || $notificacion.estado_turno == 2}
                <a href="javascript:;" class="icon-toggle item-open consultorio" data-idturno="{$notificacion.turno_idturno}" data-idnotificacion="{$notificacion.idnotificacion}" data-estado="{$notificacion.estado_turno}" data-click-state="0">
                    <i class="fa fa-plus" aria-hidden="true"></i>
                </a>
            {/if}
            <div class="col-md-4 col-sm-4">
                {if $notificacion.estado_turno === "0"}
                    <h5 class="turno-pendiente">{"Turno pendiente"|x_translate}</h5>
                {elseif $notificacion.estado_turno == 1}
                    <h5 class="turno-confirmado">{"Turno confirmado"|x_translate}</h5>
                {elseif $notificacion.estado_turno == 2}
                    <h5 class="turno-cancelado">{"Turno cancelado"|x_translate}</h5>
                {elseif $notificacion.estado_turno == 3}
                    <h5 class="turno-suspendido">{"Turno declinado"|x_translate}</h5>
                {elseif $notificacion.estado_turno == 5}
                    <h5 class="turno-suspendido">{"Paciente ausente"|x_translate}</h5>
                {elseif $notificacion.estado_turno == 6}
                    <h5 class="turno-reprogramado">{"Turno reprogramado"|x_translate}</h5>
                {/if}
                <p>{$notificacion.fechaNotificacion_format}</p>
            </div>	
            <div class="col-md-8 col-sm-8">
                <div class="item-contenido">
                    <p><strong>{"Paciente"|x_translate}:</strong> {$notificacion.paciente_nombre}</p>
                    <p><strong>{"Turno"|x_translate}:</strong> {$notificacion.descripcion}</p>
                    {if $notificacion.mensajes.mensaje!="" || $notificacion.estado_turno == 2}


                        <div class="mensajes">
                            <div>&nbsp;</div>
                            <div class="item-contenido text-left">
                                <p>
                                    <strong>{"Comentarios del paciente:"|x_translate}</strong>
                                    {if $notificacion.mensajes.mensaje!=""}
                                        {$notificacion.mensajes.mensaje|escape}
                                    {/if}
                                    {if $notificacion.estado_turno == 2 && $notificacion.mensaje_cancelacion_turno!=""}
                                        {$notificacion.mensaje_cancelacion_turno|escape}
                                    {/if}
                                </p>
                            </div>
                            {if $notificacion.mensajes.archivos_mensaje && $notificacion.mensajes.archivos_mensaje|@count > 0}
                                <div class="thumbs">
                                    {foreach from=$notificacion.mensajes.archivos_mensaje item=archivo}

                                        <a href="{$archivo.url}" class="gallery" target="_blank">
                                            <img src="{$archivo.path_images}" alt="{$archivo.nombre}" style="width:100px">
                                        </a>

                                    {/foreach}
                                </div>
                            {/if}



                        </div>
                    {/if}
                </div>
                {if $notificacion.turno_idturno!=""}
                    <div class="button-container text-center">
                        {if $notificacion.turno.estado==0 && $notificacion.estado_turno==0 && $notificacion.turno.paciente_idpaciente!="" && $notificacion.turno.paciente_idpaciente==$notificacion.paciente_idpaciente_emisor && $notificacion.turno.pasado!="1"}
                            <a href="javascript:;" data-redirect="{$url}medico.php?&modulo=agenda&submodulo=agenda_diaria&fecha={$notificacion.turno.fecha|date_format:"%d/%m/%Y"}&idconsultorio={$notificacion.turno.consultorio_idconsultorio}" class="btn btn-xs btn-default btn-primary btnCambiarEstadoTurno" data-idturno="{$notificacion.turno_idturno}" data-idnotificacion="{$notificacion.idnotificacion}" style="min-width:150px">
                                {"confirmar"|x_translate}
                            </a>
                        {/if}

                        <a href="{$url}medico.php?&modulo=agenda&submodulo=agenda_diaria&fecha={$notificacion.turno.fecha|date_format:"%d/%m/%Y"}&idconsultorio={$notificacion.turno.consultorio_idconsultorio}" class="btn btn-xs btn-default btn-inverse ">
                            {"ver agenda"|x_translate}
                        </a>
                    </div>
                {/if}

            </div>
        </div>                
    </div>
    <div class="item-options">
        <a data-idturno="{$notificacion.turno_idturno}" data-idnotificacion="{$notificacion.idnotificacion}" data-estado="{$notificacion.estado_turno}" href="javascript:;" class="consultorio">
            {$notificacion.item_options}
        </a>
    </div>              
</div>


