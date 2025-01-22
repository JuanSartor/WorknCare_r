<section>
    <div class="hom-soporte col-xs-12" style="border:none !important;">
        <div class="row">
            <div class="text-center" style="width:100px; margin:auto;">
                <div class="animationContainer animated pulse">

                    <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 85 82" xml:space="preserve">
                        {literal}
                            <style type="text/css">
                                .st000{fill:#EAEAEA;}
                                .st100{clip-path:url(#SVGID_2_);fill:none;stroke:#6A6F72;stroke-width:80;stroke-linecap:round;stroke-miterlimit:10;}
                                .st200{fill:none;stroke:#00E7B6;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                                .st300{fill:none;stroke:#BA4343;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                            </style>
                        {/literal}
                        <path class="st300 XIkPkPTZ_0" d="M9.5,41A33,33 0,1,1 75.5,41A33,33 0,1,1 9.5,41"></path>
                        <g>
                            <path class="st300 XIkPkPTZ_1" d="M29.5,28L55.5,54"></path>
                            <path class="st300 XIkPkPTZ_2" d="M29.5,54L55.5,28"></path>
                        </g>
                        {literal}
                            <style>.XIkPkPTZ_0{stroke-dasharray:208 210;stroke-dashoffset:209;animation:XIkPkPTZ_draw 879ms ease-in-out 0ms forwards;}.XIkPkPTZ_1{stroke-dasharray:37 39;stroke-dashoffset:38;animation:XIkPkPTZ_draw 160ms ease-in-out 879ms forwards;}.XIkPkPTZ_2{stroke-dasharray:37 39;stroke-dashoffset:38;animation:XIkPkPTZ_draw 160ms ease-in-out 1040ms forwards;}@keyframes XIkPkPTZ_draw{100%{stroke-dashoffset:0;}}@keyframes XIkPkPTZ_fade{0%{stroke-opacity:1;}92.5925925925926%{stroke-opacity:1;}100%{stroke-opacity:0;}}</style>
                        {/literal}
                    </svg>

                </div>

            </div>
        </div>
        <h4>{"Pago cancelado"|x_translate}</h4>
        <p class="text-center"> 
            {"No se pudo registrar su pago porque no se pudo cargar la tarjeta utilizada."|x_translate}
        </p>
        <div class="row text-center">
            <div class="col-xs-12">
                <a href="{$url}panel-paciente/" class="btn-default" id="btnRedirect">{"continuar"|x_translate}</a>
            </div>

        </div>

    </div>
</section>
{literal}
    <script>
        $(function () {
            var payment_redirect = localStorage.getItem('payment_redirect');
            if (payment_redirect === "ce") {
                $("#btnRedirect").attr("href", BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true");
            } else if (payment_redirect === "vc") {
                $("#btnRedirect").attr("href", BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true");
            } else if (payment_redirect.indexOf("turno_vc:") > -1) {
                var idturno = payment_redirect.replace("turno_vc:", "");
                if (parseInt(idturno) > 0) {
                    $("#btnRedirect").attr("href", BASE_PATH + "panel-paciente/busqueda-profesional/reservar-turno-video-llamada-" + idturno + ".html");
                }

            }
        });
    </script>
{/literal}