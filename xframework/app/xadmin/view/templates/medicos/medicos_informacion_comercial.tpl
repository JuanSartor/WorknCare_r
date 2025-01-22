<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">M&Eacute;DICO &raquo; INFORMACI&Oacute;N COMERCIAL &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />     

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=medicos&submodulo=medicos_informacion_comercial"  method="post"  name="f_record" id="f_record">
                    <input type="hidden" name="idinformacion_comercial_medico" id="idinformacion_comercial_medico" value="{$record.idinformacion_comercial_medico}" />
                    <input type="hidden" name="medico_idmedico" id="medico_idmedico" value="{$record.medico_idmedico}" />
                    <div class="form_container ">
                        <div class="title">
                            Datos comerciales del médico
                        </div>
                        <ul>
                            <li class="wide">
                                <label>Nom du titulaire du compte</label>
                                {x_form_input  id="nombre_beneficiario" isRequired="false" maxChars=100 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Nom de votre Banque</label>
                                <select name="banco_idbanco" id="banco_idbanco" class="half">
                                    <option value="">Seleccione...</option>
                                    {html_options options=$combo_banco selected=$record.banco_idbanco}
                                </select>
                            </li>
                            <li class="wide">
                                <label>IBAN</label>
                                {x_form_input  id="iban" isRequired="false" class="" record=$record}
                            </li>
                            <li class="left">
                                <label>{"Número de identificación fiscal"|x_translate}</label>
                                {x_form_input  id="identificacion_fiscal" isRequired="false" class="" record=$record}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">  {"Condición frente al IVA"|x_translate}</label>
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.condicion_iva  name="condicion_iva" id="condicion_iva"}
                            </li>

                            <div class="clear">
                                <p>&nbsp;</p>
                            </div>
                        </ul>
                        <div class="clear">
                            <p>&nbsp;</p>
                        </div>
                    </div>
                </form>
            </div>


            <div class="end">
                &nbsp;
            </div>

        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>