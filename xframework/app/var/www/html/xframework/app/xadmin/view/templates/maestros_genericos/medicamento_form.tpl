<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">MEDICAMENTO &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_genericos&submodulo=medicamento_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idmedicamento" id="idmedicamento" value="{$record.idmedicamento}" />

                    <div class="form_container ">
                        <div class="title">Medicamento</div>
                        <ul>
      
                            <li class="wide">
                                <label>Nombre Comercial * </label> 
                                {x_form_input  id="nombre_comercial" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
                            </li>  
                            
                            <li class="wide">
                                <label>Forma Farmaceutica * </label> 
                                {x_form_input  id="forma_farmaceutica" descriptor="none" isRequired="true" maxChars=200 class="" record=$record} 
                            </li>  
                            
                            <li class="wide">
                                <label>Presentación * </label> 
                                {x_form_input  id="presentacion" descriptor="none" isRequired="true" maxChars=200 class="" record=$record} 
                            </li>  
                            
                            <li class="wide">
                                <label>Genérico * </label> 
                                {x_form_input  id="generico" descriptor="none" isRequired="true" maxChars=350 class="" record=$record} 
                            </li>  
                            
                            <li class="left">
                                <label>Laboratorio</label> 
                                <select name="laboratorio_idlaboratorio" id="laboratorio_idlaboratorio" class="">
                                    {html_options options=$combo_laboratorio selected=$record.laboratorio_idlaboratorio}                           
                                </select>                 
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