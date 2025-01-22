            
<ul>
    {foreach from=$listado_pacientes item=paciente}
    <li class="modal-paciente-trg">
        
        {if $paciente.imagen.list != ""}
        <img class="img-circle modal-resultados-imagen"  src="{$paciente.imagen.list}" alt="{$paciente.nombre} {$paciente.apellido}">
        {else}
        <img class="img-circle modal-resultados-imagen" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}">
        {/if}
       
        <h3 class="modal-resultados-nombre" data-idpaciente="{$paciente.idpaciente}" data-sexo="{$paciente.sexo}">{$paciente.nombre} {$paciente.apellido}</h3>
        <span class="modal-resultados-fn">DN {$paciente.fechaNacimiento}</span>
        <span class="modal-resultados-tel">{if $paciente.numeroCelular!=""}{$paciente.numeroCelular}{else}-{/if}</span>
        <span class="modal-resultados-mail">{$paciente.email}</span>
    </li>
    {foreachelse}
    <h4 class="text-center" style="padding-top:80px">{"No se encontraron resultados"|x_translate}</h4>
    {/foreach}

</ul>
