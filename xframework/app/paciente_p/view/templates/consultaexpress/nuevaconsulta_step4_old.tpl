{*paciente con saldo o sin cargo o consultas disponibles plan empresa*}
{if $paciente_sin_cargo || ($paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0) ||($ConsultaExpress.tipo_consulta=="1" && $cuenta_paciente.saldo>=$ConsultaExpress.precio_tarifa) ||($ConsultaExpress.tipo_consulta=="0" && $cuenta_paciente.saldo>=$filtro.rango_maximo)}
    <section class="container ce-nc-p3">
        <div class="ce-nc-p3-header">
            <figure>
                <i class="icon-doctorplus-dollar"></i>
            </figure>
            <h2 class="ce-nc-p3-title">{"Confirmación de consulta"|x_translate}</h2>
        </div>

        {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0}
            {*paciente empresa*}
            <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta"|x_translate} </h3>
            <div class="ce-nc-p3-monto-holder">
                <div class="ce-nc-p3-monto" style="padding: 10px 0;">
                    <span style="line-height: 1;">1 {"consulta por chat"|x_translate}</span>
                    <br>
                    <small class="red">({$paciente.ce_disponibles}&nbsp;{"consultas por chat disponibles en su plan"|x_translate})</small>
                </div>
            </div>

        {else}
            {*paciente comun*}
            {if $ConsultaExpress.tipo_consulta=="0" }
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

                    <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta el importe de"|x_translate} </h3>
                    <div class="ce-nc-p3-monto-holder">
                        <div class="ce-nc-p3-monto">
                            <span>&euro;{$filtro.rango_maximo}</span>
                        </div>
                    </div>
                </div>

            {/if}
            {if $ConsultaExpress.tipo_consulta=="1"}
                <h3 class="ce-nc-p3-title">{"Se debitará de su cuenta el importe de"|x_translate} </h3>
                <div class="ce-nc-p3-monto-holder">
                    <div class="ce-nc-p3-monto">
                        <span>&euro;{$ConsultaExpress.precio_tarifa}</span>
                    </div>
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
        {if $paciente.is_paciente_empresa!="1" || $paciente.ce_disponibles==0}
            {if $ConsultaExpress.tipo_consulta=="0" }
                <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                    <figure>
                        <i class="icon-doctorplus-alert"></i>
                    </figure>
                    <p>{"En caso de que su Consulta Express sea respondida por un profesional con tarifa de menor valor la diferencia será reembolsada al concluir la consulta"|x_translate}</p>
                </div>
            {/if}

            {if  $paciente.animal!=1}
                <!-- banner alerta reintegro-->
                {if  ($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="0" && $especialidad.tipo==1 &&  $filtro.pais_idpais==1) ||($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="1" && $especialidades_medico.0.tipo==1 && $medico.pais_idpais==1)}
                    <div class="row" >
                        <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                            <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</p>
                            <p class="text-center" style="color: #283e73;">{"Si quiere beneficiar de un reintegro de la Consulta Express, tiene que consultar con sus médicos frecuentes."|x_translate}</p>
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
                        <p class="text-center" style="color: #283e73;">{"La consulta de su mascota es por cuenta particular y no se beneficia de reintegro"|x_translate}</p>
                    </div>
                </div>
            {/if}
        {/if}
        <div class="row">
            <div class="okm-center-col">
                <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>
    </section>
{else}
    {*paciente sin saldo*}
    {if $ConsultaExpress.tipo_consulta=="0"}
        {math equation='precio - saldo' saldo=$cuenta_paciente.saldo precio=$filtro.rango_maximo assign='dinero_faltante'}
    {else}
        {math equation='precio - saldo' saldo=$cuenta_paciente.saldo precio=$ConsultaExpress.precio_tarifa assign='dinero_faltante'}
    {/if}
    <script>
        var DINERO_FALTANTE ={$dinero_faltante};
    </script>


    <section class="container ce-nc-p3">
        <div class="ce-nc-p3-header">
            <figure>
                <i class="icon-doctorplus-dollar"></i>
            </figure>
            <h2 class="ce-nc-p3-title">{"Confirmación de consulta"|x_translate}</h2>
        </div>
        {if $ConsultaExpress.tipo_consulta=="0"}
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
                {if $ConsultaExpress.tipo_consulta=="0"} 
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
            {if  ($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="0" && $especialidad.tipo==1 &&  $filtro.pais_idpais==1) ||($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="1" && $especialidades_medico.0.tipo==1 && $medico.pais_idpais==1)}
                <div class="row" >
                    <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                        <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</h6>
                        <p class="text-center" style="color: #283e73;">{"Si quiere beneficiar de un reintegro de la Consulta Express, tiene que consultar con sus médicos frecuentes."|x_translate}</p>
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
                    <p class="text-center" style="color: #283e73;">{"La consulta de su mascota es por cuenta particular y no se beneficia de reintegro"|x_translate}</p>
                </div>
            </div>
        {/if}
        <!-- FIN banner alerta reintegro-->
        <div class="row">
            <div class="okm-center-col">
                <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>

    </section>
{/if}


{literal}
    <script>

        $(function () {

            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#consulta-express-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }
            ///cargar credito
            /* 
             $("#btnCargarCredito").click(function () {
             localStorage.setItem('payment_redirect', 'ce');
             window.location.href = BASE_PATH + "panel-paciente/credito-proceso-compra/?compra=" + DINERO_FALTANTE;
             });
             */

            //boton para cancelar pago y volver al paso anterior
            $("#btnCancelarPago, #btnModificarRango").click(function () {

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

            //boton siguiente paso- se crea confirmar el choricito
            $("#btnConfirmarPago").click(function () {


                $("#consulta-express-step-container").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'confirmar_pago.do',
                        "idconsultaExpress=" + $("#idconsultaExpress").val(),
                        function (data) {

                            $("#consulta-express-step-container").spin(false);
                            if (data.result) {

                                x_loadModule('consultaexpress', 'nuevaconsulta_step5', 'idconsultaExpress=' + $("#idconsultaExpress").val(), 'consulta-express-step-container', BASE_PATH + "paciente_p");

                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });


        });

    </script>
{/literal}