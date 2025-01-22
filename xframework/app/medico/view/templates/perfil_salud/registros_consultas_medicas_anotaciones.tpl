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
        <input type="hidden" name="idperfilSaludConsulta" id="idperfilSaludConsulta" value="{$consulta.idperfilSaludConsulta}" />

        <div class="row">
            <div class='col-sm-8'>
                {include file="perfil_salud/consulta_nueva_data_paciente.tpl"}
            </div>
            <div class='col-sm-4'>
                <div class="date-holder pull-right" id="div_date_picker">
                    <label>{$consulta.fecha_format}</label>
                    <img src="{$IMGS}icons/icon-calendar.svg" alt="Calendario"/>
                </div>
            </div>
        </div>
        <div class="row conclusion-row">
            <div class="col-xs-12">
                {if $otro_profesional=="1"}
                    <p>
                        <strong>{"Profesional"|x_translate}: </strong>
                        {$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}
                    </p>
                    <p>
                        <strong>{"Especialidad"|x_translate}: </strong>
                        {$consulta.especialidades.especialidad}
                    </p>
                {/if}
                {if $consulta.motivoVideoConsulta!=""}
                    <p>
                        <strong>{"Motivo"|x_translate}: </strong>
                        {$consulta.motivoVideoConsulta}
                    </p>
                {/if}
                {if $consulta.motivoConsultaExpress!=""}
                    <p>
                        <strong>{"Motivo"|x_translate}: </strong> 
                        {$consulta.motivoConsultaExpress}
                    </p>  
                {/if}
                {if $otro_profesional!="1"}
                    <p> 
                        <strong>{"Evolución clinica"|x_translate}: </strong>
                        {$consulta.evolucion_clinica}
                    </p>
                    <p>
                        <strong>{"Anotaciones"|x_translate}: </strong>
                        {$consulta.anotacion}
                    </p>
                {/if}

                <h5>{"Campos visibles para el paciente"|x_translate} <i class="icon-ojo"></i></h5>
                <p>
                    <strong>{"Diagnóstico"|x_translate}: </strong> 
                    {$consulta.diagnostico}
                </p>
                <p> 
                    <strong>{"Tratamiento"|x_translate}: </strong> 
                    {$consulta.tratamiento}
                </p>						
            </div>	
        </div>	
    </div>					
</div>