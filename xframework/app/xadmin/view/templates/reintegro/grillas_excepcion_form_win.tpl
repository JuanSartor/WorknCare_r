
<div class="top">&nbsp;</div>
<div class="contenido">



    <div class="xForm ">

        <form action="{$controller}.php?action=1&modulo=reintegro&submodulo=grillas_excepcion_form"  method="post"  name="f_record_excepcion" id="f_record_excepcion" >
            <input type="hidden" name="idgrilla_excepcion" id="idgrilla_excepcion" value="{$smarty.request.id}" />
             <input type="hidden" name="grilla_idgrilla" id="grilla_idgrilla" value="" />

            <div class="form_container ">
                <div class="title">Excepción de tarifa</div>
                <ul>
                    <li class="left">
                        <label>Código * </label> 
                        {x_form_input  id="excepcion_codigo" descriptor="none" name="codigo" isRequired="true" maxChars=255 class="" record=$record} 
                    </li>  
                    <li class="right">
                         <label>Especialidad * </label> 
                        <select id="especialidad_idespecialidad" name="especialidad_idespecialidad" required>
                            <option value="" >Seleccione</option>
                            {html_options options=$combo_especialidades selected=$record.especialidad_idespecialidad}
                        </select>
                    </li> 

                    <li class="wide" >
                        <label>Sector 1 * </label> 
                        <select id="excepcion_sector1" name="sector1" required>
                            <option value="0" {if $record.sector1==0}selected{/if}>No aplica</option>
                            <option value="1" {if $record.sector1==1}selected{/if}>Tarifa</option>
                            <option value="2" {if $record.sector1==2}selected{/if}>Libre</option>
                        </select>
                    </li>  

                    <li id="div_excepcion_condicion_sector1" class="left" {if $record.sector1!=1}style="display:none;"{/if}>
                        <label>Condición Tarifa * </label> 
                        <select id="excepcion_condicion_sector1" name="condicion_sector1">
                            <option value="1" {if $record.condicion_sector1==1}selected{/if}>Igual a</option>
                            <option value="2" {if $record.condicion_sector1==2}selected{/if}>Máximo</option>
                            <option value="3" {if $record.condicion_sector1==3}selected{/if}>Mínimo</option>
                        </select>
                    </li>  
                    <li id="div_excepcion_tarifa_sector1" class="right" {if $record.sector1!=1}style="display:none;"{/if} >
                        <label>Tarifa Sector 1 (&euro;)</label> 
                        {x_form_input  id="excepcion_valor_sector1" name="valor_sector1" descriptor="none" isRequired="" maxChars=255 class="" record=$record} 
                    </li>  
                    <div class="clear"> &nbsp; </div>
                    <li class="wide" >
                        <label>Sector 2 * </label> 
                        <select id="excepcion_sector2" name="sector2" required>
                            <option value="0" {if $record.sector2==0}selected{/if}>No aplica</option>
                            <option value="1" {if $record.sector2==1}selected{/if}>Tarifa</option>
                            <option value="2" {if $record.sector2==2}selected{/if}>Libre</option>
                        </select>
                    </li>  

                    <li id="div_excepcion_condicion_sector2"class="left" {if $record.sector2!=1}style="display:none;"{/if}>
                        <label>Condición Tarifa * </label> 
                        <select id="excepcion_condicion_sector2" name="condicion_sector2">
                            <option value="1" {if $record.condicion_sector2==1}selected{/if}>Igual a</option>
                            <option value="2" {if $record.condicion_sector2==2}selected{/if}>Máximo</option>
                            <option value="3" {if $record.condicion_sector2==3}selected{/if}>Mínimo</option>
                        </select>
                    </li>  
                    <li id="div_excepcion_tarifa_sector2" class="right" {if $record.sector2!=1}style="display:none;"{/if}>
                        <label>Tarifa Sector 2 (&euro;) </label> 
                        {x_form_input  id="excepcion_valor_sector2"  name="valor_sector2" descriptor="none" isRequired="" maxChars=255 class="" record=$record} 
                    </li> 
                    <div class="clear"> &nbsp; </div>
                    <li class="wide" >
                        <label>Optam * </label> 
                        <select id="excepcion_optam" name="optam" required>
                            <option value="0" {if $record.optam==0}selected{/if}>No aplica</option>
                            <option value="1" {if $record.optam==1}selected{/if}>Tarifa</option>
                            <option value="2" {if $record.optam==2}selected{/if}>Libre</option>
                        </select>
                    </li>  

                    <li id="div_excepcion_condicion_optam" class="left"  {if $record.optam!=1}style="display:none;"{/if}>
                        <label>Condición Tarifa * </label> 
                        <select id="excepcion_condicion_optam" name="condicion_optam">
                            <option value="1" {if $record.condicion_optam==1}selected{/if}>Igual a</option>
                            <option value="2" {if $record.condicion_optam==2}selected{/if}>Máximo</option>
                            <option value="3" {if $record.condicion_optam==3}selected{/if}>Mínimo</option>
                        </select>
                    </li>  
                    <li id="div_excepcion_tarifa_optam" class="right" {if $record.optam!=1}style="display:none;"{/if}>
                        <label>Tarifa Optam (&euro;) </label> 
                        {x_form_input  id="excepcion_valor_optam"  name="valor_optam" descriptor="none" isRequired="" maxChars=255 class="" record=$record} 
                    </li>  

                </ul>

                <div class="clear">&nbsp;</div> 

                <ul>
                    <li class="tools">
                        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
                        {x_form_html_button id="btnGuardarExcepcion" label="Guardar" w="100" type="button" class="icon save"}
                    </li>

                </ul>

                <div class="clear">&nbsp;</div> 
            </div> 
            <div class="clear">&nbsp;</div>      
        </form>
    </div> 

</div>  

