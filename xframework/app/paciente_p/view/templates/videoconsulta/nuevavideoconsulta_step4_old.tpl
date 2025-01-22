{*paciente con saldo o sin cargo*}
{if ($paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0) || ($VideoConsulta.tipo_consulta=="1" && $cuenta_paciente.saldo>=$VideoConsulta.precio_tarifa) ||($VideoConsulta.tipo_consulta=="0" && $cuenta_paciente.saldo>=$filtro.rango_maximo)}
    <section class="container ce-nc-p3">
        <div class="ce-nc-p3-header">
            <figure>
                <i class="icon-doctorplus-dollar"></i>
            </figure>
            <h2 class="ce-nc-p3-title">{"Confirmación de consulta"|x_translate}</h2>
        </div>

        {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0}
            {*paciente empresa*}
            <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta"|x_translate} </h3>
            <div class="ce-nc-p3-monto-holder">
                <div class="ce-nc-p3-monto" style="padding: 10px 0;">
                    <span style="line-height: 1;">1 {"consulta por video"|x_translate}</span>
                    <br>
                    <small class="red">({$paciente.vc_disponibles}&nbsp;{"consultas por video disponibles en su plan"|x_translate})</small>
                </div>
            </div>

        {else}
            {*paciente comun*}
            {if $VideoConsulta.tipo_consulta=="0" }

                <div class="ce-nc-p3-rango-tarifa">
                    <p>
                        {if $cant_profesionales_bolsa ==1}
                            {"El profesional por ud. seleccionado tiene una tarifa de"|x_translate}  <br>
                        {/if}
                        {if $cant_profesionales_bolsa >1}
                            {"Los [[{$cant_profesionales_bolsa}]] profesionales por ud. seleccionados se encuentran en un rango tarifario entre"|x_translate} <br>
                        {/if}
                        {if $filtro.rango_minimo!=$filtro.rango_maximo}
                            <strong>&euro;{$filtro.rango_minimo}</strong> y <strong>&euro;{$filtro.rango_maximo}</strong>
                        {else}
                            <strong>&euro;{$filtro.rango_maximo}</strong>
                        {/if}
                    </p>
                </div>
                <div class="clearfix">
                    <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta el importe del profesional que responda su consulta"|x_translate} </h3>
                </div>

            {/if}
            {if $VideoConsulta.tipo_consulta=="1"}
                <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta el importe de"|x_translate} </h3>
                <div class="ce-nc-p3-monto-holder">

                    {*Si podee reitegro mostramos las 2 opciones*}
                    {if $tarifa_videconsulta.grilla}
                        <div class="ce-nc-p3-monto" id="div_tarifa_reintegro"  {if $turno.beneficia_reintegro==1}style="display:block;"{else}style="display:none;"{/if}>
                            <span>&euro; {$tarifa_videconsulta.monto}</span>
                        </div>
                        <div class="ce-nc-p3-monto" id="div_tarifa_original" {if $turno.beneficia_reintegro==1}style="display:none;"{else}style="display:block;"{/if}>
                            <span>&euro; {$VideoConsulta.precio_tarifa}</span>
                        </div>
                    {else}
                        <div class="ce-nc-p3-monto" id="div_tarifa_reintegro">
                            <span>&euro; {$VideoConsulta.precio_tarifa}</span>
                        </div>
                    {/if}
                </div>
            {/if}
        {/if}

        <div class="ce-nc-p3-monto-btns-holder">
            <button class="btn btn-secondary" id="btnCancelarPago">
                {"volver"|x_translate}
            </button>
            <button class="btn btn-primary btn-default" id="btnConfirmarPago">
                {"confirmar"|x_translate}
            </button>
        </div>
        {if $paciente.is_paciente_empresa!="1" || $paciente.vc_disponibles==0}
            {if $VideoConsulta.tipo_consulta=="0" }
                <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                    <figure>
                        <i class="icon-doctorplus-alert"></i>
                    </figure>
                    <p>{"En caso de que su Video Consulta sea respondida por un profesional con tarifa de MENOR VALOR la diferencia le será REEMBOLSADA al concluir la consulta"|x_translate}</p>
                </div>
            {/if}
            {if  $paciente.animal!=1}
                <!-- Banner alerta reintegro-->
                {if $medico.pais_idpais==1 && $medico.mis_especialidades.0.tipo==1 && (($paciente.titular==1 && $paciente.pais_idpais==1 && ($medico.medico_cabecera==1 || ($medico.medico_cabecera==0 &&$medico.mis_especialidades.0.acceso_directo==1 ))) || ($paciente.titular==0 && $account.paciente.pais_idpais==1)) }
                    <div class="okm-row text-center" id="div_reintegro_checked" {if $turno.beneficia_reintegro==1}style="display:block;"{else}style="display:none;"{/if}>
                        <h7>{"Esta consulta es elegible al reintegro por la caja y su cubertura privada."|x_translate}</h7>  
                        <h7>{"Le pedimos que adelante el precio de la consulta para permitir a su médico verificar sus derechos. Cuando ese mismo los valide y envie el reporte de consulta a la caja, recibira una notificacion y se acreditara el importe adelantado en su cuenta."|x_translate}</h7>  
                    </div>

                    <div class="okm-row text-center" id="div_reintegro_unchecked" {if $turno.beneficia_reintegro==1}style="display:none;"{else}style="display:block;"{/if}>
                        <h7>{"Esta consulta NO es elegible al reintegro por la caja y su cubertura privada. Necesita confirmar el criterio siguiente para eso"|x_translate}</h7>  
                    </div>

                    <div id="div_confirmacion_pago" class="okm-row  text-center">
                        <label class="checkbox beneficia_reintegro">
                            <input type="checkbox" id="beneficia_reintegro" {if $turno.beneficia_reintegro==1}checked{/if}  data-toggle="radio" class="custom-radio">
                            {if $paciente.beneficia_ald==1}
                                {"Confirmo que he tenido una consulta presencial en los últimos 12 meses y que el especialista está incluido en mi protocolo de tratamiento"|x_translate}
                            {else}
                                {"Confirmo que he tenido una consulta presencial en los últimos 12 meses"|x_translate}
                            {/if}
                        </label>
                    </div>

                {else}
                    {*check para aceptar reintegro*}
                    <div class="row" >
                        <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                            <h7>{"Esta consulta NO es elegible al reintegro por la caja y su cubertura privada."|x_translate}</h7>  
                        </div>
                    </div>
                {/if}

            {else}
                <!-- banner mascota-->
                <div class="row" >
                    <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                        <p class="text-center" style="color: #283e73;">{"La videoconsulta de su mascota es por cuenta particular y no se beneficia de reintegro"|x_translate}</p>
                    </div>
                </div>
            {/if}
        {/if}
        <!-- Fin banner alerta reintegro-->
        <div class="row">
            <div class="okm-center-col">
                <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>
    </section>
{else}
    {*paciente sin saldo*}
    {if $VideoConsulta.tipo_consulta=="0" }
        {math equation='precio - saldo' saldo=$cuenta_paciente.saldo precio={$filtro.rango_maximo} assign='dinero_faltante'}
    {else}
        {math equation='precio - saldo' saldo=$cuenta_paciente.saldo precio=$VideoConsulta.precio_tarifa assign='dinero_faltante'}
    {/if}
    <script>
        var DINERO_FALTANTE ={$dinero_faltante};
    </script>
    <section class="container ce-nc-p3">
        <div class="ce-nc-p3-header">
            <figure>
                <i class="icon-doctorplus-dollar"></i>
            </figure>
            <h2 class="ce-nc-p3-title">{"Confirmación de pago"|x_translate}</h2>
        </div>
        {if $VideoConsulta.tipo_consulta=="0"}

            <div class="ce-nc-p3-rango-tarifa">
                <p>
                    {if $cant_profesionales_bolsa ==1}
                        {"El profesional por ud. seleccionado tiene una tarifa de"|x_translate}  <br>
                    {/if}
                    {if $cant_profesionales_bolsa >1}
                        {"Los [[{$cant_profesionales_bolsa}]] profesionales por ud. seleccionados se encuentran en un rango tarifario entre"|x_translate} <br>
                    {/if}
                    {if $filtro.rango_minimo!=$filtro.rango_maximo}
                        <strong>&euro;{$filtro.rango_minimo}</strong> y <strong>&euro;{$filtro.rango_maximo}</strong>
                    {else}
                        <strong>&euro;{$filtro.rango_maximo}</strong>
                    {/if}
                </p>
            </div>

        {/if}
        <div class="clearfix"></div>
        <div class="ce-nc-p3-monto-holder saldo-insuficiente">
            <div class="ce-nc-p3-monto">
                <p class="saldo-insuficiente-lbl">{"Su saldo es insuficiente para realizar la consulta a los profesionales seleccionados"|x_translate}</p>
                <p class="saldo-insuficiente-qty">{"Dinero faltante:"|x_translate} &euro;{$dinero_faltante}</p>
            </div>
        </div>

        <div class="col-xs-12 text-center">
            <button class="btn btn-primary btn-default modificar-tarifa" id="btnModificarRango">
                {if $VideoConsulta.tipo_consulta=="0"} 
                    <i class="icon-doctorplus-back"></i> {"modificar rango de tarifa"|x_translate}
                {else}
                    <i class="icon-doctorplus-back"></i> {"seleccionar otro profesional"|x_translate}
                {/if}
            </button>
            <button class="btn btn-primary btn-default" id="btnCargarCredito">
                {"cargar crédito"|x_translate}
            </button>
        </div>
        {if  $paciente.animal!=1}
            <!-- banner alerta reintegro-->
            {if  ($paciente.pais_idpais==1 && $VideoConsulta.tipo_consulta=="0" && $especialidad.tipo==1 &&  $filtro.pais_idpais==1) ||($paciente.pais_idpais==1 && $VideoConsulta.tipo_consulta=="1" && $especialidades_medico.0.tipo==1 && $medico.pais_idpais==1)}
                <div class="row" >
                    <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                        <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</p>
                        <p class="text-center" style="color: #283e73;">{"Si quiere beneficiar de un reintegro de la Video Consulta, tiene que consultar con sus médicos frecuentes."|x_translate}</p>
                    </div>
                </div>

            {else}
                <div class="row" >
                    <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                        <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</p>
                    </div>
                </div>
            {/if}
        {else}
            <!-- banner mascota-->
            <div class="row" >
                <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                    <p class="text-center" style="color: #283e73;">{"La videoconsulta de su mascota es por cuenta particular y no se beneficia de reintegro"|x_translate}</p>
                </div>
            </div>
        {/if}
        <!-- Fin banner alerta reintegro-->
        <div class="row">
            <div class="okm-center-col">
                <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>
    </section>
{/if}

