
<div id="agenda_mensual_medico" class="">
    <input type="hidden"  id="dia_agenda" value="{$dia_agenda}"/>
    {include file="agenda/agenda_header.tpl"}


    <section class="agenda-content">
        <div class="agenda-month-selector-box">
            <a href="javascript:;"  title="Anterior" id="a_get_dia_previous_month" class="agenda-circle-btn left">
                <i class="icon-doctorplus-left-arrow"></i>							
            </a>
            <h3 class="agenda-month">{$nombre_mes}</h3>
            <a href="javascript:;" title="Siguiente" id="a_get_dia_next_month" class="agenda-circle-btn right">
                <i class="icon-doctorplus-right-arrow"></i>							
            </a>
        </div>
        <div class="agenda-container">
            <div class="okm-row"> 
                <div class="agenda-calendario-header">
                    <ul>
                        <li><span class="agenda-label-lg">{"Lunes"|x_translate}</span><span class="agenda-label-sm">{"Lun"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Martes"|x_translate}</span><span class="agenda-label-sm">{"Mar"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Miércoles"|x_translate}</span><span class="agenda-label-sm">{"Mié"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Jueves"|x_translate}</span><span class="agenda-label-sm">{"Jue"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Viernes"|x_translate}</span><span class="agenda-label-sm">{"Vie"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Sábado"|x_translate}</span><span class="agenda-label-sm">{"Sáb"|x_translate}</span></li>
                        <li><span class="agenda-label-lg">{"Domingo"|x_translate}</span><span class="agenda-label-sm">{"Dom"|x_translate}</span></li>
                    </ul>
                </div>


                <!--agenda mensual-->
              
                <div id="agenda-mensual" class="agenda-calendario-days">

                    {foreach name=foreach_agenda from=$list_agenda_mensual item=agenda_mensual name=dia_turnos}
                    {math  assign="indexInicio" equation='(x-1)%7' x=$smarty.foreach.dia_turnos.iteration}
                    {math  assign="indexFin" equation='x%7' x=$smarty.foreach.dia_turnos.iteration}

                    {if $indexInicio==0}<div class="okm-row agenda-calendar-row">{/if}
                        {if !$agenda_mensual.agenda.is_actual}
                        <a href="{$url}panel-medico/agenda/agenda-mensual/{$agenda_mensual.agenda.fecha|date_format:'%d'}-{$agenda_mensual.agenda.fecha|date_format:'%m'}-{$agenda_mensual.agenda.fecha|date_format:'%Y'}/?idconsultorio={$idconsultorio}" class="agenda-calendario-day-cell disabled {if $indexFin==0}feriado{/if}">
                            {else}
                            <a href="{$url}panel-medico/agenda/agenda-diaria/{$agenda_mensual.agenda.fecha|date_format:'%d'}-{$agenda_mensual.agenda.fecha|date_format:'%m'}-{$agenda_mensual.agenda.fecha|date_format:'%Y'}/?idconsultorio={$idconsultorio}" class="agenda-calendario-day-cell {if $indexFin==0}feriado{/if}">
                                {/if}

                                <div class="agenda-calendar-day-number">{$agenda_mensual.agenda.fecha|date_format:"%d"}</div>
                                <div class="agenda-calendar-day-confirmado"><i class="icon-doctorplus-check-circle"></i><span class="cant">{$agenda_mensual.agenda.cant_confirmados}</span></div>
                                <div class="agenda-calendar-day-pendiente"><i class="icon-doctorplus-contrast-circle"></i><span class="cant">{$agenda_mensual.agenda.cant_pendientes}</span></div>
                                <div class="agenda-calendar-day-libre"><i class="icon-doctorplus-turno-disponible"></i><span class="cant">{$agenda_mensual.agenda.cant_disponibles}</span></div>
                            </a>
                            {if $indexFin==0}</div>{/if}


                {foreachelse}
                    {if $agenda_definida}
                    <td colspan="7">
                        <h4 class="msg-generico text-center">{"No se ha definido agenda de turnos para este mes."|x_translate} </h4>
                    </td>
                    {else}
                    <td colspan="7">
                        <h4 class="msg-generico text-center">{"Ud. aún no ha definido los días y los horarios de su agenda de turnos"|x_translate}</h4>
                    </td>
                    {/if}
                    <div class="text-center" style="margin-top:50px">
                        <a href="{$url}panel-medico/perfil-profesional/consultorios/" class="btn-default-square agregar_horario"> {"Agregar horario"|x_translate}</a>
                    </div>
                    
                
                {/foreach}


                </div>
               
                
            </div>
        </div>
    </section>
    {include file="agenda/referencia_estado_turnos.tpl"}
</div>

{x_load_js}