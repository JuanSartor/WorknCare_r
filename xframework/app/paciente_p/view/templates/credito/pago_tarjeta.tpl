<h5 class="light">Pago con Tarjetas de crédito</h5>



 <div class="col-md-4 col-sm-6 col-xs-12">
                                <div class="hidden-xs">
                                    <button class="card"><img class="img-responsive" src="{$IMGS}amex_logo.png" alt="American Express"></button>
                                    <button class="card"><img class="img-responsive" src="{$IMGS}visa_logo.png" alt="Visa"></button>
                                    <button class="card"><img class="img-responsive" src="{$IMGS}mastercard_logo.png" alt="Mastercard"></button>
                                </div>
                                <div class="visible-xs text-center">
                                    <button class="card"><img class="img-responsive" src="{$IMGS}amex_logo.png" alt="American Express"></button>
                                    <button class="card"><img class="img-responsive" src="{$IMGS}visa_logo.png" alt="Visa"></button>
                                    <button class="card"><img class="img-responsive" src="{$IMGS}mastercard_logo.png" alt="Mastercard"></button>
                                </div>

                            </div>
                            <div class="col-md-5 col-sm-6 col-xs-12">
                               <a  href="{$enlace}" id="submitter" name="MP-Checkout" class="step-btn uppercase pull-right hidden-xs" {*data-toggle="tab"*} role="button">{"Pagar"|x_translate}</a>
                               <a  href="{$enlace}" id="submitter" name="MP-Checkout" class="step-btn uppercase visible-xs" {*data-toggle="tab"*} role="button">{"Pagar"|x_translate}</a>

                                <p>&nbsp;</p>
                            </div>
{*<script type="text/javascript" src="https://www.mercadopago.com/org-img/jsapi/mptools/buttons/render.js"></script>*}

{literal}
<script>
    $(function(){
        $("#div_metodo_pago").spin(false);
        $('html, body').animate({
scrollTop: $("#div_metodo_pago").offset().top  - 56
}, 1000);
        
    });

</script>
{/literal}