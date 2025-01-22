
<input type="hidden" id="idmedico_session" value="{$idmedico}">


{if $listado_consultas_red.rows && $listado_consultas_red.rows|@count > 0}
    <section class="container ceprr-accordion">

        <div class="cs-ca-consultas-holder">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                {foreach from=$listado_consultas_red.rows key=key item=consulta_red}
                    <div class="panel panel-default">
                        <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                            <div class="ce-ca-toolbar">                         

                                <div class="row">
                                    <div class="colx3 pce-dr-col">
                                        <div class="cs-ca-colx3-inner dr-col">
                                            <div class="cs-ca-usr-avatar">
                                                {if $consulta_red.paciente.image}
                                                    <img src="{$consulta_red.paciente.image.list}" alt="{$consulta_red.paciente.nombre} {$consulta_red.paciente.apellido}"/>
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta_red.paciente.nombre} {$consulta_red.paciente.apellido}"/>
                                                {/if}
                                                <a href="javascript:;"  class="change_miembro" data-id="{$consulta_red.paciente.idpaciente}">
                                                    <figure>
                                                        <i class="icon-doctorplus-pharmaceutics"></i>
                                                    </figure>
                                                </a>
                                            </div>
                                            <div class="cs-ca-usr-data-holder">
                                                <span>{"Paciente"|x_translate}</span>
                                                <h2>{$consulta_red.paciente.nombre} {$consulta_red.paciente.apellido}</h2>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="colx3 ceprr-pariente-col">
                                        <div class="cs-ca-colx3-inner">
                                            {if $consulta_red.paciente_titular}

                                                <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                    {if $consulta_red.paciente_titular.image}
                                                        <img src="{$consulta_red.paciente_titular.image.perfil}" alt="user"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                    {/if}
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    {if $consulta_red.paciente_titular.relacion != ""}
                                                        <span>{$consulta_red.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                    {else}
                                                        <span>{"propietario"|x_translate}</span>
                                                    {/if}
                                                    <h2>{$consulta_red.paciente_titular.nombre} {$consulta_red.paciente_titular.apellido}</h2>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                    <div class="cs-ca-tiempo-respuesta-holder">
                                        <div class="cs-ca-tiempo-respuesta-inner">
                                            <span id="cs-ca-tiempo-respuesta-label-{$consulta_red.idconsultaExpress}" class="cs-ca-tiempo-respuesta-label">{"Tiempo de respuesta"|x_translate}</span>

                                            <div class="cs-ca-tiempo-respuesta">
                                                {if $consulta_red.segundos_diferencia > 0}
                                                    <span class="cs-ca-clock-icon">
                                                        <i class="icon-doctorplus-clock"></i>
                                                    </span>
                                                    <span data-id="{$consulta_red.idconsultaExpress}" data-startsec="{$consulta_red.segundos_diferencia}" data-fecha-vencimiento="{$consulta_red.fecha_vencimiento}" class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                {/if}
                                            </div>

                                        </div>
                                    </div>
                                </div>


                                <div class="row ce-ca-toolbar-row pce-header-low-row collapsed " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_red.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_red.idconsultaExpress}">
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">Nº {$consulta_red.numeroConsultaExpress}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">{$consulta_red.motivoConsultaExpress}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-date-tools">
                                            <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                            <span class="cs-ca-fecha">{$consulta_red.fecha_inicio_format}</span>
                                            <div class="cs-ca-date-tools-holder">
                                                <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div id="collapse-{$consulta_red.idconsultaExpress}" data-id="{$consulta_red.idconsultaExpress}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$consulta_red.idconsultaExpress}">
                            <div class="panel-body">
                                <div class="cs-ca-chat-holder">


                                    {foreach from=$consulta_red.mensajes item=mensaje}

                                        {if $mensaje.emisor == "p"}
                                            <div class="row chat-row">
                                                <div class="chat-line-holder pce-dr-chat">
                                                    <div class="chat-image-avatar-xn">
                                                        {if $consulta_red.paciente_titular}
                                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                {if $consulta_red.paciente_titular.image.perfil != ""}
                                                                    <img src="{$consulta_red.paciente_titular.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                            </div>
                                                        {/if}
                                                        <div class="chat-image-avatar-xn-row">
                                                            {if $consulta_red.paciente.image.perfil != ""}
                                                                <img src="{$consulta_red.paciente.image.perfil}" alt="user"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                            {/if}
                                                            <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                        </div>
                                                    </div>

                                                    <div class="chat-content">
                                                        <figure>
                                                            <div class="chat-content-date">
                                                                {$mensaje.fecha_format} hs
                                                            </div>
                                                            <p>{$mensaje.mensaje} </p>
                                                            <span class="chat-content-arrow"></span>
                                                        </figure>
                                                        {if $mensaje.cantidad_archivos_mensajes > 0}
                                                            <div class="chat-content-attach">
                                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
                                                                    <i class="fui-clip"></i>
                                                                    &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                </a>
                                                            </div>
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        {/if}

                                    {/foreach}


                                    <div  id="row_actions_panels_{$consulta_red.idconsultaExpress}" class="row">

                                        <div class="audio-actions-panel">

                                            <div class="audio-action-holder btn-slide-holder">
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder">
                                                        <div class="chat-content">
                                                            <figure>
                                                                <p class="chat-content-rechazada">
                                                                    <i class="icon-doctorplus-info-circle"></i>
                                                                    {"Al aceptar esta consulta, tendrá 10 minutos para enviar la respuesta al paciente"|x_translate}
                                                                </p>
                                                                <p class="chat-content-rechazada">
                                                                    {"Luego de ese tiempo, otro médico podrá aceptar la consulta y responder al paciente"|x_translate}
                                                                </p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                        </div>
                                                    </div>
                                                </div>
                                                <a href="javascript:;" data-send="0" data-id="{$consulta_red.idconsultaExpress}" class="ce-ca-enviar-consulta tomar-consulta"><i class="icon-doctorplus-chat-add"></i>{"Aceptar y enviar respuesta"|x_translate}</a>

                                            </div>
                                            <div class="clearfix">&nbsp;</div>
                                        </div>
                                        <div class="clearfix">&nbsp;</div>
                                    </div>
                                    <div class="row chat-row" id="div_row_time_{$consulta_red.idconsultaExpress}" {if $consulta_red.segundos_diferencia > 0} style="display: none" {/if}>
                                        <div class="chat-line-holder chat-line-answer">
                                            <div class="chat-content">
                                                <figure>
                                                    <br>
                                                    <p class="chat-content-rechazada">
                                                        <i class="fa fa-clock-o"></i>
                                                        {"Se excedió el tiempo para responder la consulta."|x_translate}
                                                    </p>
                                                    <span class="chat-content-arrow"></span>
                                                </figure>
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
    </section>

    <!--	@primer accordion-->	
    <section class="container">

        <div class="row">
            <div class="col-xs-12">

                <div class="paginas">
                    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_red" container_id="div_consultasexpress_red"}
                </div>

            </div>
        </div>

    </section>
{else}
    <div class="sin-registros">
        <i class="icon-doctorplus-chat-rss"></i>
        <h6>{"¡La sección está vacía!"|x_translate}</h6>

        <p>{"No existen Consultas Express publicadas para Profesionales en la Red en esta especialidad."|x_translate}</p>
    </div>
    {literal}
        <script>
            $(function () {
                scrollToEl($(".sin-registros"));
            });
        </script>
    {/literal}
    {*mostramos alerta si tenia una consulta en la red asociada y ya no esta publicada*}
    {if $consulta_red_historica>0}
        {literal}
            <script>
                $(function () {
                    var hide_alert_consultasexpress_red = localStorage.getItem('hide_alert_consultasexpress_red');
                    if (hide_alert_consultasexpress_red !== "1") {
                        localStorage.setItem('hide_alert_consultasexpress_red', "1");
                        notify({title: x_translate("No tiene Consultas Express en la red publicadas"), text: x_translate("Es posible que haya pasado su tiempo de publicación o que hayan sido contestadas por otro profesional"), style: "consulta-express"});
                    }
                });
            </script>
        {/literal}
    {/if}
{/if}

