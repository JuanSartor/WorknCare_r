<!-- BANNER TURNOS - AGENDA -->
{include file="agenda/agenda_header.tpl"}



<section class="container td-content">
    <div class="okm-row">
        <h1 class="td-title">{"Detalle de Turno"|x_translate}</h1>
        <a href="{$url}panel-medico/agenda/imprimir-detalle-turno-{$smarty.request.id}.html" target="_blank" class="td-print-action"><i class="icon-doctorplus-print"></i></a>
    </div>
    <div id="div_turno_detalle" >


    </div>
</section>
<section class="td-turnos-referencias-detalle">
    <div class="td-turnos-referencias-box referencias">
        <h2>{"Referencias"|x_translate}</h2>
        <ul>

            <li>
                <figure class="confirmado"><i class="icon-doctorplus-check-circle"></i></figure>
                <p>{"Confirmar: El profesional avisa al paciente que su turno es aceptado"|x_translate}</p>
            </li>
            <li>
                <figure class="confirmacion"><i class="icon-doctorplus-pendiente"></i></figure>
                <p>{"Pendiente: El turno fue solicitado por el paciente y está pendiente de confirmación por parte del profesional."|x_translate}</p>
            </li>
            <li>
                <figure class="cancelado">  <i class="fas fa-user-times"></i></figure>
                <p>{"Cancelar: El turno ha sido cancelado por el paciente. El turno pasa a estar disponible en la agenda."|x_translate}</p>
            </li>
            <li>
                <figure class="ausente"><i class="icon-doctorplus-ausente"></i></figure>
                <p>{"Ausente: El paciente no se presentó a su turno médico."|x_translate}</p>
            </li>
            <li>
                <figure class="declinado"> <i class="fa fa-calendar-times-o"></i></figure>
                <p>{"Declinar: El profesional no puede antender en ese horario. DoctorPlus notificá al paciente por mail y por SMS y se le ofrecerá un nuevo turno."|x_translate}</p>
            </li>
        </ul>
    </div>
</section>

<script>
    x_loadModule('turno', 'turno_detalle', 'id={$smarty.request.id}', 'div_turno_detalle', BASE_PATH + "medico");

    {literal}
        $(function () {
            $("#Main").spin("large");
        });
    {/literal}
</script>


