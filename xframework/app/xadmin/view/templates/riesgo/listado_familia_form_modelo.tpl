<style>
    .agregar_pregunta {
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

    .delete_cuestionario {
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
<div class="title" style="cursor:pointer;margin-bottom: 16px;">Familias Asignadas</div>
<!--<li class="wide">
    <label>Agregar Pregunta</label>
    <input  id="inputpregunta"  />
    <span class="agregar_pregunta" id="agregar_pregunta_grupo" title="Agregar">+ Agregar</span>
</li> -->
<div class="clear"></div>
<div id="listado_cuestionarios" {if $listado_cuestionarios}style="display:block;" {else}style="display:none" {/if}>
    <ul>
        {foreach from=$listado_cuestionarios item=cuestionario}
            <li data-id="{$cuestionario.idfamilia_riesgo}"  class="programa"><span class="delete_cuestionario" data-id="{$cuestionario.idfamilia_riesgo}" data-idmodelo="{$idmodelos_riesgos}" title="Eliminar"> X </span> {$cuestionario.titulo}</li>
            {/foreach}
    </ul>

</div>

