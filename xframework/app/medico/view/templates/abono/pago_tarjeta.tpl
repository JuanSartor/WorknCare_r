<h5 class="light">{"Pago con Tarjetas de crédito"|x_translate}</h5>

<div class="col-md-4 col-sm-6 col-xs-12">
    <input type="hidden" id="p_key" value="{$p_key}">
    <input type="hidden" id="checkout_session_id" value="{$checkout_session_id}">
    <div class="hidden-xs">
        <img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX">
    </div>
    <div class="visible-xs text-center">
        <img class="img-responsive" src="{$IMGS}visa-mastercard-amex.png" alt="VISA, Mastercard, AMEX">
    </div>
</div>
<div class="col-md-5 col-sm-6 col-xs-12">
    <a  href="javascript:;" id="btn_submit" role="button" class="step-btn uppercase next pull-right hidden-xs">{"Pagar"|x_translate}</a>
    <a  href="javascript:;" id="btn_submit_xs" role="button" class="step-btn uppercase next visible-xs">{"Pagar"|x_translate}</a>
    <p>&nbsp;</p>
</div>   
{literal}
    <script>
        $(function () {
            var stripe = Stripe($("#p_key").val());
            var checkoutSessionId = $("#checkout_session_id").val();

            $("#div_metodo_pago").spin(false);
            $('html, body').animate({
                scrollTop: $("#div_metodo_pago").offset().top - 56
            }, 1000);

            $("#btn_submit, #btn_submit_xs").click(function () {
                stripe.redirectToCheckout({
                    // Make the id field from the Checkout Session creation API response
                    // available to this file, so you can provide it as parameter here
                    // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
                    sessionId: checkoutSessionId
                }).then(function (result) {
                    // If `redirectToCheckout` fails due to a browser or network
                    // error, display the localized error message to your customer
                    // using `result.error.message`.
                });
            });
        });
    </script>
{/literal}