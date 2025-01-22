<style>
    .agregar_programa {
        position: absolute;
        overflow: visible;
        display: inline-block;
        padding: 0.5em 1em;
        border: 1px solid #B80C1D;
        border-radius: 5px;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }

    .delete_programa {
        position: relative;
        overflow: visible;
        display: inline-block;
        padding: 0.5em;
        border-radius: 5px;
        border: 1px solid #B80C1D;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }
</style>
<div class="title" style="cursor:pointer;margin-bottom: 16px;">Programas asignados</div>
<li class="wide">
    <label>Agregar Programa</label>
    <select name="programa_idprograma" id="idprograma" class="">
        <option value="">Seleccionar...</option>

        {html_options options=$combo_programas}
    </select>
    <span class="agregar_programa" id="agregar_programa_grupo" title="Agregar">+ Agregar</span>
</li>
<div class="clear"></div>
<div id="listado_programas" {if $listado_programas}style="display:block;" {else}style="display:none" {/if}>
    <ul>
        {foreach from=$listado_programas item=programa}
            <li data-id="{$programa.idprogramas_salud_grupo_asociacion}"  class="programa"><span class="delete_programa" data-id="{$programa.idprogramas_salud_grupo_asociacion}" title="Eliminar"> X </span> {$programa.programa_salud}</li>
            {/foreach}
    </ul>

</div>

