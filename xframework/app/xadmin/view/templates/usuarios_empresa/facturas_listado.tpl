{if $listado_facturas.data && $listado_facturas.data|@count > 0}
    <div class="table table-responsive tabla-facturas">
        <table class="table">

            <tr>  

                <th width="20%" align="left">{"Fecha"|x_translate}</th>
                <th width="25%" align="left">{"Monto"|x_translate}</th>
                <th width="20%" align="left">{"Estado"|x_translate}</th>

                <th width="25%" align="left">&nbsp;</th>
                <th width="25%" align="left">{"Transferencia recibida"|x_translate}</th>

            </tr>
            {foreach from=$listado_facturas.data item=factura}
                <td align="left">{$factura.date|date_format:"%d/%m/%Y"}</td>
                <td align="left" >&euro;{math equation="total/100" total=$factura.total assign=total} {$total|number_format:2}</td>
                <td    {if $factura.status!="paid"}class="red"{/if}>
                    {if $factura.status=="paid" || $factura.suscripcion.pack_pago_pendiente =='2'}
                        <i class="fa fa-check"></i>&nbsp;
                        {"Pagado"|x_translate}
                    {else if $factura.status=="open" || $factura.status=="draft"}
                        <i class="fa fa-clock-o"></i>&nbsp;
                        {"Pendiente"|x_translate}
                    {else}
                        <i class="fa fa-times-circle"></i>&nbsp;
                        {"Pago pendiente"|x_translate}
                    {/if}
                </td>
                <td align="left">
                    {if $factura.invoice_pdf!="" && $factura.visible !='0'}
                        <a href="{$factura.invoice_pdf}" target="_blank" class=" btn btn-default btn-factura" style="margin: 0 10px;">
                            <i class="fa fa-file-o"></i> 
                            {"descargar"|x_translate}
                        </a>
                    {else}
                        <a href="{$url}xframework/files/entities/facturas_pagopackmanual_recompra/{$factura.suscripcion.empresa_idempresa}/fac-pay-{$factura.suscripcion.idprograma_salud_suscripcion}.pdf" target="_blank" class=" btn btn-default btn-factura" style="margin: 0 10px;">
                            <i class="fa fa-file-o"></i> 
                            {"descargar"|x_translate}
                        </a>  
                    {/if}
                </td>
                <td align="left">
                    {if  $factura.visible !='0'}
                        {"No Aplica"|x_translate}
                    {else}
                    <li class="right checkbox-inline">
                        <label class="checkbox">
                            <input type="checkbox"  name="sus" value="{$factura.suscripcion.pack_pago_pendiente}" {if $factura.suscripcion.pack_pago_pendiente =='2' } checked {/if} data-id="{$factura.suscripcion.idprograma_salud_suscripcion}" data-toggle="checkbox" id="{$factura.suscripcion.idprograma_salud_suscripcion}" class="custom-checkbox chkTrnRecompra">
                        </label>
                    </li>
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


<script>
    $(".chkTrnRecompra").change(function () {
        idSus = $(this).data("id");
        if ($('#' + idSus).prop('checked')) {
            jConfirm(
                    "Confirma que  ha recibido la transferencia de recompra de Packs!",
                    "Confimar transferencia recibida",
                    function (r) {
                        if (r) {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'xadmin.php?action=1&modulo=usuarios_empresa&submodulo=actualizar_sus_pack_transfe',
                                    "idempresa=" + $("#idempresa").val() + "&idSus=" + idSus,
                                    function (data) {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    }
                            );
                        }
                        x_goTo('usuarios_empresa', 'usuarios_form', 'id=' + $("#idempresa").val(), 'Main', this);

                    }
            );
        } else {
            x_alert(x_translate("Ya ha Aprobado el pago"));
            x_goTo('usuarios_empresa', 'usuarios_form', 'id=' + $("#idempresa").val(), 'Main', this);

        }
    });
</script>