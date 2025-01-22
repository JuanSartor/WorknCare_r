<section>
    <div class="hom-soporte col-xs-12" style="border:none !important;">
        <div class="row">
            <div class="text-center" style="width:100px; margin:auto;">
                <div class="animationContainer animated rubberBand">
                    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 85 82" xml:space="preserve">
                        {literal}
                            <style type="text/css">
                                .st00{fill:#EAEAEA;}
                                .st10{clip-path:url(#SVGID_2_);fill:none;stroke:#6A6F72;stroke-width:80;stroke-linecap:round;stroke-miterlimit:10;}
                                .st20{fill:none;stroke:#00E7B6;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                                .st30{fill:none;stroke:#BA4343;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                            </style>
                        {/literal}
                        <g>
                            <path class="st20 CVKuhQYc_0" d="M67.6,19.5c0.2,0.2,0.4,0.5,0.6,0.7c0.2,0.2,0.4,0.5,0.6,0.7c4.2,5.5,6.7,12.5,6.7,20c0,18.2-14.8,33-33,33
                                  s-33-14.8-33-33s14.8-33,33-33c9.4,0,17.9,3.9,23.9,10.3c0.3,0.4,0.7,0.7,1,1.1"></path>
                            <path class="st20 CVKuhQYc_1" d="M66.9,19.8L35.3,51.3L23,39"></path>
                        </g>
                        {literal}
                            <style>.CVKuhQYc_0{stroke-dasharray:208 210;stroke-dashoffset:209;animation:CVKuhQYc_draw 918ms ease-out 0ms forwards;}.CVKuhQYc_1{stroke-dasharray:63 65;stroke-dashoffset:64;animation:CVKuhQYc_draw 281ms ease-out 918ms forwards;}@keyframes CVKuhQYc_draw{100%{stroke-dashoffset:0;}}@keyframes CVKuhQYc_fade{0%{stroke-opacity:1;}92.5925925925926%{stroke-opacity:1;}100%{stroke-opacity:0;}}
                            </style>
                        {/literal}
                    </svg>
                </div>

            </div>
        </div>
        <h4>{"Pago realizado"|x_translate}</h4>
        <p class="text-center"> 
            {"Su cuenta de DoctorPlus ha sido acreditada con éxito. ¡Puede consultar a un médico de su elección ahora!"|x_translate}
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