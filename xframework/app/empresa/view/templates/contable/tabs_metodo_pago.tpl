
<div class="pass-sante-registro-planes">

    <div class="checkout-form" id="form_cambiar_metodo_pago">
        {if $metodo_pago == ''}
            <h2 class="text-center">{"Debe cargar un método de pago"|x_translate}</h2>
        {else}
            <h2 class="text-center">{"Agregar nuevo método de pago"|x_translate}</h2>
        {/if}
        <div id="tabs-metodo-pago" class="tabs-metodo-pago">	
            <ul class="nav nav-tabs">
                <li class="active">
                    <a  href="#tarjeta-credito-panel" data-toggle="tab"><i class="fa fa-credit-card"></i>{"Tarjeta de crédito"|x_translate}</a>
                </li>
                <li><a href="#sepa-panel" data-toggle="tab"><i class="fa fa-bank"></i>{"Débito SEPA"|x_translate}</a>
                </li>

            </ul>

            <div class="tab-content ">
                <div class="tab-pane active" id="tarjeta-credito-panel">
                    {*PAGO TARJETA*}
                    <div class="okm-row">
                        <div id="payment-form" class="payment-form">
                            <input type="hidden" id="customerId" value="{$usuario_empresa.stripe_customerid}">
                            <input type="hidden" id="priceId" value="{$plan_contratado.stripe_priceid}">
                            <input id="email_tarjeta" type="hidden" value="{$usuario_empresa.email}" />
                            <div class="okm-row ">
                                <div class="mapc-input-line">
                                    <label for="titular_tarjeta" class="mapc-label"> {"Titular de la tarjeta"|x_translate}</label>
                                    <input id="titular_tarjeta" type="text"  value="{$usuario_empresa.nombre} {$usuario_empresa.apellido}" placeholder="{$usuario_empresa.nombre} {$usuario_empresa.apellido}"/>
                                </div>
                            </div>
                            <div class="okm-row ">
                                <label for="card-element" class="mapc-label">
                                    {"Número de tarjeta"|x_translate}
                                </label>

                                <div id="card-element" class="payment-element" ></div>
                            </div>
                            <!-- Errores ocurridos. -->
                            <div id="card-element-errors" class="card-element-errors" role="alert"></div>

                        </div>
                        <div class="mapc-registro-form-row center">
                            <button class="btn-default btn-process-checkout disabled" id="btn-process-checkout" type="submit">{"Adherir"|x_translate}</button>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="sepa-panel">
                    {*PAGO SEPA*}
                    <div class="okm-row">
                        <div id="setup-form-sepa" class="payment-form">
                            <input id="email_sepa" type="hidden" value="{$usuario_empresa.email}" />
                            <div class="okm-row ">
                                <div class="mapc-input-line">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Titular de la cuenta"|x_translate}</label>
                                    <input id="titular_cuenta_sepa" type="text"  value="{$empresa.empresa}" placeholder="{$empresa.empresa}" />
                                </div>

                            </div>
                            <div class="okm-row">
                                <label for="iban-element" class="mapc-label">
                                    {"IBAN"|x_translate}
                                </label>
                                <div id="iban-element" class="payment-element">
                                    <!-- Stripe Element se inserta aqui -->
                                </div>
                            </div>

                            <!-- Errores ocurridos. -->
                            <div id="sepa-element-errors"  class="card-element-errors"  role="alert"></div>
                        </div>

                        <div class="mapc-registro-form-row center">
                            <button class="btn-default btn-process-checkout disabled" id="btn-process-sepa" type="submit" data-secret="{$usuario_empresa.stripe_client_secret}">
                                {"Adherir"|x_translate}</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
<script>
    var STRIPE_APIKEY_PUBLIC = "{$STRIPE_APIKEY_PUBLIC}";
