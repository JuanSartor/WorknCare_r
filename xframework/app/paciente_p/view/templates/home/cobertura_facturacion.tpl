<style>
    #wizard_cobertura_facturacion form{
        border-radius: 10px;
        box-shadow: 2px 2px 10px 0 #666;
        margin: 10px;
        padding: 10px;
    }
    ul.easyWizardSteps{
        display:none !important;
    }

    /*header titulo*/
    .pul-perfil-incompleto{
        padding-top: 10px;
    }
    .pul-pi-box h2 {
        padding: 0 16px 16px 16px;
    }
    @media(min-width:600px){
        .top-verde-centrado {
            min-height: 60px;

        }
        .top-verde-centrado h1 {
            font-size: 18px;
            line-height: 60px;
        }

        .top-verde-centrado h1>i {
            font-size: 24px;
            margin-right: 12px;
            top: 2px;
        }
    }

    @media(max-width:600px){
        .top-verde-centrado {
            background-color: #00b0ad;
            min-height: 60px;
            text-align: center;
        }
        .top-verde-centrado h1 {
            color: #fff;
            font-size: 16px;
            margin: 0;
            align-items: center;
            line-height: 25px;
            padding: 10px;
        }
        .mapc-registro-form-row a.btn-default {
            width:auto !important
        }
        .pul-pi-box h2 {
            padding: 0 16px 16px 16px;
        }
    }

</style>

