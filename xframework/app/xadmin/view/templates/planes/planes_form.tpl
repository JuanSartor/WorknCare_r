<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">PLAN &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=planes&submodulo=planes_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idprograma_salud_plan" id="idprograma_salud_plan" value="{$record.idprograma_salud_plan}" />

                    <div class="form_container ">
                        <div class="title">Datos del Plan</div>
                        <ul>

                            <li class="left">
                                <label>Nombre</label> 
                                {x_form_input  id="nombre" descriptor="none"  isRequired="true"  maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="right">
                                <label>Precio</label> 
                                {x_form_input  id="precio" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li> 
                            <li class="left text">
                                <label>Primer Texto</label> 
                                {x_form_input  id="primer_texto_card" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="left text">
                                <label>Segundo Texto</label> 
                                {x_form_input  id="segundo_texto_card" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                            </li>
                            <li class="left text">
                                <label>Tercer Texto</label> 
                                {x_form_input  id="tercer_texto_card" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                            </li>
                            <li class="left text">
                                <label>Primer Texto (en)</label> 
                                {x_form_input  id="primer_texto_card_en" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="left text">
                                <label>Segundo Texto (en)</label> 
                                {x_form_input  id="segundo_texto_card_en" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                            </li>
                            <li class="left text">
                                <label>Tercer Texto (en)</label> 
                                {x_form_input  id="tercer_texto_card_en" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
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