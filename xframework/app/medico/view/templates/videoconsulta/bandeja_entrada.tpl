<div id="div_bandeja_entrada">
    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <div class="container">
        <div class="okm-row">
            <nav class="breadcrum">
                <ul>
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                        {*<li class="active">{"Video Consultas"|x_translate}</li>*}
                </ul>
            </nav>
        </div>
    </div>


    <!-- checkRTC modal -->
    <div id="checkrtc-modal" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"><i class="fa fa-wrench"></i>&nbsp;{"Chequeo de compatibilidad para Video Consultas"|x_translate}</h4>
                </div>
                <div class="modal-body">
                    <p>
                        {"Es importante que realice un chequeo general del sistema para asegurarse que su ordenador está en condiciones de recibir videoconsultas"|x_translate}
                    </p>
                    <div class="text-center">  
                        <a href="javascript:;" class="btn-sm btn-primary" id="btnRunTestRTC">{"Comenzar test de utilización"|x_translate}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {*TEST RTC*}
    <link rel="stylesheet" href="{$url}xframework/app/themes/dp02/css/checkrtc.css">
    <script type="text/javascript" src="https://static.opentok.com/v2/js/opentok.min.js"></script>
    <script src="{$url}xframework/files/session_conectividad.js"></script>
    <script src="{$url}xframework/core/libs/libs_js/bundle_test_conectividad_2.js"></script>
    <div id="run-checkrtc" class="modal fade " tabindex="-1" role="dialog"  data-backdrop="static" data-keyboard="false" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-dialog-centered" role="document" >
            <div class="modal-content" id="checkRTC_container">
            </div>
        </div>
    </div>

    {literal}
        <script>
            $(function () {
                //recargar test
                if (localStorage.getItem('reload_checkrtc') == 1) {
                    console.log("reload test rtc");
                    localStorage.removeItem('reload_checkrtc');
                    $("#checkRTC_container").empty();
                    $("body").spin("large");

                    x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                        $("body").spin(false);
                        $("#run-checkrtc").modal("show");

                    });
                } else if (localStorage.getItem('hide_checkrtc_modal') != 1) {
                    //mostrar modal sugerencia test
                    $("#checkrtc-modal").modal("show");
                }

                //ocultamos el modal de alerta y ejecutamos el test rtc
                $("#btnRunTestRTC").click(function () {
                    $("#checkRTC_container").empty();
                    $("body").spin("large");

                    x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                        $("body").spin(false);
                        $("#checkrtc-modal").modal("hide");
                        $("#run-checkrtc").modal("show");

                    });
                });


            });
        </script>
    {/literal}

    <!-- /checkRTC modal -->

    <section id="div_bandeja_entrada_videoconsulta" class="consulta-express-submenu">
        <div class="container">
            <div class="row">
                <div class="col-sm-12 menu-consulta-item">
                    <div class="consulta-express-submenu-icon-holder-lg red">
                        <a href="{$url}panel-medico/videoconsulta/red.html" >
                            <div id="div_red">
                                <figure class=" {if $cantidad_consulta.red>0}mvc-active{/if}"><i class="icon-doctorplus-people-add consulta-portada-lg-icon"></i></figure>
                                {if $cantidad_consulta.red>0} <span>{$cantidad_consulta.red}</span> {/if}
                            </div>
                            <span>{"PUBLICADAS EN LA RED"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg pendientes">
                        <a href="{$url}panel-medico/videoconsulta/pendientes.html">
                            <div id="div_pendientes">
                                <figure class="mvc-lista-icon"><i class="fas fa-user-clock"></i></figure>
                                {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span> {/if}

                            </div>
                            <span>{"RECIBIDAS"|x_translate}</span>
                        </a>
                    </div>
                    {*
                    <div class="consulta-express-submenu-icon-holder-lg consultorio-virtual">
                    <a href="{$url}panel-medico/videoconsulta/sala/" >
                    <div>
                    <figure><i class="icon-doctorplus-video-call mvc-sala-icon"></i></figure>
                    </div>
                    <span>{"CONSULTORIO VIRTUAL"|x_translate}</span>
                    </a>
                    </div>
                    *}
                    <div class="consulta-express-submenu-icon-holder-lg abiertas">
                        <a href="{$url}panel-medico/videoconsulta/sala-espera.html">
                            <div id="div_abiertas">
                                <figure class="mvc-lista-icon"><i class="icon-doctorplus-video-sheet"></i></figure>
                                <span class="mvc-entrar-sala  mvc-cam-animation"  {if $cantidad_consulta.en_curso==0}style="display:none;"{/if} ><i class="icon-doctorplus-video-cam"></i></span>
                                {if $cantidad_consulta.abiertas>0} <span>{$cantidad_consulta.abiertas}</span> {/if}

                            </div>
                            <span>{"SALA DE ESPERA"|x_translate}</span>
                        </a>
                    </div>

                    <div class="consulta-express-submenu-icon-holder-lg finalizadas">
                        <a href="{$url}panel-medico/videoconsulta/finalizadas.html">
                            <div id="div_finalizadas">
                                <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                {if $cantidad_consulta.pendientes_finalizacion>0} <span>{$cantidad_consulta.pendientes_finalizacion}</span> {/if}

                            </div>
                            <span>{"FINALIZADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm declinadas">
                        <a href="{$url}panel-medico/videoconsulta/declinadas.html" >
                            <div id="div_rechazadas">
                                <figure><i class="fas fa-user-times"></i></figure>
                                {if $cantidad_consulta.rechazadas>0} <span>{$cantidad_consulta.rechazadas}</span> {/if}
                            </div>
                            <span>{"DECLINADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm vencidas">
                        <a href="{$url}panel-medico/videoconsulta/vencidas.html" >
                            <div id="div_vencidas">
                                <figure><i class="far fa-calendar-times"></i></figure>
                                {if $cantidad_consulta.vencidas>0} <span>{$cantidad_consulta.vencidas}</span> {/if}
                            </div>
                            <span>{"VENCIDAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm check-rtc">
                        <a id="btnTestRTC" href="javascript:;">
                            <div id="div_test">
                                <figure><i class="fa fa-wrench"></i></figure>                       
                            </div>
                            <span>{"TEST D'UTILISATION"|x_translate}</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
{if ($listado_videoconsultas_interrumpidas.rows && $listado_videoconsultas_interrumpidas.rows|@count > 0) || ($listado_videoconsultas_pendientes_finalizacion.rows && $listado_videoconsultas_pendientes_finalizacion.rows|@count > 0)}
    <section class="vc-interrumpidas">
        <div id="div_interrumpidas">
            {include file="videoconsulta/videoconsulta_interrumpidas.tpl"}

        </div>
        <div id="div_pendientes_finalizacion" class="okm-container">
            {include file="videoconsulta/videoconsulta_pendientes_finalizacion.tpl"}
        </div>
    </section>
{/if}
<section class="mvc-video-consulta-disclaimer">
    <div class="okm-container">
        <h3>
            {"Recuerde que al finalizar la Video Consulta el sistema le solicitará que deje registro de sus conclusiones."|x_translate}
        </h3>
        <p>
            {"El ingreso de sus conclusiones es requisito indispensable para que el sistema le transfiera el pago de dicha consulta"|x_translate}
        </p>
    </div>
</section>
        
<div id="guia_uso_container"></div>


{literal}
    <script>

        $(function () {

            $("#btnTestRTC").click(function () {
                $("#checkRTC_container").empty();
                $("#checkRTC_container").spin("large");
                $("#run-checkrtc").modal("show");
                x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                    $("#checkRTC_container").spin(false);
                });
            });

            if (getViewportWidth() > 768) {
                x_loadModule("consultaexpress", "guia_uso", "", "guia_uso_container", BASE_PATH + "medico");
            }
        });

    </script>
{/literal}
