<div id="div_videoconsulta_espera" class="relative cs-nc-section-holder">
    <form  action="{$url}panel-paciente/videoconsulta/sala/" id="link_sala" method="POST" role="form" >
    </form>

    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}"/>


    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/">{"Video Consulta"|x_translate}</a></li>

        </ol>
    </div>

    {if $listado_videoconsultas_espera.rows && $listado_videoconsultas_espera.rows|@count > 0}
        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-clock"></i></figure>
                            {if $cantidad_consulta.abiertas>0} 
                            <span>{$cantidad_consulta.abiertas}</span>
                        {/if}                 
                    </div>
                    <span>{"SALA DE ESPERA"|x_translate}</span>
                </div>
            </div>

            <div class="cs-ca-consultas-holder">
                {foreach $listado_videoconsultas_espera.rows item=videoconsulta_espera}
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar">
                                    <div class="row">
                                        {*header medico consulta*}
                                        {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$videoconsulta_espera} 

                                        {*header tipo consulta*}
                                        {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$videoconsulta_espera} 

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="va-atender-paciente-card-container proximo-atender">
                                                <div class="va-atender-card ">
                                                    {if $videoconsulta_espera.segundos_diferencia > 0}
                                                        <div class="va-atender-paciente-tiempo front" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}">
                                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                                <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_espera.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Horario de atención"|x_translate}</span>
                                                                <div class="cs-ca-tiempo-respuesta">
                                                                    <span class="cs-ca-clock-icon"><i class="fa fa-calendar-o"></i></span>
                                                                    <span class="vc-paciente-fecha">{$videoconsulta_espera.fecha_futura_format} {$videoconsulta_espera.inicio_sala|date_format:"%H:%M"}hs</span>
                                                                </div>
                                                                {if $videoconsulta_espera.fecha_futura!=1}
                                                                    <div class="cs-ca-tiempo-respuesta timer-wrapper">
                                                                        <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span>
                                                                        <span data-id="{$videoconsulta_espera.idvideoconsulta}" data-startsec="{$videoconsulta_espera.segundos_diferencia}" data-inicio-sala="{$videoconsulta_espera.inicio_sala}"  class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                                    </div>
                                                                {/if}

                                                            </div>
                                                        </div>
                                                    {/if}
                                                    <div class="va-atender-paciente-btn back" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}" style="transform:none; {if $videoconsulta_espera.segundos_diferencia > 0} display:none;{/if}"   >
                                                        <a href="{$url}panel-paciente/videoconsulta/sala/?id={$videoconsulta_espera.idvideoconsulta}" data-idvideoconsulta="{$videoconsulta_espera.idvideoconsulta}"  class="btn-default pasar_consultorio"><i class="icon-doctorplus-video-cam"></i>{"pasar al consulorio"|x_translate}</a>	
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_espera.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_espera.idvideoconsulta}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_espera.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_espera.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_espera.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="javascript:;"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$videoconsulta_espera.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_espera.idvideoconsulta}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">
                                        {if $videoconsulta_espera.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Video Consulta Nº"|x_translate}{$videoconsulta_espera.republicacion}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}
                                        {foreach from=$videoconsulta_espera.mensajes item=mensaje}

                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-image-avatar-xn pcer-chat-image-right">


                                                            {if $videoconsulta_espera.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $videoconsulta_espera.paciente_titular.image.perfil != ""}
                                                                        <img src="{$videoconsulta_espera.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_espera.paciente.image.perfil != ""}
                                                                    <img src="{$videoconsulta_espera.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                                <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                            </div>
                                                        </div>

                                                        <div class="chat-content pcer-chat-right">
                                                            <figure>
                                                                <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                <p>{$mensaje.mensaje} </p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                {*archivos videoconsulta*}
                                                                {if $mensaje.idmensajeVideoConsulta!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                                {*archivos turno*}
                                                                {if $mensaje.idmensajeTurno!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeTurno}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
                                                <div class="row chat-row">

                                                    <div class="chat-line-holder pce-dr-chat">
                                                        {if $videoconsulta_espera.medico.imagen.perfil != ""}
                                                            <img src="{$videoconsulta_espera.medico.imagen.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date"><span>{$videoconsulta_espera.medico.titulo_profesional.titulo_profesional} {$videoconsulta_espera.medico.nombre} {$videoconsulta_espera.medico.apellido}</span> {$mensaje.fecha_format} hs</div>
                                                                <p>{$mensaje.mensaje}</p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                <div class="chat-content-attach">
                                                                    <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                        <i class="fui-clip"></i>
                                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                    </a>
                                                                </div>
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}
                                        {foreachelse}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"No se registraron mensajes"|x_translate}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/foreach}


                                    </div>

                                    <div class="row">
                                        <div class="audio-actions-panel buttons-actions-panel"  data-id="{$videoconsulta_espera.idvideoconsulta}">

                                            <div class="text-center btn-slide-holder">
                                                <a href="javascript:;"  data-id="{$videoconsulta_espera.idvideoconsulta}" class="btn btn-alert ce-ca-cancelar-consulta"><i class="icon-doctorplus-cruz"></i>{"Cancelar consulta"|x_translate}</a>
                                                    {if $videoconsulta_espera.turno_idturno!=""}
                                                    <a href="{$url}panel-paciente/detalle-turno.html?idturno={$videoconsulta_espera.turno_idturno}&reprogramar={$videoconsulta_espera.turno_idturno}" data-idturno="{$videoconsulta_espera.turno_idturno}" class="btn btn-default btn-proponer-horario"><i class="fa fa-calendar-o"></i>{"Reprogramar"|x_translate}</a>
                                                    {else}
                                                    <a href="javascript:;"  data-id="{$videoconsulta_espera.idvideoconsulta}" class="btn btn-default btn-proponer-horario"><i class="fa fa-clock-o"></i>{"Proponer otro horario"|x_translate}</a>
                                                    {/if}

                                            </div>
                                        </div>
                                    </div>

                                    {*contenedor escribir mensaje*}
                                    <!--  Form mensaje-->
                                    <div class="row enviar-mesaje-container" data-id="{$videoconsulta_espera.idvideoconsulta}" style="display:none;">
                                        <div class="audio-actions-panel">
                                            <!--slide-->
                                            <div class="audio-reccord-holder">

                                                <form  id="send_mensaje_{$videoconsulta_espera.idvideoconsulta}">
                                                    <input type="hidden" name="idvideoconsulta" value="{$videoconsulta_espera.idvideoconsulta}"/>
                                                    <input type="hidden" name="repuesta_desde_consulta" value="1"/>

                                                    <div class="audio-reccord-holder">
                                                        <div class="chat-msg-holder">
                                                            <div class="chat-msg-input-holder">
                                                                <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Escriba sus horarios disponibles para realizar la videoconsulta"|x_translate}'></textarea>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </form>

                                                <div class="text-center  btn-send-mensaje-holder">
                                                    <a href="javascript:;" class="btn btn-white btn-cancelar" data-id="{$videoconsulta_espera.idvideoconsulta}"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</a>
                                                    <a href="javascript:;"  class="btn btn-default btn_send_mensaje" data-id="{$videoconsulta_espera.idvideoconsulta}"><i class="icon-doctorplus-chat-add"></i>{"Enviar respuesta"|x_translate}</a>
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
                            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_sala_espera" container_id="div_videoconsulta_espera"}
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
                            <figure><i class="icon-doctorplus-video-sheet"></i></figure>

                        </div>
                        <span>{"SALA DE ESPERA"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-video-sheet"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas en Sala de Espera"|x_translate}.</p>
                </div>
            </section>
        </div>

    {/if}



    <!--	ALERTAS - Modal consulta vencida	-->
    <div id="pasar_consultorio_consulta_vencida" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{"¡Acceso al consultorio virtual no habilitado!"|x_translate}</h4>
                </div>
                <div class="modal-body">
                    <p>
                        {"Han pasado los 5 minutos de espera desde el horario de inicio de su Video Consulta."|x_translate}
                    </p>
                    <div class="modal-perfil-completo-action-holder">

                        <button onclick="window.location.href = '{$url}panel-paciente/videoconsulta/vencidas.html'"><i class="far fa-calendar-times"></i> {"videoconsultas vencidas"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>	

    {literal}
        <script>
            var flipCard = function (e) {
                e.velocity({
                    rotateX: "180deg",
                    delay: 500,
                    duration: 2000
                });
            };
            $(document).ready(function (e) {
                renderUI2();
                /*$(".cs-ca-chat-holder").mCustomScrollbar({
                 theme: "dark-3"
                 });*/

                //al pasar al consultorio verificamos que siga disponible
                $(".pasar_consultorio").click(function (e) {

                    $element = $(this);
                    var idvideoconsulta = $(this).data("idvideoconsulta");
                    if (parseInt(idvideoconsulta) > 0) {
                        e.stopPropagation();
                        x_doAjaxCall('POST',
                                BASE_PATH + "acceder_consultorio_virtual.do",
                                "idvideoconsulta=" + idvideoconsulta,
                                function (data) {
                                    if (data.result) {

                                    } else {
                                        e.preventDefault();
                                        $("#pasar_consultorio_consulta_vencida").modal("show");
                                        $element.hide();
                                    }
                                },
                                null,
                                true
                                );
                    } else {
                        e.preventDefault();
                    }



                });

                //boton cancelar consulta
                $(".ce-ca-cancelar-consulta").click(function () {
                    var idconsulta = $(this).data("id");
                    jConfirm({
                        title: x_translate("Cancelar Video Consulta"),
                        text: x_translate("Está por cancelar la Video Consulta. ¿Desea continuar?"),
                        confirm: function () {
                            if (parseInt(idconsulta) > 0) {
                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'cancelar_videoconsulta_pendiente.do',
                                        'id=' + idconsulta,
                                        function (data) {
                                            $("body").spin(false);
                                            if (data.result) {
                                                x_alert(data.msg, () => recargar(BASE_PATH + "panel-paciente/videoconsulta/"));
                                            } else {
                                                x_alert(data.msg);
                                            }
                                        }


                                );
                            }

                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                });


                // timer
                /*
                 Date.prototype.addSeconds = function (h) {
                 this.setSeconds(this.getSeconds() + h);
                 return this;
                 }
                 */

                $.each($('.timer-1'), function (idx, elem) {
                    if ($(elem).data("inicio-sala") !== "") {
                        var idvideoconsulta = $(elem).data("id");
                        var [date_part, time_part] = $(elem).data("inicio-sala").split(" ");
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
                                $(elem).text("");

                                //ocultamos el timer
                                $(".va-atender-paciente-tiempo.front[data-idvideoconsulta=" + idvideoconsulta + "]").slideUp();
                                //mostramos el boton ingreso a la sala
                                $(".va-atender-paciente-btn.back[data-idvideoconsulta=" + idvideoconsulta + "]").slideDown();
                            }
                        }, 1000);
                    }
                });

                /**
                 * proponer otro turno - mensaje
                 */
                //listener desplegar form enviar mensaje
                $(".btn-proponer-horario").click(function () {
                    var id = $(this).data("id");
                    $(".buttons-actions-panel[data-id=" + id + "]").hide();
                    $(".enviar-mesaje-container[data-id=" + id + "]").slideDown();
                });
                //listener ocultar form enviar mensaje
                $(".btn-cancelar").click(function () {
                    var id = $(this).data("id");
                    $(".enviar-mesaje-container[data-id=" + id + "]").hide();
                    $(".buttons-actions-panel[data-id=" + id + "]").slideDown();

                });
                //enviar mensaje
                $(".btn_send_mensaje").click(function (e) {

                    e.preventDefault();
                    var id = $(this).data("id");
                    console.log("data-id" + id);
                    if ($("#send_mensaje_" + id + " textarea").val() === "") { // no enviar mensajes sin texto 
                        x_alert(x_translate("Ingrese texto del mensaje"));
                        return false;
                    }
                    $("body").spin();
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'send_mensaje_videoconsulta.do',
                            $('#send_mensaje_' + id).serialize(),
                            function (data) {
                                $("body").spin(false);

                                if (data.result) {
                                    $(".enviar-mesaje-container[data-id=" + id + "]").hide();
                                    $(".buttons-actions-panel[data-id=" + id + "]").slideDown();
                                    $("#send_mensaje_" + id + " textarea").val("");
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }
                            });

                });


            }
            );
        </script>
    {/literal}
</div>