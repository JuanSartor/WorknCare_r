
<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">
                {if $record} EDITAR{else}NUEVO{/if}  PRESTADOR &raquo; 
            </div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
                       &nbsp;
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
             &nbsp;
            {x_form_html_button id="btnListadoMedicos" label="Listado de Médicos" w="150" type="button" class="icon user"}
            &nbsp;
            {x_form_html_button id="btnListadoPacientes" label="Listado de Pacientes" w="150" type="button" class="icon user"}


        </div>
        <div class="top">
            &nbsp;
        </div>
        <div class="contenido">

            <div class="xForm ">

                <div class="form_container ">
                    <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=prestadores_form"  method="post"  name="f_record" id="f_record" >
                        <input type="hidden" name="idprestador" id="idprestador" value="{$record.idprestador}" />

                        <div class="title">
                            Datos del Prestador
                        </div>
                        <ul>

                            <li class="wide">
                                <label>Nombre</label>
                                {x_form_input  id="nombre"  descriptor="none" isRequired="true" maxChars=50 class="" value="{$record.nombre}" }
                            </li>
                            {* <li class="right">
                                <label>Razón social</label>
                                {x_form_input  id="razon_social"  descriptor="none" isRequired="true" maxChars=50 class="" value="{$record.razon_social}" }
                            </li>
                            <li class="left">
                                <label>CUIT</label>
                                {x_form_input  id="cuit"  descriptor="none" isRequired="true" maxChars=50 class="" value="{$record.cuit}" }
                            </li>
                            <li class="right">
                                <label>Domicilio fiscal</label>
                                {x_form_input  id="domicilio_fiscal"  descriptor="none" isRequired="true" maxChars=50 class="" value="{$record.domicilio_fiscal}" }
                            </li>
                            <li class="left">
                                <label>Condición IVA</label> 
                                <select class="" name="condicion_iva_idcondicion_iva" id="condicion_iva_idcondicion_iva">
                                    <option value="">Condición de IVA</option>
                                    {html_options options=$combo_condicion_iva selected=$record.condicion_iva_idcondicion_iva}
                                </select>             
                            </li>


                            <li class="right">
                                <label>Método cobro</label> 
                                <select class="" name="metodo_cobro" id="metodo_cobro" required data-title="Seleccione el método de cobro">
                                    <option value="">Seleccione método de Cobro</option>
                                    <option value="0" {if $record.metodo_cobro == "0"} selected{/if}>Cheque</option>
                                    <option value="1" selected>Transferencia Bancaria</option>
                                </select>               
                            </li>
                            *}

                        </ul>
                        {*
                        <div class="clear">&nbsp;</div>
                        <div class="title">
                            Datos de cuenta de pago
                        </div>
                        <ul>

                            <li class="left">
                                <label>Banco</label> 
                                <select class="" name="banco_idbanco" id="banco_idbanco" data-title="Seleccione Banco">

                                    <option value="">Seleccione un Banco</option>
                                    {foreach from=$listado_bancos item=banco }
                                    <option value="{$banco.idbanco}" data-codigo="{$banco.codigo}"{if $record.banco_idbanco==$banco.idbanco}selected{/if}>{$banco.nombre_banco}</option>
                                    {/foreach}      
                                </select>
                            </li>

                            <li class="right">
                                <label>Banco</label> 
                                <select class="" name="tipo_cuenta" id="tipo_cuenta" required data-title="Seleccione el tipo de cuenta">
                                    <option value="">Tipo de cuenta</option>
                                    <option value="0" {if $record.tipo_cuenta == 0} selected{/if}>Caja de Ahorro en Pesos</option>
                                    <option value="1" {if $record.tipo_cuenta == 1} selected{/if}>Cuenta Corriente en Pesos</option>
                                    <option value="2" {if $record.tipo_cuenta == 2} selected{/if}>Cuenta Única</option>
                                </select>
                            </li>
                            <li class="left">
                                <label>CBU</label>
                                {x_form_input  id="CBU"  descriptor="integer" isRequired="false" maxChars=50 class="" value="{$record.CBU}" }
                            </li>
                            <li class="right">
                                <label>Alias CBU</label>
                                {x_form_input  id="alias_CBU"  descriptor="none" isRequired="false" maxChars=50 class="" value="{$record.alias_CBU}" }
                            </li>
                            <li class="left">
                                <label>Número de cuenta</label>
                                {x_form_input  id="numero_cuenta"  descriptor="none" isRequired="false" maxChars=50 class="" value="{$record.numero_cuenta}" }
                            </li>
                        </ul>
                        *}
                        <div class="clear">&nbsp;</div>
                        <div class="title">
                            Servicios
                        </div>
                        <ul>

                            <li class="left">
                                <label>¿Puede agregar pacientes?</label>
                                {x_form_boolean  label_yes='Si' label_no='No' value_yes=1 value_no=0 default=1 checked=$record.agregar_paciente  name="agregar_paciente"  id="agregar_paciente"}
                            </li>
                            <li class="right">
                                <label>¿Puede agregar médicos?</label>
                                {x_form_boolean  label_yes='Si' label_no='No' value_yes=1 value_no=0  default=1 checked=$record.agregar_medico name="agregar_medico" id="agregar_medico"}
                            </li>


                            <li class="wide">
                                <label>Consulta Express</label>
                                {x_form_boolean  label_yes='Todos los pacientes de DoctorPlus' label_no='Sólo a sus pacientes' value_yes=1 value_no=2  default=1  checked=$record.pacientesConsultaExpress name="pacientesConsultaExpress" id="pacientesConsultaExpress"}
                            </li>
                            <li class="wide">
                                <label>Video Consultas inmediatas</label>
                                {x_form_boolean  label_yes='Todos los pacientes de DoctorPlus' label_no='Sólo a sus pacientes' value_yes=1 value_no=2  default=1 checked=$record.pacientesVideoConsulta name="pacientesVideoConsulta" id="pacientesVideoConsulta"}
                            </li>
                            <li class="wide">
                                <label>Video Consultas con turno</label>
                                {x_form_boolean  label_yes='Todos los pacientes de DoctorPlus' label_no='Sólo a sus pacientes' value_yes=1 value_no=2 default=1 checked=$record.pacientesVideoConsultaTurno name="pacientesVideoConsultaTurno" id="pacientesVideoConsultaTurno"}
                            </li>
                            <li class="wide">
                                <label>Turnos presenciales</label>
                                {x_form_boolean  label_yes='Todos los pacientes de DoctorPlus' label_no='Sólo a sus pacientes' value_yes=1 value_no=2  default=1 checked=$record.pacientesTurno  name="pacientesTurno" id="pacientesTurno"}
                            </li>
                            <li class="wide">
                                <label>Costos de servicios</label>
                                {if $record.descuento!=""}
                                {x_form_boolean  label_yes='Descuento' label_no='Configurar valores' value_yes=1 value_no=0 checked=1 name="costos_servicios"  id="costos_servicios"}
                                {else}
                                {x_form_boolean  label_yes='Descuento' label_no='Configurar valores' value_yes=1 value_no=0 checked=0 name="costos_servicios"  id="costos_servicios"}
                                {/if}

                            </li>
                            <div id="div_configurar_valores"  style="display:none;">
                                <li class="left">
                                    <label>Valor Consulta Express</label>
                                    {x_form_input  id="valorConsultaExpress"  descriptor="integer" isRequired="false" maxChars=3 class="" value="{$record.valorConsultaExpress}" }
                                </li>
                                <li class="right">
                                    <label>Valor Video Consulta inmediata</label>
                                    {x_form_input  id="valorVideoConsulta"  descriptor="integer" isRequired="false" maxChars=3 class="" value="{$record.valorVideoConsulta}" }
                                </li>
                                <li class="left">
                                    <label>Valor Video Consulta con Turno</label>
                                    {x_form_input  id="valorVideoConsultaTurno"  descriptor="integer" isRequired="false" maxChars=3 class="" value="{$record.valorVideoConsultaTurno}" }
                                </li>
                            </div>
                            <div id="div_descuento" style="display:none;">
                                <li class="left">
                                    <label>% Descuento</label>
                                    {x_form_input  id="descuento"  descriptor="integer" isRequired="false" maxChars=3 class="" value="{$record.descuento}" }
                                </li>
                            </div>
                            <li class="right">
                                <label>% Comision DoctorPlus</label>
                                {x_form_input  id="comision_dp"  descriptor="integer" isRequired="true" maxChars=3 class="" value="{$record.comision_dp}" }
                            </li>

                        </ul>
                    </form>

                    <div class="clear">&nbsp;</div>  
                    <div id="div_listado_planes_prestador">

                    </div>



                    <div class="clear">&nbsp;</div>  
                    <div id="div_listado_usuarios_prestador">

                    </div>

                   
                    <div class="end">&nbsp;</div>
                </div>



            </div>

        </div>

    </div>
</div>
