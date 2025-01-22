<style>
    .invitaciones-container{
        padding: 0 15px;
    }
    .invitacion-item{
        border: solid 1px #ccc;
        border-radius: 10px;
        background-color: #fff;
        margin: 10px;
        box-shadow: 2px 2px 10px 0 #666;
        max-width: 780px;
        margin:10px auto ;
        padding: 15px;
    }
    .invitacion-item .row-data{
        width:100%;
        display: flex;
        justify-content: space-between;

    }
    .invitacion-item .col-data h3 {
        margin: 0;
        padding: 0 0 2px;
        font-size: 16px;
        line-height: 18px;
        color: #415b70;
    }
    .invitacion-item .col-data h4 {
        margin: 0;
        padding: 0 0 4px;
        font-size: 16px;
        line-height: 18px;
        color: #1ABCA1;
        font-weight: 400;
    }
    .reenvio-data{
        text-align: center;
    }
    .reenvio-data .btn-cancelar-invitacion{
        font-size: 14px;
        color: #cf3244;
        margin-left: 10px;
        border: solid 1px;
        border-radius: 6px;
        padding: 4px 10px;
    }
    .reenvio-data .btn-cancelar-invitacion:hover {
        background-color: #F23243;
        color: #fff;
    }
    .reenvio-data .btn-cancelar-invitacion i{
        font-size: 14px;
    }
</style>
<div class="invitaciones-container">
    {foreach from=$listado_invitaciones item=medico_invitacion} 
        <div class="invitacion-item">
            <div class="row-data">
                <div class="col-data">

                    <h3>{$medico_invitacion.nombre}</h3>
                    <h4>{if $medico_invitacion.medico_cabecera==1}{"Médico de cabecera"|x_translate}{else}{$medico_invitacion.especialidad}{/if}</h4>     
                </div>

                <div class="col-action">
                    <a href="javascript:;" class="btn-default btn btn-xs reenviar_invitacion" data-id="{$medico_invitacion.idpaciente_medico_invitacion}" class="reenviar_invitacion">{"reenviar"|x_translate} <i class="dpp-send"></i> </a>
                </div>
            </div>
            <div class="reenvio-data ">
                <small><em>{"Solicitud enviada el"|x_translate} {$medico_invitacion.ultimoenvio|date_format:"%d/%m/%Y %H:%M"}</em></small>
                <a href="javascript:;" class="btn-cancelar-invitacion" data-id="{$medico_invitacion.idpaciente_medico_invitacion}">{"Cancelar"|x_translate}</a>
            </div>
        </div>
    {/foreach}
</div>
{literal}
    <script>
        $(function () {
            $("#div_invitaciones_medicos_frecuentes").spin(false);

            //boton reenviar invitacion
            $(".reenviar_invitacion").click(function () {
                var id = parseInt($(this).data("id"));
                if (id > 0) {


                    //confirmar la accion
                    jConfirm({
                        title: x_translate("Reenviar invitación"),
                        text: x_translate("Confirma que desea reenviar la invitación al profesional?"),
                        confirm: function () {

                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "reenviar-invitacion-medico.do",
                                    "id=" + id,
                                    function (data) {
                                        x_alert(data.msg);
                                        $("body").spin(false);
                                        if (data.result) {

                                            $("#div_invitaciones_medicos_frecuentes").spin("large");
                                            x_loadModule('home', 'invitaciones_medicos_frecuentes_list', '', 'div_invitaciones_medicos_frecuentes');

                                        }
                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                }
            });

            //boton eliminar 
            $(".btn-cancelar-invitacion").click(function () {
                var id = parseInt($(this).data("id"));
                if (id > 0) {


                    //confirmar la accion
                    jConfirm({
                        title: x_translate("Cancelar invitación"),
                        text: x_translate("Confirma que desea cancelar la invitación al profesional?"),
                        confirm: function () {

                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "cancelar-invitacion-medico.do",
                                    "id=" + id,
                                    function (data) {
                                        x_alert(data.msg);
                                        $("body").spin(false);
                                        if (data.result) {

                                            $("#div_invitaciones_medicos_frecuentes").spin("large");
                                            x_loadModule('home', 'invitaciones_medicos_frecuentes_list', '', 'div_invitaciones_medicos_frecuentes');


                                        }
                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                }
            });
        });
    </script>
{/literal}