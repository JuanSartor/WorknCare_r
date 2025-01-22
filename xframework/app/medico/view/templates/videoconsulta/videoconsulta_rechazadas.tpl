<div id="div_videoconsulta_rechazadas" class="cs-nc-section-holder">
    {include file="videoconsulta/videoconsulta_settings.tpl"}

    <input type="hidden" id="notificacion_videoconsulta" value="{$notificacion_general}">
    <input type="hidden" id='cant_consulta_rechazadas_total' value="{$cantidad_consulta.rechazadas_total}"/>

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                {*<li class="active">{"Declinadas"|x_translate}</li>*}
        </ol>
    </div>
    {if $listado_videoconsultas_rechazadas.rows && $listado_videoconsultas_rechazadas.rows|@count > 0}


        <section class="container cs-nc-p2">
            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-medico/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-times"></i></figure>

                    </div>
                    <span>{"DECLINADAS"|x_translate}</span>
                </div>
            </div>

            <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
                <div class="modal-dialog">
                    <div class="modal-content"></div>
                </div>
            </div>
            <script>
                $(document).ready(function (e) {
                    $('#ver-archivo').on('hidden.bs.modal', function () {
                        $(this)
                                .removeData('bs.modal')
                                .find(".modal-content").html('');
                    });
                });


            </script> 

            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">


                    {foreach from=$listado_videoconsultas_rechazadas.rows key=key item=videoconsulta_rechazada}
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading-{$videoconsulta_rechazada.idvideoconsulta}">
                                <div class="ce-ca-toolbar cv-ca-toolbar">                         
                                    <div class="row">
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                <div class="cs-ca-usr-avatar">
                                                    {if $videoconsulta_rechazada.paciente.image}
                                                        <img src="{$videoconsulta_rechazada.paciente.image.list}" alt="user"/>
                                                    {else}
                                                        {if $videoconsulta_rechazada.paciente.animal!=1}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                        {/if}
                                                    {/if}
                                                    <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_rechazada.paciente.idpaciente}">
                                                        <figure>
                                                            <i class="icon-doctorplus-pharmaceutics"></i>
                                                        </figure>
                                                    </a>
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    <span>{"Paciente"|x_translate}</span>
                                                    <h2>{$videoconsulta_rechazada.paciente.nombre} {$videoconsulta_rechazada.paciente.apellido}</h2>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-colx3-inner">
                                                {if $videoconsulta_rechazada.paciente_titular}

                                                    <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                        {if $videoconsulta_rechazada.paciente_titular.image}
                                                            <img src="{$videoconsulta_rechazada.paciente_titular.image.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}
                                                    </div>
                                                    <div class="cs-ca-usr-data-holder">
                                                        {if $videoconsulta_rechazada.paciente_titular.relacion != ""}
                                                            <span>{$videoconsulta_rechazada.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                        {else}
                                                            <span>{"propietario"|x_translate}</span>
                                                        {/if}
                                                        <h2>{$videoconsulta_rechazada.paciente_titular.nombre} {$videoconsulta_rechazada.paciente_titular.apellido}</h2>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="colx3">
                                            <div class="cs-ca-consultas-abiertas-holder">
                                                <div class="cs-ca-consultas-abiertas-spacer">	
                                                    <i class="fas fa-user-times cs-ca-finalizadas-icon"></i>
                                                    <span class="cs-ca-finalizadas">{"Consulta Declinada"|x_translate}</span>
                                                    <span class="cs-ca-finalizadas-date">{$videoconsulta_rechazada.fecha_fin_format}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_rechazada.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_rechazada.idvideoconsulta}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_rechazada.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo"|x_translate}:</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_rechazada.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_rechazada.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$videoconsulta_rechazada.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" data-id="{$videoconsulta_rechazada.idvideoconsulta}"  aria-labelledby="heading-{$videoconsulta_rechazada.idvideoconsulta}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">

                                        {foreach from=$videoconsulta_rechazada.mensajes item=mensaje}

                                            {if $mensaje.emisor == "p"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-dr-chat">
                                                        <div class="chat-image-avatar-xn">
                                                            {if $videoconsulta_rechazada.paciente_titular}
                                                                <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                    {if $videoconsulta_rechazada.paciente_titular.image.perfil != ""}
                                                                        <img src="{$videoconsulta_rechazada.paciente_titular.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_rechazada.paciente.image.perfil != ""}
                                                                    <img src="{$videoconsulta_rechazada.paciente.image.perfil}" alt="user"/>
                                                                {else}
                                                                    {if $videoconsulta_rechazada.paciente.animal!=1}
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
                                                                {*archivos videoconsulta*}
                                                                {if $mensaje.idmensajeVideoConsulta!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                                {*archivos turno*}
                                                                {if $mensaje.idmensajeTurno!=""}
                                                                    <div class="chat-content-attach">
                                                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeTurno}" data-target="#ver-archivo">
                                                                            <i class="fui-clip"></i>
                                                                            &nbsp;{$mensaje.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                            {/if}
                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-image-avatar-xn pcer-chat-image-right">

                                                            <div class="chat-image-avatar-xn-row">
                                                                {if $videoconsulta_rechazada.medico.image.perfil != ""}
                                                                    <img src="{$videoconsulta_rechazada.medico.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}

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
                                                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
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
                                            <div class="chat-line-holder pce-paciente-chat ">
                                                <div class="chat-image-avatar-xn pcer-chat-image-right">

                                                    <div class="chat-image-avatar-xn-row">
                                                        {if $videoconsulta_rechazada.medico.image.perfil != ""}
                                                            <img src="{$videoconsulta_rechazada.medico.image.perfil}" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {/if}

                                                    </div>
                                                </div>
                                                <div class="chat-content pcer-chat-right">
                                                    <figure>
                                                        <div class="chat-content-date">{$videoconsulta_rechazada.fecha_fin_format} hs</div>
                                                        <p class="chat-content-rechazada">
                                                            {"Motivo"|x_translate}:
                                                            {$videoconsulta_rechazada.motivoRechazo}
                                                        </p>
                                                        <span class="chat-content-arrow"></span>
                                                    </figure>
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
                    {if $listado_videoconsultas_rechazadas.rows && $listado_videoconsultas_rechazadas.rows|@count > 0}
                        <div class="paginas">
                            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta"
                        submodulo="videoconsulta_rechazadas" 
                        container_id="div_videoconsulta_rechazadas"}
                        </div>
                    {/if}
                </div>
            </div>

        </section>



        {literal}
            <script>

                $(function () {
                    renderUI2();
                    //redireccion al perfil salud del paciente
                    $("#div_videoconsulta_rechazadas .change_miembro").click(function () {

                        window.sessionStorage.setItem("mostrar_inputs", "1");

                        var id = $(this).data("id");
                        if (parseInt(id) > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'panel-medico/change_member.do',
                                    "id=" + id,
                                    function (data) {
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/tablero.html";
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                    });


                    $('#div_videoconsulta_rechazadas .slider-for').slick({
                        slidesToShow: 1,
                        slidesToScroll: 1,
                        arrows: true,
                        centerMode: false,
                        fade: true,
                        asNavFor: '#div_videoconsulta_rechazadas .slider-nav-carrousel',
                        draggable: true,
                        adaptiveHeight: true
                    });
                    $('#div_videoconsulta_rechazadas .slider-nav-carrousel').slick({
                        slidesToShow: 3,
                        slidesToScroll: 1,
                        asNavFor: '#div_videoconsulta_rechazadas .slider-for',
                        dots: false,
                        centerMode: false,
                        focusOnSelect: true,
                        draggable: true
                    });

                    //            $('.ui-accordion').bind('accordionchange', function(event, ui) {
                    //                ui.newHeader // jQuery object, activated header
                    //                ui.oldHeader // jQuery object, previous header
                    //                ui.newContent // jQuery object, activated content
                    //                ui.oldContent // jQuery object, previous content
                    //                console.log('s');
                    //            });
                });


            </script>

        {/literal}

    {else}
        <div class="cs-nc-section-holder">
            <section class="container cs-nc-p2">
                <div class="row">
                    <div class="ce-ca-toobar">
                        <a href="{$url}panel-medico/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-times"></i></figure>

                        </div>
                        <span>{"DECLINADAS"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="icon-doctorplus-chat-comment"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Declinadas"|x_translate}</p>
                </div>
            </section>
        </div>
    {/if}


</div>