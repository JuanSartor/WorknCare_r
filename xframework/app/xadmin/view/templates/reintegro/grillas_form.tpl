
<div id="colRight">



    <div class="block">


        <div class="title_bar"><div class="text"> GRILLAS DE TARIFAS &raquo;  {if $record}EDITAR{else}NUEVO{/if}</div>   


            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}

            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />     
            <div class="end">
                &nbsp;
            </div>

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=reintegro&submodulo=grillas_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idgrilla" id="idgrilla" value="{$record.idgrilla}" />

                    <div class="form_container ">


                        <div class="title">Tarifas generales de la grilla</div>
                        <ul>
                            <li class="left">
                                <label>Grilla * </label> 
                                {x_form_input  id="grilla" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>  
                            
                            <li class="left">
                                <label>Código * </label> 
                                {x_form_input  id="codigo" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li> 
                            <li class="wide" >
                                <label>Sector 1 * </label> 
                                <select id="sector1" name="sector1" required>
                                    <option value="0" {if $record.sector1==0}selected{/if}>No aplica</option>
                                    <option value="1" {if $record.sector1==1}selected{/if}>Tarifa</option>
                                    <option value="2" {if $record.sector1==2}selected{/if}>Libre</option>
                                </select>
                            </li>  

                            <li id="div_condicion_sector1" class="left" {if $record.sector1!=1}style="display:none;"{/if}>
                                <label>Condición Tarifa * </label> 
                                <select id="condicion_sector1" name="condicion_sector1">
                                    <option value="1" {if $record.condicion_sector1==1}selected{/if}>Igual a</option>
                                    <option value="2" {if $record.condicion_sector1==2}selected{/if}>Máximo</option>
                                    <option value="3" {if $record.condicion_sector1==3}selected{/if}>Mínimo</option>
                                </select>
                            </li>  
                            <li id="div_tarifa_sector1" class="right" {if $record.sector1!=1}style="display:none;"{/if} >
                                <label>Tarifa Sector 1 (&euro;)</label> 
                                {x_form_input  id="valor_sector1" descriptor="integer" isRequired="" maxChars=255 class="" record=$record} 
                            </li>  
                            <div class="clear"> &nbsp; </div>
                            <li class="wide" >
                                <label>Sector 2 * </label> 
                                <select id="sector2" name="sector2" required>
                                    <option value="0" {if $record.sector2==0}selected{/if}>No aplica</option>
                                    <option value="1" {if $record.sector2==1}selected{/if}>Tarifa</option>
                                    <option value="2" {if $record.sector2==2}selected{/if}>Libre</option>
                                </select>
                            </li>  

                            <li id="div_condicion_sector2"class="left" {if $record.sector2!=1}style="display:none;"{/if}>
                                <label>Condición Tarifa * </label> 
                                <select id="condicion_sector2" name="condicion_sector2">
                                    <option value="1" {if $record.condicion_sector2==1}selected{/if}>Igual a</option>
                                    <option value="2" {if $record.condicion_sector2==2}selected{/if}>Máximo</option>
                                    <option value="3" {if $record.condicion_sector2==3}selected{/if}>Mínimo</option>
                                </select>
                            </li>  
                            <li id="div_tarifa_sector2" class="right" {if $record.sector2!=1}style="display:none;"{/if}>
                                <label>Tarifa Sector 2 (&euro;) </label> 
                                {x_form_input  id="valor_sector2" descriptor="integer" isRequired="" maxChars=255 class="" record=$record} 
                            </li> 
                            <div class="clear"> &nbsp; </div>
                            <li class="wide" >
                                <label>Optam * </label> 
                                <select id="optam" name="optam" required>
                                    <option value="0" {if $record.optam==0}selected{/if}>No aplica</option>
                                    <option value="1" {if $record.optam==1}selected{/if}>Tarifa</option>
                                    <option value="2" {if $record.optam==2}selected{/if}>Libre</option>
                                </select>
                            </li>  

                            <li id="div_condicion_optam" class="left"  {if $record.optam!=1}style="display:none;"{/if}>
                                <label>Condición Tarifa * </label> 
                                <select id="condicion_optam" name="condicion_optam">
                                    <option value="1" {if $record.condicion_optam==1}selected{/if}>Igual a</option>
                                    <option value="2" {if $record.condicion_optam==2}selected{/if}>Máximo</option>
                                    <option value="3" {if $record.condicion_optam==3}selected{/if}>Mínimo</option>
                                </select>
                            </li>  
                            <li id="div_tarifa_optam" class="right" {if $record.optam!=1}style="display:none;"{/if}>
                                <label>Tarifa Optam (&euro;) </label> 
                                {x_form_input  id="valor_optam" descriptor="integer" isRequired="" maxChars=255 class="" record=$record} 
                            </li>  
                              <li class="wide" >
                                <label>Descripción </label> 
                                <textarea id="descripcion" name="descripcion" rows="5">{$record.descripcion}</textarea>
                              
                              </li>

                        </ul>
                        <div class="clear">
                            &nbsp;
                        </div>
                         <div class="clear">
                            &nbsp;
                        </div>
                         <div class="clear">
                            &nbsp;
                        </div>
                    </div>

                </form>

            </div>
            {if $record}
            <div  class="xTable" id="xTable">

                <div class="container">		
                    {x_form_html_button id="btnAddExcepcion" label="Agregar excepción" w="100" type="button" class="icon add"}
                    <table id="list">
                    </table> 

                    <div id="pager"></div>

                </div>     


            </div> 
            {/if}

        </div> 
        <div class="end">
            &nbsp;
        </div>
    </div>  

</div>
