<div id="div_bandeja_entrada">
    {* {include file="videoconsulta/videoconsulta_settings.tpl"} *}

    <!--  <section class="container-fluid">
          <div class="row">
              <div class="col-md-12">
                  <div class="container">
                      <ol class="breadcrumb">
                          <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
    {*<li class="active">{"Video Consulta"|x_translate}</li>*}
</ol>
</div>
</div>
</div>
</section>
    -->

    <div class="okm-container container-header container-header-mobile">
        <a  href="{$url}panel-paciente/"  class="btn-volver-home-sante btn-volver-reembolso container-btn-a-volver"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
        <h1 class="h1-personalizado">{"Video Consulta"|x_translate}</h1>
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

                //ocultamos el modal de alerta y ejecutamos el test rtc
                $("#btnRunTestRTC").click(function () {
                    $("#checkRTC_container").empty();
                    $("body").spin("large");

                    x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                        $("body").spin(false);
                        $("#run-checkrtc").modal("show");

                    });
                });


            });
        </script>
    {/literal}

    <section id="div_bandeja_entrada_videoconsulta" class="consulta-express-submenu">
        <div class="container">
            <div class="row">
                <div class="col-sm-12 menu-consulta-item ">

                    <div class="consulta-express-consultar-icon-holder-lg nueva" >
                        <a href="{$url}panel-paciente/videoconsulta/nuevavideoconsulta.html" >
                            <div class="nueva-consulta">
                                <figure class="mvc-nueva">
                                    <i class="icon-doctorplus-video-cam"></i>
                                    <span>{"NUEVA VIDEO CONSULTA"|x_translate}</span>
                                </figure>
                            </div>
                        </a>
                    </div>
                </div>

            </div>
            <div class="row">
                <div class="col-sm-12 menu-consulta-item ">
                    {*
                    <div class="consulta-express-submenu-icon-holder-lg consultorio-virtual" >
                    <a href="{$url}panel-paciente/videoconsulta/sala/" id="btnCheckRTC" >
                    <div>
                    <figure><i class="icon-doctorplus-video-call"></i></figure>
                    <span class="mvc-entrar-sala mvc-cam-animation" {if $cantidad_consulta.en_curso==0}style="display:none;"{/if} ><i class="icon-doctorplus-video-cam"></i></span>
                    </div>
                    <span>{"CONSULTORIO VIRTUAL"|x_translate}</span>
                    </a>
                    </div>
                    *}
                    <div class="consulta-express-submenu-icon-holder-lg abiertas" >
                        <a href="{$url}panel-paciente/videoconsulta/sala-espera.html">
                            <div id="div_abiertas">
                                <figure class="mvc-lista-icon"><i class="icon-doctorplus-video-sheet"></i></figure>
                                <span class="mvc-entrar-sala mvc-cam-animation" {if $cantidad_consulta.en_curso==0}style="display:none;"{/if} ><i class="icon-doctorplus-video-cam"></i></span>
                                {if $cantidad_consulta.abiertas>0} <span>{$cantidad_consulta.abiertas}</span> {/if}

                            </div>
                            <span>{"SALA DE ESPERA"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg pendientes">
                        <a href="{$url}panel-paciente/videoconsulta/pendientes.html" >
                            <div id="div_pendientes">
                                <figure><i class="fas fa-user-clock"></i></figure>
                                {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span> {/if}

                            </div>
                            <span>{"PENDIENTES"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-lg finalizadas" >
                        <a href="{$url}panel-paciente/videoconsulta/finalizadas.html" >
                            <div id="div_finalizadas">
                                <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                {if $cantidad_consulta.finalizadas>0} <span>{$cantidad_consulta.finalizadas}</span> {/if}

                            </div>
                            <span>{"FINALIZADAS"|x_translate}</span>
                        </a>
                    </div>

                    <div class="consulta-express-submenu-icon-holder-sm declinadas" >
                        <a href="{$url}panel-paciente/videoconsulta/declinadas.html" >
                            <div id="div_rechazadas">
                                <figure><i class="fas fa-user-times"></i></figure>
                                {if $cantidad_consulta.rechazadas>0} <span>{$cantidad_consulta.rechazadas}</span> {/if}

                            </div>
                            <span>{"DECLINADAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm vencidas" >
                        <a href="{$url}panel-paciente/videoconsulta/vencidas.html" >
                            <div id="div_vencidas">
                                <figure><i class="far fa-calendar-times"></i></figure>
                                {if $cantidad_consulta.vencidas>0} <span>{$cantidad_consulta.vencidas}</span> {/if}

                            </div>
                            <span>{"VENCIDAS"|x_translate}</span>
                        </a>
                    </div>
                    <div class="consulta-express-submenu-icon-holder-sm check-rtc">
                        <a id="btnRunTestRTC" href="javascript:;">
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
    <div id="div_pendientes_finalizacion"></div>
    <div id="div_pasos_videoconsulta" ></div>
</div>
<div id="guia_uso_container"></div>

{literal}
    <script>
        $(function () {
            if (getViewportWidth() > 768) {
                x_loadModule("videoconsulta", "guia_uso", "", "guia_uso_container", BASE_PATH + "paciente_p");
            }
            x_loadModule('videoconsulta', 'videoconsulta_pendientes_finalizacion', 'do_reset=1', 'div_pendientes_finalizacion', BASE_PATH + 'paciente_p');
        });
    </script>
{/literal}
