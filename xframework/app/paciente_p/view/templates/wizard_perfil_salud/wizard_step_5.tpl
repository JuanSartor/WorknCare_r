<div class="okm-row ">
    <h6 class="text-center">{if $paciente.sexo==1}(5/9){else}(5/10){/if}</h6>
    <div class="col-md-6 col-md-offset-3"  style="margin-top:20px">

        <form class="form patient-file relative" id="antecedentes_form_2" action="{$url}save_enfermedades_actuales.do" role="form" method="post" onsubmit="return false;">
            <input type="hidden" name="idenfermedadesActuales" id="idenfermedadesActuales" value="{$enfermedad_actual.idenfermedadesActuales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" id="ninguna_patologia" name="ninguna_patologia"   value="" />
            <input type="hidden" name="from_wizard" value="1" />

            <div class="row">
                <div class="col-md-7 col-md-offset-3">
                    <div class="item-wrapper">
                        <span class="question small">{"Tiene alguna patología?"|x_translate}</span>
                        <label class="radio pull-right" for="patologias_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="patologias_no" name="patologias"  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                        <label class="radio pull-right" for="patologias_si" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="patologias_si" name="patologias" class="custom-radio">
                            {"Si"|x_translate}
                        </label>

                    </div>
                </div>
            </div>
            <div id="div_enfermedades_patologias" class="data-form health-profile" style="display:none;">
                <div  class="patient-file">


                    <div class="clearfix">&nbsp;</div>
                    <div >

                        <div class="pps-form-row ">
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
                                    <label class="radio">
                                        <input type="radio" id="otitis-oder" name="otitis" value="0"  data-toggle="radio" class="custom-checkbox">
                                        <span class="label">{"Oído der."|x_translate}</span>
                                    </label>
                                </div>
                                <div class="pps-form-options-item">
                                    <label class="radio">
                                        <input type="radio" id="otitis-oizq" name="otitis" value="2"  data-toggle="radio" class="custom-checkbox">
                                        <span class="label">{"Oído izq."|x_translate}</span>
                                    </label>
                                </div>
                                <div class="pps-form-options-item">
                                    <label class="radio">
                                        <input type="radio" id="otitis-ambos" name="otitis" value="1"  data-toggle="radio" class="custom-checkbox">
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
                                <input type="checkbox" id="infeccion-urinaria" name="infecciones_urinarias" value="1"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                        </div>
                    </div>

                    <div class="pps-form-row">
                        <div class="pps-form-col-x6">
                            <label class="pps-form-col-x6-label">{"Psicológicas"|x_translate}</label>
                        </div>
                        <div class="pps-form-col-x6">
                            <label class="checkbox">
                                <input type="checkbox" id="psicologicas" name="psicologicas" value="1"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                        </div>
                    </div>

                    <div class="pps-form-row">
                        <div class="pps-form-col-x6">
                            <label class="pps-form-col-x6-label">{"DBT - Diabetes"|x_translate}</label>
                        </div>
                        <div class="pps-form-col-x6">
                            <label class="checkbox">
                                <input type="checkbox" id="dbt" name="dbt" value="1" data-toggle="checkbox" class="custom-checkbox">
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <div class="clearfix">&nbsp;</div>
        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="4" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
            <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="5" data-next="6">{"siguiente"|x_translate}</a>

        </div>

        <div class="okm-row text-center" style="margin-top:40px">
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que NO, confirma que no tiene ningún tipo de patología, que sean patologías respiratorias, neurológicas, psiquiátricas, endocrinas, de peso y alimentación, reumáticas & inflamatórias crónicas, diabetes, oftalmología, dermatológicas, digestivas, urológicas, oncológicas o cardiológicas... entre otras."|x_translate}</small></em></p>
        </div>

    </div>
