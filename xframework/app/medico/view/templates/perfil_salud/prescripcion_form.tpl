
<div class="modal-header">
    <div class="modal-title pull-left">
        <h5 class="dp-medicine">Agregar medicación</h5>
    </div>
    <div class="modal-action pull-right">
        <button class="btn btn-block btn-lg btn-primary dp-search">{"Vademecum"|x_translate}</button>	
    </div>
    <div class="clearfix"></div>
</div>
<div class="modal-body" id="modal-medicamentos">
    <form id="medicamentos_form" action="{$url}save_medicamentos.do" method="post" onsubmit="return false;">
        <input type="hidden" name="idperfilSaludMedicamento" id="idperfilSaludMedicamento" value="{$medicamento.idperfilSaludMedicamento}" />
        <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$medicamento.paciente_idpaciente}" />
        <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" id="idperfilSaludConsulta_win" value="{$medicamento.perfilSaludConsulta_idperfilSaludConsulta}" />

        <div class="form-content">
            <p>
                <input type="hidden" name="medicamento_idmedicamento" id="medicamento_idmedicamento" value="{$medicamento.medicamento_idmedicamento}" />
                <input type="text" placeholder='{"Medicamento"|x_translate}' name="as_nombre_comercial" id="as_nombre_comercial" value="{$medicamento.medicamento.nombre_comercial}">
            </p>
            <p>
                <input type="text" placeholder='{"Posología"|x_translate}' name="posologia" id="posologia" value="{$medicamento.posologia}">
            </p>
            <p>
                <select name="tipoTomaMedicamentos_idtipoTomaMedicamentos" id="tipoTomaMedicamentos_idtipoTomaMedicamentos" class="form-control select select-primary select-block">
                    {html_options options=$combo_tipo_toma_medicamento selected=$medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos}
                </select>
            </p>
            <div class="date-holder">

                <input type="text" id="fecha_inicio" class="input-group-addon" name="fecha_inicio" placeholder='{"Fecha de inicio"|x_translate}' data-date-format="DD/MM/YYYY" required="required" >

                <input type="text" id="fecha_fin" class="input-group-addon" name="fecha_fin" placeholder='{"Fecha de fin"|x_translate}' data-date-format="DD/MM/YYYY" >

                <img src="{$IMGS}icons/icon-calendar.svg" alt='{"Calendario"|x_translate}'/>

            </div>
        </div>
        <div class="modal-btns">
            <button data-dismiss="modal" id="btnCancelPrescripcion">{"cancelar"|x_translate}</button>
            <button type="submit" onclick ="submitForm()" >{"agregar"|x_translate}</button>
        </div>
    </form>

</div>

<script>
    $(document).ready(function() {

        $("#paciente_idpaciente").val($("#idpaciente").val());

        if ($("#tipoTomaMedicamentos_idtipoTomaMedicamentos").val() != "4") {
            $("#fecha_fin").prop("disabled", true);
        }
        
        $("#idperfilSaludConsulta_win").val($("#idperfilSaludConsulta").val());

        $("#tipoTomaMedicamentos_idtipoTomaMedicamentos").change(function() {
            if ($("#tipoTomaMedicamentos_idtipoTomaMedicamentos").val() != "4") {
                $("#fecha_fin").prop("disabled", true);
                $("#fecha_fin").val("");
            } else {
                $("#fecha_fin").prop("disabled", false);
            }
        });

        $("#fecha_inicio")
                .datetimepicker({
                    pickTime: false,
                    language: 'fr'
                });

        $("#fecha_fin")
                .datetimepicker({
                    pickTime: false,
                    language: 'fr'
                });


        $('#as_nombre_comercial').autocomplete({
            zIndex: 10000,
            serviceUrl: BASE_PATH + 'medico.php?action=1&modulo=perfil_salud&submodulo=medicamentos_autossugest',
            onSelect: function(data) {

                $("#medicamento_idmedicamento").val(data.data);

            }
        });


        renderUI2("modal-medicamentos");

        x_runJS();

    });

    function submitForm() {

        $("#medicamentos_form").validate({
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
                if ($("#medicamento_idmedicamento").val() == "") {
                    x_alert(x_translate("Ingrese medicamento"));
                    return false;
                }

                
                x_sendForm($('#medicamentos_form'), true, function(data) {
                    x_alert(data.msg);
                    if (data.result) {
                        $('#winModal').modal('toggle');
                        x_loadModule('perfil_salud', 'list_medicamentos_consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_medicamentos_consulta', BASE_PATH + "medico");
                    }
                });
            }
        });
    }



</script>
