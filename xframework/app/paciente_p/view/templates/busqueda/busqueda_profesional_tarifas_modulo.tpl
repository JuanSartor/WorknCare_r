<div id="medico-data-row-{$consultorio.idmedico}" class="medico-data-row">
    <div class="okm-row pbp-planes-row " >
        <!--okm-hidden-->
        <a href="javascript:;" class="pbp-planes-item {if $consultorio.preferencia.valorPinesConsultaExpress==""}no-publica{/if}">
            <div class="pbp-planes-content express ">
                <figure>
                    <i class="icon-doctorplus-chat"></i>
                </figure>
                <h4>{"Consulta Express"|x_translate}</h4>

                {if $consultorio.preferencia.valorPinesConsultaExpress==""}
                    <span class="price">{"No publica"|x_translate}</span>
                {else}

                    {if $consultorio.paciente_sincargo=="1"}
                        <span class="price">{"Bonificado"|x_translate}</span>
                        <div data-id="{$consultorio.idmedico}" class="{if $consultorio.paciente_sincargo=="1"}select-profesional-frecuente-ce{/if} pbp-planes-action2">
                            <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                        </div>
                    {else}
                        {if $consultorio.consultaexpress_solo_pacientes=="1"}
                            <span class="price"></span>
                            <div data-id="{$consultorio.idmedico}" class="consultaexpress_solo_pacientes pbp-planes-action2">
                                <span>{"No disponible"|x_translate}</span>
                            </div>
                        {else}
                            {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0 && $consultorio.medico_bonificado==1}
                                {*paciente empresa*}
                                <span class="price">{"Gratuita"|x_translate}</span>
                            {else}
                                {*paciente comun*}
                                <span class="price">&euro; {$consultorio.preferencia.valorPinesConsultaExpress}</span>
                            {/if} 
                            <div data-id="{$consultorio.idmedico}" class="{if $consultorio.preferencia.valorPinesConsultaExpress!=""}select-profesional-frecuente-ce{/if} pbp-planes-action2">
                                <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {/if} 
                    {/if} 
                {/if}
            </div>
        </a>

        <a href="javascript:;" class="pbp-planes-item {if $consultorio.preferencia.valorPinesVideoConsulta==""}no-publica{/if}">
            <div class="pbp-planes-content vc-demanda {if $paciente.pais_idpais==1 && $consultorio.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $consultorio.medico_cabecera==1))} bg-reintegro{/if}">
                <figure>
                    <i class="icon-doctorplus-video-cam"></i>
                </figure>
                <h4>{"Video Consulta"|x_translate}<span><em>{"(inmediata)"|x_translate}</em></span></h4>
                {if $consultorio.preferencia.valorPinesVideoConsulta==""}
                    <span class="price">{"No publica"|x_translate}</span>
                {else}
                    {if $consultorio.videoconsulta_solo_pacientes=="1"}
                        <span class="price"></span>
                        <div data-id="{$consultorio.idmedico}" class="videoconsulta_solo_pacientes pbp-planes-action2">
                            <span>{"No disponible"|x_translate}</span>
                        </div>
                    {else}
                        {if ($paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $consultorio.medico_bonificado==1) || ($recompensa =='1')}
                            {*paciente empresa*}
                            <span class="price">{"Gratuita"|x_translate}</span>
                        {else}
                            {*paciente comun*}
                            <span class="price">&euro; {$consultorio.preferencia.valorPinesVideoConsulta}</span>
                        {/if}
                        <div data-id="{$consultorio.idmedico}" class="{if $consultorio.preferencia.valorPinesVideoConsulta!=""}select-profesional-frecuente-vc{/if} pbp-planes-action2">
                            <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                        </div>
                    {/if}
                {/if}
            </div>
        </a>

        <a href="javascript:;"  class="pbp-planes-item sacar-turno-vc  {if $consultorio.preferencia.valorPinesVideoConsultaTurno==""}no-publica{/if}" data-idmedico="{$consultorio.idmedico}">
            <div class="pbp-planes-content vc-turno {if $paciente.pais_idpais==1 &&  $consultorio.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $consultorio.medico_cabecera==1))}bg-reintegro{/if}"  >
                <figure>
                    <i class="icon-doctorplus-video-call"></i>
                </figure>
                <h4>{"Video Consulta"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>
                {if $consultorio.preferencia.valorPinesVideoConsultaTurno==""}
                    <span class="price">{"No publica"|x_translate}</span>

                {else}
                    {if $consultorio.videoconsulta_solo_pacientes=="1"}
                        <span class="price"></span>
                        <div data-id="{$consultorio.idmedico}" class="videoconsulta_solo_pacientes pbp-planes-action2">
                            <span>{"No disponible"|x_translate}</span>
                        </div>
                    {else}
                        {if ($paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $consultorio.medico_bonificado==1) || ($recompensa =='1')}
                            {*paciente empresa*}
                            <span class="price">{"Gratuita"|x_translate}</span>
                        {else}
                            {*paciente comun*}
                            <span class="price">&euro; {$consultorio.preferencia.valorPinesVideoConsultaTurno}</span>
                        {/if}
                        <div class="pbp-planes-action2">
                            <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                        </div>
                    {/if}
                {/if}
            </div>
        </a>

        <a href="javascript:;"  class="pbp-planes-item sacar-turno-presencial" data-idmedico="{$consultorio.idmedico}">
            <div class="pbp-planes-content presencial">
                <figure>
                    <i class="icon-doctorplus-ficha-check"></i>
                </figure>
                <h4>{"Consulta presencial"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>
                {if $consultorio.preferencia.sector.sector==""}
                    {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $consultorio.medico_bonificado==1}
                        {*paciente empresa*}
                        <span class="price">{"Gratuita"|x_translate}</span>
                    {else}
                        <span class="price">{"No publica"|x_translate}</span>
                    {/if}
                    <div class="pbp-planes-action2">
                        <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                    </div>
                {else}
                    {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $consultorio.medico_bonificado==1}
                        {*paciente empresa*}
                        <span class="price">{"Gratuita"|x_translate}</span>
                    {else}
                        <span class="price">{$consultorio.preferencia.sector.sector}</span> 
                    {/if}
                    <div class="pbp-planes-action2">
                        <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                    </div>
                {/if}
            </div>
        </a>
    </div>

    <div class="clearfix"></div>
</div>