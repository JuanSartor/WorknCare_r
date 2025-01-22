<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">PINES PACIENTE &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=configuracion&submodulo=pinesPaciente_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idpackPinesPaciente" id="idpackPinesPaciente" value="{$record.idpackPinesPaciente}" />

                    <div class="form_container ">
                        <div class="title">Datos de los Pines del Paciente</div>
                        <ul>
                            <li class="wide">
                                <label>Cantidad de SMS *</label> 
                                {x_form_input  id="cantidadPines" descriptor="integer" isRequired="true" maxChars=11 class="" record=$record} 
                            </li>
&nbsp;
                            <li class="wide">
                                <label>Precio Pack ($)* </label> 
                                {x_form_input  id="precioPack" descriptor="real" isRequired="true" maxChars=11 class="" record=$record} 
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