<script>
    $(function () {
        $(".covid_alert").removeClass("hidden");
    });
</script>

{literal}
    <script>
        $(function () {
            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#videoconsulta-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }

            // Inicialización de los checks
            $(':checkbox').radiocheck();

            $("#beneficia_reintegro").on('change.radiocheck', function () {
                if ($("#beneficia_reintegro").is(":checked")) {
                    $("#div_reintegro_checked").show();
                    $("#div_reintegro_unchecked").hide();

                    //si hay 2 tarifas la intercambiamos
                    if ($("#div_tarifa_original").length > 0) {
                        $("#div_tarifa_reintegro").show();
                        $("#div_tarifa_original").hide();
                    }
                } else {
                    $("#div_reintegro_checked").hide();
                    $("#div_reintegro_unchecked").show();
                    //si hay 2 tarifas la intercambiamos
                    if ($("#div_tarifa_original").length > 0) {
                        $("#div_tarifa_reintegro").hide();
                        $("#div_tarifa_original").show();
                    }
                }
            });

            //boton para cancelar pago y volver al paso anterior
            $("#btnCancelarPago, #btnModificarRango").click(function () {


                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'cancelar_pago_videoconsulta.do',
                        "idvideoconsulta=" + $("#idvideoconsulta").val(),
                        function (data) {

                            if (data.result) {

                                window.location.href = "" + "?continue=true";

                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });

            //boton siguiente paso- se crea confirmar el choricito
            $("#btnConfirmarPago").click(function () {


                $("#videoconsulta-step-container").spin("large");
                if ($("#beneficia_reintegro").is(":checked")) {
                    var reintegro = 1;
                } else {
                    var reintegro = 0;
                }
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'confirmar_pago_videoconsulta.do',
                        "idvideoconsulta=" + $("#idvideoconsulta").val() + "&beneficia_reintegro=" + reintegro,
                        function (data) {

                            $("#videoconsulta-step-container").spin(false);
                            if (data.result) {

                                x_loadModule('videoconsulta', 'nuevavideoconsulta_step5', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });

            ///cargar credito
            $("#btnCargarCredito").click(function () {
                localStorage.setItem('payment_redirect', 'vc');
                window.location.href = BASE_PATH + "panel-paciente/credito-proceso-compra/?compra=" + DINERO_FALTANTE;
            });


        });

    </script>
{/literal}