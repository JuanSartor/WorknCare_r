<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(4/9){else}(4/10){/if}</h6>
    <div class="col-md-6 col-md-offset-3"  style="margin-top:20px">
        
        <form class="form patient-file relative" role="form" id="antecedentes_form_1" action="{$url}save_antecedentes_personales.do" method="post" onsubmit="return false;">
            <input type="hidden" name="idantecedentesPersonales" id="idantecedentesPersonales" value="{$antecedente.idantecedentesPersonales}" />
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="from_wizard" value="1" />
            <div class="row" >
                <div class="col-md-7 col-md-offset-3">
                    <div class="item-wrapper">
                        <span class="question small">{"Tiene algún antecedente?"|x_translate}</span>
                        <label class="radio pull-right" for="antecedentes_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="antecedentes_no" name="antecedentes"  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                        <label class="radio pull-right" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="antecedentes_si" name="antecedentes" class="custom-radio">
                            {"Si"|x_translate}
                        </label>
                    </div>
                </div>
            </div>
            <div id="div_antecedentes">
                <div class="row antecedente active" {if $antecedente.varicela == ""} style="display:none;"{/if} id="div_varicela">
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Varicela"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="varicela-no" name="varicela" {if $antecedente.varicela == "0"}checked{/if} value="0" data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="varicela-si" name="varicela" {if $antecedente.varicela == 1}checked{/if} value="1"  data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente"  {if $antecedente.rubiola == ""} style="display:none;"{/if}>
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Rubéola"|x_translate}</span>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"  id="rubiola-no" name="rubiola" value="0"  {if $antecedente.rubiola == "0"}checked{/if}  data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"  id="rubiola-si"  name="rubiola"  value="1"  {if $antecedente.rubiola == "1"}checked{/if}  data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente" {if $antecedente.sarampion == ""} style="display:none;"{/if}>
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Sarampión"|x_translate}</span>
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" id="sarampion-no" name="sarampion" value="0"  {if $antecedente.sarampion == "0"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" name="sarampion" value="1"   {if $antecedente.sarampion == "1"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente" {if $antecedente.escarlatina == ""} style="display:none;"{/if} >
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Escarlatina"|x_translate}</span>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"  name="escarlatina" value="0"  id="escarlatina-no" {if $antecedente.escarlatina == "0"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" name="escarlatina" value="1"   id="escarlatina-si" {if $antecedente.escarlatina == "1"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente" {if $antecedente.eritema == ""} style="display:none;"{/if} >
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Eritema infeccioso o Quinta Enfermedad"|x_translate}</span>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" name="eritema" value="0" id="eritema-no" {if $antecedente.eritema == "0"}checked{/if}  data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"   name="eritema" value="1"  id="eritema-si" {if $antecedente.eritema == "1"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente" {if $antecedente.exatema == ""} style="display:none;"{/if}>
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Exantema súbito o Sexta Enfermedad"|x_translate}</span>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"  name="exatema" value="0"  id="exatema-no"  {if $antecedente.exatema == "0"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio"  name="exatema" value="1"  id="exatema-si"  {if $antecedente.exatema == "1"}checked{/if}  data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
                    
                <div class="row antecedente" {if $antecedente.papera == ""} style="display:none;"{/if}>
                     <div class="col-md-7 col-md-offset-3">
                        <div class="item-wrapper">
                            <span class="question small">{"Paperas"|x_translate}</span>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" name="papera" value="0" id="papera-no" {if $antecedente.papera == "0"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"No"|x_translate}</span>
                            </label>
                                
                            <label class="radio pull-right" style="display:inline">
                                <input type="radio" name="papera" value="1"  id="papera-si" {if $antecedente.papera == "1"}checked{/if} data-toggle="radio" class="custom-checkbox">
                                       <span class="label">{"Si"|x_translate}</span>
                            </label>
                                
                        </div>
                    </div>
                </div>
            </div>
                
        </form>
        <div class="clearfix">&nbsp;</div>
            
        <div class="mapc-registro-form-row center">
            <a href="javascript:;" data-prev="3" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
            <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="4" data-next="5">{"siguiente"|x_translate}</a>
                
        </div>
            
        <div class="okm-row text-center" style="margin-top:40px">
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que NO, confirma que no tuvo ningún tipo de antecedentes como la varicela, rubéola, sarampión, escarlatina, eritema infeccioso, quinta enfermedad, exantema súbito, sexta enfermedad o paperas."|x_translate}</small></em></p>
        </div>
            
            
    </div>
</div>
{literal}
<script>
    $(function () {
        $("body").spin(false);
        scrollToEl($("#wizard_perfil_salud"));
        
        renderUI2("wizard_perfil_salud");
        if ($("#idantecedentesPersonales")!="") {
            if ($("#div_antecedentes :radio[value=1]:checked").length > 0) {
                $("#antecedentes_si").prop("checked",true);
            }else{
                $("#antecedentes_no").prop("checked",true);
            }
        }
        
        $('#antecedentes_si').on('change.radiocheck', function () {
            $("#div_antecedentes").show();
            $("#div_varicela").show();
        });
        
        $('#antecedentes_no').on('change.radiocheck', function () {
            $("#div_antecedentes").hide();
        });
        
        //buscamos el siguiente div de antecedentes y lo mostramos
        $('#div_antecedentes :radio').on('change.radiocheck', function () {
            
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
        
        $(".btn-siguiente").click(function () {
            if ($("#antecedentes_si").is(":checked") || $("#antecedentes_no").is(":checked")) {
                
                if ($("#antecedentes_si").is(":checked")) {
                    var $actual_elem = $(".row.antecedente.active");
                    
                    //verififamos si se selecciono al menos una opcion
                    if ($(".row.antecedente.active").find(":radio:checked").length == 0) {
                        x_alert(x_translate("Complete los campos obligatorios"));
                        return false;
                    }
                    
                }
                if ($("#antecedentes_no").is(":checked")) {
                    //checkeamos las opciones de NO para guardarlas
                    $("#div_antecedentes input[type='radio'][value='0']").prop("checked", true);
                }
                var next = $(this).data('next');
                x_sendForm($('#antecedentes_form_1'),
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
                $("body").spin("large");
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