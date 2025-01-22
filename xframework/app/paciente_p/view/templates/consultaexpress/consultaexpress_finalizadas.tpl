<div id="div_consultasexpress_finalizadas" class="cs-nc-section-holder">



    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_finalizadas_total' value="{$cantidad_consulta.finalizadas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                {*<li class="active">{"Finalizadas"|x_translate}</li>*}

        </ol>
    </div>
    {if $listado_consultas_finalizadas.rows && $listado_consultas_finalizadas.rows|@count > 0}

        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <div class="ce-ca-toolbar-col">
                        <a href="{$url}panel-paciente/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                            {if $cantidad_consulta.finalizadas>0} <span id="cant_consulta_finalizadas">{$cantidad_consulta.finalizadas}</span>{/if} 
                        </div>
                        <span>{"FINALIZADAS"|x_translate}</span>
                    </div>

                    <div class="ce-ca-toolbar-filter-col">
                        <div class="ce-ca-toolbar-filter-box">
                            <div class="ce-ca-toolbar-desde-box">
                                <label>{"Mostrar desde"|x_translate}
                                    <input type="text" id="filtro_inicio" name="filtro_inicio" placeholder="dd/mm/aaaa"/>
                                </label>
                            </div>
                            <div class="ce-ca-toolbar-hasta-box">
                                <label>{"hasta"|x_translate}
                                    <input type="text" id="filtro_fin" name="filtro_fin" placeholder="dd/mm/aaaa"/>
                                </label>
                            </div>
                            <div class="ce-ca-toolbar-action-box">
                                <button id="btnAplicarFiltro"><i class="icon-doctorplus-search"></i></button>
                            </div>
                        </div>
                    </div>

                </div>
            </div>


            {*finalizacion*}


            <div class="cs-ca-consultas-holder">

                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_consultas_finalizadas.rows key=key item=consulta_finalizada}

                        <div id="consulta-finalizada-{$consulta_finalizada.idconsultaExpress}" class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar " >
                                    <div class="row consultas-finalizadas with-parent {if $consulta_finalizada.leido_paciente=="0"}highlight{/if}">
                                        {*header medico consulta*}
                                        {include file="consultaexpress/consultaexpress_header_medico.tpl" consulta=$consulta_finalizada}
                                        
                                        {*header tipo consulta*}
                                        {include file="consultaexpress/consultaexpress_header_tipo.tpl" consulta=$consulta_finalizada}
                                        <div class="ca-ce-finalizadas-col">

                                            {if $consulta_finalizada.estadoConsultaExpress_idestadoConsultaExpress!=8}
                                                <a class="ver-indicaciones" data-id="{$consulta_finalizada.idconsultaExpress}" data-idperfilsaludconsulta="{$consulta_finalizada.idperfilSaludConsulta}" href="javascript:;">
                                                    <figure>
                                                        <i class="icon-doctorplus-sheet"></i>
                                                        {if $consulta_finalizada.leido_paciente=="0"}
                                                            <span class="subcircle"></span>
                                                        {/if}
                                                    </figure>
                                                    <span>{"Ver conclusiones"|x_translate}</span>
                                                </a>
                                            {else}
                                                <div class="ca-ce-finalizadas-indicaciones">
                                                    <em>{"¡AGUARDA! El especialista aún no ingresó indicaciones."|x_translate}</em>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_finalizada.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_finalizada.idconsultaExpress}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$consulta_finalizada.numeroConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$consulta_finalizada.motivoConsultaExpress}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Finalizada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta_finalizada.fecha_fin_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$consulta_finalizada.idconsultaExpress}" class="panel-collapse collapse" data-id="{$consulta_finalizada.idconsultaExpress}" role="tabpanel" aria-labelledby="heading-{$consulta_finalizada.idconsultaExpress}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">
                                        {if $consulta_finalizada.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Consulta Express Nº"|x_translate}{$consulta_finalizada.republicacion}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}

                                        {foreach from=$consulta_finalizada.mensajes item=mensaje}

                                            {if $mensaje.emisor == "m"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        {if $mensaje.imagen_medico.list != ""}
                                                            <img src="{$mensaje.imagen_medico.perfil}?{$smarty.now}" alt="user"/>
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


                                                            {if $consulta_finalizada.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $consulta_finalizada.paciente_titular.image.perfil != ""}
                                                                        <img src="{$consulta_finalizada.paciente_titular.image.perfil}?{$smarty.now}" />
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" />
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $consulta_finalizada.paciente.image.perfil != ""}
                                                                    <img src="{$consulta_finalizada.paciente.image.perfil}?{$smarty.now}"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" />
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
                                    {if $consulta_finalizada.estadoConsultaExpress_idestadoConsultaExpress!=8}
                                        <div class="row">
                                            <div class="audio-actions-panel">
                                                <div class="audio-action-holder">
                                                    <a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta_finalizada.idperfilSaludConsulta}"><i class="icon-doctorplus-sheet"></i>{"Ver conclusiones"|x_translate}</a>
                                                </div>
                                            </div>
                                        </div>
                                    {/if}

                                </div>
                            </div>
                        </div>

                    {/foreach}

                </div>

            </div>

            <div class="row">
                <div class="col-xs-12">
                    <div class="paginas">
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_finalizadas" container_id="div_consultasexpress_finalizadas"}
                    </div>
                </div>
            </div>
        </section>
    {else}
        {if $filtro_inicio!="" || $filtro_fin!=""}
            <div class="cs-nc-section-holder">
                <section class="container cs-nc-p2">
                    <div class="row">
                        <div class="ce-ca-toobar">
                            <div class="ce-ca-toolbar-col">
                                <a href="{$url}panel-paciente/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                                <div class="ce-ca-consultas-abiertas">
                                    <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                    {if $cantidad_consulta.finalizadas>0} <span id="cant_consulta_finalizadas">{$cantidad_consulta.finalizadas}</span>{/if} 
                                </div>
                                <span>{"FINALIZADAS"|x_translate}</span>
                            </div>

                            <div class="ce-ca-toolbar-filter-col">
                                <div class="ce-ca-toolbar-filter-box">
                                    <div class="ce-ca-toolbar-desde-box">
                                        <label>{"Mostrar desde"|x_translate}
                                            <input type="text" id="filtro_inicio" name="filtro_inicio"  value="{$filtro_inicio}" placeholder="dd/mm/aaaa"/>
                                        </label>
                                    </div>
                                    <div class="ce-ca-toolbar-hasta-box">
                                        <label>{"hasta"|x_translate}
                                            <input type="text" id="filtro_fin" name="filtro_fin"  value="{$filtro_fin}" placeholder="dd/mm/aaaa"/>
                                        </label>
                                    </div>
                                    <div class="ce-ca-toolbar-action-box">
                                        <button id="btnAplicarFiltro"><i class="icon-doctorplus-search"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="sin-registros">
                        <i class="icon-doctorplus-sheet"></i>
                        <h6>{"¡La sección está vacía!"|x_translate}</h6>
                        <p>{"Ud. no tiene Consultas Finalizadas en este periodo"|x_translate}</p>
                    </div>
                </section>
            </div>
        {else}
            <div class="cs-nc-section-holder">
                <section class="container cs-nc-p2">


                    <div class="row">
                        <div class="ce-ca-toobar">
                            <a href="{$url}panel-paciente/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                            <div class="ce-ca-consultas-abiertas">
                                <figure><i class="icon-doctorplus-ficha-check"></i></figure>

                            </div>
                            <span>{"FINALIZADAS"|x_translate}</span>
                        </div>
                    </div>
                    <div class="sin-registros">
                        <i class="icon-doctorplus-chat-comment"></i>
                        <h6>{"¡La sección está vacía!"|x_translate}</h6>
                        <p>{"Ud. no tiene Consultas Finalizadas"|x_translate}.</p>
                    </div>

                </section>
            </div>
        {/if}
    {/if}

    {literal}
        <script>

            //actualizamos el contador de notificaciones

            $(document).ready(function (e) {
                renderUI2("div_consultasexpress_finalizadas");

                //filtros de busqueda por fecha
                $("#filtro_inicio,#filtro_fin").datetimepicker({
                    pickTime: false,
                    language: 'fr'
                });
                $("#filtro_inicio,#filtro_fin").inputmask("d/m/y");

                //boton filtro de consultas finalizadas por fecha
                $("#btnAplicarFiltro").click(function () {
                    $("#div_consultasexpress_finalizadas").spin("large");
                    x_loadModule('consultaexpress', 'consultaexpress_finalizadas', 'do_reset=1&filtro_inicio=' + $("#filtro_inicio").val() + '&filtro_fin=' + $("#filtro_fin").val(), 'div_consultasexpress_finalizadas', "paciente_p");
                });


                /*  $(".cs-ca-chat-holder").mCustomScrollbar({
                 theme: "dark-3"
                 });*/
                //scroll hasta el ultimo mensaje del chat
                $('.panel-collapse').on('show.bs.collapse', function () {
                    scrollToLastMsg($(".cs-ca-chat-holder"));
                });

                //marcamos la consulta leida al desplegarla
                $('.panel-collapse').on('show.bs.collapse', function () {
                    $this = $(this);
                    var id = parseInt($this.data("id"));
                    if (id > 0) {
                        //Enviar a leer todos los mensajes
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'marcar_leida_consulta_express.do',
                                "id=" + id,
                                function (data) {

                                    if (data.result) {
                                        $("#consulta-finalizada-" + id + " .consultas-finalizadas").removeClass("highlight");

                                        $("#consulta-finalizada-" + id + " .subcircle").remove();

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
                                            //actualizamos el contador de abiertas
                                            var notif_finalizadas = parseInt($("#cant_consulta_finalizadas").html()) - 1;
                                            if (notif_finalizadas > 0) {
                                                $("#cant_consulta_finalizadas").html(notif_finalizadas);
                                            } else {
                                                $("#cant_consulta_finalizadas").hide();
                                            }

                                        }

                                    }
                                }
                        );
                    }
                });

                //marcamos la consulta leida al desplegarla
                $("#div_consultasexpress_finalizadas").on('click', "a.ver-indicaciones", function (e) {
                    e.preventDefault();
                    $this = $(this);
                    var id = parseInt($this.data("id"));
                    var idperfilsaludconsulta = parseInt($this.data("idperfilsaludconsulta"));
                    if (id > 0 && idperfilsaludconsulta > 0) {
                        //Enviar a leer todos los mensajes
                        if ($(".ver-indicaciones[data-id='" + id + "']").find(".subcircle").length > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_leida_consulta_express.do',
                                    "id=" + id,
                                    function (data) {

                                        if (data.result) {
                                            $("#consulta-finalizada-" + id + " .consultas-finalizadas").removeClass("highlight");

                                            $("#consulta-finalizada-" + id + " .subcircle").remove();

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
                                                //actualizamos el contador de abiertas
                                                var notif_finalizadas = parseInt($("#cant_consulta_finalizadas").html()) - 1;
                                                if (notif_finalizadas > 0) {
                                                    $("#cant_consulta_finalizadas").html(notif_finalizadas);
                                                } else {
                                                    $("#cant_consulta_finalizadas").hide();
                                                }

                                            }

                                        }
                                    }
                            );
                        }
                        window.location.href = BASE_PATH + "panel-paciente/perfil-salud/registros-consultas-medicas-detalle/" + idperfilsaludconsulta;

                    }
                });


            });
        </script>
    {/literal}
</div>