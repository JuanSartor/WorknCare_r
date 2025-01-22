{if $list_medicacion_medico && $list_medicacion_medico|@count > 0}

        <div class="table-responsive">
            <table class="table table-striped table-mis-prescripciones">
                <thead>
                    <tr>
                        <td class="col-wide">{"Medicamento"|x_translate}</td>
                        <td>{"Posología"|x_translate}</td>
                        <td class="date">{"Fecha de inicio"|x_translate}</td>
                        <td class="date">{"Fecha de fin"|x_translate}</td>
                        <td></td>
                    </tr>
                </thead>
                <tbody>
                    {if $list_medicacion_medico}
                        {foreach from=$list_medicacion_medico item=medicacion_medico}
                            <tr id="tr_medicamento_{$medicacion_medico.idperfilSaludMedicamento}">
                                <td>{$medicacion_medico.nombre_comercial}</td>
                                <td>{$medicacion_medico.posologia}</td>
                                <td class="text-center">{$medicacion_medico.fecha_inicio_f}</td>
                                <td class="text-center">
                                    {if $medicacion_medico.fecha_fin_f !=""}
                                        {$medicacion_medico.fecha_fin_f}
                                    {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 1}
                                        {"Medicación Crónica"|x_translate}
                                    {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                                        {"Temporal"|x_translate}
                                    {/if}
                                </td>

                                <td class="text-center check_delete">
                                    <button class="eliminar-medicamento" title='{"Eliminar"|x_translate}' data-id="{$medicacion_medico.idperfilSaludMedicamento}">
                                        <span class="fui-trash"></span>&nbsp;<span class="hidden-xs">{"Eliminar"|x_translate}</span>
                                    </button>
                                </td>
                            </tr>								
                        {/foreach}
                    {/if}

                </tbody>
            </table>
        </div>

 

    {literal}
        <script>

            $(document).ready(function () {




                renderUI2("div_medicamentos_consulta");
                $(".eliminar-medicamento").click(function () {
                    var id = $(this).data("id");

                 

                    jConfirm({
                        title: x_translate("Eliminar medicamentos"),
                        text: x_translate('Desea eliminar los medicamentos seleccionados?'),
                        confirm: function () {
                            $("body").spin("large");

                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_multiple_medicamento_medico.do',
                                    'ids=' + id,
                                    function (data) {

                                        $("body").spin(false);
                                        if (data.result) {
                                            //Actualizo la cantidad de imágenes
                                            x_loadModule('perfil_salud', 'list_medicamentos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_medicamentos_consulta', BASE_PATH + "medico");
                                        } else {
                                            x_alert(data.msg);
                                        }

                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                });
            });
        </script>
    {/literal}
{/if}