</script>
<script src="https://js.stripe.com/v3/"></script>
{literal}
    <script>
    $(function () {
        /*TARJETA CREDITO*/
        //Stripe api inicilizacion - Elements
        var stripe = Stripe(STRIPE_APIKEY_PUBLIC, {locale: 'fr'});
        var elements = stripe.elements();
        let style = {
            base: {
                iconColor: '#c4f0ff',
                color: '#333333',
                backgroundColor: '#ffffff',
                fontWeight: '600',
                fontFamily: 'Roboto, Open Sans, Segoe UI, sans-serif',
                fontSize: '16px',
                fontSmoothing: 'antialiased',
                ':-webkit-autofill': {
                    color: '#007d8b'
                },
                '::placeholder': {
                    color: '#415b70'
                }
            },
            invalid: {
                iconColor: '#F33243',
                color: '#F33243'
            }};
        //Creamos el formulario de los datos de la tarjeta con la API Elements de Stripe
        var cardElement = elements.create('card', {style: style});
        $("body").spin("large");
        cardElement.mount('#card-element');
        //validar datos de tarjeta ingresados mientra tipea
        cardElement.on('change', function (event) {
            // activar boton pago
            if (event.complete) {
                $("#btn-process-checkout").removeClass("disabled");
                $("#card-element-errors").text('');
            } else if (event.error) {
                $("#btn-process-checkout").addClass("disabled");
                //mostrar error
                displayError(event);
            }
        });
        cardElement.on('ready', function (event) {
            $("body").spin(false);
            cardElement.focus();
        });
        /**
         * Método encargado de mostrar los errores en el formulario de datos de la tajeta
         * @type Element
         */
        function displayError(event) {
            console.log(event);
            if (event.elementType === "card") {
                var displayError = document.getElementById('card-element-errors');
            } else {
                var displayError = document.getElementById('sepa-element-errors');
            }

            if (event.error) {
                displayError.textContent = event.error.message;
            } else {
                displayError.textContent = '';
            }
        }
        /*
         * Metodo encargado de crear el metodo de pago para la suscripcion de un cliente a un plan empresa del pass esalud
         * @param {type} customerId
         * @param {type} paymentMethodId
         * @param {type} priceId
         * @returns {unresolved}
         */
        function crear_metodo_pago(cardElement) {
            $("body").spin("large");
            return stripe
                    .createPaymentMethod({
                        type: 'card',
                        card: cardElement,
                        billing_details: {
                            name: $("#titular_tarjeta").val(),
                            email: $("#email_tarjeta").val()
                        }
                    })
                    .then((result) => {
                        $("body").spin(false);
                        if (result.error) {
                            console.log("createPaymentMethod Error:", result.error);
                            displayError(result);
                        } else {
                            //enviamos a actualizar la suscripcion con todos los datos de la tajeta (metodo pago)
                            actualizar_metodo_pago_suscripcion(result.paymentMethod.id);
                        }
                    });
        }
        /*
         * Si el métodos de pago que requieren autenticación de cliente con 3D Secure, 
         * en la pantalla se notifica al cliente que se requiere autenticación para completar el pago e iniciar la suscripción
         * @param {type} customerId
         * @param {type} paymentMethodId
         * @param {type} priceId
         * @returns {unresolved}
         */
        function handlePaymentThatRequiresCustomerAction(subscription, paymentMethodId) {
            console.log("subscription:", subscription);
            console.log("paymentMethodId:", paymentMethodId);
            let setupIntent = subscription.pending_setup_intent;
            if (setupIntent && setupIntent.status === 'requires_action')
            {
                return stripe
                        .confirmCardSetup(setupIntent.client_secret, {
                            payment_method: paymentMethodId
                        })
                        .then((result) => {
                            if (result.error) {
                                console.log("confirmCardSetup Error:", result);
                                displayError(result);
                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            } else {
                                if (result.setupIntent.status === 'succeeded') {
                                    onSubscriptionComplete(result);
                                }
                            }
                        });
            }
        }
        /**
         * Resolucion de llamada exitosa después de que se actualiza la suscripción.
         * @param {type} subscription
         * @returns {undefined}
         */
        function onSubscriptionComplete(subscription) {
            console.log("Subscription complete:", subscription);
            // Metodo agregado con Exito
            if (subscription.status === 'active') {
                $("#form_cambiar_metodo_pago").slideUp();
                x_alert(x_translate("Se ha registrado su nuevo método de pago para su suscripcion"), recargar);
            } else {
                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
            }
        }
        /*
         * Funcion encargada de realizar la llamada para actualizar el metodo de pago de la suscripcion del Pass bien-être
         */
        function  actualizar_metodo_pago_suscripcion(paymentMethodId) {
            console.log("paymentMethodId", paymentMethodId);
            if (!paymentMethodId) {
                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                return false;
            }
            $("body").spin("large");
            return x_doAjaxCall(
                    'POST',
                    BASE_PATH + "empresa.php?action=1&modulo=contable&submodulo=cambiar_metodo_pago",
                    "paymentMethodId=" + paymentMethodId,
                    function (data) {
                        console.log("data result", data);
                        $("body").spin(false);
                        if (data.error) {
                            console.log("Error:", data);
                            displayError(data);
                            x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            return false;
                        }
                        //Transaccion de suscripcion exitosa
                        if (data.result && data.id && data.id !== "") {
                            //Si la tarjeta requiere autorizacion, se lanza una excepcion y se muestra el error
                            if (data.pending_setup_intent && data.pending_setup_intent.status === 'requires_action') {
                                return handlePaymentThatRequiresCustomerAction(data, paymentMethodId);
                            }

                            // Normalizamos el resultado, devolvemos la info de Stripe
                            return onSubscriptionComplete(data);
                        } else {
                            if (data.msg) {
                                if (data.home == '1') {
                                    x_alert(data.msg, function () {
                                        window.location.href = BASE_PATH + "entreprises/";
                                    });
                                } else {
                                    x_alert(data.msg);
                                }
                            } else {
                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            }

                        }
                    });
        }

        /*
         * Listener de evento para crear metodo de pago con los datos de la tarjeta llamado a la API de Stripe
         */
        $("#btn-process-checkout").click(function () {
            if ($(this).hasClass("disabled")) {
                return false;
            }
            if ($("#titular_tarjeta").val() === "" || $("#email_tarjeta").val() === "") {
                x_alert(x_translate("Complete los datos obligatorios"));
                return false;
            }
            if (cardElement) {
                crear_metodo_pago(cardElement);
            } else {
                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
            }
        });
        /*Configuracion pago SEPA*/
        /*IBAN*/
        var optionsIBAN = {
            style: style,
            supportedCountries: ['SEPA'],
            // Elements usa un placeholder con el formato de IBAN del pais seleccionado
            placeholderCountry: 'FR'
        };
        // Creamos la intancia del IBAN Elements con Stripe
        var iban = elements.create('iban', optionsIBAN);
        // Agregamos la instancia de IBAN Elements al  html de la pagina
        iban.mount('#iban-element');
        //validar datos de tarjeta ingresados mientra tipea
        iban.on('change', function (event) {
            // activar boton pago
            if (event.complete) {
                $("#btn-process-sepa").removeClass("disabled");
                $("#sepa-element-errors").text('');
            } else if (event.error) {
                //mostrar error
                $("#btn-process-sepa").removeClass("disabled");
                displayError(event);
            }
        });
        /*
         * Listener encargado de crear el metodo de pago en Stripe para la suscripcion de un cliente a un plan empresa del pass esalud
         */
        $("#btn-process-sepa").click(function (e) {
            if ($(this).hasClass("disabled")) {
                return false;
            }
            e.preventDefault();
            let email = $("#email_sepa").val();
            let nombre = $("#titular_cuenta_sepa").val();
            let  clientSecret = $("#btn-process-sepa").data("secret");
            if (email === "" || nombre === "") {
                x_alert(x_translate("Complete los datos obligatorios"));
                return false;

            }
            $("body").spin("large");
            return stripe
                    .createPaymentMethod({
                        type: 'sepa_debit',
                        sepa_debit: iban,
                        billing_details: {
                            name: nombre,
                            email: email
                        }
                    })
                    .then((result) => {
                        $("body").spin(false);
                        if (result.error) {
                            console.log("createPaymentMethod Error:", result.error);
                            displayError(result);
                        } else {
                            //enviamos a actualizar la suscripcion con todos los datos de la tajeta (metodo pago)
                            actualizar_metodo_pago_suscripcion(result.paymentMethod.id);
                        }
                    });

        });
    }
    );
    </script>
{/literal}