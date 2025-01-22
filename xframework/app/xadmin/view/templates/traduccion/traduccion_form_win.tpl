


<div class="block">


    <div class="top">&nbsp;</div>


    <div class="xForm">
        <form action="{$controller}.php?action=1&modulo=traduccion&submodulo=traduccion_form_win"  method="post"  id="f_record" >
            <input type="hidden"  id="idtraduccion" name="idtraduccion" value="{$smarty.request.id}" />


            <div class="form_container">
                <div class="title">
                    Traducción
                </div>
                <ul>

                    <li class="wide">
                        <label>Original</label> 
                        {x_form_input  id="original" descriptor="none" isRequired="false" maxChars=500 class="" value=$record.original} 
                    </li>
                    {foreach from=$idiomas_traduccion item=idioma}

                        <li class="wide">
                            <label>Traducción ({$idioma})</label> 
                            {x_form_input  id="traduccion_$idioma" descriptor="none" isRequired="false" maxChars=500 class="" record=$record} 
                        </li>
                    {/foreach}

                    <li class="left">
                        <label>Tipo </label> 
                        <select name="tipo" id="tipo" class="">
                            <option value="1" {if $record.tipo==1}selected{/if}>Mensajes de alerta</option>  
                            <option value="2" {if $record.tipo==2}selected{/if}>Página  web (HTML)</option>    
                            <option value="3" {if $record.tipo==3}selected{/if}>Página  web (JS)</option>     
                        </select>                             
                    </li>   
                    <li class="wide">
                        <label>Descripción</label> 
                        {x_form_input  id="descripcion" descriptor="none" isRequired="false" maxChars=200 class="" value=$record.descripcion} 
                    </li>

                    <li class="clear"></li>
                    {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
                    {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
                    <li class="clear"></li>
                </ul>
            </div>
        </form>
    </div>


</div> 






