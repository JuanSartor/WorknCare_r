<div class="col-sm-2 vista-impresion-holder col-2-print">
    {if $consulta.paciente.imagen.perfil != ""}
        <img class="vista-impresion-avatar" src="{$consulta.paciente.imagen.perfil}" alt="{$consulta.paciente.nombre} {$consulta.paciente.apellido}"/>
    {else}
        {if $consulta.paciente.animal!=1}
            <img class="vista-impresion-avatar" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta.paciente.nombre} {$consulta.paciente.apellido}"/>
        {else}
            <img class="vista-impresion-avatar" src="{$IMGS}extranet/noimage-animal.jpg" alt="{$consulta.paciente.nombre} {$consulta.paciente.apellido}"/>
        {/if}
    {/if}
</div>
<div class="col-sm-4 vista-impresion-holder col-4-print">
    <span class="vista-impresion-user-name">{$consulta.paciente.nombre} {$consulta.paciente.apellido}</span>
    <span class="vista-impresion-user-fn"><label>DN</label> {$consulta.paciente.fechaNacimiento_format}</span>
</div>
<div class="col-sm-4 vista-impresion-holder col-4-print">
    {if $consulta.paciente.animal!=1}
        {if $consulta.paciente.pais_idpais==1}
            <span class="vista-impresion-user-name">{"Tarjeta Vitale"|x_translate}</span>
            <span class="vista-impresion-user-pshb">
                <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$consulta.paciente.tarjeta_vitale}
            </span>
        {/if}
        {if $consulta.paciente.pais_idpais==2}
            <span class="vista-impresion-user-name">{"Tarjeta CNS"|x_translate}</span>
            <span class="vista-impresion-user-pshb">
                <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$consulta.paciente.tarjeta_cns}
            </span>
        {/if}
        {if $consulta.paciente.pais_idpais==3}
            <span class="vista-impresion-user-name">{"Tarjeta eID"|x_translate}</span>
            <span class="vista-impresion-user-pshb">
                <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$consulta.paciente.tarjeta_eID}
            </span>
        {/if}
        {if $consulta.paciente.pais_idpais==4}
            <span class="vista-impresion-user-name">{"Pasaporte"|x_translate}</span>
            <span class="vista-impresion-user-pshb">
                <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$consulta.paciente.tarjeta_pasaporte}
            </span>
        {/if}
    {/if}
</div>