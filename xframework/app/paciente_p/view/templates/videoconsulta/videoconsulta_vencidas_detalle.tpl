<div id="div_videoconsulta_vencidas" class=" cs-nc-section-holder">

    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <input type="hidden" id="notificacion_videoconsulta" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_vencidas_total' value="{$cantidad_consulta.vencidas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/vencidas.html">{"Vencidas"|x_translate}</a></li>
            {if $videoconsulta_vencida}<li class="active">Nº {$videoconsulta_vencida.numeroVideoConsulta}</li>{/if}
        </ol>
    </div>

    {if $videoconsulta_vencida}
        <input type="hidden" id='idvideoconsulta' value="{$videoconsulta_vencida.idvideoconsulta}"/>
        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/videoconsulta/vencidas.html" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="far fa-calendar-times"></i></figure>
                        {if $cantidad_consulta.vencidas>0} <span>{$cantidad_consulta.vencidas}</span>{/if}                    
                    </div>
                    <span>{"VENCIDAS"|x_translate}</span>
                </div>
            </div>

            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">



                    <div class="panel panel-default">
                        <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                            <div class="ce-ca-toolbar cv-ca-toolbar" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_vencida.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_vencida.idvideoconsulta}">


                                <div class="row">
                                    {*header medico consulta*}
                                    {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$videoconsulta_vencida} 

                                    {*header tipo consulta*}
                                    {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$videoconsulta_vencida} 

                                    <div class="cs-ca-tiempo-respuesta-holder">
                                        <div class="cs-ca-tiempo-respuesta-inner ce-pc-tiempo-vencidas">
                                            <span class="cs-ca-tiempo-respuesta-label">{"Tiempo cumplido"|x_translate}</span>
                                            <div class="cs-ca-tiempo-respuesta">
                                                <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>





                                <div class="row ce-ca-toolbar-row pce-header-low-row">
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">Nº {$videoconsulta_vencida.numeroVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">{$videoconsulta_vencida.motivoVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-date-tools">
                                            <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                            <span class="cs-ca-fecha">{$videoconsulta_vencida.fecha_inicio_format}</span>
                                            <div class="cs-ca-date-tools-holder">
                                                <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div id="collapse-{$videoconsulta_vencida.idvideoconsulta}" class="panel-collapse collapse in" data-id="{$videoconsulta_vencida.idvideoconsulta}" role="tabpanel" aria-labelledby="heading-{$videoconsulta_vencida.idvideoconsulta}">

                            <div class="panel-body">

                                <div class="cs-ca-chat-holder ce-pc-chat-holder">
                                    <div class="row chat-row">
                                        {if $videoconsulta_vencida.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Video Consulta Nº"|x_translate}{$videoconsulta_vencida.republicacion}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}
                                        <div class="pce-mensaje-disclaimer">
                                            <h4>{"Su consulta aún no pudo ser respondida"|x_translate}</h4>
                                        </div>
                                    </div>
                                    <div class="ce-pc-chat-btn-holder">
                                        <a href="javascript:;" class="ce-pc-extender btn_extender_consulta" data-tipoconsulta="{$videoconsulta_vencida.tipo_consulta}" data-id="{$videoconsulta_vencida.idvideoconsulta}"><i class="icon-doctorplus-clock"></i> {"Extender plazo de respuesta"|x_translate}</a>
                                        <a href="javascript:;" data-id="{$videoconsulta_vencida.idvideoconsulta}" class="btn_eliminar_consulta"><i class="icon-doctorplus-cruz"></i> {"Cancelar y eliminar"|x_translate}</a>
                                    </div>
                                    <div class="ce-pc-consulta-holder">

                                        <div class="ce-pc-consulta-holder-slide">


                                            {foreach from=$videoconsulta_vencida.mensajes item=mensaje}


                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-image-avatar-xn pcer-chat-image-right">


                                                            {if $videoconsulta_vencida.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $videoconsulta_vencida.paciente_titular.image.perfil != ""}
                                                                        <img src="{$videoconsulta_vencida.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_vencida.paciente.image.perfil != ""}
                                                                    <img src="{$videoconsulta_vencida.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                                <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                            </div>
                                                        </div>

                                                        <div class="chat-content pcer-chat-right">
                                                            <figure>
                                                                <div class="chat-content-date">
                                                                    {if $videoconsulta_vencida.paciente_titular.relacion != ""}
                                                                        <span>{$videoconsulta_vencida.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                                    {/if} 
                                                                    {$mensaje.fecha_format} hs
                                                                </div>
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

                                            {/foreach}

                                        </div>

                                        <div class="ce-pc-consulta-btn-holder">
                                            <a href="#" class="ce-pc-consulta-trigger">{"Mostrar consulta"|x_translate}</a>
                                        </div>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </section>

        <div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion modal-ce-pc-extender" id="modal_extension_plazo" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <p>{"Se extenderá el plazo de respuesta"|x_translate}</p>
                        <span  class="ce-pc-modal-alert"><strong id="span_tiempo_extender"></strong> {"horas"|x_translate}</span>
                        <p>{"Su Video Consulta pasará a estado Pendiente de confirmación"|x_translate}</p>

                        <div class="modal-perfil-completo-action-holder">
                            <a href="javascript:;" data-id="" id="btnConfirmarExtensionPlazo">{"Confirmar"|x_translate}</a>
                        </div>
                    </div>


                </div>
            </div>
        </div>

        <div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion modal-ce-pc-cancelar" id="modal_cancelacion_videoconsulta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <span class="ce-pc-modal-alert">{"Video Consulta cancelada"|x_translate}</span>
                        <p>{"El importe de la consulta ya ha sido acreditado en su cuenta"|x_translate}</p>

                        <div class="modal-perfil-completo-action-holder">
                            <a href="javascript:;" data-id="" id="btnConfirmarCancelacion">{"Confirmar"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/videoconsulta/vencidas.html"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="far fa-calendar-times"></i></figure>

                        </div>
                        <span>{"VENCIDAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Vencidas"|x_translate}.</p>
            </section>
        </div>
    {/if}
    <script>
        var VENCIMIENTO_VC_RED ={$VENCIMIENTO_VC_RED};
        var VENCIMIENTO_VC_FRECUENTES ={$VENCIMIENTO_VC_FRECUENTES};
    </script>
    {literal}
        <script>
            var marcar_leida_consulta = function () {
                //Enviar a leer todos los mensajes
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'marcar_leida_videoconsulta.do',
                        "idestadoVideoConsulta=5&idvideoconsulta=" + $("#idvideoconsulta").val(),
                        function (data) {

                            if (data.result) {

                                //actualizamos el contador de notificaciones generales superior
                                var notif_CE = parseInt($("#notificacion_videoconsultas").val()) - 1;
                                $("#notificacion_videoconsultas").val(notif_CE);

                                if (notif_CE > 0) {
                                    $("#div_shorcuts_cant_videoconsultas").html("<span>" + notif_CE + "</span>");
                                } else {
                                    $("#div_shorcuts_cant_videoconsultas").html("");
                                }
                                //actualizamos el contador de rechazadas

                                var notif_vencidas = parseInt($("#cant_videoconsulta_vencidas").html()) - 1;

                                if (notif_vencidas > 0) {
                                    $("#cant_videoconsulta_vencidas").html(notif_rechazadas);
                                } else {
                                    $("#cant_videoconsulta_vencidas").hide();
                                }
                            }
                        }
                );
            };

            $(function () {

                marcar_leida_consulta();

                //scroll hasta el ultimo mensaje del chat
                $('.panel-collapse').on('show.bs.collapse', function () {
                    scrollToLastMsg($(".cs-ca-chat-holder"));
                });

                $("#btnConfirmarCancelacion").click(function () {

                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        $("#div_videoconsulta_vencidas").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'eliminar_videoconsulta_from_vencidas_paciente.do',
                                "id=" + id,
                                function (data) {
                                    $("#div_videoconsulta_vencidas").spin(false);
                                    if (data.result) {
                                        $("#modal_cancelacion_videoconsulta").modal("toggle");
                                        window.location.href = "";
                                    }
                                }
                        );
                    }
                });
                //modal_cancelacion_videoconsulta

                $(".btn_eliminar_consulta").click(function () {
                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        $("#btnConfirmarCancelacion").data("id", $(this).data("id"));
                        $("#modal_cancelacion_videoconsulta").modal("show");
                    }
                });

                $("#btnConfirmarExtensionPlazo").click(function () {

                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        $("#div_videoconsulta_vencidas").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'extender_videoconsulta_from_vencidas_paciente.do',
                                "id=" + id,
                                function (data) {

                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true";
                                    } else {
                                        $("#div_videoconsulta_vencidas").spin(false);
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                });

                $(".btn_extender_consulta").click(function () {
                    var id = $(this).data("id");
                    var tipo = $(this).data("tipoconsulta");
                    if (parseInt(id) > 0) {
                        $("#btnConfirmarExtensionPlazo").data("id", $(this).data("id"));
                        //establecemos el tiempo de extension si es prefesionales en la red o frecuentes
                        if (tipo == 1) {
                            $("#span_tiempo_extender").html(VENCIMIENTO_VC_FRECUENTES);
                        } else {
                            $("#span_tiempo_extender").html(VENCIMIENTO_VC_RED);
                        }

                        $("#modal_extension_plazo").modal("show");
                    }
                });

             
                $(".ce-pc-consulta-trigger").on('click', function (e) {
                    e.preventDefault();
                    $(this).parent().siblings('.ce-pc-consulta-holder-slide').slideToggle(function (el) {

                        if ($(this).is(':visible')) {
                            $(this).siblings('.ce-pc-consulta-btn-holder').children('.ce-pc-consulta-trigger').html(x_translate('Ocultar consulta'));
                        } else {
                            $(this).siblings('.ce-pc-consulta-btn-holder').children('.ce-pc-consulta-trigger').html(x_translate('Mostrar consulta'));
                        }

                    });


                });



            });
        </script>
    {/literal}
</div>