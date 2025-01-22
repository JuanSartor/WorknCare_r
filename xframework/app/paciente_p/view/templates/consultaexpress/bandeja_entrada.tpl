<div id="div_bandeja_entrada">
    {* {include file="consultaexpress/consultaexpress_settings.tpl"} *}

    <!-- <section class="container-fluid">
         <div class="row">
             <div class="col-md-12">
                 <div class="container">
                     <ol class="breadcrumb">
                         <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
    {*<li class="active">{"Consulta Express"|x_translate}</li>*}
</ol>
</div>
</div>
</div>
</section>
    -->
    <div class="okm-container container-header container-header-mobile">
        <div class="container-a">
            <a href="{$url}panel-paciente/"  class="btn-volver-home-sante btn-volver-reembolso a-personalizado container-btn-a-volver"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
        </div>
        <h1 class="h1-personalizado">{"Consulta Express"|x_translate}</h1>
    </div>

    {*
    <section class="module-header">
    <h1 class="section-header">{"Consultas"|x_translate}</h1>
    </section>
    *}
    <section id="div_bandeja_entrada_consultaexpress" class="consulta-express-submenu">
        <div class="container">
            <div class="row">
                <div class="col-sm-12 menu-consulta-item ">

                    <div class="consulta-express-consultar-icon-holder-lg nueva" >
                        <a href="{$url}panel-paciente/consultaexpress/nuevaconsulta.html" >
                            <div class="nueva-consulta">
                                <figure class="mvc-nueva">
                                    <i class="icon-doctorplus-chat-empty"></i>
                                    <span>{"NUEVA CONSULTA"|x_translate}</span>
                                </figure>
                            </div>
                        </a>
                    </div>
                </div>

            </div>
            <div class="row">
                <div class="col-sm-12 menu-consulta-item">
                    <div class="consulta-express-submenu-icon-holder-lg abiertas">
                        <a href="{$url}panel-paciente/consultaexpress/abiertas.html" >

                            <div id="div_abiertas">
                                <figure><i class="icon-doctorplus-chat-comment"></i></figure>
                                {if $cantidad_consulta.abiertas>0} <span>{$cantidad_consulta.abiertas}</span> {/if}
                            </div>

                            <span>{"ABIERTAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg pendientes">
                        <a href="{$url}panel-paciente/consultaexpress/pendientes.html" >
                            <div id="div_pendientes">
                                <figure><i class="fas fa-user-clock"></i></figure>
                                {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span>{/if}
                            </div>
                            <span>{"PENDIENTES"|x_translate}</span>
                        </a>
                    </div>

                    <div class="consulta-express-submenu-icon-holder-lg finalizadas">
                        <a href="{$url}panel-paciente/consultaexpress/finalizadas.html" >
                            <div id="div_finalizadas">
                                <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                {if $cantidad_consulta.finalizadas>0}<span>{$cantidad_consulta.finalizadas}</span>{/if}
                            </div>
                            <span>{"FINALIZADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm declinadas">
                        <a href="{$url}panel-paciente/consultaexpress/declinadas.html" >
                            <div id="div_rechazadas">
                                <figure><i class="fas fa-user-times"></i></figure>
                                {if $cantidad_consulta.rechazadas>0}<span>{$cantidad_consulta.rechazadas}</span>{/if}
                            </div>
                            <span>{"DECLINADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm vencidas">
                        <a href="{$url}panel-paciente/consultaexpress/vencidas.html" >
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
<div id="guia_uso_container"></div>

{literal}
    <script>
        $(function () {
            if (getViewportWidth() > 768) {
                x_loadModule("consultaexpress", "guia_uso", "", "guia_uso_container", BASE_PATH + "paciente_p");
            }
        });
    </script>
{/literal}