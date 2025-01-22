<div class="ce-nc-consulta-precios-tabla-holder" >
    {if $listado_movimiento_cuenta.rows|@count>0}
        <div class="nc-tabla-precios">
            <div class="nc-header">
                <div class="nc-td">{"Fecha"|x_translate}</div>
                <div class="nc-td">{"Detalle"|x_translate}</div>
                <div class="nc-td">{"Profesional"|x_translate}</div>
                <div class="nc-td">{"Valor"|x_translate}</div>
            </div>

            {foreach from=$listado_movimiento_cuenta.rows item=movimiento}
                <div class="nc-row">
                    <div class="nc-td">

                        {$movimiento.fecha|date_format:"%d/%m/%Y %H:%M"}
                    </div>
                    <div class="nc-td" data-type="tipo">{$movimiento.detalleMovimientoCuenta}</div>
                    <div class="nc-td">
                        {if $movimiento.idmedico!=""}
                            {$movimiento.titulo_profesional} {$movimiento.nombre_medico} {$movimiento.apellido_medico} {if $movimiento.prestador!=""}{$movimiento.prestador}{/if}
                        {else} 
                            {if $movimiento.tipo_consulta=="0"}
                                {"PROFESIONALES EN LA RED"|x_translate}
                            {else}
                                -
                            {/if}

                        {/if}
                    </div>
                    {*consultas del plan empresa*}
                    <div class="nc-td  {if $movimiento.is_ingreso == "1"}saldo-menor{else}red{/if}">
                        {if $movimiento.debito_plan_empresa=="1"}
                            {if $movimiento.is_ingreso == "1"}

                                {if $movimiento.consultaExpress_idconsultaExpress!=""}
                                    +1&nbsp;{"consulta por chat"|x_translate}
                                {/if}
                                {if $movimiento.videoconsulta_idvideoconsulta!="" || $movimiento.turno_idturno!=""}
                                    +1&nbsp;{"consulta por video"|x_translate}
                                {/if}
                            {else}
                                {if $movimiento.consultaExpress_idconsultaExpress!=""}
                                    -1&nbsp;{"consulta por chat"|x_translate}
                                {/if}
                                {if $movimiento.videoconsulta_idvideoconsulta!="" || $movimiento.turno_idturno!=""}
                                    -1&nbsp;{"consulta por video"|x_translate}
                                {/if}
                            {/if}
                        {else}
                            {*dinero paciente*}
                            {if $movimiento.is_ingreso == "1"}
                                {if $movimiento.reembolso_idreembolso!=''}
                                    - 1 PRESTATION
                                {else}
                                    + &euro; {$movimiento.monto}
                                {/if}
                            {else}
                                {if $movimiento.reembolso_idreembolso!=''}
                                    + 1 PRESTATION
                                {else}
                                    - &euro; {$movimiento.monto}
                                {/if}
                            {/if}
                        {/if}
                        {if $movimiento.stripe_payment_intent_id!=""}
                            &nbsp;
                            <button class="btn-xs btn btn-white btn-ticket-stripe" data-payment="{$movimiento.stripe_payment_intent_id}" style="padding: 2px 10px; width: auto; margin-bottom: 5px">
                                <i class="fa fa-download" aria-hidden="true"></i>
                            </button>  
                        {/if}
                    </div>
                </div>
                <div class="nc-row-small">
                    <div class="nc-td">{"Detalle"|x_translate}</div>
                    <div class="nc-td"></div>
                </div>
            {/foreach}

        </div>

        <span class="ce-nc-consulta-precios-tabla-footer">{"Los valores marcados en verde, corresponden a devoluciones realizadas en su cuenta por diferencia de tarifa o carga de crédito."|x_translate}</span>
        {if $listado_movimiento_cuenta.records>$listado_movimiento_cuenta.total}
            <div class="ce-nc-footer-table-lnk">
                <a href="javascript:;" class="ce-nc-footer-table-lnk-action">{"ver consumos anteriores"|x_translate}</a>
            </div>

            <div class="paginas ce-nc-pagination">
                {if $listado_movimiento_cuenta.rows && $listado_movimiento_cuenta.rows|@count > 0}
                    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="home"
        submodulo="estado_cuenta_listado_movimientos" 
        container_id="div_listado_movimiento_cuenta"}
                {/if}
            </div>
        {/if}
    {else}
        <span class="ce-nc-consulta-precios-tabla-footer">{"Aún no se han registrado movimientos"|x_translate}</span>
    {/if}

