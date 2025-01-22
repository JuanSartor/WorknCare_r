<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(9/9){else}(9/10){/if}</h6>
    <div class="col-md-6 col-md-offset-3"  style="margin-top:20px">

        <form class="edit patient-data" id="medicamentos_form" action="{$url}save_medicamentos_paciente.do" method="post" onsubmit="return false;">
            <input type="hidden" name="idperfilSaludMedicamento" id="idperfilSaludMedicamento" value="{$record.idperfilSaludMedicamento}" />
            <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="from_wizard" value="1" />
            <div class="row">


                <div class="col-md-7 col-md-offset-3">
                    <div class="item-wrapper">
                        <span class="question small">{"Está tomando algún medicamento?"|x_translate}</span>
                        <label class="radio pull-right" for="medicamento_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="medicamento_no" name="medicamento"  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                        <label class="radio pull-right" for="medicamento_si" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="medicamento_si" name="medicamento" class="custom-radio">
                            {"Si"|x_translate}
                        </label>

                    </div>
                </div>
            </div>
            <div  id="div_medicamentos_msg" style="display:none;">
                <div class="row">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="col-md-8 col-xs-12">
                            <div class="form-group underline">
                                <label for="nombre_medicamento">{"Indique el medicamento"|x_translate}</label>
                            </div>
                        </div>
                        <div class="col-md-4 col-xs-12 form-group ">
                            <span class="" >
                                <input name="nombre_medicamento" id="nombre_medicamento"  class="form-control"> 
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row text-center" >
                    <p>{"Necesita agregar en su perfil de salud el medicamento que esta tomando."|x_translate}</p>
                </div>
            </div>

        </form>
        <div class="clearfix">&nbsp;</div>

        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="8" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
            {if $paciente.sexo==1}
                <a href="javascript:;" class="btn btn-blue btn-finalizar" >{"finalizar"|x_translate}</a>
            {else}
                <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="9" data-next="10" >{"siguiente"|x_translate}</a>
            {/if}
        </div>
        <div class="okm-row text-center" style="margin-top:40px">
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que No, confirma que no esta tomando ningún tipo de remedio o tratamiento."|x_translate}</small></em></p>
        </div>
    </div>
</div>
{literal}
    <script>

        $(function () {
            $("body").spin(false);
            scrollToEl($("#wizard_perfil_salud"));
            renderUI2("wizard_perfil_salud");
            $('#medicamento_si').on('change.radiocheck', function () {
                $("#div_medicamentos_msg").show();

            });

            $('#medicamento_no').on('change.radiocheck', function () {
                $("#div_medicamentos_msg").hide();
            });
            //paciente masculino
            $(".btn-finalizar").click(function () {
                if ($("#medicamento_si").is(":checked")) {
                    if ($("#nombre_medicamento").val() == "") {
                        x_alert(x_translate("Complete los campos obligatorios"));
                        return false;
                    }
                    x_sendForm($('#medicamentos_form'), true, function (data) {

                        if (data.result) {

                            x_alert(x_translate("Ha completado su Perfil de Salud"), recargar(BASE_PATH + "panel-paciente/"));
                        } else {
                            x_alert(data.msg);
                        }
                    });
                } else if ($("#medicamento_no").is(":checked")) {
                    window.location.href = BASE_PATH + "panel-paciente/";
                } else {
                    x_alert(x_translate("Complete los campos obligatorios"));
                    return false;
                }
            });

            //paciente femenino
            $(".btn-siguiente").click(function () {
                var next = $(this).data('next');
                if ($("#medicamento_si").is(":checked")) {
                    if ($("#nombre_medicamento").val() == "") {
                        x_alert(x_translate("Complete los campos obligatorios"));
                        return false;
                    }
                    x_sendForm($('#medicamentos_form'), true, function (data) {

                        if (data.result) {

                            x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
                        } else {
                            x_alert(data.msg);
                        }
                    });
                } else if ($("#medicamento_no").is(":checked")) {
                    x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
                } else {
                    x_alert(x_translate("Complete los campos obligatorios"));
                    return false;
                }
            });


            $(".btn-volver").click(function () {
                $("body").spin("large");
                x_loadModule('wizard_perfil_salud', 'wizard_step_' + $(this).data('prev'), '', 'div_wizzard_step');
            });
        });

    </script>
{/literal}