<h5 class="light">{"Pago con Mercado Pago"|x_translate}</h5>

<div class="col-md-4 col-sm-6 col-xs-12">
    <div class="hidden-xs">
        <button class="card"><img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX"></button>
    </div>
    
    <div class="visible-xs text-center">
        <button class="card"><img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX"></button>
    </div>
</div>

<div class="col-md-5 col-sm-6 col-xs-12">
    <a  href="{$enlace}" id="submitter" name="MP-Checkout" class="step-btn uppercase pull-right hidden-xs" {*data-toggle="tab"*} role="button">{"Pagar"|x_translate}</a>
    <a  href="{$enlace}" id="submitter" name="MP-Checkout" class="step-btn uppercase visible-xs" {*data-toggle="tab"*} role="button">{"Pagar"|x_translate}</a>
    <p>&nbsp;</p>
</div>

<script src="https://js.stripe.com/v3/"></script>

{literal}
<script>
    $(function(){
        $("#div_metodo_pago").spin(false);
        $('html, body').animate({scrollTop: $("#div_metodo_pago").offset().top  - 56}, 1000);
        
    });

</script>
{/literal}