{if $videoconsulta_no_disponible=="1"}

    <div class="pbn-turnos-slide-holder">
        <div class="pnb-slide" >
            <div class="pnb-slide-inner">
                <div class="pnb-slide-col">
                </div>
                <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                    <h4>{"Disponible solo para sus pacientes frecuentes"|x_translate}</h4>

                </div>
            </div>
        </div>
    </div>
{else}
    {* mostrar proximo turno disponible*}
    {if $agenda.hay_siguiente == 1}
        <div class="pnb-slide">
            <div class="pnb-slide-inner no-turno-disponible">
                <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                    <h4>{"Próximo turno disponible"|x_translate}:</h4>

                    {if $consultorio.is_virtual == 1}
                        <a class="a_reservar_turno_vc" data-idturno="{$agenda.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada.html?turno={$agenda.idturno}">
                            <p>
                                {$agenda.fecha|getDiaSemanaXFecha} {$agenda.fecha|date_format:"%d/%m"} - {$agenda.horarioInicio|date_format:"%H:%M"} {"hs"|x_translate}
                                <i class="fa fa-check-circle"></i>
                            </p>
                        </a>
                    {else}
                        <a class="a_reservar_turno" data-idturno="{$agenda.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$agenda.idturno}.html">
                            <p>
                                {$agenda.fecha|getDiaSemanaXFecha} {$agenda.fecha|date_format:"%d/%m"} - {$agenda.horarioInicio|date_format:"%H:%M"} {"hs"|x_translate}
                                <i class="fa fa-check-circle"></i>
                            </p>
                        </a>
                    {/if}
                    <a href="javascript:;" class="a_semana_next_turno" data-cantidad_semanas="{$agenda.diferencia_semana}" >
                        {"mostrar otros"|x_translate}<i class="fa fa-chevron-down"></i>
                    </a>
                </div> 
            </div> 
        </div>
    {/if}
    {*sin turnos disponibles *}
    {if $agenda.hay_siguiente == 2}
        <div class="pnb-slide">
            <div class="pnb-slide-inner no-turno-disponible">
                <div class="pbn-turno-vacio pbn-turno-vacio-slider">
                    <h4>{"No hay turnos disponibles"|x_translate}</h4>
                    <a href="javascript:;"  class="no-turno-select-profesional-frecuente-vc" data-idmedico="{$medico.idmedico}"><p>{"Video Consulta"|x_translate}</p></a>
                    <br>
                    <a href="javascript:;"  class="no-turno-select-profesional-frecuente-ce" data-idmedico="{$medico.idmedico}"><p>{"Consulta Express"|x_translate}</p></a>

                    <script>

                        $("#pbn-turnos-holder-{$consultorio.idconsultorio} .a_semana_previous").data("fecha", "{$dia_agenda}");

                    </script>
                </div>
            </div>
        </div>
    {/if}
    {*turnos*}
    {if $agenda.hay_siguiente == ""}
        <div class="pbn-turnos-slide-holder">
            <div class="pnb-slide" >
                <div class="pnb-slide-inner">
                    <div class="pnb-slide-col {if $agenda[1].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"lun"|x_translate}<br>
                                    {$agenda[1].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[1].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}                        
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}"  href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}

                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        {if $agenda[1].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>
                    <div class="pnb-slide-col {if $agenda[2].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"mar"|x_translate}<br>
                                    {$agenda[2].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[2].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}

                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        {if $agenda[2].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>

                    <div class="pnb-slide-col {if $agenda[3].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"mié"|x_translate}<br>
                                    {$agenda[3].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[3].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}

                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        {if $agenda[3].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>

                    <div class="pnb-slide-col {if $agenda[4].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"jue"|x_translate}<br>
                                    {$agenda[4].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[4].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}

                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        {if $agenda[4].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>

                    <div class="pnb-slide-col {if $agenda[5].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"vie"|x_translate}<br>
                                    {$agenda[5].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[5].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}
                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}

                        </ul>
                        {if $agenda[5].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>

                    <div class="pnb-slide-col {if $agenda[6].vacaciones=='1'} pnb-vacaciones  {/if}">
                        <ul>
                            <li>
                                <span>
                                    {"sáb"|x_translate}<br>
                                    {$agenda[6].fecha|date_format:"%d/%m"}
                                </span>
                            </li>
                            {foreach from=$agenda[6].turnos item=turno}
                                <li>
                                    {if $consultorio.is_virtual == 1}
                                        {if $preferencia.valorPinesVideoConsultaTurno == ""}
                                            <a href="javascript:;" onclick="x_alert(x_translate('El médico no posee configurada la tarifa de video consulta'));">{$turno.horario}</a>
                                        {else}
                                            <a class="a_reservar_turno_vc" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno.idturno}.html">{$turno.horario}</a>
                                        {/if}
                                    {else}
                                        <a class="a_reservar_turno" data-idturno="{$turno.idturno}" href="{$url}panel-paciente/busqueda-profesional/reservar-turno-{$turno.idturno}.html">{$turno.horario}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                        {if $agenda[6].turnos|@count > 5}
                            <a href="javascript:;" class="pbn-mas-trigger">{"Más..."|x_translate}</a>
                        {/if}
                    </div>


                </div>
            </div>
        </div>
        <a href="javascript:;" class="pbn-turnos-left-arrow a_semana_previous" ><i class="icon-doctorplus-left-arrow"></i></a>
        <a href="javascript:;" class="pbn-turnos-right-arrow a_semana_next"><i class="icon-doctorplus-right-arrow"></i></a>

        {if $agenda[6].vacaciones=='1' || $agenda[5].vacaciones=='1' || $agenda[4].vacaciones=='1' || $agenda[3].vacaciones=='1' || $agenda[2].vacaciones=='1' || $agenda[1].vacaciones=='1' }
            <div class="container-leyenda">
                <div class="cuadrado"></div>
                <div class="texto-vacaciones"> {"Profesional de vacaciones"|x_translate}</div>
            </div> 
        {/if}

    {/if}

{/if}


<script>
    $(function () {

        $("#pbn-turnos-holder-{$consultorio.idconsultorio}").data("fecha", "{$dia_agenda}");

        var altoUl = 230;
        $('.pbn-mas-trigger').on('click', function (e) {

            e.preventDefault();

            var innerSlide = $(this).parent('.pnb-slide-col');
            var heightSlide = $(this).parent('.pnb-slide-col').children('ul').outerHeight() + $(this).outerHeight();

            if (innerSlide.outerHeight() <= altoUl) {
                innerSlide.animate({
                    height: heightSlide
                }, 600);
                $(this).html('Moins');
            } else {
                innerSlide.animate({
                    height: altoUl
                }, 600);
                $(this).html('Plus...');
            }
        });

        $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .pbn-mas-trigger', function (e) {
            e.preventDefault();

            var innerSlide = $(this).parent('.pnb-slide-col');
            var heightSlide = $(this).parent('.pnb-slide-col').children('ul').outerHeight() + $(this).outerHeight();

            if (innerSlide.outerHeight() <= altoUl) {

                innerSlide.animate({
                    height: heightSlide
                }, 600);
                $(this).html('Moins');
            } else {
                innerSlide.animate({
                    height: altoUl
                }, 600);
                $(this).html('Plus...');
            }
        });
    });

</script>