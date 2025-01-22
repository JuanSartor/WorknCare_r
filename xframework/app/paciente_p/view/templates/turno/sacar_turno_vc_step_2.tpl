{include file="turno/pasos_turno.tpl"}
<!--	@PASOS NAV-->

<!--	content-->
<section class="okm-container">
    <div class="okm-row">
        <div class="bst-col">
            <h2>{"Datos del profesional"|x_translate}</h2>
            <div class="bst-box medico">
                <ul>
                    <li>
                        <a target="_blank" href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html?from_busqueda=1">
                            <figure><i class="icon-doctorplus-usr-add"></i></figure>
                            <div class="bst-usr-data">
                                <h3>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</h3>
                                <span>{$medico.mis_especialidades.0.especialidad}</span>
                                {if $paciente.pais_idpais==1 && $medico.pais_idpais==1}
                                    {if $medico.preferencia.sector.sector!=""}
                                        <h3>{$medico.preferencia.sector.sector}</h3>
                                    {/if}       
                                {else}
                                    <h3>{$medico.pais_medico}</h3>                      
                                {/if}
                                {if $medico.medico_cabecera==1}
                                    <h3 style="color:#F23243">{"Médico de cabecera"|x_translate}</h3>
                                {/if}


                            </div>
                        </a>
                    </li>
                    <li>
                        <figure><i class="icon-doctorplus-calendar"></i></figure>
                        <div class="bst-usr-data">
                            <p class="date">{$turno.fechaTurno_format} - <strong>{$turno.horarioTurno_format} {"hs"|x_translate}</strong></p>
                        </div>
                    </li>
                    <li>
                        <figure><i class="icon-doctorplus-video-call"></i></figure>
                        <div class="bst-usr-data">
                            <p>{"Consultorio Virtual"|x_translate}</p>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="bst-col">
            <h2>{"Datos del  paciente"|x_translate}</h2>
            <div class="bst-box cobertura bst-paso2-data-list">
                <ul class="cobertura-data-list bst-medico-data-list">
                    <li>
                        <label>{"Paciente"|x_translate}<span> </span></label>
                        <p>{$paciente.nombre} {$paciente.apellido}</p>
                    </li>
                    <li>
                        <label>{"Motivo"|x_translate}<span> </span></label>
                        <p>{$motivo_videoconsulta.motivoVideoConsulta}</p>
                    </li>
                    <li>
                        <label>{"Mail"|x_translate}</label>
                        <p>{if $paciente.email} {$paciente.email} {else} - {/if}</p>
                    </li>
                    <li>
                        <label>{"Reintegro"|x_translate}</label>
                        <p>
                            {if $turno.beneficia_reintegro==1}
                                {"Recibirá una notificación cuando su médico confirme que envío a la caja los datos de su consulta"|x_translate}
                            {else}
                                {"Pagaré en forma particular"|x_translate}
                            {/if}
                        </p>
                    </li>

                </ul>
            </div>
        </div>
    </div>
</section>

{if $account.paciente.celularValido != 1 && $account.paciente.numeroCelular != ""}
    <section class="bst-validar-cel">
        <div class="bst-validar-cel-box">
            <div class="okm-row bst-cel-inner-box">
                <span class="cel-number-label">{"Celular"|x_translate}</span>
                <span class="cel-number">{$paciente.numeroCelular}</span>
                <div class="bst-cel-tooltip">
                    {"Celular no validado"|x_translate}
                    <span class="bst-cel-tooltip-arrrow"></span>
                </div>
            </div>

            <div class="okm-row">
                <p class="bst-validar-cel-disclaimer">{"Para que le enviemos mensajes recordatorios o cancelaciones gratis de sus turnos,  ingrese el código que le enviamos por mensaje de texto (SMS) al número:"|x_translate} {$paciente.numeroCelular}. 
                    {"Para que le enviemos nuevamente el código haga clic"|x_translate} <a href="javascript:;" id="generateCodigoCelular">{"AQUI"|x_translate}</a>
                </p>
            </div>

            <div class="okm-row">
                <div class="bst-cel-validar-slide-1">

                    <span>{"Ingrese el código"|x_translate}</span>
                    <input type="text" name="codigoValidacionCelular" id="codigo"/>
                    <button class="btn-default bst-validar-trigger" id="validarCodigoCelular">{"Validar"|x_translate}</button>

                </div>
                <div class="bst-cel-validar-slide-2">
                    <figure><i class="icon-doctorplus-sms"></i></figure>
                    <p>{"¡Su celular se encuentra validado!"|x_translate}</p>
                    <span>{"Ahora podrá recibir alertas y avisos por sms"|x_translate}</span>
                </div>
            </div>
        </div>
    </section>
{/if}


<section class="okm-container">
    <div class="okm-row ce-nc-p3-monto-btns-holder">
        <button href="javascript:;" id="btn_back" class="btn btn-secondary">{"volver"|x_translate}</button>
        <button href="javascript:;" id="btn_confirmar"  class="btn btn-default">{"confirmar"|x_translate}</button>
    </div>
    <div class="okm-row ce-nc-p3-monto-btns-holder">
        <a href="javascript:;" id="btnCancelar" class="btn btn-cancel"><i class="icon-doctorplus-cruz"></i> {"Cancelar turno"|x_translate}</a>
    </div>
</section>
