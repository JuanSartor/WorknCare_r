<section class="container-fluid">
    <div class="row">
        <div class="col-sm-12 col-md-10 col-md-offset-1">
            <div class="module-subheader">
                <h3>{"Mis prescripciones"|x_translate}</h3>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-mis-prescripciones" id="table_medicamentos">
                    <thead>
                        <tr>
                            <td class="col-wide">{"Medicamento"|x_translate}</td>
                            <td>{"Posología"|x_translate}</td>
                            <td class="date">{"Fecha de inicio"|x_translate}</td>
                            <td class="date">{"Fecha de fin"|x_translate}</td>
                            <td >&nbsp;</td>
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

        </div>
    </div>
    <!--@tabla -->
</section>	

{literal}
    <script>



        x_runJS();
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
                                    //Actualizo la cantidad de medicamentos
                                    x_loadModule('perfil_salud', 'list_medicamentos_consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_medicamentos_consulta', BASE_PATH + "medico");

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

        $("#eliminar_multiple_medicamentos").click(function () {
            var ids = "";

            $.each($(".check_delete_medicamento").find("[type=checkbox]:checked"),
                    function (index, value) {
                        ids += "," + $(this).val();
                        //console.log($(this).val());
                    });

            if (ids.length > 0) {
                ids = ids.substring(1);
            } else {
                $("#cancelar_multiple_files").click();
                x_alert(x_translate("No hay archivos seleccionados"));
                return false;
            }

            $("#table_medicamentos").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'eliminar_multiple_medicamento_medico.do',
                    'ids=' + ids,
                    function (data) {
                        x_alert(data.msg);
                        $("#table_medicamentos").spin(false);
                        if (data.result) {
                            //Actualizo la cantidad de imágenes

                            $.each($(".check_delete_medicamento").find("[type=checkbox]:checked"),
                                    function (index, value) {

                                        $("#tr_medicamento_" + $(this).val()).remove();

                                    });

                        }
                        $("#cancelar_multiple_medicamentos").click();
                    }
            );
        });
    </script>
{/literal}