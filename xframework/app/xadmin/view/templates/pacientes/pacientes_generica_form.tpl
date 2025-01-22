{if $record} 
    <div id="colRight">

        <div class="block">

            <div class="title_bar">
                <div class="text">
                    PACIENTE &raquo; EDITAR
                </div>

                {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
                &nbsp;
                {if $record.active == "0"}
                    {x_form_html_button id="btnHabilitarDeshabilitarPaciente" label="Habilitar Paciente" w="100" type="button" class="icon check"}
                {/if}
                {if $record.active == "1"}
                    {x_form_html_button id="btnHabilitarDeshabilitarPaciente" label="Deshabilitar Paciente" w="100" type="button" class="icon check"}
                {/if}
                &nbsp;
                {if $record.cantidad_intentos_fallidos >= 10}
                    {x_form_html_button id="btnIntentosFallidos" label="Reiniciar intentos fallidos" w="100" type="button" class="icon check"}
                {/if}
                &nbsp;
                {if $record}
                    {x_form_html_button id="change_password" label="Cambiar Contraseña" w="100" type="button"}
                    &nbsp;
                {/if}
                {if $record}
                    {x_form_html_button id="cargar_credito" label="Cargar crédito" w="100" type="button"}
                    &nbsp;
                {/if}

                {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}

            </div>
            <div class="top">
                &nbsp;
            </div>
            <div class="contenido">

                <input type="hidden" id="idusuarioweb" value="{$record.usuarioweb_idusuarioweb}" />
                <input type="hidden" name="paramsReload" id="paramsReload" value="" />

                <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

                <div class="end">
                    &nbsp;
                </div>
                <div class="xForm ">
                    <form action="{$controller}.php?action=1&modulo=pacientes&submodulo=pacientes_generica_form"  method="post"  name="f_record" id="f_record" >
                        <input type="hidden" name="idpaciente" id="idpaciente" value="{$record.idpaciente}" />
                        <input type="hidden" name="fromadmin" id="fromadmin" value="1" />
                        <div class="form_container ">
                            <div class="title">
                                {"Datos del paciente"|x_translate}  <small id="estado_paciente" style="color:red">{if $record && $record.active==0} - {"Deshabilitado"|x_translate}{/if}</small>
                            </div>
                            <ul>
                                <li class="left">
                                    <label>{"Nombre"|x_translate}</label>
                                    {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right">
                                    <label>{"Apellido"|x_translate}</label>
                                    {x_form_input  id="apellido" descriptor="none" isRequired="true" maxChars=50 class="" record=$record}
                                </li>
                                <li class="left">
                                    <label>{"Fecha de nacimiento"|x_translate}</label>
                                    {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fechaNacimiento" isRequired="false" value=$record.fechaNacimiento|date_format:"%d/%m/%Y"}

                                </li>
                                <li class="right checkbox-inline">
                                    <label>{"Sexo"|x_translate}</label>
                                    {x_form_boolean  label_yes='Masculin' label_no='Féminin' value_yes=1 value_no=0 checked=$record.sexo default=0 name="sexo" id="sexo"}
                                </li>

                                <li class="left left">
                                    <label>{"Celular"|x_translate} </label>
                                    {x_form_input  id="numeroCelular" descriptor="none" isRequired="true" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right checkbox-inline">
                                    <label class="">{"Validar celular"|x_translate}</label> 
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.celularValido  name="celularValido" id="celularValido"}
                                </li>
                                <li class="left">
                                    <label>{"Email"|x_translate} </label>
                                    {x_form_input  id="email" descriptor="email" isRequired="true" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right checkbox-inline">
                                    <label class="">{"Validar casilla de correo"|x_translate}</label> 
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=2 checked=$record.estado  name="estado" id="estado"}
                                </li>

                                <div class="clear">
                                    &nbsp;
                                </div>



                                <li class="left">
                                    <label>{"País"|x_translate}</label> 
                                    <select name="pais_idpais" id="pais_idpais" class="">
                                        <option value="">{"Seleccionar"|x_translate}</option>
                                        {if $record}
                                            {html_options options=$paises selected=$record.pais_idpais}  
                                        {else}                         
                                            {html_options options=$paises selected=1}                      
                                        {/if}
                                    </select>        
                                </li> 

                                <li class="right checkbox-inline">
                                    <label>{"¿Trabaja en otro país?"|x_translate}</label>
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.trabaja_otro_pais default=0 name="trabaja_otro_pais" id="trabaja_otro_pais"}
                                </li>
                                <div class="clear">
                                    &nbsp;
                                </div>
                                <li class="left">
                                    <label>{"Tarjeta Vitale"|x_translate}</label>
                                    {x_form_input  id="tarjeta_vitale" descriptor="none" isRequired="false" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right">
                                    <label>{"Tarjeta CNS"|x_translate}</label>
                                    {x_form_input  id="tarjeta_cns" descriptor="none" isRequired="false" maxChars=50 class="" record=$record}
                                </li>
                                <li class="left">
                                    <label>{"Tarjeta eID"|x_translate}</label>
                                    {x_form_input  id="tarjeta_eID" descriptor="none" isRequired="false" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right">
                                    <label>{"Pasaporte"|x_translate}</label>
                                    {x_form_input  id="tarjeta_pasaporte" descriptor="none" isRequired="false" maxChars=50 class="" record=$record}
                                </li>

                            </ul>
                            <div class="clear">
                                &nbsp;
                            </div>
                            <div class="title">{"Documentos"|x_translate}</div>
                            <div id="identificacion_paciente_container">
                                {include file="pacientes/identificacion_paciente.tpl"}
                            </div>

                            <div class="clear">
                                &nbsp;
                            </div>
                            <div id="div_estado_cuenta" class="datos-administrador-submodulo">
                                {include file="pacientes/movimientos_cuenta.tpl"}
                            </div>

                        </div>

                        <div class="clear">
                            &nbsp;
                        </div>

                    </form>
                </div>
            </div>
            <div class="end">
                &nbsp;
            </div>
        </div>
    </div>
{/if}