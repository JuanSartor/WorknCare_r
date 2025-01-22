
<div role="tabpanel" class="w tab-pane fade" id="agregar-prescripcion">
    <div class="form-content">
        <form id="medicamentos_form" class="medicamentos-form" action="{$url}save_medicamentos.do" method="post" onsubmit="return false;">
            <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" value="{$record.idperfilSaludConsulta}" />
            <input type="hidden" id="medicamento_idmedicamento" name="medicamento_idmedicamento" value=""/>
            <input type="hidden" name="nombre_medicamento_hidden" id="nombre_medicamento_hidden"  value="">

            <h4><strong>{"Medicación"|x_translate}</strong> <em>({"Opcional"|x_translate})</em></h4>
            <div class="row">
                <div class="col-xs-12">
                    <input type="text" placeholder='{"Medicamento"|x_translate}' name="nombre_medicamento" id="nombre_medicamento"  value="">
                </div>
            </div>		
            <div class="row">
                <div class="col-xs-12">
                    <input type="text" placeholder='{"Posología"|x_translate}' name="posologia" id="posologia" value="{$medicamento.posologia}">
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <select name="tipoTomaMedicamentos_idtipoTomaMedicamentos" id="tipoTomaMedicamentos_idtipoTomaMedicamentos" class="form-control select select-inverse select-block">
                        {html_options options=$combo_tipo_toma_medicamento selected=$medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos}
                    </select>
                </div>

                <div class="col-sm-4">
                    <div class="date-holder ui-datepicker-trigger">
                        <input type="text" id="medicamento_fecha_inicio" name="fecha_inicio"  data-date-format="DD/MM/YYYY" />
                        <img src="{$IMGS}icons/icon-calendar.svg" />
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="date-holder ui-datepicker-trigger">
                        <input type="text" id="medicamento_fecha_fin" name="fecha_fin" data-date-format="DD/MM/YYYY"/>
                        <img src="{$IMGS}icons/icon-calendar.svg" />
                    </div>
                </div>
            </div>


            <div class="clearfix">&nbsp;</div>
            <div class="text-center" style="margin:20px">
                <a href="javascript:;" class="btn btn-primary guardar-btn" id="savePrescripcionForm"><span class="fui-plus"></span> {"Agregar"|x_translate}</a>
            </div>
        </form>
        <div class="clearfix">&nbsp;</div>


        <div class="row" id="div_medicamentos_consulta">
        </div>

        {literal}
            <script>
                $(document).ready(function () {
                    x_loadModule('perfil_salud', 'list_medicamentos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_medicamentos_consulta', BASE_PATH + "medico");
                });
            </script>
        {/literal}

        <div class="text-center">
            <p>{"Le puede interesar guardar asiento el contenido de la receta copiando la información de su software de prescripción medica."|x_translate}</p> 
            <p>{"Podrá tener mejor seguimiento de su paciente ya que esos datos se encontraran en sus registros médicos en forma estructurada."|x_translate}</p>
        </div>
        <div class="clearfix">&nbsp;</div>
    </div>
</div>
<!-- /tab medicación -->
{literal}
    <script>
        $(function () {
            /*Guarar medicamento*/
            $("#savePrescripcionForm").click(function () {
                $("#medicamentos_form .required").removeClass("required");
                if ($("#nombre_medicamento").val() === "") {
                    x_alert(x_translate("Ingrese un medicamento y su posología"));
                    $("#nombre_medicamento").addClass("required");
                    return false;
                }
                if ($("#posologia").val() === "") {
                    x_alert(x_translate("Ingrese un medicamento y su posología"));
                    $("#posologia").addClass("required");
                    return false;
                }

                //verificar fecha 
                if ($("#medicamento_fecha_inicio").val() !== "") {
                    if ($("#medicamento_fecha_inicio").val().length !== 10 || (typeof (validatedate) === "function" && !validatedate($("#medicamento_fecha_inicio").val()))) {
                        x_alert(x_translate("Error. verifique la fecha ingresada"));
                        $("#medicamento_fecha_inicio").parent().addClass("required");
                        return false;
                    }
                }
                //verificar fecha 
                if ($("#medicamento_fecha_fin").val() !== "") {
                    if ($("#medicamento_fecha_fin").val().length !== 10 || (typeof (validatedate) === "function" && !validatedate($("#medicamento_fecha_fin").val()))) {
                        x_alert(x_translate("Error. verifique la fecha ingresada"));
                        $("#medicamento_fecha_fin").parent().addClass("required");
                        return false;
                    }
                }
                x_sendForm($('#medicamentos_form'), true, function (data) {

                    x_alert(data.msg);
                    if (data.result) {

                        x_loadModule('perfil_salud', 'list_medicamentos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_medicamentos_consulta', BASE_PATH + "medico");
                        $("#medicamento_idmedicamento, #nombre_medicamento_hidden, #nombre_medicamento, #posologia, #medicamento_fecha_inicio, #medicamento_fecha_fin").val("");
                    }
                });

            });

        });
    </script>
{/literal}