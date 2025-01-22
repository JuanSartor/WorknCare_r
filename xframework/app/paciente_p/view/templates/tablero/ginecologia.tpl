{if $card}
<article class="col-md-6">
    <input type="hidden" id="idpaciente_ginecologia" value="{$paciente.idpaciente}" />

    <div class="card card-pink gineco">
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Gineco-Obstétricos"|x_translate}</h1>
                </div>	
            </div>
            <div class="col-md-6 col-xs-6">
                <div class="card-header">
                    <div class="card-value value icon-card" >
                        <span class="icon-svg ginecology"></span>
                    </div>											
                </div>		
                <div class="card-body">
                    <ul class="list-details">
                        <li>
                            <div class="item">{"Ultimo PAP"|x_translate}</div>
                            <div class="value">{if $record.pap_dp != ""}{$record.pap_dp}{else}--{/if}</div>
                        </li>
                        <li>
                            <div class="item">{"Ultima mamografía"|x_translate}</div>
                            <div class="value">{if $record.mam_dp != ""}{$record.mam_dp}{else}--{/if}</div>
                        </li>
                        <li class="value-pad">
                            <div class="item">{"Embarazo"|x_translate} </div>
                            <div class="value">{if $record.semanas_embarazo != ""}{$record.semanas_embarazo} sem{else}--{/if}</div>
                        </li>
                    </ul>
                </div>								
            </div>
        </div>
        <div class="bottom-data">
            <p class="last-modified"></p> 
         <button class="edit dp-edit" role="button" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden" id="div_gineco_form">

                <div class="edit-data patient">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                        <h1>{"Gineco-Obstétricos"|x_translate}</h1>
                        <form class="edit patient-data" id="ginecologicos_form" action="{$url}save_perfil_ginecologico_card.do" method="post" onsubmit="return false;">
                            <input type="hidden" name="idperfilSaludGinecologico" value="{$record.idperfilSaludGinecologico}"/>
                            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/>
                            <div class="form-group underline">
                                <label for="blood-type">{"Fecha ultimo Pap"|x_translate}</label>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="pap_mes">
                                    <option value="">{"Mes"|x_translate}</option>
                                    {html_options options=$combo_meses selected=$record.split_pap.mes}
                                </select>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="pap_anio">
                                    <option value="">{"Año"|x_translate}</option>
                                    {html_options options=$combo_anios selected=$record.split_pap.anio}
                                </select>												
                            </div>
                            <div class="form-group underline">
                                <label for="eye-color">{"Fecha ultima mamografia"|x_translate}</label>
                               
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="mam_mes">
                                    <option value="">{"Mes"|x_translate}</option>
                                    {html_options options=$combo_meses selected=$record.split_mam.mes}
                                </select>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="mam_anio">
                                    <option value="">{"Año"|x_translate}</option>
                                    {html_options options=$combo_anios selected=$record.split_mam.anio}
                                </select>	
                            </div>
                            <div class="form-group underline">
                                <label for="skin-color">{"¿Actualmente se encuentra embarazada?"|x_translate}</label>
                                <input type="checkbox" class="switch-checkbox pull-right" data-toggle="switch" data-on-text="Si" data-off-text="No" name="is_embarazada" {if $record.is_embarazada}checked {/if}/>
                            </div>
                            <div class="form-group underline">
                                <label for="hair-color">{"FUM"|x_translate}</label>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="fum_dia">
                                    <option value="">{"Dia"|x_translate}</option>
                                    {html_options options=$combo_dias selected=$record.split_fum.dia}
                                </select>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="fum_mes">
                                    <option value="">{"Mes"|x_translate}</option>
                                    {html_options options=$combo_meses selected=$record.split_fum.mes}
                                </select>
                                <select class="form-control select select-primary select-block mbl pull-right date-select" name="fum_anio">
                                    <option value="">{"Año"|x_translate}</option>
                                    {html_options options=$combo_anios selected=$record.split_fum.anio}
                                </select>	
                            </div>
                            <input type="submit" onClick="submitGinecologiaForm()" value='{"guardar"|x_translate}'>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}
<script>
    x_runJS();


    function submitGinecologiaForm() {

        x_sendForm($('#ginecologicos_form'), true, function (data) {
            x_alert(data.msg);
            if (data.result) {
                if (data.result) {
                        $(".modal.fade.in:visible").modal('toggle')
                    x_loadModule('tablero', 'ginecologia', 'idpaciente=' + $("#idpaciente_ginecologia").val(), "div_ginecologia", BASE_PATH + "paciente_p");
                }
            }
        });
    }

    $(document).ready(function () {
       
        $('#div_ginecologia button').on('click', function (event) {

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
{/if}