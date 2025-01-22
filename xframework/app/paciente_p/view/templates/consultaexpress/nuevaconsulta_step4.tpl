{*paciente con saldo o sin cargo o consultas disponibles plan empresa*}
<section class="container ce-nc-p3">
    <div class="ce-nc-p3-header">
        <figure>
            <i class="icon-doctorplus-dollar"></i>
        </figure>
        <h2 class="ce-nc-p3-title">{"Confirmación de consulta"|x_translate}</h2>
    </div>
    <div class="payment-wrapper">
        {if $paciente.is_paciente_empresa!="1" || $paciente.ce_disponibles==0 || ($medico_bonificado!=1  && $programa_bonificado!=1)}
            {if ($ConsultaExpress.tipo_consulta=="0" && $filtro.rango_maximo>0) || ($ConsultaExpress.tipo_consulta=="1" && $ConsultaExpress.precio_tarifa>0)}
                {*Tarjetas cargadas*}
                <div class="tarjetas-container">
                    {foreach from=$metodo_pago_list item=metodo_pago}
                        {if $metodo_pago.id!=""}
                            <div class="card tarjeta-item tarjeta-cargada" data-payment="{$metodo_pago.id}">
                                <div class="card-header">
                                    <div class="iconos">                             
                                        <figure class="card-logo">
                                            {if $metodo_pago.card.brand=="visa"}
                                                <i class="fa fa-cc-visa"></i>
                                            {else if $metodo_pago.card.brand=="mastercard"}
                                                <i class="fa fa-cc-mastercard"></i>                                 
                                            {else if $metodo_pago.card.brand=="amex"}
                                                <i class="fa fa-cc-amex"></i>
                                            {else}
                                                <i class=" fa fa-credit-card"></i>
                                            {/if}
                                        </figure> 
                                        <figure class="icon"><i class="fa fa-check-circle"></i></figure>
                                    </div>
                                    <span class="card-data">
                                        {"Tarjeta de crédito"|x_translate} &nbsp;****&nbsp;{$metodo_pago.card.last4} 
                                        <small><em>({"expiracion de la tarjeta"|x_translate} {if $metodo_pago.card.exp_month<10}0{/if}{$metodo_pago.card.exp_month}/{$metodo_pago.card.exp_year|substr:2:2})</em></small>
                                    </span>
                                    <span class="btnEliminarTarjetaCredito" data-payment="{$metodo_pago.id}"><i class="fa fa-trash btn-eliminar-tarjeta-credito"></i></span>        
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                    <div class="card tarjeta-item tarjeta-nueva">
                        <div class="card-header">
                            <figure class="card-logo"><i class="fa fa-credit-card"></i></figure>
                            <span class="card-data">{"Agregar nueva tarjeta"|x_translate}</span>
                            <figure class="icon"><i class="fa fa-caret-right"></i></figure>
                        </div>
                        <div class="card-body checkout-form">


                            <div class="okm-row">
                                <div id="payment-form" class="payment-form">
                                    <input type="hidden" id="customerId" value="{$cuenta_paciente.customerId}">
                                    <input id="email_tarjeta" type="hidden" value="{$cuenta_paciente.email}" />

                                    <div class="okm-row ">
                                        <label for="card-element" class="mapc-label">
                                            {"Número de tarjeta"|x_translate}
                                        </label>

                                        <div id="card-element" class="payment-element" ></div>
                                    </div>

                                    <!-- Errores ocurridos. -->
                                    <div id="card-element-errors" class="card-element-errors" role="alert"></div>
                                    <div class="okm-row ">
                                        <div class="mapc-input-line">
                                            <label for="titular_tarjeta" class="mapc-label"> {"Titular de la tarjeta"|x_translate}</label>
                                            <input id="titular_tarjeta" type="text"  value="{$cuenta_paciente.nombre} {$cuenta_paciente.apellido}" placeholder="{$cuenta_paciente.nombre} {$cuenta_paciente.apellido}"/>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}
        {/if}
        {*monto de la consulta*}
        <div class="pago-container {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0 && ($medico_bonificado==1 || $programa_bonificado==1)}beneficiario-empresa{/if}">
            <h3 class="pago-monto-title">
                {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0  && ($medico_bonificado==1 || $programa_bonificado==1)}
                    {"Se debitarán consultas de su plan"|x_translate}
                {else}
                    {"Se debitará de su cuenta"|x_translate} 
                {/if}
            </h3>
            {*beneficiario empresa*}
            {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0  && ($medico_bonificado==1 || $programa_bonificado==1)}
                <div class="pago-monto beneficiario-empresa">
                    1 {"consulta por chat"|x_translate}
                </div>
                <p>*&nbsp;<strong>{$paciente.ce_disponibles}</strong>&nbsp;{"consultas por chat disponibles en su plan"|x_translate}</p>
            {else}
                {*paciente comun*}
                <!-- Consulta a medicos en la red-->
                {if $ConsultaExpress.tipo_consulta=="0" }
                    <div class="pago-monto-holder">
                        <div class="pago-monto">
                            {if $filtro.rango_minimo!=$filtro.rango_maximo}
                                &euro;&nbsp;{$filtro.rango_minimo} à &euro;&nbsp;{$filtro.rango_maximo} *
                            {else}
                                &euro;&nbsp;{$filtro.rango_maximo}
                            {/if}
                        </div>
                    </div>
                    <span>*&nbsp;{"Se debitará de su cuenta el importe del profesional que responda su consulta"|x_translate} </span>
                {/if}
                <!-- Consulta a medicos particular-->
                {if $ConsultaExpress.tipo_consulta=="1"}
                    <div class="pago-monto-holder">
                        <div class="pago-monto" >
                            &euro;&nbsp;{$ConsultaExpress.precio_tarifa}
                        </div>
                    </div>
                {/if}
                <div class="okm-row aclaracion-debito">
                    <p>
                        <em>
                            {if ($ConsultaExpress.tipo_consulta=="0" && $filtro.rango_maximo>0) || ($ConsultaExpress.tipo_consulta=="1" && $ConsultaExpress.precio_tarifa>0)}
                                {"Autorizo a DoctorPlus a enviar instrucciones a la institución financiera que emitió mi tarjeta para recibir pagos de la cuenta de mi tarjeta de acuerdo con los términos de mi acuerdo con usted."|x_translate}
                            {else}
                                {"Su consulta se encuentra bonificada y no tiene costo"|x_translate}
                            {/if}
                        </em>
                    </p>
                </div>
            {/if}
        </div>
    </div>


    {*beneficiario empresa o consulta gratis*}
    {if ($paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0 && ($medico_bonificado==1 || $programa_bonificado==1)) || ($ConsultaExpress.tipo_consulta=="0" && $filtro.rango_maximo==0) || ($ConsultaExpress.tipo_consulta=="1" && $ConsultaExpress.precio_tarifa==0)}
        <div class="pago-monto-btns-holder text-center">
            <button class="btn btn-secondary" id="btnCancelarPago">
                {"volver"|x_translate}
            </button>
            <button class="btn btn-primary btn-default" id="btnConfirmarDebitoPlan">
                {"confirmar"|x_translate}
            </button>
        </div>
    {else}
        {*paciente comun*}

        {include file="consultaexpress/banner_reintegro.tpl"}

        {*botones*}
        {if $cuenta_paciente.customerId!="" }
            <div class="pago-monto-btns-holder text-center">
                <button class="btn btn-secondary" id="btnCancelarPago">
                    {"volver"|x_translate}
                </button>
                <button class="btn btn-primary btn-default" id="btnConfirmarPago">
                    {"confirmar"|x_translate}
                </button>
            </div>
        {else}
            <div class="pago-monto-btns-holder text-center">
                <a class="btn btn-secondary" href="{$url}panel-paciente/">
                    {"volver"|x_translate}
                </a>
            </div>
        {/if}
    {/if}
