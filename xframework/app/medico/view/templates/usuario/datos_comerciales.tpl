<div id="div_menu_usuario"></div>
<script>
    x_loadModule('usuario', 'menu_usuario', 'sm={$submodulo}', 'div_menu_usuario');
</script>

<div id="info-comercial" class="mul-form-type" style="display:block;">	
    <section class="form edit info-profesional-form">

        <div class="container">
            <form id="frmCambiarDatos" role="form" action="{$url}informacion-comercial-medico.do" method="post" onsubmit="return false" >
                <input name="idinformacion_comercial_medico" value="{$info_comercial.idinformacion_comercial_medico}" type="hidden">
                <input name="banco_idbanco" id="banco_idbanco" value="{$info_comercial.banco_idbanco}" type="hidden">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <h4 class="mul-form-tittle">{"Datos Cuenta de pagos"|x_translate}</h4>
                    </div>
                </div>

                <div class="row text-center">
                    <div class="col-md-8 col-md-offset-2">
                        <p class="mul-end-text-disclaimer">
                            {"Ingrese sus datos bancarios utilizando el código IBAN que aparece en su extracto bancario"|x_translate}                                
                        </p>

                    </div>	 
                </div>
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <label>{"IBAN"|x_translate}</label>
                        <div class="field-edit  dp-edit mul-light-placeholder">
                            <input type="text" maxlength="50" placeholder="{if $medico.pais_idpais==1}ex: FR7614707001013222180662691{else}ex: LU970031234567890123{/if}" name="iban" id="iban" value="{$info_comercial.iban}" data-title='{"Ingrese el IBAN"|x_translate}' >
                        </div>
                        <label>{"Confirma tu IBAN"|x_translate}:</label>
                        <div class="field-edit  dp-edit mul-light-placeholder">
                            <input type="text" maxlength="50" placeholder='{"Repita el número IBAN"|x_translate}' name="iban" id="repetir_iban" value="{$info_comercial.iban}" data-title='{"Repita el número IBAN"|x_translate}' >
                        </div>
                        <button id="validar_iban" class="save-data btn-default">{"validar"|x_translate}</button>
                    </div>   
                </div>


                <div id="div_datos_cuenta" {if $info_comercial.banco_idbanco==""}style="display:none;"{/if}>
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2">
                            <label>{"Banco"|x_translate}</label>
                            <div class="field-edit dp-edit mul-light-placeholder">
                                <span id="nombre_banco">{$info_comercial.nombre_banco}</span>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2">
                            <label>{"Nombre beneficiario"|x_translate}</label>
                            <div class="field-edit dp-edit mul-light-placeholder">
                                <input type="text" maxlength="50" placeholder='{"Nombre del beneficiario"|x_translate}' name="nombre_beneficiario" id="nombre_beneficiario" value="{$info_comercial.nombre_beneficiario}" data-title='{"Ingrese el nombre del beneficiario"|x_translate}'>
                            </div>
                        </div>   
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-2">
                            <label>{"Número de identificación fiscal"|x_translate}</label>
                            <div class="field-edit dp-edit mul-light-placeholder">
                                <input type="text" maxlength="50" placeholder='{"Ingrese número de identificación fiscal"|x_translate}' name="identificacion_fiscal" id="identificacion_fiscal" value="{$info_comercial.identificacion_fiscal}" data-title='{"Número de identificación fiscal"|x_translate}'>
                            </div>
                        </div>   

                        <div class="col-md-4 ">  
                            <label>
                                {"Condición frente al IVA"|x_translate}
                            </label>
                            <label class="radio"  style="margin-left: 20px; display:inline">
                                {"No"|x_translate}
                                <input type="radio"  class="condicion_iva" {if $info_comercial.condicion_iva=="0"}checked{/if} name="condicion_iva" value="0"/>
                            </label>
                            <label class="radio" style="margin-left: 20px; display:inline">
                                {"Si"|x_translate}
                                <input type="radio"  class="condicion_iva"  {if $info_comercial.condicion_iva=="1"}checked{/if} name="condicion_iva" value="1"/>
                            </label>
                        </div>


                    </div>
                    <div id="numero_tva_container" class="row"  {if $info_comercial.condicion_iva=="1"}style="display:block"{else}style="display:none"{/if}>
                        <div class="col-md-4 col-md-offset-2">
                            <label>{"Número de TVA"|x_translate}</label>
                            <div class="field-edit dp-edit mul-light-placeholder">
                                <input type="text" maxlength="50" placeholder='{"Ingrese número de identificación TVA"|x_translate}' name="numero_tva" id="numero_tva" value="{$info_comercial.numero_tva}" data-title='{"Número de identificación TVA"|x_translate}'>
                            </div>
                        </div>   



                    </div>
                    <div class="mul-submit-box">
                        <button id="btnGuardarInfoComercial" class="save-data btn-default">{"Guardar"|x_translate}</button>   
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <p class="mul-end-text-disclaimer">
                            {"Los profesionales podrán solicitar los pagos de los resumenes a partir del primer día hábil siguiente al período (mes) reclamado."|x_translate}
                        </p>
                        <p class="mul-end-text-disclaimer">
                            {"Los pagos se encontrarán a disposición del interesado dentro del plazo de diez (10) días hábiles desde la recepción de la solicitud de pago."|x_translate}
                        </p>
                    </div>	 
                </div>
            </form>   
        </div>

    </section>
</div>
{x_load_js}