</div>
{literal}
    <script>
        x_runJS();
        $(function () {
            $("body").spin(false);

            scrollToEl($("#wizard_perfil_salud"));
            renderUI2("wizard_perfil_salud");
            $('#patologias_si').on('change.radiocheck', function () {
                $("#div_enfermedades_patologias").show();

            });

            if ($("#idenfermedadesActuales") != "") {
                if ($("#patologias_tag_input").tagsinput('items').length == 0) {
                    $("#patologias_no").prop("checked", true);
                } else {
                    $("#patologias_si").prop("checked", true);
                    $("#div_enfermedades_patologias").show();
                }
            }

            $('#patologias_no').on('change.radiocheck', function () {
                $("#div_enfermedades_patologias").hide();
            });

            $(".btn-siguiente").click(function () {
                if ($('#patologias_no').is(":checked") || $('#patologias_si').is(":checked")) {
                    if ($('#patologias_si').is(":checked") && $("#patologias_tag_input").tagsinput('items').length == 0) {
                        x_alert(x_translate("Complete los campos obligatorios"));
                        return false;
                    }
                    if ($('#patologias_si').is(":checked")) {
                        $("#ninguna_patologia").val("");
                    }
                    if ($('#patologias_no').is(":checked")) {
                        $("#ninguna_patologia").val(1);
                    }
                    $("body").spin("large");
                    var next = $(this).data('next');
                    x_sendForm($('#antecedentes_form_2'),
                            true,
                            function (data) {

                                if (data.result) {
                                    x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
                                } else {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                }
                            }
                    );

                } else {
                    x_alert(x_translate("Complete los campos obligatorios"));
                    return false;
                }

            })

            $(".btn-volver").click(function () {
                $("body").spin("large");
                x_loadModule('wizard_perfil_salud', 'wizard_step_' + $(this).data('prev'), '', 'div_wizzard_step');
            })

            $("#idenfermedad").change(function () {
                updateComboBoxSelect2("#idenfermedad", 'idtipoEnfermedad', 'ManagerTipoEnfermedad', 'getCombo', 0, x_translate('Patología'), doUpdateComboBoxSelect2);
            });

            $("#otro_tipo_enfermedad").keypress(function () {
                if ($("#otro_tipo_enfermedad").val() != "") {
                    $("#idenfermedad").val(14);
                    $("#idtipoEnfermedad").val("");
                    renderUI2("div_enfermedades_patologias");
                }
            });
            $("#btnAgregarPatologia").click(function () {

                //otro tipo de enfermedades
                if ($("#otro_tipo_enfermedad").val() != "") {
                    $("#antecedentes_form_2").spin("large");


                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'add_enfermedades_actuales.do',
                            'otro_tipo_enfermedad=' + $("#otro_tipo_enfermedad").val() + '&idenfermedad=' + $("#idenfermedad").val() + "&enfermedad=1",
                            function (data) {
                                $("#antecedentes_form_2").spin(false);

                                if (data.result) {

                                    $('#patologias_tag_input').tagsinput('add', {"value": data.id, "text": $("#otro_tipo_enfermedad").val()});
                                    $("#ninguna_patologia").val("");
                                    $("#idenfermedad").val("");
                                    $("#otro_tipo_enfermedad").val("");
                                    renderUI2("div_enfermedades_patologias");
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                } else {
                    //enfermedades seleccionadas combo
                    if ($("#idenfermedad").val() != "" && $("#idenfermedad").val() != 14 && $("#idtipoEnfermedad").val() != "") {
                        $("#antecedentes_form_2").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'add_enfermedades_actuales.do',
                                'idtipoEnfermedad=' + $("#idtipoEnfermedad").val(),
                                function (data) {
                                    $("#antecedentes_form_2").spin(false);

                                    if (data.result) {

                                        $('#patologias_tag_input').tagsinput('add', {"value": data.id, "text": data.tipoEnfermedad});
                                        $("#ninguna_patologia").prop('checked', false);
                                        $("#idtipoEnfermedad").val("");
                                        $("#idenfermedad").val("");
                                        $("#otro_tipo_enfermedad").val("");
                                        renderUI2("div_enfermedades_patologias");
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                }
            });

        })

    </script>
{/literal}