<div id="div_bandeja_entrada">
    {include file="consultaexpress/consultaexpress_settings.tpl"}

    <section class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                            {*<li class="active">{"Consulta Express"|x_translate}</li>*}

                    </ol>
                </div>
            </div>
        </div>
    </section>
    {*
    <section class="module-header">
    <h1 class="section-header">{"Consultas"|x_translate}</h1>
    </section>
    *}

    <section id="div_bandeja_entrada_consultaexpress" class="consulta-express-submenu">
        <div class="container">

            <div class="row">
                <div class="col-sm-12 menu-consulta-item" >
                    <div class="consulta-express-submenu-icon-holder-lg abiertas">
                        <a href="{$url}panel-medico/consultaexpress/abiertas.html" >
                            <div id="div_abiertas">
                                <figure><i class="icon-doctorplus-chat-comment"></i></figure>
                                {if $cantidad_consulta.abiertas>0} <span>{$cantidad_consulta.abiertas}</span> {/if}
                            </div>
                            <span>{"ABIERTAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg pendientes" >
                        <a href="{$url}panel-medico/consultaexpress/pendientes.html" >
                            <div id="div_pendientes">
                                <figure><i class="fas fa-user-clock"></i></figure>
                                {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span>{/if}
                            </div>
                            <span>{"RECIBIDAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg red">
                        <a href="{$url}panel-medico/consultaexpress/red.html" >
                            <div id="div_red">
                                <figure class="{if $cantidad_consulta.red>0}mvc-active{/if}"><i class="icon-doctorplus-people-add consulta-portada-lg-icon"></i></figure>
                                {if $cantidad_consulta.red>0}<span>{$cantidad_consulta.red}</span>{/if}
                            </div>
                            <span>{"PUBLICADAS EN LA RED"|x_translate}</span>
                        </a>
                    </div>

                    <div class="consulta-express-submenu-icon-holder-sm finalizadas">
                        <a href="{$url}panel-medico/consultaexpress/finalizadas.html" >
                            <div id="div_finalizadas">
                                <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                {if $cantidad_consulta.pendientes_finalizacion>0}<span>{$cantidad_consulta.pendientes_finalizacion}</span>{/if}
                            </div>
                            <span>{"FINALIZADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm declinadas">
                        <a href="{$url}panel-medico/consultaexpress/declinadas.html" >
                            <div id="div_rechazadas">
                                <figure><i class="fas fa-user-times"></i></figure>
                                {if $cantidad_consulta.rechazadas>0}<span>{$cantidad_consulta.rechazadas}</span>{/if}
                            </div>
                            <span>{"DECLINADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm vencidas">
                        <a href="{$url}panel-medico/consultaexpress/vencidas.html" >
                            <div id="div_vencidas">
                                <figure><i class="far fa-calendar-times"></i></figure>
                                {if $cantidad_consulta.vencidas>0} <span>{$cantidad_consulta.vencidas}</span>{/if}
                            </div>
                            <span>{"VENCIDAS"|x_translate}</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
{*pendientes de finalizacion*}
{if $listado_consultas_pendientes_finalizacion.rows && $listado_consultas_pendientes_finalizacion.rows|@count > 0 }
    <div class="cs-nc-section-holder">	
        <section class="container cs-nc-p2">
            <div id="div_pendientes_finalizacion">
                {include file="consultaexpress/consultaexpress_pendientes_finalizacion.tpl"}
            </div>
        </section>
    </div>
{/if}

<div id="guia_uso_container"></div>

{literal}
    <script>
        $(function () {
            if (getViewportWidth() > 768) {
                x_loadModule("consultaexpress", "guia_uso", "", "guia_uso_container", BASE_PATH + "medico");
            }
        });
    </script>
{/literal}