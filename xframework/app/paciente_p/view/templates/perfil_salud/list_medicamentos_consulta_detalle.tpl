<div class="col-md-12">
    <div class="table-responsive">
        <table class="table table-striped table-mis-prescripciones">
            <thead>
                <tr>
                    <td class="col-wide">{"Medicamento"|x_translate}</td>
                    <td>{"Posología"|x_translate}</td>
                    <td class="date">{"Inicio"|x_translate}</td>
                    <td class="date">{"Fin"|x_translate}</td>
      
                </tr>
            </thead>
            <tbody>
                {if $list_medicacion_medico}
                {foreach from=$list_medicacion_medico item=medicacion_medico}
                <tr id="tr_medicamento_{$medicacion_medico.idperfilSaludMedicamento}">
                    <td>{$medicacion_medico.nombre_comercial}</td>
                    <td>{$medicacion_medico.posologia}</td>
                    <td>{$medicacion_medico.fecha_inicio_f}</td>
                    <td>{if $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 4}
                        {$medicacion_medico.fecha_fin_f}
                        {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 3}
                        {"Medicación Crónica"|x_translate}
                        {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                        {"Tratamiento Prolongado"|x_translate}
                        {else}
                        {"Única Toma"|x_translate}
                        {/if}
                    </td>
                   
                </tr>								
                {/foreach}
                {/if}

            </tbody>
        </table>
    </div>


   

</div>


{literal}
<script>

    $(document).ready(function() {

    });

    renderUI2("div_medicamentos_consulta");
 
</script>
{/literal}