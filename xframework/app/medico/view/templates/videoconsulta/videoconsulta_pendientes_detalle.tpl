<div id="div_videoconsulta_pendientes" class="relative cs-nc-section-holder">

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

    {include file="videoconsulta/videoconsulta_settings.tpl"}

    <div class="container">
        <ol class="breadcrum">
            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
            <li><a href="{$url}panel-medico/videoconsulta/pendientes.html">{"Recibidas"|x_translate}</a></li>
            {if $videoconsulta_pendiente}<li class="active">Nº {$videoconsulta_pendiente.numeroVideoConsulta}</li>{/if}
        </ol>
    </div>
    {if $videoconsulta_pendiente}


        <section class="container cs-nc-p2">

            <div class="row">
                <div class="ce-ca-toobar">
                    <a href="{$url}panel-medico/videoconsulta/" ><i class="icon-doctorplus-left-arrow"></i></a>
                    <div class="ce-ca-consultas-abiertas">
                        <figure><i class="fas fa-user-clock"></i></figure>
                            {if $cantidad_consulta.pendientes>0}
                            <span>{$cantidad_consulta.pendientes}</span>
                        {/if}
                    </div>
                    <span>{"RECIBIDAS"|x_translate}</span>
                </div>
            </div>


            <div class="cs-ca-consultas-holder">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">


                    <div class="panel {if $videoconsulta_pendiente.tomada=="1" &&  $videoconsulta_pendiente.tipo_consulta=="0"} ceprr-accordion {/if} panel-default">
                        <div class="panel-heading" role="tab">
                            <div class="ce-ca-toolbar cv-ca-toolbar">                         
                                <div class="row">
                                    <div class="colx3">
                                        <div class="cs-ca-colx3-inner">
                                            <div class="cs-ca-usr-avatar">
                                                {if $videoconsulta_pendiente.paciente.image}
                                                    <img src="{$videoconsulta_pendiente.paciente.image.list}" alt="user"/>
                                                {else}
                                                    {if $videoconsulta_pendiente.paciente.animal!=1}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-animal.jpg" alt="user"/>
                                                    {/if}
                                                {/if}
                                                <a href="javascript:;"  class="change_miembro" data-id="{$videoconsulta_pendiente.paciente.idpaciente}">
                                                    <figure>
                                                        <i class="icon-doctorplus-pharmaceutics"></i>
                                                    </figure>
                                                </a>
                                            </div>
                                            <div class="cs-ca-usr-data-holder">
                                                <span>{"Paciente"|x_translate}</span>
                                                <h2>{$videoconsulta_pendiente.paciente.nombre} {$videoconsulta_pendiente.paciente.apellido}</h2>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="colx3">
                                        <div class="cs-ca-colx3-inner">
                                            {if $videoconsulta_pendiente.paciente_titular}

                                                <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
                                                    {if $videoconsulta_pendiente.paciente_titular.image}
                                                        <img src="{$videoconsulta_pendiente.paciente_titular.image.perfil}" alt="user"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                    {/if}
                                                </div>
                                                <div class="cs-ca-usr-data-holder">
                                                    {if $videoconsulta_pendiente.paciente_titular.relacion != ""}
                                                        <span>{$videoconsulta_pendiente.paciente_titular.relacion} {"del paciente"|x_translate}</span>
                                                    {else}
                                                        <span>{"propietario"|x_translate}</span>
                                                    {/if}
                                                    <h2>{$videoconsulta_pendiente.paciente_titular.nombre} {$videoconsulta_pendiente.paciente_titular.apellido}</h2>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>

                                    <div class="cs-ca-tiempo-respuesta-holder">
                                        <div class="cs-ca-tiempo-respuesta-inner">
                                            <span id="cs-ca-tiempo-respuesta-label-{$videoconsulta_pendiente.idvideoconsulta}" class="cs-ca-tiempo-respuesta-label">{"Tiempo de respuesta"|x_translate}</span>
                                            <div class="cs-ca-tiempo-respuesta">
                                                {if $videoconsulta_pendiente.segundos_diferencia > 0}
                                                    <span class="cs-ca-clock-icon">
                                                        <i class="icon-doctorplus-clock"></i>
                                                    </span>
                                                    <span data-id="{$videoconsulta_pendiente.idvideoconsulta}" data-startsec="{$videoconsulta_pendiente.segundos_diferencia}" {if $videoconsulta_pendiente.tipo_consulta=="0"} data-fecha-vencimiento="{$videoconsulta_pendiente.fecha_vencimiento_toma}" {else} data-fecha-vencimiento="{$videoconsulta_pendiente.fecha_vencimiento}"{/if}  class="cs-ca-tiempo-respuesta-num timer-1" ></span>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <div class="row ce-ca-toolbar-row pce-header-low-row " role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-{$videoconsulta_pendiente.idvideoconsulta}" aria-expanded="true" aria-controls="collapse-{$videoconsulta_pendiente.idvideoconsulta}">
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-label">{"Video Consulta"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">Nº {$videoconsulta_pendiente.numeroVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-numero-consulta-holder">
                                            <span class="cs-ca-numero-consulta-motivo-label">{"Motivo:"|x_translate}</span>
                                            <span class="cs-ca-numero-consulta">{$videoconsulta_pendiente.motivoVideoConsulta}</span>
                                        </div>
                                    </div>
                                    <div class="pce-colx3">
                                        <div class="cs-ca-date-tools">
                                            <span class="cs-ca-numero-consulta-date-label">{"Iniciada"|x_translate}</span>
                                            <span class="cs-ca-fecha">{$videoconsulta_pendiente.fecha_inicio_format}</span>
                                            <div class="cs-ca-date-tools-holder">
                                                <a href="#"><i class="icon-doctorplus-minus"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="collapse-{$videoconsulta_pendiente.idvideoconsulta}" data-id="{$videoconsulta_pendiente.idvideoconsulta}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-{$videoconsulta_pendiente.idvideoconsulta}">
                            <div class="panel-body">
                                <div class="cs-ca-chat-holder">


                                    {foreach from=$videoconsulta_pendiente.mensajes item=mensaje}


                                        {if $mensaje.emisor == "p"}
                                            <div class="row chat-row">
                                                <div class="chat-line-holder pce-dr-chat">
                                                    <div class="chat-image-avatar-xn">
                                                        {if $videoconsulta_pendiente.paciente_titular}
                                                            <div class="chat-image-avatar-xn-row chat-image-avatar-xn-row-sm">
                                                                {if $videoconsulta_pendiente.paciente_titular.image.perfil != ""}
                                                                    <img src="{$videoconsulta_pendiente.paciente_titular.image.perfil}" alt="user"/>
                                                                {else}
                                                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user"/>
                                                                {/if}
                                                            </div>
                                                        {/if}
                                                        <div class="chat-image-avatar-xn-row">
                                                            {if $videoconsulta_pendiente.paciente.image.perfil != ""}
                                                                <img src="{$videoconsulta_pendiente.paciente.image.perfil}" alt="user"/>
                                                            {else}
                                                                {if $videoconsulta_pendiente.paciente.animal != 1}
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
                                        {/if}

                                    {/foreach}

                                    <div class="row chat-row" id="div_row_time_{$videoconsulta_pendiente.idvideoconsulta}" {if $videoconsulta_pendiente.segundos_diferencia > 0} style="display: none" {/if}>
                                        <div class="chat-line-holder chat-line-answer">
                                            <div class="chat-content">
                                                <figure>
                                                    <br>
                                                    <p class="chat-content-rechazada">
                                                        <i class="fa fa-clock-o"></i>
                                                        {"Se excedió el tiempo para responder la consulta."|x_translate}
                                                    </p>
                                                    <span class="chat-content-arrow"></span>
                                                </figure>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                {if $videoconsulta_pendiente.segundos_diferencia > 0}

                                    <div  id="row_actions_panels_{$videoconsulta_pendiente.idvideoconsulta}" class="row">
                                        <div class="audio-actions-panel">

                                            <div class="audio-reccord-holder-chat">

                                            </div>
                                            <div class="chat-motivo-rechazo-holder">
                                                <form name="rechazar_mensaje_{$videoconsulta_pendiente.idvideoconsulta}" id="rechazar_mensaje_{$videoconsulta_pendiente.idvideoconsulta}" action="{$url}rechazar_videoconsulta_m.do" method="POST" role="form" onsubmit="return false">
                                                    <input type="hidden" name="videoconsulta_idvideoconsulta" value="{$videoconsulta_pendiente.idvideoconsulta}"/>
                                                    <div class="chat-msg-holder">
                                                        <select class="form-control select select-primary select-block mbl" name="motivoRechazo_idmotivoRechazo" id="motivoRechazo_idmotivoRechazo_{$videoconsulta_pendiente.idvideoconsulta}">
                                                            <option value="">{"Indicar motivo"|x_translate}</option>
                                                            {html_options options=$combo_motivo_rechazo}
                                                        </select>
                                                        <div class="chat-msg-input-holder mensaje-paciente">
                                                            <textarea data-autoresize rows="4" name="mensaje" placeholder='{"Comentarios para el paciente (opcional)"|x_translate}' data-id="{$videoconsulta_pendiente.idvideoconsulta}"></textarea>
                                                        </div>
                                                        <div class="text-center  btn-send-mensaje-holder">
                                                            <button  class="btn_send_motivo btn btn-primary" data-id="{$videoconsulta_pendiente.idvideoconsulta}" style="border:solid 1px; border-radius:5px">{"Enviar"|x_translate}<i class="icon-doctorplus-right-arrow"></i></button>

                                                        </div>       

                                                    </div>
                                                </form>
                                                <hr>
                                            </div>
                                            <div class="audio-action-holder btn-slide-holder">
                                                {if $videoconsulta_pendiente.tipo_consulta!="0"} 
                                                    <a href="javascript:;" data-send="0" data-id="{$videoconsulta_pendiente.idvideoconsulta}" class="ce-ca-mdl-rechazo-consulta" style="background: #ff6f6f;">
                                                        <i class="fas fa-user-times"></i>
                                                        {"Declinar consulta"|x_translate}
                                                    </a>
                                                {/if} 
                                                <div class="cv-consulta-select">
                                                    <select name="price"   class="form-control select select-primary  cv-consulta-select-trg">
                                                        <option value="">{"Aceptar consulta"|x_translate}</option>
                                                        <option data-id="{$videoconsulta_pendiente.idvideoconsulta}" value="0">{"Lo atenderé ya mismo"|x_translate}</option>
                                                        {foreach from=$aceptar_consulta_rangos item=rango}
                                                            <option  data-id="{$videoconsulta_pendiente.idvideoconsulta}" value="{$rango.format}" data-quarters='{$rango.quarters|@json_encode nofilter}' >
                                                                {$rango.format}
                                                            </option>
                                                        {/foreach}

                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="vc-registro-lista-disclaimer">

                                            <p class="vc-registro-lista-txt-1">{"¡Hemos notificado al paciente!"|x_translate}</p>
                                            <p class="vc-registro-lista-txt-2"><strong>{"A la hora acordada ingrese al Consultorio Virtual o tome la consulta desde sus registros en -Sala de espera-"|x_translate}</strong></p>
                                            <div class="vc-registro-lista-action-box">
                                                <a href="{$url}panel-medico/videoconsulta/" class="btn btn-default btn-inverse">{"volver"|x_translate}</a>
                                                <a href="{$url}panel-medico/videoconsulta/sala/"  class="btn btn-default btn_sala" style="display:none;">{"Ingresar al Consultorio Virtual"|x_translate}</a>
                                                <a href="{$url}panel-medico/videoconsulta/sala-espera.html" class="btn btn-default btn_espera" style="display:none;">{"Ingresar a Sala de espera"|x_translate}</a>

                                            </div>
                                            <div class="vc-registro-lista-msg-box">
                                                <h4>{"IMPORTANTE"|x_translate}</h4>
                                                <p class="vc-registro-lista-msg-box-txt-1">{"Recuerde que los pacientes valoran positivamente que ud. los atienda a la hora acordada."|x_translate}</p>
                                                <p class="vc-registro-lista-msg-box-txt-2">{"¡Genere un vínculo perdurable con ellos! Cuide estos detalles."|x_translate}</p>
                                            </div>

                                        </div>
                                    </div>



                                {/if}


                            </div>
                        </div>
                    </div>


                </div>

            </div>




        </section>
        <!-- Modal Horarios atender Video Consulta -->
        <div id="modal-seleccionar-horario-consulta" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" data-load="no" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button"   class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">{"Seleccione el horario de inicio de la Video Consulta"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            {"La solicitud se coloca en la sala de espera virtual y se notifica al paciente"|x_translate}
                        </p>
                        <div class="modal-perfil-completo-action-holder">
                            <button class="btn select-inicio-sala" data-slot="0" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="15" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="30" data-time=""></button>
                            <button class="btn select-inicio-sala" data-slot="45" data-time=""></button>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        {literal}
            <script>
                $(document).ready(function (e) {
                    /*     $(".cs-ca-chat-holder").mCustomScrollbar({
                     theme: "dark-3"
                     });*/

                    //redireccion al perfil salud del paciente
                    $("#div_videoconsulta_pendientes .change_miembro").click(function () {

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



                    $('#div_videoconsulta_pendientes .slider-for').slick({
                        slidesToShow: 1,
                        slidesToScroll: 1,
                        arrows: true,
                        centerMode: false,
                        fade: true,
                        asNavFor: '#div_videoconsulta_pendientes .slider-nav-carrousel',
                        draggable: true,
                        adaptiveHeight: true
                    });
                    $('#div_videoconsulta_pendientes .slider-nav-carrousel').slick({
                        slidesToShow: 3,
                        slidesToScroll: 1,
                        asNavFor: '#div_videoconsulta_pendientes .slider-for',
                        dots: false,
                        centerMode: false,
                        focusOnSelect: true,
                        draggable: true
                    });


                    //accion de aceptar la Video Consulta e informar al paciente que se habilita la sala

                    $('.cv-consulta-select-trg').change(function (e) {
                        var idvideoconsulta = parseInt($(this).find("option:selected").data("id"));
                        var inicio = $(this).find("option:selected").val();
                        var inicio_txt = $(this).find("option:selected").text();

                        $element = $(this);
                        $lista_disclaimer = $(".vc-registro-lista-disclaimer");

                        if (idvideoconsulta > 0 && inicio != "") {
                            //resetamos los botones de horarios
                            $(".select-inicio-sala").attr("disabled", false);
                            $(".select-inicio-sala").removeClass("disabled");
                            $(".select-inicio-sala").data("idvideoconsulta", idvideoconsulta);
                            //si no se responde inmediatamentes ->mostramos modal con horarios
                            if (inicio != 0) {
                                var quarters = $(this).find("option:selected").data("quarters");
                                //seteamos los textos de horarios en los botones
                                $(".select-inicio-sala[data-slot=0]").text(quarters["label-0"]);
                                $(".select-inicio-sala[data-slot=15]").text(quarters["label-15"]);
                                $(".select-inicio-sala[data-slot=30]").text(quarters["label-30"]);
                                $(".select-inicio-sala[data-slot=45]").text(quarters["label-45"]);
                                //seteamos los valores de horario en los botones 
                                $(".select-inicio-sala[data-slot=0]").data("time", quarters["time-0"]);
                                $(".select-inicio-sala[data-slot=15]").data("time", quarters["time-15"]);
                                $(".select-inicio-sala[data-slot=30]").data("time", quarters["time-30"]);
                                $(".select-inicio-sala[data-slot=45]").data("time", quarters["time-45"]);

                                //deshabilitamos los horarios no disponibles
                                if (!quarters["min-0"]) {
                                    $(".select-inicio-sala[data-slot=0]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=0]").addClass("disabled");
                                }
                                if (!quarters["min-15"]) {
                                    $(".select-inicio-sala[data-slot=15]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=15]").addClass("disabled");
                                }
                                if (!quarters["min-30"]) {
                                    $(".select-inicio-sala[data-slot=30]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=30]").addClass("disabled");
                                }
                                if (!quarters["min-45"]) {
                                    $(".select-inicio-sala[data-slot=45]").attr("disabled", true);
                                    $(".select-inicio-sala[data-slot=45]").addClass("disabled");
                                }




                                //mostramos el modal de horarios
                                $("#modal-seleccionar-horario-consulta").modal("show");

                            } else {

                                jConfirm({
                                    title: x_translate("Aceptar consulta"),
                                    text: x_translate('Desea aceptar la Video Consulta en este momento?'),
                                    confirm: function () {
                                        $("#div_videoconsulta_pendientes").spin("large");
                                        x_doAjaxCall(
                                                'POST',
                                                BASE_PATH + 'aceptar_videoconsulta.do',
                                                "idvideoconsulta=" + idvideoconsulta + "&inicio=" + inicio,
                                                function (data) {
                                                    $("#div_videoconsulta_pendientes").spin(false);

                                                    if (data.result) {
                                                        $element.parent().parent().slideUp();
                                                        $lista_disclaimer.find("a.btn_sala").show();
                                                        $lista_disclaimer.find("a.btn_espera").hide();
                                                        $lista_disclaimer.slideDown();
                                                        scrollToEl($lista_disclaimer);

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
                            }
                        } else {
                            return false;
                        }

                    });

                    /*Al cerrar modal de horario limpiamos la seleccion*/
                    $('#modal-seleccionar-horario-consulta').on('hidden.bs.modal', function () {
                        $(".cv-consulta-select-trg").val(null).trigger('change');

                    });
                    /*Al mostrar modal ocultamos horarios pasados*/
                    $('#modal-seleccionar-horario-consulta').on('show.bs.modal', function () {
                        $("#modal-seleccionar-horario-consulta .select-inicio-sala").each(function (idx, elem) {
                            //si ya pasó, añadimos disabled
                            if (new Date() > new Date($(elem).data("time"))) {
                                $(elem).addClass("disabled");
                                $(elem).prop("disabled", true);
                            }
                        });

                    });
                    //accion de aceptar la Video Consulta en un horario en particular
                    $(".select-inicio-sala").click(function () {
                        var idvideoconsulta = parseInt($(this).data("idvideoconsulta"));
                        var $lista_disclaimer = $(".vc-registro-lista-disclaimer");
                        var inicio = $(this).data("time");
                        var inicio_format = $(this).text();
                        jConfirm({
                            title: x_translate("Aceptar consulta"),
                            text: x_translate('Desea aceptar la Video Consulta a las') + "&nbsp;" + inicio_format + "hs?",
                            confirm: function () {
                                $("#modal-seleccionar-horario-consulta").modal("hide");
                                $("#div_videoconsulta_pendientes").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'aceptar_videoconsulta.do',
                                        "idvideoconsulta=" + idvideoconsulta + "&inicio=" + inicio,
                                        function (data) {
                                            $("#div_videoconsulta_pendientes").spin(false);

                                            if (data.result) {
                                                $element.parent().parent().slideUp();
                                                $lista_disclaimer.find("a.btn_sala").hide();
                                                $lista_disclaimer.find("a.btn_espera").show();
                                                $lista_disclaimer.slideDown();
                                                scrollToEl($lista_disclaimer);

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
                    });

                    //boton rechazar videoconsulta - seleccionar motivo
                    $(".btn_send_motivo").click(function () {
                        var id = parseInt($(this).data("id"));
                        if (id > 0) {
                            $(".chat-motivo-rechazo-holder form .chat-msg-holder .select2-choice").css("border-color", "#a9a6a6");
                            if ($("#motivoRechazo_idmotivoRechazo_" + id).val() != "") {
                                $('#div_videoconsulta_pendientes').spin("large");
                                x_sendForm(
                                        $('#rechazar_mensaje_' + id),
                                        true,
                                        function (data) {
                                            $('#div_videoconsulta_pendientes').spin(false);
                                            if (data.result) {
                                                x_alert(data.msg, function () {
                                                    recargar(BASE_PATH + "panel-medico/videoconsulta/pendientes.html");
                                                });
                                            } else {
                                                x_alert(data.msg);
                                            }
                                        }
                                );
                            } else {
                                $(".chat-motivo-rechazo-holder form .chat-msg-holder .select2-choice").css("border-color", "red");
                                x_alert(x_translate("Seleccione el motivo de rechazo de la consulta"));
                                return false;

                            }
                        }
                    });



                    //seteamos como leidas las consultas visualizadas
                    $('.panel-collapse').on('show.bs.collapse', function () {
                        $this = $(this);
                        var id = parseInt($this.data("id"));

                        //Enviar a leer todos los mensajes
                        if (id > 0) {
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_leida_videoconsulta_m.do',
                                    "idvideoconsulta=" + id,
                                    function (data) {

                                    });
                        }

                    });




                    //boton rechazar consulta - desplega combo box motivo
                    $('.ce-ca-mdl-rechazo-consulta').on('click', function (e) {
                        e.preventDefault();
                        var $this = $(this);
                        $this.parent().siblings('.audio-reccord-holder').hide();
                        //                $this.parent().siblings('.audio-reccord-holder').removeClass('show');
                        $this.parent().siblings('.chat-motivo-rechazo-holder').toggleClass('show');

                    });


                    // timer tiempo restante
                    $.each($('.timer-1'), function (idx, elem) {

                        if ($(elem).data("fecha-vencimiento") !== "") {
                            var id = $(this).data("id");

                            var [date_part, time_part] = $(elem).data("fecha-vencimiento").split(" ");
                            var date = date_part.split("-");
                            var time = time_part.split(":");
                            var countDownDate = new Date(date[0], date[1] - 1, date[2], time[0], time[1], time[2]).getTime();

                            // Actualizamos el contador cada segundo
                            var x = setInterval(function () {

                                //Calculo el tiempo actual
                                var now = new Date().getTime();

                                // calulamos el tiempo restante
                                var distance = countDownDate - now;

                                // Calculamos dias, horas, segundos 
                                var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                var seconds = Math.floor((distance % (1000 * 60)) / 1000);

                                if (hours < 10) {
                                    hours = "0" + hours;
                                }
                                if (minutes < 10) {
                                    minutes = "0" + minutes;
                                }
                                if (seconds < 10) {
                                    seconds = "0" + seconds;
                                }

                                // Actualizamos el tiempo restante en la consulta
                                $(elem).text(hours + "h " + minutes + "mn " + seconds + "s");

                                // cuando finaliza el tiempo ocultamos el timer
                                if (distance < 0) {
                                    clearInterval(x);
                                    $(elem).text(x_translate("Tiempo cumplido"), );
                                    $("#row_actions_panels_" + id).html("");
                                    $("#div_row_time_" + id).show();
                                }
                            }, 1000);
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
                        <a href="{$url}panel-medico/videoconsulta/"><i class="icon-doctorplus-left-arrow"></i></a>
                        <div class="ce-ca-consultas-abiertas">
                            <figure><i class="fas fa-user-clock"></i></figure>

                        </div>
                        <span>{"Recibidas"|x_translate}</span>
                    </div>
                </div>
                <div class="sin-registros">
                    <i class="fas fa-user-clock"></i>
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"Ud. no tiene Video Consultas Recibidas"|x_translate}</p>
                </div>
            </section>
        </div>

    {/if}

</div>
