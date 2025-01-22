<div class="col-sm-2 vista-impresion-holder col-2-print">
    {if $consulta.paciente.imagen.perfil != ""}
        <img class="vista-impresion-avatar" src="{$consulta.paciente.imagen.perfil}" alt="{$consulta.paciente.nombre} {$consulta.paciente.apellido}"/>
    {else}
        <img class="vista-impresion-avatar" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta.paciente.nombre} {$consulta.paciente.apellido}"/>
    {/if}
</div>
<div class="col-sm-3 vista-impresion-holder col-3-print">
    <span class="vista-impresion-user-name">{$consulta.paciente.nombre} {$consulta.paciente.apellido}</span>
    <span class="vista-impresion-user-fn"><label>DN</label> {$consulta.paciente.fechaNacimiento_format}</span>
</div>

<div class="col-sm-5 vista-impresion-holder col-5-print">
    {if $consulta.paciente.animal!=1}
        {if $consulta.paciente.tarjeta_vitale!=""}
            <span class="vista-impresion-user-pshb">{"Tarjeta Vitale"|x_translate}:
                {$consulta.paciente.tarjeta_vitale}
            </span>
        {/if}

        {if $consulta.paciente.tarjeta_cns!=""}
            <span class="vista-impresion-user-pshb">{"Tarjeta CNS"|x_translate}:
                {$consulta.paciente.tarjeta_cns}
            </span>
        {/if}

        {if $consulta.paciente.tarjeta_eID!=""}
            <span class="vista-impresion-user-pshb">{"Tarjeta eID"|x_translate}:
                {$consulta.paciente.tarjeta_eID}
            </span>
        {/if}
        {if $consulta.paciente.tarjeta_pasaporte!=""}
            <span class="vista-impresion-user-pshb">{"Pasaporte"|x_translate}:
                {$consulta.paciente.tarjeta_pasaporte}
            </span>
        {/if}
    {/if}
</div>
