<style>
    .textareaw{
        width: 200px;
    }
</style>
<div id="colRight">

    <div class="block">
        <div class="title_bar" style="margin-top: -60px" ><div class="text">CHEQUEO REEMBOLSO</div>
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm " style="margin-top: 10px;">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=reembolso_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idreembolso" id="idreembolso" value="{$reembolso.idReembolso}" />
                    <input type="hidden" name="usuarioWeb_idusuarioweb" id="usuarioWeb_idusuarioweb" value="{$reembolso.usuarioWeb_idusuarioweb}" />

                    <div class="form_container ">
                        <div class="title">Reembolsos</div>
                        <div class="clear">&nbsp;</div> 
                        <hr>
                        <div class="row">
                            <!-- columna de las imagenes -->
                            <div class="col-6">
                                <div class="row">
                                    <label style="width: 200px;">{"Pendientes"|x_translate} </label> 
                                </div>
                                {include file="contable/imagenes_reembolso.tpl"}

                                <div class="clear">&nbsp;</div>
                                <div class="clear">&nbsp;</div>
                                <div class="row-derecha" style="margin-top:170px;">
                                    {x_form_html_button id="rechazar" label={"Rechazar"|x_translate} w="100" type="button" class="primary icon remove"}
                                </div>
                                <div class="clear">&nbsp;</div>
                                <div class="row-derecha" id="label_motivo" {if $reembolso.comentario == '' }style="visibility:hidden;" {else}style="visibility:visible;" {/if}>
                                    <label>{"Motivo"|x_translate} </label> 
                                </div>
                                <div class="row-derecha" id="input_motivo" {if $reembolso.comentario == '' }style="visibility:hidden;" {else}style="visibility:visible;" {/if}>
                                    {x_form_textarea name="motivo" id="motivo"  descriptor="none"  isRequired="false" maxChars=255 class="textareaw" value=$reembolso.comentario} 
                                </div>
                                <div class="clear">&nbsp;</div>
                                <div class="clear">&nbsp;</div>
                                {if $reembolso.usuarioweb_idusuariowebResponsable == '' }
                                    <div class="row-derecha" id="btn_confimar" style="visibility:hidden;">
                                        {x_form_html_button id="confirmar"  label={"Confirmar"|x_translate}  type="button" class="primary icon trash"}
                                    </div>
                                {/if}
                            </div>
                            <!-- columna de inputs -->
                            <div class="contenedor-derecho">
                                {if $reembolso.comentario == '' }
                                    <div class="row-derecha">
                                        <label>{"Socio"|x_translate} </label> 
                                    </div>
                                    <div class="row-derecha">
                                        <select name="id_programa" id="id_programa" class="">
                                            <option value="">Seleccionar...</option>
                                            {foreach from=$listado_grupo_programas_socios item=programa}
                                                {if $reembolso.programaSalud_idprogramasalud == $programa.idprograma_salud }
                                                    <option selected value={$programa.idprograma_salud}>{$programa.programa_salud}</option>
                                                {else}
                                                    <option value={$programa.idprograma_salud}>{$programa.programa_salud}</option> 
                                                {/if}
                                            {/foreach}
                                        </select>   
                                    </div>
                                    <div class="clear">&nbsp;</div>
                                    <div class="row-derecha">
                                        <label>{"Importe a reembolsar"|x_translate} </label> 
                                    </div>
                                    <div class="row-derecha">
                                        {x_form_input value=$reembolso.monto  id="importe_reintegro" name="importe_reintegro" descriptor="real" isRequired="false" maxChars=45 class="text"} 
                                    </div>
                                {/if}
                                <div class="clear">&nbsp;</div>
                                <div class="clear">&nbsp;</div>
                                {if $reembolso.usuarioweb_idusuariowebResponsable == '' }
                                    <div class="row-derecha">
                                        {x_form_html_button id="aprobar" label={"Validar"|x_translate} w="100" type="button" class="primary icon approve"}
                                    </div>
                                {/if}
                            </div>
                        </div>
                        <div class="clear">&nbsp;</div> 
                    </div>
                    <div class="clear">&nbsp;</div>
                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>