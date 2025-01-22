<article class="col-md-6">
    <div class="pressure card">
        <div class="row">
            <div class="col-md-12">
                <div class="card-header">
                    <h1 class="card-title">{"Glucemia"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $glucemia.test}{$glucemia.test}{else}__{/if} <span>{"mg/dl"|x_translate}</span></h2>
                    </div>										
                </div>	
            </div>
        </div>
        <div class="bottom-data">
            {if $glucemia}
            <p class="last-modified">{"Último registro"|x_translate} {$glucemia.fecha_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" id="modal-400" data-modal="yes">{"Actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Glucemia"|x_translate}</h1>
                    <form class="edit patient-data" id="glucemia_form" action="{$url}save_glucemia_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" id="idpaciente_glucemia" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                        <div class="form-group underline">
                           <input class="pull-right" value="{$glucemia.test}" name="test" type="text"> <small>{"mg/dl"|x_translate}</small>
                        </div>
                        <input type="submit" onclick ="submitFormGlucemia();" value='{"guardar"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}

<script>
    function submitFormGlucemia() {

        x_sendForm($('#glucemia_form'), true, function(data) {
            x_alert(data.msg);
            if (data.result) {
                $(".modal.fade.in:visible").modal('toggle')
                x_loadModule('tablero', 'glucemia', 'idpaciente=' + $("#idpaciente_glucemia").val(), "div_glucemia", BASE_PATH + "paciente_p");
            }
        });
    }


    $(document).ready(function() {
        $('#div_glucemia button').on('click', function(event) {

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