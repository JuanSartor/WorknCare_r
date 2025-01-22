<div id="div_videoconsulta_finalizadas" class="cs-nc-section-holder">



    {include file="videoconsulta/videoconsulta_settings.tpl"}
    <input type="hidden" id="notificacion_videoconsulta" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_finalizadas_total' value="{$cantidad_consulta.finalizadas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {*<li class="active">{"Finalizadas"|x_translate}</li>*}
        </ol>
    </div>

    {if $listado_videoconsultas_finalizadas.rows && $listado_videoconsultas_finalizadas.rows|@count > 0}

        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <div class="ce-ca-toolbar-col">
                        <a href="{$url}panel-paciente/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                            {if $cantidad_consulta.finalizadas>0} <span id="cant_videoconsulta_finalizadas">{$cantidad_consulta.finalizadas}</span>{/if}                    </div>
                        <span>{"Finalizadas"|x_translate}</span>
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

            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_videoconsultas_finalizadas.rows key=key item=videoconsulta_finalizada}

                        <div id="consulta-finalizada-{$videoconsulta_finalizada.idvideoconsulta}" class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar" >
                                    <div class="row consultas-finalizadas video-consulta with-parent {if $videoconsulta_finalizada.leido_paciente=="0"}highlight{/if} ">
                                        {*header medico consulta*}
                                        {include file="videoconsulta/videoconsulta_header_medico.tpl" consulta=$videoconsulta_finalizada} 

                                        {*header tipo consulta*}
                                        {include file="videoconsulta/videoconsulta_header_tipo.tpl" consulta=$videoconsulta_finalizada} 

                                        <div class="ca-ce-finalizadas-col">

                                            {if $videoconsulta_finalizada.estadoVideoConsulta_idestadoVideoConsulta!=8}
                                                {if $videoconsulta_finalizada.posee_receta=="1"}<small style="float: left;color: #f2f2f2;">{"Prescripcion recibida!"|x_translate}</small>{/if}
                                                <a class="ver-indicaciones" data-id="{$videoconsulta_finalizada.idvideoconsulta}" data-idperfilsaludconsulta="{$videoconsulta_finalizada.idperfilSaludConsulta}" href="javascript:;">
                                                    <figure>
                                                        <i class="icon-doctorplus-sheet"></i>
                                                        {if $videoconsulta_finalizada.leido_paciente=="0"}
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
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_finalizada.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_finalizada.idvideoconsulta}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_finalizada.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_finalizada.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Finalizada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_finalizada.fecha_fin_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$videoconsulta_finalizada.idvideoconsulta}" class="panel-collapse collapse" data-id="{$videoconsulta_finalizada.idvideoconsulta}" role="tabpanel" aria-labelledby="heading-{$videoconsulta_finalizada.idvideoconsulta}">
                                <div class="panel-body">

                                    <div class="cs-ca-chat-holder">
                                        {if $videoconsulta_finalizada.cancelada_paciente=="1"}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Cancelada por el paciente"|x_translate} </small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}
                                        {if $videoconsulta_finalizada.republicacion!=""}
                                            <div class="row chat-row chat-date-divider">
                                                <span class="chat-date"><small>{"Republicación Video Consulta Nº"|x_translate}{$videoconsulta_finalizada.republicacion}</small></span>
                                                <div class="chat-line-divider"></div>
                                            </div>
                                        {/if}

                                        {foreach from=$videoconsulta_finalizada.mensajes item=mensaje}

                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-image-avatar-xn pcer-chat-image-right">


                                                            {if $videoconsulta_finalizada.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $videoconsulta_finalizada.paciente_titular.image.perfil != ""}
                                                                        <img src="{$videoconsulta_finalizada.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_finalizada.paciente.image.perfil != ""}
                                                                    <img src="{$videoconsulta_finalizada.paciente.image.perfil}" alt="user"/>
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
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
                                                <div class="row chat-row">
                                                    {if $videoconsulta_finalizada.republicacion!=""}
                                                        <div class="row chat-row chat-date-divider">
                                                            <span class="chat-date"><small>{"Republicación Video Consulta Nº"|x_translate}{$videoconsulta_finalizada.republicacion}</small></span>
                                                            <div class="chat-line-divider"></div>
                                                        </div>
                                                    {/if}
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        {if $videoconsulta_finalizada.medico.imagen.perfil != ""}
                                                            <img src="{$videoconsulta_finalizada.medico.imagen.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date"><span>{$videoconsulta_finalizada.medico.titulo_profesional.titulo_profesional} {$videoconsulta_finalizada.medico.nombre} {$videoconsulta_finalizada.medico.apellido}</span> {$videoconsulta_finalizada.fecha_fin_format} hs</div>
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




                                        {/foreach}
                                    </div>
                                    {if $videoconsulta_finalizada.estadoVideoConsulta_idestadoVideoConsulta!=8 && $videoconsulta_finalizada.idperfilSaludConsulta!=""}
                                        <div class="row">
                                            <div class="audio-actions-panel">
                                                <div class="audio-action-holder">
                                                    <a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$videoconsulta_finalizada.idperfilSaludConsulta}"><i class="icon-doctorplus-sheet"></i>{"Ver conclusiones"|x_translate}</a>
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
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="videoconsulta_finalizadas" container_id="div_videoconsulta_finalizadas"}
                    </div>
                </div>
            </div>

        </section>
    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">


                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-ficha-check"></i></figure>

                        </div>
                        <span>{"Finalizadas"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Finalizadas"|x_translate}.</p>
                </div>

            </section>
        </div>
    {/if}

    {literal}
        <script>

            //actualizamos el contador de notificaciones

            $(document).ready(function (e) {

                renderUI2("div_videoconsulta_finalizadas");

                //filtros de busqueda por fecha
                $("#filtro_inicio,#filtro_fin").datetimepicker({
                    pickTime: false,
                    language: 'fr'
                });
                $("#filtro_inicio,#filtro_fin").inputmask("d/m/y");

                //boton filtro de consultas finalizadas por fecha
                $("#btnAplicarFiltro").click(function () {
                    $("#div_videoconsulta_finalizadas").spin("large");
                    x_loadModule('videoconsulta', 'videoconsulta_finalizadas', 'do_reset=1&filtro_inicio=' + $("#filtro_inicio").val() + '&filtro_fin=' + $("#filtro_fin").val(), 'div_videoconsulta_finalizadas', "paciente_p");
                });

                //scroll hasta el ultimo mensaje del chat
                $('.panel-collapse').on('show.bs.collapse', function () {
                    scrollToLastMsg($(".cs-ca-chat-holder"));
                });

                //marcamos la consulta leida al desplegarla
                $('.panel-collapse').on('show.bs.collapse', function () {
                    $this = $(this);
                    var id = parseInt($this.data("id"));

                    if (id > 0) {
                        if ($(".ver-indicaciones[data-id='" + id + "']").find(".subcircle").length > 0) {

                            //Enviar a leer todos los mensajes
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_leida_videoconsulta.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {

                                        if (data.result) {
                                            $("#consulta-finalizada-" + id + " .consultas-finalizadas").removeClass("highlight");
                                            $(".ver-indicaciones[data-id='" + id + "']").find(".subcircle").remove();
                                            //actualizamos el contador de notificaciones generales superior
                                            var notif_CE = parseInt($("#notificacion_videoconsulta").val()) - 1;
                                            $("#notificacion_videoconsulta").val(notif_CE);
                                            if (notif_CE > 0) {
                                                $("#div_shorcuts_cant_videoconsulta").html("<span>" + notif_CE + "</span>");
                                            } else {
                                                $("#div_shorcuts_cant_videoconsulta").html("");
                                            }
                                            //actualizamos el contador de abiertas
                                            var notif_finalizadas = parseInt($("#cant_videoconsulta_finalizadas").html()) - 1;
                                            if (notif_finalizadas > 0) {
                                                $("#cant_videoconsulta_finalizadas").html(notif_finalizadas);
                                            } else {
                                                $("#cant_videoconsulta_finalizadas").hide();
                                            }



                                        }
                                    }
                            );
                        }
                    }
                });

                //marcamos la consulta leida al desplegarla
                $("#div_videoconsulta_finalizadas").on('click', "a.ver-indicaciones", function (e) {
                    e.preventDefault();
                    $this = $(this);
                    var id = parseInt($this.data("id"));
                    var idperfilsaludconsulta = parseInt($this.data("idperfilsaludconsulta"));
                    if (id > 0 && idperfilsaludconsulta > 0) {
                        //Enviar a leer todos los mensajes
                        if ($(".ver-indicaciones[data-id='" + id + "']").find(".subcircle").length > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_leida_videoconsulta.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {

                                        if (data.result) {

                                            //actualizamos el contador de notificaciones generales superior
                                            var notif_CE = parseInt($("#notificacion_videoconsulta").val()) - 1;
                                            $("#notificacion_videoconsulta").val(notif_CE);
                                            if (notif_CE > 0) {
                                                $("#div_shorcuts_cant_videoconsulta").html("<span>" + notif_CE + "</span>");
                                            } else {
                                                $("#div_shorcuts_cant_videoconsulta").html("");
                                            }
                                            //actualizamos el contador de abiertas
                                            var notif_finalizadas = parseInt($("#cant_videoconsulta_finalizadas").html()) - 1;
                                            if (notif_finalizadas > 0) {
                                                $("#cant_videoconsulta_finalizadas").html(notif_finalizadas);
                                            } else {
                                                $("#cant_videoconsulta_finalizadas").hide();
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