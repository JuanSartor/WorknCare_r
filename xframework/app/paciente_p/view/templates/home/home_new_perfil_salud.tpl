{math assign="porcentaje" equation="puntaje_status*100/puntaje_total" puntaje_status=$statusPerfil.puntaje_status puntaje_total=$statusPerfil.puntaje_total format="%.0f"}
{if $wizard_step <9 && $porcentaje!=100 }
    <p class="text-center"><em>{"Termina de completar la información para un seguimiento más personalizado"|x_translate}</em></p>

    <div class="okm-row pul-pi-data-box">
        <div class="col-data">
            <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
            <p>{"Cuestionario médico"|x_translate}</p>
        </div>

        <div class="col-info hidden-xs">
            <figure>{if $porcentaje>100}100{else}{$porcentaje}{/if}%</figure>
        </div>
        
        <div class="col-action">
            <a href="{$url}panel-paciente/wizard_perfil_salud/" class="btn">{"Completar"|x_translate}</a>

        </div>
    </div>
{/if}