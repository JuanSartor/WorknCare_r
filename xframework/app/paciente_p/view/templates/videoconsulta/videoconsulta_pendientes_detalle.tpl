<div id="div_videoconsulta_pendientes" class="relative cs-nc-section-holder">
    {include file="videoconsulta/videoconsulta_settings.tpl"}

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {* <li class="active">{"Pendientes"|x_translate}</li>*}
        </ol>
    </div>

    <input type="hidden" id='cant_consulta_pendientes' value="{$cantidad_consulta.pendientes}"/>
    {if $consulta}


        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-clock"></i></figure>
                        {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span>{/if}      
                    </div>
                    <span>{"PENDIENTES"|x_translate}</span>
                </div>
            </div>

            <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
                <div class="modal-dialog">
                    <div class="modal-content"></div>
                </div>
            </div>

            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                    <div class="panel panel-default">
                        <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                            <div class="ce-ca-toolbar cv-ca-toolbar">
                                <div class="row">
                                    {*header medico consulta*}
                                    {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$consulta} 

                                    {*header tipo consulta*}
                                    {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$consulta} 

                                    <div class="cs-ca-tiempo-respuesta-holder">
                                        <div class="cs-ca-tiempo-respuesta-inner">
                                            <span id="cs-ca-tiempo-respuesta-label-{$consulta.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Respuesta aproximada en"|x_translate}</span>
                                            <div class="cs-ca-tiempo-respuesta">
                                                {if $consulta.segundos_diferencia > 0}
                                                    <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span><span data-id="{$consulta.idvideoconsulta}" data-startsec="{$consulta.segundos_diferencia}" class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                    {/if}
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="row ce-ca-toolbar-row pce-header-low-row" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$consulta.idvideoconsulta}">
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">Nº {$consulta.numeroVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-motivo-label">{"Motivo"|x_translate}:</span>
                                            <span class="cs-ca-numero-consulta">{$consulta.motivoVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-date-tools">
                                            <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                            <span class="cs-ca-fecha">{$consulta.fecha_inicio_format}</span>
                                            <div class="cs-ca-date-tools-holder">
                                                <a href="javascript:;"><i class="icon-doctorplus-minus"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="collapse-{$consulta.idvideoconsulta}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-{$consulta.idvideoconsulta}">
                            <div class="panel-body">
                                <div class="cs-ca-chat-holder">
                                    {if $consulta.republicacion!=""}
                                        <div class="row chat-row chat-date-divider">
                                            <span class="chat-date"><small>{"Republicación Video Consulta"|x_translate} Nº{$consulta.republicacion}</small></span>
                                            <div class="chat-line-divider"></div>
                                        </div>
                                    {/if}
                                    {foreach from=$consulta.mensajes item=mensaje}


                                        <div class="row chat-row">
                                            <div class="chat-line-holder pce-paciente-chat">
                                                <div class="chat-image-avatar-xn pcer-chat-image-right">


                                                    {if $consulta.paciente_titular}
                                                        <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                            {if $consulta.paciente_titular.image.perfil != ""}
                                                                <img src="{$consulta.paciente_titular.image.perfil}" alt="user"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                            {/if}
                                                        </div>
                                                    {/if}
                                                    <div class="chat-image-avatar-xn-row">
                                                        {if $consulta.paciente.image.perfil != ""}
                                                            <img src="{$consulta.paciente.image.perfil}" alt="user"/>
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
                                    {/foreach}


                                </div>

                                <div class="row">
                                    <div class="audio-actions-panel">
                                        <div class="audio-reccord-holder-chat">

                                        </div>
                                        <div class="text-center btn-slide-holder">
                                            <a href="javascript:;"  data-id="{$consulta.idvideoconsulta}" class="btn btn-alert ce-ca-cancelar-consulta"><i class="icon-doctorplus-cruz"></i>{"Cancelar consulta"|x_translate}</a>
                                        </div>
                                    </div>
                                </div>


                            </div>
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

            $(".btn_send_mensaje").click(function () {
                var id = parseInt($(this).data("id"));
                if (id > 0) {
                    $('#div_videoconsulta_pendientes').spin("large");
                    x_sendForm(
                            $('#send_mensaje_' + id),
                            true,
                            function (data) {
                                $('#div_videoconsulta_pendientes').spin(false);
                                if (data.result) {
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
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

            //ocultamos el texto de mensaje 
            $('.ce-ca-cancelar').on('click', function (e) {
                e.preventDefault();
                $(this).parent().parent().siblings('.btn-slide-holder').show();
                $(this).parent().parent().slideUp();
            });




            // timer

            Date.prototype.addSeconds = function (h) {
                this.setSeconds(this.getSeconds() + h);
                return this;
            }

            $.each($('.timer-1'), function () {
                $this = $(this);
                $start_sec = $this.data("startsec");
                var date1 = new Date().addSeconds($start_sec) / 1000;
                if (parseInt($start_sec) > 0) {
                    $this.countid({
                        clock: true,
                        dateTime: date1,
                        dateTplRemaining: "%H:%M:%S",
                        dateTplElapsed: x_translate("Tiempo cumplido"),
                        complete: function (el) {

                            $("#cs-ca-tiempo-respuesta-label-" + $this.data("id")).html("&nbsp;");
                            el.css({color: '#415b70'});
                            el.siblings('.cs-ca-clock-icon').addClass('cs-ca-clock-icon-end');
                            return;
                        }
                    });
                }
            });
        });
    </script>
{/literal}
