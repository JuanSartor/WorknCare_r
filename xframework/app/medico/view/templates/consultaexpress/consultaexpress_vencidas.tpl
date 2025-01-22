<div id="div_consultasexpress_vencidas">
    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id='cant_consulta_vencidas_total' value="{$cantidad_consulta.vencidas_total}"/>

    <input type="hidden" id="notificacion_consultaexpress" value="{$notificacion_general}">

    {if $listado_consultas_vencidas.rows && $listado_consultas_vencidas.rows|@count > 0}
        <div class="cs-nc-section-holder">	
            <div class="container">
                <ol class="breadcrum">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                        {*<li class="active">{"Vencidas"|x_translate}</li>*}
                </ol>
            </div>
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="far fa-calendar-times"></i></figure>
                        </div>
                        <span>{"VENCIDAS"|x_translate}</span>
                    </div>
                </div>


                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                        {foreach from=$listado_consultas_vencidas.rows key=key item=consulta_vencida}
                            <div class="panel panel-default paciente-consulta-express-acc-header">
                                <div class="panel-heading" role="tab">
                                    <div class="ce-ca-toolbar">
                                        <div class="row">
                                            <div class="colx3">
                                                <div class="cs-ca-colx3-inner">
                                                    <div class="cs-ca-usr-avatar">
                                                        {if $consulta_vencida.paciente.image}
                                                            <img src="{$consulta_vencida.paciente.image.list}" alt="user"/>
                                                        {else}
                                                            {if $consulta_vencida.paciente.animal!=1}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                            {/if}
                                                        {/if}
                                                        <a href="javascript:;"  class="change_miembro" data-id="{$consulta_vencida.paciente.idpaciente}">
                                                            <figure>
                                                                <i class="icon-doctorplus-pharmaceutics"></i>
                                                            </figure>
                                                        </a>
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        <span>{"Paciente"|x_translate}</span>
                                                        <h2>{$consulta_vencida.paciente.nombre} {$consulta_vencida.paciente.apellido}</h2>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="colx3">
                                                <div class="cs-ca-colx3-inner">
                                                    {if $consulta_vencida.paciente_titular}

                                                        <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                            {if $consulta_vencida.paciente_titular.image}
                                                                <img src="{$consulta_vencida.paciente_titular.image.perfil}" alt="user"/>
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                            {/if}
                                                        </div>
                                                        <div class="cs-ca-usr-data-holder">
                                                            {if $consulta_vencida.paciente_titular.relacion != ""}
                                                                <span>{$consulta_vencida.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                            {else}
                                                                <span>{"propietario"|x_translate}</span>
                                                            {/if}
                                                            <h2>{$consulta_vencida.paciente_titular.nombre} {$consulta_vencida.paciente_titular.apellido}</h2>
                                                        </div>
                                                    {/if}
                                                </div>
                                            </div>
                                            <div class="cs-ca-tiempo-respuesta-holder">
                                                <div class="cs-ca-tiempo-respuesta-inner ce-pc-tiempo-vencidas">
                                                    <span class="cs-ca-tiempo-respuesta-label">{"Tiempo cumplido"|x_translate}</span>
                                                    <div class="cs-ca-tiempo-respuesta">
                                                        <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$consulta_vencida.idconsultaExpress}" aria-expanded="true" aria-controls="collapse-{$consulta_vencida.idconsultaExpress}">
                                            <div class="pce-colx3">
                                                <div class="cs-ca-numero-consulta-holder">
                                                    <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                    <span class="cs-ca-numero-consulta">Nº {$consulta_vencida.numeroConsultaExpress}</span>
                                                </div>
                                            </div>
                                            <div class="pce-colx3">
                                                <div class="cs-ca-numero-consulta-holder">
                                                    <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                    <span class="cs-ca-numero-consulta">{$consulta_vencida.motivoConsultaExpress}</span>
                                                </div>
                                            </div>
                                            <div class="pce-colx3">
                                                <div class="cs-ca-date-tools">
                                                    <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                    <span class="cs-ca-fecha">{$consulta_vencida.fecha_inicio_format}</span>
                                                    <div class="cs-ca-date-tools-holder">
                                                        <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="collapse-{$consulta_vencida.idconsultaExpress}" data-id="{$consulta_vencida.idconsultaExpress}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$consulta_vencida.idconsultaExpress}">
                                    <div class="panel-body">
                                        <div class="cs-ca-chat-holder">

                                            {foreach from=$consulta_vencida.mensajes item=mensaje}

                                                {if $mensaje.emisor == "p"}
                                                    <div class="row chat-row">
                                                        <div class="chat-line-holder pce-dr-chat">
                                                            <div class="chat-image-avatar-xn">
                                                                {if $consulta_vencida.paciente_titular}
                                                                    <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                        {if $consulta_vencida.paciente_titular.image.perfil != ""}
                                                                            <img src="{$consulta_vencida.paciente_titular.image.perfil}" alt="user"/>
                                                                        {else}
                                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                        {/if}
                                                                    </div>
                                                                {/if}
                                                                <div class="chat-image-avatar-xn-row">
                                                                    {if $consulta_vencida.paciente.image.perfil != ""}
                                                                        <img src="{$consulta_vencida.paciente.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        {if $consulta_vencida.paciente.image.animal != 1}
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

                                        </div>

                                        <div class="row">
                                            <div class="audio-actions-panel">
                                                <div class="audio-action-holder">
                                                    <a href="javascript:;" data-id="{$consulta_vencida.idconsultaExpress}" class="btn_eliminar_consulta"><i class="icon-doctorplus-cruz"></i>Eliminar</a>
                                                </div>
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
                            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_vencidas" container_id="div_consultasexpress_vencidas"}
                        </div>
                    </div>
                </div>
            </section>

        </div>	

        {literal}
            <script>



                $(function () {
                    renderUI2();
                    //redireccion al perfil salud del paciente
                    $("#div_consultasexpress_vencidas .change_miembro").click(function () {

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

                    $(".btn_eliminar_consulta").click(function () {
                        id = $(this).data("id");
                        if (parseInt(id) > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_from_vencidas.do',
                                    "id=" + id,
                                    function (data) {
                                        if (data.result) {
                                            window.location.href = "";
                                        }
                                    }
                            );
                        }
                    });

                    //scroll hasta el ultimo mensaje del chat
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        scrollToLastMsg($(".cs-ca-chat-holder"));
                    });

                });

            </script>

        {/literal}

    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="far fa-calendar-times"></i></figure>

                        </div>
                        <span>{"VENCIDAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Vencidas"|x_translate}</p>
                </div>
            </section>
        </div>
    {/if}
</div>