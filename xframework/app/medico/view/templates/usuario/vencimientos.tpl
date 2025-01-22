
<div class="mul-vencimientos-box">
    
    {if $medico.fundador=="1"}
    <section class="okm-container mul-vencimientos">
        <div class="okm-row">
            <h2 class="text-center">{"Estado de cuenta"|x_translate}</h2>
        </div>
        <div class="okm-row">
            <div class="mul-precio-box">
                <div class="mul-precio-top-box">
                        {"Usted tiene una cuenta de médico socio"|x_translate}
                </div>
            </div>
        </div>
    </section>
    {else}
    {if $medico.planProfesional == 0}
    <section class="okm-container mul-vencimientos">
        <div class="okm-row">
            <h2 class="text-center">{"Estado de cuenta"|x_translate}</h2>
        </div>
        <div class="okm-row">
            <div class="mul-precio-box">
                <div class="mul-precio-top-box">
                    {"Ud. posee una Cuenta Gratuita"|x_translate}
                </div>
                <div class="mul-account-type-disclaimer">
                    <p>{"Disfrute de los beneficios de una Cuenta Profesional"|x_translate}<br>
                        {"¡Todas las funcionalidades sin descuentos por comisión!"|x_translate}</p>
                    <p class="mul-higlight">{"a un PRECIO inmejorable"|x_translate}</p>
                </div>
                <div class="account-type pro">
                    <div>
                        <span>{"Cuenta Profesional"|x_translate}</span>
                        <span class="price">&euro;{$MONTO_CUOTA}<span> {"finales / MES"|x_translate}</span></span>
                    </div>
                </div>
            </div>
            <p class="mul-cuenta-precio-disclaimer">{"Inicialmente la contratación mínima es de 6 (seis) meses. PRECIOS EXPRESADOS EN PESOS ARGENTINOS IVA INCLUÍDO"|x_translate}</p>

        </div>

        <div class="okm-row">
            <div class="mul-precio-action-box">
                <a href="{$url}panel-medico/abono-proceso-compra/" class="btn-default">{"Cambiar de plan"|x_translate} <span class="bst-arrow-right"></span></a>
            </div>
        </div>

    </section>
    {else}

    <section class="okm-container mul-vencimientos">
        <div class="okm-row">
            <h2 class="text-center">{"Estado de cuenta"|x_translate}</h2>
        </div>
        <div class="okm-row">
            <div class="mul-precio-box">
                <div class="mul-precio-top-box">
                    {if $suscripcion.vencida==0}
                    {"Ud. posee una Cuenta Profesional"|x_translate}
                    {else}
                    {"Ud. posee una Cuenta Gratuita"|x_translate}
                    {/if}
                </div>
                <div class="mul-account-type-disclaimer">
                    {if $medico.fundador==1}
                    <p class="mul-higlight">{"Su suscripción no posee vencimiento"|x_translate}</p>
                    {else}
                    {if $suscripcion.vencida==0}
                    <p class="mul-higlight">{"Su suscripción vence el"|x_translate} <strong>{$suscripcion.fecha_inicio|date_format:'%d/%m/%Y'}</strong></p>
                    {else}
                    <p class="mul-higlight">{"Su suscripción venció el"|x_translate} <strong>{$suscripcion.fecha_inicio|date_format:'%d/%m/%Y'}</strong></p>
                    {/if}
                    {/if}

                </div>
                <div class="account-type pro">
                    <div>
                        <span>{"Cuenta Profesional"|x_translate}</span>
                        <span class="price">&euro;{$MONTO_CUOTA}<span> {"finales / MES"|x_translate}</span></span>
                    </div>
                </div>
            </div>
            <p class="mul-cuenta-precio-disclaimer">{"PRECIOS EXPRESADOS EN PESOS ARGENTINOS IVA INCLUÍDO"|x_translate}</p>

        </div>

        
    </section>
    {/if}
 {/if}
    </div>	


    {literal}
    <script>
        $(document).ready(function () {
            $(':radio, :checkbox').radiocheck();

            //metodos al chequear las opciones de configuracion de de renovacion automatica de la cuenta profesional
            $("#renovacion-automatica").on('change.radiocheck', function () {


                if ($("#sms").is(':checked')) {
                    var val = 1;
                } else {
                    var val = 0;
                }
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'registrar_renovacion_automatica.do',
                        'renovar=' + val,
                        function (data) {

                            x_alert(data.msg);

                        });

            });



        });
    </script>
    {/literal}
