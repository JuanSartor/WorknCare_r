<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(2/9){else}(2/10){/if}</h6>
    <div class="col-md-4 col-md-offset-4  col-xs-12"  style="margin-top:20px">
        <form class="edit patient-data" id="masa_corporal_form" action="{$url}save_masa_corporal_form.do" method="post" onsubmit="return false;">
            <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
            <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
            <input type="hidden" name="from_altura" value="1" />
            <input type="hidden" name="from_wizard" value="1" />

            
            <div class="col-md-8 col-xs-12">
            <div class="form-group ">

                <label for="size">{"¿Cuál es su altura? (cms)"|x_translate}</label>
                
            </div>
            </div>
            
             <div class="col-md-4 col-xs-12 form-group ">
               <span id="size">
                    <input  id="altura" name="altura" value="{$masa_corporal.altura}" type="number" class="form-control"> 
                </span>
            </div>

        </form>
        <div class="clearfix">&nbsp;</div>
        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="1" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>

            <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="2" data-next="3" >{"siguiente"|x_translate}</a>

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
            var next = $(this).data('next');
            if ($("#altura").val() != "") {
                $("body").spin("large");
                x_sendForm($('#masa_corporal_form'), true, function (data) {

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
    })

</script>
{/literal}