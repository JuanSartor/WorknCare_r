<div class="cell stripe-checkout stripe-checkout2" id="stripe-checkout-2">
    <form>
        <div data-locale-reversible>
            <div class="row">
                <div class="field">
                    <input id="stripe-checkout2-address" class="input empty" type="text" placeholder="2 bld Henri Becquerel" required="" autocomplete="address-line1">
                    <label for="stripe-checkout2-address">{"Dirección"|x_translate}</label>
                    <div class="baseline"></div>
                </div>
            </div>
            <div class="row" data-locale-reversible>
                <div class="field half-width">
                    <input id="stripe-checkout2-city" class="input empty" type="text" placeholder="Yutz" required="" autocomplete="address-level2">
                    <label for="stripe-checkout2-city">{"Ciudad"|x_translate}</label>
                    <div class="baseline"></div>
                </div>
                {*<div class="field quarter-width">
                <input id="stripe-checkout2-state"  class="input empty" type="text" placeholder="CA" required="" autocomplete="address-level1">
                <label for="stripe-checkout2-state" >{"Ciudad"|x_translate}</label>
                <div class="baseline"></div>
                </div>*}
                <div class="field quarter-width">
                    <input id="stripe-checkout2-zip" class="input empty" type="text" placeholder="57970" required="" autocomplete="postal-code">
                    <label for="stripe-checkout2-zip">{"Código Postal"|x_translate}</label>
                    <div class="baseline"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="field">
                <div id="stripe-checkout2-card-number" class="input empty"></div>
                <label for="stripe-checkout2-card-number" >{"Número de tarjeta"|x_translate}</label>
                <div class="baseline"></div>
            </div>
        </div>
        <div class="row">
            <div class="field half-width">
                <div id="stripe-checkout2-card-expiry" class="input empty"></div>
                <label for="stripe-checkout2-card-expiry" >{"Fecha de expiración"|x_translate}</label>
                <div class="baseline"></div>
            </div>
            <div class="field half-width">
                <div id="stripe-checkout2-card-cvc" class="input empty"></div>
                <label for="stripe-checkout2-card-cvc" >{"CVC"|x_translate}</label>
                <div class="baseline"></div>
            </div>
        </div>
        {*<button type="submit" data-tid33="elements_stripe-checkouts.form.pay_button">Pay $25</button>*}
        <div class="error" role="alert">

            <span class="message"></span>
        </div>
    </form>

</div>
