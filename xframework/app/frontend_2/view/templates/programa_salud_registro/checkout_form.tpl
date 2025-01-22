
<div class="checkout-form" id="checkout-form" style="display:none">
    <h3>{"Agrega tu tarjeta o cuenta bancaria"|x_translate}</h3>
    <div class="plan-contratado">
        <h4 class="nombre-plan">{"Su plan contratado:"|x_translate} {$plan_contratado.nombre} </h4>
        <p>
            <i class="fa fa-check"></i> {"Fecha de inicio"|x_translate}: {$plan_contratado.fecha_adhesion_format}
        </p>
        <p>
            <i class="fa fa-check"></i> 
            {if $plan_contratado.idprograma_salud_plan!=4}               
                {math equation="x+y" x=$plan_contratado.cant_videoconsulta y=$plan_contratado.cant_consultaexpress}  {"consultas por empleado / por año"|x_translate}
            {else}
                {"Consultas Ilimitadas"|x_translate}
            {/if}
        </p> 
        <p>
            <i class="fa fa-check"></i> {"Compromiso de un año, tácitamente renovable"|x_translate}
        </p>
        <p>
            <i class="fa fa-check"></i> {$plan_contratado.precio}  &euro; {"precio por beneficiario / por mes"|x_translate} * 
        </p> 
        {if $cupon.codigo_cupon!=""}
            <p>
                <i class="fa fa-tag" style="transform:rotate(90deg)"></i>&nbsp;{"Cupón de descuento"|x_translate}: {$cupon.codigo_cupon} <em><small>({$cupon.descuento})</small></em>
            </p> 
        {/if}
    </div>


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
                                <input id="titular_cuenta_sepa" type="text"  value="{$usuario_empresa.empresa}" placeholder="{$usuario_empresa.empresa}" />
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
    <div class="aclaracion-debito">
        <p>* {"Votre carte ou compte sera débitée à la fin de chaque mois."|x_translate}</p>
      <!--  <p>{"Número de beneficiarios reales al final del mes multiplicado por la tarifa por empleado que ha decidido financiar con su Plan de Salud contratado."|x_translate}</p>
        <p class="ejemplo">{"Ej: 7 beneficiarios registrados x 8 € sin impuestos = 56 € sin impuestos retirados a final de mes"|x_translate}</p>
        -->
    </div>
</div>

