
<div class="checkout-form" id="checkout-form" style="display:none">
    <h3>{"Agrega tu tarjeta"|x_translate}</h3>
    <div class="plan-contratado">
        <h4 class="nombre-plan">{"Su plan contratado:"|x_translate} {$plan_contratado.nombre} </h4>
        <p>
            <i class="fa fa-check"></i> {"Fecha de inicio"|x_translate}: {$plan_contratado.fecha_adhesion_format}
        </p>


        <p>
            {*calculamos el precio final del paquete*}
            {if $cupon.codigo_cupon!=""}
                {math equation="(precio)" precio=$plan_contratado.precio  assign=precio_original}
                {math equation="(precio)*((100-cupon)/100)" precio=$plan_contratado.precio  cupon=$cupon.porcentaje_descuento assign=precio_total}
                <i class="fa fa-check"></i> <span style="text-decoration: line-through;">&euro;{$precio_original}</span>&nbsp;&euro;{$precio_total} {"paquete válido por 1 año"|x_translate} 
            {else}
                {math equation="precio" precio=$plan_contratado.precio assign=precio_total}
                <i class="fa fa-check"></i> &euro; {$precio_total} {"paquete válido por 1 año"|x_translate} 
            {/if}
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

        </ul>
        <div class="tab-content ">
            <div class="tab-pane active" id="tarjeta-credito-panel">
                {*PAGO TARJETA*}
                <div class="okm-row">
                    <div id="payment-form" class="payment-form">
                        <input type="hidden" id="clientSecret" value="{$clientSecret}">
                        <input type="hidden" id="customerId" value="{$usuario_empresa.stripe_customerid}">
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
                        <button class="btn-default btn-process-checkout disabled" id="btn-process-checkout" type="submit">{"Pagar"|x_translate}&nbsp;&euro;{$precio_total}</button>
                    </div>
                </div> 
            </div>

        </div>
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

    <h3>{"¡Se ha registrado su pago de forma exitosa!"|x_translate}</h3>

    <p class="plogin-envio-correo">
        {"Conectese a su cuenta para comenzar a disfrutas de los beneficios"|x_translate}
    </p>
    <div class="plogin-mensaje-registro-actions">
        <a href="javascript:;" class="btn-default btn-conectarme" title='{"Conectarme a mi cuenta"|x_translate}'>{"Conectarme a mi cuenta"|x_translate}</a>
    </div>

</div>


{literal}
    <script>
        $(function () {
            //desplegar modal login
            $(".btn-conectarme").click(function () {
                $("#loginbtn").trigger("click");
            });
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
                if ($(this).hasClass("disabled")) {
                    return false;
                }
                let clientSecret = $("#clientSecret").val();
                let customerId = $("#customerId").val();

                if (stripe && clientSecret && cardElement && customerId) {
                    process_pago_tarjeta(stripe, cardElement, clientSecret);
                } else {
                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                }
            });

            /*
             * Funcion encargada de activar la suscripcion al Pass bien-être cuando se procesó el pago en Stripe
             */
            function activar_suscripcion(customerId, paymentMethodId) {

                if (!customerId && !paymentMethodId) {
                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                    return false;
                }
                $("body").spin();
                return x_doAjaxCall(
                        'POST',
                        BASE_PATH + "frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=activar_suscripcion_pack",
                        "customerId=" + customerId + "&paymentMethodId=" + paymentMethodId,
                        function (data) {
                            console.log("data result", data);
                            $("body").spin(false);
                            if (data.result) {
                                $("#checkout-form").hide();
                                $("#subscription_ok_message").fadeIn();
                            } else {


                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));

                            }
                        });
            }


            /**
             * Llamamos a la api de stripe para procesar el pago con tarjeta
             * Si se requiere autorizacion de la tarjeta se muestra un popup al usuario
             * @param {type} stripe
             * @param {type} card
             * @param {type} clientSecret
             * @returns {undefined}
             */
            var process_pago_tarjeta = function (stripe, card, clientSecret) {
                console.log("procesar pago tarjeta");
                $("body").spin();
                stripe
                        .confirmCardPayment(clientSecret, {
                            payment_method: {
                                card: card
                            }
                        })
                        .then(function (result) {
                            console.log("result", result);
                            $("body").spin(false);
                            if (result.error) {

                                displayError(result);
                                x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                            } else {
                                //marcamos la compra del pack como activo
                                let customerId = $("#customerId").val();
                                if (!result.paymentIntent.payment_method) {
                                    x_alert(x_translate("Ha ocurrido un error al procesar su suscripción"));
                                } else {
                                    //marcamos la suscrpcion como pagada en la BD
                                    activar_suscripcion(customerId, result.paymentIntent.payment_method);
                                }


                            }
                        });
            };


        }
        );
    </script>
{/literal}