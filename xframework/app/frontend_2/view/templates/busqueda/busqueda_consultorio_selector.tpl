<div class="pnb-consultorios-holder">
    {if $consultorio.posee_consultorio_virtual==1}
    <div class="pbp-tiene-consultorio-virtual">
        {if $paciente.pais_idpais==1 && $consultorio.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $consultorio.medico_cabecera==1))}
        <figure id="msg_consulta_reintegro">{"¡Consulta con reintegro!"|x_translate}</figure>
        {else}
        <figure>{"¡Posee Consultorio Virtual!"|x_translate}</figure>
        {/if}
    </div>
    {/if}
    <!-- Nav tabs -->
    <ul class="nav nav-tabs pbp-consultorio-tabs" role="tablist">

        <li role="presentation" class="active">
            <a href="#consultorio-{$consultorio.idconsultorio}-{$consultorio.idconsultorio}" aria-controls="consultorio-{$consultorio.idconsultorio}"
               role="tab" data-toggle="tab" data-idconsultorio="{$consultorio.idconsultorio}" data-idconsultorio_to_change="{$consultorio.idconsultorio}"
               data-idmedico="{$consultorio.idmedico}" class="change_consultorio {if $consultorio.is_virtual != 1}presencial{else}virtual{/if}">
                {if $consultorio.is_virtual != 1}
                <i class="icon-doctorplus-map-plus-rounded"></i>
                {else}
                <i class="icon-doctorplus-consultorio-virtual"></i>
                {/if}
                <span class="arrow"></span>
            </a>
        </li>
        {foreach from=$consultorio.list_consultorios item=otro_consultorio} 
        {if $otro_consultorio.is_virtual != 1}
        <li role="presentation">
            <a href="#consultorio-{$consultorio.idconsultorio}-{$otro_consultorio.idconsultorio}" aria-controls="consultorio-{$consultorio.idconsultorio}-{$otro_consultorio.idconsultorio}"
               role="tab" data-toggle="tab" data-idconsultorio="{$consultorio.idconsultorio}" data-idconsultorio_to_change="{$otro_consultorio.idconsultorio}"
               data-idmedico="{$consultorio.idmedico}" class="change_consultorio presencial">
                <i class="icon-doctorplus-map-plus-rounded"></i>
                <span class="arrow"></span>
            </a>
        </li>
        {else}
        <li role="presentation">
            <a href="#consultorio-{$consultorio.idconsultorio}-{$otro_consultorio.idconsultorio}" aria-controls="consultorio-{$consultorio.idconsultorio}-{$otro_consultorio.idconsultorio}"
               role="tab" data-toggle="tab" data-idconsultorio="{$consultorio.idconsultorio}" data-idconsultorio_to_change="{$otro_consultorio.idconsultorio}"
               data-idmedico="{$consultorio.idmedico}" class="change_consultorio virtual">
                <i class="icon-doctorplus-consultorio-virtual"></i>
                <span class="arrow"></span>
            </a>
        </li>
        {/if} {/foreach}
    </ul>

    <!-- Tab panes -->
    <div class="tab-content pbp-consultorio-tabs-content">
        {if $consultorio.idconsultorio!=""}
        <div role="tabpanel" class="tab-pane active" id="consultorio-{$consultorio.idconsultorio}-{$consultorio.idconsultorio}">
            {if $consultorio.is_virtual != 1}
            <span>{"Consultorio Físico"|x_translate} - {$consultorio.direccion|lower|ucfirst} {$consultorio.numero}, {$consultorio.localidad|lower|ucfirst}, {$consultorio.pais}</span>
            {else}
            <span>{"Consultorio Virtual"|x_translate}</span>
            {/if}
        </div>

        {foreach from=$consultorio.list_consultorios item=otro_consultorio}
        <div role="tabpanel" class="tab-pane" id="consultorio-{$consultorio.idconsultorio}-{$otro_consultorio.idconsultorio}">
            {if $otro_consultorio.is_virtual == 1}
            <span>
               {"Consultorio Virtual"|x_translate}
            </span>
            {else}
            <span>
                {"Consultorio Físico"|x_translate} - {$otro_consultorio.direccion|lower|ucfirst} {$otro_consultorio.numero}, {$otro_consultorio.localidad|lower|ucfirst},
                {$otro_consultorio.pais}
            </span>

            {/if}
        </div>
        {/foreach} {else}
        <div role="tabpanel" class="tab-pane active">

            <span>{"No posee consultorio"|x_translate}</span>

        </div>
        {/if}

    </div>

</div>