</div>

{*si no hay movimientos ocultamos la cabecera del contenedor del modulo padre*}
{if $listado_movimiento_cuenta.rows|@count>0}
    <script>
        $(".ce-nc-consulta-precios-tabla-titulo").show();
    </script>
{else}
    <script>
        $(".ce-nc-consulta-precios-tabla-titulo").hide();
    </script>
{/if}


<script>
    $(function () {
        $('.ce-nc-consulta-precios-tabla-holder').show();
        $(".ce-nc-footer-table-lnk").hide();
        $('.ce-nc-pagination').show();
    });
</script>


{literal}
    <script>
        function getScrollBarWidth() {
            var inner = document.createElement('p');
            inner.style.width = "100%";
            inner.style.height = "200px";

            var outer = document.createElement('div');
            outer.style.position = "absolute";
            outer.style.top = "0px";
            outer.style.left = "0px";
            outer.style.visibility = "hidden";
            outer.style.width = "200px";
            outer.style.height = "150px";
            outer.style.overflow = "hidden";
            outer.appendChild(inner);

            document.body.appendChild(outer);
            var w1 = inner.offsetWidth;
            outer.style.overflow = 'scroll';
            var w2 = inner.offsetWidth;
            if (w1 == w2)
                w2 = outer.clientWidth;

            document.body.removeChild(outer);

            return (w1 - w2);
        }
        ;

        function tablaprecios(vpw) {
            if (vpw < 800) {

                $('.nc-td').children('i').show();

                $('.nc-row').on('click', function (e) {

                    //cambiar texto
                    texto = $(this).find('[data-type="tipo"]').text();
                    $(this).next('.nc-row-small').find('.nc-td').last().html(texto);

                    //muetra row
                    hrow = $(this).next('.nc-row-small');
                    /*  
                     if ($(hrow).is(":visible")) {
                     $(hrow).hide();
                     } else {
                     $(hrow).show();
                     }*/
                    if (hrow.is(":visible")) {
                        hrow.hide();
                    } else {
                        hrow.show();
                    }


                    symbolPlus = $(this).find('i');

                    if (symbolPlus.hasClass('icon-doctorplus-circle-add')) {
                        //open
                        symbolPlus.removeClass('icon-doctorplus-circle-add')
                                .addClass('icon-doctorplus-circle-minus')
                                .addClass('nc-symbol-red');
                        $(this).find('.nc-td').addClass('nc-td-border');




                    } else if (symbolPlus.hasClass('icon-doctorplus-circle-minus')) {
                        //close
                        symbolPlus.removeClass('icon-doctorplus-circle-minus')
                                .addClass('icon-doctorplus-circle-add')
                                .removeClass('nc-symbol-red');
                    }



                });
            } else {
                $('.nc-td').children('i').hide().stop();
                $('.nc-row').off('click');
                $('.nc-row-small').hide();
            }
        }

        $(document).ready(function () {


            if ($('.ce-nc-footer-table-lnk-action').length > 0) {
                $('.ce-nc-footer-table-lnk-action').on('click', function (e) {
                    e.preventDefault();
                    $(".ce-nc-footer-table-lnk").hide();
                    $('.ce-nc-pagination').show();
                });
            }
            $(".btn-ticket-stripe").click(function () {
                $("body").spin();
                var payment_intent_id = $(this).data("payment");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'paciente_p.php?action=1&modulo=home&submodulo=ver_ticket_stripe',
                        "payment_intent_id=" + payment_intent_id,
                        function (data) {
                            $("body").spin(false);
                            if (data.result && data.url) {
                                window.open(data.url);
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            });

            if ($(".nc-tabla-precios").length > 0) {

                var vpw = $(window).width() + getScrollBarWidth();
                tablaprecios(vpw);

                $(window).resize(function () {
                    var vpw = $(window).width() + getScrollBarWidth();
                    //vpw = jQuery('body').width() + getScrollBarWidth();
                    tablaprecios(vpw);
                });

            }
        });

    </script>
{/literal}