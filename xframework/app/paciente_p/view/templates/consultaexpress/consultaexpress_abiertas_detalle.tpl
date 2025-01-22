<div id="div_consultasexpress_abiertas" class="relative cs-nc-section-holder">

    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/abiertas.html">{"Abiertas"|x_translate}</a></li>
            {if $consulta}<li class="active">Nº {$consulta.numeroConsultaExpress}</li>{/if}

        </ol>
    </div>

    {if $consulta}
        <input type="hidden" id="idconsultaExpress" value="{$consulta.idconsultaExpress}"/>
        <section class="container cs-nc-p2">
            <div class="">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/abiertas.html" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>
                            {if $cantidad_consulta.abiertas>0} <span id='cant_consulta_abiertas'>{$cantidad_consulta.abiertas}</span>{/if}
                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>

                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">



                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar">
                                    <div class="row">
                                        {*header medico consulta*}
                                        {include file="consultaexpress/consultaexpress_header_medico.tpl" consulta=$consulta}

                                        {*header tipo consulta*}
                                        {include file="consultaexpress/consultaexpress_header_tipo.tpl" consulta=$consulta}

                                        <div class="colx3">
                                            <div class="cs-ca-consultas-abiertas-holder">
                                                <div id="cont_mensajes_noleidos_{$consulta.idconsultaExpress}" class="cs-ca-consultas-abiertas-spacer">	
                                                    {if $consulta.mensajes_noleidos>0}
                                                        <span>{"Mensajes sin leer"|x_translate}</span>
                                                        <figure>{$consulta.mensajes_noleidos}</figure>
                                                        {/if}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta.idconsultaExpress}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$consulta.numeroConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$consulta.motivoConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta.idconsultaExpress}" class="panel-collapse collapse in" data-id="{$consulta.idconsultaExpress}" role="tabpanel" aria-labelledby="heading-{$consulta.idconsultaExpress}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">
                                        {if $consulta.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Consulta Express Nº"|x_translate}{$consulta.republicacion}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}

                                        {foreach from=$consulta.mensajes item=mensaje}

                                            {if $mensaje.emisor == "m"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        {if $mensaje.imagen_medico.list != ""}
                                                            <img src="{$mensaje.imagen_medico.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date">{$mensaje.fecha_format}</div>
                                                                <p>{$mensaje.mensaje} </p>
                                                                {if $mensaje.mensaje_audio != ""}
                                                                    <div class="chat-audio-holder">
                                                                        <audio controls preload="true" src="{$mensaje.mensaje_audio}"></audio>
                                                                    </div>
                                                                {/if}
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                <div class="chat-content-attach">
                                                                    <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
                                                                        <i class="fui-clip"></i>
                                                                        &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                    </a>
                                                                </div>
                                                            {/if}

                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
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
                                                                <div class="chat-content-date">{$mensaje.fecha_format}</div>
                                                                <p>{$mensaje.mensaje}</p>
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>
                                                            {if $mensaje.cantidad_archivos_mensajes > 0}
                                                                <div class="chat-content-attach">
                                                                    <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
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
                                    </div>




                                    <!--  Form mensaje-->
                                    <div class="row">
                                        <div class="audio-actions-panel">
                                            <!--slide-->
                                            <div class="audio-reccord-holder">

                                                <form name="send_mensaje_{$consulta.idconsultaExpress}" action="{$url}send_mensaje_consulta_express.do" id="send_mensaje_{$consulta.idconsultaExpress}">
                                                    <input type="hidden" name="consultaExpress_idconsultaExpress" value="{$consulta.idconsultaExpress}"/>

                                                    <div class="audio-reccord-holder">
                                                        <div class="chat-msg-holder">
                                                            <div class="chat-msg-input-holder">
                                                                <textarea data-autoresize rows="1" name="mensaje" placeholder='{"Escribir mensaje"|x_translate}'></textarea>
                                                                <button class="file-trigger" data-id="{$consulta.idconsultaExpress}" type="submit" title='{"Archivos adjuntos"|x_translate}'><i class="fui-clip"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="audio-reccord-holder">
                                                        <div class="chat-img-upld">
                                                            <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
                                                                {x_component_upload_multiple max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="images_mensajes_ce"
                                                                callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf"}

                                                                <div class="dz-message needsclick">
                                                                    <i class="fui-clip"></i>
                                                                    <h3>{"Archivos adjuntos"|x_translate}</h3>
                                                                    <small>{"Ud. podrá subir archivos en formato:"|x_translate}&nbsp; JPG, PNG, PDF</small>
                                                                    <div class="add-more-container">
                                                                        <div class="add-more-btn"> 
                                                                            <i class="fa fa-plus-circle"></i>
                                                                            <span>{"Agregar más"|x_translate}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>
                                                        </div>
                                                    </div>
                                                </form>

                                                <div class="audio-action-holder">
                                                    <a href="javascript:;" data-send="0" data-id="{$consulta.idconsultaExpress}" class="ce-ca-enviar-consulta btn_send_mensaje"><i class="icon-doctorplus-chat-add"></i>{"Enviar respuesta"|x_translate}</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </section>


        {literal}
            <script>
                //Enviar a leer todos los mensajes
                var marcar_leida_consulta_express = function (id) {
                    if (parseInt(id) > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'marcar_leida_consulta_express.do',
                                "id=" + id,
                                function (data) {

                                    if (data.result) {

                                        $("#cont_mensajes_noleidos_" + id).hide();
                                        //descontamos la notificacion si no se leyó anteriormente ya
                                        if (data.leido_anteriormente == 0) {
                                            //actualizamos el contador de notificaciones generales superior
                                            var notif_CE = parseInt($("#notificacion_consultaexpress").val()) - 1;
                                            $("#notificacion_consultaexpress").val(notif_CE);
                                            if (notif_CE > 0) {
                                                $("#div_shorcuts_cant_consultaexpress").html("<span>" + notif_CE + "</span>");
                                            } else {
                                                $("#div_shorcuts_cant_consultaexpress").html("");
                                            }

                                        }

                                    }
                                }
                        );
                    }
                }
                $(document).ready(function (e) {

                    $.each($('textarea[data-autoresize]'), function () {
                        var offset = this.offsetHeight - this.clientHeight;

                        var resizeTextarea = function (el) {
                            $(el).css('height', 'auto').css('height', el.scrollHeight + offset);
                        };
                        $(this).on('keyup input', function () {
                            resizeTextarea(this);
                        }).removeAttr('data-autoresize');
                    });


                    //Enviar a leer todos los mensajes
                    marcar_leida_consulta_express($("#idconsultaExpress").val());




                    $('.btn_send_mensaje').on('click', function (e) {


                        //Click en el botón enviar respuesta
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                            $("#send_mensaje_" + id + " textarea").parent().css("border", "none");
                            if ($("#send_mensaje_" + id + " textarea").val() == "") {

                                x_alert(x_translate("Ingrese el texto del mensaje"));
                                $("#send_mensaje_" + id + " textarea").parent().css("border", "1px solid red");
                                return false;
                            }
                            //carga de imagenes en proceso
                            if ($("#dropzone .dz-complete").length != $("#dropzone .dz-preview").length) {
                                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                                return false;

                            }
                            //Envío el mensaje
                            $('#div_consultasexpress_abiertas').spin("large");
                            x_sendForm(
                                    $('#send_mensaje_' + id),
                                    true,
                                    function (data) {
                                        $('#div_consultasexpress_abiertas').spin(false);
                                        if (data.result) {
                                            scrollToEl($("body"));
                                            if ($('.chat-img-upld').is(":visible")) {
                                                $('.chat-img-upld').slideUp();

                                            }
                                            x_alert(data.msg, recargar);
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );

                        }
                    });

                    /*   $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/
                    //scroll hasta el ultimo mensaje del chat
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        scrollToLastMsg($(".cs-ca-chat-holder"));
                    });


                    $('.file-trigger').on('click', function (e) {
                        e.preventDefault();

                        if ($('.chat-img-upld').is(":hidden")) {
                            $('.chat-img-upld').slideDown();


                        } else {
                            $('.chat-img-upld').slideUp();

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
                        <a href="{$url}panel-paciente/consultaexpress/abiertas.html"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>

                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Abiertas"|x_translate}.</p>
            </section>
        </div>
    {/if}
</div>
