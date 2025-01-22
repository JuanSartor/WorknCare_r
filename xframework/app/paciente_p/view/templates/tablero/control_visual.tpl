
<article class="col-md-6">
    <div class="tablero-default-card card">
        <div class="tablero-card-header">
            <h3>{"Control Visual"|x_translate}</h3>
            <figure class="tablero-card-header-icon">
                <i class="icon-doctorplus-visual"></i>
            </figure>
        </div>
        <div class="tablero-card-body">
            <ul>
                <li><label>{"Usa anteojos"|x_translate}:</label>{if $control_visual.anteojos!=""}{$control_visual.anteojos}{else}-{/if}</li>
                <li><label>{"Cirugía ocular"|x_translate}:</label>{if $control_visual.antecedentes!=""}{$control_visual.antecedentes}{else}-{/if}</li>
                <li><label>{"Patología ocular"|x_translate}:</label>{if $control_visual.patologia_actual!=""}{$control_visual.patologia_actual}{else}-{/if}</li>
            </ul>
        </div>
        
        <div class="bottom-data">
            <button class="edit dp-edit" onclick="window.location.href='{$url}panel-paciente/perfil-salud/control-visual.html'">{"actualizar"|x_translate}</button>
           
        </div>
    </div>
</article>
