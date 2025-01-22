{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}


<section class="module-header ajustes-panel-paciente">
    <figure>
        <i class="icon-doctorplus-termometro"></i>
    </figure>
    <h1 class="section-header">{"Enfermedades y patologías"|x_translate}</h1>
</section>


<section class="data-form health-profile">
    <div class="container">
        <form class="form patient-file relative" role="form" id="antecedentes_form_1" action="{$url}save_antecedentes_personales.do" method="post" onsubmit="return false;">
            <input type="hidden" name="idantecedentesPersonales" id="idantecedentesPersonales" value="{$antecedente.idantecedentesPersonales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <div class="col-md-11 col-center">
                <h2 class="pps-subtitle">{"Antecedentes personales"|x_translate}</h2>
                <div class="pps-form-row">

                    <label class="pps-label">{"Varicela"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="varicela-no" name="varicela" value="0" {if $antecedente.varicela === "0"}checked{/if}  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="varicela-nose" name="varicela" value="2" {if $antecedente.varicela == 2}checked{/if}  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="varicela-si" name="varicela" value="1" {if $antecedente.varicela == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="varicela-edad" name="edad_varicela" value="{$antecedente.edad_varicela}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Rubéola"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  id="rubiola-no" name="rubiola" value="0" {if $antecedente.rubiola === "0"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  id="rubiola-nose" name="rubiola" value="2" {if $antecedente.rubiola == 2}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  id="rubiola-si"  name="rubiola"  value="1" {if $antecedente.rubiola == 1}checked{/if}  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small"  value="{$antecedente.edad_rubiola}" name="edad_rubiola" id="rubiola-edad" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Sarampión"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="sarampion-no" name="sarampion" value="0" {if $antecedente.sarampion === "0"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="sarampion-nose" name="sarampion" value="2" {if $antecedente.sarampion == 2}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="sarampion" value="1" {if $antecedente.sarampion == 1}checked{/if} id="sarampion-si" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="sarampion-edad" name="edad_sarampion" value="{$antecedente.edad_sarampion}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Escarlatina"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  name="escarlatina" value="0" {if $antecedente.escarlatina === "0"}checked{/if}   id="escarlatina-no" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  name="escarlatina" value="2" {if $antecedente.escarlatina == 2}checked{/if}   id="escarlatina-nose" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="escarlatina" value="1" {if $antecedente.escarlatina == 1}checked{/if}   id="escarlatina-si" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="escarlatina-edad" name="edad_escarlatina" value="{$antecedente.edad_escarlatina}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Eritema infeccioso o Quinta Enfermedad"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="eritema" value="0" {if $antecedente.eritema === "0"}checked{/if} id="eritema-no"  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"   name="eritema" value="2" {if $antecedente.eritema == 2}checked{/if} id="eritema-nose"  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"   name="eritema" value="1" {if $antecedente.eritema == 1}checked{/if} id="eritema-si" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="eritema-edad" name="edad_eritema" value="{$antecedente.edad_eritema}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Exantema súbito o Sexta Enfermedad"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  name="exatema" value="0" {if $antecedente.exatema === "0"}checked{/if}   id="exatema-no"  data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  name="exatema" value="2" {if $antecedente.exatema == 2}checked{/if}   id="exatema-nose" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox"  name="exatema" value="1" {if $antecedente.exatema == 1}checked{/if}   id="exatema-si"   data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="exatema-edad" name="edad_exatema" value="{$antecedente.edad_exatema}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Paperas"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="papera" value="0" {if $antecedente.papera === "0"}checked{/if} id="papera-no" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="papera" value="2" {if $antecedente.papera == 2}checked{/if} id="papera-nose" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" name="papera" value="1" {if $antecedente.papera == 1}checked{/if}   id="papera-si" data-toggle="checkbox" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="papera-edad" name="edad_papera" value="{$antecedente.edad_papera}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" id="btn_save_antecedentes" class="submit">{"grabar datos"|x_translate}</button>
            </div>
        </form>
    </div>
</section>


<section class="data-form health-profile">
    <div class="container">
        <form class="form patient-file relative" id="antecedentes_form_2" action="{$url}save_enfermedades_actuales.do" role="form" method="post" onsubmit="return false;">
            <input type="hidden" name="idenfermedadesActuales" id="idenfermedadesActuales" value="{$enfermedad_actual.idenfermedadesActuales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />

            <div class="col-md-11 col-center pps-col">
                <h2 class="pps-subtitle">{"Patologías"|x_translate}</h2>

                <div class="pps-form-row">
                    <div class="pps-form-col-x6">
                        <label class="pps-form-col-x6-label">{"Ninguna"|x_translate}</label>
                    </div>
                    <div class="pps-form-col-x6">
                        <label class="checkbox">
                            {if $perfiles_patologias|@count > 0}
                                <input type="checkbox" id="ninguna_patologia" name="ninguna_patologia" value="1" data-toggle="checkbox" class="custom-checkbox">
                            {else}
                                <input type="checkbox" id="ninguna_patologia" name="ninguna_patologia" value="1" checked data-toggle="checkbox" class="custom-checkbox">
                            {/if}
                        </label>
                    </div>
                </div>

                <div id="div_enfermedades_patologias">

                    <div class="pps-form-row">
                        <div class="pps-form-col-x6">
                            <div class="pps-form-col-x6-input right">
                                <select class="form-control select select-primary select-block mbl" id="idenfermedad" name="idenfermedad">
                                    <option value="">{"Tipo"|x_translate}</option>
                                    {html_options options=$combo_enfermedad}
                                </select>
                            </div>
                        </div>
                        <div class="pps-form-col-x6">
                            <div class="pps-form-col-x6-input left">
                                <select class="form-control select select-primary select-block mbl" id="idtipoEnfermedad" name="idtipoEnfermedad">
                                    <option value="">{"Patología"|x_translate}</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="pps-form-row">
                        <div class="pps-form-col-x6">
                            <label class="pps-form-col-x6-label">{"Enfermedades virales o de otro tipo"|x_translate}</label>
                        </div>
                        <div class="pps-form-col-x6">
                            <div class="pps-form-col-x6-input left">
                                <input type="text" id="otro_tipo_enfermedad" >
                            </div>
                        </div>
                    </div>

                    <div class="pps-form-row">
                        <div class="pps-form-col-x6-offset-x6">
                            <div class="pps-form-col-x6-input left">
                                <button class="submit" id="btnAgregarPatologia">{"agregar"|x_translate} <i class="icon-doctorplus-plus"></i></button>
                            </div>
                        </div>
                    </div>

                    <div class="pps-form-row pps-tags-holder">
                        <div class="col-sm-12 ceprr-tags-cell pps-col">
                            <div class="tagsinput-primary ceprr-tags">

                                {literal}
                                    <script>
                                        var func_delete = function (event) {

                                            var id = event.item.value;

                                            x_doAjaxCall(
                                                    'POST',
                                                    BASE_PATH + 'delete_enfermedades_actuales.do',
                                                    'id=' + id,
                                                    function (data) {

                                                        if (data.result) {
                                                            $('#patologias_tag_input').tagsinput('remove', {id: id});
                                                        } else {
                                                            x_alert(data.msg);
                                                            $('#patologias_tag_input').tagsinput('add', {"value": "'" + event.item.value + "'", "text": event.item.text});
                                                        }
                                                    }
                                            );
                                        };
                                    </script>
                                {/literal}
                                {x_form_tagsinput class="tagsinput" id="patologias" items=$perfiles_patologias delete="func_delete"}
                            </div>
                        </div>
                    </div>

                </div>


                <div class="pps-form-row">
                    <div class="pps-divider"></div>
                </div>

                <div class="pps-form-row">
                    <div class="pps-form-col-x6">
                        <label class="pps-form-col-x6-label">{"Otitis"|x_translate}</label>
                    </div>
                    <div class="pps-form-col-x6">
                        <div class="pps-form-options pps-form-options-left-col">
                            <div class="pps-form-options-item">
                                <label class="checkbox">
                                    <input type="checkbox" id="otitis-oder" name="otitis" value="0" {if $enfermedad_actual.otitis === "0"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                    <span class="label">{"Oído der."|x_translate}</span>
                                </label>
                            </div>
                            <div class="pps-form-options-item">
                                <label class="checkbox">
                                    <input type="checkbox" id="otitis-oizq" name="otitis" value="2" {if $enfermedad_actual.otitis == 2}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                    <span class="label">{"Oído izq."|x_translate}</span>
                                </label>
                            </div>
                            <div class="pps-form-options-item">
                                <label class="checkbox">
                                    <input type="checkbox" id="otitis-ambos" name="otitis" value="1" {if $enfermedad_actual.otitis == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                    <span class="label">{"Ambos"|x_translate}</span>
                                </label>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">
                    <div class="pps-form-col-x6">
                        <label class="pps-form-col-x6-label">{"Infecciones urinarias"|x_translate}</label>
                    </div>
                    <div class="pps-form-col-x6">
                        <label class="checkbox">
                            <input type="checkbox" id="infeccion-urinaria" name="infecciones_urinarias" value="1" {if $enfermedad_actual.infecciones_urinarias == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                        </label>
                    </div>
                </div>

                <div class="pps-form-row">
                    <div class="pps-form-col-x6">
                        <label class="pps-form-col-x6-label">{"Psicológicas"|x_translate}</label>
                    </div>
                    <div class="pps-form-col-x6">
                        <label class="checkbox">
                            <input type="checkbox" id="psicologicas" name="psicologicas" value="1" {if $enfermedad_actual.psicologicas == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                        </label>
                    </div>
                </div>

                <div class="pps-form-row">
                    <div class="pps-form-col-x6">
                        <label class="pps-form-col-x6-label">{"DBT - Diabetes"|x_translate}</label>
                    </div>
                    <div class="pps-form-col-x6">
                        <label class="checkbox">
                            <input type="checkbox" id="dbt" name="dbt" value="1" {if $enfermedad_actual.dbt == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                        </label>
                    </div>
                </div>

                <button type="submit" id="btn_save_antecedentes2" class="submit">{"grabar datos"|x_translate}</button>
            </div>
        </form>
    </div>
</section>

<section class="data-form health-profile">
    <div class="container">
        <form class="form patient-file relative" id="antecedentes_form_3" action="{$url}save_patologias_actuales.do" role="form" method="post" onsubmit="return false;">
            <input type="hidden" name="idpatologiasActuales" id="idpatologiasActuales" value="{$patologias_actuales.idpatologiasActuales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />

            <div class="col-md-11 col-center pps-col">
                <div class="pps-form-row">

                    <label class="pps-label">{"Hepatitis A"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisA-si" name="hepatitisA" value="1"  data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisA == 1} checked {/if}>
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisA-no" name="hepatitisA" value="0" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisA === "0"} checked {/if}>
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisA-nose" name="hepatitisA" value="2"  data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisA == 2} checked {/if}>
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>

                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Hepatitis B"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisB-si" name="hepatitisB" value="1" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisB == 1} checked {/if}>
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisB-no" name="hepatitisB" value="0" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisB === "0"} checked {/if}>
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisB-nose" name="hepatitisB" value="2" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisB == 2} checked {/if}>
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>

                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"Hepatitis C"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisC-si" name="hepatitisC" value="1" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisC == 1} checked {/if}>
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisC-no" name="hepatitisC" value="0" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisC === "0"} checked {/if}>
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="hepatitisC-nose" name="hepatitisC" value="2" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.hepatitisC == 2} checked {/if}>
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>

                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"VPH"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="VPH-si" name="VPH" value="1" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.VPH == 1} checked {/if}>
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="VPH-no" name="VPH" value="0" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.VPH === "0"} checked {/if}>
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="VPH-nose" name="VPH" value="2" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.VPH == 2} checked {/if}>
                                <span class="label">{"Vacuna"|x_translate}</span>
                            </label>
                            <div class="pps-form-input-holder">
                                <input type="text" class="flat-input small" id="edad_vacuna_vph" name="edad_vacuna_vph" value="{$patologias_actuales.edad_vacuna_vph}" placeholder='{"¿A qué edad?"|x_translate}'>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pps-form-row">

                    <label class="pps-label">{"HIV"|x_translate}</label>

                    <div class="pps-form-options">
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="HIV-si" name="HIV" value="1" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.HIV == 1} checked {/if}>
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="HIV-no" name="HIV" value="0" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.HIV === "0"} checked {/if}>
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                        </div>
                        <div class="pps-form-options-item">
                            <label class="checkbox">
                                <input type="checkbox" id="HIV-nose" name="HIV" value="2" data-toggle="checkbox" class="custom-checkbox" {if $patologias_actuales.HIV == 2} checked {/if}>
                                <span class="label">{"No sé"|x_translate}</span>
                            </label>
                        </div>
                    </div>
                </div>

                <button type="submit" id="btn_save_antecedentes3" class="submit">{"grabar datos"|x_translate}</button>
            </div>
        </form>
    </div>
</section>	




{x_load_js}