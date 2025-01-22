<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">ENFERMEDAD &raquo; TIPO ENFERMEDAD  &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_enfermedades&submodulo=tipo_enfermedad_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idtipoEnfermedad" id="idtipoEnfermedad" value="{$record.idtipoEnfermedad}" />
                    <input type="hidden" name="enfermedad_idenfermedad" id="enfermedad_idenfermedad" value="{$enfermedad.idenfermedad}" />

                    <div class="form_container ">
                        <div class="title">Datos del Tipo de enfermedad</div>
                        <ul>

                            <li class="wide">
                                <label>Enfermedad</label>
                                <span class="lbl" id="pre_id" >{$enfermedad.enfermedad}</span>
                            </li>
                            
                            <li class="wide">
                                <label>Tipo enfermedad* </label> 
                                {x_form_input  id="tipoEnfermedad" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
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