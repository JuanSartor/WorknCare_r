<div class="okm-row">
    <h6 class="text-center">{if $paciente.sexo==1}(7/9){else}(7/10){/if}</h6>
        
        
    <form class="form " id="form_patologia_familiar" role="form" method="post" action="{$url}add_patologia_familiar.do" method="post"  onsubmit="return false;">
        <div class="row">
            <input type="hidden" id="idperfilSaludAntecedentes" name="idperfilSaludAntecedentes" value="{$record.idperfilSaludAntecedentes}"/>
            <input type="hidden" id="paciente_idpaciente" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="tipoFamiliar_idtipoFamiliar" id="tipoFamiliar_idtipoFamiliar"  value="" />
            <input type="hidden" name="tipoPatologia_idtipoPatologia" id="tipoPatologia_idtipoPatologia" value="" />
            <input type="hidden" name="from_wizard" value="1" />
                
            <div class="col-md-6 col-md-offset-3 "  style="margin-top:20px">
                <div class="col-md-8 col-md-offset-2">
                    <div class="item-wrapper">
                        <span class="question small">{"Tiene algún antecedente familiar?"|x_translate}</span>
                        <label class="radio pull-right" for="antecedentes_no" style="display:inline">
                            <input type="radio" data-toggle="radio" value="0" id="antecedentes_no" name="antecedentes"  class="custom-radio">
                            {"No"|x_translate}
                        </label>
                        <label class="radio pull-right" for="antecedentes_si" style="display:inline">
                            <input type="radio" data-toggle="radio" value="1" id="antecedentes_si" name="antecedentes" class="custom-radio">
                            {"Si"|x_translate}
                        </label>
                            
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-md-offset-3 data-form" >
            
            <div class="row form-header text-center patient-file" id="div_antecedentes_familiares" style="display:none">
                
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
                                <input type="checkbox" id="no_antecedentesfamiliares" value="1" name="no_antecedentesfamiliares" data-toggle="checkbox" class="custom-checkbox">
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
                    
            </div>
        </div>
    </form>
    <div class="clearfix">&nbsp;</div>
        
    <div class="mapc-registro-form-row center">
        <a href="javascript:;" data-prev="6" class="btn btn-blue  btn-volver">{"volver"|x_translate}</a>
        <a href="javascript:;" class="btn btn-blue  btn-siguiente" data-step="7" data-next="8" >{"siguiente"|x_translate}</a>
    </div>
        
    <div class="okm-row text-center" style="margin-top:40px">
        <div class="col-md-6 col-md-offset-3 " >
            <p  style="color: #283e73;"><small>{"Cualquier duda, haga click sobre SI!!"|x_translate}</small></p>
            <p><em><small>{"Es importante que indique a su médico la información mas precisa posible. Al responder que NO, confirma que no tiene ningún tipo de antecedentes familiares."|x_translate}</small></em></p>
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
        $('#antecedentes_si').on('change.radiocheck', function () {
            $("#div_antecedentes_familiares").show();
        });
        
        $('#antecedentes_no').on('change.radiocheck', function () {
            $("#div_antecedentes_familiares").hide();
        });
        
         if ($("#idperfilSaludAntecedentes")!="") {
            if ($("#antecedentes_tag_input").tagsinput('items').length == 0) {
                $("#antecedentes_no").prop("checked",true);
            }else{
                $("#antecedentes_si").prop("checked",true);
                 $("#div_antecedentes_familiares").show();
            }
        }
        
        $(".btn-siguiente").click(function () {
            if ($("#antecedentes_si").is(":checked") || $("#antecedentes_no").is(":checked")) {
                if ($('#antecedentes_si').is(":checked") && $("#antecedentes_tag_input").tagsinput('items').length == 0 && !$("#no_antecedentesfamiliares").is(':checked')) {
                    x_alert(x_translate("Complete los campos obligatorios"));
                    return false;
                }
                var next = $(this).data('next');
                if ($("#antecedentes_no").is(":checked")) {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                    BASE_PATH + 'no_antecedente_familiar.do',
                    "paciente_idpaciente=" + $("#paciente_idpaciente").val() + "&idperfilSaludAntecedentes=" + $("#idperfilSaludAntecedentes").val(),
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
                    $("body").spin("large");
                    x_loadModule('wizard_perfil_salud', 'wizard_step_' + next, '', 'div_wizzard_step');
                    
                }
                
                
            } else {
                x_alert(x_translate("Complete los campos obligatorios"));
                return false;
            }
        });
        
        $(".btn-volver").click(function () {
            $("body").spin("large");
            x_loadModule('wizard_perfil_salud', 'wizard_step_' + $(this).data('prev'), '', 'div_wizzard_step');
        });
        
        $("ul.slider-menu li a").removeClass("active");
        $("ul.slider-menu li i.dpp-dna").parent().addClass("active");
        
        $('.select-box li').on('click', function () {
            $(this).parent('.select-box').find('li').removeClass('active');
            $(this).addClass('active');
        });
        
        
        $('.add-items').on('click', function (event) {
            event.preventDefault();
            
            var id_tipo_familiar = $('#ul_tipo_familiar').find('.active').data("id");
            var tipo_familiar = $('#ul_tipo_familiar').find('.active').text();
            
            var id_tipo_patologia = $('#ul_tipo_patologia').find('.active').data("id");
            var tipo_patologia = $('#ul_tipo_patologia').find('.active').text();
            
            if (typeof id_tipo_familiar == "undefined") {
                x_alert(x_translate("Elija tipo familiar"));
                return false;
            } else {
                $("#tipoFamiliar_idtipoFamiliar").val(id_tipo_familiar);
            }
            
            if (typeof id_tipo_patologia == "undefined") {
                x_alert(x_translate("Elija tipo patología"));
                return false;
            } else {
                $("#tipoPatologia_idtipoPatologia").val(id_tipo_patologia);
            }
            
            
            $("#form_patologia_familiar").spin("large");
            
            x_sendForm(
                    $('#form_patologia_familiar'),
            true,
            function (data) {
                $("#form_patologia_familiar").spin(false);
                
                
                if (data.result) {
                    
                    $('#antecedentes_tag_input').tagsinput('add', {"value": data.id, "text": tipo_familiar + ' - ' + tipo_patologia});
                    $('#no_antecedentesfamiliares').radiocheck('uncheck');
                } else {
                    x_alert(data.msg);
                }
            }
                    );
        });
        
        //funcionamiento cuando se checkea "Ningun Patologia"  se borran las cargadas previamente
        $("#no_antecedentesfamiliares").on('change.radiocheck', function () {
            if ($("#no_antecedentesfamiliares").is(':checked')) {
                
                x_doAjaxCall(
                        'POST',
                BASE_PATH + 'no_antecedente_familiar.do',
                "paciente_idpaciente=" + $("#paciente_idpaciente").val() + "&idperfilSaludAntecedentes=" + $("#idperfilSaludAntecedentes").val(),
                function (data) {
                    if (data.result) {
                        
                        
                    } else {
                        x_alert(data.msg);
                    }
                    
                }
                        );
                
            }
        });
    })
    
</script>
{/literal}