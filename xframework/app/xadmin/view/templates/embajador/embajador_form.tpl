<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">EMBAJADOR &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=embajador&submodulo=embajador_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idembajador" id="idembajador" value="{$record.idembajador}" />

                    <div class="form_container ">
                        <div class="title">Datos del embajador</div>
                        <ul>

                            <li class="left">
                                <label>Nombre</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="right">
                                <label>Apellido</label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li> 
                            <li class="left">
                                <label>Email</label> 
                                {x_form_input  id="email" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="right">
                                <label>Teléfono</label> 
                                {x_form_input  id="telefono" descriptor="none" isRequired="false"  class="" record=$record} 
                            </li>
                            <li class="left">
                                <label>Id Fiscal</label> 
                                {x_form_input  id="identificacion_fiscal" isRequired="false" descriptor="none" class="" record=$record} 
                            </li>  

                        </ul>

                        <div class="clear">&nbsp;</div> 
                        <div id="listado_empresas">
                            <div class="title">Empresas Asociadas</div>
                            <div class="xForm">
                                <ul>
                                    {foreach from=$listado_empresas item=empresa}
                                        <li class="empresa" style="list-style: inside;"> {$empresa.empresa}: <small>{$empresa.usuario.nombre} {$empresa.usuario.apellido} ({$empresa.usuario.email})</small></li>
                                        {foreachelse}
                                        <li class="empresa"> <small>Sin empresas asociadas</small></li>
                                        {/foreach}
                                </ul>
                            </div>


                        </div>


                        <div class="clear">&nbsp;</div>

                    </div>


                    <div class="clear">&nbsp;</div>


                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>