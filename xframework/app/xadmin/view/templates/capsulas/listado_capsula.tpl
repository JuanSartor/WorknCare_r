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

    .delete_pregunta {
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
<div class="title" style="cursor:pointer;margin-bottom: 16px;">Capsulas asignadas</div>


<div class="clear"></div>
<div id="listado_capsulas" {if $listado_capsulas}style="display:block;" {else}style="display:none" {/if}>
    <ul>
        {foreach from=$listado_capsulas item=cuestionario}
            <li data-id="{$cuestionario.idcapsula}"  class="programa"><span class="delete_capsula delete_pregunta" data-id="{$cuestionario.idcapsula}" title="Eliminar"> X </span> {$cuestionario.titulo}</li>
            {/foreach}
    </ul>

</div>


