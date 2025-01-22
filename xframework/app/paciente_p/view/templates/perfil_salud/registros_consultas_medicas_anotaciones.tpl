<div role="tabpanel" class="w tab-pane active fade in" id="anotaciones">	
    <div class="form-content">
        <h4>
            <strong>
                {"Conclusión médica"|x_translate}&nbsp;
                {if $consulta.consulta_express && $consulta.consulta_express|@count > 0}
                    {"Consulta Express Nº"|x_translate}{$consulta.numeroConsultaExpress}
                {/if}
                {if $consulta.videoconsulta && $consulta.videoconsulta|@count > 0}
                    {"Video Consulta Nº"|x_translate}{$consulta.numeroVideoConsulta}
                {/if}
            </strong>
        </h4>
        <div class="mps-row">
            <div class="mps-medico-ficha-holder">
                <a href="#" data-toggle="modal" data-target=".modal-medico-perfil">
                    {if $consulta.medico_imagen.list!=""}
                        <img class="mps-medico-img" src="{$consulta.medico_imagen.list}" alt="{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}" style="width:72px">
                    {else}
                        <img class="mps-medico-img" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}" style="width:72px">
                    {/if}
                </a>
                <div class="mps-medico-ficha">
                    <span class="mps-medico-nombre">{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}</span>
                    <span class="mps-medico-especialidad">{$consulta.especialidades.especialidad}</span>
                    <p class="mps-medico-specs"></p>
                </div>

            </div>
            <div class="mps-medico-date">
                <span>{"Fecha"|x_translate}</span> {$consulta.fechaConsulta_format|date_format:'%d/%m/%Y'}
            </div>
        </div>
        {if $consulta.motivoVideoConsulta!="" || $consulta.motivoConsultaExpress!=""}
            <div class="mps-row">
                <div class="mps-data-row">
                    <p>
                        <span class="mps-data-label">
                            {"Motivo"|x_translate}:
                        </span>
                        {if $consulta.motivoVideoConsulta!=""}
                            {$consulta.motivoVideoConsulta}
                        {/if}
                        {if $consulta.motivoConsultaExpress!=""}
                            {$consulta.motivoConsultaExpress}
                        {/if}
                    </p>
                </div>
            </div>
        {/if}

        <div class="mps-row">
            <div class="mps-data-row">
                <p><span class="mps-data-label">{"Diagnóstico"|x_translate}: </span> {$consulta.diagnostico}</p>
            </div>
        </div>

        <div class="mps-row">
            <div class="mps-data-row mps-tratamiento">
                <p><span class="mps-data-label">{"Tratamiento"|x_translate}: </span> {$consulta.tratamiento}</p>
            </div>
        </div>
    </div>					
</div>
<!-- /tab anotaciones -->