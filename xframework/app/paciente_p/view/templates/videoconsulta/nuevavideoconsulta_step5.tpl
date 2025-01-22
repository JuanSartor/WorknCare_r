<section class="container cs-nc-p2">

    <div class="cs-nc-p2-inner ce-p5-content">

        <h2>{"¡Abrimos tu Video Consulta con el Nº"|x_translate} {$VideoConsulta.numeroVideoConsulta}!</h2>
        <p>{"Por favor aguarda la respuesta. Te avisaremos al email:"|x_translate} 
            {$pacienteTitular.email}
            {if $pacienteTitular.celularValido=="1"} 
                {"y al celular"|x_translate}
                {$pacienteTitular.numeroCelular}
            {/if}
        </p>
        <div class="nc-cs-btn-cbtn-hodler">
            <a href="{$url}panel-paciente/videoconsulta/pendientes.html" class="btn btn-primary ce-btn">
                {"ir a mis videoconsultas"|x_translate}
            </a>
        </div>
        <h3>{"ATENCION"|x_translate}</h3>
        <div class="nc-cs-info-box">
            <p>
                {"Una vez que el profesional te llama recuerda que el tiempo de espera para el ingreso a la sala es de [[{$VIDEOCONSULTA_VENCIMIENTO_SALA}]] minutos. Transcurrido dicho plazo el médico puede cancelar la consulta y llamar al próximo paciente."|x_translate} 
                <br>{"¡Estate atento!"|x_translate}
            </p>
        </div>
    </div>
</section>
{literal}
    <script>
        $(function () {
            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#videoconsulta-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }
        });
    </script>
{/literal}

