
<div id="item-{$notificacion.idnotificacion}" class="item nt-mensaje ">
    <div class="item-wrap">
        <span class="dp-email item-cat item-open" data-click-state="0">
            {if $notificacion.leido != 1} 
                <i class="fa fa-exclamation-circle no-leido" ></i>
            {/if}
        </span>
        <label class="checkbox chk-eliminar" ><input type="checkbox" value="{$notificacion.idnotificacion}" class="class_checkbox_seleccion" /></label>

        <div class="row">
            <a href="javascript:;" id="btn_plus_{$notificacion.idnotificacion}" data-idnotificacion="{$notificacion.idnotificacion}" class="icon-toggle item-open" data-click-state="0"><i class="fa fa-plus" aria-hidden="true"></i></a>	

            <div class="col-md-4">
                <h5><strong>{$notificacion.titulo}</strong></h5>
                <p>{$notificacion.fechaNotificacion_format}</p>
            </div>	
            <div class="col-md-8">
                <div class="item-contenido">

                    <p class="preview-mensaje">{$notificacion.descripcion|escape}</p>
                    {if $notificacion.file && $notificacion.file|@count > 0}
                        <div class="thumbs">
                            {foreach from=$notificacion.file item=estudio}
                                {foreach from=$estudio item=file_estudio}
                                    <a href="{$file_estudio.path_images}" class="gallery">
                                        <img src="{$file_estudio.path_images_list}" alt="{$file_estudio.nombre_archivo}" height="84" width="111">
                                    </a>
                                {/foreach}
                            {/foreach}
                        </div>
                    {/if}

                    {if $notificacion.mensajes_anteriores|@count >0}

                        {*<p>{"Conversación:"|x_translate}</p>*}
                        <div class="respuestas-container">
                            <hr>
                            {foreach from=$notificacion.mensajes_anteriores name=mensajes  item=respuesta}


                                <div class="item-contenido {if $respuesta.medico_idmedico==$account.medico.idmedico}text-left{else}text-right{/if}">
                                    <span> <small><em>{$respuesta.fechaNotificacion_format}</em> | {$respuesta.nombre} {$respuesta.apellido}:</small></span>
                                    <p>
                                        {$respuesta.descripcion|escape}
                                    </p>
                                </div>
                                {if $respuesta.file && $respuesta.file|@count > 0}
                                    <div class="thumbs">
                                        {foreach from=$respuesta.file item=estudio}
                                            {foreach from=$estudio item=file_estudio}
                                                <a href="{$file_estudio.path_images}" class="gallery">
                                                    <img src="{$file_estudio.path_images_list}" alt="{$file_estudio.nombre_archivo}" height="84" width="111">
                                                </a>
                                            {/foreach}
                                        {/foreach}
                                    </div>
                                {/if}
                                {if $respuesta.archivos}
                                    <div class="form-content">
                                        <p>{"Archivos adjuntos"|x_translate}:</p>
                                        {foreach from=$respuesta.archivos item=archivorta}
                                            <p class="archivo-adjunto">
                                                <a href="{$url}{$controller}.php?action=1&modulo=notificaciones&submodulo=get_file_mensaje_medico&idnotificacion={$respuesta.idnotificacion}&filename={$archivorta}" target="_blank">
                                                    <i class="fa fa-paperclip"></i>{$archivorta}                                 
                                                </a>
                                            </p>
                                        {/foreach}
                                    </div>
                                {/if}

                            {/foreach}

                        </div>
                    {/if}
                    <div class="form-content">
                        <form role="form" id="responder_mensaje_{$notificacion.idnotificacion}" action="{$url}responder_mensaje.do" method="post"  onsubmit="return false;">
                            <input type="hidden" name="notificacion_idnotificacion" value="{$notificacion.idnotificacion}" /> 
                            <textarea id="texto_responder_mensaje_{$notificacion.idnotificacion}" name="respuesta" placeholder='{"Responder"|x_translate}'style="height: auto; resize: vertical;"></textarea>
                            <div class="text-center">
                                <button class="btn btn-primary btnEnviarRespuesta" data-id="{$notificacion.idnotificacion}">{"enviar"|x_translate}&nbsp;<i class="fa fa-chevron-right"></i></button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="clear-fix">&nbsp;</div>
                <div class="button-container text-center">
                    <button class="btn btn-xs btn-secondary btn-responder-mensaje" data-id="{$notificacion.idnotificacion}">{"Responder"|x_translate}</button>
                </div>
            </div>
        </div>                
    </div>
</div>