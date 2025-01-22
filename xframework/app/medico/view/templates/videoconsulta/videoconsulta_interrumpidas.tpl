<div id="div_videoconsulta_interrumpidas" class="relative">
    <input type="hidden" id='cant_consulta_interrumpidas' value="{$cantidad_consulta.pendientes_finalizacon}"/>

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



    {if $listado_videoconsultas_interrumpidas.rows && $listado_videoconsultas_interrumpidas.rows|@count > 0}


        <div class="okm-container">
            <div class="vc-interrumpidas-header">	

                <i id="icon_alert_interrumpidas" class="icon-doctorplus-alert-round"></i>

                <h1>{"Video Consultas pendientes de finalización"|x_translate}</h1>
                <a href="javascript:;" id="vc-interrumpidas-card-trg">{"Ayuda para resolver conflictos de Video Consultas pendientes de finalización"|x_translate}</a>
            </div>

            <div class="vc-interrumpidas-ayuda-box">
                <div class="okm-row mvc-interrumpidas-row">
                    <div class="mvc-interrumpidas-col">
                        <div class="mvc-grid-item-13 bg-type-4 vc-interrumpidas-ayuda-item">
                            <a href="#" class="mvc-guia-holder-trg">{"Cerrar consulta y escribir conclusiones"|x_translate}</a>
                            <div class="mvc-guia-holder">
                                <figure class="mvc-item-figure">
                                    <i class="icon-doctorplus-ficha-check"></i>
                                </figure>
                                <h4 class="mvc-grid-title-3">
                                    {"Cerrar consulta y escribir conclusiones"|x_translate}
                                </h4>
                                <p class="mvc-grid-p white">
                                    {"Si ud. está en condiciones de brindarle un diagnóstico o consejo médico a su paciente cierre y finalice la Video Consulta."|x_translate}
                                </p>

                            </div>
                        </div>
                    </div>
                    <div class="mvc-interrumpidas-col">
                        <div class="mvc-grid-item-14 bg-type-7 vc-interrumpidas-ayuda-item">
                            <a href="#" class="mvc-guia-holder-trg">{"Llamar al paciente"|x_translate}</a>
                            <div class="mvc-guia-holder">
                                <figure class="mvc-item-figure">
                                    <i class="icon-doctorplus-cam-rss"></i>
                                </figure>
                                <h4 class="mvc-grid-title-3">
                                    {"Llamar al paciente"|x_translate}
                                </h4>
                                <p class="mvc-grid-p white">
                                    {"Espere unos minutos e intente ponerse en contacto nuevamente con el paciente."|x_translate}
                                    {"DoctorPlus le enviará una notificación al paciente por mail y por SMS para que ingrese nuevamente al Consultorio Virtual."|x_translate}
                                </p>

                            </div>
                        </div>
                    </div>
                    <div class="mvc-interrumpidas-col">
                        <div class="mvc-grid-item-15 bg-type-5 vc-interrumpidas-ayuda-item">
                            <a href="#" class="mvc-guia-holder-trg">{"Reembolsar importe de la consulta"|x_translate}</a>
                            <div class="mvc-guia-holder">
                                <figure class="mvc-item-figure">
                                    <i class="icon-doctorplus-refund"></i>
                                </figure>
                                <h4 class="mvc-grid-title-3">
                                    {"Reembolsar importe de la consulta"|x_translate}
                                </h4>
                                <p class="mvc-grid-p white">
                                    {"Si su inconveniente técnico no pudo ser solucionado y ud. no pudo terminar de atender al paciente."|x_translate} 
                                    {"Le damos la opción para que le reembolse el dinero abonado por dicha consulta."|x_translate}
                                </p>

                            </div>
                        </div>
                    </div>
                </div>



            </div>


            <p class="vc-interrumpidas-aviso-importante">
                <strong>{"Aviso importante:"|x_translate}</strong><br>
                {"Si ud. no realiza ninguna de las siguientes acciones dentro de las [[{$VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION}]] hs. posteriores a la interrupcción de la transmisión, la Video Consulta quedará anulada y el dinero abonado por la misma será reembolsado al paciente."|x_translate}
            </p>

        </div>


        <div class="okm-container">
            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                    {foreach from=$listado_videoconsultas_interrumpidas.rows key=key item=videoconsulta_interrumpida}
                        <div class="panel {if $videoconsulta_interrumpida.tomada=="1" &&  $videoconsulta_interrumpida.tipo_consulta=="0"} ceprr-accordion {/if} panel-default">
                            <div class="panel-heading" role="tab">
                                <div class="ce-ca-toolbar cv-ca-toolbar highlight">                         
                                    <div class="row">
                                        <div class="colx3 vc-ca-colx3">
                                            <div class="cs-ca-colx3-inner">
                                                <div class="cs-ca-usr-avatar">
                                                    {if $videoconsulta_interrumpida.paciente.image}
                                                        <img src="{$videoconsulta_interrumpida.paciente.image.list}" alt="user"/>
                                                    {else}
                                                        {if $videoconsulta_interrumpida.paciente.animal!=1}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                        {/if}
                                                    {/if}
                                                    <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_interrumpida.paciente.idpaciente}">
                                                        <figure>
                                                            <i class="icon-doctorplus-pharmaceutics"></i>
                                                        </figure>
                                                    </a>
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    <span>{"Paciente"|x_translate}</span>
                                                    <h2>{$videoconsulta_interrumpida.paciente.nombre} {$videoconsulta_interrumpida.paciente.apellido}</h2>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="vc-colx6">

                                            <div class="vc-interrumpidas-botonera">
                                                <ul class="okm-row">
                                                    <li>
                                                        <a href="javascript:;"  data-id="{$videoconsulta_interrumpida.idvideoconsulta}" class="cerrar-consulta-rtg btn_finalizar_videoconsulta">
                                                            <figure><i class="icon-doctorplus-ficha-check"></i></figure>
                                                            <div>{"Cerrar consulta"|x_translate}<br>
                                                                <span>{"y escribir conclusiones"|x_translate}</span></div>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="javascript:;"  data-id="{$videoconsulta_interrumpida.idvideoconsulta}" class="llamar-paciente-rtg btn_aceptar_videoconsulta">
                                                            <figure><i class="icon-doctorplus-cam-rss"></i></figure>
                                                            <div>{"Llamar al paciente"|x_translate}</div>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="javascript:;"  data-id="{$videoconsulta_interrumpida.idvideoconsulta}" class="reembolsar-importe-rtg">
                                                            <figure><i class="icon-doctorplus-refund"></i></figure>
                                                            <div>{"Reembolsar importe"|x_translate}<br>
                                                                <span>{"de la consulta"|x_translate}</span></div>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                        </div>

                                    </div>
                                    <div class="row ce-ca-toolbar-row pce-header-low-row collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_interrumpida.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_interrumpida.idvideoconsulta}">
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">Nº {$videoconsulta_interrumpida.numeroVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-numero-consulta-holder">
                                                <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                                <span class="cs-ca-numero-consulta">{$videoconsulta_interrumpida.motivoVideoConsulta}</span>
                                            </div>
                                        </div>
                                        <div class="pce-colx3">
                                            <div class="cs-ca-date-tools">
                                                <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                                <span class="cs-ca-fecha">{$videoconsulta_interrumpida.fecha_inicio_format}</span>
                                                <div class="cs-ca-date-tools-holder">
                                                    <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collapse-{$videoconsulta_interrumpida.idvideoconsulta}" data-id="{$videoconsulta_interrumpida.idvideoconsulta}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{$videoconsulta_interrumpida.idvideoconsulta}">
                                <div class="panel-body">
                                    <div class="cs-ca-chat-holder">


                                        {foreach from=$videoconsulta_interrumpida.mensajes item=mensaje}

                                            {if $mensaje.emisor == "dp"}
                                                <div class="row chat-row">
                                                    <div class="chat-line-holder pce-paciente-chat">
                                                        <div class="chat-content">
                                                            <figure>
                                                                <div class="chat-content-date">{$mensaje.fecha_format} hs</div>
                                                                <div class="vc-llamada-perdida">
                                                                    <figure>
                                                                        <span></span>
                                                                        <i class="icon-doctorplus-cam-rss"></i>
                                                                    </figure>
                                                                    <span>{"Llamada perdida"|x_translate}</span>
                                                                </div>                                                             
                                                                <span class="chat-content-arrow"></span>
                                                            </figure>                                                       
                                                        </div>
                                                    </div>
                                                </div>
                                            {else}
                                                {if $mensaje.emisor == "p"}
                                                    <div class="row chat-row">
                                                        <div class="chat-line-holder pce-dr-chat">
                                                            <div class="chat-image-avatar-xn">
                                                                {if $videoconsulta_interrumpida.paciente_titular}
                                                                    <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                        {if $videoconsulta_interrumpida.paciente_titular.image.perfil != ""}
                                                                            <img src="{$videoconsulta_interrumpida.paciente_titular.image.perfil}" alt="user"/>
                                                                        {else}
                                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                        {/if}
                                                                    </div>
                                                                {/if}
                                                                <div class="chat-image-avatar-xn-row">
                                                                    {if $videoconsulta_interrumpida.paciente.image.perfil != ""}
                                                                        <img src="{$videoconsulta_interrumpida.paciente.image.perfil}" alt="user"/>
                                                                    {else}
                                                                        {if $videoconsulta_interrumpida.paciente.animal != 1}
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
                                                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=videoconsulta&submodulo=mensajes_imagenes_slider&id={$mensaje.idmensajeVideoConsulta}" data-target="#ver-archivo">
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
                                                            <div class="chat-content">
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
                                            {/if}

                                        {/foreach}



                                    </div>


                                    <div  id="row_actions_panels_{$videoconsulta_interrumpida.idvideoconsulta}" class="row">

                                        <div class="vc-registro-lista-disclaimer">

                                            <p class="vc-registro-lista-txt-1">{"¡Hemos notificado al paciente!"|x_translate}</p>

                                            <p class="vc-registro-lista-txt-2"><strong>{"Ingrese a la Sala o tome la consulta desde sus registros -En lista-"|x_translate}</strong></p>

                                            <div class="vc-registro-lista-msg-box">
                                                <h4>{"IMPORTANTE"|x_translate}</h4>
                                                <p class="vc-registro-lista-msg-box-txt-1">{"Recuerde que los pacientes valoran positivamente que ud. los atienda a la hora acordada."|x_translate}</p>
                                                <p class="vc-registro-lista-msg-box-txt-2">{"¡Genere un vínculo perdurable con ellos! Cuide estos detalles."|x_translate}</p>
                                            </div>
                                            <div class="vc-registro-lista-action-box">
                                                <a href="{$url}panel-medico/videoconsulta/sala/"  class="btn-default btn_sala">{"Ingresar al Consultorio Virtual"|x_translate}</a>
                                            </div>
                                        </div>
                                    </div>





                                </div>
                            </div>
                        </div>
                    {/foreach}

                </div>

            </div>
        </div>




        <!--Modal-->
        <div id="vc-modal-refund" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <figure class="modal-icon"><i class="icon-doctorplus-refund"></i></figure>
                        <h4 class="modal-title">{"Cancelar Video Consulta"|x_translate}</h4>
                        <p class="modal-title-disclaimer">{"Se reembolsará al paciente el importe de la consulta"|x_translate}</p>
                    </div>
                    <div class="modal-body">
                        <div class="modal-action-row">
                            <a href="javascript:;" class="btn-alert" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                            <a href="javascript:;" data-id="" class="btn-default btn_devolver_dinero"><i class="icon-doctorplus-check-thin"></i>{"aceptar"|x_translate}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        {literal}
            <script>
                $(document).ready(function (e) {

                    /*$(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/
                    renderUI2("div_videoconsulta_interrumpidas");

                    //redireccion al perfil salud del paciente
                    $("#div_videoconsulta_interrumpidas .change_miembro").click(function () {

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

                    if ($('.vc-interrumpidas-ayuda-box').length > 0) {
                        $('#vc-interrumpidas-card-trg').on('click', function (e) {
                            e.preventDefault();
                            $('.vc-interrumpidas-ayuda-box').slideToggle();
                        });
                    }


                    //accion de aceptar la Video Consulta e informar al paciente que se habilita la sala

                    $('.btn_aceptar_videoconsulta').click(function (e) {
                        var idvideoconsulta = parseInt($(this).data("id"));


                        if (idvideoconsulta > 0) {


                            jConfirm({
                                title: x_translate("Aceptar consulta"),
                                text: x_translate("Desea aceptar la Video Consulta en este momento?"),
                                confirm: function () {
                                    $("#div_videoconsulta_interrumpidas").spin("large");
                                    x_doAjaxCall(
                                            'POST',
                                            BASE_PATH + 'aceptar_videoconsulta.do',
                                            "idvideoconsulta=" + idvideoconsulta + "&opcion=1",
                                            function (data) {
                                                $("#div_videoconsulta_interrumpidas").spin(false);

                                                if (data.result) {
                                                    //mostramos desplegamos la ventana del mensaje 
                                                    if (!$("#collapse-" + idvideoconsulta).is(":visible")) {
                                                        $("#collapse-" + idvideoconsulta).siblings().find(".cs-ca-date-tools-holder a").click();//click en el +
                                                    }

                                                    $("#row_actions_panels_" + idvideoconsulta + " .vc-registro-lista-disclaimer").slideDown();
                                                    scrollToEl($("#row_actions_panels_" + idvideoconsulta + " .vc-registro-lista-disclaimer .btn_sala"));

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
                        } else {
                            return false;
                        }

                    });


                    //boton para finalizar la Video Consulta y escribir la consulta medica
                    $(".btn_finalizar_videoconsulta").click(function () {
                        var id = parseInt($(this).data("id"));

                        if (id > 0) {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'terminar_videoconsulta.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {
                                        if (data.result) {
                                            var idpaciente = data.idpaciente;
                                            if (parseInt(id) > 0) {
                                                x_doAjaxCall(
                                                        'POST',
                                                        BASE_PATH + 'panel-medico/change_member.do',
                                                        "id=" + idpaciente,
                                                        function (data) {

                                                            if (data.result) {
                                                                window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/mis-registros-consultas-medicas/consultanueva-videoconsulta-" + id + ".html";
                                                            } else {
                                                                $("body").spin(false);
                                                                x_alert(data.msg);
                                                            }

                                                        }
                                                );
                                            }
                                        } else {
                                            $("body").spin(false);
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                    });
                    //desplegamos el modal para devolver el dinero
                    $('.reembolsar-importe-rtg').on('click', function (e) {

                        var id = $(this).data("id");
                        e.preventDefault();
                        $(".btn_devolver_dinero").data("id", id);
                        $('#vc-modal-refund').modal(['show']);
                    });
                    //boton para devolver el dinero de la Video Consulta y pasarla a vencida
                    $(".btn_devolver_dinero").click(function () {
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                             $("body").spin();
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'devolucion_dinero_videoconsulta.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {
                                        $("body").spin(false);
                                        $('#vc-modal-refund').modal('hide');
                                        if (data.result) {
                                            x_alert(data.msg, recargar);
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


    {/if}

</div>
