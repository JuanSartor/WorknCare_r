<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(3/9){else}(3/10){/if}</h6>
    <div class="col-md-6 col-md-offset-3"  style="margin-top:20px">

        <form class="edit patient-data" id="miscelaneas_form" action="{$url}save_miscelaneas_form.do" method="post" onsubmit="return false;">
            <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
            <input type="hidden" name="idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
            <input type="hidden" name="from_wizard" value="1" />
            <div class="form-group underline">
                <div class="col-md-7">
                    <label for="blood-type">{"¿Cuál es su grupo sanguíneo?"|x_translate}</label>
                </div>
                <div class="col-md-5">
                    <select class="form-control select select-primary select-block mbl pull-right" name="grupofactorsanguineo_idgrupoFactorSanguineo" id="grupofactorsanguineo_idgrupoFactorSanguineo">
                        <option value="">{"Seleccione"|x_translate}</option>
                        {html_options options=$combo_fs selected=$perfil_salud_biometrico.grupofactorsanguineo_idgrupoFactorSanguineo}
                    </select>
                </div>
            </div>
            <div class="form-group underline">
                <div class="col-md-7">

                    <label for="eye-color">{"¿Cuál es su color de ojos?"|x_translate}</label>
                </div>
                <div class="col-md-5">
                    <select class="form-control select select-primary select-block mbl pull-right" name="colorOjos_idcolorOjos" id="colorOjos_idcolorOjos">
                        <option value="">{"Seleccione"|x_translate}</option>
                        {html_options options=$combo_ojos selected=$perfil_salud_biometrico.colorOjos_idcolorOjos}
                    </select>
                </div>
            </div>
            <div class="form-group underline">
                <div class="col-md-7">
                    <label for="skin-color">{"¿Cuál es su color de piel?"|x_translate}</label>
                </div>
                <div class="col-md-5">
                    <select class="form-control select select-primary select-block mbl pull-right" name="colorPiel_idcolorPiel" id="colorPiel_idcolorPiel">
                        <option value="">{"Seleccione"|x_translate}</option>
                        {html_options options=$combo_piel selected=$perfil_salud_biometrico.colorPiel_idcolorPiel}
                    </select>
                </div>
            </div>
            <div class="form-group underline">
                <div class="col-md-7">
                    <label for="hair-color">{"¿Cuál es su color de pelo?"|x_translate}</label>
                </div>
                <div class="col-md-5">
                    <select class="form-control select select-primary select-block mbl pull-right" name="colorPelo_idcolorPelo" id="colorPelo_idcolorPelo">
                        <option value="">{"Seleccione"|x_translate}</option>
                        {html_options options=$combo_pelo selected=$perfil_salud_biometrico.colorPelo_idcolorPelo}
                    </select>
                </div>
            </div>

        </form>
        <div class="clearfix">&nbsp;</div>

        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="2" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
            <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="3"  data-next="4">{"siguiente"|x_translate}</a>

        </div>

    </div>
</div>
{literal}
<script>
    $("body").spin(false);
    scrollToEl($("#wizard_perfil_salud"));
    $(function () {
        renderUI2("wizard_perfil_salud");
        $(".btn-siguiente").click(function () {
            var completo = true;
            $("#miscelaneas_form select").each(function (i, e) {
                if ($(e).val() == "") {
                    completo = false;
                }
            })
            var next = $(this).data('next');
            if (completo) {
                $("body").spin("large");
                x_sendForm($('#miscelaneas_form'), true, function (data) {

                    if (data.result) {
                        x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
         
                    }else{
                          $("body").spin(false);
                         x_alert(data.msg);
                    }
                });
            } else {
                x_alert(x_translate("Complete los campos obligatorios"));
                return false;

            }
        })

        $(".btn-volver").click(function () {
            $("body").spin("large");
            x_loadModule('wizard_perfil_salud', 'wizard_step_' + $(this).data('prev'), '', 'div_wizzard_step');
        })
    })

</script>
{/literal}