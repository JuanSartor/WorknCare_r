{if $horarios}
{foreach from=$horarios item=horario}
<div class="scheduled">
    <span class="time">{$horario.desde|date_format:"%H:%M"}</span>
    <span>a</span>
    <span class="time">{$horario.hasta|date_format:"%H:%M"}</span>
    <a href="javascript:;" data-id="{$horario.idconfiguracionAgenda}" class="delete fui-trash trash pull-right" title='{"Eliminar"|x_translate}'></a>
    {*<button class="fui-trash trash pull-right"></button>*}
</div>
{/foreach}
{/if}