<div class="okm-row plogin-mensaje-registro" id="subscription_ok_message" style="display:none;">

    <div class="text-center" style="width:100px; margin:auto;">
        <div class="animationContainer animated rubberBand">
            <svg  xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 85 82" xml:space="preserve">
            {literal}
                <style type="text/css">
                    .st00{fill:#EAEAEA;}
                    .st10{clip-path:url(#SVGID_2_);fill:none;stroke:#6A6F72;stroke-width:80;stroke-linecap:round;stroke-miterlimit:10;}
                    .st20{fill:none;stroke:#00E7B6;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                    .st30{fill:none;stroke:#BA4343;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                </style>
            {/literal}
            <g>
            <path class="st20 CVKuhQYc_0" d="M67.6,19.5c0.2,0.2,0.4,0.5,0.6,0.7c0.2,0.2,0.4,0.5,0.6,0.7c4.2,5.5,6.7,12.5,6.7,20c0,18.2-14.8,33-33,33
                  s-33-14.8-33-33s14.8-33,33-33c9.4,0,17.9,3.9,23.9,10.3c0.3,0.4,0.7,0.7,1,1.1"></path>
            <path class="st20 CVKuhQYc_1" d="M66.9,19.8L35.3,51.3L23,39"></path>
            </g>
            {literal}
                <style>.CVKuhQYc_0{stroke-dasharray:208 210;stroke-dashoffset:209;animation:CVKuhQYc_draw 918ms ease-out 0ms forwards;}.CVKuhQYc_1{stroke-dasharray:63 65;stroke-dashoffset:64;animation:CVKuhQYc_draw 281ms ease-out 918ms forwards;}@keyframes CVKuhQYc_draw{100%{stroke-dashoffset:0;}}@keyframes CVKuhQYc_fade{0%{stroke-opacity:1;}92.5925925925926%{stroke-opacity:1;}100%{stroke-opacity:0;}}
                </style>
            {/literal}
            </svg>
        </div>

    </div>

    <h3>{"¡Se ha registrado su suscripción de forma exitosa!"|x_translate}</h3>

    <p class="plogin-envio-correo">
        {"Ha continuación podrá generar una invitación WorknCare"|x_translate}
    </p>
    <div class="plogin-mensaje-registro-actions">
        <a href="{$url}programmes-bienetre/checkout_ok.html?id={$plan_contratado.hash}" class="btn-default">{"Continuar"|x_translate}</a>
    </div>

</div>

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
            function crear_metodo_pago(cardElement, customerId, priceId) {
                $("body").spin("large");
                return stripe
                        .createPaymentMethod({
                            type: 'card',
                            card: cardElement
                        })
                        .then((result) => {
                            $("body").spin(false);
                            if (result.error) {
                                console.log("createPaymentMethod Error:", result.error);
                                displayError(result);
                            } else {
                                //enviamos a crear la suscripcion con todos los datos de la tajeta (metodo pago)
                                crear_suscripcion(customerId, result.paymentMethod.id, priceId);
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
             * Resolucion de llamada exitosa después de que se crea la suscripción.
             * @param {type} subscription
             * @returns {undefined}
             */
            function onSubscriptionComplete(subscription) {
                console.log("Subscription complete:", subscription);
                // Pago Exitoso
                if (subscription.status === 'active') {
                    $("#checkout-form").hide();
                    $("#subscription_ok_message").fadeIn();
                } else {
                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                }
            }
            /*
             * Funcion encargada de realizar la llamada para crear la suscripcion de un cliente a un plan del Pass bien-être
             */
            function crear_suscripcion(customerId, paymentMethodId, priceId) {
                console.log("customerId", customerId);
                console.log("paymentMethodId", paymentMethodId);
                console.log("priceId", priceId);
                if (!customerId || !paymentMethodId || !priceId) {
                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                    return false;
                }
                $("body").spin("large");
                return x_doAjaxCall(
                        'POST',
                        BASE_PATH + "frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=crear_suscripcion",
                        "customerId=" + customerId + "&paymentMethodId=" + paymentMethodId + "&priceId=" + priceId,
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
                                    x_alert(data.msg);
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
                let customerId = $("#customerId").val();
                let priceId = $("#priceId").val();
                if (priceId && customerId && cardElement) {
                    crear_metodo_pago(cardElement, customerId, priceId);
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
                let  customerId = $("#customerId").val();
                let  priceId = $("#priceId").val();
                if (nombre !== "" && email !== "" && clientSecret !== "") {
                    $("body").spin("large");
                    stripe.confirmSepaDebitSetup(
                            clientSecret,
                            {
                                payment_method: {
                                    sepa_debit: iban,
                                    billing_details: {
                                        name: nombre,
                                        email: email
                                    }
                                }
                            }
                    ).then((result) => {
                        $("body").spin(false);
                        console.log("Result SEPA", result);
                        if (result.error) {
                            console.log("createPaymentMethod SEPA Error:", result.error);

                            //verificamos si el error es porque ya se logró crear el intento de pago - 
                            //En este caso No se puede actualizar el setup_itent, ya fue creado con exito entonces continuamos igual
                            if (result.error.code === "setup_intent_unexpected_state" && result.error.setup_intent) {
                                let  setupIntent = result.error.setup_intent;
                                if (setupIntent.payment_method && setupIntent.payment_method !== "" && setupIntent.status && setupIntent.status === "succeeded") {
                                    crear_suscripcion(customerId, setupIntent.payment_method, priceId);
                                } else {
                                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                                }
                            } else {
                                //sino mostramos el error
                                $("#sepa-element-errors").text(result.error.message);
                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            }
                        } else {

                            let setupIntent = result.setupIntent;
                            console.log("setupIntent", setupIntent);
                            //enviamos a crear la suscripcion con todos los datos de cuenta SEPA (metodo pago)F
                            if (setupIntent.payment_method && setupIntent.payment_method !== "" && setupIntent.status && setupIntent.status === "succeeded") {
                                crear_suscripcion(customerId, setupIntent.payment_method, priceId);
                            } else {
                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            }

                        }
                    });
                } else {
                    x_alert(x_translate("Verifique los datos ingresados"));
                }


            });
        }
        );
    </script>
{/literal}