<div class="row tab-buttons">
    <ul class="nav-tabs nav">
        <li class="active">
            <a href="#anotaciones" role="tab" data-toggle="tab">
                <span class="dp-profile"></span><small>{"Conclusión médica"|x_translate}</small>
            </a>
        </li>
        {if ($consulta.estudios_list && $consulta.estudios_list|@count > 0) ||( $consulta.adjuntos_list && $consulta.adjuntos_list|@count > 0)}

            <li>
                <a href="#agregar-archivo" role="tab" data-toggle="tab" title='{"Archivos adjuntos"|x_translate}'>
                    <span class="fui-clip"></span><small>{"Archivos adjuntos"|x_translate}</small>
                </a>
            </li>
        {/if}
        {if $consulta.medicacion_list && $consulta.medicacion_list|@count > 0}
            <li>
                <a href="#agregar-prescripcion" role="tab" data-toggle="tab" class="" title='{"Medicación"|x_translate}'>
                    <span class="dp-medicine"></span><small>{"Medicación"|x_translate}</small>
                </a>
            </li>
        {/if}

        {if $consulta.recetas_list && $consulta.recetas_list|@count > 0}
            <li>
                <a href="#agregar-recetas" role="tab" data-toggle="tab" class="" title='{"Prescripcion"|x_translate}'>
                    <span class="dp-file"></span><small>{"Prescripcion"|x_translate}</small>
                </a>
            </li>
        {/if}


        {if $consulta.consulta_express && $consulta.consulta_express|@count > 0}
            <li>
                <a href="#chat" role="tab" data-toggle="tab" title='{"Mensajes"|x_translate}'>
                    <span class="icon-doctorplus-chat-comment"></span><small>{"Mensajes"|x_translate}</small>
                </a>
            </li>
        {/if}
        {if $consulta.videoconsulta && $consulta.videoconsulta|@count > 0}
            <li>
                <a href="#chat" role="tab" data-toggle="tab" title='{"Mensajes"|x_translate}'>
                    <span class="icon-doctorplus-chat-comment"></span><small>{"Mensajes"|x_translate}</small>
                </a>
            </li>
        {/if}

        <li>
            {if $smarty.request.mis_registros_consultas_medicas!="1"}
                <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registros_consultas_medicas_imprimir/{$consulta.idperfilSaludConsulta}" target="_blank" title='{"Imprimir"|x_translate}'>
                    <span class="dp-print"></span><small>{"Imprimir"|x_translate}</small>
                </a>
            {else}
                <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/mis-registros-consultas-medicas/imprimir/{$consulta.idperfilSaludConsulta}" target="_blank" title='{"Imprimir"|x_translate}'>
                    <span class="dp-print"></span><small>{"Imprimir"|x_translate}</small>
                </a>
            {/if}

        </li>

    </ul>
</div>	