<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">OBRA SOCIAL - PREPAGA &raquo; PLANES  &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_os&submodulo=maestros_planes_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idplanObraSocial" id="idplanObraSocial" value="{$record.idplanObraSocial}" />
                    <input type="hidden" name="obraSocial_idobraSocial" id="obraSocial_idobraSocial" value="{$obraSocial.idobraSocial}" />

                    <div class="form_container ">
                        <div class="title">Datos de la Obra Social</div>
                        <ul>
                        	
                        	<li class="wide">
								<label>Obra Social / Prepaga</label>
								<span class="lbl" id="pre_id" >{$obraSocial.nombre} {if $obraSocial.siglas!=""} - {$obraSocial.siglas} {/if}</span>
							</li>

							                        	
                            
                            <li class="wide">
                                <label>Nombre * </label> 
                                {x_form_input  id="nombrePlan" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
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