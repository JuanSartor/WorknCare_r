
<section>
    <div class="okm-container">
        <div class="cs-nc-p2-medicos-fav-header">
            <figure class="green">
                <i class="icon-doctorplus-user-add-like"></i>
            </figure>
            <h3>{"Médicos frecuentes"|x_translate}</h3>
        </div>
        {if $medicos_list && $medicos_list|@count > 0}
            <div class="okm-row">
                {foreach item=medico from=$medicos_list}
                    {include file="profesionalesfrecuentes/profesional_item_modulo.tpl"}
                {/foreach}
            </div>

        {else}
            <div class="sin-registros-cs">      
                <p>{"No registra Profesionales Frecuentes asociados al paciente"|x_translate}</p>
            </div>	
        {/if}

    </div>

</section>

