<div class="title" style="cursor:pointer;margin-bottom: 16px;">Médicos referentes</div>
<li class="wide">
    <label>Agregar médico</label>
    <select name="medico_idmedico" id="referente_medico_idmedico" class="">
        <option value="">Seleccionar...</option>

        {html_options options=$combo_medicos_referentes}
    </select>
    <span class="agregar_medico" id="agregar_medico_referente" title="Agregar">+ Agregar</span>
</li>
<div class="clear"></div>
<div id="listado_medicos_referente" {if $listado_medicos_referentes}style="display:block;" {else}style="display:none" {/if}>

    <ul>
        {foreach from=$listado_medicos_referentes item=medico}
            <li data-id="{$medico.idprograma_medico_referente}" data-idmedico="{$medico.medico_idmedico}" class="medico"><span class="delete_medico" data-id="{$medico.idprograma_medico_referente}" title="Eliminar"> X </span> {$medico.tituloprofesional} {$medico.nombre} {$medico.apellido} ({$medico.especialidad})</li>
            {/foreach}
    </ul>
</div>

