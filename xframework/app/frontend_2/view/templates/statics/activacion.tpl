{if $respuesta_activacion.usuario == "medico"}
    {include file="medico/menu.tpl"}
{else}
    {** {include file="paciente/menu.tpl"} **}
{/if}
<div class="okm-container">
    <div class="home-main">
        <div class="home-doctorplus-logo">
            <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
        </div>
    </div>
</div>
{include file="home/login.tpl"}

<div class="plogin-header okm-container">
    {if $respuesta_activacion.result}
        {*MEDICO*}
        {if $respuesta_activacion.usuario == "medico"}
            <h1>{"Crear una cuenta como"|x_translate}</h1>
            <h2>{"Profesional de la Salud"|x_translate}</h2>

            {if !$respuesta_activacion.activo }
                <h3>{"¡Hemos recibido sus datos profesionales!"|x_translate} {if !$respuesta_activacion.validado}<br>{"Su cuenta se encuentra pendiente de validación."|x_translate}{/if}</h3>

            {/if}
            {if $respuesta_activacion.activo }
                <h3>{"¡Ya se encuentra activo!"|x_translate}</h3>
            {/if}
            <br>
            {if !$respuesta_activacion.validado}
                <div class='row'>
                    <div class="col-md-8 col-md-offset-2 text-center">
                        <p align="center">
                            {"Le enviaremos un mail cuando la administración de DoctorPlus verifique sus datos y su cuenta quede habilitada para operar en el sitio."|x_translate}
                        </p>
                    </div>
                </div>
            {/if}

        {/if}

        {*PACIENTE O BENEFICIARIO*}
        {if $respuesta_activacion.usuario == "paciente"}
            <h1>{"Crear una cuenta como"|x_translate}</h1>
            {if $respuesta_activacion.pass_esante == "1"}
                <h2>{"Beneficiario"|x_translate}</h2>
            {else}
                <h2>{"Paciente"|x_translate}</h2>
            {/if}

            {if !$respuesta_activacion.activo}
                <h3>{"¡Se ha activado su cuenta de manera exitosa!"|x_translate}</h3>
            {else}
                <h3>{"¡Ya se encuentra activo!"|x_translate}</h3>

            {/if}
            <br>
            <div class='row'>
                <div class="col-md-8 col-md-offset-2 text-center">
                    {if $respuesta_activacion.pass_esante == "1"}
                        <p align="center">{"Su empresa aún debe validar sus acceso al  Pase. Pronto recibirás una notificación para conectarte"|x_translate}</p>
                    {else}
                        <p align="center">{"Comience a disfrutar de los beneficios de DoctorPlus"|x_translate}</p>
                    {/if}
                </div>
            </div>



        {/if}
    {else}
        <h3>{"Se produjo un error en la activación."|x_translate} <span class="color_rojo">Doctor</span>Plus!</h3>
    {/if}

    <br>
    {if ($respuesta_activacion.usuario == "paciente" && $respuesta_activacion.pass_esante != "1") || ($respuesta_activacion.usuario == "medico" && $respuesta_activacion.activo==1 && $respuesta_activacion.validado==1 ) }
        <div class='row'>
            <div class="col-xs-12 text-center">
                <a href="javascript:;" id="loginActivacion" data-toggle="modal" data-target=".login" class="btn-default">{"iniciar sesión"|x_translate}</a>
            </div>
        </div>
    {else}
        <div class='row'>
            <div class="col-xs-12 text-center">
                <a href="{$url}/portailsalaries" class="btn-default">{"volver"|x_translate}</a>
            </div>
        </div>
    {/if}

    <p>&nbsp;</p>
</div>

{literal}
    <script>
        $(function () {
            $('#loginActivacion').on('click', function (e) {
                $('#login').show();
                $('#passrecovery').hide();

                $('#timeout').hide();
            });


        });
    </script>
{/literal}