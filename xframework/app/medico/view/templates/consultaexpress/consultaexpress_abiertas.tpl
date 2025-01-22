<style>
    .icon-doctorplus-plus:before {
        content: "ouvrir (+)" !important;
        font-family: Lato, sans-serif !important;
        font-size: 13px;
    }
</style>
<div id="div_consultasexpress_abiertas" class="relative">

    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}" />
    <input type="hidden" id="notificacion_consultaexpress" value="{$notificacion_general}">
    {if $listado_consultas_abiertas.rows && $listado_consultas_abiertas.rows|@count > 0}
        <div class="cs-nc-section-holder">
            <div class="container">
                <ol class="breadcrum">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                        {*<li class="active">{"Abiertas"|x_translate}</li>*}

                </ol>
            </div>
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>
                            {if $cantidad_consulta.abiertas>0} <span id='cant_consulta_abiertas'>{$cantidad_consulta.abiertas}</span>{/if}

                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>


                <div class="cs-ca-consultas-holder">
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                        {foreach from=$listado_consultas_abiertas.rows key=key item=consulta_abierta}
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab">
                                    <div class="ce-ca-toolbar ">

                                        <div class="row">
                                            <div class="colx3">
                                                <div class="cs-ca-colx3-inner">
                                                    <a href="javascript:;" class="change_miembro" data-id="{$consulta_abierta.paciente.idpaciente}">
                                                        <div class="cs-ca-usr-avatar">
                                                            {if $consulta_abierta.paciente.image}
                                                                <img src="{$consulta_abierta.paciente.image.list}" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}" />
                                                            {else}
                                                                {if $consulta_abierta.paciente.animal!=1}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}" />
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}" />
                                                                {/if}
                                                            {/if}

                                                            <figure>
                                                                <i class="icon-doctorplus-pharmaceutics"></i>
                                                            </figure>

                                                        </div>
                                                        <div class="cs-ca-usr-data-holder">
                                                            <span>{"Paciente"|x_translate}</span>
                                                            <h2>{$consulta_abierta.paciente.nombre} {$consulta_abierta.paciente.apellido}</h2>
                                                        </div>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="colx3">
                                                <div class="cs-ca-colx3-inner">
                                                    {if $consulta_abierta.paciente_titular}

                                                        <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                            {if $consulta_abierta.paciente_titular.image}
                                                                <img src="{$consulta_abierta.paciente_titular.image.perfil}" alt="user" />
                                                            {else}
                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user" />
                                                            {/if}
                                                        </div>
                                                        <div class="cs-ca-usr-data-holder">
                                                            {if $consulta_abierta.paciente_titular.relacion != ""}
                                                                <span>{$consulta_abierta.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                            {else}
                                                                <span>{"propietario"|x_translate}</span>
                                                            {/if}
                                                            <h2>{$consulta_abierta.paciente_titular.nombre} {$consulta_abierta.paciente_titular.apellido}</h2>
                                                        </div>
                                                    {/if}
                                                </div>
                                            </div>
                                            <div class="colx3">
                                                <div class="cs-ca-consultas-abiertas-holder">
                                                    <div id="cont_mensajes_noleidos_{$consulta_abierta.idconsultaExpress}" class="cs-ca-consultas-abiertas-spacer">
                                                        {if $consulta_abierta.mensajes_noleidos>0}
                                                            <span>{"Mensajes sin leer"|x_translate}</span>
                                                            <figure>{$consulta_abierta.mensajes_noleidos}</figure>
                                                            {/if}
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" >

                                            <div class="pce-colx3">
                                                <div class="cs-ca-numero-consulta-holder">
                                                    <span class="cs-ca-numero-consulta-label">{"Consulta Express"|x_translate}</span>
                                                    <span class="cs-ca-numero-consulta">Nº {$consulta_abierta.numeroConsultaExpress}</span>
                                                </div>
                                            </div>
                                            <div class="pce-colx3">
                                                <div class="cs-ca-numero-consulta-holder">
                                                    <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                    <span class="cs-ca-numero-consulta">{$consulta_abierta.motivoConsultaExpress}</span>
                                                </div>
                                            </div>
                                            <div class="pce-colx3">
                                                <div class="cs-ca-date-tools">
                                                    <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                    <span class="cs-ca-fecha">{$consulta_abierta.fecha_inicio_format}</span>
                                                    <div class="cs-ca-date-tools-holder">
                                                        <a href="{$url}panel-medico/consultaexpress/abiertas-{$consulta_abierta.idconsultaExpress}.html">
                                                            <i class="icon-doctorplus-plus"></i>
                                                        </a>
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
                        <div class="col-xs-12">
                            <div class="paginas">
                                {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_abiertas" container_id="div_consultasexpress_abiertas"}
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>


        {literal}
            <script>
                $(document).ready(function (e) {
                    renderUI2();
                    //redireccion al perfil salud del paciente
                    $("#div_consultasexpress_abiertas .change_miembro").click(function () {

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
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>

                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Abiertas"|x_translate}</p>
                </div>
            </section>
        </div>
    {/if}
</div>