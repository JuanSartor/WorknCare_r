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
    <a href="javascript:;" id="payuCheckout" name="payu-checkout" class="btn-payu-checkout step-btn uppercase pull-right hidden-xs" role="button">{"Pagar"|x_translate}</a>
    <a href="javascript:;" id="payuCheckout_xs" name="payu-checkout" class="btn-payu-checkout step-btn uppercase visible-xs" role="button">{"Pagar"|x_translate}</a>
    <p>&nbsp;</p>
</div>
{*Formulario para PayU*}                            
                            
<form style="display:none" id="frmPayU" action="{$datos_pago_payu.action}" method="POST">
    <input type="hidden" name="merchantId" id="merchantId" value="{$datos_pago_payu.merchantId}"> {*idcomercio*}
    <input type="hidden" name="referenceCode" id="referenceCode" value="{$datos_pago_payu.referenceCode}">
    <input type="hidden" name="description" id="description" value="{$datos_pago_payu.description}">
    <input type="hidden" name="amount" id="amount" value="{$datos_pago_payu.amount}">
    <input type="hidden" name="tax" id="tax" value="{$datos_pago_payu.tax}">
    <input type="hidden" name="taxReturnBase" id="taxReturnBase" value="{$datos_pago_payu.taxReturnBase}">
    <input type="hidden" name="signature" id="signature" value="{$datos_pago_payu.signature}">
    <input type="hidden" name="accountId" id="accountId" value="{$datos_pago_payu.accountId}"> {*idcuenta*}
    
    <input type="hidden" name="currency" id="currency" value="{$datos_pago_payu.currency}">
    <input type="hidden" name="buyerEmail" id="buyerEmail" value="{$datos_pago_payu.buyerEmail}">
    <input type="hidden" name="buyerFullName" id="buyerFullName" value="{$datos_pago_payu.buyerFullName}">
    
    {if $datos_pago_payu.test == 1}
    <input type="hidden" name="test" value="{$datos_pago_payu.test}">
    <input type="hidden" name="responseUrl" id="responseUrl" value="{$datos_pago_payu.responseUrl}">
    <input type="hidden" name="confirmationUrl" id="confirmationUrl" value="{$datos_pago_payu.confirmationUrl}">
    {/if}
</form>

{literal}
<script>
    $(function(){
        $("#div_metodo_pago").spin(false);
        $('html, body').animate({
            scrollTop: $("#div_metodo_pago").offset().top - 56
        }, 1000);        
    });

    $("#payuCheckout, #payuCheckout_xs").click(function(){
        $('#frmPayU').submit();
    });
</script>
{/literal}