<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">BANCO &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_banco&submodulo=banco_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idbanco" id="idbanco" value="{$record.idbanco}" />

                    <div class="form_container ">
                        <div class="title">Datos del Banco</div>
                        <ul>
                        
                            <li class="wide">
                                <label>Nombre Banco * </label> 
                                {x_form_input  id="nombre_banco" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
                            </li>  
                             <li class="left">
                                <label>Código * </label> 
                                {x_form_input  id="codigo" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
                            </li>  
                             <li class="right">
                                <label>Pais * </label> 
                                <select name='pais_idpais' id='pais_idpais' required>
                                    <option value=''>Seleccione...</option>
                                    <option value='1' {if $record.pais_idpais==1}selected{/if}>France</option>
                                    <option value='2' {if $record.pais_idpais==2}selected{/if}>Luxembourg</option>
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