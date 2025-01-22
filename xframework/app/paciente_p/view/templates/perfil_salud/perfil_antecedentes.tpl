{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
<input type="hidden" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Antecedentes"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}
<section class="data-form health-profile ajustes-panel-paciente">
    <h1 class="section-header text-center icon-svg circle dna">{"Antecedentes"|x_translate}</h1>
    <div class="container">
        {if $paciente.edad_anio<18}
            <div class="row">
                <div class="col-md-6">
                    <h2 class="section-header form-header text-center">{"Perinatales"|x_translate}</h2>
                    <form class="form patient-file light-grey" role="form"  id="antecedentes_form_1" action="{$url}save_perfil_antecedentes.do" method="post"  onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente"  value="{$paciente.idpaciente}" />
                        <input type="hidden" name="idperfilSaludAntecedentes" id="idperfilSaludAntecedentes" value="{$record.idperfilSaludAntecedentes}" />
                        <input type="hidden" name="from_perinatales"  value="1" />


                        <div class="form-group">
                            <span class="question small">{"Gesta"|x_translate}</span>
                            <input type="number"  class="flat-input small" id="gesta" name="gesta" value="{$record.gesta}">

                            <label class="checkbox ib">
                                <input type="radio"  id="is_parto" value="1" name="is_parto" {if $record.is_parto == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                {"Parto"|x_translate}
                            </label>
                            <label class="checkbox ib">
                                <input type="radio"  id="is_cesarea" value="1" name="is_cesarea" {if $record.is_cesarea == 1}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                {"Cesárea"|x_translate}
                            </label>

                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <span class="question small">{"Peso"|x_translate}</span>
                                    <input type="number" class="flat-input small" id="peso" {if $paciente.edad_anio<18} required{/if} name="peso" value="{$record.peso}">{"grs"|x_translate}
                                </div>
                                <div class="form-group">
                                    <span class="question small">{"Talla"|x_translate}</span>
                                    <input type="number" class="flat-input small" id="talla" {if $paciente.edad_anio<18} required{/if} name="talla" value="{$record.talla}">{"cm"|x_translate}
                                </div>
                                <div class="form-group">
                                    <span class="question small">{"Per. Cef."|x_translate}</span>
                                    <input type="number" class="flat-input small" id="per_cef" {if $paciente.edad_anio<18} required{/if} name="per_cef" value="{$record.per_cef}">{"cm"|x_translate}
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <span class="question small">{"Apgar 1'"|x_translate}</span>
                                    <input type="number" class="flat-input small" id="apgar-1" name="apgar_1" value="{$record.apgar_1}">
                                </div>
                                <div class="form-group">
                                    <span class="question small">{"Apgar 5'"|x_translate}</span>
                                    <input type="number" class="flat-input small" id="apgar-5" name="apgar_5" value="{$record.apgar_5}">
                                </div>
                                <div class="form-group">
                                    <span class="question small">{"Ed. Gest."|x_translate}</span>
                                    <input type="number" class="flat-input small" id="ed-gest" name="ed_gest" value="{$record.ed_gest}">
                                </div>
                            </div>
                        </div>
                        <button type="submit" id="btn_antecedentes_1" class="submit">{"grabar datos"|x_translate}</button>
                    </form>
                </div>
                <div class="col-md-6">
                    <h2 class="section-header form-header text-center">{"Familiares"|x_translate}</h2>
                    <form class="form patient-file" role="form"  id="antecedentes_form_2" action="{$url}save_perfil_antecedentes.do" method="post"  onsubmit="return false;">
                        <input type="hidden" name="idperfilSaludAntecedentes" value="{$record.idperfilSaludAntecedentes}" />
                        <input type="hidden" name="paciente_idpaciente"  value="{$paciente.idpaciente}" />

                        <h1 class="text-center no-margin">{"Grupo Sanguíneo"|x_translate}</h1>
                        <br>
                        <br>
                        <div class="form-group text-center">
                            <span class="question small">{"Padre"|x_translate}</span>
                            <select name="grupofactorsanguineo_idgrupoFactorSanguineo_padre" id="grupofactorsanguineo_idgrupoFactorSanguineo_padre" class="form-control select select-primary select-block mbl medium ib">
                                <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_grupo_sanguineo selected=$record.grupofactorsanguineo_idgrupoFactorSanguineo_padre}
                            </select>
                        </div>
                        <div class="form-group text-center">
                            <span class="question small">{"Madre"|x_translate}</span>
                            <select name="grupofactorsanguineo_idgrupoFactorSanguineo_madre" id="grupofactorsanguineo_idgrupoFactorSanguineo_madre" class="form-control select select-primary select-block mbl medium ib">
                                <option value="">{"Seleccione"|x_translate}</option>
                                {html_options options=$combo_grupo_sanguineo selected=$record.grupofactorsanguineo_idgrupoFactorSanguineo_madre}
                            </select>
                        </div>
                        <br>
                        <br>
                        <br>
                        <button type="submit" id="btn_antecedentes_2" class="submit">{"grabar datos"|x_translate}</button>
                    </form>
                </div>
            </div>
        {/if}

        <h2 class="section-header form-header text-center">{"Patologías familiares"|x_translate}</h2>
        <form class="form patient-file" id="form_patologia_familiar" role="form" method="post" action="{$url}add_patologia_familiar.do" method="post"  onsubmit="return false;">
            <input type="hidden" id="idperfilSaludAntecedentes" name="idperfilSaludAntecedentes" value="{$record.idperfilSaludAntecedentes}"/>
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="tipoFamiliar_idtipoFamiliar" id="tipoFamiliar_idtipoFamiliar"  value="" />
            <input type="hidden" name="tipoPatologia_idtipoPatologia" id="tipoPatologia_idtipoPatologia" value="" />



            <div class="row user-select">
                <div class="col-md-4 col-md-offset-1">
                    <h1 class="box-header">{"Familiar"|x_translate}</h1>
                    <ul id="ul_tipo_familiar" class="select-box">
                        {foreach from=$list_tipo_familiar item=tipo_familiar}
                            <li data-id="{$tipo_familiar.idtipoFamiliar}">{$tipo_familiar.tipoFamiliar}</li>
                            {/foreach}                        
                    </ul>
                </div>

                <div class="col-md-4">
                    <h1 class="box-header">{"Patología"|x_translate}</h1>
                    <ul id="ul_tipo_patologia" class="select-box">
                        {foreach from=$list_tipo_patologia item=tipo_patologia}
                            <li data-id="{$tipo_patologia.idtipoPatologia}">{$tipo_patologia.tipoPatologia}</li>
                            {/foreach}
                    </ul>

                    <div class="select-otras">
                        <label class="checkbox ib">
                            <input type="checkbox" id="no_antecedentesfamiliares" value="1" name="no_antecedentesfamiliares" {if $record.posee_antecedentesfamiliares == "0"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                            {"Ninguna de las mencionadas"|x_translate} 
                        </label>

                    </div>
                </div>

                <div class="col-md-3">
                    <button class="add-items btn-inverse btn">{"agregar"|x_translate}</button>
                    <div class="tagsinput-primary">
                        {literal}
                            <script>
                                var func_delete = function (event) {

                                    var id = event.item.value;

                                    x_doAjaxCall(
                                            'POST',
                                            BASE_PATH + 'delete_patologia_familiar.do',
                                            'id=' + id,
                                            function (data) {
                                                x_alert(data.msg);
                                                if (data.result) {
                                                    $('#antecedentes_tag_input').tagsinput('remove', {id: id});
                                                }
                                            }
                                    );
                                };
                            </script>
                        {/literal}
                        {x_form_tagsinput  id="antecedentes" items=$perfiles_antecedentes delete="func_delete"}
                    </div>
                </div>
            </div>
        </form>
    </div>
</section>



{x_load_js}