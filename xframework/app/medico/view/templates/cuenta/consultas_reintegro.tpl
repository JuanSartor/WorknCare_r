{literal}
<style>
    tr.facturacion-pendiente td{background-color: #f9cfcf;}
</style>
{/literal}
<div class="hom-soporte  text-center" style="padding-bottom:0px;">
    {if $cantidad>0}
    <p style="padding-bottom:0px;">{"Tiene [[{$cantidad}]] consultas pendientes de facturación"|x_translate}</p>
    {else}
    <p style="padding-bottom:0px;">{"No tiene consultas pendientes de facturación"|x_translate}</p>
    {/if}
    {if $medico.facturacion_teleconsulta==1}
    <span>Mode de facturation choisi: {"Teletransmision caja 'mode dégradé'"|x_translate}</span>
    {/if}
    {if $medico.facturacion_teleconsulta==2}
    <span>Mode de facturation choisi: {"Envio por el paciente"|x_translate}</span>
    {/if}
</div>

<div class="table-detail">
    <div class="container" style="margin:40px;">
        <div class="table-reference">
            <h2>{"Consultas con reintegro"|x_translate}</h2>
            <div class="ce-ca-toolbar-filter-box" style="margin-top: 32px; float:right;margin-top:0px;width: auto;">
                <div class="ce-ca-toolbar-desde-box">
                    <label>{"Mostrar desde"|x_translate}
                        <input type="text" id="filtro_inicio" name="filtro_inicio" value="{$filtro_inicio}" placeholder="dd/mm/aaaa"/>
                    </label>
                </div>
                <div class="ce-ca-toolbar-hasta-box">
                    <label>{"hasta"|x_translate}
                        <input type="text" id="filtro_fin" name="filtro_fin" value="{$filtro_fin}" placeholder="dd/mm/aaaa"/>
                    </label>
                </div>
                <div class="ce-ca-toolbar-action-box">
                    <button id="btnAplicarFiltro"><i class="icon-doctorplus-search"></i></button>
                </div>
            </div>

        </div>
        <table class="table table-responsive">

            <tr>
                <th>{"Video Consulta"|x_translate}</th>
                <th>{"Fecha"|x_translate}</th>
                <th>{"Titular"|x_translate}</th>    
                <th>{"Tarjeta Vitale"|x_translate}</th>                 
                <th>{"Importe"|x_translate}</th>
                <th>{"Estado"|x_translate}</th>
                <th>&nbsp;</th>
            </tr>
            {foreach from=$videoconsultas_reintegro.rows item=videoconsulta}
            <tr {if $videoconsulta.estado_facturacion_caja==""}class="facturacion-pendiente"{/if}>


                <td> Nº{$videoconsulta.numeroVideoConsulta}</td>
                <td>{$videoconsulta.fecha_inicio_format}</td>
                <td>{if $videoconsulta.paciente.titular==1}{$videoconsulta.paciente.nombre} {$videoconsulta.paciente.apellido}{else}{$videoconsulta.paciente_titular.nombre} {$videoconsulta.paciente_titular.apellido}{/if}</td>
                <td>{if $videoconsulta.paciente.titular==1}{$videoconsulta.paciente.tarjeta_vitale}{else}{$videoconsulta.paciente_titular.tarjeta_vitale}{/if}</td>
                <td>&euro;{$videoconsulta.precio_tarifa}</td>
                <td>{$videoconsulta.estado_facturacion}</td>
                <td align="center"><a href="javascript:;" class="btnConsultaDetalle" data-id="{$videoconsulta.idvideoconsulta}"><i class="icon-doctorplus-search"></i></a></td>
            </tr>
            {/foreach}

        </table>
        {if $videoconsultas_reintegro.rows && $videoconsultas_reintegro.rows|@count > 0}
        <div class="paginas">

            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="cuenta"
            submodulo="consultas_reintegro" 
            container_id="div_listado_consultas_reintegro"}

        </div>
        {/if}
    </div>
</div>
<!-- Modal detalle videoconsulta -->

<div id="modal_consultas_reintegro_detalle" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content" id="div_consultas_reintegro_detalle">

        </div>
    </div>
</div>

{literal}
<script>
    $("body").spin(false);
    $(function () {
        $(".btnConsultaDetalle").click(function () {
            var id = $(this).data("id");
            $("body").spin("large");
            x_loadModule('cuenta', "consultas_reintegro_detalle", "id=" + id, "div_consultas_reintegro_detalle").then(function () {
                $("#modal_consultas_reintegro_detalle").modal("show");
                $("body").spin(false);
            })

        });

        //boton filtro de consultas finalizadas por fecha
        $("#btnAplicarFiltro").click(function () {
            $("body").spin("large");
            x_loadModule('cuenta', 'consultas_reintegro', 'do_reset=1&filtro_inicio=' + $("#filtro_inicio").val() + '&filtro_fin=' + $("#filtro_fin").val(), 'div_listado_consultas_reintegro').then(function () {

                $("body").spin(false);
            });
        });

        //filtros de busqueda por fecha
        $("#filtro_inicio,#filtro_fin").datetimepicker({
            pickTime: false,
            language: 'fr'
        });
        $("#filtro_inicio,#filtro_fin").inputmask("d/m/y");


    });
</script>
{/literal}
