<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
{*preview mensaje bienvenida*}
<section class="pass-sante-registro-planes bienvenida-preview" >

    {if  $invitacion!='' }
        <div class="preview-container">
            {include file="programa_salud_registro/capsula.tpl"}
        </div>
    {else}
        <div class="okm-container">
            <div class="card" style="margin-top: 60px;">
                <div class="plogin-header">
                    <h3>{"El enlace no es válido."|x_translate}</h3>
                    <p class="text-center">{"Comuníquese con su empleador para recibir uno nuevo"|x_translate} </p>
                </div>
                <div class="text-center">
                    <a href="{$url}" class="btn-default">{"volver"|x_translate}</a>
                </div>
            </div>
        </div>
    {/if} 


</div>
{literal}
    <script>
        $(function () {

        });
    </script>
{/literal}