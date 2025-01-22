<div id="colRight">

    <div class="block">

        <div class="title_bar"><div class="text">TIPO BANNER &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=banner&submodulo=tipo_banner_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idtipoBanner" id="idtipoBanner" value="{$record.idtipoBanner}" />

                    <div class="form_container ">
                        <div class="title">Tipo Banner</div>
                        <ul>
                            <li class="wide">
                                <label>Títuo *</label> 
                                {x_form_input  id="tipoBanner" descriptor="none" isRequired="true" class="" record=$record} 
                            </li>

                            <li class="wide">
                                <label>Descripción</label> 
                                {x_form_textarea  id="descripcion" name="descripcion" isRequired="false" rows=1 cols=70 class="" maxChars=1000 value=$record.descripcion}
                            </li>
                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>
                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>