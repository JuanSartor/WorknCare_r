<div class="form-content edit-data">
    <button data-dismiss="modal" class="close dp-canceled"></button>
    <form id="vacuna_form" action="{$url}vacuna_form_paciente.do" method="post"  onsubmit="return false;">
        <input type="hidden" name="idpaciente_vacuna_vacunaEdad" value="{$record.idpaciente_vacuna_vacunaEdad}" />
        <input type="hidden" name="vacuna_vacunaEdad_idvacuna_vacunaEdad" value="{$idvacuna_vacunaEdad}" />
        <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
        <p class="text-center">
            <label for="va-check" class="checkbox">
                <input type="checkbox" name="is_aplicada" value="1" {if $record.idpaciente_vacuna_vacunaEdad} checked{/if} id="va-check">{"Vacuna aplicada"|x_translate}
            </label>
        </p>
        <p class="text-center">
            <i>{"Si tiene constancia por favor ingrese la fecha de su aplicación"|x_translate}</i>
            <select class="select date-select" name="dia">
                <option value="">{"dia"|x_translate}</option>
                {html_options options=$combo_dias selected=$record.dia}
            </select>
            <select class="select date-select" name="mes" style="width:100px">
                <option value="">{"mes"|x_translate}</option>
                {html_options options=$combo_meses selected=$record.mes}
            </select>
            <select class="select date-select" name="anio">
                <option value="">{"año"|x_translate}</option>
                {html_options options=$combo_anios selected=$record.anio}
            </select>												
        </p>
        <input id="btnSaveVacuna" type="submit" value='{"grabar datos"|x_translate}'>
    </form>
</div>

{literal}
<script>
    $(document).ready(function() {
        renderUI2("div_modal_vacuna_aplicada");
         
    });
    $("#btnSaveVacuna").click(function() {

        x_sendForm($('#vacuna_form'), true, function(data) {
            $("#vacuna-aplicada .close.dp-canceled").click();
            
          
            if (data.result) {
               x_alert(data.msg,recargar);
            }else{
                x_alert(data.msg);
            }
        });
    });


</script>
{/literal}