<div id="div_consultasexpress_abiertas" class="relative cs-nc-section-holder">
    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_abiertas_total' value="{$cantidad_consulta.abiertas_total}" />

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                {*<li class="active">{"Abiertas"|x_translate}</li>*}
        </ol>
    </div>

    {if $listado_consultas_abiertas.rows && $listado_consultas_abiertas.rows|@count > 0}
        <div class="cs-nc-section-holder">

            <section class="container cs-nc-p2">

                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
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
                                <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                    <div class="ce-ca-toolbar">
                                        <div class="row">
                                            {*header medico consulta*}
                                            {include file="consultaexpress/consultaexpress_header_medico.tpl" consulta=$consulta_abierta}

                                            {*header tipo consulta*}
                                            {include file="consultaexpress/consultaexpress_header_tipo.tpl" consulta=$consulta_abierta}

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

                                        <div class="row ce-ca-toolbar-row pce-header-low-row collapsed">
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
                                                    <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                    <span class="cs-ca-fecha">{$consulta_abierta.fecha_inicio_format}</span>
                                                    <div class="cs-ca-date-tools-holder">
                                                        <a href="{$url}panel-paciente/consultaexpress/abiertas-{$consulta_abierta.idconsultaExpress}.html">
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

                </div>
                {if $listado_consultas_abiertas.rows && $listado_consultas_abiertas.rows|@count > 0}
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="paginas">
                                {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_abiertas"  container_id="div_consultasexpress_abiertas"}
                            </div>
                        </div>
                    </div>
                {/if}
            </section>
        </div>
    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-chat-comment"></i></figure>

                        </div>
                        <span>{"ABIERTAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p><strong>{"Ud. no tiene Consultas Abiertas"|x_translate}.</p>
            </section>
        </div>
    {/if}
</div>