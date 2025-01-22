
<div id="colRight">


    <div class="block">

        <div class="title_bar"><div class="text">{"Administración de Pase de Salud"|x_translate}</div>   
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'usuarios_empresa'" p2="'usuarios_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;
            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="change_password" label="Cambiar Contraseña" w="100" type="button" class="icon key"}
            &nbsp;
            {if $record.cancelar_suscripcion!="2"}
                {x_form_html_button id="cancelar-suscripcion" label="Cancelar suscripción" w="150" type="button" class="icon trash"}
                &nbsp;
            {/if}
        </div>



        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=usuarios_empresa&submodulo=usuarios_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idusuario_empresa" id="idusuario_empresa" value="{$record.idusuario_empresa}" />
                    <input type="hidden" name="idempresa" id="idempresa" value="{$record.idempresa}" />
                    <input type="hidden" name="idProgramaSus" id="idProgramaSus" value="{$programaSaludSuscripcion.idprograma_salud_suscripcion}" />
                    <div class="form_container ">
                        <div class="title">
                            Datos del WorknCare 
                            {if $record.cancelar_suscripcion!="0"}
                                <small id="estado_empresa" style="color:red"> 
                                    {if $record.cancelar_suscripcion=="1"}
                                        - Cancelacion pendiente {$record.fecha_vencimiento|date_format:"%d/%m/%Y"}
                                    {/if}
                                    {if $record.cancelar_suscripcion=="2"}
                                        - Cancelada {$record.fecha_vencimiento|date_format:"%d/%m/%Y"}
                                    {/if}
                                </small>
                            {else}
                                <small id="estado_empresa" style="color:green"> 
                                    {if $record.suscripcion_activa=="2"}
                                        -  Pendiente de inicio {$record.fecha_adhesion|date_format:"%d/%m/%Y"}
                                    {/if}
                                    {if $record.suscripcion_activa=="1"}
                                        - Activa 
                                    {/if}
                                </small>
                            {/if}
                        </div>
                        <ul>
                            <li class="left">
                                <label>{"Nombre"|x_translate}</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}  
                            </li> 

                            <li class="right">
                                <label>{"Apellido"|x_translate}</label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="true" maxChars=255 class="" record=$record} 
                            </li>


                            <li class="left">
                                <label>{"Su plan contratado:"|x_translate}</label> 
                                <span>{$plan.nombre}</span>
                            </li> 
                            <li class="right checkbox-inline">
                                <label class="">{"Tipo de cuenta:"|x_translate}</label> 
                                {x_form_boolean  label_yes='Entreprise' label_no='Particulier' value_yes=1 value_no=2 default=1 checked=$record.tipo_cuenta  name="tipo_cuenta" id="tipo_cuenta"}
                            </li>
                            {if $empresa.tipo_cuenta=="1"}
                                <li class="left">
                                    <label>{"Empresa"|x_translate}</label> 
                                    {x_form_input  id="empresa" descriptor="empresa" isRequired="false" maxChars=255 class="" record=$record} 
                                </li>
                            {/if}
                            <li class="right">
                                <label>{"Fecha registro"|x_translate}</label>
                                <span>{$record.fecha_alta|date_format:"%d/%m/%Y"}</span>
                            </li>
                            <li class="left">
                                <label>{"Fecha de adhesion"|x_translate}</label>
                                <span>{$record.fecha_adhesion|date_format:"%d/%m/%Y"}</span>           
                            </li>
                            <li class="right">
                                <label>{"Fecha de vencimiento"|x_translate}</label>
                                <span>{$record.fecha_vencimiento|date_format:"%d/%m/%Y"}</span>                         
                            </li>


                            <li class="left">
                                <label>{"Correo electrónico"|x_translate}</label>
                                {x_form_input  id="email" descriptor="email" isRequired="true" maxChars=50 class="" record=$record}
                            </li>

                            <li class="right checkbox-inline">
                                <label class="">{"Validar casilla de correo"|x_translate}</label>
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.estado  name="estado" id="estado"}
                            </li>
                            <li class="right">
                                <label>{"Embajador"|x_translate}</label>
                                <select name="embajador_idembajador" id="embajador_idembajador" class="">
                                    <option value="">Seleccione...</option>
                                    {html_options options=$combo_embajadores selected=$record.embajador_idembajador}                           
                                </select> 
                            </li>

                            <li class="right checkbox-inline">
                                <label>{"Estado"|x_translate} </label> 
                                {x_form_boolean  label_yes='Actif' label_no='Inactif' value_yes=1 value_no=0 checked=$record.activo default=1 name="activo"}
                            </li> 
                            {if $empresa.tipo_cuenta=="1"}
                                <li class="left">
                                    <label>{"Dominio de correo electronico de su empresa"|x_translate}</label> 
                                    {x_form_input  id="dominio_email" descriptor="none" isRequired="false" maxChars=255 class="" record=$record} 
                                </li> 
                            {/if}
                            <li class="right">
                                <label>{"Cupón de descuento"|x_translate}</label> 

                                <span>{if $record.cupon_descuento}{$record.cupon_descuento}{else}-{/if}</span>
                            </li>
                            {if $empresa.contratacion_manual=='1'}
                                <li class="clear">&nbsp;</li>
                                <li class="left">
                                    <label>{"CONTRATACION"|x_translate}</label>
                                    <span>MANUAL</span>
                                </li>

                                <li class="right checkbox-inline">
                                    <label class="">{"Transferencia recibida"|x_translate}</label>
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=2 value_no=1 checked=$programaSaludSuscripcion.pack_pago_pendiente  name="estadoPack" id="estadoPack"}
                                </li>

                                <li class="right">
                                    <label>Factura</label> 
                                    <a  href="{$url}xframework/files/entities/facturas_pagopackmanual/{$programaSaludSuscripcion.empresa_idempresa}/fac-pay-{$programaSaludSuscripcion.idprograma_salud_suscripcion}.pdf" target="_blank">  Factura PDF </a>   
                                </li>
                                <li class="clear">&nbsp;</li>
                                {/if}
                            <div class="clear">
                                &nbsp;
                            </div>
                            <li class="right checkbox-inline">
                                <label class="">{"Cliente"|x_translate}</label>
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=0 value_no=1 checked=$empresa.empresa_test  name="empresa_test" id="empresa_test"}
                            </li>
                        </ul>

                    </div> 
                    <div class="clear">
                        &nbsp;
                    </div>
                    <div id="div_listado_beneficiarios" class="datos-administrador-submodulo">
                        {include file="usuarios_empresa/listado_beneficiarios.tpl"}
                    </div>
                    <div class="clear">
                        &nbsp;
                    </div>
                    <div id="div_listado_usuarios_secundarios" class="datos-administrador-submodulo">
                        {include file="usuarios_empresa/listado_usuarios_secundarios.tpl"}
                    </div>
                    <div class="clear">
                        &nbsp;
                    </div>
                    <div class="title">
                        {"Facturas"|x_translate}
                    </div>

                    <div class="clear">
                        &nbsp;
                    </div>
                    <div id="div_facturas" class="datos-administrador-submodulo">

                    </div>
            </div>
            <div class="clear">
                &nbsp;
            </div>
            </form>
            <div class="clear">&nbsp;</div>

        </div>
    </div>  

</div> 
</div>  
