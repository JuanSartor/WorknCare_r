{if $paciente.teaser_home_paciente==1 && $paciente.email!=""}

    <div class="container" id="teaser_home_paciente">
        <div class="row">
            <div class="pacientes-sin-cargo" style="margin-bottom:0px;">
                <div class="pacientes-sin-cargo-disclaimer padding-banner">
                    {if $paciente.is_paciente_empresa=="1"}
                        <h3 style="font-size:16px !important; line-height:1; margin-bottom:10px; margin-top:0px;"><strong>{"Utilice su Pase para consultar sobre +150 temas."|x_translate}</strong></h3>
                        <h3 style="font-size:16px !important; line-height:1.5; margin-bottom:0px; margin-top:0px;">{"Tienes sesiones prepagas, ¡aprovéchalas!"|x_translate}</h3>
                    {else}
                        {if $paciente.pais_idpais==1}
                            <h3 style="font-size:16px !important; line-height:1; margin-bottom:10px; margin-top:0px;"><strong>{"Tiene la posibilidad de beneficiar un reintegro por la caja cuando agenda una videoconsulta con su medico de cabecera y médico de ciertas especialidades. (paciente frances)"|x_translate}</strong></h3>
                            <h3 style="font-size:16px !important; line-height:1.5; margin-bottom:0px; margin-top:0px;">{"Invítelo ahora mismo! (paciente frances)"|x_translate}</h3>
                        {else}
                            <h3 style="font-size:16px !important; line-height:1; margin-bottom:10px; margin-top:0px;"><strong>{"Tiene la posibilidad de beneficiar un reintegro por la caja cuando agenda una videoconsulta con su medico de cabecera y médico de ciertas especialidades. (paciente no frances)"|x_translate}</strong></h3>
                            <h3 style="font-size:16px !important; line-height:1.5; margin-bottom:0px;margin-top:0px;">{"Invítelo ahora mismo! (paciente no frances)"|x_translate}</h3>
                        {/if}
                    {/if}
                </div>
                <div class="pacientes-sin-cargo-disclaimer-footer">
                    <div class="okm-row">

                        <div class="colx2 colx1">
                            <label class="checkbox pacientes-sin-cargo-disclaimer-check">
                                <input type="checkbox" value="" id="btnNoMostrarTeaser" data-toggle="checkbox" class="custom-checkbox"><span class="icons"><span class="icon-unchecked"></span><span class="icon-checked"></span></span>
                                        {"No ver más este mensaje"|x_translate}
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/if}
{literal}
    <script>
        $(function () {
            //ocultar teaser
            $("#teaser_home_paciente .close-box").click(function () {
                $("#teaser_home_paciente").slideUp();
            });

            //no mostrar mas el teaser
            $("#btnNoMostrarTeaser").click(function () {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'no_mostrar_teaser_home.do',
                        'idpaciente=' + $("#idpaciente").val(),
                        function (data) {
                            $("#teaser_home_paciente").slideUp();

                        }

                );
            });
        });
    </script>
{/literal}
