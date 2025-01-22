<div id="colRight">
    
    <div class="block">
        
        <div class="title_bar"><div class="text">INFORMACIÓN GEOGRÁFICA &raquo; {$pais.pais|strtoupper} &raquo; LOCALIDADES &raquo {if $record} EDITAR LOCALIDAD {else} NUEVA LOCALIDAD {/if}</div>   
            
            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="btnVolver" label="Volver" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">
            
            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
         
                
            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_localizacion&submodulo=localidad_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idlocalidad" id="idlocalidad" value="{$record.idlocalidad}" />
                    {if $record}
                       <input type="hidden" name="pais_idpais" id="pais_idpais" value="{$record.pais_idpais}" />
                          <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="pais_idpais={$record.pais_idpais}" />          
                    {else}
                       <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="pais_idpais={$smarty.request.pais_idpais}" />          
                       <input type="hidden" name="pais_idpais" id="pais_idpais" value="{$smarty.request.pais_idpais}" />
                    {/if}
                  
                        
                    <div class="form_container ">
                        <div class="title">Datos de la localidad</div>
                        <ul>
        
                            <li class="right">
                                <label>Localidad</label> 
                                {x_form_input  id="localidad" descriptor="none" isRequired="true" maxChars=45 class="" record=$record}
                            </li>  
                            <li class="left">
                                <label>C&oacute;digo postal</label> 
                                {x_form_input  id="cpa" descriptor="none" isRequired="true" maxChars=45 class="" record=$record}
                            </li> 
                                
                            <li class="clear">&nbsp;</li>
                                
                        </ul>
                    </div> 
                    <!-- -->
                    
                        
                        
                        
                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>