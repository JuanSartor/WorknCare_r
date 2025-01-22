<div class="okm-row medico-result-item" data-idmedico="{$medico.idmedico}">
    {*mensaje medico vacaciones*}
    {if $medico.vacaciones.hasta!=""}
        <div class="vacaciones-turno-wrapper ">
            <p>{"Profesional de vacaciones"|x_translate}</p>
            <p>{"Responderá sus consultas luego del"|x_translate}&nbsp;{$medico.vacaciones.hasta_format}</p>
        </div>
    {/if}
    <div class="pbn-col-profesional">

        <div class="gnlist-profesional-holder">
            <div class="okm-row gnlist-profesional-row">
                <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                    <figure class="gnlist-usr-avatar">                        
                        {if !$medico.imagen}
                            <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                        {else}
                            <img src="{$path_files}/entities/medicos/{$medico.idmedico}/{$medico.idmedico}_list.jpg" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                        {/if}
                    </figure>
                </a>
                <a class="btnEliminarMedicos" href="javascript:;" data-idmedico="{$medico.idmedico}" role="button">
                    <i class="icon-doctorplus-trash"></i> {"Eliminar"|x_translate}
                </a>
                {* <label class="checkbox">
                <input type="checkbox" class="check_delete_profesional" data-toggle="checkbox" value="{$medico.idmedico}">                           
                </label>
                *}
            </div>
        </div>
        <div class="gnlist-usr-data-holder">

            <h3>
                <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                    {$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}
                </a>
            </h3>
            <h4>{$medico.especialidad.0.especialidad}</h4>
            <div class="usr-data-content">
                {if $paciente.pais_idpais!=1}
                    <h3>{$medico.pais_medico}</h3>
                {else}
                    {if $medico.preferencia.sector.sector!=""}
                        <h3>{$medico.preferencia.sector.sector}</h3>
                    {else}
                        <h3>{$medico.pais_medico}</p>
                        {/if}                                      
                    {/if}

                    {if $medico.medico_cabecera==1}
                        <h3 style="color:#ff6f6f;">{"Médico de cabecera"|x_translate} <a href="javascript:;" class="btn-eliminar-medico-cabecera" data-idmedico="{$medico.idmedico}" title='{"Eliminar médico de cabecera"|x_translate}' style="color:#F23243; font-size:14px">
                                <span class="trash-icon" ><i class="icon-doctorplus-trash"></i></span>
                            </a></h3> 

                    {/if}
                    <div class="gnlist-ratting-holder">
                        <div class="resultados-list-left-ratting">
                            {if $medico.valoracion >0}
                                <p><span>
                                        {if $medico.valoracion ==1}
                                            {$medico.valoracion} {"paciente lo recomienda"|x_translate}
                                        {else}
                                            {$medico.valoracion} {"pacientes lo recomendaron"|x_translate}
                                        {/if}
                                    </span>
                                </p>
                            {/if}
                        </div>

                    </div>
            </div>
        </div>
        <div class="okm-row proximo-turno-disponible-holder">
            <span>
                <small>
                    <em>
                        {if $medico.proximo_turno_vc!="NO_TURNO" && $medico.proximo_turno_vc!=""}
                            {"Próximo turno disponible"|x_translate}
                            {if $medico.proximo_turno_format!=""}
                                {if $medico.proximo_turno_format.hr!=""}
                                    <strong>{$medico.proximo_turno_format.hr}
                                        {"hr"|x_translate}&nbsp;
                                        {$medico.proximo_turno_format.min}
                                        {"mns"|x_translate}
                                    </strong>

                                {else}
                                    <strong>
                                        {$medico.proximo_turno_format.min}
                                        {"mns"|x_translate}
                                    </strong>
                                {/if}
                            {else}
                                <strong>{$medico.proximo_turno_vc|date_format:"%d/%m"} - {$medico.proximo_turno_vc|date_format:"%H:%M"}{"hs"|x_translate}</strong>
                            {/if}
                        {else}
                            {"Sin turno disponible"|x_translate}
                        {/if}
                    </em>
                </small>
            </span>
        </div>
    </div>
    <div class="col-xs-12 btn-planes-holder">
        <a href="javascript:;" class="btn-oil-square btn-mostrar-planes btn-xs" data-id="{$medico.idmedico}"><span>{"Consultar"|x_translate}</span> <i class="fa fa-chevron-down"></i></a>
        <a href="javascript:;" class="btn-oil-square btn-ocultar-planes btn-xs" data-id="{$medico.idmedico}" style="display:none;"><span>{"Volver"|x_translate}</span> <i class="fa fa-chevron-up"></i></a>
    </div>
    <div  id="div_turnos_modulo_{$medico.idmedico}" class="pbn-col-turno">
        <div id="medico-data-row-{$medico.idmedico}" class="medico-data-row">
            <div class="okm-row pbp-planes-row">
                <!-- Consulta Express -->
                <a href="javascript:;" class="pbp-planes-item {if $medico.preferencia.valorPinesConsultaExpress>"0" } select-profesional-frecuente-ce {else}no-publica{/if}" data-idmedico="{$medico.idmedico}">
                    <div class="pbp-planes-content express">
                        <figure>
                            <i class="icon-doctorplus-chat"></i>
                        </figure>
                        <h4>{"Consulta Express"|x_translate}</h4>

                        <span class="price">
                            {if $medico.paciente_sincargo=="1"}
                                {"Bonificado"|x_translate}
                            {else}
                                {if $medico.preferencia.valorPinesConsultaExpress>"0"}
                                    {if $paciente.is_paciente_empresa=="1" && $paciente.ce_disponibles>0 && $medico.medico_bonificado==1}
                                        {*paciente empresa*}
                                        {"Gratuita"|x_translate}
                                    {else}
                                        {*paciente comun*}
                                        &euro;{$medico.preferencia.valorPinesConsultaExpress}
                                    {/if}
                                {else}
                                    {"No publica"|x_translate}
                                {/if}
                            {/if}
                        </span>
                        {if $medico.paciente_sincargo=="1" || $medico.preferencia.valorPinesConsultaExpress>"0"}
                            <div  class="pbp-planes-action2">
                                <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {/if}


                    </div>
                </a>

                <!--Videoconsulta-->
                <a href="javascript:;" class="pbp-planes-item {if $medico.preferencia.valorPinesVideoConsulta>"0" && $medico.consultorio_virtual.idconsultorio!=""} select-profesional-frecuente-vc {else}no-publica{/if}" data-idmedico="{$medico.idmedico}">
                    <div class="pbp-planes-content vc-demanda {if $paciente.pais_idpais==1 && $medico.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $medico.medico_cabecera==1))} bg-reintegro{/if}">
                        <figure>
                            <i class="icon-doctorplus-video-cam"></i>
                        </figure>
                        <h4>{"Video Consulta"|x_translate}<span><em>{"(inmediata)"|x_translate}</em></span></h4>

                        <span class="price">
                            {if $medico.preferencia.valorPinesVideoConsulta>"0" && $medico.consultorio_virtual.idconsultorio!=""}
                                {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $medico.medico_bonificado==1}
                                    {*paciente empresa*}
                                    {"Gratuita"|x_translate}
                                {else}
                                    {*paciente comun*}
                                    &euro;{$medico.preferencia.valorPinesVideoConsulta}
                                {/if}
                            {else}
                                {"No publica"|x_translate}
                            {/if}
                        </span>
                        {if $medico.preferencia.valorPinesVideoConsulta>"0" && $medico.consultorio_virtual.idconsultorio!=""}
                            <div  class="pbp-planes-action2">
                                <span>{"Hacer consulta"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {/if}
                    </div>

                </a>

                <!-- Videoconsulta Turno-->
                <a href="javascript:;" class="pbp-planes-item {if $medico.preferencia.valorPinesVideoConsultaTurno>"0" && $medico.consultorio_virtual.idconsultorio!=""} select-turno {else}no-publica{/if}" data-tipo="vc" data-idmedico="{$medico.idmedico}">
                    <div class="pbp-planes-content vc-turno {if $paciente.pais_idpais==1 && $medico.especialidad.0.tipo==1 && ($paciente.titular==0 || ($paciente.titular==1 && $medico.medico_cabecera==1))} bg-reintegro{/if}">
                        <figure>
                            <i class="icon-doctorplus-video-call"></i>
                        </figure>
                        <h4>{"Video Consulta"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>

                        <span class="price">
                            {if $medico.preferencia.valorPinesVideoConsultaTurno>"0" && $medico.consultorio_virtual.idconsultorio!=""}
                                {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $medico.medico_bonificado==1}
                                    {*paciente empresa*}
                                    {"Gratuita"|x_translate}
                                {else}
                                    {*paciente comun*}
                                    &euro;{$medico.preferencia.valorPinesVideoConsultaTurno}
                                {/if}
                            {else}
                                {"No publica"|x_translate}
                            {/if}
                        </span>
                        {if $medico.preferencia.valorPinesVideoConsultaTurno>"0" && $medico.consultorio_virtual.idconsultorio!=""}
                            <div  class="pbp-planes-action2">
                                <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                            </div>
                        {/if}
                    </div>

                </a>
                <!-- turno presencial-->
                <a href="javascript:;" class="pbp-planes-item  select-turno" data-tipo="presencial" data-idmedico="{$medico.idmedico}">
                    <div class="pbp-planes-content presencial">
                        <figure>
                            <i class="icon-doctorplus-ficha-check"></i>
                        </figure>
                        <h4>{"Consulta presencial"|x_translate}<span><em>{"(con turno)"|x_translate}</em></span></h4>

                        <span class="price">
                            {if $medico.preferencia.sector.sector!=""}
                                {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $medico.medico_bonificado==1}
                                    {*paciente empresa*}
                                    {"Gratuita"|x_translate}
                                {else}
                                    {$medico.preferencia.sector.sector}
                                {/if}
                            {else}
                                {if $paciente.is_paciente_empresa=="1" && $paciente.vc_disponibles>0 && $medico.medico_bonificado==1}
                                    {*paciente empresa*}
                                    {"Gratuita"|x_translate}
                                {else}
                                    {"No publica"|x_translate}
                                {/if}
                            {/if}
                        </span>
                        <div  class="pbp-planes-action2">
                            <span>{"Sacar turno"|x_translate} <i class="fa fa-chevron-right"></i></span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
        <div id="container-pbn-turnos-holder-{$medico.idmedico}" style="display:none">
        </div>
    </div>
</div>