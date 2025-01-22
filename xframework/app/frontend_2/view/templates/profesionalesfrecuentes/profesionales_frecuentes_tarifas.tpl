<div class="pbp-card">
    <div class="pbp-card-inner">
        {*mensaje medico vacaciones*}
        {if $medico.vacaciones.hasta!=""}
            <div class="vacaciones-turno-wrapper full">
                <p>{"Profesional de vacaciones"|x_translate}</p>
                <p>{"Responderá sus consultas luego del"|x_translate}&nbsp;{$medico.vacaciones.hasta_format}</p>
            </div>
        {/if}
        <h3>
            <i class="icon-doctorplus-maletin"></i>
            <strong> {"Servicios y tarifas"|x_translate}</strong>
            <span class="pull-down pull-right"><i class="fa fa-chevron-down"></i></span>
        </h3>
        <div class="pbp-card-slide">

            <div class="okm-row pbp-planes-row " >
                <!--okm-hidden-->
                <a href="javascript:;" class="pbp-planes-item  {if $medico.preferencia.valorPinesConsultaExpress==""}no-publica{/if}">
                    <div class="pbp-planes-content express">
                        <figure>
                            <i class="icon-doctorplus-chat"></i>
                        </figure>
                        <h4>{"Consulta Express"|x_translate}</h4>

                        {if $medico.preferencia.valorPinesConsultaExpress==""}
                            <span class="price">{"No publica"|x_translate}</span>
                        {else}
                            {if $consultorio.paciente_sincargo=="1"}
                                <span class="price">{"Bonificado"|x_translate}</span>
                                <div data-id="{$medico.idmedico}" class="{if $consultorio.paciente_sincargo=="1"}select-profesional-frecuente-ce{/if} pbp-planes-action2">
                                    <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                                </div>
                            {else}
                                {if $consultorio.consultaexpress_solo_pacientes=="1"}
                                    <span class="price"></span>
                                    <div data-id="{$medico.idmedico}" class="consultaexpress_solo_pacientes pbp-planes-action2">
                                        <span>{"No disponible"|x_translate}</span>
                                    </div>
                                {else}
                                    <span class="price">&euro; {$medico.preferencia.valorPinesConsultaExpress}</span>
                                    <div data-id="{$medico.idmedico}" class="{if $medico.preferencia.valorPinesConsultaExpress!=""}select-profesional-frecuente-ce{/if} pbp-planes-action2">
                                        <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                                    </div>
                                {/if} 
                            {/if} 
                        {/if}
                    </div>
                </a>

                <a href="javascript:;" class="pbp-planes-item {if $medico.preferencia.valorPinesVideoConsulta==""}no-publica{/if}" >
                    <div class="pbp-planes-content vc-demanda {if $paciente.pais_idpais==1 && $consultorio.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $consultorio.medico_cabecera==1))} bg-reintegro{/if}">
                        <figure>
                            <i class="icon-doctorplus-video-cam"></i>
                        </figure>
                        <h4>{"Video Consulta"|x_translate}<span><em>{"(inmediata)"|x_translate}</em></span></h4>
                        {if $medico.preferencia.valorPinesVideoConsulta==""}
                            <span class="price">{"No publica"|x_translate}</span>
                        {else}
                            {if $consultorio.videoconsulta_solo_pacientes=="1"}
                                <span class="price"></span>
                                <div data-id="{$medico.idmedico}" class="videoconsulta_solo_pacientes pbp-planes-action2">
                                    <span>{"No disponible"|x_translate}</span>
                                </div>
                            {else}
                                <span class="price">&euro; {$medico.preferencia.valorPinesVideoConsulta}</span>
                                <div data-id="{$medico.idmedico}" class="{if $medico.preferencia.valorPinesVideoConsulta!=""}select-profesional-frecuente-vc{/if} pbp-planes-action2">
                                    <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                                </div>
                            {/if}
                        {/if}
                    </div>
                </a>

                <a href="javascript:;"  class="pbp-planes-item sacar-turno-vc {if $medico.preferencia.valorPinesVideoConsultaTurno==""}no-publica{/if}" data-idmedico="{$medico.idmedico}" data-target="virtual">
                    <div class="pbp-planes-content vc-turno {if $paciente.pais_idpais==1 &&  $consultorio.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $consultorio.medico_cabecera==1))}bg-reintegro{/if}"  >
                        <figure>
                            <i class="icon-doctorplus-video-call"></i>
                        </figure>
                        <h4>{"Video Consulta"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>
                        {if $medico.preferencia.valorPinesVideoConsultaTurno==""}
                            <span class="price">{"No publica"|x_translate}</span>
                        {else}
                            {if $consultorio.videoconsulta_solo_pacientes=="1"}
                                <span class="price"></span>
                                <div data-id="{$medico.idmedico}" class="videoconsulta_solo_pacientes pbp-planes-action2">
                                    <span>{"No disponible"|x_translate}</span>
                                </div>
                            {else}
                                <span class="price">&euro; {$medico.preferencia.valorPinesVideoConsultaTurno}</span>
                                <div class="pbp-planes-action2">
                                    <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                                </div>
                            {/if}
                        {/if}
                    </div>
                </a>

                <a href="javascript:;"  class="pbp-planes-item sacar-turno-presencial" data-idmedico="{$medico.idmedico}" data-target="presencial">
                    <div class="pbp-planes-content presencial">
                        <figure>
                            <i class="icon-doctorplus-ficha-check"></i>
                        </figure>
                        <h4>{"Consulta presencial"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>
                        {if $medico.preferencia.sector.sector==""}
                            <span class="price">{"No publica"|x_translate}</span>
                            <div class="pbp-planes-action2">
                                <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {else}
                            <span class="price">{$medico.preferencia.sector.sector}</span>
                            <div class="pbp-planes-action2">
                                <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {/if}
                    </div>
                </a>
            </div>

        </div>

    </div>
</div>