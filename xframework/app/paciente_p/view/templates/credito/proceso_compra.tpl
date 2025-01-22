<style>
    section.sign-up>.nav-tabs {
        display: flex;
        justify-content: space-around;
    }
    section.sign-up>.nav-tabs li span {
        width: min-content;
    }
    section.mapc-mi-cuenta .metodo-pago img{
        width:230px;
        margin: auto;

    } 
    section.mapc-mi-cuenta .purchase-summary{
        width:230px;
        margin: auto;

    } 
    section.sign-up>.nav-tabs li span:after {
        display: none;
    }
    .mapc-action-center {
        text-align: center;
        padding: 16px;
    }
</style>
<script src="https://js.stripe.com/v3/"></script>      
<div class="container">

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
            <li><span class="dp-pin">{"Pago"|x_translate}</span></li>
        </ul>
        <div class="tab-content" id="tabs-proceso">
            <div role="tabpanel" class="tab-pane active fade in" id="product">

                <section class="mapc-mi-cuenta">
                    <h2 class="mapc-section-title">{"¿CUANTO DESEA CARGAR DE CREDITO?"|x_translate}</h2>

                    <div class="okm-row">
                        <div class="mapc-select-box">
                            <span>&euro;&nbsp;</span>
                            <div class="price-select">

                                <div class="">
                                    <input type="text" id="monto_compra" value="{$smarty.request.compra}" class="form-control" placeholder='{"Mínimo"|x_translate} &euro; 5'>
                                </div>
                            </div>
                        </div>
                    </div>

                   {* <div class="mapc-action-center">
                        <a href="#billing" class="step-btn uppercase" id="btnConfirmarMonto" data-toggle="tab" role="button">{"Continuar"|x_translate}</a>
                    </div>*}
                    <div class="okm-row text-center metodo-pago ">
                        <p class="light">{"Pago con Mercado Pago"|x_translate}:</p>
                        <img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX">
                    </div>
                </section>
            </div>


            <div role="tabpanel" class="tab-pane fade relative" id="billing">

                <section class="mapc-mi-cuenta">
                    <div class="purchase-summary">
                        <div class="text-center total">
                            <p>{"Total a pagar"|x_translate}:</p>
                            <p class="price"></p>
                            {*<p class="uppercase">&euro;</p>*}
                            <p></p>
                            <div class="row relative mapc-action-center" id="div_metodo_pago">
                                <a href="javascript:;" role="button" class="uppercase ">{"Pagar"|x_translate}</a>
                            </div>
                            {*<div id="div_mercado_pago">
                            <a class="uppercase" role="button" data-toggle="tab" href="#div_metodo_pago" id="btnContinuarMP">{"Continuar"|x_translate}</a>
                            </div>*}

                        </div>



                        <div class="okm-row text-center metodo-pago">
                            <p class="light">{"Pago con Mercado Pago"|x_translate}:</p>
                            <img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX">
                        </div>
                        <div class="mapc-action-center">
                           {* <a  href="#product" id="btn_submit"  data-toggle="tab" class="uppercase  btn btn-xs  btn-secondary">{"Volver"|x_translate}</a>*}
                        </div>
                    </div>
                    {* <h5 class="uppercase light">{"Pago"|x_translate}</h5>
                    <div class="purchase-summary">
                    <div class="row">
                    <div class="col-md-9">
                    <div class="table-responsive">
                    <table>
                    <tr>
                    <th>{"Detalle"|x_translate}</th>
                    <th>{"Medio de pago"|x_translate}</th>
                    <th></th>
                    <th>{"Subtotal"|x_translate}</th>
                    </tr>
                    <tr>
                    <td>{"Recarga de crédito"|x_translate}</td>
                    <td>
                    <select class="form-control select select-primary select-block mbl" name="metodo_pago" id="metodo_pago">
                    <option value="">{"Seleccione Método Pago"|x_translate}</option>
                    {html_options options=$combo_metodo_pago}
                    </select>
                    </td>
                    <td></td>
                    <td class="stotal"></td>
                    </tr>
                    
    
                    </table>
                    </div>
                    </div>
                    <div class="col-md-2 col-md-offset-1 text-center total">
                    <p>{"Total a pagar"|x_translate}</p>
                    <p class="price"></p>
                    <p class="uppercase">&euro;</p>
                    <p></p>
                    <br />
                    <div id="div_mercado_pago">
                    <a class="uppercase" role="button" data-toggle="tab" href="#div_metodo_pago" id="btnContinuarMP">{"Continuar"|x_translate}</a>
                    </div>
    
    
                    </div>
                    </div>
                    <div class="clearfix"></div>
                    <hr />
    
                    <div class="payment-options">
    
                    <div class="row relative" id="div_metodo_pago">
    
    
                    </div>
                    </div>
                    </div>*}
                </section>
            </div>
        </div>
    </section>

</div>

{literal}
    <script>
        var monto_compra;

        $(document).ready(function () {


            //redondeamos el precio de las consultas multiplo de 10
            $("#monto_compra").change(function () {
                var valor = $(this).val();

                if (valor.indexOf(',') !== -1) {
                    valor = valor.substr(0, valor.indexOf(','));
                }
                /*if (valor % 10 <= 5) {
                 valor_new = valor - valor % 10;
                 $(this).val(valor_new);
                 } else {
                 valor_new = valor - valor % 10 + 10;
                 $(this).val(valor_new);
                 }*/
            });
           /* $("#btnConfirmarMonto").click(function (e) {
                if ($("#monto_compra").val() == "") {
                    e.preventDefault();
                    e.stopPropagation();
                    x_alert(x_translate("Ingrese un monto de compra de crédito"));
                    return false;
                }
                if (parseInt($("#monto_compra").val()) < 5) {
                    e.preventDefault();
                    e.stopPropagation();
                    x_alert(x_translate("La compra de crédito debe ser mayor al mínimo"));
                    return false;
                }
                //$('#signup-steps li:eq(1)').addClass("active");

                //seteamos el precio seleccionado en la siguiente pantalla
                monto_compra = $("#monto_compra").val();

                $("td.stotal").html("&euro; " + monto_compra);
                $("td.ptotal").html("&euro; " + monto_compra);
                $("p.price").html("&euro; " + monto_compra);
                scrollToEl($("body"));
                $("body").spin("large");
                x_loadModule('credito', 'pago_mercadopago', 'monto_compra=' + monto_compra + '&codigo=' + $("div.promo-code input").val(), 'div_metodo_pago', BASE_PATH + "paciente_p");


            });*/


            /*$("#btnContinuarMP").click(function () {
             $("#div_metodo_pago").spin("large");
             x_loadModule('credito', 'pago_mercadopago', 'monto_compra=' + monto_compra + '&codigo=' + $("div.promo-code input").val(), 'div_metodo_pago', BASE_PATH + "paciente_p");
             
             });*/

        });

    </script>

{/literal}
