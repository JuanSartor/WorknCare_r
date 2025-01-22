{*verificamos si es la activacion de cuenta de un usuario secundario que debe generar su password*}
{if $usuario_secundario["idusuario_empresa"] != ""}
    {include file="statics/setear_contrasenia_usuario_empresa.tpl"}
{else}
    {include file="programa_salud_registro/menu.tpl"}
    {if $particular=="1"}
        {include file="home/login.tpl"}
    {else}
        {include file="programa_salud_registro/login.tpl"}
    {/if}

    <link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

    <section class="pass-sante-registro-planes">
        <div class="okm-container creacion-cuenta">
            <div class="plogin-header">
                {if $respuesta_activacion.result}

                    {if !$respuesta_activacion.activo}
                        <h3>{"¡Se ha activado su cuenta de manera exitosa!"|x_translate}</h3>
                    {else}
                        <h3>{"¡Ya se encuentra activo en DoctorPlus!"|x_translate}</h3>

                    {/if}
                    <p align="center">{"Inicie sesión para gestionar sus beneficiarios"|x_translate}</p>


                {else}
                    <h3>{"Se produjo un error en la activación."|x_translate} <span class="color_rojo">Doctor</span>Plus!</h3>
                {/if}

                <p>&nbsp;</p>
                {if $respuesta_activacion.result}
                    <div class="center">
                        {if $empresa["plan_idplan"]=='21' || $empresa["plan_idplan"]=='22' || $empresa["plan_idplan"]=='23'}
                            <a href="{$url}?connecter=1"   class="btn-default">{"iniciar sesión"|x_translate}</a>
                        {else}
                            <a href="{$url}creer-compte.html?connecter"   class="btn-default">{"iniciar sesión"|x_translate}</a>
                        {/if}
                    </div>
                {else}
                    <div class="center">
                        <a href="{$url}" class="btn-default">{"volver"|x_translate}</a>
                    </div>
                {/if}

                <p>&nbsp;</p>
            </div>
        </div>

    </section>
    {literal}
        <script>
            /*  esto lo comente porque tiraba un error del CORS
             * lo que hice fue comentar esto y agregar la direccion en el href
             *  y borre tambien  de la etiqueta a  id="loginActivacion" data-toggle="modal" data-target=".login" 
             * 
             * $(function () {
             $('#loginActivacion').on('click', function (e) {
             $('#login').show();
             $('#passrecovery').hide();
             
             $('#timeout').hide();
             });
             
             
             }); */
        </script>
    {/literal}
{/if}
