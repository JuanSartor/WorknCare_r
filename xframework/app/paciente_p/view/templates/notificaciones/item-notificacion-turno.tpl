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

<div id="item-{$notificacion.idnotificacion}" class="item nt-turno" data-idnotificacion="{$notificacion.idnotificacion}" >
    <div class="item-wrap">
        <span class="dpp-turnos item-cat">
            {if $notificacion.leido != 1} 
                <i class="fa fa-exclamation-circle no-leido" ></i>
            {/if}
        </span>
        <label class="checkbox chk-eliminar" >
            <input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" >
        </label>   
        <div class="row">
            {*<a href="javascript:;" class="icon-toggle item-open"  data-idnotificacion="{$notificacion.idnotificacion}" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>*}

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
                    <h5 class="turno-cancelado">{"Paciente ausente"|x_translate}</h5>
                {/if}
                <p>{$notificacion.fechaNotificacion_format}</p>
            </div>	
            <div class="col-md-8 col-sm-8">

                <div class="item-contenido" style="height: auto" >
                    <p>{"Profesional"|x_translate}: {$notificacion.medico_nombre}
                        <span  class="esp_list">
                            {$notificacion.medico_especialidad}
                        </span>
                    </p>
                    <p>{$notificacion.descripcion}</p>
                </div>
                {if $notificacion.turno_idturno!="" && $notificacion.estado_turno != 2}
                    <div class="button-container text-center">
                      <a href="{$url}panel-paciente/detalle-turno.html?idturno={$notificacion.turno_idturno}" class="btn btn-xs btn-default btn-secondary ">{"ver detalle"|x_translate}</a>
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

