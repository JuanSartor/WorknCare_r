<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">VACUNA POR EDAD / GRUPO &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=vacunas&submodulo=vacuna_edad_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idvacunaEdad" id="idvacunaEdad" value="{$record.idvacunaEdad}" />

                    <div class="form_container ">
                        <div class="title">Vacuna Edad</div>
                        <ul>

                            <li class="wide">
                                <label>Edad * </label> 
                                {x_form_input  id="edad" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
                            </li> 

                            <li class="left">
                                <label>Unidades</label> 
                                <select name="unidadTemporal_idunidadTemporal" id="unidadTemporal_idunidadTemporal" class="">
                                    <option value="">Ninguna...</option>
                                    {html_options options=$combo_unidad_temporal selected=$record.unidadTemporal_idunidadTemporal}                           
                                </select>
                            </li>

                            <li class="right">
                                <label>Valor Unidad </label> 
                                {x_form_input  id="valor_unidad" descriptor="integer" isRequired="false" maxChars=11 class="" record=$record} 
                            </li>
                            <li class="right">
                                <label>Tiempo en meses </label> 
                                {x_form_input  id="tiempo_meses" descriptor="integer" isRequired="false" maxChars=11 class="" record=$record} 
                            </li>


                        </ul>
                        <div class="clear">&nbsp;</div> 
                    </div>
                    <div class="clear">&nbsp;</div>
                </form>
            </div> 


            {if $record}
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=vacunas&submodulo=vacuna_edad_relacion_form" target="_blank"  method="post"  name="f_add_relacion" id="f_add_relacion" >
                    <input type="hidden" name="vacunaEdad_idvacunaEdad" value="{$record.idvacunaEdad}" />
                    <div class="form_container ">
                        <div class="title">Agregar Vacuna a la edad / grupo</div>
                        <ul>
                           

                            <li class="wide">
                                <label>Vacunas</label> 
                                <select name="vacuna_idvacuna" id="vacuna_idvacuna" required class="">
                                    <option value="">Seleccione vacuna...</option>
                                    {html_options options=$combo_vacunas}                           
                                </select>
                            </li>
                            <li class="wide">
                                <label>Tipo aplicación</label> 
                                <select name="clase" id="clase" required class="">
                                  
                                    <option value="va-unica-dosis" {if $record.clase=="va-unica-dosis"}checked{/if}>Única dosis</option>
                                    <option value="va-primer-dosis" {if $record.clase=="va-primer-dosis"}checked{/if}>1&deg; dosis</option>
                                    <option value="va-segunda-dosis" {if $record.clase=="va-segunda-dosis"}checked{/if}>2&deg; dosis</option>
                                    <option value="va-tercera-dosis" {if $record.clase=="va-tercera-dosis"}checked{/if}>3&deg; dosis</option>
                                    <option value="va-cuarta-dosis" {if $record.clase=="va-cuarta-dosis"}checked{/if}>4&deg; dosis</option>
                                    <option value="va-refuerzo" {if $record.clase=="va-refuerzo"}checked{/if}>Refuerzo</option>
                                    <option value="va-esquema"  {if $record.clase=="va-esquema"}checked{/if}>Iniciar o completar esquema</option>
                                    <option value="va-anual-dosis" {if $record.clase=="a-anual-dosis"}checked{/if}>Dosis anual</option>
                                </select>
                            </li>
                             <li class="wide">
                                <label>Descripcion</label> 
                                {x_form_input  id="descripcion" descriptor="none" isRequired="false" maxChars=100 class="" record=$record} 
                            </li> 
                          {*  <li class="wide">
                                <label>Referencia númerica</label> 
                                <select name="ref_num" id="ref_num" required class="">
                                    <option value="">Seleccione...</option>
                                    <option value="(1)" {if $record.ref_num=="(1)"}checked{/if}>(1)Se inicia esquema: 3 dosis (0-1-6 meses) </option>
                                    <option value="(2)" {if $record.ref_num=="(2)"}checked{/if}>(2)Niños desde 6 meses hasta 24 meses de edad. </option>
                                    <option value="(3)" {if $record.ref_num=="(3)"}checked{/if}>(3)En cualquier trimestre de la gestación. <</option>
                                    <option value="(4)" {if $record.ref_num=="(4)"}checked{/if}>(4)Madres de niños menores de 6 meses (si no la hubieran recibido durante el embarazo) </option>
                                    <option value="(5)" {if $record.ref_num=="(5)"}checked{/if}>(5)Se indica 1 dosis a partir de la semana 20 de gestación </option>
                                    <option value="(6)" {if $record.ref_num=="(6)"}checked{/if}>(6)Se indica 1 dosis a quienes atienden a niños menores de 1 año. </option>
                                    <option value="(7)" {if $record.ref_num=="(7)"}checked{/if}>(7)Se indica refuerzo cada 10 años. </option>
                                    <option value="(8)" {if $record.ref_num=="(8)"}checked{/if}>(8)Niñas de 11 años de edad: 3 dosis (0-1-6 meses o 0-2-6 meses) </option>
                                    <option value="(9)" {if $record.ref_num=="(9)"}checked{/if}>(9)Si no hubiera recibido 2 dosis de Triple Viral o 1 dosis de Doble Viral </option>
                                    <option value="(10)" {if $record.ref_num=="(10)"}checked{/if}>(10)Residentes en zonas de riesgo </option>
                                    <option value="(11)" {if $record.ref_num=="(11)"}checked{/if}>(11)Residentes en zonas de riesgo. Unico refuerzo a los 10 años de la 1º dosis</option>

                                </select>
                            </li>
                            *}
                            

                          

                    
                            <li class="clear"></li>

                            <li class="wide">           
                                {x_form_html_button id="btnGuardarRelacion" label="Agregar Relación" class="icon add" w="100" type="button"} 
                            </li>
                        </ul>
                    </div>
                    <div class="clear">&nbsp;</div>
                </form>
            </div>

            <div  class="xTable" id="xTable">

                <div class="container">		

                    <table id="list">
                    </table> 

                    <div id="pager"></div>

                </div>     
            </div>
            {/if}

        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>