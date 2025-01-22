<article class="col-md-6">
    <div class="card weight" id="div_peso_altura">
        <input type="hidden" id="idpaciente_peso_altura" value="{$idpaciente}" />
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Peso"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.peso}{$masa_corporal.peso}{else}__{/if} <span>{"kg"|x_translate}</span></h2>
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_peso}{$masa_corporal.diferencia_peso}kg{else}&nbsp;{/if}</p>
                        {if $masa_corporal.fecha_peso_dp != ""}
                        <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_peso_dp} </p>
                        {else}
                        <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                        {/if}
                    </div>
                </div>
                <div class="card-header" style="margin-top:130px;">
                    <h1 class="card-title">{"IMC"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{$masa_corporal.imc}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Altura"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.altura}{$masa_corporal.altura}{else}__{/if} <span>{"cm"|x_translate}</span></h2>
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_altura}{$masa_corporal.diferencia_altura}{"cm"|x_translate}{else}&nbsp;{/if}</p>
                        {if $masa_corporal.fecha_altura_dp != ""}
                        <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_altura_dp} </p>
                        {else}
                        <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                        {/if}
                    </div>										
                </div>
                <button class="btn-search search" data-modal="yes" style="margin-top:122px;">{"Ver Estatus segun IMC"|x_translate}</button>
                <div class="modal-edit-data hidden">
                    <div class="edit-data info patient w">
                        <button data-dismiss="modal" class="close dp-canceled"></button>
                        <h1>{"Estatus/Comentario"|x_translate}</h1>
                        <h2 class="text-center">{"Valores del IMC"|x_translate}</h2>
                        <ul>
                            <li>
                                <div class="col-md-6 red">{"Infra Peso"|x_translate}</div>
                                <div class="col-md-6 bigger">{"IMC < 18.49"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-6 red">{"Peso Normal"|x_translate}</div>
                                <div class="col-md-6 bigger">{"18.50 < IMC < 24.99"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-6 red">{"Sobre Peso"|x_translate}</div>
                                <div class="col-md-6 bigger">{"25 < IMC < 29.99"|x_translate} </div>
                            </li>
                            <li>
                                <div class="col-md-6 red">{"Obesidad Leve"|x_translate}</div>
                                <div class="col-md-6 bigger"> {"30 < IMC < 34.99"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-6 red">{"Obesidad Media"|x_translate}</div>
                                <div class="col-md-6 bigger">{"35 < IMC < 39.99"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-6 red">{"Obesidad Mórbida"|x_translate}</div>
                                <div class="col-md-6 bigger">{"IMC > 40"|x_translate}</div>
                            </li>
                        </ul>
                        {*<ul>
                            <li>
                                <div class="col-md-8 red">{"Peso por debajo del peso normal -> delgadez"|x_translate}</div>
                                <div class="col-md-4 bigger">{"IMC < 19"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-8 red">{"Peso en exceso (sobrepeso) -> riesgos bajos"|x_translate}</div>
                                <div class="col-md-4 bigger">{"19 < IMC < 25"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-8 red">{"Peso normal"|x_translate}</div>
                                <div class="col-md-4 bigger">{"25 < IMC < 30"|x_translate} </div>
                            </li>
                            <li>
                                <div class="col-md-8 red">{"Obesidad clase I -> riesgos moderados"|x_translate}</div>
                                <div class="col-md-4 bigger"> {"30 < IMC < 35"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-8 red">{"Obesidad clase II -> riesgos altos"|x_translate}</div>
                                <div class="col-md-4 bigger">{"35 < IMC < 40"|x_translate}</div>
                            </li>
                            <li>
                                <div class="col-md-8 red">{"Obesidad clase III -> riesgos muy altos"|x_translate}</div>
                                <div class="col-md-4 bigger">{"IMC > 40"|x_translate}</div>
                            </li>
                        </ul>*}
                        <div class="clearfix"></div>
                    </div>
                </div>										
            </div>
        </div>
        <div class="bottom-data">
            <button class="edit dp-edit modal-btn" data-id="peso_altura_modal" id="modal-400" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden" id="peso_altura_modal">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Peso y altura"|x_translate}</h1>
                    <form class="edit patient-data" id="masa_corporal_form" action="{$url}save_masa_corporal_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="peso" >{"Peso"|x_translate}</label>
                            <span class="pull-right" id="weight">
                              
                                <input id="peso" name="peso" value="{$masa_corporal.peso}" type="number">
                            </span>
                        </div>
                        <div class="form-group underline">
                            <label for="altura">{"Altura"|x_translate}</label>
                            <span class="pull-right" id="size">
                                <input id="altura" name="altura" value="{$masa_corporal.altura}" type="number">
                            </span>
                        </div>
                        <div class="form-group" style="margin-top:15px;">
                            <label for="sms"><b>{"IMC"|x_translate}</b></label>
                            <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                        </div>
                        <input type="submit" onclick="submitFormMC();" value='{"guardar"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}

<script>
    //x_runJS();


    function submitFormMC() {

        $("#masa_corporal_form").validate({
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
                x_sendForm($('#masa_corporal_form'), true, function(data) {
                    x_alert(data.msg);
                    if (data.result) {
                        $(".modal.fade.in:visible").modal('toggle')
                        x_loadModule('tablero', "datos_biometricos_adultos", 'idpaciente=' + $("#idpaciente_peso_altura").val(), "div_cards_datos_biometricos", BASE_PATH + "paciente_p");
                        x_loadModule('tablero', 'peso_altura', 'idpaciente=' + $("#idpaciente_peso_altura").val(), "div_peso_altura", BASE_PATH + "paciente_p");
                    }
                }
                );
            }
        });
    }


    $(document).ready(function() {
        $('#div_peso_altura button').on('click', function(event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });
    });
</script>
{/literal}