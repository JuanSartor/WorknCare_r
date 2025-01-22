<div id="div_consultasexpress_vencidas" class="cs-nc-section-holder">

    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id="notificacion_consultaexpress" value="{$cantidad_consulta.notificacion_general}">
    <input type="hidden" id='cant_consulta_vencidas_total' value="{$cantidad_consulta.vencidas_total}" />

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-paciente/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
        </ol>
    </div>
    {if $listado_consultas_vencidas.rows && $listado_consultas_vencidas.rows|@count > 0}
        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-paciente/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="far fa-calendar-times"></i></figure>
                        {if $cantidad_consulta.vencidas>0} <span id='cant_consulta_vencidas'>{$cantidad_consulta.vencidas}</span>{/if}
                    </div>
                    <span>{"VENCIDAS"|x_translate}</span>
                </div>
            </div>


            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_consultas_vencidas.rows key=key item=consulta_vencida}

                        <div class="panel panel-default">
                            <div class="panel-heading paciente-consulta-express-acc-header" role="tab">
                                <div class="ce-ca-toolbar">
                                    <div class="row consultas-vencidas {if $consulta_vencida.leido_paciente=="0"}highlight{/if}">
                                     
                                        {*header medico consulta*}
                                        {include file="consultaexpress/consultaexpress_header_medico.tpl" consulta=$consulta_vencida} 

                                        {*header tipo consulta*}
                                        {include file="consultaexpress/consultaexpress_header_tipo.tpl" consulta=$consulta_vencida} 

                                        <div class="cs-ca-tiempo-respuesta-holder">
                                            <div class="cs-ca-tiempo-respuesta-inner ce-pc-tiempo-vencidas">
                                                <span class="cs-ca-tiempo-respuesta-label">{"Tiempo cumplido"|x_translate}</span>
                                                <div class="cs-ca-tiempo-respuesta">
                                                    <span class="cs-ca-clock-icon"><i class="icon-doctorplus-clock"></i></span>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed">
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
                                                <span class="cs-ca-numero-consulta-date-label">{"Solicitud enviada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$consulta_vencida.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="{$url}panel-paciente/consultaexpress/vencidas-{$consulta_vencida.idconsultaExpress}.html">
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

            <div class="row">
                <div class="col-xs-12">

                    <div class="paginas">
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress" submodulo="consultaexpress_vencidas" container_id="div_consultasexpress_vencidas"}
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
{literal}
    <script>
        $(function (e) {
            renderUI2();
        });
    </script>
{/literal}