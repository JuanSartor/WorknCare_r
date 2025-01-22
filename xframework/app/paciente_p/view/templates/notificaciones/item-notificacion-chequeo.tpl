<div id="item-{$notificacion.idnotificacion}" class="item nt-chequeos " data-idnotificacion="{$notificacion.idnotificacion}" >
    <div class="item-wrap">
        <span class="dpp-chequeos item-cat">
            {if $notificacion.leido != 1} 
                <i class="fa fa-exclamation-circle no-leido" ></i>
            {/if}
        </span>
        <label class="checkbox chk-eliminar">
            <input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" >
        </label>
        <div class="row">
            <a href="javascript:;" class="icon-toggle item-open" data-idnotificacion="{$notificacion.idnotificacion}" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>	            	

            <div class="col-md-4 col-sm-4">
                <h5>{"Controles y Chequeos"|x_translate}</h5>
                <p>{$notificacion.fechaNotificacion_format}</p>
            </div>	
            <div class="col-md-8 col-sm-8">
                <div class="item-contenido">
                    <p><span class="np-text">{$notificacion.titulo}</span></p>
                </div>
            </div>
            </a>
        </div>                
    </div>
</div>