</section>

{literal}
    <script>
        $(function () {
            /*
             * Codigo JS compartido - empresa/particular
             */

            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#consulta-express-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }

            //boton para cancelar pago y volver al paso anterior
            $("#btnCancelarPago").click(function () {

                $("body").spin();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'cancelar_pago.do',
                        "idconsultaExpress=" + $("#idconsultaExpress").val(),
                        function (data) {
                            if (data.result) {
                                window.location.href = "" + "?continue=true";
                            } else {
                                $("body").spin(false);
                                x_alert(data.msg);
                            }
                        }
                );
            });

            //boton siguiente paso- se confirma la consulta
            $("#btnConfirmarDebitoPlan").click(function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'confirmar_pago.do',
                        "idconsultaExpress=" + $("#idconsultaExpress").val(),
                        function (data) {

                            if (data.result) {

                                x_loadModule('consultaexpress', 'nuevaconsulta_step5', 'idconsultaExpress=' + $("#idconsultaExpress").val(), 'consulta-express-step-container', BASE_PATH + "paciente_p").then(function () {
                                    $("body").spin(false);
                                });

                            } else {
                                $("body").spin(false);
                                x_alert(data.msg);
                            }
                        }
                );
            });

        });
    </script>
{/literal}

{*pago de consulta con cargo*}
{if $paciente.is_paciente_empresa!="1" || $paciente.ce_disponibles==0 || ($medico_bonificado!=1  && $programa_bonificado!=1)}
    {if ($ConsultaExpress.tipo_consulta=="0" && $filtro.rango_maximo>0) || ($ConsultaExpress.tipo_consulta=="1" && $ConsultaExpress.precio_tarifa>0)}
        {if $cuenta_paciente.customerId!=""}
            <script>
                var STRIPE_APIKEY_PUBLIC = "{$STRIPE_APIKEY_PUBLIC}";
                var customerId = "{$cuenta_paciente.customerId}";
            </script>

            {literal}
                <script>
                    $(function () {
                        //seleccionar tarjeta
                        $(".tarjeta-item").click(function () {
                            $(".tarjeta-item").removeClass("selected");
                            $(this).addClass("selected");
                        });
                        $(".tarjeta-item").first().addClass("selected");
                        $(".tarjeta-cargada").click(function () {
                            $(".checkout-form").slideUp();
                        });

                        // Inicialización de los checks
                        $(':checkbox').radiocheck();
                        $(".tarjeta-nueva").click(function () {
                            $(".checkout-form").slideDown();
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


                        /**
                         * Metodo que registra en la base de datos la creacion del PaymentIntent,(intencion de pago) para asociar la tarjeta luego
                         * @param {type} payment_method
                         * @returns {undefined}
                         */
                        var crear_setup_intent = function () {

                            $("body").spin();
                            return x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'paciente_p.php?action=1&modulo=credito&submodulo=crear_setup_intent',
                                    "customerId=" + customerId,
                                    function (data) {
                                        console.log(data);
                                        $("body").spin(false);
                                        if (data.result && data.client_secret && data.client_secret !== "") {
                                            confirm_card_setup(data.client_secret);
                                        } else {
                                            x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                                        }
                                    }
                            );
                            return promise;

                        };
                        /**
                         * Metodo que registra en la base de datos la condirmacion de la consulta luego de que se registró el metodo de pago en stripe
                         * @param {type} payment_method
                         * @returns {undefined}
                         */
                        function confirmar_pago(payment_method) {

                            $("body").spin("large");

                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'confirmar_pago.do',
                                    "idconsultaExpress=" + $("#idconsultaExpress").val() + "&payment_method=" + payment_method,
                                    function (data) {

                                        if (data.result) {
                                            x_loadModule('consultaexpress', 'nuevaconsulta_step5', 'idconsultaExpress=' + $("#idconsultaExpress").val(), 'consulta-express-step-container', BASE_PATH + "paciente_p").then(function () {
                                                $("body").spin(false);
                                            });
                                        } else {
                                            $("body").spin(false);
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                        /**
                         * Metodo que registra  en Stripe la tarjeta asigandola al SetupIntent del cliente creada anteriormente
                         */
                        function confirm_card_setup(clientSecret) {
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
                                            confirmar_pago(setupIntent.payment_method);
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
                                        confirmar_pago(setupIntent.payment_method);
                                    } else {
                                        x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                                    }

                                }
                            });

                        }
                        //boton confirgmar pago - añadir tarjeta
                        $("#btnConfirmarPago").click(function () {
                            //verififcamos si usa una tarjeta cargada anteriormente
                            if ($(".tarjeta-cargada").hasClass("selected")) {
                                let payment_method = $(".tarjeta-cargada.selected").data("payment");
                                if (payment_method !== "") {
                                    confirmar_pago(payment_method);
                                } else {
                                    x_alert(x_translate("Ha ocurrido un error al cargar su tarjeta"));
                                }

                            } else {
                                //cargar nueva tarjeta
                                if ($("#titular_tarjeta").val() === "" || $("#email_tarjeta").val() === "") {
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

                            }
                        });

                    });

                </script>
            {/literal}
        {else}
            {literal}
                <script>
                    $(function () {
                        x_alert("Ha ocurrido un error. Intente nuevamente");
                    });
                </script>
            {/literal}
        {/if}
    {/if}
{/if}
<script>
    //boton para eliminar tarjeta de credito
    $(".btnEliminarTarjetaCredito").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        var idmetodopago = $(this).data("payment");

        jConfirm({
            title: x_translate("Eliminar Tarjeta"),
            text: x_translate("Desea eliminar esta tarjeta?"),
            confirm: function () {
                $("body").spin();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "paciente_p.php?action=1&modulo=consultaexpress&submodulo=eliminar_tarjeta_credito",
                        "idmetodopago=" + idmetodopago,
                        function (data) {
                            if (data.result) {

                                $(".tarjeta-item.tarjeta-cargada[data-payment=" + idmetodopago + "]").remove();
                                if ($(".tarjeta-item.tarjeta-cargada").size() > '0') {
                                    $(".tarjeta-item").first().addClass("selected");
                                }
                            }
                            $("body").spin(false);
                            x_alert(data.msg);
                        }
                );
            },
            cancel: function () {
            },
            confirmButton: x_translate("Si"),
            cancelButton: x_translate("No")
        });
    });
</script>                                   