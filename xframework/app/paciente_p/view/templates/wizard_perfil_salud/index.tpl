<div id="wizard_perfil_salud">
    <div class="okm-row text-center" style="margin-top:40px">
        <a href="{$url}panel-paciente/informacion-paciente/" class=" selector-urs-circle picture  "  title="{$paciente.nombre} {$paciente.apellido}"  style="width: 104px;">
            <figure>

                {if $paciente.image.perfil != ""}
                <img src="{$paciente.image.perfil}" title="{$paciente.nombre} {$paciente.apellido}"/>
                {else}
                <img src="{$IMGS}extranet/noimage-paciente.jpg" title="{$paciente.nombre} {$paciente.apellido}"/>
                {/if}
            </figure>
            <span>{$paciente.nombre} {$paciente.apellido}</span>

        </a>
    </div>
    <div class="okm-row text-center">
        <h6  style="color: #283e73;">{"Algunas preguntas para su médico"|x_translate}</h6>
        <h7>{"... y ganar tiempo para sus próximas consultas"|x_translate}</h7>
    </div>

    <div id="div_wizzard_step"> 
        {include file='wizard_perfil_salud/wizard_step_'|cat:$wizard_step|cat:'.tpl'}

    </div>
</div>
