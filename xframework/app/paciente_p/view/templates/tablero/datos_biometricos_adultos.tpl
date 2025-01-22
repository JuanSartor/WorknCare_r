<article class="col-md-4 ">
    <div class="weight card card-white overview">
        <div class="card-header">
            <h1 class="card-title">{"Peso"|x_translate}</h1>
            <div class="card-value value">
                <h2>{if $masa_corporal.peso}{$masa_corporal.peso}{else}__{/if} <span>{"Kg"|x_translate}</span></h2>	
                <p class="summary status-ok value">{if $masa_corporal.diferencia_peso}{$masa_corporal.diferencia_peso} {"kg"|x_translate}{else}&nbsp;{/if}</p>
            </div>
            {if $paciente.sexo == 0}
            <span class="sex female"></span>
            {else}
            <span class="sex male"></span>
            {/if}
            <!-- class "female" o "male" -->
        </div>
        <div class="bottom-data">
            {if $masa_corporal}
            <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" data-modal="yes" id="modal-400">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden" id="peso_altura_modal">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Peso y altura"|x_translate}</h1>
                    <form class="edit patient-data" id="masa_corporal_tablero_form" action="{$url}save_masa_corporal_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="weight">{"Peso"|x_translate}</label>
                            <span class="pull-right" id="weight">
                                <input name="peso" value="{$masa_corporal.peso}" type="number">
                            </span>
                        </div>
                        <div class="form-group underline">
                            <label for="size">{"Altura"|x_translate}</label>
                            <span class="pull-right" id="size">
                                <input name="altura" value="{$masa_corporal.altura}" type="number">
                            </span>
                        </div>
                        <div class="form-group" style="margin-top:15px;">
                            <label for="sms"><b>{"IMC"|x_translate}</b></label>
                            <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                        </div>
                        <input type="submit" onclick="submitTableroFormMC();" value='{"guardar"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>
<article class="col-md-4 border-sep">
    <div class="height card card-white overview">
        <div class="card-header icon">
            <h1 class="card-title">{"Presión Arterial"|x_translate}</h1>
            <div class="card-value value">
                <h2>{if $presion_arterial.presion_campo1 != ""}{$presion_arterial.presion_campo1}/<small>{$presion_arterial.presion_campo2}</small>{else}--/<small>--</small>{/if}
                </h2>
            </div>
        </div>
        <div class="bottom-data">
            {if $presion_arterial}
            <p class="last-modified">{"Último registro"|x_translate} {$presion_arterial.fecha_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" id="modal-400" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Presión Arterial"|x_translate}</h1>
                    <form class="edit patient-data" id="presion_arterial_tablero_form" action="{$url}save_presion_arterial_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="systole">{"Presión Arterial"|x_translate}</label>
                            <input class="pull-right" id="presion_campo2" tabindex="2" name="presion_campo2" value="{$presion_arterial.presion_campo2}" type="text" style="width:42px">
                            <span class="pull-right"> / </span>
                            <input class="pull-right" id="presion_campo1" tabindex="1" name="presion_campo1" value="{$presion_arterial.presion_campo1}" type="text" style="width:42px">							

                        </div>
                        <div class="form-group underline">
                            <label for="systole">{"Sístole"|x_translate}</label>
                            <input class="pull-right" id="sistole" name="sistole" tabindex="3" value="{$presion_arterial.sistole}" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="diastole">{"Diástole"|x_translate}</label>
                            <input class="pull-right" id="diastole" name="diastole" tabindex="4" value="{$presion_arterial.diastole}" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="frequency">{"Frecuencia Cardíaca"|x_translate}</label>
                            <input class="pull-right" id="frecuencia_cardiaca" name="frecuencia_cardiaca" tabindex="5" value="{$presion_arterial.frecuencia_cardiaca}" type="number">
                        </div>
                        <input type="submit" onclick ="submitFormPresionArterialTablero()" value='{"guardar"|x_translate}'>
                     
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>
<article class="col-md-4">
    <div class="height card card-white overview">
        <div class="card-header icon">
            <h1 class="card-title">{"Colesterol"|x_translate}</h1>
            <div class="card-value value">
                <h2>{if $colesterol.colesterol_total}{$colesterol.colesterol_total}{else}___{/if} <span>{"mg/dl"|x_translate}</span></h2>
            </div>
        </div>
        <div class="bottom-data">
            {if $colesterol}
            <p class="last-modified">{"Último registro"|x_translate} {$colesterol.fecha_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" id="modal-400" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Colesterol"|x_translate}</h1>
                    <form class="edit patient-data" id="colesterol_tablero_form" action="{$url}save_colesterol_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                        <div class="form-group underline">
                            <label for="ch-total">{"Colesterol Total"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.colesterol_total}" name="colesterol_total" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="hdl">{"HDL"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.HDL}" name="HDL"  type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="ldl">{"LDL"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.LDL}" name="LDL"  type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="triglycerides">{"Triglicéridos"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.trigriseliridos}" name="trigriseliridos" type="number">
                        </div>
                        <input type="submit" onclick ="submitColesterolTableroForm()" value='{"guardar"|x_translate}'>

                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}
<script>
    $(document).ready(function() {
        $("#presion_arterial_tab").inputmask("9[9]/9[9]");


        $('#div_cards_datos_biometricos button[data-modal="yes"]').on('click', function(event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }


            buttonTriggers(button, menuOrigin, objClass);


        });

    });



    function submitFormPresionArterialTablero() {

        $("#presion_arterial_tablero_form").validate({
            showErrors: function(errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function(index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function(index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function(form) {
                if ($("#frecuencia_cardiaca").val() != "" || $("#sistole").val() != "" || $("#diastole").val() != "" || ($("#presion_campo2").val() != "" && $("#presion_campo1").val() != "")) {
                    //Si hay al menos un campo, guardo la info 
                    x_sendForm($('#presion_arterial_tablero_form'), true, function(data) {
                        $(".modal.fade.in:visible").modal('toggle');
                        x_alert(data.msg);
                        if (data.result) {

                            x_loadModule('tablero', "datos_biometricos_adultos", 'idpaciente=' + $("#idpaciente_p_arterial").val(), "div_cards_datos_biometricos", BASE_PATH + "paciente_p");
                            x_loadModule('tablero', 'presion_arterial', 'idpaciente=' + $("#idpaciente_p_arterial").val(), "div_presion_arterial", BASE_PATH + "paciente_p");
                        }
                    });
                } else {
                    x_alert(x_translate("Se debe completar al menos un campo"));
                    return false;
                }
            }
        });
    }

    function submitColesterolTableroForm() {

        $("#colesterol_tablero_form").validate({
            showErrors: function(errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function(index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function(index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function(form) {
                x_sendForm($('#colesterol_tablero_form'), true, function(data) {

                    if (data.result) {
                        x_alert(data.msg, recargar);

                    } else {
                        x_alert(data.msg);
                    }
                });
            }
        });
    }


    function submitTableroFormMC() {

        $("#masa_corporal_tablero_form").validate({
            showErrors: function(errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function(index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function(index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function(form) {
                x_sendForm($('#masa_corporal_tablero_form'), true, function(data) {
                    
                    if (data.result) {
                        x_alert(data.msg, recargar);
                    }else{
                        x_alert(data.msg);
                    }
                }
                );
            }
        });
    }
</script>
{/literal}