<section class="container cs-nc-p2">

    <div class="cs-nc-p2-inner ce-p5-content">

        <h2>{"¡Abrimos tu Consulta Express con el Nº"|x_translate} {$ConsultaExpress.numeroConsultaExpress}</h2>
        <p>{"Por favor aguarda la respuesta. Te avisaremos al email:"|x_translate} {$pacienteTitular.email}
            {if $pacienteTitular.celularValido=="1"} {"y al celular"|x_translate} {$pacienteTitular.numeroCelular}{/if}
        </p>
        <div class="nc-cs-btn-cbtn-hodler">
            <a href="{$url}panel-paciente/consultaexpress/pendientes.html" class="btn btn-primary ce-btn">
                {"ir a mis consultas"|x_translate}
            </a>
        </div>
        <h3>{"ATENCION"|x_translate}</h3>

        <div class="nc-cs-info-box">
            <p>{"Reabre esta consulta sólo si agregas información adicional que consideres ayudará al/los profesional/es a brindarte el consejo más adecuado a tu caso."|x_translate}
                {"De lo contrario, es posible que demores la respuesta."|x_translate}</p>
        </div>
    </div>
</section>
{literal}
    <script>
        $(function () {
            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#consulta-express-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }
        });
    </script>
{/literal}
