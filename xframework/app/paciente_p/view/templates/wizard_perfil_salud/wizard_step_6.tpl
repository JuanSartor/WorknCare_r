<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(6/9){else}(6/10){/if}</h6>
    <div class="col-md-6 col-md-offset-3 "  style="margin-top:20px">
        
        <form class="form patient-file relative" id="antecedentes_form_3" action="{$url}save_patologias_actuales.do" role="form" method="post" onsubmit="return false;">
            <input type="hidden" name="idpatologiasActuales" id="idpatologiasActuales" value="{$patologias_actuales.idpatologiasActuales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="from_wizard" value="1" />
            <div class="row">
                
                
                <div class="col-md-7 col-md-offset-3">
                    <div class="item-wrapper">
                        <span class="question small">{"Tiene alguna hepatitis o virus?"|x_translate}</span>
                        <label class="radio pull-right" for="hepatitis_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="hepatitis_no" name="hepatitis"  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                            
                        <label class="radio pull-right" for="hepatitis_si" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="hepatitis_si" name="hepatitis" class="custom-radio">
                            {"Si"|x_translate}
                        </label>
                            
                    </div>
                </div>
            </div>
            <div id="div_hepatitis">
                
                <div class="row antecedente active" {if $patologias_actuales.hepatitisA =="" } style="display:none;" {/if} id="div_hepatitisA">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Hepatitis A"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisA-no" name="hepatitisA" value="0" {if $patologias_actuales.hepatitisA == "0"} checked {/if} data-toggle="radio" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisA-si" name="hepatitisA" value="1"  {if $patologias_actuales.hepatitisA == "1"} checked {/if} data-toggle="radio" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                                
                        </div>
                            
                    </div>
                </div>
                    
                <div class="row antecedente " {if $patologias_actuales.hepatitisB =="" } style="display:none;" {/if} id="div_hepatitisB">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Hepatitis B"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisB-no" name="hepatitisB" value="0"  {if $patologias_actuales.hepatitisB == "0"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisB-si" name="hepatitisB" value="1"  {if $patologias_actuales.hepatitisB == "1"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                            
                    </div>
                </div>
                    
                <div class="row antecedente " {if $patologias_actuales.hepatitisC =="" } style="display:none;" {/if} id="div_hepatitisC">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Hepatitis C"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisC-no" name="hepatitisC" value="0" {if $patologias_actuales.hepatitisC == "0"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="hepatitisC-si" name="hepatitisC" value="1" {if $patologias_actuales.hepatitisC == "1"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                            
                    </div>
                </div>
                    
                <div class="row antecedente " {if $patologias_actuales.VPH =="" } style="display:none;" {/if} id="div_vph">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"VPH"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="VPH-no" name="VPH" value="0" {if $patologias_actuales.VPH == "0"} checked {/if} data-toggle="radio" class="custom-checkbox">
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="VPH-si" name="VPH" value="1" {if $patologias_actuales.VPH == "1"} checked {/if} data-toggle="radio" class="custom-checkbox">
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                            
                    </div>
                </div>
                    
                <div class="row antecedente" {if $patologias_actuales.HIV =="" } style="display:none;" {/if} id="div_hiv">
                    <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"HIV"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="HIV-no" name="HIV" value="0"  {if $patologias_actuales.HIV == "0"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="HIV-si" name="HIV" value="1"  {if $patologias_actuales.HIV == "1"} checked {/if} data-toggle="radio" class="custom-checkbox" >
                                <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                            
                    </div>
                </div>
                    
                    
            </div>
                
                
        </form>
        <div class="clearfix">&nbsp;</div>
            
        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="5" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
            <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="6" data-next="7" >{"siguiente"|x_translate}</a>
                
        </div>
            
        <div class="okm-row text-center" style="margin-top:40px">
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que NO, confirma que no tiene ningún tipo de Hepatitis o virus, que sean la Hepatitis A, Hepatitis B, la Hepatitis C, el VPH o el HIV."|x_translate}</small></em></p>
        </div>
            
    </div>
</div>
{literal}
<script>
    $(function () {
        $("body").spin(false);
        
        scrollToEl($("#wizard_perfil_salud"));
        renderUI2("wizard_perfil_salud");
        
           if ($("#idpatologiasActuales")!="") {
            if ($("#div_hepatitis :radio[value=1]:checked").length > 0) {
                $("#hepatitis_si").prop("checked",true);
            }else{
                $("#hepatitis_no").prop("checked",true);
            }
        }
        
        $('#hepatitis_si').on('change.radiocheck', function () {
            $("#div_hepatitis").show();
            $("#div_hepatitisA").show();
        });
        
        $('#hepatitis_no').on('change.radiocheck', function () {
            $("#div_hepatitis").hide();
        });
        
        $(".btn-siguiente").click(function () {
            if ($("#hepatitis_si").is(":checked") || $("#hepatitis_no").is(":checked")) {
                
                if ($("#hepatitis_si").is(":checked")) {
                    var $actual_elem = $(".row.antecedente.active");
                    
                    //verififamos si se selecciono al menos una opcion
                    if ($(".row.antecedente.active").find(":radio:checked").length == 0) {
                        x_alert(x_translate("Complete los campos obligatorios"));
                        return false;
                    }
                    
                    
                    
                }
                if ($("#hepatitis_no").is(":checked")) {
                    //checkeamos las opciones de NO para guardarlas
                    $("#div_hepatitis input[type='radio'][value='0']").prop("checked", true);
                }
                $("body").spin("large");
                var next = $(this).data('next');
                x_sendForm($('#antecedentes_form_3'),
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
        });
        
        //buscamos el siguiente div de antecedentes y lo mostramos
        $('#div_hepatitis :radio').on('change.radiocheck', function () {
            
            var $actual_elem = $(this).parents(".row.antecedente");
            
            if ($actual_elem.next(".row.antecedente").length > 0) {
                if (!$actual_elem.next(".row.antecedente").is(":visible")) {
                    $actual_elem.removeClass("active");
                    $actual_elem.next(".row.antecedente").addClass("active").show();
                }
            } else {
                $(".btn-siguiente").show();
            }
        });
        
        $(".btn-volver").click(function () {
            $("body").spin("large");
            x_loadModule('wizard_perfil_salud', 'wizard_step_' + $(this).data('prev'), '', 'div_wizzard_step');
        })
        
        
    })
    
</script>
{/literal}