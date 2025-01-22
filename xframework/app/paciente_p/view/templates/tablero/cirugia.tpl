<article class="col-md-6">
    <div class="card card-yellow grid-overview">
        <div class="card-header">
            <h1 class="card-title">{"Cirugías e intervenciones"|x_translate}</h1>
            <div class="card-value value icon-card" >
                <span class="icon-svg surgery"></span>
            </div>								
        </div>
        <div class="card-body">
            <ul class="listas">
                
                {if $list_cirugias}
                {foreach from=$list_cirugias item=cirugia}
                <li>{if $cirugia@index != 0}<br>{/if}{$cirugia}</li>
                {/foreach}
                {/if}
                
            </ul>
        </div>
        <div class="bottom-data">
            <a href="{$url}panel-paciente/perfil-salud/cirugias-protesis.html" class="edit btn-inverse btn-block dp-edit">{"actualizar"|x_translate}</a>
        </div>						
    </div>
</article>