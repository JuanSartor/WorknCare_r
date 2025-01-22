<section class="{if $smarty.request.submodulo=="agenda_semanal"}hidden-xs{/if} td-turnos-referencias">
    {* <div class="td-turnos-referencias-box">
    <h2 align="center">{"Referencias"|x_translate}</h2>
    <div class="agenda-referencias-row">
    <div class="agenda-referencias-item">
    <figure class="disponible"><i class="icon-doctorplus-disponible"></i></figure>
    <p>{"Disponible"|x_translate}</p>
    </div>
    <div class="agenda-referencias-item">
    <figure class="confirmado"><i class="icon-doctorplus-check-circle"></i></figure>
    <p>{"Confirmado"|x_translate}</p>
    </div>
    <div class="agenda-referencias-item">
    <figure class="confirmacion"><i class="icon-doctorplus-pendiente"></i></figure>
    <p>{"Pendiente"|x_translate}</p>
    </div>

    <div class="agenda-referencias-item">
    <figure class="ausente"><i class="icon-doctorplus-ausente"></i></figure>
    <p>{"Ausente"|x_translate}</p>
    </div>
    <div class="agenda-referencias-item">
    <figure class="declinado"><i class="fa fa-calendar-times-o"></i></figure>
    <p>{"Declinado"|x_translate}</p>
    </div>
    </div>
    </div>*}
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
</section>