<article class="col-md-6">
    <div class="card card-pink-dark grid-overview">
        <div class="card-header">
            <h1 class="card-title">{"Alergias"|x_translate}</h1>
            <div class="card-value value icon-card" >
                <span class="icon-svg allergy"></span>
            </div>								
        </div>
        <div class="card-body">
            <ul class="listas">
                {foreach from=$list_alergias item=alergia}
                <li>{$alergia}</li>
                {/foreach}
            </ul>
        </div>
        <div class="bottom-data">
            <a href="{$url}panel-paciente/perfil-salud/alergias-intolerancias.html" class="edit btn-inverse btn-block dp-edit">{"actualizar"|x_translate}</a>
        </div>							
    </div>
</article>