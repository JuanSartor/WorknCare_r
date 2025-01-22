
<div class="boton-pago">
    <input type="hidden" id="p_key" value="{$p_key}">
    <input type="hidden" id="checkout_session_id" value="{$checkout_session_id}">
   {* <a  href="javascript:;" id="btn_submit" role="button" class="uppercase ">{"Pagar"|x_translate}</a>*}
</div>
{literal}
    <script>
        $(function () {
            var stripe = Stripe($("#p_key").val());
            var checkoutSessionId = $("#checkout_session_id").val();

            $("body").spin(false);
            //$('html, body').animate({scrollTop: $("#div_metodo_pago").offset().top - 56}, 1000);

            $("#btn_submit").click(function () {
                stripe.redirectToCheckout({
                    // Make the id field from the Checkout Session creation API response
                    // available to this file, so you can provide it as parameter here
                    // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
                    sessionId: checkoutSessionId
                }).then(function (result) {
                    x_alert(result.error.message);
                    // If `redirectToCheckout` fails due to a browser or network
                    // error, display the localized error message to your customer
                    // using `result.error.message`.
                });
                //redirectToCheckout();
            });
        });

    </script>
{/literal}