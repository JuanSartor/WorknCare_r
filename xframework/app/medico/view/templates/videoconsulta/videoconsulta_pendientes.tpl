<div id="div_videoconsulta_pendientes" class="relative cs-nc-section-holder">

    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {*<li class="active">{"Recibidas"|x_translate}</li>*}

        </ol>
    </div>
    {if $listado_videoconsultas_pendientes.rows && $listado_videoconsultas_pendientes.rows|@count > 0}


        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-medico/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-clock"></i></figure>
                            {if $cantidad_consulta.pendientes>0}
                            <span>{$cantidad_consulta.pendientes}</span>
                        {/if}
                    </div>
                    <span>{"RECIBIDAS"|x_translate}</span>
                </div>
            </div>


            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_videoconsultas_pendientes.rows key=key item=videoconsulta_pendiente}
                        <div class="panel {if $videoconsulta_pendiente.tomada=="1" &&  $videoconsulta_pendiente.tipo_consulta=="0"} ceprr-accordion {/if} panel-default">
                            <div class="panel-heading" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar">
                                    <div class="row">
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                <div class="cs-ca-usr-avatar">
                                                    {if $videoconsulta_pendiente.paciente.image}
                                                        <img src="{$videoconsulta_pendiente.paciente.image.list}" alt="user" />
                                                    {else}
                                                        {if $videoconsulta_pendiente.paciente.animal!=1}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user" />
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user" />
                                                        {/if}
                                                    {/if}
                                                    <a href="javascript:;" class="change_miembro" data-id="{$videoconsulta_pendiente.paciente.idpaciente}">
                                                        <figure>
                                                            <i class="icon-doctorplus-pharmaceutics"></i>
                                                        </figure>
                                                    </a>
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    <span>{"Paciente"|x_translate}</span>
                                                    <h2>{$videoconsulta_pendiente.paciente.nombre} {$videoconsulta_pendiente.paciente.apellido}</h2>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                {if $videoconsulta_pendiente.paciente_titular}

                                                    <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                        {if $videoconsulta_pendiente.paciente_titular.image}
                                                            <img src="{$videoconsulta_pendiente.paciente_titular.image.perfil}" alt="user" />
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user" />
                                                        {/if}
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        {if $videoconsulta_pendiente.paciente_titular.relacion != ""}
                                                            <span>{$videoconsulta_pendiente.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                        {else}
                                                            <span>{"propietario"|x_translate}</span>
                                                        {/if}
                                                        <h2>{$videoconsulta_pendiente.paciente_titular.nombre} {$videoconsulta_pendiente.paciente_titular.apellido}</h2>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_pendiente.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Tiempo de respuesta"|x_translate}</span>
                                                <div class="cs-ca-tiempo-respuesta">
                                                    {if $videoconsulta_pendiente.segundos_diferencia > 0}
                                                        <span class="cs-ca-clock-icon">
                                                            <i class="icon-doctorplus-clock"></i>
                                                        </span>
                                                        <span data-id="{$videoconsulta_pendiente.idvideoconsulta}" data-startsec="{$videoconsulta_pendiente.segundos_diferencia}" {if $videoconsulta_pendiente.tipo_consulta=="0"} data-fecha-vencimiento="{$videoconsulta_pendiente.fecha_vencimiento_toma}" {else} data-fecha-vencimiento="{$videoconsulta_pendiente.fecha_vencimiento}" {/if} class="cs-ca-tiempo-respuesta-num timer-1"></span>
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
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_pendiente.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_pendiente.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="{$url}panel-medico/videoconsulta/pendientes-{$videoconsulta_pendiente.idvideoconsulta}.html">
                                                        <i class="icon-doctorplus-mas"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    {/foreach}

                </div>

            </div>


            <div class="row">
                <div class="col-xs-12">

                    <div class="paginas">
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_pendientes" container_id="div_videoconsulta_pendientes"}
                    </div>

                </div>
            </div>

        </section>


        {literal}
            <script>
                $(document).ready(function (e) {
                    renderUI2();
                    /* $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/

                    //redireccion al perfil salud del paciente
                    $("#div_videoconsulta_pendientes .change_miembro").click(function () {

                        window.sessionStorage.setItem("mostrar_inputs", "1");

                        var id = $(this).data("id");
                        if (parseInt(id) > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'panel-medico/change_member.do',
                                    "id=" + id,
                                    function (data) {
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/";
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                    });


                    // timer tiempo restante
                    $.each($('.timer-1'), function (idx, elem) {

                        if ($(elem).data("fecha-vencimiento") !== "") {
                            var id = $(this).data("id");

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
                                    $("#row_actions_panels_" + id).html("");
                                    $("#div_row_time_" + id).show();
                                }
                            }, 1000);
                        }

                    });


                });
            </script>
        {/literal}
    {else}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>

                        </div>
                        <span>{"RECIBIDAS"|x_translate} </span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="fas fa-user-clock"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Recibidas"|x_translate}.</p>
                </div>
            </section>
        </div>

    {/if}

</div>