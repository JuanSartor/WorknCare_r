<article class="col-md-6">
    <div class="cholesterol card">
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Colesterol"|x_translate}</h1>
                </div>	
            </div>
            <div class="col-md-6 col-xs-6">
                <ul class="list-details">
                    <li><div class="value top-value">{if $colesterol.colesterol_total}{$colesterol.colesterol_total}{else}___{/if} <span><small>{"mg/dl"|x_translate}</small></span></div></li>
                    <li>
                        <div class="item">{"HDL"|x_translate}</div>
                        <div class="value">{if $colesterol.HDL}{$colesterol.HDL}{else}___{/if} {"mg/dl"|x_translate}</div>
                    </li>
                    <li>
                        <div class="item">{"LDL"|x_translate}</div>
                        <div class="value">{if $colesterol.LDL}{$colesterol.LDL}{else}___{/if} {"mg/dl"|x_translate}</div>
                    </li>
                    <li>
                        <div class="item">{"Triglicéridos"|x_translate}</div>
                        <div class="value">{if $colesterol.trigriseliridos}{$colesterol.trigriseliridos}{else}___{/if} {"mg/dl"|x_translate}</div>
                    </li>
                </ul>
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
                    <form class="edit patient-data" id="colesterol_form" action="{$url}save_colesterol_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" id="idpaciente_colesterol" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                        <div class="form-group underline">
                            <label for="ch-total">{"Colesterol Total"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.colesterol_total}" name="colesterol_total" id="colesterol_total" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="hdl">{"HDL"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.HDL}" name="HDL"  id="HDL" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="ldl">{"LDL"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.LDL}" name="LDL"  id="LDL" type="number">
                        </div>
                        <div class="form-group underline">
                            <label for="triglycerides">{"Triglicéridos"|x_translate}</label>
                            <input class="pull-right" value="{$colesterol.trigriseliridos}" name="trigriseliridos" id="trigriseliridos"  type="number">
                        </div>
                        <input type="submit" onclick ="submitForm()" id="btnSaveColesterol" value='{"guardar"|x_translate}'>
                     
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}
<script>
    function submitForm() {

        $("#colesterol_form").validate({
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
                x_sendForm($('#colesterol_form'), true, function(data) {
                    x_alert(data.msg);
                    if (data.result) {
                        if (data.result) {
                            $(".modal.fade.in:visible").modal('toggle')
                            x_loadModule('tablero', "datos_biometricos_adultos", 'idpaciente=' + $("#idpaciente_colesterol").val(), "div_cards_datos_biometricos", BASE_PATH + "paciente_p");
                            x_loadModule('tablero', 'colesterol', 'idpaciente=' + $("#idpaciente_colesterol").val(), "div_colesterol", BASE_PATH + "paciente_p");
                        }
                    }
                });
            }
        });
    }
    
    
    $(document).ready(function() {
        $('#div_colesterol button[data-modal="yes"]').on('click', function(event) {

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