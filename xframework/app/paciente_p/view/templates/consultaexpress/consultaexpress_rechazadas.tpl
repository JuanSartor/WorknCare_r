<div id="div_consultasexpress_rechazadas" class="cs-nc-section-holder">



    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_rechazadas_total' value="{$cantidad_consulta.rechazadas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                {*<li class="active">{"Declinadas"|x_translate}</li>*}
        </ol>
    </div>
    {if $listado_consultas_rechazadas.rows && $listado_consultas_rechazadas.rows|@count > 0}

        <section class="container cs-nc-p2">


            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-times"></i></figure>
                        {if $cantidad_consulta.rechazadas>0} <span id="cant_consulta_rechazadas">{$cantidad_consulta.rechazadas}</span>{/if}
                    </div>
                    <span>{"DECLINADAS"|x_translate}</span>
                </div>
            </div>


            <div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion modal-ce-pc-cancelar" id="modal_cancelacion_consulta_express" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <span class="ce-pc-modal-alert">{"Consulta Express cancelada"|x_translate}</span>
                            <p>{"El importe de la consulta ya ha sido acreditado en su cuenta"|x_translate}</p>

                            <div class="modal-perfil-completo-action-holder">
                                <a href="javascript:;" data-id="" id="btnConfirmarCancelacion">{"Confirmar"|x_translate}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_consultas_rechazadas.rows key=key item=consulta_rechazada}

                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar" >

                                    <div class="row">
                                        {*header medico consulta*}
                                        {include file="consultaexpress/consultaexpress_header_medico.tpl" consulta=$consulta_rechazada}
                                        
                                        {*header tipo consulta*}
                                        {include file="consultaexpress/consultaexpress_header_tipo.tpl" consulta=$consulta_rechazada}
                                        <div class="colx3">
                                            <div class="cs-ca-consultas-abiertas-holder">
                                                <div class="cs-ca-consultas-abiertas-spacer">	
                                                    <i class="fas fa-user-times cs-ca-finalizadas-icon"></i>
                                                    <span class="cs-ca-finalizadas">{"Consulta Declinada"|x_translate}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_rechazada.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_rechazada.idconsultaExpress}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$consulta_rechazada.numeroConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$consulta_rechazada.motivoConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta_rechazada.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta_rechazada.idconsultaExpress}" class="panel-collapse collapse" data-id="{$consulta_rechazada.idconsultaExpress}" role="tabpanel" aria-labelledby="heading-{$consulta_rechazada.idconsultaExpress}">

                                <div class="panel-body">

                                    <div class="cs-ca-chat-holder ce-pc-chat-holder">
                                        {foreach from=$consulta_rechazada.mensajes item=mensaje}
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


                                                            {if $consulta_rechazada.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $consulta_rechazada.paciente_titular.image.perfil != ""}
                                                                        <img src="{$consulta_rechazada.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $consulta_rechazada.paciente.image.perfil != ""}
                                                                    <img src="{$consulta_rechazada.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                                <figure><i class="icon-doctorplus-pharmaceutics"></i></figure>
                                                            </div>
                                                        </div>

                                                        <div class="chat-content  pcer-chat-right">
                                                            <figure>
                                                                <div class="chat-content-date">
                                                                    {if $consulta_rechazada.paciente_titular.relacion != ""}
                                                                        <span>{$consulta_rechazada.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                                    {/if} 
                                                                    {$mensaje.fecha_format} hs
                                                                </div>
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

                                        <div class="row chat-row">
                                            {if $consulta_rechazada.republicacion!=""}
                                                <div class="row chat-row chat-date-divider">
                                                    <span class="chat-date"><small>{"Republicación Consulta Express Nº"|x_translate}{$consulta_rechazada.republicacion}</small></span>
                                                    <div class="chat-line-divider"></div>
                                                </div>
                                            {/if}
                                            <div class="chat-line-holder pce-dr-chat">
                                                {if $consulta_rechazada.medico.imagen.perfil != ""}
                                                    <img src="{$consulta_rechazada.medico.imagen.perfil}" alt="user"/>
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                {/if}
                                                <div class="chat-content">
                                                    <figure>
                                                        <div class="chat-content-date"><span>{$consulta_rechazada.medico.titulo_profesional.titulo_profesional} {$consulta_rechazada.medico.nombre} {$consulta_rechazada.medico.apellido}</span> {$consulta_rechazada.fecha_fin_format} hs</div>
                                                        <h4 class="pcer-disclaimer">
                                                            {"Motivo"|x_translate}:
                                                            {$consulta_rechazada.motivoRechazo} 
                                                        </h4>
                                                        <span class="chat-content-arrow"></span>
                                                    </figure>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ce-pc-chat-btn-holder">
                                            <a href="javascript:;" class="ce-pc-republicar btn_republicar_consulta" data-id="{$consulta_rechazada.idconsultaExpress}"><i class="icon-doctorplus-back"></i> {"Editar y republicar a otros profesionales"|x_translate}</a>
                                            {*<a href="javascript:;" class="ce-pc-cancelar btn_eliminar_consulta" data-id="{$consulta_rechazada.idconsultaExpress}"><i class="icon-doctorplus-cruz"></i> {"Cancelar y eliminar"|x_translate}</a>*}
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
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_rechazadas" container_id="div_consultasexpress_rechazadas"}
                    </div>
                </div>
            </div>

        </section>

    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-times"></i></figure>

                        </div>
                        <span>{"DECLINADAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Declinadas"|x_translate}.</p>
            </section>
        </div>
    {/if}

    {literal}
        <script>


            $(document).ready(function (e) {
                renderUI2();
                /*   $(".cs-ca-chat-holder").mCustomScrollbar({
                 theme: "dark-3"
                 });*/
                //scroll hasta el ultimo mensaje del chat
                $('.panel-collapse').on('show.bs.collapse', function () {
                    scrollToLastMsg($(".cs-ca-chat-holder"));
                });


                //Enviar a leer todos los mensajes
                $('.panel-collapse').on('show.bs.collapse', function () {
                    $this = $(this);
                    var id = parseInt($this.data("id"));
                    if (id > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'marcar_leida_consulta_express.do',
                                "id=" + id,
                                function (data) {

                                    if (data.result) {


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
                                            //actualizamos el contador de rechazadas

                                            var notif_rechazadas = parseInt($("#cant_consulta_rechazadas").html()) - 1;

                                            if (notif_rechazadas > 0) {
                                                $("#cant_consulta_rechazadas").html(notif_rechazadas);
                                            } else {
                                                $("#cant_consulta_rechazadas").hide();
                                            }

                                        }

                                    }
                                }
                        );
                    }
                });


                $(".btn_eliminar_consulta").click(function () {
                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        $("#btnConfirmarCancelacion").data("id", $(this).data("id"));
                        $("#modal_cancelacion_consulta_express").modal("show");
                    }
                });


                $("#btnConfirmarCancelacion").click(function () {

                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'eliminar_from_vencidas_paciente.do',
                                "id=" + id,
                                function (data) {
                                    if (data.result) {
                                        $("#modal_cancelacion_consulta_express").modal("toggle");
                                        window.location.href = "";
                                    }
                                }
                        );
                    }
                });


                $(".btn_republicar_consulta").click(function () {
                    id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'republicar_from_vencidas_paciente.do',
                                "id=" + id,
                                function (data) {
                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true&republicar=true";
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                });


            });
        </script>
    {/literal}
</div>