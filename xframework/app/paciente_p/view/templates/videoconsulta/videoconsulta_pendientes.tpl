<div id="div_videoconsulta_pendientes" class="relative cs-nc-section-holder">
    {include file="videoconsulta/videoconsulta_settings.tpl"}

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {* <li class="active">{"Pendientes"|x_translate}</li>*}
        </ol>
    </div>

    <input type="hidden" id='cant_consulta_pendientes' value="{$cantidad_consulta.pendientes}" />
    {if $listado_videoconsultas_pendientes.rows && $listado_videoconsultas_pendientes.rows|@count > 0}


        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-clock"></i></figure>
                        {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span>{/if}
                    </div>
                    <span>{"PENDIENTES"|x_translate}</span>
                </div>
            </div>
            <div class="cs-ca-consultas-holder">
                {foreach $listado_videoconsultas_pendientes.rows item=videoconsulta_pendiente}
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar">
                                    <div class="row">
                                        {*header medico consulta*}
                                        {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$videoconsulta_pendiente} 

                                        {*header tipo consulta*}
                                        {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$videoconsulta_pendiente} 

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_pendiente.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Respuesta aproximada en"|x_translate}</span>
                                                <div class="cs-ca-tiempo-respuesta">
                                                    {if $videoconsulta_pendiente.segundos_diferencia > 0}
                                                        <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span><span data-id="{$videoconsulta_pendiente.idvideoconsulta}" data-startsec="{$videoconsulta_pendiente.segundos_diferencia}" data-fecha-vencimiento="{$videoconsulta_pendiente.fecha_vencimiento}" class="cs-ca-tiempo-respuesta-num timer-1"></span>
                                                        {/if}
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_pendiente.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo"|x_translate}:</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_pendiente.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_pendiente.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="{$url}panel-paciente/videoconsulta/pendientes-{$videoconsulta_pendiente.idvideoconsulta}.html">
                                                        <i class="icon-doctorplus-plus"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}

            </div>

            <div class="row">

                <div class="row">
                    <div class="col-xs-12">
                        <div class="paginas">
                            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_pendientes" container_id="div_videoconsulta_pendientes"}
                        </div>
                    </div>
                </div>
            </div>

        </section>


    {else}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">

                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>

                        </div>
                        <span>{"PENDIENTES"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="fas fa-user-clock"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Pendientes de confirmación"|x_translate}</p>
                </div>
            </section>
        </div>

    {/if}

</div>
{literal}
    <script>
        $(document).ready(function (e) {
            renderUI2();
            // timer tiempo restante
            $.each($('.timer-1'), function (idx, elem) {

                if ($(elem).data("fecha-vencimiento") !== "") {
                    var [date_part, time_part] = $(elem).data("fecha-vencimiento").split(" ");
                    var date = date_part.split("-");
                    var time = time_part.split(":");
                    var countDownDate = new Date(date[0], date[1] - 1, date[2], time[0], time[1], time[2]).getTime();

                    // Actualizamos el contador cada segundo
                    var x = setInterval(function () {

                        //Calculo el tiempo actual
                        var now = new Date().getTime();

                        // calulamos el tiempo restante
                        var distance = countDownDate - now;

                        // Calculamos dias, horas, segundos 
                        var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                        var seconds = Math.floor((distance % (1000 * 60)) / 1000);

                        if (hours < 10) {
                            hours = "0" + hours;
                        }
                        if (minutes < 10) {
                            minutes = "0" + minutes;
                        }
                        if (seconds < 10) {
                            seconds = "0" + seconds;
                        }

                        // Actualizamos el tiempo restante en la consulta
                        $(elem).text(hours + "h " + minutes + "mn " + seconds + "s");

                        // cuando finaliza el tiempo ocultamos el timer
                        if (distance < 0) {
                            clearInterval(x);
                            $(elem).text(x_translate("Tiempo cumplido"), );
                        }
                    }, 1000);
                }

            });

            //informamos al usuario que se envio la consulta y debe esperar la respuesta
            if (parseInt($("#cant_consulta_pendientes").val()) > 0 && localStorage.getItem('show_notify_vc_pendientes') != "0") {
                notify({title: x_translate("Video Consulta enviada"), text: x_translate("Su solicitud de Video Consulta ha sido enviada, el profesional tiene plazo para enviarle su respuesta"), style: "video-consulta"});
                localStorage.setItem('show_notify_vc_pendientes', 0);
            }
        });
    </script>
{/literal}