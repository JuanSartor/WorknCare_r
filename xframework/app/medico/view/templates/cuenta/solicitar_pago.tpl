<section class="okm-container mmc-costos-periodo">


    {*verificamos si ya se ha solicitado el pago*}

    {if $solicitud_pago}
        <div id="mmc-paso-3" class="mmc-costos-periodo-paso-box" style="display:block;">
            <h3>{"Solicitud de pago"|x_translate}</h3>
            <div class="mmc-paso-box-3">
                <p>{"Su solicitud ha sido enviada."|x_translate}</p>

                <ul class="mmc-solicitud-enviada">
                    <li>
                        <span>{"Fecha:"|x_translate}</span>
                        {$solicitud_pago.fecha_solicitud_format}
                    </li>
                    <li>
                        <span>{"Número de solicitud de pago:"|x_translate}</span>
                        {$solicitud_pago.idsolicitudPagoMedico}
                    </li>
                    <li>
                        {if $solicitud_pago.metodo_cobro=="1"}
                            <span>{"PAGO POR TRANSFERENCIA BANCARIA"|x_translate}</span>
                            <div class="mmc-solicitud-enviada-datos-box">
                                <ul class="mmc-datos-de-cuenta">
                                    <li>{"Número de Cuenta:"|x_translate} {$solicitud_pago.numero_cuenta}</li>

                                    <li>{"Banco:"|x_translate} {$solicitud_pago.nombre_banco}</li>
                                    <li>{"Titular:"|x_translate} {$solicitud_pago.titular}</li>

                                </ul>
                            </div>
                        {else}
                            <span>{"PAGO POR CHEQUE"|x_translate}</span>
                            <div class="mmc-solicitud-enviada-datos-box">
                                <ul class="mmc-datos-de-cuenta">
                                    <li>{"Beneficiario:"|x_translate} {$solicitud_pago.titular}</li>
                                </ul>
                            </div>
                        {/if}
                    </li>
                </ul>

                <div class="mmc-action-center-box">
                    <div class="mmc-importe-box">
                        <span>{"Importe"|x_translate}</span>
                        <span class="mmc-price">&euro; {if $periodo_pago.importePeriodo!=""}{$periodo_pago.importePeriodo}{else}0{/if}</span>
                    </div>
                </div>
                {*
                <div id="mmc-costos-periodo-paso1" class="mmc-action-center-box mmc-action-2-btn-box">
                <a href="javascript:;" id="paso-3-cancelar-trg" class="mmc-periodo-pago-btn">{"Cancelar"|x_translate}</a>
                <a href="javascript:;" class="mmc-periodo-pago-btn-print"><i class="icon-doctorplus-print"></i></a>
                </div>*}


            </div>
        </div>
    {else}

        {if $periodo_pago.status_solicitud_pago==1}


            <div id="mmc-paso-0" class="mmc-action-center-box">
                {if !$info_comercial || $periodo_pago.importePeriodo==0}
                    <a href="javascript:;" id="completar_info_comercial" class="mmc-periodo-pago-btn">{"Solicitar pago de período"|x_translate}</a>
                {else}
                    <a href="javascript:;" id="paso-0-trg" class="mmc-periodo-pago-btn">{"Solicitar pago de período"|x_translate}</a>
                {/if}

            </div>

            <div id="mmc-paso-1" class="mmc-costos-periodo-paso-box">
                <h3>{"Solicitud de pago"|x_translate}</h3>
                <div class="mmc-paso-box-1">
                    <div class="mmc-grey-box">
                        <div class="okm-row">
                            <div class="col-x2">
                                <span>{"Importe"|x_translate}</span>
                                <span class="mmc-paso1-importe">&euro; {if $periodo_pago}{$periodo_pago.importePeriodo}{else}0{/if}</span>
                            </div>
                            <div class="col-x2">
                                <span>{"Correspondientes al período"|x_translate}</span>
                                <span class="mmc-paso1-importe">{$nombre_mes} {$periodo_pago.anio}</span>
                            </div>
                        </div>
                    </div>
                    <div id="mmc-costos-periodo-paso1" class="mmc-action-center-box">
                        <a href="javascript:;" id="paso-1-trg" class="mmc-periodo-pago-btn">{"Confirmo"|x_translate}</a>
                    </div>
                </div>
            </div>

            <div id="mmc-paso-2" class="mmc-costos-periodo-paso-box">
                <h3>{"Solicitud de pago"|x_translate}</h3>
                <div class="mmc-paso-box-2">
                    {if $info_comercial}

                        <p>{"Ud. solicitó pago por transfencia a la cuenta bancaria"|x_translate}</p>
                        <div class="mmc-paso-datos-cuenta">
                            <ul class="mmc-datos-de-cuenta">  
                                <li>IBAN: {$info_comercial.iban}</li>
                                <li>{"Banco"|x_translate}: {$info_comercial.nombre_banco}</li>
                                <li>{"Nombre beneficiario"|x_translate} {$info_comercial.nombre_beneficiario}</li>

                            </ul>
                        </div>

                        <div class="mmc-action-center-box">
                            <div class="mmc-importe-box">
                                <span>{"Importe"|x_translate}</span>
                                <span class="mmc-price">&euro; {if $periodo_pago}{$periodo_pago.importePeriodo}{else}0{/if}</span>
                            </div>
                        </div>
                        <div class="mmc-action-center-box mmc-action-2-btn-box">
                            <a href="javascript:;" id="paso-2-cancelar-trg" class="mmc-periodo-pago-btn">{"Cancelar"|x_translate}</a>
                            <a href="javascript:;" id="paso-2-trg" class="mmc-periodo-pago-btn">{"Confirmo"|x_translate}</a>
                        </div>
                    {/if}
                </div>
            </div>

            <div id="mmc-paso-3" class="mmc-costos-periodo-paso-box">
                <h3>{"Solicitud de pago"|x_translate}</h3>
                <div class="mmc-paso-box-3">
                    <p>{"Su solicitud ha sido enviada."|x_translate}</p>

                    <ul class="mmc-solicitud-enviada">
                        <li>
                            <span>{"Fecha:"|x_translate}</span>
                            <span id="fecha_solicitud"></span>
                        </li>
                        <li>
                            <span>{"Número de solicitud de pago:"|x_translate}</span>
                            <span id="numero_solicitud"></span>
                        </li>
                        <li>
                            {if $info_comercial.metodo_cobro=="1"}
                                <span>{"PAGO POR TRANSFERENCIA BANCARIA"|x_translate}</span>
                                <div class="mmc-solicitud-enviada-datos-box">
                                    <ul class="mmc-datos-de-cuenta">
                                        <li>{"Número de Cuenta:"|x_translate} {$info_comercial.numero_cuenta}</li>
                                        <li>{"CBU:"|x_translate} {$info_comercial.CBU}</li>
                                        <li>{"Banco:"|x_translate} {$info_comercial.nombre_banco}</li>
                                        <li>{"Titular:"|x_translate} {$info_comercial.titular}</li>
                                        <li>{"CUIT:"|x_translate} {$info_comercial.cuit}</li>
                                    </ul>
                                </div>
                            {else}
                                <span>{"PAGO POR CHEQUE"|x_translate}</span>
                                <div class="mmc-solicitud-enviada-datos-box">
                                    <ul class="mmc-datos-de-cuenta">
                                        <li>{"Beneficiario:"|x_translate} {$info_comercial.titular}</li>
                                    </ul>
                                </div>
                            {/if}
                        </li>
                    </ul>

                    <div class="mmc-action-center-box">
                        <div class="mmc-importe-box">
                            <span>{"Importe"|x_translate}</span>
                            <span class="mmc-price">&euro; {if $periodo_pago}{$periodo_pago.importePeriodo}{else}0{/if}</span>
                        </div>
                    </div>
                    {*
                    <div id="mmc-costos-periodo-paso1" class="mmc-action-center-box mmc-action-2-btn-box">
                    <a href="javascript:;" id="paso-3-cancelar-trg" class="mmc-periodo-pago-btn">{"Cancelar"|x_translate}</a>
                    <a href="javascript:;" class="mmc-periodo-pago-btn-print"><i class="icon-doctorplus-print"></i></a>
                    </div>*}


                </div>
            </div>
        {else}
            <div id="mmc-paso-0" class="mmc-action-center-box">
                <a href="javascript:;" id="periodo_no_disponible" class="mmc-periodo-pago-btn">{"Solicitar pago de período"|x_translate}</a>
            </div>

        {/if}
    {/if}
    {if $medico.pais_idpais==1 && $especialidad.requiere_modo_facturacion == "1"}

        <div id="div_listado_consultas_reintegro">
            {include file="cuenta/consultas_reintegro.tpl"}
        </div>
    {/if}
    <div class="mmc-costos-periodo-disclaimer">
        <p>
            {"Los profesionales podrán solicitar los pagos de los resumenes a partir del primer día siguiente al cierre del período (mes) reclamado."|x_translate}
        </p>
        <p>
            {"COMISIONES DOCTORPLUS S.A."|x_translate}<br>

            {$COMISION_VC}%&nbsp;{"de costo de uso por consulta. ¡OPTA POR LA SUSCRIPCIÓN DE 10 CONSULTAS POR MES!"|x_translate}
        </p>
        <p>
            {"Los servicios que impliquen mensajes vía SMS requiere que el celular adherido sea apto para dicha tecnología y que se encuentre encendido y dentro del área de cobertura. La baja del celular adherido en el caso mencionado implicará que el cliente deja de recibir avisos de DoctorPlus por dicha vía."|x_translate}
        </p>

    </div>

