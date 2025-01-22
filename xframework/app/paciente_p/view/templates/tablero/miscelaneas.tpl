<article class="col-md-6">
    <div class="pressure card">
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Grupo Sanguíneo"|x_translate}</h1>
                </div>	
            </div>
            <div class="col-md-6  col-xs-6">
                <ul class="list-details">
                    <li><div class="value top-value">{if $perfil_salud_biometrico.nombre != ""}{$perfil_salud_biometrico.nombre}{else}___{/if}</div></li>
                    <li>
                        <div class="item">{"Color de ojos"|x_translate}</div>
                        <div class="value">{if $perfil_salud_biometrico.colorOjos != ""}{$perfil_salud_biometrico.colorOjos}{else}___{/if}</div>
                    </li>
                    <li>
                        <div class="item">{"Color de piel"|x_translate}</div>
                        <div class="value">{if $perfil_salud_biometrico.colorPiel != ""}{$perfil_salud_biometrico.colorPiel}{else}___{/if}</div>
                    </li>
                    <li>
                        <div class="item">{"Color de pelo"|x_translate}</div>
                        <div class="value">{if $perfil_salud_biometrico.colorPelo != ""}{$perfil_salud_biometrico.colorPelo}{else}___{/if}</div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="bottom-data">
            <button class="edit dp-edit" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Misceláneas"|x_translate}</h1>
                    <form class="edit patient-data" id="miscelaneas_form" action="{$url}save_miscelaneas_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" id="idpaciente_miscelaneas" value="{$idpaciente}" />
                        <input type="hidden" name="idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                        <div class="form-group underline">
                            <label for="blood-type">{"Grupo Sanguíneo"|x_translate}</label>
                            <select class="form-control select select-primary select-block mbl pull-right" name="grupofactorsanguineo_idgrupoFactorSanguineo" id="grupofactorsanguineo_idgrupoFactorSanguineo">
                                  <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_fs selected=$perfil_salud_biometrico.grupofactorsanguineo_idgrupoFactorSanguineo}
                            </select>
                        </div>
                        <div class="form-group underline">
                            <label for="eye-color">{"Color de Ojos"|x_translate}</label>
                            <select class="form-control select select-primary select-block mbl pull-right" name="colorOjos_idcolorOjos" id="colorOjos_idcolorOjos">
                                  <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_ojos selected=$perfil_salud_biometrico.colorOjos_idcolorOjos}
                            </select>
                        </div>
                        <div class="form-group underline">
                            <label for="skin-color">{"Color de Piel"|x_translate}</label>
                            <select class="form-control select select-primary select-block mbl pull-right" name="colorPiel_idcolorPiel" id="colorPiel_idcolorPiel">
                                 <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_piel selected=$perfil_salud_biometrico.colorPiel_idcolorPiel}
                            </select>
                        </div>
                        <div class="form-group underline">
                            <label for="hair-color">{"Color de Pelo"|x_translate}</label>
                            <select class="form-control select select-primary select-block mbl pull-right" name="colorPelo_idcolorPelo" id="colorPelo_idcolorPelo">
                                 <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_pelo selected=$perfil_salud_biometrico.colorPelo_idcolorPelo}
                            </select>
                        </div>
                        <input type="submit" onclick ="submitFormMiscelaneas();" value='{"guardar"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}
<script>
    x_runJS();

    function submitFormMiscelaneas() {

        x_sendForm($('#miscelaneas_form'), true, function(data) {
            x_alert(data.msg);
            if (data.result) {
                $(".modal.fade.in:visible").modal('toggle')
                x_loadModule('tablero', 'miscelaneas', 'idpaciente=' + $("#idpaciente_miscelaneas").val(), "div_miscelaneas", BASE_PATH + "paciente_p");
            }
        });
    }


    $(document).ready(function() {

        $('#div_miscelaneas button').on('click', function(event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });
    });
</script>
{/literal}