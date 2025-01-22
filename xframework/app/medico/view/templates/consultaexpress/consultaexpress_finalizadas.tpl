<div id="div_consultasexpress_finalizadas">

    {include file="consultaexpress/consultaexpress_settings.tpl"}
    <input type="hidden" id='cant_consulta_finalizadas_total' value="{$cantidad_consulta.finalizadas_total}"/>

    <input type="hidden" id="notificacion_consultaexpress" value="{$notificacion_general}">
    {if $listado_consultas_finalizadas.rows && $listado_consultas_finalizadas.rows|@count > 0 || $listado_consultas_pendientes_finalizacion.rows && $listado_consultas_pendientes_finalizacion.rows|@count > 0}
        <div class="cs-nc-section-holder">	
            <div class="container">
                <ol class="breadcrum">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                        {*<li class="active">{"Finalizadas"|x_translate}</li>*}

                </ol>
            </div>
            <section class="container cs-nc-p2">
                <!--	<div class="cs-nc-p2-inner">-->
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                            {if $cantidad_consulta.pendientes_finalizacion>0} <span id="cant_consulta_pendientes_finalizacion">{$cantidad_consulta.pendientes_finalizacion}</span>{/if}
                        </div>
                        <span>{"FINALIZADAS"|x_translate}</span>
                    </div>
                </div>


                </script> 
                {*pendientes de finalizacion*}
                {if $listado_consultas_pendientes_finalizacion.rows && $listado_consultas_pendientes_finalizacion.rows|@count > 0 }
                    <div id="div_pendientes_finalizacion">
                        {include file="consultaexpress/consultaexpress_pendientes_finalizacion.tpl"}
                    </div>
                {/if}

                {*finalizacion*}
                {if $listado_consultas_finalizadas.rows && $listado_consultas_finalizadas.rows|@count > 0  }
                    <div class="cs-ca-consultas-holder">
                        <div class="row">
                            <div class="ce-ca-toobar {if $listado_consultas_pendientes_finalizacion.rows && $listado_consultas_pendientes_finalizacion.rows|@count > 0 }ca-ce-divider{/if}">

                                <div class="ce-ca-toolbar-filter-col-wide">
                                    <div class="ce-ca-toolbar-filter-box">
                                        <div class="ce-ca-toolbar-desde-box">
                                            <label>{"Mostrar desde"|x_translate}
                                                <input type="text" id="filtro_inicio" name="filtro_inicio" value="{$filtro_inicio}" placeholder="dd/mm/aaaa"/>
                                            </label>
                                        </div>
                                        <div class="ce-ca-toolbar-hasta-box">
                                            <label>{"hasta"|x_translate}
                                                <input type="text" id="filtro_fin" name="filtro_fin" value="{$filtro_fin}" placeholder="dd/mm/aaaa"/>
                                            </label>
                                        </div>
                                        <div class="ce-ca-toolbar-action-box">
                                            <button id="btnAplicarFiltro"><i class="icon-doctorplus-search"></i></button>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                            {foreach from=$listado_consultas_finalizadas.rows key=key item=consulta_finalizada}
                                <div id="consulta-finalizada-{$consulta_finalizada.idconsultaExpress}" class="panel panel-default">
                                    <div class="panel-heading" role="tab">
                                        <div class="ce-ca-toolbar">                         
                                            <div class="row consultas-finalizadas with-parent{if $consulta_finalizada.leido_medico=="0"}highlight{/if}">
                                                <div class="colx3">
                                                    <div class="cs-ca-colx3-inner">
                                                        <div class="cs-ca-usr-avatar">
                                                            {if $consulta_finalizada.paciente.image}
                                                                <img src="{$consulta_finalizada.paciente.image.list}" alt="user"/>
                                                            {else}
                                                                {if $consulta_finalizada.paciente.animal!=1}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                                {/if}
                                                            {/if}
                                                            <a href="javascript:;"  class="change_miembro" data-id="{$consulta_finalizada.paciente.idpaciente}">
                                                                <figure>
                                                                    <i class="icon-doctorplus-pharmaceutics"></i>
                                                                </figure>
                                                            </a>
                                                        </div>
                                                        <div class="cs-ca-usr-data-holder">
                                                            <span>{"Paciente"|x_translate}</span>
                                                            <h2>{$consulta_finalizada.paciente.nombre} {$consulta_finalizada.paciente.apellido}</h2>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="colx3">
                                                    <div class="cs-ca-colx3-inner">
                                                        {if $consulta_finalizada.paciente_titular}

                                                            <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                                {if $consulta_finalizada.paciente_titular.image}
                                                                    <img src="{$consulta_finalizada.paciente_titular.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                            </div>
                                                            <div class="cs-ca-usr-data-holder">
                                                                {if $consulta_finalizada.paciente_titular.relacion != ""}
                                                                    <span>{$consulta_finalizada.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                                {else}
                                                                    <span>{"propietario"|x_translate}</span>
                                                                {/if}
                                                                <h2>{$consulta_finalizada.paciente_titular.nombre} {$consulta_finalizada.paciente_titular.apellido}</h2>
                                                            </div>
                                                        {/if}
                                                    </div>
                                                </div>
                                                <div class="ca-ce-finalizadas-col">

                                                    <a class="btn-ver-conclusiones" data-idpaciente="{$consulta_finalizada.paciente_idpaciente}" data-nombre="{$consulta_finalizada.paciente.nombre|str2seo}" data-apellido="{$consulta_finalizada.paciente.apellido|str2seo}" data-idconsulta="{$consulta_finalizada.idperfilSaludConsulta}" href="javascript:;">
                                                        <figure>
                                                            <i class="icon-doctorplus-sheet"></i>
                                                            {if $consulta_finalizada.leido_medico=="0"}
                                                                <span class="subcircle"></span>
                                                            {/if}
                                                        </figure>
                                                        <span>{"Ver registro médico"|x_translate}</span>
                                                    </a>
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
                                    <div id="collapse-{$consulta_finalizada.idconsultaExpress}" class="panel-collapse collapse" role="tabpanel" data-id="{$consulta_finalizada.idconsultaExpress}" aria-labelledby="heading-{$consulta_finalizada.idconsultaExpress}">

                                        <div class="panel-body">
                                            <div class="cs-ca-chat-holder">

                                                {foreach from=$consulta_finalizada.mensajes item=mensaje}
                                                    {if $mensaje.emisor == "p"}
                                                        <div class="row chat-row">
                                                            <div class="chat-line-holder pce-dr-chat">
                                                                <div class="chat-image-avatar-xn">
                                                                    {if $consulta_finalizada.paciente_titular}
                                                                        <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                            {if $consulta_finalizada.paciente_titular.image.perfil != ""}
                                                                                <img src="{$consulta_finalizada.paciente_titular.image.perfil}" alt="user"/>
                                                                            {else}
                                                                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                            {/if}
                                                                        </div>
                                                                    {/if}
                                                                    <div class="chat-image-avatar-xn-row">
                                                                        {if $consulta_finalizada.paciente.image.perfil != ""}
                                                                            <img src="{$consulta_finalizada.paciente.image.perfil}" alt="user"/>
                                                                        {else}
                                                                            {if $consulta_finalizada.paciente.animal != 1}
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
                                                    {else}
                                                        <div class="row chat-row">
                                                            <div class="chat-line-holder pce-paciente-chat">
                                                                <div class="chat-image-avatar-xn pcer-chat-image-right">



                                                                    <div class="chat-image-avatar-xn-row">
                                                                        {if $consulta_finalizada.medico.image.perfil != ""}
                                                                            <img src="{$consulta_finalizada.medico.image.perfil}" alt="user"/>
                                                                        {else}
                                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                        {/if}

                                                                    </div>
                                                                </div>
                                                                <div class="chat-content pcer-chat-right">
                                                                    <figure>
                                                                        <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
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
                                                        <a class="btn-ver-conclusiones" data-idpaciente="{$consulta_finalizada.paciente_idpaciente}" data-idconsulta="{$consulta_finalizada.idperfilSaludConsulta}"  data-nombre="{$consulta_finalizada.paciente.nombre|str2seo}" data-apellido="{$consulta_finalizada.paciente.apellido|str2seo}" href="javascript:;"><i class="icon-doctorplus-sheet"></i>{"Ver registro médico"|x_translate}</a>
                                                    </div>
                                                </div>
                                            </div>



                                        </div>
                                    </div>
                                </div>
                            {/foreach}

                        </div>

                    </div>


                    <!--	</div>-->

                    <div class="row">
                        <div class="col-xs-12">
                            {if $listado_consultas_finalizadas.rows && $listado_consultas_finalizadas.rows|@count > 0}
                                {x_paginate_loadmodule_v2  id="$idpaginate" modulo="consultaexpress"
                    submodulo="consultaexpress_finalizadas" 
                    container_id="div_consultasexpress_finalizadas"}
                            {/if}
                        </div>
                    </div>
                {else}
                    <div class="cs-nc-section-holder">
                        <section class="container cs-nc-p2">
                            <div class="row">
                                <div class="ce-ca-toobar ca-ce-divider">

                                    <div class="ce-ca-toolbar-filter-col-wide">
                                        <div class="ce-ca-toolbar-filter-box">
                                            <div class="ce-ca-toolbar-desde-box">
                                                <label>{"Mostrar desde"|x_translate}
                                                    <input type="text" id="filtro_inicio" name="filtro_inicio" value="{$filtro_inicio}" placeholder="dd/mm/aaaa"/>
                                                </label>
                                            </div>
                                            <div class="ce-ca-toolbar-hasta-box">
                                                <label>{"hasta"|x_translate}
                                                    <input type="text" id="filtro_fin" name="filtro_fin" value="{$filtro_fin}" placeholder="dd/mm/aaaa"/>
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
                                <p><strong>{"Ud. no tiene Consultas Finalizadas"|x_translate}</strong></p>
                            </div>
                        </section>
                    </div>
                {/if}

            </section>
        </div>	
    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/consultaexpress/" ><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="icon-doctorplus-sheet"></i></figure>

                        </div>
                        <span>{"FINALIZADAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-sheet"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Consultas Finalizadas"|x_translate}.</p>
                </div>
            </section>
        </div>
    {/if}
</div>
{literal}
    <script>

        $(function () {
            renderUI2("div_consultasexpress_finalizadas");
            //filtros de busqueda por fecha
            $("#filtro_inicio,#filtro_fin").datetimepicker({
                pickTime: false,
                language: 'fr'
            });
            $("#filtro_inicio,#filtro_fin").inputmask("d/m/y");

            //redireccion al perfil salud del paciente
            $("#div_consultasexpress_finalizadas .change_miembro").click(function () {

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

            //conclusiones de la CE
            $(".btn-ver-conclusiones").click(function () {
                var idpaciente = $(this).data("idpaciente");
                var idconsulta = $(this).data("idconsulta");
                var nombre = $(this).data("nombre");
                var apellido = $(this).data("apellido");
                if (parseInt(idpaciente) > 0 && parseInt(idconsulta) > 0) {

                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + idpaciente + "-" + nombre + "-" + apellido + "/mis-registros-consultas-medicas/" + idconsulta;

                }


            });

            //conclusiones de la CE
            $(".btn-escribir-conclusiones").click(function () {

                var idpaciente = $(this).data("idpaciente");
                var idconsultaexpress = $(this).data("idconsultaexpress");
                var nombre = $(this).data("nombre");
                var apellido = $(this).data("apellido");

                if (parseInt(idpaciente) > 0 && parseInt(idconsultaexpress) > 0) {
                    $("body").spin("large");
                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + idpaciente + "-" + nombre + "-" + apellido + "/mis-registros-consultas-medicas/consultanueva-express-" + idconsultaexpress + ".html";

                }

            });

            //boton filtro de consultas finalizadas por fecha
            $("#btnAplicarFiltro").click(function () {
                $("#div_consultasexpress_finalizadas").spin("large");
                x_loadModule('consultaexpress', 'consultaexpress_finalizadas', 'do_reset=1&filtro_inicio=' + $("#filtro_inicio").val() + '&filtro_fin=' + $("#filtro_fin").val(), 'div_consultasexpress_finalizadas');
            });
            console.log("custom scroll diabled");
            /*$(".cs-ca-chat-holder").mCustomScrollbar({
             theme: "dark-3"
             });*/
            //scroll hasta el ultimo mensaje del chat
            $('.panel-collapse').on('show.bs.collapse', function () {
                scrollToLastMsg($(".cs-ca-chat-holder"));
            });
            $('#div_consultasexpress_finalizadas .slider-for').slick({
                slidesToShow: 1,
                slidesToScroll: 1,
                arrows: true,
                centerMode: false,
                fade: true,
                asNavFor: '#div_consultasexpress_finalizadas .slider-nav-carrousel',
                draggable: true,
                adaptiveHeight: true
            });
            $('#div_consultasexpress_finalizadas .slider-nav-carrousel').slick({
                slidesToShow: 3,
                slidesToScroll: 1,
                asNavFor: '#div_consultasexpress_finalizadas .slider-for',
                dots: false,
                centerMode: false,
                focusOnSelect: true,
                draggable: true
            });
        });


    </script>
{/literal}