<!--	ALERTAS -  Consulta express actualizar listado	-->
<div id="modal-recagrar-consultaexpress-red" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  onclick="recargar_consultaexpress_red();" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"La página solicita recargarse para mantenerse actualizada."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button onclick="window.location.href = '';"> {"Recargar"|x_translate}</button>
                    <button onclick="recargar_consultaexpress_red();"> {"Permanecer en la página"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>


{literal}
    <script>
        //funcion que levanta el modal de recargar pagina cada 10 min para mantener actualizado el listado
        var recargar_consultaexpress_red = function () {
            $("#modal-recagrar-consultaexpress-red").modal("hide");

            setTimeout(function () {
                $("#modal-recagrar-consultaexpress-red").modal("show");
            }, 600000);
        };

        $(function () {
            renderUI2();
            //redireccion al perfil salud del paciente
            $("#div_consultasexpress_red .change_miembro").click(function () {

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

            //tiempo espera para mostrar el modal de recargar pagina
            setTimeout(function () {
                $("#modal-recagrar-consultaexpress-red").modal("show");
            }, 600000);

            //Tomamos la consulta para contestarla
            $('.tomar-consulta').on('click', function (e) {
                e.preventDefault();
                $("body").spin("large");
                var id = $(this).data('id');
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'tomar_consultaexpress.do',
                        "id=" + id,
                        function (data) {
                            if (data.result) {
                                //si ya esta tomada
                                if (data.tomada == "1") {//tomada por un medico distinto
                                    if (data.medico_tomada.idmedico != $("#idmedico_session").val()) {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    } else {
                                        //tomada por el medico actual

                                        window.location.href = BASE_PATH + "panel-medico/consultaexpress/pendientes-" + id + ".html";
                                    }
                                } else {
                                    window.location.href = BASE_PATH + "panel-medico/consultaexpress/pendientes-" + id + ".html";
                                }


                            } else {
                                $("body").spin(false);
                                if (data.abierta == "1") {
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }


                            }
                        }
                );

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
                            $(elem).text(x_translate("Tiempo cumplido"));
                            $("#row_actions_panels_" + id).remove();
                            $("#div_row_time_" + id).slideDown();
                        }
                    }, 1000);
                }

            });



        });

    </script>


{/literal}

