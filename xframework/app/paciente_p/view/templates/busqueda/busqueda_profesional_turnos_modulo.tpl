{if $consultorio.vacaciones.hasta!=""}
    {*mensaje medico vacaciones*}
    <div class="vacaciones-turno-wrapper">
        <p>{"Profesional de vacaciones"|x_translate}</p>
        <p>{"Responderá sus consultas luego del"|x_translate}&nbsp;{$consultorio.vacaciones.hasta_format}</p>
    </div>
{/if}
<div class="pbn-col-turno">

    {include file="busqueda/busqueda_profesional_tarifas_modulo.tpl"}
    <div id="container-pbn-turnos-holder-{$consultorio.idmedico}" style="display:none">
        {include file="busqueda/busqueda_consultorio_selector.tpl"}
        {if $consultorio.idconsultorio!=""}

            <div class="pbn-turnos-holder" id="pbn-turnos-holder-{$consultorio.idconsultorio}" data-idconsultorio_to_change="{$consultorio.idconsultorio}" data-fecha="" data-idmedico="{$consultorio.idmedico}" data-idconsultorio="{$consultorio.idconsultorio}" {if $consultorio.agenda.hay_siguiente==1 }style="min-width:200px;" {/if}>

                <div class="pbn-turnos-slide-holder" id="div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}">
                    {if $consultorio.videoconsulta_no_disponible=="1"}

                        <div class="pnb-slide" id="pnb-slide-{$consultorio.idconsultorio}">
                            <div class="pnb-slide-inner">
                                <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                                    <h4>{"Disponible solo para sus pacientes frecuentes"|x_translate}</h4>
                                </div>
                            </div>
                        </div>
                    {else}
                        {* mostrar proximo turno disponible*}
                        {if $consultorio.agenda.hay_siguiente == 1}
                            <div class="pnb-slide">
                                <div class="pnb-slide-inner proximo-turno-disponible">
                                    <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                                        <h4>{"Próximo turno disponible"|x_translate}:</h4>

                                        {if $consultorio.is_virtual == 1} 
                                            {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">
                                                    <p>
                                                        {$consultorio.agenda.fecha|getDiaSemanaXFecha} {$consultorio.agenda.fecha|date_format:"%d/%m"} - {$consultorio.agenda.horarioInicio|date_format:"%H:%M"} {"hs"|x_translate}
                                                        <i class="fa fa-check-circle"></i>
                                                    </p>
                                                </a>
                                            {else}
                                                <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$consultorio.agenda.idturno}.html">
                                                    <p>
                                                        {$consultorio.agenda.fecha|getDiaSemanaXFecha} {$consultorio.agenda.fecha|date_format:"%d/%m"} - {$consultorio.agenda.horarioInicio|date_format:"%H:%M"} {"hs"|x_translate}
                                                        <i class="fa fa-check-circle"></i>
                                                    </p>
                                                </a>
                                            {/if}
                                        {else}
                                            <a class="a_reservar_turno" data-idturno="{$consultorio.agenda.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$consultorio.agenda.idturno}.html">
                                                <p>
                                                    {$consultorio.agenda.fecha|getDiaSemanaXFecha} {$consultorio.agenda.fecha|date_format:"%d/%m"} - {$consultorio.agenda.horarioInicio|date_format:"%H:%M"} {"hs"|x_translate}
                                                    <i class="fa fa-check-circle"></i>
                                                </p>
                                            </a>
                                        {/if}

                                        <a href="javascript:;" class="a_semana_next_turno" data-cantidad_semanas="{$consultorio.agenda.diferencia_semana}">
                                            {"mostrar otros"|x_translate} <i class="fa fa-chevron-down"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        {/if}

                        {*sin turnos disponibles *}
                        {if $consultorio.agenda.hay_siguiente == 2}
                            <div class="pnb-slide">
                                <div class="pnb-slide-inner no-turno-disponible">
                                    <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                                        <h4>{"No hay turnos disponibles"|x_translate}</h4>
                                        <a href="javascript:;"  data-id="{$consultorio.idmedico}" class="no-turno-select-profesional-frecuente-vc"><p>{"Video Consulta"|x_translate}</p></a>
                                        <a href="javascript:;"  data-id="{$consultorio.idmedico}" class="no-turno-select-profesional-frecuente-ce"><p>{"Consulta Express"|x_translate}</p></a>
                                    </div>
                                </div>
                            </div>
                        {/if}
                        {* turnos *}
                        {if $consultorio.agenda.hay_siguiente == ""}
                            <div class="pnb-slide">
                                <div class="pnb-slide-inner">

                                    <!--                                LUNES-->
                                    <div class="pnb-slide-col {if $agenda[1].vacaciones=='1'} pnb-vacaciones  {/if}">
                                        <ul>
                                            <li>
                                                <span>
                                                    {"lun"|x_translate}
                                                    <br> {$consultorio.agenda[1].fecha|date_format:"%d/%m"}
                                                </span>
                                            </li>
                                            {foreach from=$consultorio.agenda[1].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1}
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'))">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>                                                       
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}
                                        </ul>
                                        {if $consultorio.agenda[1].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>

                                    <!--                                MARTES-->
                                    <div class="pnb-slide-col {if $agenda[2].vacaciones=='1'} pnb-vacaciones  {/if}">

                                        <ul>
                                            <li>
                                                <span>
                                                    {"mar"|x_translate}
                                                    <br> {$consultorio.agenda[2].fecha|date_format:"%d/%m"}
                                                </span>
                                            </li>
                                            {foreach from=$consultorio.agenda[2].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1}
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}
                                        </ul>
                                        {if $consultorio.agenda[2].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>

                                    <!--                                MIÉRCOLES-->
                                    <div class="pnb-slide-col {if $agenda[3].vacaciones=='1'} pnb-vacaciones  {/if}">

                                        <ul>
                                            <li>
                                                <span>
                                                    {"mié"|x_translate}
                                                    <br> {$consultorio.agenda[3].fecha|date_format:"%d/%m"}
                                                </span>
                                            </li>
                                            {foreach from=$consultorio.agenda[3].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1}
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}
                                        </ul>
                                        {if $consultorio.agenda[3].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>

                                    <!--                                JUEVES-->
                                    <div class="pnb-slide-col {if $agenda[4].vacaciones=='1'} pnb-vacaciones  {/if}">

                                        <ul>
                                            <li>
                                                <span>
                                                    {"jue"|x_translate}
                                                    <br> {$consultorio.agenda[4].fecha|date_format:"%d/%m"}
                                                </span>
                                            </li>
                                            {foreach from=$consultorio.agenda[4].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1}
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}
                                        </ul>
                                        {if $consultorio.agenda[4].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>

                                    <!--                                VIERNES-->
                                    <div class="pnb-slide-col {if $agenda[5].vacaciones=='1'} pnb-vacaciones  {/if}">

                                        <ul>
                                            <li>
                                                <span>
                                                    {"vie"|x_translate}
                                                    <br> {$consultorio.agenda[5].fecha|date_format:"%d/%m"}
                                                </span>
                                            </li>
                                            {foreach from=$consultorio.agenda[5].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1} 
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}

                                        </ul>
                                        {if $consultorio.agenda[5].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>

                                    <!--                                SÁBADO-->
                                    <div class="pnb-slide-col {if $agenda[6].vacaciones=='1'} pnb-vacaciones  {/if}">

                                        <ul>
                                            <li>
                                                <span>
                                                    {"sáb"|x_translate}
                                                    <br> {$consultorio.agenda[6].fecha|date_format:"%d/%m"}
                                                </span>

                                            </li>
                                            {foreach from=$consultorio.agenda[6].turnos item=turno}
                                                <li>
                                                    {if $consultorio.is_virtual == 1} 
                                                        {if $consultorio.preferencia.valorPinesVideoConsultaTurno == ""}
                                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                                        {else}
                                                            <a class="a_reservar_turno_vc" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                                        {/if}
                                                    {else}
                                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                                    {/if}
                                                </li>
                                            {/foreach}
                                        </ul>
                                        {if $consultorio.agenda[6].turnos|@count > 5}
                                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                                        {/if}
                                    </div>
                                </div>
                            </div>

                            <!--				actions-->
                            <a href="javascript:;" class="pbn-turnos-left-arrow a_semana_previous">
                                <i class="icon-doctorplus-left-arrow"></i>
                            </a>
                            <a href="javascript:;" class="pbn-turnos-right-arrow a_semana_next">
                                <i class="icon-doctorplus-right-arrow"></i>
                            </a>
                            {if $agenda[6].vacaciones=='1' || $agenda[5].vacaciones=='1' || $agenda[4].vacaciones=='1' || $agenda[3].vacaciones=='1' || $agenda[2].vacaciones=='1' || $agenda[1].vacaciones=='1' }
                                <div class="container-leyenda">
                                    <div class="cuadrado"></div>
                                    <div class="texto-vacaciones"> {"Profesional de vacaciones"|x_translate}</div>
                                </div> 
                            {/if}
                        {/if}

                    {/if}
                </div>

            </div>

        {else}
            <!-- si no posee consultorio, ofrece consulta express-->

            <div class="pbn-turnos-holder" id="pbn-turnos-holder-{$consultorio.idconsultorio}" data-idconsultorio_to_change="{$consultorio.idconsultorio}"
                 data-fecha="" data-idmedico="{$consultorio.idmedico}" data-idconsultorio="{$consultorio.idconsultorio}">

                <div class="pbn-turnos-slide-holder" id="div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}">

                    <div class="pnb-slide">
                        <div class="pnb-slide-inner">





                            <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                                <h4>{"El profesional sólo ofrece servicio de"|x_translate}</h4>
                                <a class="a_consultaexpress" data-idmedico="{$consultorio.idmedico}" href="javascript:;">
                                    <p>{"Consulta Express"|x_translate}</p>
                                </a>
                            </div>


                        </div>
                    </div>
                    <!--actions -->



                </div>
            </div>

        {/if}
    </div>
</div>