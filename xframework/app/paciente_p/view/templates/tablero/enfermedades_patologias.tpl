<article class="col-md-6">
    <div class="card card-blue grid-overview patologias">
        <div class="card-header">
            <h1 class="card-title">{"Enfermedades y patologías"|x_translate}</h1>
            <div class="card-value value icon-card" >
                <span class="icon-svg patology"></span>
            </div>									
        </div>
        <div class="card-body">
            <ul class="listas">
                {if $list_patologias_actuales}
                {foreach from=$list_patologias_actuales item=value}
                <li>{$value}</li>
                {/foreach}
                {/if}
                {if $list_enfermedades_actuales}
                {foreach from=$list_enfermedades_actuales item=value}
                <li>{$value}</li>
                {/foreach}
                {/if}
            </ul>
        </div>
        <div class="bottom-data">
            <a href="{$url}panel-paciente/perfil-salud/enfermedades-patologias.html" class="edit btn-inverse btn-block dp-edit">{"actualizar"|x_translate}</a>
        </div>							
    </div>
</article>