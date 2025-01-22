<section class="video-consulta-pasos">
    <a href="#" id="usr-help-trg">
        <h3>{"¿Necesita ayuda?"|x_translate}</h3>
        <h4>{"¿Qué pasos debo seguir para hacer una Video Consulta?"|x_translate}</h4>
    </a>
    <div class="video-consultas-pasos-container" id="usr-help-box">

        <div class="okm-row">

            <div class="video-consultas-pasos-col video-consultas-paso-1">
                <figure><img src="{$IMGS}video-consulta/paso-1.png"/></figure>
                <div class="video-consultas-pasos-number">
                    <i class="icon-doctorplus-ficha-tecnica"></i>
                </div>
                <h5 class="video-consultas-pasos-title">{"Registrate en DoctorPlus"|x_translate}</h5>
                <p class="video-consultas-pasos-txt">
                    {"podés agregar también a los miembros de tu grupo familiar para centralizar toda la información."|x_translate}
                </p>
            </div>


            <div class="video-consultas-pasos-col video-consultas-paso-2">
                <figure><img src="{$IMGS}video-consulta/paso-2.png"/></figure>
                <div class="video-consultas-pasos-number">
                    <i class="icon-doctorplus-map-point"></i>
                </div>
                <h5 class="video-consultas-pasos-title">{"Buscá médicos"|x_translate}</h5>
                <p class="video-consultas-pasos-txt">
                    {"y seleccioná uno o varios según tus preferencias."|x_translate}
                </p>
            </div>


            <div class="video-consultas-pasos-col video-consultas-paso-3">
                <figure><img src="{$IMGS}video-consulta/paso-3.png"/></figure>
                <div class="video-consultas-pasos-number">
                    <i class="icon-doctorplus-dollar-circular"></i>
                    <i class="icon-doctorplus-dollar-add"></i>
                </div>
                <h5 class="video-consultas-pasos-title">{"Confirmá el pago"|x_translate}</h5>
                <p class="video-consultas-pasos-txt">
                    {"o cargá crédito para poder realizar la Video Consulta."|x_translate}
                </p>
            </div>

            <div class="video-consultas-pasos-col video-consultas-paso-4">
                <figure><img src="{$IMGS}video-consulta/paso-4.png"/></figure>
                <div class="video-consultas-pasos-number">
                    <i class="icon-doctorplus-calendar-time"></i>
                </div>
                <h5 class="video-consultas-pasos-title">{"Indicá el motivo y aguardá"|x_translate}</h5>
                <p class="video-consultas-pasos-txt">
                    {"El médico te confirmará el horario en que te atenderá. Si la consulta fue publicada en Profesionales en la Red el sistema te avisará por sms o por mail en qué momento te toca pasar a la sala."|x_translate}
                </p>

            </div>

        </div>

        <div class="okm-row">
            <div class="video-consultas-pasos-col-center">

                <figure>
                    <img src="{$IMGS}video-consulta/video-mobile.png"/>
                </figure>
                <p>
                    {"A la hora acordada entrá a la sala del consultorio virtual y esperá a que el médico inicie la Video Consulta!"|x_translate}
                </p>
            </div>
        </div>

        <div class="okm-row">

            <div class="video-consultas-features-row">

                <div class="video-consultas-features-col">
                    <figure>
                        <img src="{$IMGS}video-consulta/imagenes.png"/>
                    </figure>
                    <h5>{"Posibilidad de incluir imágenes"|x_translate}</h5>
                    <p>
                        {"Además... tenés la posibilidad de compartir imágenes y  documentos con el profesional durante tu consulta. Las mismas quedarán almacenadas en tu historial de Estudios e imágenes para, por ejemplo, poder ser compartidas con otros profesionales."|x_translate}
                    </p>
                </div>

                <div class="video-consultas-features-col">
                    <figure>
                        <img src="{$IMGS}video-consulta/hostorial.png"/>
                    </figure>
                    <h5>{"Historial de Registros Médicos"|x_translate}</h5>
                    <p>
                        {"Al finalizar la consulta el médico te enviará sus conclusiones, tratamiento  o diagnóstico por mial. También quedará almacenado en tu Historial de Registros Médicos del Perfil de Salud."|x_translate}
                    </p>
                </div>

                <div class="video-consultas-features-col">
                    <figure>
                        <img src="{$IMGS}video-consulta/cancelacion.png"/>
                    </figure>
                    <h5>{"Devolución en caso de cancelación"|x_translate}</h5>
                    <p>
                        {"Si tu consulta no fue atendida en el plazo establecido, deseas cancelarla o el médico considera que no puede resolver tu consulta por este medio, el importe de la misma será reintegrado en tu cuenta."|x_translate}
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

{literal}
<script>
    $(function(){
        //desplegable guia pasos
        if ($('.video-consulta-pasos').length > 0) {

            $('#usr-help-trg').on('click', function (e) {
                e.preventDefault();

                $('#usr-help-box').slideToggle();
            });

            $('#alert-modal').on('click', function (e) {
                e.preventDefault();

                $('#modal-alert').modal('toggle');
            });
        }
        
    });
</script>
{/literal}