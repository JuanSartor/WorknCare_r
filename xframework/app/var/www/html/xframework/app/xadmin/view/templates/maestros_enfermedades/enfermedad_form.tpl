<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">ENFERMEDAD &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_enfermedades&submodulo=enfermedad_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idenfermedad" id="idenfermedad" value="{$record.idenfermedad}" />

                    <div class="form_container ">
                        <div class="title">Datos de la Enfermedad</div>
                        <ul>

                            <li class="wide">
                                <label>Nombre Enfermedad * </label> 
                                {x_form_input  id="enfermedad" descriptor="none" isRequired="true" maxChars=75 class="" record=$record} 
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