{if $record}
    <div id="colRight">



        <div class="block">


            <div class="title_bar">
                <div class="text">M&Eacute;DICO &raquo; EDITAR </div>


                {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
                <input type="hidden" id="validado" value="{$record.validado}" />
                <input type="hidden" id="active" value="{$record.active}" />
                <input type="hidden" id="planProfesional" value="{$record.planProfesional}" />
                &nbsp;
                {if $record.estado!=2}
                    {if $record.validado == 0}
                        {x_form_html_button id="btnAprobarMedico" label="Validar Médico" w="100" type="button" class="icon approve"}
                    {else}
                        {x_form_html_button id="btnAprobarMedico" label="Suspender Validacion" w="100" type="button" class="icon remove"}
                    {/if}
                {/if}
                &nbsp;
                {if $record.cantidad_intentos_fallidos >= 10}
                    {x_form_html_button id="btnIntentosFallidos" label="Reiniciar intentos fallidos" w="100" type="button" class="icon check"}
                {/if}

                &nbsp;
                {if $record.active == 0}
                    {x_form_html_button id="btnActivar" label="Activar cuenta" w="100" type="button" class="icon approve"}
                {else}
                    {x_form_html_button id="btnActivar" label="Desactivar cuenta" w="100" type="button" class="icon remove"}
                {/if}

                &nbsp;
                {x_form_html_button id="change_password" label="Cambiar Contraseña" w="100" type="button" class="icon key"}

                &nbsp;
                {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}

            </div>
            <div class="top">&nbsp;</div>
            <div class="contenido">
                <input type="hidden" id="idusuarioweb" value="{$record.usuarioweb_idusuarioweb}" />
                <input type="hidden" name="paramsReload" id="paramsReload" value="" />
                <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />


                <div class="xForm ">
                    <form action="{$controller}.php?action=1&modulo=medicos&submodulo=medicos_generica_form" method="post" name="f_record" id="f_record">
                        <input type="hidden" name="idmedico" id="idmedico" value="{$record.idmedico}" />

                        <div class="form_container ">


                            <div class="title">Datos del Médico <small id="estado_medico" {if $record.estado==2}style="color:red" {else}{if $record.validado==0}style="color:red" {else}style="color:green" {/if}{/if}> {if $record.estado==2}Email pendiente de confirmación por el médico{else}{if $record.validado==0}Pendiente de validación por DoctorPlus{else}Médico validado{/if}{/if}</small></div>
                            <ul>
                                <li class="left">
                                    <label>{"Nombre"|x_translate}</label>
                                    {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=50 class="" record=$record}
                                </li>

                                <li class="right">
                                    <label>{"Apellido"|x_translate}</label>
                                    {x_form_input  id="apellido" descriptor="none" isRequired="true" maxChars=50 class="" record=$record}
                                </li>

                                <li class="left checkbox-inline">
                                    <label>{"Sexo"|x_translate}</label>
                                    {x_form_boolean  label_yes='Masculin' label_no='Féminin' value_yes=1 value_no=0 checked=$record.sexo  name="sexo" id="sexo"}
                                </li>
                                <li class="right">
                                    <label>{"País"|x_translate}</label>
                                    {if $record.pais_idpais==1}
                                        <span>France</span>
                                    {else}
                                        <span>Luxembourg</span>
                                    {/if}
                                </li>

                                <li class="left">
                                    <label>{"Celular"|x_translate}</label>
                                    {x_form_input  id="numeroCelular" descriptor="none" isRequired="false" maxChars=15 class="" record=$record}
                                </li>
                                <li class="right checkbox-inline">
                                    <label class="">{"Validar celular"|x_translate}</label>
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.celularValido  name="celularValido" id="celularValido"}
                                </li>

                                <li class="left">
                                    <label>{"Correo electrónico"|x_translate}</label>
                                    {x_form_input  id="email" descriptor="email" isRequired="true" maxChars=50 class="" record=$record}
                                </li>
                                <li class="right checkbox-inline">
                                    <label class="">{"Validar casilla de correo"|x_translate}</label>
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=2 checked=$record.estado  name="estado" id="estado"}
                                </li>

                            </ul>

                        </div>

                        <div class="clear">
                            &nbsp;
                        </div>
                        <div class="title">{"Datos profesionales"|x_translate}</div>
                        <ul>

                            <li class="wide">
                                <label>{"Especialidad"|x_translate}</label>
                                <select name="especialidad_medico" id="especialidad_medico" class="">
                                    <option value="">Todos...</option>
                                    {html_options options=$combo_especialidades selected=$record.mis_especialidades.0.idespecialidad}                           
                                </select> 
                            </li>
                            <li class="wide checkbox-inline">
                                <label>{"Profesional"|x_translate}</label>
                                {x_form_boolean  label_yes='Docteur' label_no='Non médecin' value_yes=1 value_no=2 checked=$record.titulo_profesional_idtitulo_profesional  name="titulo_profesional_idtitulo_profesional" id="titulo_profesional_idtitulo_profesional"}
                            </li>
                            <li class="left">
                                <label>{"Número de tarjeta RPPS"|x_translate}</label>
                                {x_form_input  id="numero_rpps" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                            <li class="right">
                                <label>{"Número Adeli"|x_translate}</label>
                                {x_form_input  id="numero_adeli" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>

                            <li class="right">
                                <label>{"Número AM"|x_translate}</label>
                                {x_form_input  id="numero_identificación" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left">
                                <label>{"Número de identificación"|x_translate}</label>
                                {x_form_input  id="numero_identificación" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                        </ul>
                        <div class="clear">
                            &nbsp;
                        </div>
                        <div class="title">{"Documentos"|x_translate}</div>
                        <div id="identificacion_medico_container">
                            {include file="medicos/identificacion_medico.tpl"}
                        </div>

                </div>

                <div class="clear">
                    &nbsp;
                </div>

                </form>
            </div>
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">



            <div class="xForm ">

                <form action="{$controller}.php?action=1&modulo=medicos&submodulo=set_cuenta_profesional" method="post" id="f_cuenta_profesional">
                    <input type="hidden" name="medico_idmedico" value="{$record.idmedico}" />
                    <input type="hidden" name="activar" value="" id="activar_cuenta_profesional" />
                    <div class="form_container ">
                        <div class="title">Abono Profesional
                            {if $record.planProfesional == 1 || $record.fundador == 1 }
                                <small id="estado_cuenta" style="color:green">
                                    {if $record.planProfesional == 1} Plan Profesional {/if}
                                    {if $record.fundador == 1}
                                        Médico Fundador - Vencimiento: Ilimitado
                                    {else}
                                        - Vencimiento: {$record.fecha_vto_premium}
                                    {/if}
                                </small>

                            {else}
                                <small id="estado_cuenta" style="color:red">
                                    Cuenta Gratuita
                                </small>
                            {/if}

                        </div>

                        <ul>
                            <li class="left">
                                <label>Cantidad de meses</label>
                                <select name="cantidad_meses" id="cantidad_meses" class="">
                                    {for $i=1 to 12}
                                        <option value="{$i}">{$i} {if $i==1}mes{else}meses{/if}</option>
                                    {/for}
                                    <option value="13" {if $record.fundador==1}selected{/if}>Médico Fundador - Ilimitado</option>

                                </select>
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div>

                        <ul>
                            <li class="tools">

                                {if $record.planProfesional == 0}
                                    {x_form_html_button id="btnPlanProfesional" label="Activar Cuenta Profesional" w="100" type="button" class="icon approve"}
                                {else}
                                    {x_form_html_button id="btnPlanProfesional" label="Desactivar Cuenta Profesional" w="100" type="button" class="icon remove"}
                                {/if}

                            </li>
                        </ul>



                    </div>

                </form>
            </div>


        </div>
        <div class="end">&nbsp;</div>
    </div>
</div>

{/if}