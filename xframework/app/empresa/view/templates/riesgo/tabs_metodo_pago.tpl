<style>
    .input-factura{
        padding: 8px !important;
    }
</style>

<div class="" style="width: 600px">

    <div class="checkout-form" id="form_cambiar_metodo_pago">

        <div id="tabs-metodo-pago" class="tabs-metodo-pago">	

            <div class="tab-content ">
                <div class="tab-pane " id="tarjeta-credito-panel">
                    {*PAGO TARJETA*}
                    <div class="okm-row">
                        <div id="payment-form" class="payment-form">
                            <input type="hidden" id="idPagoRecomensa" value="{$pago_recompensa.idpago_recompensa_encuesta}">
                            <input type="hidden" id="clientSecret" value="{$pago_recompensa.client_secret}">
                            <input type="hidden" id="customerId" value="{$usuario_empresa.stripe_customerid}">
                            <input type="hidden" id="priceId" value="{$pago_recompensa.priceId}">
                            <input type="hidden" id="idempresa" value="{$usuario_empresa.empresa_idempresa}">
                            <input id="email_tarjeta" type="hidden" value="{$usuario_empresa.email}" />
                            <input id="cantCuestionariosListos" type="hidden" value="{$cantCuestionariosListos}" />

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
                            <button class="btn-default btn-process-checkout disabled" id="btn-process-checkout" type="submit">{"Pagar"|x_translate}</button>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="sepa-panel">
                    {*PAGO SEPA*}
                    <div class="okm-row">
                        <div id="setup-form-sepa" class="payment-form">

                            <div class="okm-row  ">
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Su empresa"|x_translate}</label>
                                    <input id="input_empresa" class="input-factura" type="text"  value="{$empresa.empresa}" placeholder="{$empresa.empresa}" />
                                </div>
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Numero de identificacion(ex: SIRET...)"|x_translate}</label>
                                    <input id="input_siret" class="input-factura" type="text"  value="{$empresa.siret}" placeholder="{$empresa.siret}" />
                                </div>

                            </div>
                            <div class="okm-row  ">
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Direccion"|x_translate}</label>
                                    <input id="input_direccion" class="input-factura" type="text"  value="{$empresa.direccion}" placeholder="{$empresa.direccion}" />
                                </div>
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Codigo postal"|x_translate}</label>
                                    <input id="input_codigopostal" class="input-factura" type="text"  value="{$empresa.codigo_postal}" placeholder="{$empresa.codigo_postal}" />
                                </div>

                            </div>
                            <div class="okm-row  ">
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Ciudad"|x_translate}</label>
                                    <input id="input_ciudad" class="input-factura" type="text"  value="{$empresa.ciudad}" placeholder="{$empresa.ciudad}" />
                                </div>
                                <div class="mapc-input-line col-xs-6">
                                    <label for="titular_cuenta_sepa" class="mapc-label"> {"Pais"|x_translate}</label>

                                    <select name="input_pais" id="input_pais" class="form-control select select-primary select-block">
                                        <option value="">{"Pais"|x_translate}</option>
                                        {html_options options=$combo_pais selected=$empresa.pais}
                                    </select>
                                </div>

                            </div>

                        </div>

                        <div class="mapc-registro-form-row center">
                            <button class="btn-default btn-process-checkout " id="btn-registrar-factura" type="submit" data-secret="{$usuario_empresa.stripe_client_secret}">
                                {"Registrar"|x_translate}</button>
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

            var displayError = document.getElementById('card-element-errors');


            if (event.error) {
                displayError.textContent = event.error.message;
            } else {
                displayError.textContent = '';
            }
        }


        /*
         * Listener de evento para crear metodo de pago con los datos de la tarjeta llamado a la API de Stripe
         */
        $("#btn-process-checkout").click(function () {

            if ($("#cantCuestionariosListos").val() < 1) {
                if ($(this).hasClass("disabled")) {
                    return false;
                }
                let clientSecret = $("#clientSecret").val();
                let customerId = $("#customerId").val();

                //cargar nueva tarjeta
                if ($("#titular_tarjeta").val() === "") {
                    x_alert(x_translate("Complete los datos obligatorios"));
                    return false;
                }
                //creamos el setup intent en Stripe necesario para asociar la tarjeta
                if (customerId !== "") {
                    //creamos la intencion de pago al clinete (Setup Intent) en Stripe
                    crear_setup_intent();
                } else {
                    x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                }


            } else {
                x_alert(x_translate("No esta permitido tener mas de un cuestionario listo para enviar"));
            }
        });



        /**
         * Metodo que registra en la base de datos la creacion del PaymentIntent,(intencion de pago) para asociar la tarjeta luego
         * @param {type} payment_method
         * @returns {undefined}
         */
        var crear_setup_intent = function () {
            let customerId = $("#customerId").val();
            let idPagoRecomensa = $("#idPagoRecomensa").val();
            $("body").spin();
            return x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'empresa.php?action=1&modulo=gestion&submodulo=crear_setup_intent',
                    "customerId=" + customerId + "&idPagoRecomensa=" + idPagoRecomensa,
                    function (data) {

                        $("body").spin(false);
                        if (data.result && data.client_secret && data.client_secret !== "") {
                            confirm_card_setup(data.client_secret, data.setupIntentId);
                        } else {
                            x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                        }
                    }
            );
            return promise;

        };


        /**
         * Metodo que registra  en Stripe la tarjeta asigandola al SetupIntent del cliente creada anteriormente
         */
        function confirm_card_setup(clientSecret, setupIntentId) {
            $("body").spin();
            stripe.confirmCardSetup(
                    clientSecret,
                    {
                        payment_method: {
                            card: cardElement,
                            billing_details: {
                                name: $("#titular_tarjeta").val()
                            }
                        }
                    }
            ).then(function (result) {
                $("body").spin(false);
                console.log("result:", result);


                if (result.error) {
                    //verificamos si el error es porque ya se logró crear el intento de pago - 
                    //En este caso No se puede actualizar el setup_itent, ya fue creado con exito entonces continuamos igual
                    if (result.error.code === "setup_intent_unexpected_state" && result.error.setup_intent) {
                        let  setupIntent = result.error.setup_intent;
                        if (setupIntent.payment_method && setupIntent.payment_method !== "" && setupIntent.status && setupIntent.status === "succeeded") {
                            confirmar_pago(setupIntent.payment_method, setupIntentId);
                        } else {
                            x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                        }
                    } else {
                        //otro error - lo mostramos
                        displayError(result);
                    }

                } else {
                    let  setupIntent = result.setupIntent;
                    if (setupIntent.payment_method && setupIntent.payment_method !== "" && setupIntent.status && setupIntent.status === "succeeded") {
                        confirmar_pago(setupIntent.payment_method, setupIntentId);
                    } else {
                        x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                    }

                }
            });

        }

        /**
         * Metodo que registra en la base de datos la condirmacion de la consulta luego de que se registró el metodo de pago en stripe
         * @param {type} payment_method
         * @returns {undefined}
         */
        function confirmar_pago(payment_method, setupIntentId) {
            console.log(payment_method);
            let idPagoRecomensa = $("#idPagoRecomensa").val();
            $("body").spin("large");

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=activar_pago_cuestionario_tarjeta",
                    "idpago_recompensa_encuesta=" + idPagoRecomensa + "&pago_pendiente=1"
                    + "&stripe_payment_method=" + payment_method,
                    function (data) {

                        if (data.result) {
                            $("body").spin(false);
                            x_alert(x_translate('Pago realizado'), function () {

                                window.location.href = BASE_PATH + "entreprises/questionnairesready/" + data.hash + ".html";

                            });

                        } else {
                            $("body").spin(false);
                            x_alert(x_translate("Ha ocurrido un error al procesar su pago"));

                        }
                    }
            );
        }



        /**
         *  0 pendiente
         *  1 pagado
         *  2 factura enviada
         *  3 cancelado
         *  4 pago con tarjeta concretado
         */

        $("#btn-registrar-factura").click(function () {
            if ($("#cantCuestionariosListos").val() < 1) {
                $("body").spin("large");
                let idPagoRecomensa = $("#idPagoRecomensa").val();
                idempresa = $("#idempresa").val();
                codigo_postal = $("#input_codigopostal").val();
                nombreempresa = $("#input_empresa").val();
                siret = $("#input_siret").val();
                ciudad = $("#input_ciudad").val();
                pais = $("#input_pais").val();
                direccion = $("#input_direccion").val();
                if (codigo_postal == '' || nombreempresa == '' || siret == '' || direccion == '' || pais == '' || ciudad == '') {
                    x_alert(x_translate('Debe completar todos los campos'));
                } else {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=activar_pago_cuestionario_factura",
                            "idpago_recompensa_encuesta=" + idPagoRecomensa + "&pago_pendiente=2" + "&idempresa=" + idempresa
                            + "&codigo_postal=" + codigo_postal + "&nombreempresa=" + nombreempresa + "&siret=" + siret
                            + "&ciudad=" + ciudad + "&pais=" + pais + "&direccion=" + direccion,
                            function (data) {
                                console.log("data result", data);
                                $("body").spin(false);
                                if (data.result) {
                                    $("body").spin(false);
                                    x_alert(x_translate('Solicitud relizada'), function () {

                                        window.location.href = BASE_PATH + "entreprises/questionnairesready/" + data.hash + ".html";

                                    });
                                } else {

                                    x_alert(x_translate("Ha ocurrido un error al procesar su solicitud"));

                                }
                            });
                }

            } else {
                x_alert(x_translate("No esta permitido tener mas de un cuestionario listo para enviar"));

            }

        });

    });
    </script>
{/literal}