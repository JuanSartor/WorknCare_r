<div role="tabpanel" class="w tab-pane active fade in" id="anotaciones">	
    <div class="form-content">
        <h4>
            <strong>
                {"Conclusión médica"|x_translate}&nbsp;
                {if $ConsultaExpress} {"Consulta Express Nº"|x_translate}{$ConsultaExpress.numeroConsultaExpress}{/if}
                {if $videoconsulta} {"Video Consulta Nº"|x_translate}{$videoconsulta.numeroVideoConsulta}{/if}
            </strong>
        </h4>
        <form  id="consulta_form" action="{$url}save_consulta_form.do" method="post" onsubmit="return false;">	
            <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
            <input type="hidden" name="idperfilSaludConsulta" id="idperfilSaludConsulta" value="{$record.idperfilSaludConsulta}" />
            <input type="hidden" name="idturno" id="idturno" value="{$turno.idturno}" />

            <div class="row">
                <div class='col-sm-8'>
                    {include file="perfil_salud/consulta_nueva_data_paciente.tpl"}
                </div>
                <div class='col-sm-4'>
                    <div class="date-holder pull-right ui-datepicker-trigger" id="div_date_picker">
                        <input type="text" id="fecha" name="fecha" placeholder='{"Fecha"|x_translate}' value="{$smarty.now|date_format:'%d/%m/%Y'}"/>
                        <img src="{$IMGS}icons/icon-calendar.svg" alt="Calendario"/>
                    </div>
                </div>
            </div>
            <div class="row conclusion-row">
                <div class="col-xs-12">
                    {if $videoconsulta.motivoVideoConsulta.motivoVideoConsulta!=""}
                        <p class="motivo-consulta">{"Motivo"|x_translate}: {$videoconsulta.motivoVideoConsulta.motivoVideoConsulta}</p>
                    {/if}
                    {if $ConsultaExpress.motivoConsultaExpress.motivoConsultaExpress!=""}
                        <p class="motivo-consulta">{"Motivo"|x_translate}: {$ConsultaExpress.motivoConsultaExpress.motivoConsultaExpress}</p>
                    {/if}
                    <p><textarea placeholder='{"Evolucion clínica"|x_translate}'   name="evolucion_clinica" id="evolucion_clinica">{$record.evolucion_clinica}</textarea></p>
                    <p><textarea placeholder='{"Anotaciones"|x_translate}' name="anotacion" id="anotacion">{$record.anotacion}</textarea></p>
                    <div class="row">
                        <div class="col-sm-12 col-md-6 pull-left ">
                            <h5 class="icon-ojo">{"Campos visibles para el paciente"|x_translate}</h5>
                        </div>
                    </div>
                    <p>
                        <input type="hidden" name="importacion_cie10_idimportacion_cie10" id="importacion_cie10_idimportacion_cie10" value="{$record.importacion_cie10_idimportacion_cie10}" >
                        <input type="hidden" name="diagnostico_hidden" id="diagnostico_hidden" value="{$record.diagnostico}" >
                        <input type="text" placeholder='{"Diagnostico"|x_translate}' name="diagnostico" id="diagnostico" value="{$record.diagnostico}" class="icon-ojo">
                    </p>
                    <p><textarea placeholder='{"Tratamiento"|x_translate}' name="tratamiento" id="tratamiento" class="icon-ojo">{$record.tratamiento}</textarea></p>						
                </div>
            </div>
        </form>
    </div>					
</div>
<!-- /tab anotaciones -->