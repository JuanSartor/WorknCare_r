<input type="hidden" id="idmedico_session" value="{$idmedico}">
<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>
<script>
    $(document).ready(function (e) {
        $('#ver-archivo').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });
    });



</script> 



{if $listado_videoconsultas_red.rows && $listado_videoconsultas_red.rows|@count > 0}
    <section class="container ceprr-accordion">

        <div class="cs-ca-consultas-holder">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                {foreach from=$listado_videoconsultas_red.rows key=key item=videoconsulta_red}
                    <div class="panel panel-default">
                        <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                            <div class="ce-ca-toolbar">                         

                                <div class="row">
                                    <div class="colx3 pce-dr-col">
                                        <div class="cs-ca-colx3-inner dr-col">
                                            <div class="cs-ca-usr-avatar">
                                                {if $videoconsulta_red.paciente.image}
                                                    <img src="{$videoconsulta_red.paciente.image.list}" alt="{$videoconsulta_red.paciente.nombre} {$videoconsulta_red.paciente.apellido}"/>
                                                {else}
                                                    {if $videoconsulta_red.paciente.animal!=1}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$videoconsulta_red.paciente.nombre} {$videoconsulta_red.paciente.apellido}"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$videoconsulta_red.paciente.nombre} {$videoconsulta_red.paciente.apellido}"/>
                                                    {/if}
                                                {/if}
                                                <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_red.paciente.idpaciente}">
                                                    <figure>
                                                        <i class="icon-doctorplus-pharmaceutics"></i>
                                                    </figure>
                                                </a>
                                            </div>
                                            <div class="cs-ca-usr-data-holder">
                                                <span>{"Paciente"|x_translate}</span>
                                                <h2>{$videoconsulta_red.paciente.nombre} {$videoconsulta_red.paciente.apellido}</h2>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="colx3 ceprr-pariente-col">
                                        <div class="cs-ca-colx3-inner">
                                            {if $videoconsulta_red.paciente_titular}

                                                <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                    {if $videoconsulta_red.paciente_titular.image}
                                                        <img src="{$videoconsulta_red.paciente_titular.image.perfil}" alt="user"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                    {/if}
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    {if $videoconsulta_red.paciente_titular.relacion != ""}
                                                        <span>{$videoconsulta_red.paciente_titular.relacion}  {"del paciente"|x_translate}</span>
                                                    {else}
                                                        <span>{"propietario"|x_translate}</span>
                                                    {/if}
                                                    <h2>{$videoconsulta_red.paciente_titular.nombre} {$videoconsulta_red.paciente_titular.apellido}</h2>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                    <div class="cs-ca-tiempo-respuesta-holder">
                                        <div class="cs-ca-tiempo-respuesta-inner">
                                            <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_red.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Tiempo de respuesta"|x_translate}</span>
                                            <div class="cs-ca-tiempo-respuesta">
                                                {if $videoconsulta_red.segundos_diferencia > 0}
                                                    <span class="cs-ca-clock-icon">
                                                        <i class="icon-doctorplus-clock"></i>
                                                    </span>
                                                    <span data-id="{$videoconsulta_red.idvideoconsulta}" data-startsec="{$videoconsulta_red.segundos_diferencia}" data-fecha-vencimiento="{$videoconsulta_red.fecha_vencimiento}" class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="row ce-ca-toolbar-row pce-header-low-row {if $videoconsulta_red.status=="1" && $videoconsulta_red.tomada=="1" && $videoconsulta_red.medico_idmedico==$idmedico}{else}collapsed{/if} " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_red.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_red.idvideoconsulta}">
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">Nº {$videoconsulta_red.numeroVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">{$videoconsulta_red.motivoVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-date-tools">
                                            <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                            <span class="cs-ca-fecha">{$videoconsulta_red.fecha_inicio_format}</span>
                                            <div class="cs-ca-date-tools-holder">
                                                <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div id="collapse-{$videoconsulta_red.idvideoconsulta}" data-id="{$videoconsulta_red.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_red.idvideoconsulta}">
                            <div class="panel-body">
                                <div class="cs-ca-chat-holder">


                                    {foreach from=$videoconsulta_red.mensajes item=mensaje}


                                        {if $mensaje.emisor == "p"}
                                            <div class="row chat-row">
                                                <div class="chat-line-holder pce-dr-chat">
                                                    <div class="chat-image-avatar-xn">
                                                        {if $videoconsulta_red.paciente_titular}
                                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                {if $videoconsulta_red.paciente_titular.image.perfil != ""}
                                                                    <img src="{$videoconsulta_red.paciente_titular.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                            </div>
                                                        {/if}
                                                        <div class="chat-image-avatar-xn-row">
                                                            {if $videoconsulta_red.paciente.image.perfil != ""}
                                                                <img src="{$videoconsulta_red.paciente.image.perfil}" alt="user"/>
                                                            {else}
                                                                {if $videoconsulta_red.paciente.animal != 1}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                                {/if}
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
                                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
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
                                    <div  id="row_actions_panels_{$videoconsulta_red.idvideoconsulta}" class="row">

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
                                                <a href="javascript:;" data-send="0" data-id="{$videoconsulta_red.idvideoconsulta}" class="ce-ca-enviar-consulta tomar-consulta"><i class="icon-doctorplus-chat-add"></i>{"Aceptar y enviar respuesta"|x_translate}</a>

                                            </div>
                                            <div class="clearfix">&nbsp;</div>
                                        </div>
                                        <div class="clearfix">&nbsp;</div>
                                    </div>
                                    <div class="row chat-row" id="div_row_time_{$videoconsulta_red.idvideoconsulta}" {if $videoconsulta_red.segundos_diferencia > 0} style="display: none" {/if}>
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
                    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_red" container_id="div_videoconsulta_red"}
                </div>
            </div>
        </div>

    </section>
    <script>
        $(function () {
            scrollToEl($("#div_videoconsulta_red"));
        });
    </script>
{else}
    <div class="sin-registros">
        <i class="icon-doctorplus-chat-rss"></i>
        <h6>{"¡La sección está vacía!"|x_translate}</h6>

        <p>{"No existen Video Consultas publicadas para Profesionales en la Red en esta especialidad."|x_translate}</p>
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
                    var hide_alert_videoconsultas_red = localStorage.getItem('hide_alert_videoconsultas_red');
                    if (hide_alert_videoconsultas_red !== "1") {
                        localStorage.setItem('hide_alert_videoconsultas_red', "1");
                        notify({title: x_translate("No tiene Videoconsultas en la red publicadas"), text: x_translate("Es posible que haya pasado su tiempo de publicación o que hayan sido contestadas por otro profesional"), style: "video-consulta"});
                    }
                });
            </script>
        {/literal}
    {/if}
{/if}

