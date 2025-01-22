{if $paciente}

{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}

<section class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                    <li><a  class="nombre_paciente"  href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                    <li class="active">{"Alergias e intolerancias"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}

<section class="data-form health-profile">
    {*<h1 class="section-header text-center icon-svg circle allergy">{"Alergias e intolerancias"|x_translate}</h1>*}
    <div class="container">
        <form class="form patient-file" role="form"  id="alergias_form" action="{$url}save_perfil_alergias_m.do" method="post"  onsubmit="return false;">
            <input type="hidden" name="idperfilSaludAlergia" value="{$record.idperfilSaludAlergia}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <div class="col-md-11 col-center">
                <ul>
                    <li>
                        <div class="item-wrapper">
                            <span class="question">1. {"¿Tiene alergias o intolerancias?"|x_translate}</span>
                            <label class="checkbox" for="posee_intolerancia_si" style="display:inline">
                                <input type="checkbox" data-toggle="checkbox" value="1" id="posee_intolerancia_si" name="posee_intolerancia" {if $record.posee_intolerancia == "1"}checked="checked" {/if} class="custom-checkbox">
                                       {"Si"|x_translate}
                            </label>
                            <label class="checkbox" for="posee_intolerancia_no" style="display:inline">
                                <input type="checkbox" data-toggle="checkbox" value="0" id="posee_intolerancia_no" name="posee_intolerancia" {if $record.posee_intolerancia == "0"}checked="checked" {/if} class="custom-checkbox">
                                       {"No"|x_translate}
                            </label>
                        </div>
                        <div class="row" id="div_row_listado_alergias" {if $record.posee_intolerancia == 0}style="display:none"{/if}>

                             {foreach from=$listado_alergias item=alergia}
                             <div class="col-md-4 tipo-alergia">
                                <h2 class="section-header group-list">{$alergia.tipoAlergia}</h2>

                                {foreach from=$alergia.array_subtipoAlergia item=subTipoAlergia}
                                <label class="checkbox" >
                                    {if $subTipoAlergia.subTipoAlergia != "Otros"}
                                    <input type="checkbox"   id="sub-tipo-alergia-{$subTipoAlergia.idsubTipoAlergia}" value="1" name="check_sta[{$subTipoAlergia.idsubTipoAlergia}]" data-toggle="checkbox" class="custom-checkbox" {if $subTipoAlergia.is_checked == 1} checked {/if}>{$subTipoAlergia.subTipoAlergia}
                                           {else}
                                           <input type="checkbox" data-action="clean-val" data-target="otra-alergia-{$subTipoAlergia.idsubTipoAlergia}"  id="sub-tipo-alergia-{$subTipoAlergia.idsubTipoAlergia}" value="1" name="check_sta[{$subTipoAlergia.idsubTipoAlergia}]" data-toggle="checkbox" class="custom-checkbox" {if $subTipoAlergia.is_checked == 1} checked {/if}>{$subTipoAlergia.subTipoAlergia}

                                           <input type="text"   data-action="check-si" data-target="sub-tipo-alergia-{$subTipoAlergia.idsubTipoAlergia}" id="otra-alergia-{$subTipoAlergia.idsubTipoAlergia}" name="check_sta_otros[{$subTipoAlergia.idsubTipoAlergia}]" value="{$subTipoAlergia.texto}"  placeholder='{"Otros"|x_translate}'>
                                    {/if}
                                </label>
                                {/foreach}

                            </div>
                            {/foreach}
                        </div>
                    </li>
                    <li>
                        <div class="item-wrapper" >
                            <div id="div_anafilaxia"  {if $record.posee_intolerancia == 0}style="display:none"{/if}>

                                 <label class="checkbox" for="anafilaxia">
                                    <h2 class="section-header group-list ib no-margin">{"Anafilaxia"|x_translate}&nbsp;</h2>
                                    <input type="checkbox" id="anafilaxia" data-toggle="checkbox" value="1" {if $record.posee_anafilaxia == 1} checked {/if} name="posee_anafilaxia" class="custom-checkbox">&nbsp;
                                           <span class="icon-info" data-toggle="tooltip" title="{"La anafilaxia es una reacción alérgica grave en todo el cuerpo a un químico que se ha convertido en alergeno."|x_translate}"></span>
                                </label>

                            </div>
                            <br>
                            <div id="div_causa_intolerancia" {if $record.posee_intolerancia != "1"}style="display:none;"{/if}>
                            <span class="question">2. {"¿Sabe que agente produce su alergia o intolerancia?"|x_translate}</span>

                            <label class="checkbox" for="posee_causa_intolerancia_si" style="display:inline">
                                <input type="checkbox" data-toggle="checkbox" value="1" id="posee_causa_intolerancia_si" name="posee_causa_intolerancia" {if $record.posee_causa_intolerancia == "1"}checked="checked" {/if}>
                                       {"Si"|x_translate}
                            </label>
                            <label class="checkbox" for="posee_causa_intolerancia_no" style="display:inline">
                                <input type="checkbox" data-toggle="checkbox" value="0" id="posee_causa_intolerancia_no" name="posee_causa_intolerancia" {if $record.posee_causa_intolerancia == "0"}checked="checked" {/if}>
                                       {"No"|x_translate}
                            </label>
                            </div>
                        </div>
                      
                        <div id="div_causas_intolerancias" {if  $record.posee_causa_intolerancia == 0 || $record.posee_intolerancia != "1"} style="display:none"{/if}>
                             <label class="checkbox">
                                <input type="checkbox" value="1" id="check_intolerancia_alimentos" name="check_intolerancia_alimentos" {if $record.intolerancia_alimentos != ""}checked {/if} data-toggle="checkbox" data-action="clean-val" data-target="intolerancia_alimentos" class="custom-checkbox">
                                       <input type="text" class="md" data-action="check-si" data-target="check_intolerancia_alimentos" placeholder='{"Alimentos"|x_translate}' id="intolerancia_alimentos"  name="intolerancia_alimentos" value="{$record.intolerancia_alimentos}">
                            </label>
                            <label class="checkbox">
                                <input type="checkbox" value="1" id="check_intolerancia_medicamentos" data-toggle="checkbox" {if $record.intolerancia_medicamentos != ""}checked {/if} name="check_intolerancia_medicamentos" class="custom-checkbox" data-action="clean-val" data-target="intolerancia_medicamentos">
                                       <input type="text" class="md" data-action="check-si" data-target="check_intolerancia_medicamentos" placeholder='{"Fármacos o medicamentos"|x_translate}' id="intolerancia_medicamentos" name="intolerancia_medicamentos" value="{$record.intolerancia_medicamentos}">
                            </label>
                            <label class="checkbox">
                                <input type="checkbox" value="1" id="check_intolerancia_insecto" data-toggle="checkbox" {if $record.intolerancia_insecto != ""}checked {/if} name="check_intolerancia_insecto" class="custom-checkbox" data-action="clean-val" data-target="intolerancia_insecto">
                                       <input type="text" class="md" data-action="check-si" data-target="check_intolerancia_insecto" id="intolerancia_insecto" name="intolerancia_insecto" placeholder='{"Veneno o picadura de algún insecto"|x_translate}' value="{$record.intolerancia_insecto}">
                            </label>
                            <label class="checkbox">
                                <input type="checkbox" value="1" id="check_intolerancia_otros" name="check_intolerancia_otros" {if $record.intolerancia_otros != ""}checked {/if} data-toggle="checkbox" class="custom-checkbox" data-action="clean-val" data-target="intolerancia_otros">
                                       <input type="text" class="md" data-action="check-si" data-target="check_intolerancia_otros" id="intolerancia_otros" name="intolerancia_otros" placeholder='{"Otros (plástico, latex, etc)"|x_translate}' value="{$record.intolerancia_otros}">
                            </label>
                        </div>
                    </li>
                </ul>
                <button type="submit" id="save" class="submit">{"grabar datos"|x_translate}</button>
            </div>
        </form>
    </div>
</section>


{x_load_js}
{/if}