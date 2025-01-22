<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">VACUNA &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=vacunas&submodulo=vacuna_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idvacuna" id="idvacuna" value="{$record.idvacuna}" />

                    <div class="form_container ">
                        <div class="title">Vacuna</div>
                        <ul>
                        	
                            <li class="wide">
                                <label>Vacuna * </label> 
                                {x_form_input  id="vacuna" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
                            </li> 
                            
                            <li class="wide">
                                <label>Descripción </label> 
                                {x_form_input  id="descripcion" descriptor="none" isRequired="false" maxChars=250 class="" record=$record} 
                            </li>
                             <li class="left">
                                 <label>Activo <input type="checkbox" value="1" name="activo" {if $record.activo}checked{/if} /></label> 
                            </li>
                             <li class="right">
                                 <label>Genera Notificaci&oacute;n <input type="checkbox" value="1" name="genera_notificacion" {if $record.genera_notificacion}checked{/if} /></label> 
                            </li>
                            
                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>


                    <div class="clear">&nbsp;</div>


                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>