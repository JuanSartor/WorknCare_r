    
<div class="modal-header">
    <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">{"Video Consulta"|x_translate} Nº {$videoconsulta.numeroVideoConsulta}</h4>
</div>
<div class="modal-body" >
    <form id="f_consulta_reintegro" action="{$url}panel-medico/mi-cuenta/facturar_reintegro_consulta.do" method="POST" onsubmit="return false;">
        <input  type="hidden" name="idvideoconsulta" value="{$videoconsulta.idvideoconsulta}"/>
        <table class="table table-condensed table-responsive tabla-consulta-reintegro-detalle">


            <tbody>
                <tr> 
                    <td width="200">{"Fecha"|x_translate}</td>
                    <td>{$videoconsulta.fecha_inicio_format}</td>
                </tr>
                <tr> 
                    <td>{"Titular de la cuenta"|x_translate}</td>
                    <td>{if $videoconsulta.paciente.titular==1}{$videoconsulta.paciente.nombre} {$videoconsulta.paciente.apellido}{else}{$videoconsulta.paciente_titular.nombre} {$videoconsulta.paciente_titular.apellido}{/if}</td>
                </tr>
                <tr> 
                    <td>{"Paciente"|x_translate}</td>
                    <td>{$videoconsulta.paciente.nombre} {$videoconsulta.paciente.apellido}</td>
                </tr>
                <tr> 
                    <td>{"Tarjeta Vitale"|x_translate}</td>
                    <td>{if $videoconsulta.paciente.titular==1}{$videoconsulta.paciente.tarjeta_vitale}{else}{$videoconsulta.paciente_titular.tarjeta_vitale}{/if}</td>
                </tr>
                <tr> 
                    <td>{"Importe"|x_translate}</td>
                    <td>&euro;{$videoconsulta.precio_tarifa}</td>
                </tr>

                <tr> 
                    <td>{"Médico de cabecera"|x_translate}</td>
                    <td>{$videoconsulta.medico_cabecera.nombre} {$videoconsulta.medico_cabecera.apellido}</td>
                </tr>
                <tr> 
                    <td>{"ALD"|x_translate}</td>
                    <td>{if $videoconsulta.paciente.beneficia_ald==1}{"Si"|x_translate}{else}{"No"|x_translate}{/if}</td>
                </tr>
                <tr> 
                    <td>{"Código"|x_translate}</td>
                    <td>{$videoconsulta.grilla.codigo}</td>
                </tr>
                <tr> 
                    <td>{"Facturación caja"|x_translate}</td>
                    <td>
                        <select class="form-control" id="estado_facturacion_caja" name="estado_facturacion_caja">
                            <option value="" {if $videoconsulta.estado_facturacion_caja==""}selected{/if}>{"Seleccione una opción"|x_translate}</option>               
                            <option value="1" {if $videoconsulta.estado_facturacion_caja==1}selected{/if}>{"Facturada"|x_translate}</option>1:Facturada -2:No elegible para reintegro -3:No elegible para reintegro
                            <option value="2" {if $videoconsulta.estado_facturacion_caja==2}selected{/if}>{"No elegible para reintegro"|x_translate}</option>
                            {*<option value="3" {if $videoconsulta.estado_facturacion_caja==3}selected{/if}>{"Rechazada"|x_translate}</option>*}
                        </select>
                    </td>
                </tr>
                <tr {if $videoconsulta.idmotivo_rechazo_reintegro==""} style="display:none;" {/if} id="div_motivo_rechazo_reintegro"> 
                    <td>{"Motivo de rechazo"|x_translate}</td>
                    <td>
                        <select class="form-control" id="idmotivo_rechazo_reintegro" name="idmotivo_rechazo_reintegro" >
                            <option value="" {if $videoconsulta.idmotivo_rechazo_reintegro==""}selected{/if}>{"Seleccione una opción"|x_translate}</option>         
                            <option value="1" {if $videoconsulta.idmotivo_rechazo_reintegro==1}selected{/if}>{"Numero tarjeta no valido"|x_translate}</option>               
                            <option value="2" {if $videoconsulta.idmotivo_rechazo_reintegro==2}selected{/if}>{"No soy médico de cabeza"|x_translate}</option>
                            <option value="3" {if $videoconsulta.idmotivo_rechazo_reintegro==3}selected{/if}>{"No es paciente ALD"|x_translate}</option>
                            <option value="4" {if $videoconsulta.idmotivo_rechazo_reintegro==4}selected{/if}>{"No tuvimos consulta presencial en los últimos 12 meses"|x_translate}</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
    <div class="modal-perfil-completo-action-holder">
        <a href="javascript:;"  class="btn btn-blue" id="btnCerrar">{"volver"|x_translate}</a>
       {if $videoconsulta.estado_facturacion_caja==""} <a href="javascript:;" class="btn btn-blue"   id="btnGuardar" >{"guardar"|x_translate}</a>{/if}

    </div>
</div>
{literal}
<script>
    $("#estado_facturacion_caja").change(function () {
        if ($("#estado_facturacion_caja").val() == 2 || $("#estado_facturacion_caja").val() == 3) {
            $("#div_motivo_rechazo_reintegro").show();
        } else {
            $("#div_motivo_rechazo_reintegro").hide();
        }
    });

    $("#btnCerrar").click(function () {
        $("#modal_consultas_reintegro_detalle").modal("hide");
    })

    $("#btnGuardar").click(function () {
        if ($("#estado_facturacion_caja").val() == "") {
            x_alert(x_translate("Complete los datos obligatorios"));
            return false;
        }
        if (($("#estado_facturacion_caja").val() == 2 || $("#estado_facturacion_caja").val() == 3) && $("#idmotivo_rechazo_reintegro").val() == "") {
            x_alert(x_translate("Complete los datos obligatorios"));
            return false;
        }

        //enviamos el formulario para crear el paciente
         $("#div_consultas_reintegro_detalle").spin("large");
        x_sendForm($('#f_consulta_reintegro'), true, function (data) {
             $("#div_consultas_reintegro_detalle").spin(false);
            x_alert(data.msg);
            if (data.result) {
                $("#modal_consultas_reintegro_detalle").modal("hide");
                $("body").spin("large");
                x_loadModule('cuenta', 'consultas_reintegro', 'do_reset=1&filtro_inicio=' + $("#filtro_inicio").val() + '&filtro_fin=' + $("#filtro_fin").val(), 'div_listado_consultas_reintegro');

            } else {

            }

        });

    })

</script>
{/literal}