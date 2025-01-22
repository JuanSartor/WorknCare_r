<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
{*preview mensaje bienvenida*}
<section class="pass-sante-registro-planes bienvenida-preview" >


    {if  $cuestionario!='' && $cuestionario.fecha_fin|date_format:"%Y/%m/%d" > $smarty.now|date_format:"%Y/%m/%d" }
        <div class="preview-container">
            {include file="programa_salud_registro/cuestionario.tpl"}
        </div>
    {else}
        <div class="okm-container">
            <div class="card" style="margin-top: 60px;">
                <div class="plogin-header">
                    {if $cuestionario.fecha_fin|date_format:"%Y/%m/%d" <= $smarty.now|date_format:"%Y/%m/%d" }
                        <h3>{"El enlace ha caducado."|x_translate}</h3>
                    {else}
                        <h3>{"El enlace no es válido."|x_translate}</h3>
                    {/if}
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