<section class="pul-perfil-incompleto">
    {if $paciente.beneficios_reintegro==1 && $paciente.pais_idpais==1 }
        <div class="pul-pi-box" id="div_wizard_cobertura" style="    max-width: 750px;">
            <div class="top-verde-centrado">
                <h1>
                    {"Bienvenido"|x_translate} {$paciente.nombre} {$paciente.apellido}!
                </h1>
                <h2>
                    {"Tiene que setear su perfil de usuario para definir cual será su nivel de reintegro cuando consultara con sus médicos por videoconsulta"|x_translate}
                </h2>
            </div>


            <div id="wizard_cobertura_facturacion">
                <section class="step"  data-step-title="" data-callback='step1' >
                    <form id="form_cobertura_facturacion_step1" role="form" action="{$url}{$controller}.php?action=1&modulo=pacientes&submodulo=cobertura_facturacion" method="POST" onsubmit="return false;">
                        <input type="hidden" name="step" value="1" />
                        <input type="hidden"  name="idpaciente" value="{$paciente.idpaciente}" />
                        <div  id="cont_1">

                            <div class="okm-row input-row"  id="div_beneficia_ald">
                                <div class="pul-col-x2">
                                    <label>{"Beneficia de afección de largo plazo?"|x_translate}</label>
                                </div>
                                <div class="pul-col-x2 check-holder" >
                                    <div class="col-md-4 col-xs-6">
                                        <label for="beneficia_ald_si" class="radio"><input type="radio" name="beneficia_ald" value="1" id="beneficia_ald_si" > {"Si"|x_translate}</label>
                                    </div>
                                    <div class="col-md-4 col-xs-6">
                                        <label for="beneficia_ald_no" class="radio"><input type="radio" name="beneficia_ald" value="0" id="beneficia_ald_no"  > {"No"|x_translate}</label>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>

                            </div>

                            <div class="okm-row input-row" id="div_afeccion"  style="display:none;">
                                <div class="pul-col-x2">
                                    <label>{"Cual es?"|x_translate}</label>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-registro-form-row mapc-select pul-np-select" style="margin-top:0px;">
                                        <select id="afeccion_idafeccion" name="afeccion_idafeccion"  class="form-control select select-primary select-block mbl" data-title="Seleccione la afección">
                                            <option value="">{"Seleccione la afección"|x_translate}</option>
                                            {html_options options=$combo_afeccion selected=$afeccion.idafeccion}
                                        </select>
                                    </div>
                                </div>
                            </div>



                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">

                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="1" >{"siguiente"|x_translate}</a>

                                </div>
                            </div>

                            <p class="text-center">
                                <em>
                                    <small>
                                        {"El Seguro Social le asegura una cobertura del 100% de las teleconsultas realizadas como parte del programa de atención, si se beneficia del tratamiento para una exoneración a largo plazo del Desorden de afecto (ALD) (diabetes, cáncer ...). Es su fondo de seguro de salud primario (CPAM) el que decide si le otorgará el beneficio del ALD exonerado. El reembolso de una teleconsulta se calcula sobre la base de las tarifas de la Seguridad Social."|x_translate}
                                    </small>
                                </em>
                            </p>
                        </div>
                    </form>
                </section>

                <section class="step"  data-step-title="" data-callback='step2' >
                    <form id="form_cobertura_facturacion_step2" role="form" action="{$url}{$controller}.php?action=1&modulo=pacientes&submodulo=cobertura_facturacion" method="POST" onsubmit="return false;">
                        <input type="hidden" name="step" value="2" />
                        <input type="hidden"  name="idpaciente" value="{$paciente.idpaciente}" />
                        <div  id="cont_2">

                            <div class="okm-row input-row" id="div_beneficia_exempcion">
                                <div class="pul-col-x2">
                                    <label>{"Beneficia de una exención?"|x_translate}</label>
                                </div>
                                <div class="pul-col-x2 check-holder" >
                                    <div class="col-md-4 col-xs-6">
                                        <label for="beneficia_exempcion_si" class="radio"><input type="radio" name="beneficia_exempcion" value="1" id="beneficia_exempcion_si"> {"Si"|x_translate}</label>
                                    </div>
                                    <div class="col-md-4 col-xs-6">
                                        <label for="beneficia_exempcion_no" class="radio"><input type="radio" name="beneficia_exempcion" value="0" id="beneficia_exempcion_no" > {"No"|x_translate}</label>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>


                            </div>
                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;" class="btn-default btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="2" >{"siguiente"|x_translate}</a>

                                </div>
                            </div>

                            <p class="text-center">
                                <em>
                                    <small>
                                        {"El Seguro Social le asegura una cobertura del 100% de las teleconsultas realizadas como parte del programa de atención, si se beneficia de una Cobertura de salud suplementaria universal (CMU-C). Si es una mujer embarazada mayor de 6 meses, indíquelo más adelante en su perfil de salud porque también obtiene una cobertura del 100%. El reembolso de una teleconsulta se calcula sobre la base de las tarifas de la Seguridad Social."|x_translate}
                                    </small>
                                </em>
                            </p>
                        </div>
                    </form>
                </section>
                <section class="step"  data-step-title="" data-callback='step3' >
                    <form id="form_cobertura_facturacion_step3" role="form" action="{$url}{$controller}.php?action=1&modulo=pacientes&submodulo=cobertura_facturacion" method="POST" onsubmit="return false;">
                        <input type="hidden" name="step" value="3" />
                        <input type="hidden"  name="idpaciente" value="{$paciente.idpaciente}" />
                        <div  id="cont_3">
                            <div class="okm-row input-row" id="div_posee_cobertura">
                                <div class="pul-col-x2">
                                    <label>{"Tiene una cobertura?"|x_translate}</label>
                                </div>
                                <div class="pul-col-x2 check-holder" >
                                    <div class="col-md-4 col-xs-6">
                                        <label for="posee_cobertura_si" class="radio"><input type="radio" name="posee_cobertura" value="1" id="posee_cobertura_si" > {"Si"|x_translate}</label>
                                    </div>
                                    <div class="col-md-4 col-xs-6">
                                        <label for="posee_cobertura_no" class="radio"><input type="radio" name="posee_cobertura" value="0" id="posee_cobertura_no"  > {"No"|x_translate}</label>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>

                            </div>

                            <div class="okm-row input-row" id="div_obra_social" style="display:none;">
                                <div class="pul-col-x2">
                                    <label>{"Cual es?"|x_translate}</label>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <input type="hidden" name="idobraSocial" id="idobraSocial" value="{$obra_social.idobraSocial}"/>
                                        <input  id="as_obra_social" name="as_obra_social" type="text" class="especialidad-input"  placeholder='{"Buscar cobertura médica"|x_translate}' data-title='{"Buscar cobertura médica"|x_translate}' value="{$obra_social.nombre}">
                                    </div>
                                </div>
                            </div>
                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;" class="btn-default btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="3" >{"siguiente"|x_translate}</a>

                                </div>
                            </div>

                            <p class="text-center">
                                <em>
                                    <small>
                                        {"Esta información es importante si se beneficia de un apoyo de su salud complementaria. Podrá recibir una prueba de que podrá dirigirse a su correo complementario para hacerle reembolsar el resto a cargar. Tenga cuidado, su complemento solo le reembolsará si la teleconsulta realizada es elegible para el reembolso por el Seguro Social."|x_translate}
                                    </small>
                                </em>
                            </p>
                        </div>

                    </form>
                </section>

                <section class="step"  data-step-title="" data-callback='step3' >
                    <form id="form_cobertura_facturacion_step4" role="form" action="{$url}{$controller}.php?action=1&modulo=pacientes&submodulo=cobertura_facturacion" method="POST" onsubmit="return false;">
                        <input type="hidden" name="step" value="4" />
                        <input type="hidden"  name="idpaciente" value="{$paciente.idpaciente}" />
                        <div  id="cont_4">
                            <div id="buscador_medico_cabecera_container" >
                                {include file="pacientes/buscador_medico_cabecera.tpl"}
                            </div>
                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;" class="btn-default btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="4" >{"siguiente"|x_translate}</a>

                                </div>
                            </div>

                            <p class="text-center">
                                <em>
                                    <small>
                                        {"Si ha declarado a un profesional médico, se beneficiará del reembolso de sus teleconsultas en las mismas condiciones que una consulta en la oficina, siempre que haya tenido una consulta personal con este último durante los últimos 12 meses. Cuando consulta a un médico como parte del curso de tratamiento, se beneficia de una tasa de reembolso del 70%."|x_translate}
                                    </small>
                                </em>
                            </p>

                        </div>

                    </form>
                </section>
            </div>

        </div>
    {/if}

    {*quitamos wizard PS*}
    {*
    <div class="pul-pi-box" id="div_completar_perfil_salud"  {if $paciente.beneficios_reintegro==1 && $paciente.pais_idpais==1 }style="display:none;"{/if}>


    <div class="top-verde-centrado">
    <h1>{"Complete su perfil de salud antes de consultar"|x_translate}</h1>
    </div>


    <div class="okm-row pul-pi-data-box">
    <div class="col-data">
    <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
    <p>{"Perfil de Salud"|x_translate}</p>
    </div>

    <div class="col-info hidden-xs">
    <figure>0%</figure>
    </div>
    <div class="col-action">

    <a href="{$url}panel-paciente/wizard_perfil_salud/" class="btn">{"Completar"|x_translate}</a>

    </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div class="okm-row">
    <div class="mapc-registro-form-row center">

    <a href="javascript:;" id="no_completar_perfil_salud" class="btn-default " >{"Completar más tarde"|x_translate}</a>

    </div>
    </div>
    </div>
    *}
