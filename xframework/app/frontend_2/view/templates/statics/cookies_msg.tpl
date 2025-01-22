<style>

</style>
<div id="cookies_main_container">
    <div id="cookie-msg" >
        <div class="msg">
            <div class="okm-row">
                {"Al continuar navegando, acepta el uso de cookies, lo que nos permite garantizar una experiencia óptima de su uso de DoctorPlus. Al hacerlo, acepta el uso de cookies que pueden usarse para compilar estadísticas de visitas."|x_translate}
                <a href="{$url}cookies.html" rel="nofollow" class="saber_mas">
                    {"Saber más"|x_translate}
                </a>

            </div>
            <div class="okm-row">
                <button class=" btn btn-xs btn-white" id="btn-personalizar-cookies">
                    {"Parámetros de cookies"|x_translate}
                </button>
                <button class="btn btn-xs btn-primary btn-default" id="btn-aceptar-cookies">
                    {"Aceptar todas"|x_translate}
                </button>
            </div>


        </div>
    </div>

    <div class="modal modal-parametros-cookies" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-parametros-cookies">
        <div class="modal-dialog container" role="document">
            <div class="modal-content  ">
                <div class="modal-header">
                    <h2>{"Configuración avanzada de cookies"|x_translate}</h2>
                    <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="okm-row"> 
                        <div class="col-xs-12 cookie-type">
                            <h3>{"Cookies esenciales"|x_translate}</h3>
                            <div class=" form-group">
                                <label >{"Estas cookies permiten la activación de funciones esenciales como la seguridad, la verificación de identidad y la gestión de la red. Estas cookies no se pueden desactivar."|x_translate}</label>
                                <div class="switch-container">
                                    <input type="checkbox" class="switch-checkbox pull-right" data-toggle="switch" disabled checked data-on-text='{"Si"|x_translate}' data-off-text='{"No"|x_translate}'/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="okm-row"> 
                        <div class="col-xs-12 cookie-type">
                            <h3>{"Cookies funcionales"|x_translate}</h3>
                            <div class=" form-group">
                                <label >{"Estas cookies recopilan datos para recordar las decisiones que toman los usuarios para mejorar y personalizar su experiencia."|x_translate}</label>
                                <div class="switch-container">
                                    <input type="checkbox" class="funcional switch-checkbox pull-right" data-toggle="switch" checked data-on-text='{"Si"|x_translate}' data-off-text='{"No"|x_translate}'/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="okm-row"> 
                        <div class="col-xs-12 cookie-type">
                            <h3>{"Cookies de analiticas"|x_translate}</h3>
                            <div class="form-group">
                                <label>{"Estas cookies nos ayudan a comprender cómo los visitantes interactúan con nuestro sitio, descubrir errores y proporcionar un mejor análisis general."|x_translate}</label>
                                <div class="switch-container">
                                    <input type="checkbox"  class="analiticas switch-checkbox pull-right" data-toggle="switch"  checked data-on-text='{"Si"|x_translate}' data-off-text='{"No"|x_translate}' />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="okm-row">
                        <div class="col-xs-12 text-center">
                            <button id="btnRegistrarPreferenciasCookies" class="btn-default btn-xs" type="button">{"guardar"|x_translate}</button>
                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                </div>

            </div>
        </div>
    </div>
</div>
<script>
    var from_submodulo = "{$submodulo}";
</script>
{literal}
    <script>
        /* function that stores the info in a cookie variable*/
        function setCookie(cname, cvalue, exdays) {
            const d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            let expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }
        /*function that returns the value of a specified cookie:*/
        function getCookie(cname) {
            let name = cname + "=";
            let decodedCookie = decodeURIComponent(document.cookie);
            let ca = decodedCookie.split(';');
            for (let i = 0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }
        $(function () {
            $('.switch-checkbox').bootstrapSwitch();
            let ConsentCookies = getCookie("ConsentCookies");
            console.log("ConsentCookies", ConsentCookies);
            if (ConsentCookies === "") {
                $("#cookie-msg").slideDown();
            } else {
                let ConsentCookies_arr = ConsentCookies.split("+");
                console.log(ConsentCookies_arr);

                let analiticas = ConsentCookies_arr[0].split("=")[1];
                let funcionales = ConsentCookies_arr[1].split("=")[1];
                if (analiticas == "1" || funcionales == "1") {
                    x_loadModule("statics", "header_using_cookies", "analiticas=" + analiticas + "&funcionales=" + funcionales + "&from_submodulo=" + from_submodulo, "third_party_plugin_container");
                }
            }

            //mostrar modal cookies

            //acpetar todas las cookies
            $("#btn-aceptar-cookies").click(function () {
                //guardamos la configuracion en la cookies
                setCookie("ConsentCookies", "analiticas=" + 1 + "+funcionales=" + 1, 30);
                //cargamos los plugins de 3eros permitidos
                x_loadModule("statics", "header_using_cookies", "analiticas=1&funcionales=1&from_submodulo=" + from_submodulo, "third_party_plugin_container");
                $("#cookie-msg").fadeOut();
            });

            //abrir modal configuracion
            $("#btn-personalizar-cookies").click(function () {
                $("#modal-parametros-cookies").modal("show");

            });


            //guardar configuracion avanzada
            $("#btnRegistrarPreferenciasCookies").click(function () {
                let analiticas = $("#modal-parametros-cookies .analiticas").is(":checked") ? "1" : "0";
                let funcionales = $("#modal-parametros-cookies .funcional").is(":checked") ? "1" : "0";
                console.log("cookies-analiticas", analiticas);
                console.log("cookies-funcionales", funcionales);
                //guardamos la configuracion en la cookies
                setCookie("ConsentCookies", "analiticas=" + analiticas + "+funcionales=" + funcionales, 30);
                //cargamos los plugins de 3eros permitidos
                if (analiticas == "1" || funcionales == "1") {
                    x_loadModule("statics", "header_using_cookies", "analiticas=" + analiticas + "&funcionales=" + funcionales + "&from_submodulo=" + from_submodulo, "third_party_plugin_container");
                }
                $("#modal-parametros-cookies").modal("hide");
                $("#cookie-msg").fadeOut();
            });

        });
    </script>
{/literal}