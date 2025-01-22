<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(8/9){else}(8/10){/if}</h6>

    <form class="form patient-file" role="form"  id="alergias_form" action="{$url}save_perfil_alergias.do" method="post"  onsubmit="return false;">     
        <input type="hidden" name="idperfilSaludAlergia" value="{$record.idperfilSaludAlergia}" />
        <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
        <input type="hidden" name="from_wizard" value="1" />
        <div class="row">
            <div class="col-md-6 col-md-offset-3  "  style="margin-top:20px">


                <div class="col-md-7 col-md-offset-3">
                    <div class="item-wrapper">
                        <span class="question small">{"Tiene alguna alergia o intolerancia?"|x_translate}</span>
                        <label class="radio pull-right" for="posee_intolerancia_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="posee_intolerancia_no" name="posee_intolerancia" {if $record.posee_intolerancia == "0"}checked="checked" {/if}  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                        <label class="radio pull-right" for="posee_intolerancia_si" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="posee_intolerancia_si" name="posee_intolerancia" {if $record.posee_intolerancia == "1"}checked="checked" {/if} class="custom-radio">
                            {"Si"|x_translate}
                        </label>    
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-md-offset-3 data-form" >
            <div class="row data-form patient-file" id="div_alergia_intolerancia"  style="display:none;">

                <ul>
                    <li>

                        <div class="row" id="div_row_listado_alergias">

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
                            <div id="div_anafilaxia"  >



                                <label class="checkbox" for="anafilaxia">
                                    <h2 class="section-header group-list ib no-margin">{"Anafilaxia"|x_translate}&nbsp;</h2>
                                    <input type="checkbox" id="anafilaxia" data-toggle="checkbox" value="1" {if $record.posee_anafilaxia == "1"} checked {/if} name="posee_anafilaxia" class="custom-checkbox">&nbsp;
                                    <span class="icon-info" data-toggle="tooltip" title="{"La anafilaxia es una reacción alérgica grave en todo el cuerpo a un químico que se ha convertido en alergeno."|x_translate}"></span>
                                </label>

                            </div>
                            <br>
                            <div id="div_causa_intolerancia" >
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
                        <div id="div_causas_intolerancias" {if  $record.posee_causa_intolerancia == 0 || !$record} style="display:none"{/if}>                           <label class="checkbox">
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
            </div>

        </div>
    </form>
    <div class="clearfix">&nbsp;</div>

    <div class="mapc-registro-form-row center">
        <a href="javascript:;" data-prev="7" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
        <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="8" data-next="9" >{"siguiente"|x_translate}</a>

    </div>

    <div class="okm-row text-center" style="margin-top:40px">
        <div class="col-md-6 col-md-offset-3 " >
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que NO, confirma que no tiene ningún tipo de alergia o intolerancia, que sean intolerancias respiratorias, cutáneas, alimientarias o problema de anafilaxia entre otras."|x_translate}</small></em></p>
        </div>
    </div>
</div>

{literal}
    <script>

        $(function () {
            $("body").spin(false);
            scrollToEl($("#wizard_perfil_salud"));
            renderUI2("wizard_perfil_salud");

            $('[data-toggle="tooltip"]').tooltip();
            $('#posee_intolerancia_si').on('change.radiocheck', function () {
                $("#div_alergia_intolerancia").show();

            });

            $('#posee_intolerancia_no').on('change.radiocheck', function () {
                $("#div_alergia_intolerancia").hide();
            });

            if ($('#posee_intolerancia_no').is(":checked")) {
                $("#div_alergia_intolerancia").hide();
            }

            if ($('#posee_intolerancia_si').is(":checked")) {

                $("#div_alergia_intolerancia").show();
                $("#div_causa_intolerancia").show();

            }

            if ($("#posee_causa_intolerancia_si").is(':checked')) {
                $("#div_causas_intolerancias").show();

            }
            if ($("#posee_causa_intolerancia_no").is(':checked')) {
                $("#div_causas_intolerancias").hide();
            }

            $(".btn-siguiente").click(function () {

                if ($("#posee_intolerancia_si").is(":checked") || $("#posee_intolerancia_no").is(":checked")) {

                    //validamos que se haya ingresado al menos una opcion 
                    if ($("#posee_intolerancia_si").prop("checked") && $("#anafilaxia").prop("checked") == false && $("#div_row_listado_alergias :checkbox:checked").length == 0) {

                        x_alert(x_translate("Seleccione al menos una alergia o intolerancia"));
                        return false;
                    }
                    if ($("#posee_intolerancia_si").is(":checked") && !$("#posee_causa_intolerancia_si").prop("checked") && !$("#posee_causa_intolerancia_no").prop("checked")) {
                        x_alert(x_translate("Seleccione si conoce el agente que produce su alergia o intolerancia"));
                        return false;
                    }

                    if ($("#posee_causa_intolerancia_si").prop("checked") && $("#div_causas_intolerancias :checkbox:checked").length == 0) {
                        x_alert(x_translate("Ingrese al menos un agente que produce su alergia o intolerancia"));
                        return false;
                    }



                    $("body").spin("large");

                    var next = $(this).data('next');
                    x_sendForm($('#alergias_form'),
                            true,
                            function (data) {

                                if (data.result) {
                                    x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
                                } else {
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



            $('#posee_causa_intolerancia_si').on('change.radiocheck', function () {
                // Do something

                if ($("#posee_causa_intolerancia_si").is(':checked')) {
                    $("#div_causas_intolerancias").show();
                    $('#posee_causa_intolerancia_no').radiocheck('uncheck');
                } else {
                    $("#div_causas_intolerancias").hide();
                }
            });
            $('#posee_causa_intolerancia_no').on('change.radiocheck', function () {
                if ($("#posee_causa_intolerancia_no").is(':checked')) {
                    $("#div_causas_intolerancias :checkbox").radiocheck("uncheck");
                    $('#posee_causa_intolerancia_si').radiocheck('uncheck');

                }

                $("#div_causas_intolerancias :checkbox:checked").radiocheck('uncheck');
                $("#div_causas_intolerancias :input:text").val("");
            });

            //clickeamos los check de al empezar a escribir
            $("input[data-action='check-si']").on("keypress", function () {
                id = $(this).data('target');
                if ($(this).val() == "") {
                    $("#" + id).prop("checked", false);
                } else {
                    $("#" + id).prop("checked", true);
                }
            }
            );

            //limpiamos el texto de "otros" cuando se deshabilita el checkbox
            $(":checkbox[data-action='clean-val']").click(function () {

                if ($(this).prop("checked") == false) {
                    id = $(this).data("target");
                    $("#" + id).val("");
                }
            });
        })

    </script>
{/literal}