</section>

<!--	ALERTAS -  modal periodo no habilitado	-->


<div id="modal-periodo-no-habilitado" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                {if $periodo_pago.importePeriodo==0}
                    <p>
                        {"No tiene saldo disponible para transferir en este período"|x_translate}
                    </p>
                {else}
                    <p>
                        {"Ud. podrá solicitar los pagos de los resumenes a partir del primer día siguiente al cierre del período."|x_translate}
                    </p>
                {/if}
                <div class="modal-perfil-completo-action-holder">
                </div>
            </div>
        </div>
    </div>
</div>


<!--	ALERTAS -  modal completar info comercial	-->


<div id="modal-completar-info-comercial" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                {if $periodo_pago.importePeriodo==0}
                    <p>
                        {"No tiene saldo disponible para transferir en este período"|x_translate}
                    </p>
                {else}
                    <p>
                        {"Ud. debe completar su información comercial para solicitar un pago."|x_translate}
                    </p>
                    <div class="modal-perfil-completo-action-holder">
                        <a href="{$url}panel-medico/perfil-profesional/datos-comerciales/" >{"Completar datos comerciales"|x_translate}</a>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>
{literal}
    <script>
        $(function () {
            $("#periodo_no_disponible").click(function () {
                $("#modal-periodo-no-habilitado").modal("show");
            })
            $("#completar_info_comercial").click(function () {
                $("#modal-completar-info-comercial").modal("show");
            })

            $('#paso-0-trg').on('click', function (e) {
                e.preventDefault();
                $('#mmc-paso-0').hide();
                $('#mmc-paso-1').slideDown();
            });

            $('#paso-1-trg').on('click', function (e) {
                e.preventDefault();
                $('#mmc-paso-1').hide();
                $('#mmc-paso-2').fadeIn();
            });

            $('#paso-2-trg').on('click', function (e) {
                e.preventDefault();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'generate_solicitud_medico.do',
                        "idperiodoPago=" + $("#idperiodoPago").val(),
                        function (data) {
                            if (data.result) {
                                $("#fecha_solicitud").html(data.fecha_solicitud);
                                $("#numero_solicitud").html(data.numero_solicitud);

                                $('#mmc-paso-2').hide();
                                $('#mmc-paso-3').fadeIn();
                            } else {
                                x_alert(data.msg);
                            }
                        });

            });

            $('#paso-2-cancelar-trg').on('click', function (e) {
                e.preventDefault();
                $('#mmc-paso-2').slideUp();
                $('#mmc-paso-0').slideDown();
                scrollToEl($('.mmc-title'));
            });

            $('#paso-3-cancelar-trg').on('click', function (e) {
                e.preventDefault();
                $('#mmc-paso-3').slideUp();
                $('#mmc-paso-0').slideDown();
                scrollToEl($('.mmc-title'));
            });
        });
    </script>
{/literal}
