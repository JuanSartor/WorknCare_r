<div class="container">
           <!--Link modal sugerencia usabilidad horizontal-->
<a href="javascript:;" class="modal-btn" data-target="usabilidad-modal" id="active_modal_usabilidad" role="button"></a>

    <div class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                <div class="modal-body"></div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <section class="sign-up">
        <ul id="signup-steps" class="nav nav-tabs" role="tablist">
            <li class="active"><span class="dp-cart">{"Mi compra"|x_translate}</span></li>
            <li><span class="dp-user-dr">{"Identificación"|x_translate}</span></li>
            <li><span class="dp-pin">{"Pago"|x_translate}</span></li>
        </ul>
        <div class="tab-content" id="tabs-proceso">
            <div role="tabpanel" class="tab-pane active fade in" id="product">
           <section class="order">
			<div class="container text-center">
				<p class="uppercase">{"Detalle del abono"|x_translate}</p>

				<div class="account-type pro">
					<div>
						<span>{"Cuenta Profesional"|x_translate}</span>
						<span class="price">&euro;{$MONTO_CUOTA}<span> {"finales/MES"|x_translate}</span></span>
					</div>
				</div>

				<p class="disclaimer text-center uppercase">{"Precios expresados en pesos argentinos. La contratación mínima del servicio es de 6 meses."|x_translate}</p>
			    <a href="#billing" class="step-btn uppercase next" id="nextTab" data-toggle="tab" role="button">{"Continuar"|x_translate}</a>
			</div>
		</section>
                <br />
                <br />
                <section class="professional account-type container text-center">
                    <h2>{"¡Todas las funcionalidades sin descuentos por comisión!"|x_translate}</h2>
                    <div class="row highlights">
                        <div class="col-md-8 col-center col-sm-12 plan-highlights">
                            <p class="text-center">
                                {"Ideal para profesionales con alta demanda y requerimiento de sus pacientes fuera del consultorio"|x_translate}
                            </p>
                            <button class="toggle-features visible-xs">{"Ver Características"|x_translate}</button>
                            <div class="row special-features">
                                <div class="col-md-4 col-md-offset-2">
                                    <ul>
                                        <li><span class="dp-agenda">{"Agenda de Turnos"|x_translate}</span></li>
                                        <li><span class="dp-alarm">{"Recordatorios o cancelaciones de Turnos por email"|x_translate}</span></li>
                                        <li><span class="dp-sms">{"Recordatorios o cancelaciones de Turnos por SMS"|x_translate}</span></li>
                                        <li><span class="dp-info">{"Info de Salud de sus pacientes"|x_translate}</span></li>
                                    </ul>
                                </div>
                                <div class="col-md-4 col-md-offset-1">
                                    <ul>
                                        <li><span class="dp-express">{"Consulta Express"|x_translate}</span></li>
                                        <li><span class="icon-doctorplus-video-call">{"Video Consulta"|x_translate}</span></li>
                                        <li><span class="dp-support">{"Soporte Técnico por email"|x_translate}</span></li>
                                        <li><span class="dp-stats">{"Estadísticas de atención"|x_translate}</span></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
           <div role="tabpanel" class="tab-pane fade" id="registration">
                <div>
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active"><a href="#existing-user" aria-controls="existing-user" role="tab" data-toggle="tab">{"Ingrese sus datos de cliente"|x_translate}</a></li>
                        <li role="presentation"><a href="#new-user" aria-controls="new-user" role="tab" data-toggle="tab">{"Registrarme como usuario"|x_translate}</a></li>
                    </ul>
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="existing-user">
                            <div class="col-md-4 col-center">
                                <form class="form">
                                    <div class="form-group data-field dp-user">
                                        <input type="email" class="form-control" placeholder="ejemplo@mail.com">
                                    </div>
                                    <div class="form-group data-field dp-lock">
                                        <input type="password" class="form-control" placeholder='{"Contraseña"|x_translate}'>
                                    </div>
                                    <a href="#billing" class="step-btn uppercase next" data-toggle="tab" role="button">{"Continuar"|x_translate}</a>
                                    <br />
                                </form>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="new-user">
                            <div class="col-md-4 col-center">
                                <form class="form">
                                    <div class="form-group data-field">
                                        <input type="text" class="form-control" placeholder="Nombre">
                                    </div>
                                    <div class="form-group data-field">
                                        <input type="text" class="form-control" placeholder="Apellido">
                                    </div>
                                    <div class="form-inline">
                                        <p>Sexo</p>
                                        <div class="form-group data-field">
                                            <input type="radio" class="form-control" name="gender" id="female" value="femenino" />
                                            <label for="female">{"Femenino"|x_translate}</label>
                                        </div>
                                        <div class="form-group data-field">
                                            <input type="radio" class="form-control" name="gender" id="male" value="masculino" />
                                            <label for="male">{"Masculino"|x_translate}</label>
                                        </div>
                                    </div>
                                    <div class="form-group data-field">
                                        <select class="form-control select select-primary select-block mbl" name="speciality" id="speciality">
                                            <option value="especialidad">{"Especialidad"|x_translate}</option>
                                        </select>
                                    </div>
                                    <div class="form-group data-field">
                                        <select class="form-control select select-primary select-block mbl" name="sub-speciality" id="sub-speciality">
                                            <option value="sub-especialidad">Sub-specialidad</option>
                                        </select>
                                    </div>
                                    <div class="form-group data-field dp-email">
                                        <input type="email" class="form-control" placeholder='{"Ingrese su e-mail"|x_translate}'>
                                    </div>
                                    <div class="form-group data-field dp-email">
                                        <input type="email" class="form-control" placeholder='{"Ingrese nuevamente su e-mail"|x_translate}'>
                                    </div>
                                    <div class="form-group data-field dp-lock">
                                        <input type="password" class="form-control" placeholder='{"Contraseña"|x_translate}'>
                                    </div>
                                    <div class="form-group data-field dp-lock">
                                        <input type="password" class="form-control" placeholder='{"Repita su contraseña"|x_translate}'>
                                    </div>
                                    <p class="disclaimer text-center">
                                        <small>
                                            {"Al crear una cuenta de cliente de DoctorPlus estará aceptando los"|x_translate}<br /><a href="#">{"Términos y condiciones de uso del servicio"|x_translate}</a> - <a href="#">{"Política de Protección de Datos"|x_translate}</a>
                                        </small>
                                    </p>
                                    <a href="#billing" class="uppercase next" data-toggle="tab" role="button">{"Continuar"|x_translate}</a>
                                    <br />
                                </form>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div>
          
            <div role="tabpanel" class="tab-pane fade relative" id="billing">
                <h5 class="uppercase light">Pago</h5>
                <div class="purchase-summary">
                    <div class="row">
                        <div class="col-md-9">
                            <div class="table-responsive">
                                <table>
                                    <tr>
                                        <th>{"Detalle"|x_translate}</th>
                                        <th>{"Medio de pago"|x_translate}</th>
                                        <th>{"Precio"|x_translate}</th>
                                        <th>{"Subtotal"|x_translate}</th>
                                    </tr>
                                    <tr>
                                        <td>{"Abono Cuenta Profesional"|x_translate}</td>
                                        <td>
                                            <select class="form-control select select-primary select-block mbl" name="metodo_pago" id="metodo_pago">
                                                     <option value="">{"Seleccione Método Pago"|x_translate}</option>
                                            {html_options options=$combo_metodo_pago }
                                            </select>
                                        </td>
                                        <td>&euro;{$MONTO_CUOTA},00 / mes</td>
                                        <td class="stotal">&euro;{$MONTO_CUOTA},00<br></td>
                                    </tr>
                                    <tr>
                                        <td><a class="promo-code-btn" href="#">{"Tengo un código promocional"|x_translate}</a></td>
                                        <td></td>
                                        <td></td>
                                        <td class="total">&euro;{$MONTO_CUOTA},00</td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="padding:0">
                                            <div class="promo-code">
                                                <input type="text" placeholder='{"Ingrese su Código Promocional"|x_translate}'><a href="javascript:;" onclick="x_alert(x_translate('El código ingresado no es válido'))" role="button" id="promo-code">{"Aplicar"|x_translate}</a>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                                      <div class="col-md-2 col-md-offset-1 text-center total">
                            <p>{"Total a pagar"|x_translate}</p>
                            <p class="price">&euro;{$MONTO_CUOTA}<sup>00</sup></p>
                            <p class="uppercase">&euro;</p>
                            <p><small>{"IVA incluído"|x_translate}</small></p>
                            <br />
                            {if $enlace_mp != ""}
                            <div id="div_mercado_pago" style="display:none">
                                {*<a href="{$enlace}" id="submitter" name="MP-Checkout" class="red-M-Rn-Ar-ArOn uppercase next">{"Continuar"|x_translate}</a>
                                <script type="text/javascript" src="https://www.mercadopago.com/org-img/jsapi/mptools/buttons/render.js"></script>*}

                                <a class="uppercase next" role="button" data-toggle="tab" href="#div_metodo_pago" id="btnContinuarMP">{"Continuar"|x_translate}</a>
                            

                            </div>
                            <div id="div_otro_medio_pago" style="display:none">
                            <a class="uppercase next" role="button" data-toggle="tab" href="#div_metodo_pago" id="btnContinuar">{"Continuar"|x_translate}</a>                            </div>
                            {else}
                           <a class="uppercase next" role="button" data-toggle="tab" href="#div_metodo_pago" id="btnContinuar">{"Continuar"|x_translate}</a>
                            {/if}
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <hr />
                   
                    <div class="payment-options">
                        
                        <div class="row relative" id="div_metodo_pago">
                         
                           

                            {*<div class="col-md-4">
                                    <p>Transferencias / Depósitos Bancarios</p>
                                    <button data-modal="yes" class="wire-transfer"><img src="{$IMGS}santander_logo.png" alt="Santander Río" class="img-responsive"></button>
                                    <div class="modal-payment-information hidden">
                                            <div class="payment-information">
                                                    <div class="col-md-8 grey-15 payment-details box">
                                                            <div>
                                                                    <img src="{$IMGS}santander_logo.png" alt="Santander Río" width="150" class="img-responsive">
                                                                    <p>Podés abonar tus pagos por Depósito o Transferencia Bancaria:</p>
                                                                    <br />
                                                                    <div>Datos para depósito y/o transferencia:</div>
                                                                    <div>Entidad Bancaria: <strong>Banco Santander Río</strong></div>
                                                                    <div>Titular de la cuenta: <strong>DoctorPlus S.A.</strong></div>
                                                                    <div>Tipo de cuenta: <strong>Cuenta Corriente</strong></div>
                                                                    <div>Nro. de cuenta: <strong>895749</strong></div>
                                                                    <div>Sucursal: <strong>359</strong></div>
                                                                    <div>CBU: <strong>0010000000000111100000011</strong></div>
                                                                    <div>CUIT: <strong>30-25879364-3</strong></div>
                                                            </div>
                                                    </div>
                                                    <div class="col-md-4 grey-10 requisites box">
                                                            <div>
                                                                    <p class="dp-file">Requiere informar el pago</p>
                                                            </div>
                                                            <hr >
                                                            <div>
                                                                    <p class="dp-time">Acreditación 72hs.</p>
                                                            </div>
                                                    </div>
                                                    <div class="clearfix"></div>
                                            </div>
                                    </div>
                            </div>
                            <div class="col-md-4">
                                    <p>Débito en Cuenta Bancaria</p>
                                    <button data-modal="yes" class="dp-add-pin"></button>
                                    <div class="modal-bank-credit hidden">
                                            <div class="payment-information">
                                                    <div class="col-md-8 grey-15 payment-details box">
                                                            <div>
                                                                    <span class="dp-add-pin"></span>
                                                                    <p>El débito automático es sólo para cuentas bancarias. No realizamos débitos de tarjetas de crédito con este medio de pago.</p>
                                                                    <br />
                                                                    <p>Para pagar por débito automático siga estos pasos:</p>
                                                            </div>
                                                    </div>
                                                    <div class="col-md-4 grey-10 requisites box">
                                                            <div>
                                                                    <p class="dp-file">Requiere informar el pago</p>
                                                            </div>
                                                            <hr >
                                                            <div>
                                                                    <p class="dp-time">5 días hábiles.</p>
                                                            </div>
                                                    </div>
                                                    <div class="clearfix"></div>
                                            </div>
                                    </div>
                            </div>*}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</div>

{literal}
<script>
    $(document).ready(function() {
        
        $("#nextTab").click(function(){

  $('#signup-steps li').addClass("active");
$('#signup-steps li:eq(0)').removeClass("active");
});

        
        $("#metodo_pago").change(function() {
            if ($(this).val() == "2") {
                $("#div_otro_medio_pago").hide();
                $("#div_mercado_pago").show();
         
            } else {
                $("#div_otro_medio_pago").hide();
                $("#div_mercado_pago").hide();
                
                $("#div_metodo_pago").empty();
            }
        });
        
                
               $("#btnContinuarMP").click(function(){
                   
                   x_doAjaxCall(
                           'POST',
                            BASE_PATH+"crear_suscripcion.do",
                            "",
                            function(data){
                               
                                if(data.result){
                                    $("#div_metodo_pago").spin("large");
                                     x_loadModule('abono', 'pago_tarjeta', '', 'div_metodo_pago');
                     
                                }else{
                                    x_alert(data.msg);
                                }
                            });
                   
                    
                });
                
                
    });

</script>

{/literal}
