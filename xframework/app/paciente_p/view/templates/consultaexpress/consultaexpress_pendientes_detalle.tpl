<style>
    .icon-doctorplus-plus:before {
        content: "ouvrir (+)"!important;
        font-family: Lato,sans-serif!important;
        font-size: 13px;
    }
</style>
<div id="div_consultasexpress_pendientes" class="relative cs-nc-section-holder">
    {include file="consultaexpress/consultaexpress_settings.tpl"}

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/pendientes.html">{"Pendientes"|x_translate}</a></li>
            {if $consulta}<li class="active">Nº {$consulta.numeroConsultaExpress}</li>{/if}

        </ol>
    </div>

    {if $consulta}

        <div class="cs-nc-section-holder">	
            <section class="container cs-nc-p2">    
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/pendientes.html" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>
                            {if $cantidad_consulta.pendientes>0} <span>{$cantidad_consulta.pendientes}</span>{/if}                    
                        </div>
                        <span>{"PENDIENTES"|x_translate}</span>
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

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="cs-ca-tiempo-respuesta-inner">
                                                <span id="cs-ca-tiempo-respuesta-label-{$consulta.idconsultaExpress}" class="cs-ca-tiempo-respuesta-label">{"Respuesta aproximada en"|x_translate}</span>
                                                <div class="cs-ca-tiempo-respuesta">
                                                    {if $consulta.segundos_diferencia > 0}
                                                        <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span><span data-id="{$consulta.idconsultaExpress}" data-startsec="{$consulta.segundos_diferencia}" data-fecha-vencimiento="{$consulta.fecha_vencimiento}"  class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                        {/if}
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta.idconsultaExpress}">
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
                                                    <a href="javascript:;"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta.idconsultaExpress}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-{$consulta.idconsultaExpress}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">
                                        {if $consulta.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Consulta Express Nº"|x_translate}{$consulta.republicacion}</small></span>
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
                                                                <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=consultaexpress&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeConsultaExpress}" data-target="#ver-archivo">
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

                                                <h4 class="pce-mensaje-disclaimer-title">{"ATENCIÓN"|x_translate}</h4>
                                                <div class="pce-mensaje-disclaimer">
                                                    <p>{"Agrega información adicional a esta consulta sólo si consideras que ayudará al/los profesional/es a brindarte el consejo más adecuado a tu caso."|x_translate}<br>
                                                        {"De lo contrario, es posible que demores la respuesta."|x_translate}</p>
                                                </div>
                                                <form name="send_mensaje_{$consulta.idconsultaExpress}" action="{$url}send_mensaje_consulta_express.do" id="send_mensaje_{$consulta.idconsultaExpress}">
                                                    <input type="hidden" name="consultaExpress_idconsultaExpress" value="{$consulta.idconsultaExpress}"/>
                                                    <input type="hidden" name="cantidad" id="cantidad" value=""/>
                                                    <input type="hidden" name="reenviar" value="1"/>

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
                                                    <a href="javascript:;" class="ce-ca-cancelar"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</a>

                                                    <a href="JavaScript:;" data-id="{$consulta.idconsultaExpress}" class="ce-ca-responder btn_send_mensaje" ><i class="icon-doctorplus-right-arrow"></i> {"Enviar mensaje"|x_translate}</a>
                                                </div>

                                            </div>
                                            <div class="text-center btn-slide-holder">
                                                <a href="javascript:;"  data-id="{$consulta.idconsultaExpress}" class="btn btn-alert ce-ca-cancelar-consulta"><i class="icon-doctorplus-cruz"></i>{"Cancelar consulta"|x_translate}</a>
                                                <a href="javascript:;" class="btn btn-default ce-ca-enviar-consulta"><i class="icon-doctorplus-chat-add"></i>{"Agregar mensaje"|x_translate}</a>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </section>
        </div>


    {else}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">

                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>

                        </div>
                        <span>{"PENDIENTES DE CONFIRMACIÓN"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="fas fa-user-clock"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p><strong>{"Ud. no tiene Consultas Pendientes de confirmación"|x_translate}</strong>.</p>
                </div>
            </section>
        </div>

    {/if}

</div>
{literal}
    <script>
        $(document).ready(function (e) {

            renderUI2();


            /*$(".cs-ca-chat-holder").mCustomScrollbar({
             theme: "dark-3"
             });*/
            //scroll hasta el ultimo mensaje del chat
            $('.panel-collapse').on('show.bs.collapse', function () {
                scrollToLastMsg($(".cs-ca-chat-holder"));
            });

            /*Enviar el mensaje de la consulta*/
            $(".btn_send_mensaje").click(function () {
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
                    $('#div_consultasexpress_pendientes').spin("large");
                    x_sendForm(
                            $('#send_mensaje_' + id),
                            true,
                            function (data) {
                                $('#div_consultasexpress_pendientes').spin(false);
                                if (data.result) {
                                    //ocultamos el chat y recargamos
                                    scrollToEl($("body"));
                                    $('.ce-ca-cancelar').trigger('click');
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }
            });
            //boton cancelar consulta

            //boton cancelar consulta
            $(".ce-ca-cancelar-consulta").click(function () {
                var idconsulta = $(this).data("id");
                if (parseInt(idconsulta) > 0) {
                    jConfirm({
                        title: x_translate("Cancelar Consulta Express"),
                        text: x_translate("Está por cancelar la Consulta Express. ¿Desea continuar?"),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'cancelar_consultaexpress_pendiente.do',
                                    'id=' + idconsulta,
                                    function (data) {
                                        $("body").spin(false);
                                        if (data.result) {
                                            x_alert(data.msg, () => recargar(BASE_PATH + "panel-paciente/consultaexpress/"));
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });

                }
            });

            //botones enviar mensaje
            $('.ce-ca-enviar-consulta').on('click', function (e) {
                e.preventDefault();
                $(this).parent('.btn-slide-holder').hide();
                if ($(this).parent().siblings('.audio-reccord-holder-chat').is(':hidden')) {
                    $(this).parent().siblings('.audio-reccord-holder-chat').slideDown();
                }
            });
            //ocultamos el texto de mensaje 
            $('.ce-ca-cancelar').on('click', function (e) {
                e.preventDefault();
                $(this).parent().parent().siblings('.btn-slide-holder').show();
                $(this).parent().parent().slideUp();
                $(this).parent().parent().find("textarea").val("");
            });

            $.each($('textarea[data-autoresize]'), function () {
                var offset = this.offsetHeight - this.clientHeight;
                var resizeTextarea = function (el) {
                    $(el).css('height', 'auto').css('height', el.scrollHeight + offset);
                };
                $(this).on('keyup input', function () {
                    resizeTextarea(this);
                }).removeAttr('data-autoresize');
            });

            $('.file-trigger').on('click', function (e) {
                e.preventDefault();
                var id = $(this).data("id");
                if ($('#send_mensaje_' + id).find('.chat-img-upld').is(":hidden")) {
                    $('#send_mensaje_' + id).find('.chat-img-upld').slideDown();
                } else {
                    $('#send_mensaje_' + id).find('.chat-img-upld').slideUp();
                }

            });
            jQuery.each(jQuery('textarea[data-autoresize]'), function () {
                var offset = this.offsetHeight - this.clientHeight;
                var resizeTextarea = function (el) {
                    jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
                };
                jQuery(this).on('keyup input', function () {
                    resizeTextarea(this);
                }).removeAttr('data-autoresize');
            });
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
        });
    </script>
{/literal}