</section>


<script src="{$url_js_libs}/coco/assets/libs/jquery-wizard/jquery.easyWizard.js"></script>
{literal}
    <script>
                        $(function () {
                            var validarStep1 = function () {
                                if (!$("#beneficia_ald_si").is(":checked") && !$("#beneficia_ald_no").is(":checked")) {
                                    $("#div_beneficia_ald .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
                                    return false;
                                }
                                if ($("#beneficia_ald_si").is(":checked") && $("#afeccion_idafeccion").val() === "") {
                                    $("#div_afeccion .select").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
                                    return false;
                                }

                                return true;
                            };
                            var validarStep2 = function () {
                                if (!$("#beneficia_exempcion_si").is(":checked") && !$("#beneficia_exempcion_no").is(":checked")) {
                                    $("#div_beneficia_exempcion .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");

                                    return false;
                                }

                                return true;
                            };
                            var validarStep3 = function () {
                                if (!$("#posee_cobertura_si").is(":checked") && !$("#posee_cobertura_no").is(":checked")) {
                                    $("#div_posee_cobertura .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");

                                    return false;
                                }
                                if ($("#posee_cobertura_si").is(":checked") && $("#idobraSocial").val() === "") {
                                    $("#as_obra_social").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
                                    return false;
                                }


                                return true;
                            };
                            var validarStep4 = function () {
                                if (!$("#medico_cabeza_si").is(":checked") && !$("#medico_cabeza_no").is(":checked")) {
                                    $("#div_medico_cabeza .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
                                    return false;
                                }
                                if ($("#medico_cabeza_si").is(":checked") && !$("#medico_cabeza_externo").is(":checked") && $("#idmedico_cabecera").length === 0) {
                                    $("#div_buscador_medico_cabecera").show();
                                    $("#nombre_medico_cabecera").data("title", x_translate("Si has declarado un médico tratante debe seleccionarlo")).tooltip("show").addClass("select-required");

                                    return false;
                                }


                                return true;
                            };

                            $('#wizard_cobertura_facturacion').easyWizard({
                                showButtons: false,
                                submitButton: false,
                                before: function (wizardObj, currentStepObj, nextStepObj) {

                                    var callback = nextStepObj.data("callback");

                                    if (typeof (callback) != "undefined") {
                                        // eval(callback + "()");
                                    }

                                },
                                beforeSubmit: function (wizardObj) {
                                }
                            });
                            $(".btn-siguiente").click(function () {
                                var step = $(this).data("step");

                                //limpiamos los tooltip de validacion anteriores
                                $.each($('#form_cobertura_facturacion_step' + step + ' input'), function (index, error) {
                                    var $element = $(error);
                                    $element.tooltip("destroy");
                                });
                                $.each($('#form_cobertura_facturacion_step' + step + ' div'), function (index, error) {
                                    var $element = $(error);
                                    $element.tooltip("destroy");
                                });
                                var validacion = eval("validarStep" + step + "()");
                                if (validacion) {

                                    $(".step.active").spin("large");

                                    x_sendForm($('#form_cobertura_facturacion_step' + step), true, function (data) {
                                        $(".step.active").spin(false);

                                        if (data.result) {
                                            if (step != 4) {
                                                $('#wizard_cobertura_facturacion').easyWizard('nextStep');
                                            } else {
                                                //$("#div_wizard_cobertura").hide();
                                                //$("#div_completar_perfil_salud").slideDown();
                                                $("body").spin("large");
                                                window.location.href = "";
                                            }

                                        } else {
                                            x_alert(data.msg);
                                        }
                                    });

                                }
                            });

                            $(".btn-volver").click(function () {

                                $('#wizard_cobertura_facturacion').easyWizard('prevStep');


                            });
                            $("#beneficia_ald_si").on('change.radiocheck', function () {
                                $("#div_afeccion").slideDown();
                                $("#div_beneficia_ald .select-required").removeClass("select-required").tooltip("destroy");

                            });

                            $("#beneficia_ald_no").on('change.radiocheck', function () {
                                $("#div_afeccion").slideUp();
                                $("#div_beneficia_ald .select-required").removeClass("select-required").tooltip("destroy");

                            });
                            $("#afeccion_idafeccion").on("change", function () {
                                if ($("#afeccion_idafeccion").val() !== "") {
                                    $("#div_afeccion .select-required").removeClass("select-required").tooltip("destroy");
                                }
                            });

                            $("#beneficia_exempcion_si").on('change.radiocheck', function () {
                                $("#div_beneficia_exempcion .select-required").removeClass("select-required").tooltip("destroy");
                            });

                            $("#beneficia_exempcion_no").on('change.radiocheck', function () {
                                $("#div_beneficia_exempcion .select-required").removeClass("select-required").tooltip("destroy");
                            });

                            //cobertura medica
                            $('#as_obra_social').autocomplete({
                                zIndex: 10000,
                                serviceUrl: BASE_PATH + 'obrasocial_autosuggest.do',
                                onSelect: function (data) {
                                    $("#idobraSocial").val(data.data).change();
                                }
                            });



                            $("#posee_cobertura_si").on('change.radiocheck', function () {
                                $("#div_obra_social").slideDown();
                                $("#div_posee_cobertura .select-required").removeClass("select-required").tooltip("destroy");
                            });

                            $("#posee_cobertura_no").on('change.radiocheck', function () {
                                $("#div_obra_social").slideUp();
                                $("#div_posee_cobertura .select-required").removeClass("select-required").tooltip("destroy");
                            });

                            $("#idobraSocial").on("change", function () {
                                if ($("#idobraSocial").val() !== "") {

                                    $("#div_obra_social .select-required").removeClass("select-required").tooltip("destroy");
                                }
                            });

                            /*
                             $("#no_completar_perfil_salud").click(function () {
                             x_doAjaxCall(
                             'POST',
                             BASE_PATH + 'no_completar_perfil_salud.do',
                             "",
                             function (data) {
                             if (data.result) {
                             window.location.href = "";
                             } else {
                             x_alert(data.msg);
                             }
                             
                             }
                             );
                             });*/

                        });
    </script>
{/literal}