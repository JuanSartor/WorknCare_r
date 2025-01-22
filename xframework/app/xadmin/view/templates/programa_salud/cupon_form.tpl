<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">CUPÓN &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=cupon_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idprograma_salud_cupon" id="idprograma_salud_cupon" value="{$record.idprograma_salud_cupon}" />

                    <div class="form_container ">
                        <div class="title">Datos del cupón</div>
                        <ul>

                            <li class="left">
                                <label>Nombre</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="right">
                                <label>Código</label> 
                                {x_form_input  id="codigo_cupon" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li> 
                            <li class="left">
                                <label>ID Stipe</label> 
                                {x_form_input  id="stripe_cupon_id" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>  
                            <li class="right">
                                <label>Texto descuento</label> 
                                {x_form_input  id="descuento" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li> 
                              <li class="left">
                                <label>% descuento</label> 
                                {x_form_input  id="porcentaje_descuento" descriptor="integer" isRequired="true" maxChars=2 class="" record=$record} 
                            </li> 
                            <li class="rigth checkbox-inline">
                                <label class="">{"Activo"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.activo  name="activo" id="activo"}
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