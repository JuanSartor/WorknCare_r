{* Solo cuando no se recomendo al profesional en esta consulta*}
{if $consulta.recomendacion=="0"}
    <div class="valoracion-profesional">

        <div class="valoracion-panel-1">
            <h4 style="font-size: 16px !important;">{"Su valoración es importante para otros pacientes"|x_translate}</h4>
            <p>{"¿Recomendaría a este profesional?"|x_translate}</p>
            <div class="valoracion-profesional-checks">
                <form class="form patient-file relative" role="form" id="f_recomendacion" action="{$url}save_recomendacion_profesional.do" method="post" onsubmit="return false;">
                    <input type="hidden" name="idperfilSaludConsulta"  value="{$consulta.idperfilSaludConsulta}"/>

                    <label class="checkbox">
                        <input type="radio" data-toggle="checkbox" name="recomendado" value="1">
                        {"Si"|x_translate}
                    </label>
                    <label class="checkbox">
                        <input type="radio" data-toggle="checkbox" name="recomendado" value="0">
                        {"No"|x_translate}
                    </label>
                </form>
            </div>
            <div class="valoracion-profesional-action">
                <a href="javascript:;" id="valoracion-enviar" class="btn-default">{"Enviar opinión"|x_translate}</a>
            </div>
        </div>

        <div class="valoracion-panel-2">
            <h4  style="font-size: 16px !important;">{"¡Gracias por su tiempo!"|x_translate}</h4>
            <div class="valoracion-profesional-logo">
                <img src="{$IMGS}doctorplus_logo_160.png" alt="DoctorPlus"/>
            </div>
            <div class="valoracion-profesional-action">
                <a href="javascript:;" id="valoracion-cerrar" class="btn-default">{"Cerrar"|x_translate}</a>
            </div>
        </div>
    </div>
    {literal}
        <script>
            $(function () {


                //enviar valoracion de un profesional
                $('#valoracion-enviar').on('click', function (e) {
                    e.preventDefault();


                    if ($("#f_recomendacion :radio:checked").length != 1) {
                        x_alert(x_translate("Seleccione una opción"));
                        return false;
                    }
                    x_sendForm($('#f_recomendacion'),
                            true,
                            function (data) {

                                if (data.result) {
                                    //ocultar el div
                                    $('.valoracion-panel-1').slideUp();
                                    $('.valoracion-panel-2').slideDown();
                                } else {
                                    x_alert(data.msg);
                                }
                            });
                });

                $("#valoracion-cerrar").click(function () {
                    $(".valoracion-profesional").slideUp();
                });

            });

        </script>
    {/literal}
{/if}