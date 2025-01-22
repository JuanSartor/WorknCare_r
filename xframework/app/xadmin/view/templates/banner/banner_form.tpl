<div id="colRight">

    <div class="block">

        <div class="title_bar"><div class="text">BANNER&raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />     

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=banner&submodulo=banner_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idbanner" id="idbanner" value="{$record.idbanner}" />

                    <div class="form_container ">
                        <div class="title">Datos del Banner</div>
                        <ul>
                            <li class="wide">
                                <label>Tipo de Banner</label> 
                                <select name="tipoBanner_idtipoBanner" id="tipoBanner_idtipoBanner" class="">
                                    {html_options options=$combo_tipo_banner selected=$record.tipoBanner_idtipoBanner}                           
                                </select>                 
                            </li>
                            
                            <li class="wide">
                                <label>Título * </label> 
                                {x_form_input  id="banner" descriptor="none" isRequired="true" maxChars=150 class="" record=$record} 
                            </li>  
                            
                            <li class="wide">
                                <label>Descripción</label> 
                                {x_form_textarea  id="descripcion" name="descripcion" isRequired="false" rows=1 cols=70 class="" maxChars=1000 value=$record.descripcion}
                            </li>
                            <li class="clear">&nbsp;</li>
                            <li class="wide">
                                <label>Link</label> 
                                {x_form_input  id="link" descriptor="url" isRequired="false" maxChars=150 class="" record=$record} 
                            </li>

                            <li class="wide" style="height:180px;">
                                <label>Image Desktop</label> 
                                {x_component_upload_img_v2 name="desktop" id=$record.idbanner manager="ManagerBanner"  w="500" h=100 filter="*.jpg;"}
                            </li>
                            
                            <li class="clear">&nbsp;</li>

                            <li class="wide" style="height:180px;">
                                <label>Image Mobile</label> 
                                {x_component_upload_img_v2 name="mobile" id=$record.idbanner manager="ManagerBanner"  w="500" h=100 filter="*.jpg;"}
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div> 

                        {if $record}
                        <div class="title">Imagen Desktop</div>
                        <ul>
                            {if $record.image_desktop}
                            <li class="wide">
                                <a target="_blank" href="{$record.image_desktop}"><img src="{$record.image_desktop_perfil}" /></a>
                            </li>
                            {else}
                            <li class="wide">
                                <p>No posee imagen de Desktop</p>    
                            </li>
                            {/if}
                        </ul>
                        <div class="clear">&nbsp;</div>
                        <div class="title">Imagen Mobile</div>
                        <ul>
                            {if $record.image_mobile}
                            <li class="wide">
                                <a target="_blank" href="{$record.image_mobile}"><img src="{$record.image_mobile_perfil}" /></a>
                            </li>
                            {else}
                            <li class="wide">
                                <p>No posee imagen de Mobile</p>    
                            </li>
                            {/if}
                        </ul>
                        {/if}
                    </div>
                    

                    <div class="clear">&nbsp;</div>

                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>