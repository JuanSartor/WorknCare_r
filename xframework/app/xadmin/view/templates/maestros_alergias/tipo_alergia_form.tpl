<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">ALERGIAS &raquo; SUB TIPO ALERGIA  &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_alergias&submodulo=tipo_alergia_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idsubTipoAlergia" id="idsubTipoAlergia" value="{$record.idsubTipoAlergia}" />
                    <input type="hidden" name="tipoAlergia_idtipoAlergia" id="tipoAlergia_idtipoAlergia" value="{$tipoAlergia.idtipoAlergia}" />

                    <div class="form_container ">
                        <div class="title">Datos de Sub tipo alergia</div>
                        <ul>

                            <li class="wide">
                                <label>Alergia</label>
                                <span class="lbl" id="pre_id" >{$tipoAlergia.tipoAlergia}</span>
                            </li>
                            
                            <li class="wide">
                                <label>Sub Tipo alergia* </label> 
                                {x_form_input  id="subTipoAlergia" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
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