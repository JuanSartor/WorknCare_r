<article class="col-md-6">
    <div class="pressure card">
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Presión arterial"|x_translate}</h1>
                </div>	
            </div>
            <div class="col-md-6  col-xs-6">
                <ul class="list-details">

                    <li><div class="value top-value">
                            {if $presion_arterial.presion_campo1 != ""}{$presion_arterial.presion_campo1}/<span>{$presion_arterial.presion_campo2}</span>{else}--/<span>--</span>{/if}
                        </div>
                    </li>
                    <li>
                        <div class="item">{"Sistole"|x_translate}</div>
                        <div class="value">{if $presion_arterial.sistole != ""}{$presion_arterial.sistole} {"mmHg"|x_translate}{else}___{/if}</div>
                    </li>
                    <li>
                        <div class="item">{"Diástole"|x_translate}</div>
                        <div class="value">{if $presion_arterial.diastole != ""}{$presion_arterial.diastole} {"mmHg"|x_translate}{else}___{/if}</div>
                    </li>
                    <li>
                        <div class="item">{"Frecuencia Cardíaca"|x_translate}</div>
                        <div class="value">{if $presion_arterial.frecuencia_cardiaca != ""}{$presion_arterial.frecuencia_cardiaca} {"mmHg"|x_translate}{else}___{/if}</div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="bottom-data">
            {if $presion_arterial}
            <p class="last-modified">{"Último registro"|x_translate} {$presion_arterial.fecha_dp}</p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            
            <button class="edit dp-edit" data-modal="yes">{"Actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Presión Arterial"|x_translate}</h1>
                    <form class="edit patient-data" id="presion_arterial_form" action="{$url}save_presion_arterial_form_m.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="systole">{"Presión Arterial"|x_translate}</label>
                            <input class="pull-right" id="presion_campo2" name="presion_campo2" tabindex="2" value="{$presion_arterial.presion_campo2}" type="text" style="width:42px">
                            <span class="pull-right"> / </span>
                            <input class="pull-right" id="presion_campo1" name="presion_campo1" tabindex="1" value="{$presion_arterial.presion_campo1}" type="text" style="width:42px">
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
                        <input type="submit" id="btnPresionArterial" onclick ="submitFormPresionArterial()" value='{"grabar datos"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>


<script>
    function submitFormPresionArterial() {

        $("#presion_arterial_form").validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function (form) {
                
                if ($("#frecuencia_cardiaca").val() != "" || $("#sistole").val() != "" || $("#diastole").val() != "" || ($("#presion_campo2").val() != "" && $("#presion_campo1").val() != "")) {
                
                    x_sendForm($('#presion_arterial_form'), true, function (data) {
                        x_alert(data.msg);

                        if (data.result) {
                            $(".modal.fade.in:visible").modal('toggle');
                            if ($("#idperfilSaludBiometricos").val() != "") {
                                 x_alert(data.msg);
                                x_loadModule('perfil_salud', 'modulo_presion_arterial', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_presion_arterial", BASE_PATH + "medico");
                            } else {
                                   x_alert(data.msg,recargar);
                            }
                        }else{
                               x_alert(data.msg);
                        }
                    });
                
        }else{
                    x_alert(x_translate("Se debe completar al menos un campo"));
                    return false;
                }
            }
        });
    }


    $(document).ready(function () {

        $('#div_presion_arterial button').on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
            $("#presion_arterial").inputmask("9[9]/9[9]");
        });




    });
</script>

{if $smarty.request.print==1}
{literal}
<script>
    $(function () {
        /**Limpiamos todos los botones y comportamiento JS de la vista de impresion para que sea estatica
         * 
         */
        $(".dp-edit").remove();
        $(".vista-impresion a").click(function (e) {
            e.preventDefault();
        });
        $(".vista-impresion button:submit").remove();
    });
</script>
{/literal}
{/if}