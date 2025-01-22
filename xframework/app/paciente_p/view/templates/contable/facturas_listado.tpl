<style>
    .tabla-facturas .btn-factura {
        color: #ffffff;
        padding: 12px 24px;
    }
</style>
<link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" >

{*banner suscripcion cancelada*}
{if $empresa.cancelar_suscripcion!="0"}
    <section class="okm-container">
        <div class="alert alert-danger text-center" role="alert">
            <p>{"Ha solicitado no renovar su suscripcion actual al Pase de Salud."|x_translate}</p> 
            <p>{"La suscripcion seguirá siendo válida hasta finalizar el periodo de 12 meses y se anulará luego del"|x_translate}&nbsp;{$empresa.fecha_vencimiento_format}.</p>
            {if $empresa.cancelar_suscripcion=="1"}
                <p>{"Si desea deshacer la cancelación por favor haga"|x_translate}&nbsp;<a href="javascript:;" id="anular_cancelar_suscripcion" class="alert-link">{"click aqui"|x_translate}</a>.
                {/if}
        </div>
    </section>
{/if}
{include file="contable/info_facturacion.tpl"}
<section class="okm-container">
    <div class="table-detail">
        <div class="col-xs-12" style="margin:40px 0;" >
            <div class="table-reference">
                <h2><button class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>{"Facturas"|x_translate}:</h2>
                <div class="facturacion-box pull-right">

                    <h2>{"Información para la facturación"|x_translate}</h2>

                    <a href="javascript:;" id="btnInfoFacturacion" class="btn btn-default btn-xs">{"editar datos"|x_translate}</a>

                </div>

            </div>
            {if $listado_facturas.data && $listado_facturas.data|@count > 0}
                <div class="table table-responsive tabla-facturas">
                    <table class="table">

                        <tr>  
                            <th width="20%">&nbsp;</th>
                            <th width="40%">{"Fecha"|x_translate}</th>
                            <th width="20%">{"Monto"|x_translate}</th>
                            <th width="20%">{"Estado"|x_translate}</th>
                        </tr>
                        {foreach from=$listado_facturas.data item=factura}

                            <td align="center">
                                {if $factura.invoice_pdf!=""}
                                    {if $empresa.direccion=="" or ($empresa.siren=="" and $empresa.tipo_cuenta=="1") or $empresa.codigo_postal=="" or $empresa.ciudad=="" or $empresa.pais=="" or $empresa.empresa=="" }
                                        <a href="javascript:;" class=" btn btn-default btn-factura btn-descargar">
                                            <i class="fa fa-file-o"></i> 
                                            {"descargar"|x_translate}
                                        </a>
                                    {else}
                                        <a href="{$factura.invoice_pdf}" target="_blank" class=" btn btn-default btn-factura">
                                            <i class="fa fa-file-o"></i> 
                                            {"descargar"|x_translate}
                                        </a>
                                    {/if}
                                {/if}

                            </td>

                            <td>{$factura.date|date_format:"%d/%m/%Y"}</td>
                            <td>&euro;{math equation="total/100" total=$factura.total assign=total} {$total|number_format:2}</td>
                            <td {if $factura.status!="paid" && $factura.status!="open"}class="red"{/if}>
                                {if $factura.total=="0"}
                                    <i class="fa fa-minus"></i>
                                {else}
                                    {if $factura.status=="paid"}
                                        <i class="fa fa-check"></i>&nbsp;
                                        {"Pagado"|x_translate}
                                    {else if $factura.status=="open" || $factura.status=="draft"}
                                        <i class="fa fa-clock-o"></i>&nbsp;
                                        {"Pendiente"|x_translate}
                                    {else if $factura.status=="void"}
                                        <i class="fa fa-times"></i>&nbsp;
                                        {"Cancelada"|x_translate}
                                    {else}
                                        <a href="{$factura.hosted_invoice_url}" target="_blank" class=" btn btn-alert btn-alert btn-factura">
                                            <i class="fa fa-times-circle"></i>&nbsp;
                                            {"Pago pendiente"|x_translate}: {"Pagar"|x_translate}
                                        </a>
                                    {/if}
                                {/if}
                            </td>

                            </tr>
                        {/foreach}

                    </table>
                </div>
            {else}
                <div class="col-xs-12">
                    <div class="row">
                        <p class="text-center"> {"Aun no posee períodos facturados"|x_translate}</p>
                    </div>
                </div>
            {/if}
        </div>
    </div>
    <div class="okm-row text-center">
        <a href="javascript:;" class="btn btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
    </div>
    <div class="clearfix">
        &nbsp;
    </div>
</section>
{if $empresa.contratacion_manual!="1"}
    {include file="contable/metodo_pago.tpl"}
{/if}

{literal}
    <script>
        $("body").spin(false);
        $(function () {
            //volver a la home

            $(".btn-volver").click(function () {
                $("#Main").spin("large");
                x_loadModule('home', 'home', '', 'Main');
            });

            $("#btnInfoFacturacion").click(function () {
                $("#form_info_facturacion_container").slideDown();
            });
            //anular cancelacion de suscripcion
            $("#anular_cancelar_suscripcion").click(function (e) {
                e.preventDefault();
                jConfirm({
                    title: x_translate("Aceptar renovación"),
                    text: x_translate('Está por aceptar la renovación de su Plan de Salud luego del periodo de 12 meses de contratación. ¿Desea continuar?'),
                    confirm: function () {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'paciente_p.php?action=1&modulo=contable&submodulo=deshacer_cancelar_suscripcion',
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

        });

        $(".btn-descargar").click(function () {
            x_alert(x_translate('Debe completar su información comercial para acceder a las facturas generadas'), function () {
                scrollToEl($("#formFacturaDatos"));
                $("#form_info_facturacion_container").slideDown();

            });
        });
    </script>
{/literal}

