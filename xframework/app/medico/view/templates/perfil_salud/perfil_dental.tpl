{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}
<section class="module-header container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}
<section class="ok-container pps-prox">
    {*<div class="pps-prox-header">
        <figure><i class="icon-doctorplus-dental"></i></figure>
        <h1>{"Control dental"|x_translate}</h1>
    </div>*}
    <div class="pps-prox-content-box">
        <h4>{"Próximamente"|x_translate}</h4>
        <p>{"¡Estamos trabajando para ofrecerle nuevos controles para cuidar mejor de su salud!"|x_translate}</p>
    </div>
</section>
{literal}
<script>$(document).ready(function () {
        $("ul.slider-menu li a").removeClass("active");
        $("ul.slider-menu li i.dpp-dental").parent().addClass("active");
    });
</script>
{/literal}