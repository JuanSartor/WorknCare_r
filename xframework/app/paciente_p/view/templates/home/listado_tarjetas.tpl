<div >
    <section class="okm-container ce-nc-consulta-precios ce-nc-p3">
        <div class="row">
            <h2>{"Tarjetas de crédito cargadas"|x_translate}</h2>
        </div>
        <div class="okm-row">
            <div class="col-xs-12">
                <div class="payment-wrapper">
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
                        {foreachelse}
                            <p class="text-center">{"Aun posee tarjetas registradas en el pago de sus consultas particulares"|x_translate}</p>
                        {/foreach}

                    </div>

                </div>
            </div>
        </div>
        <div class="row" {if $iban_beneficiario.iban==''} hidden{/if}>
            <h2>{"Cuentas bancarias cargadas"|x_translate}</h2>
        </div>
        <div class="okm-row" {if $iban_beneficiario.iban==''} hidden{/if}>
            <div class="col-xs-12">
                <div class="payment-wrapper">
                    {*Tarjetas cargadas*}
                    <div class="tarjetas-container">
                        {if $iban_beneficiario.iban!=''}
                            <div class="card tarjeta-item tarjeta-cargada">
                                <div class="card-header">
                                    <div class="iconos">  
                                        <figure class="card-logo"><i class="fas fa-university"></i></figure> 
                                    </div>
                                    <span class="card-data" style="margin:auto;">

                                        <small class="small-mobile" ><em id="textIban" name="textIban">{if $iban_beneficiario.iban!=''}{$iban_beneficiario.iban}{else}FR14 0000 0000 0000 0000 0X00 000{/if}</em></small>
                                    </span>
                                    <span class="btnEditarCtaReembolso span-editar-mobile" data-id="{$iban_beneficiario.idIbanBeneficiario}" data-iban="{$iban_beneficiario.iban}"><i class="fa fa-pen btn-eliminar-tarjeta-credito"></i></span>       
                                    <span class="btnEliminarIbanReembolso" data-id="{$iban_beneficiario.idIbanBeneficiario}" data-iban="{$iban_beneficiario.iban}"><i class="fa fa-trash btn-eliminar-tarjeta-credito btn-trash-iban"></i></span>  
                                </div>
                            </div>
                        {/if}
                    </div>

                </div>
            </div>
        </div>
    </section>
</div>

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
                            //cargamos el modulo de tarjetas
                            x_loadModule('home', 'listado_tarjetas', 'mod={$smarty.request.mod}', 'div_tarjetas', BASE_PATH + "paciente_p").then(
                                    function () {
                                        $("body").spin(false);
                                    });
                        }
                );
            },
            cancel: function () {
            },
            confirmButton: x_translate("Si"),
            cancelButton: x_translate("No")
        });
    });


    //boton para eliminar iban beneficiario
    $(".btnEliminarIbanReembolso").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        var idIbanBeneficiario = $(this).data("id");
        jConfirm({
            title: x_translate("Eliminar Iban"),
            text: x_translate("Desea eliminar este Iban?"),
            confirm: function () {
                $("body").spin();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "eliminar_iban.do",
                        "idIbanBeneficiario=" + idIbanBeneficiario,
                        function (data) {
                            x_loadModule('home', 'listado_tarjetas', 'mod={$smarty.request.mod}', 'div_tarjetas', BASE_PATH + "paciente_p").then(
                                    function () {
                                        $("body").spin(false);
                                    });
                        }
                );
            },
            cancel: function () {
            },
            confirmButton: x_translate("Si"),
            cancelButton: x_translate("No")
        });
    });

    // boton para editar cta de reembolso
    $(".btnEditarCtaReembolso").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        var iban = $(this).data("iban");
        var idIbanBeneficiario = $(this).data("id");

        $.confirm({
            title: x_translate("Editar IBAN"),
            content: '' +
                    '<form action="" class="formName">' +
                    '<div class="form-group">' +
                    '<input    type="text"  class="name form-control" required />' +
                    '</div>' +
                    '</form>',
            buttons: {
                formSubmit: {
                    text: x_translate("Editar"),
                    btnClass: 'btn-blue',
                    action: function () {

                        //console.log(this.$content.find('.name').val());
                        var nuevoIban = this.$content.find('.name').val();
                        if (nuevoIban == "" || nuevoIban.length <= 27) {
                            x_alert(x_translate("Ingrese un código IBAN válido"));
                            return false;
                        }

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "get_banco_xp_iban.do",
                                'iban=' + nuevoIban,
                                function (data) {
                                    //  console.log(data);

                                    if (data != '') {
                                        //console.log(data);

                                        x_doAjaxCall(
                                                'POST',
                                                BASE_PATH + "actualizar_iban_reembolso.do",
                                                'iban=' + nuevoIban + "&idIbanBeneficiario=" + idIbanBeneficiario,
                                                function (data) {
                                                    //  console.log(data);

                                                    if (data != '') {
                                                        // console.log(data);
                                                        x_alert(x_translate("Se ha actualizado correctamente"));
                                                        $("#textIban").text(nuevoIban);

                                                    } else {
                                                        x_alert(x_translate("No se ha podido actualizar correctamente"));
                                                    }
                                                }
                                        );

                                    } else {
                                        x_alert(x_translate("Ingrese un código IBAN válido"));
                                    }
                                }
                        );

                    }
                },
                cancel: function () {
                    //close
                },
            },
            onContentReady: function () {
                // bind to events
                var jc = this;
                this.$content.find('form').on('submit', function (e) {
                    // if the user submits the form by pressing enter in the field.
                    e.preventDefault();
                    jc.$$formSubmit.trigger('click'); // reference the button and click it
                });
            }
        });
    }
    );
</script> 