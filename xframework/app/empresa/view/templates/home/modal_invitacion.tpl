<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

<div class="modal modal-flyer-invitacion" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-flyer-invitacion">
    <div class="modal-dialog container" role="document">
        <div class="modal-content  ">

            <input hidden id='idEmpresa' name="idEmpresa" value="{$empresa.idempresa}">

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
                        <div style="margin-left: 140px;" >
                            <div style="display: flex; width: 400px; margin-left: 35px;" class="input-group">
                                <span style="border: 0px; font-size: 12px; background: #3DB4C0;" class="input-group-addon" id="sizing-addon2"><i class="fa fa-pencil" aria-hidden="true"></i></span>
                                <input id="tituloI" name="tituloI" maxlength="20" style="border:2px solid #3DB4C0; font-weight: 600; font-size: 20px;" type="text" class="form-control" placeholder="{"Añadir un titulo aqui"|x_translate}" aria-describedby="sizing-addon2">
                            </div>
                            <div style="display: flex; width: 400px; margin-top: 15px; margin-bottom: 15px; margin-left: 35px;" class="input-group">
                                <input id="subtituloI" name="subtituloI" maxlength="40" style="border-radius: 6px; background: #f1f1f1; border:2px solid #f1f1f1; color: #343232;" type="text" class="form-control" placeholder="{"Texto suplementario aqui"|x_translate}" aria-describedby="sizing-addon2">
                            </div>

                            <img style="width: 170px; margin-left: 140px;" class="qr-code"  src="{$url}xframework/files/temp/qr_invitacion/{$empresa["idempresa"]}.png" />

                        </div>

                    </div>

                    <div class="text-center">
                        <a id="btnInputsFlyersI"   style="width: 280px;  margin-bottom: 10px; margin-top: 10px;"   class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta "  >{"Personalizar"|x_translate}</a>
                        <a style="width: 280px; margin-top: 10px; display: none; margin-bottom: 10px;"  name="btngenerarFlyersI" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta  "  id="btngenerarFlyersI" href="{$url}empresa.php?action=1&modulo=home&submodulo=invitacion_pass_flayer"    target="_blank" ><i style="margin-left: 10px;" class="fa fa-print"></i>{"Generar Flyer"|x_translate}</a>


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

        $("#btnInputsFlyersI").click(function (e) {
            var bandera = 0;
            idEmpresa = $("#idEmpresa").val();
            titulo = $("#tituloI").val();
            subtitulo = $("#subtituloI").val();

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "empresa.php?action=1&modulo=home&submodulo=cargar_inputs_flyer",
                    'idempresa=' + idEmpresa + "&titulo_flyer=" + titulo + "&subtitulo_flyer=" + subtitulo,
                    function (data) {

                        if (data.result) {
                            $("#btngenerarFlyersI").css("display", "block");

                        } else {
                            x_alert(data.msg);
                        }
                    }
            );

        });

    });
</script>