<!--	ALERTAS -  Video consulta actualizar listado	-->


<div id="modal-recagrar-videoconsulta-red" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  onclick="recargar_videoconsulta_red();" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"La página solicita recargarse para mantenerse actualizada."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button onclick="window.location.href = '';">{"Recargar"|x_translate}</button>
                    <button onclick="recargar_videoconsulta_red();">{"Permanecer en la página"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>






<script>
    var VIDEOCONSULTA_VENCIMIENTO_SALA = parseInt({$VIDEOCONSULTA_VENCIMIENTO_SALA});
</script>
{literal}
    <script>
        //funcion que levanta el modal de recargar pagina cada 10 min para mantener actualizado el listado
        var recargar_videoconsulta_red = function () {
            $("#modal-recagrar-videoconsulta-red").modal("hide");

            setTimeout(function () {
                $("#modal-recagrar-videoconsulta-red").modal("show");
            }, 600000);
        };
        $(function () {

            renderUI2("div_videoconsulta_red");
            //redireccion al perfil salud del paciente
            $("#div_videoconsulta_red .change_miembro").click(function () {

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
                $("#modal-recagrar-videoconsulta-red").modal("show");
            }, 600000);

            //Tomamos la consulta para contestarla
            $('.tomar-consulta').on('click', function (e) {
                e.preventDefault();

                var id = $(this).data('id');
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'tomar_videoconsulta.do',
                        "idvideoconsulta=" + id,
                        function (data) {
                            if (data.result) {
                                //si ya esta tomada
                                if (data.tomada == "1") {//tomada por un medico distinto
                                    if (data.medico_tomada.idmedico != $("#idmedico_session").val()) {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    } else {
                                        //tomada por el medico actual
                                        window.location.href = BASE_PATH + "panel-medico/videoconsulta/pendientes-" + id + ".html";
                                    }
                                } else {
                                    window.location.href = BASE_PATH + "panel-medico/videoconsulta/pendientes-" + id + ".html";
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

