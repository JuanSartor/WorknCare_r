<div class="okm-row">
    <h6 class="text-center">(10/10)</h6>
    <div class="col-md-6 col-md-offset-3"  style="margin-top:20px">

        <form class="edit patient-data" id="antecedentes_ginecologicos_form3" action="{$url}save_perfil_ginecologico.do" method="post" onsubmit="return false;">

      
                <input type="hidden" name="idperfilSaludGinecologico"  value="{$record.idperfilSaludGinecologico}"/>
                <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}"/>
                <input type="hidden" name="from_embarazo" value="1"/>

                <input type="hidden" name="from_wizard" value="1" />
                <div class="row">


                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Se encuentra embarazada actualmente?"|x_translate}</span>
                            <label class="radio pull-right" for="is_embarazada_no" style="display:inline">
                                <input type="radio" data-toggle="radio" value="0" id="is_embarazada_no" name="is_embarazada"  class="custom-radio">
                                {"No"|x_translate}
                            </label>
                            <label class="radio pull-right" for="is_embarazada_si" style="display:inline">
                                <input type="radio" data-toggle="radio" value="1" id="is_embarazada_si" name="is_embarazada" class="custom-radio">
                                {"Si"|x_translate}
                            </label>

                        </div>
                    </div>
                </div>
               
            </form>
            <div class="clearfix">&nbsp;</div>

            <div class="mapc-registro-form-row center">
                <a href="javascript:;" data-prev="9" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
                <a href="javascript:;" class="btn btn-blue btn-finalizar" >{"finalizar"|x_translate}</a>
            </div>

            <div class="okm-row text-center" style="margin-top:40px">
                <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
                <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que No, confirma que no está embarazada"|x_translate}</small></em></p>
            </div>

    </div>
</div>
{literal}
<script>

    $(function () {
        $("body").spin(false);
        scrollToEl($("#wizard_perfil_salud"));
        renderUI2("wizard_perfil_salud");
        

        

        $(".btn-finalizar").click(function () {
            if ($("#is_embarazada_si").is(":checked") || $("#is_embarazada_no").is(":checked")) {
               
                x_sendForm($('#antecedentes_ginecologicos_form3'), true, function (data) {

                    if (data.result) {

                        x_alert(x_translate("Ha completado su Perfil de Salud"), recargar(BASE_PATH + "panel-paciente/"));
                    } else {
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