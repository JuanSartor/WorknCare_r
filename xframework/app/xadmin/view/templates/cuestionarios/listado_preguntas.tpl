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
<div class="title" style="cursor:pointer;margin-bottom: 16px;">Preguntas asignadas</div>
<li class="wide">
    <label>Agregar Pregunta</label>
    <input  id="inputpregunta"  />
    <label>Agregar Pregunta (en)</label>
    <input  id="inputpregunta_en"  />
<li class="right checkbox-inline">
    <label class="">{"Cerrada"|x_translate}</label> 
    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=true  name="cerrada" id="cerrada"}
</li>
<li class="right checkbox-inline">
       <label>Orden</label>
    <input  id="orden"  /> 
</li>
<span class="agregar_pregunta" id="agregar_pregunta_grupo" title="Agregar">+ Agregar</span>

<div class="clear"></div>
<br><br>
<div id="listado_preguntas" {if $listado_preguntas}style="display:block;" {else}style="display:none" {/if}>
    <ul>
        {foreach from=$listado_preguntas item=pregunta}
            <li {if $pregunta.cerrada} data-id="{$pregunta.idpregunta}" {else} data-id="{$pregunta.idpregunta_abierta_cuestionario}" {/if} data-cerrada="{$pregunta.cerrada}"  class="programa"><span class="delete_pregunta" {if $pregunta.cerrada} data-id="{$pregunta.idpregunta}" {else} data-id="{$pregunta.idpregunta_abierta_cuestionario}" {/if} data-cerrada="{$pregunta.cerrada}" title="Eliminar"> X </span> {$pregunta.pregunta}
                {if $pregunta.cerrada} 
                    <span style="position: absolute; left: 850px; color: #ED799E;">{"Cerrada"|x_translate}</span> 
                {else}
                    <span style="position: absolute; left: 850px; color: #3DB4C0;">{"Abierta"|x_translate}</span> 
                {/if}
            </li>
        {/foreach}
    </ul>

</div>

