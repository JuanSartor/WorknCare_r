<section class="form edit info-profesional-form">
    <div class="container">
        <h2 class="text-center">{"Método de pago"|x_translate} </h2>

        <div class="col-xs-12">


            <div class="row" >

                <div class="col-md-4 col-md-offset-2">
                    <label>{"Tipo"|x_translate}</label>
                    <div class="field-edit dp-edit">
                        {if $metodo_pago.card}
                            <span>{"Tarjeta de crédito"|x_translate}: {$metodo_pago.card.brand|upper}</span>
                        {/if}
                        {if $metodo_pago.sepa_debit}
                            <span>{"Débito SEPA"|x_translate}</span>
                        {/if}
                    </div>
                </div>

                <div class="col-md-4">
                    {if $metodo_pago.card}
                        <label>{"Número de tarjeta"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <span>**** **** **** {$metodo_pago.card.last4}</span>
                        </div>
                    {/if}
                    {if $metodo_pago.sepa_debit}
                        <label>{"Número IBAN"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <span>{$metodo_pago.sepa_debit.country}*********************{$metodo_pago.sepa_debit.last4}</span>
                        </div>
                    {/if}
                </div>

            </div>
            <div class="row" >
                {if $metodo_pago.card}
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Fecha de expiración"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <span>{$metodo_pago.card.exp_month} / {$metodo_pago.card.exp_year}</span>
                        </div>
                    </div>
                {/if}
                {if $metodo_pago.sepa_debit}
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Titular de la cuenta"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <span>{$metodo_pago.billing_details.name}</span>
                        </div>
                    </div>
                {/if}

                <div class="col-md-4">
                    <label>{"Fecha de adhesion"|x_translate} *</label>
                    <div class="field-edit dp-edit">
                        <span>{$empresa.fecha_adhesion_format} - {$empresa.fecha_vencimiento_format}</span>
                    </div>
                </div>

            </div>
        </div>
        {*las empresas obras sociales pagan por unica vez no tienen suscripciones, no cambian los metodos de pago*}
        {if $empresa.obra_social!="1"}
            <div class="okm-row">
                {include  file="contable/tabs_metodo_pago.tpl"}
            </div>
            <div class="pass-sante-registro-planes">
                <div class="checkout-form" style="display: block;">
                    <div class="okm-row">
                        <div class="aclaracion-debito">
                            <p>* {"Compromiso de un año, tácitamente renovable"|x_translate}</p>
                            <p>{"Su cuenta se debitará cada mes durante un año a partir de la fecha de adhesión con la siguiente modalidad:"|x_translate}</p>
                                </div>
                    </div>

                    <div class="clearfix">&nbsp;</div>
                    <div class="okm-row text-center">
                        <button  class="btn btn-default" id="cambiar_metodo_pago" >{"cambiar metodo de pago"|x_translate}</button>
                        {if $empresa.cancelar_suscripcion=="0"}
                            <button  class="btn btn-white" id="cancelar_suscripcion" >{"cancelar la renovación"|x_translate}</button>
                        {/if}
                    </div>

                </div>
            </div>
        {/if}
    </div>
</section>
{if $empresa.obra_social!="1"}
    {literal}
        <script>
            $(function () {

                //listener cancelar la renovacion automatica de la suscripcion
                $("#cancelar_suscripcion").click(function (e) {
                    e.preventDefault();
                    jConfirm({
                        title: x_translate("Cancelar renovación"),
                        text: x_translate('Está por cancelar la renovación de su Plan de Salud luego del periodo de 12 meses de contratación. ¿Desea continuar?'),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'paciente_p.php?action=1&modulo=contable&submodulo=cancelar_suscripcion',
                                    '',
                                    function (data) {
                                        $("body").spin(false);
                                        if (data.result) {
                                            window.location.href = "";
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                });
                //Listener que despliega el form para cambiar el metodo de pago seleccionado de la suscripcions
                $("#cambiar_metodo_pago").click(function (e) {

                    $("#form_cambiar_metodo_pago").slideToggle();

                });

            });
        </script>
    {/literal}
{/if}