<!-- medicamentos-->
{if $consulta.medicacion_list|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="agregar-prescripcion">
        <div class="form-content">


            <div class="row">
                <div class="">
                    <div class="table-responsive">
                        <table class="table table-striped table-mis-prescripciones mps-table">
                            <thead>
                                <tr>
                                    <td class="col-wide">{"Medicamento"|x_translate}</td>
                                    <td>{"Posología"|x_translate}</td>
                                    <td class="date">{"Fecha de inicio"|x_translate}</td>
                                    <td class="date">{"Fecha de fin"|x_translate}</td>

                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$consulta.medicacion_list item=medicacion}
                                    <tr>
                                        <td>{$medicacion.nombre_comercial}</td>
                                        <td>{$medicacion.posologia}</td>
                                        <td  class="text-center">{$medicacion.fecha_inicio_f}</td>
                                        <td  class="text-center">
                                            {if $medicacion.fecha_fin_f !=""}
                                                {$medicacion.fecha_fin_f}
                                            {elseif $medicacion.tipoTomaMedicamentos_idtipoTomaMedicamentos == 1}
                                                {"Medicación Crónica"|x_translate}
                                            {elseif $medicacion.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                                                {"Temporal"|x_translate}
                                            {/if}
                                        </td>
                                        {*El medico no puede renovar recetas*}

                                    </tr>
                                {foreachelse}
                                    <tr>
                                        <td collspan="5">{"No hay medicamentos para la consulta"|x_translate}</td>
                                    </tr>
                                {/foreach}

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/if}