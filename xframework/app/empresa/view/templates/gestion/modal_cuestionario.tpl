<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

<div class="modal modal-flyer-cuestionario" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-flyer-cuestionario">
    <div class="modal-dialog container" role="document">
        <div class="modal-content  ">



            <div class="modal-body">
                <button type="button" class="dp-dismiss custom close" id="cerrarModal" data-dismiss="modal" aria-label="Close"></button>
                <div class="form-group okm-row" id="content_to_copy">

                    <div class="text-center">
                        {if $record.image!=''}
                            <div class="row" style="display: flex; justify-content: center;">

                                <div style="margin-bottom: 20px;" class="pass-logo-socio">
                                    <img  class="icono-empresa-socia" src="{$record.image.usuario}?t={$smarty.now}">

                                </div>
                            </div>
                        {/if}
                        <div style="margin-left: 170px;" >
                            <div style="display: flex; width: 400px;" class="input-group">
                                <span style="border: 0px; font-size: 12px; background: #3DB4C0;" class="input-group-addon" id="sizing-addon2"><i class="fa fa-pencil" aria-hidden="true"></i></span>
                                <input id="titulo" name="titulo" maxlength="30" style="border:2px solid #3DB4C0; font-weight: 600; font-size: 20px;" type="text" class="form-control" placeholder="{"Añadir un titulo aqui"|x_translate}" aria-describedby="sizing-addon2">
                            </div>
                            <div style="display: flex; width: 400px; margin-top: 15px; margin-bottom: 15px;" class="input-group">
                                <input id="subtitulo" name="subtitulo" maxlength="70" style="border-radius: 6px; background: #f1f1f1; border:2px solid #f1f1f1; color: #343232;" type="text" class="form-control" placeholder="{"Texto suplementario aqui"|x_translate}" aria-describedby="sizing-addon2">
                            </div>

                            <img style="width: 170px; margin-left: 100px;" class="qr-code" src="{$url}frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=generar_qr_cuestionario&id={$smarty.request.id}" />

                            <div style="display: flex; width: 400px; margin-bottom: 15px; margin-top: 15px;" class="input-group">
                                <input id="complementario" name="complementario" maxlength="70" style="border-radius: 6px; background: #f1f1f1; border:2px solid #f1f1f1; color: #343232;" type="text" class="form-control" placeholder="{"Añadir texto adicional aqui"|x_translate}" aria-describedby="sizing-addon2">
                            </div>
                        </div>

                    </div>

                    <div class="text-center">
                        <a id="btnInputsFlyers"  style="margin-bottom: 10px;"    class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta "  >{"Personalizar"|x_translate}</a>
                        <a   id="btngenerarFlyersc" href="{$url}empresa.php?action=1&modulo=gestion&submodulo=cuestionario_pass_flayer&id={$smarty.request.id}"  name="btngenerarFlyersc" style=" display: none; margin-bottom: 10px;"   class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta " target="_blank" ><i style="margin-left: 10px;" class="fa fa-print"></i>{"Generar Flyer"|x_translate}</a>

                    </div>

                </div>
            </div>

        </div>
    </div>
</div>
<script>
    $(function () {

        $("#cerrarModal").click(function (e) {
            $("#divEliminar").hide();
            $("#divModificar").hide();
            $("#divFinalizar").show();
            $("#divFlayer").show();
        });

        $("#btnInputsFlyers").click(function (e) {
            idcuestionario = $("#idcuestionario").val();
            titulo = $("#titulo").val();
            subtitulo = $("#subtitulo").val();
            complementario = $("#complementario").val();
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=cargar_inputs_flyer",
                    'idcuestionario=' + idcuestionario + "&titulo_flyer=" + titulo + "&subtitulo_flyer=" + subtitulo + "&complementario_flyer=" + complementario,
                    function (data) {

                        if (data.result) {
                            $("#btngenerarFlyersc").css("display", "block");
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );

        });
    });
</script>