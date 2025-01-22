{if $listado_consultorios.rows|@count > 0}
    {include file="busqueda/popover_ficha_medico.tpl"}
    <input type="hidden" id="ids_consultorio_resultado" value="{$id_consultorios}" />
    <input type="hidden" id="idprograma_categoria_seleccionado" value="{$idprograma_categoria_seleccionado}" />
    {*
    <section class="pbn-listado-top-section">
    <div class="okm-container">
    <div class="okm-row">
    <div class="pbn-top-info-col">
    <h4>{"Info del profesional y consultorio"|x_translate}</h4>
    </div>
    <div class="pbn-top-turno-col">
    <h4>{"Turnos disponibles del consultorio seleccionado"|x_translate}</h4>
    </div>
    </div>
    </div>

    </section>
    *}
    <section id="busqueda_resultado" class="pbn-listado-section">
        <div class="okm-container">
            {foreach from=$listado_consultorios.rows item=consultorio}

                <div class="okm-row medico-result-item" data-idmedico="{$consultorio.idmedico}" data-idconsultorio="{$consultorio.idconsultorio}">
                    <div id="consultorio-resultado-{$consultorio.idconsultorio}" class="pbn-col-profesional">

                        <div class="gnlist-profesional-holder">
                            <div class="okm-row gnlist-profesional-row">

                                <figure class="gnlist-usr-avatar">
                                    <a href="{$url}panel-paciente/profesionales/{$consultorio.idmedico}-{$consultorio.nombre|str2seo}-{$consultorio.apellido|str2seo}.html?from_busqueda=1">
                                        {if $consultorio.imagen.list != ""}
                                            <img src="{$consultorio.imagen.list}" alt="{$consultorio.titulo_profesional} {$consultorio.nombre} {$consultorio.apellido}" />
                                        {else}
                                            <img src="{$IMGS}extranet/noimage_perfil.png" alt="{$consultorio.titulo_profesional} {$consultorio.nombre} {$consultorio.apellido}" /> 
                                        {/if}
                                        <div class="ver-ficha-medica">{"Ficha médica"|x_translate}</div>
                                    </a>
                                </figure>
                                <div class="gnlist-usr-data-holder">
                                    <h3>
                                        <a href="{$url}panel-paciente/profesionales/{$consultorio.idmedico}-{$consultorio.nombre|str2seo}-{$consultorio.apellido|str2seo}.html?from_busqueda=1">{$consultorio.titulo_profesional} {$consultorio.nombre} {$consultorio.apellido}</a>
                                    </h3>
                                    <h4>{$consultorio.especialidad.0.especialidad}</h4>
                                    <div class="usr-data-content">
                                        {if $consultorio.iddireccion!=""}                      
                                            <p>                                               
                                                {if $consultorio.mostrar_direccion=="1"}
                                                    <a href="javascript:;" title='{"ver mapa"|x_translate}' class="pbn-map-trigger" data-idmedico="{$consultorio.idmedico}">
                                                        <span><i class="icon-doctorplus-map-check"></i></span>
                                                        {$consultorio.direccion|upper} {$consultorio.numero}, {$consultorio.localidad}
                                                    </a>
                                                {else}
                                                    {$consultorio.localidad}
                                                {/if} 
                                            </p>
                                        {/if}                                                                 
                                        {if $consultorio.sector!=""}
                                            <p><strong>{$consultorio.sector}</strong></p>
                                        {/if}
                                        {if $consultorio.medico_cabecera==1}
                                            <p style="color:#ff6f6f">
                                                <strong>{"Médico de cabecera"|x_translate}</strong>
                                            </p>
                                        {/if}

                                        <div class="gnlist-ratting-holder">
                                            <div class="resultados-list-left-ratting">

                                                {if $consultorio.is_profesional_frecuente == "1"}
                                                    <figure class="pbn-usr-like">
                                                        <i class="icon-doctorplus-user-add-like"></i>
                                                    </figure>
                                                    <p>
                                                        <span>{"es un profesional frecuente"|x_translate}</span>        
                                                    </p>
                                                {else}
                                                    <a class="ratting-like {if $consultorio.is_profesional_favorito=="1"} selected {/if} agregar_favoritos" data-id="{$consultorio.idmedico}" {if $consultorio.is_profesional_favorito=="1"} title='{"Eliminar"|x_translate}'{else} title='{"Agregar"|x_translate}'{/if} href="javascript:;">
                                                        <i class="icon-doctorplus-corazon"></i>
                                                    </a>
                                                    <p>
                                                        <span class="agregar-favorito" {if $consultorio.is_profesional_favorito=="1"}style="display:none"{/if} data-id="{$consultorio.idmedico}">{"agregar a mis favoritos"|x_translate}</span>            
                                                        <span class="eliminar-favorito" {if $consultorio.is_profesional_favorito!="1"}style="display:none"{/if} data-id="{$consultorio.idmedico}">{"es un profesional favorito"|x_translate}</span>         
                                                    </p>
                                                {/if}

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="okm-row proximo-turno-disponible-holder">
                                    <span>
                                        <small>
                                            <em>
                                                {if $consultorio.proximo_turno_vc!="NO_TURNO" && $consultorio.proximo_turno_vc!=""}
                                                    {"Próximo turno disponible"|x_translate}
                                                    {if $consultorio.proximo_turno_format!=""}
                                                        {if $consultorio.proximo_turno_format.hr!=""}
                                                            <strong>{$consultorio.proximo_turno_format.hr}
                                                                {"hr"|x_translate}&nbsp;
                                                                {$consultorio.proximo_turno_format.min}
                                                                {"mns"|x_translate}
                                                            </strong>

                                                        {else}
                                                            <strong>
                                                                {$consultorio.proximo_turno_format.min}
                                                                {"mns"|x_translate}
                                                            </strong>
                                                        {/if}
                                                    {else}
                                                        <strong>{$consultorio.proximo_turno_vc|date_format:"%d/%m"} - {$consultorio.proximo_turno_vc|date_format:"%H:%M"}{"hs"|x_translate}</strong>
                                                    {/if}
                                                {else}
                                                    {"Sin turno disponible"|x_translate}
                                                {/if}
                                            </em>
                                        </small>
                                    </span>
                                </div>
                                {if $consultorio.medico_referente==1 || $consultorio.medico_complementario==1}

                                    {if $consultorio.medico_referente==1}
                                        <div class="okm-row medico-destacado-tag-referente">
                                            <span>
                                                {"Médico referente"|x_translate}
                                            </span>
                                        </div>
                                    {else}
                                        <div class="okm-row medico-destacado-tag-complementario">
                                            <span>
                                                {"Médico complementario"|x_translate}
                                            </span>
                                        </div>
                                    {/if}

                                {/if}
                            </div>

                        </div>
                    </div>
                    <div class="col-xs-12 btn-planes-holder">
                        <a href="javascript:;" class="btn-oil-square btn-mostrar-planes btn-xs" data-id="{$consultorio.idmedico}"><span>{"Consultar"|x_translate}</span> <i class="fa fa-chevron-down"></i></a>
                        <a href="javascript:;" class="btn-oil-square btn-ocultar-planes btn-xs" data-id="{$consultorio.idmedico}" style="display:none;"><span>{"Volver"|x_translate}</span> <i class="fa fa-chevron-up"></i></a>
                    </div>
                    <div id="div_turnos_modulo_{$consultorio.idmedico}" class="turnos_modulo_col">
                        {include file="busqueda/busqueda_profesional_turnos_modulo.tpl"}
                    </div>
                </div>
            {/foreach}
        </div>
    </section>

    <div class="pbn-divider"></div>

    <div class="pbn-paginador">
        <div class="okm-container">
            {x_paginate_loadmodule_v2 id="$idpaginate" modulo="busqueda" submodulo="busqueda_profesional_resultado_modulo" container_id="modulo_listado_consultorios"}
        </div>
    </div>
    {*Modal no saldo*}
    {*<div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" id="modal_info_dinero_cuenta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
    <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title">{"No posees dinero suficiente en tu cuenta para realizar la Video Consulta al profesional seleccionado."|x_translate}</h4>
    </div>
    <div class="modal-body">
    <p>
    {"Debes cargar en tu cuenta para para poder realizarla o consultar un profesional de menor tarifa."|x_translate} {"Dinero faltante:"|x_translate}<span id="faltante_dinero"></span>
    </p>
    <div class="modal-perfil-completo-action-holder">
    <button id="btnCargarCredito">
    {"cargar crédito"|x_translate}
    </button>
    </div>
    </div>
    </div>
    </div>
    </div>*}

    {literal}
        <script>
            $(function () {
                $("#Main").spin(false);
                scrollToEl($("body"));
                //click boton en agenda sin turno  link para hacer vc/ce inmediata
                $("#busqueda_resultado").on("click", ".no-turno-select-profesional-frecuente-vc", function () {

                    console.log("sacar VC inmediata");
                    var id = $(this).data("id");
                    $(".select-profesional-frecuente-vc[data-id='" + id + "']").trigger("click");
                });
                $("#busqueda_resultado").on("click", ".no-turno-select-profesional-frecuente-ce", function () {
                    console.log("sacar CE inmediata");
                    var id = $(this).data("id");
                    $(".select-profesional-frecuente-ce[data-id='" + id + "']").trigger("click");
                });

                //verficamos si el turno sigue disponible al hacer click
                $("#modulo_listado_consultorios").on("click", "a.a_reservar_turno,a.a_reservar_turno_vc", function (e) {

                    e.preventDefault();
                    console.log("verificar_turno_disponible");
                    var url = $(this).attr("href");
                    var idturno = $(this).data("idturno");
                    var idprograma_categoria = $("#idprograma_categoria_seleccionado").val();
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "verificar_turno_disponible.do",
                            "idturno=" + idturno,
                            function (data) {
                                if (data.result) {
                                    window.location.href = url + "?idprograma_categoria=" + idprograma_categoria;
                                } else {
                                    x_alert(data.msg);
                                }
                            }


                    );
                });

                //medico ofrece consulta solo a sus pacientes
                $(".consultaexpress_solo_pacientes").on("click", function (e) {
                    e.preventDefault();
                    x_alert(x_translate("Este profesional solo ofrece servicios de Consulta Express a sus pacientes frecuentes"));
                });
                $(".videoconsulta_solo_pacientes").on("click", function (e) {
                    e.preventDefault();
                    x_alert(x_translate("Este profesional solo ofrece servicios de Video Consulta a sus pacientes frecuentes"));
                });

                //se despliega un modal con la diferencia de dinero faltante cuenta no posee saldo suficiente para la VC
                /*$("#modulo_listado_consultorios").on("click", "a.paciente_no_saldo", function () {
                 
                 if (parseFloat($(this).data("valor_video_llamada")) >= 0 && parseFloat($(this).data("saldo_paciente")) >= 0) {
                 var diferencia = parseFloat($(this).data("valor_video_llamada")) - parseFloat($(this).data("saldo_paciente"));
                 }
                 
                 $("#faltante_dinero").html("<strong>&euro;" + diferencia + "</strong>");
                 $("#btnCargarCredito").data("monto-compra", diferencia);
                 $("#btnCargarCredito").data("idturno", $(this).data("idturno"));
                 $("#modal_info_dinero_cuenta").modal("show");
                 });*/

                // Ajuste seba 18/06/2019
                /*$(".pnb-slide-col").on("click", ".paciente_no_saldo", function () {
                 var diferencia = "";
                 if (parseFloat($(this).data("valor_video_llamada")) >= 0 && parseFloat($(this).data("saldo_paciente")) >= 0) {
                 var diferencia = parseFloat($(this).data("valor_video_llamada")) - parseFloat($(this).data("saldo_paciente"));
                 }
                 $("#faltante_dinero").html("<strong>&euro;" + diferencia + "</strong>");
                 $("#btnCargarCredito").data("monto-compra", diferencia);
                 $("#btnCargarCredito").data("idturno", $(this).data("idturno"));
                 $("#modal_info_dinero_cuenta").modal("show");
                 });*/

                /* $("#btnCargarCredito").click(function () {
                 localStorage.setItem('payment_redirect', 'turno_vc:' + $(this).data("idturno"));
                 var monto_compra = $(this).data("monto-compra");
                 window.location.href = BASE_PATH + "panel-paciente/credito-proceso-compra/?compra=" + monto_compra;
                 });
                 */

                //botones para crear la consulta express asociada a un medico
                $(".a_consultaexpress").click(function () {
                    var idmedico = $(this).data('idmedico');
                    if (parseInt(idmedico) > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'set_medico_consultaexpress.do',
                                'medico_idmedico=' + idmedico + '&idprograma_categoria=' + $("#idprograma_categoria_seleccionado").val(),
                                function (data) {

                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                    } else {
                                        x_alert(data.msg);
                                    }

                                }

                        );
                    }


                });

                //botones para crear la consulta asociada a un medico
                $(".pbp-planes-item").click(function () {
                    //consulta express
                    var elem_ce = $(this).find(".select-profesional-frecuente-ce");
                    if (elem_ce.length > 0) {
                        var idmedico = elem_ce.data('id');

                        if (parseInt(idmedico) > 0) {
                            $("#modulo_listado_consultorios").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'set_medico_consultaexpress.do',
                                    'medico_idmedico=' + idmedico + '&idprograma_categoria=' + $("#idprograma_categoria_seleccionado").val(),
                                    function (data) {
                                        $("#modulo_listado_consultorios").spin(false);
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                        } else {

                                            x_alert(data.msg);
                                        }

                                    }

                            );
                        }
                    }
                    //videoconsulta
                    var elem_vc = $(this).find(".select-profesional-frecuente-vc");

                    if (elem_vc.length > 0) {
                        var idmedico = elem_vc.data('id');
                        if (parseInt(idmedico) > 0) {
                            $("#modulo_listado_consultorios").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'set_medico_videoconsulta.do',
                                    'medico_idmedico=' + idmedico + '&idprograma_categoria=' + $("#idprograma_categoria_seleccionado").val(),
                                    function (data) {
                                        $("#modulo_listado_consultorios").spin(false);
                                        if (data.result) {
                                            window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true";
                                        } else {

                                            x_alert(data.msg);
                                        }

                                    }

                            );
                        }
                    }


                });


                //desplegar listado tarifas
                $(".btn-mostrar-planes").click(function () {
                    var id = $(this).data("id");
                    //ocultamos los otros desplegados:
                    //$(".btn-ocultar-planes[data-id!=" + id + "]").trigger('click');
                    //mostramos el listado
                    $(this).hide();
                    $(".btn-ocultar-planes[data-id=" + id + "]").show();
                    $("#medico-data-row-" + id).slideDown();
                    $("#div_turnos_modulo_" + id).slideDown();
                    setTimeout(function () {
                        scrollToEl($(".medico-result-item[data-idmedico=" + id + "]"));
                    }, 200);

                });
                $(".btn-ocultar-planes").click(function () {
                    var id = $(this).data("id");
                    $(this).hide();
                    $(".btn-mostrar-planes[data-id=" + id + "]").show();
                    $("#medico-data-row-" + id).slideUp();
                    $("#div_turnos_modulo_" + id).slideUp();

                });

                $('.pbp-planes-btn').on('click', function (e) {
                    e.preventDefault();
                    $(this).closest('.gnlist-ratting-holder').prev('.pbp-planes-row').slideToggle();
                });

                //click sacar turno virtual- seleccionar agenda consultorio virtual
                $(".sacar-turno-vc").click(function () {
                    var idmedico = $(this).data("idmedico");

                    console.log("sacar-turno-vc");
                    //desplegamos el contendor con horarios            
                    $("#container-pbn-turnos-holder-" + idmedico).slideDown();
                    if ($("a.change_consultorio.virtual[data-idmedico=" + idmedico + "]").length > 0) {
                        $("a.change_consultorio.virtual[data-idmedico=" + idmedico + "]").trigger("click");
                        scrollToEl($("a.change_consultorio.virtual[data-idmedico=" + idmedico + "]"));
                    }

                });

                //click sacar turno presencial- seleccionar agenda consultorio presencial
                $(".sacar-turno-presencial").click(function () {
                    var idmedico = $(this).data("idmedico");
                    console.log("sacar-turno-presencial");

                    if ($("a.change_consultorio.presencial[data-idmedico=" + idmedico + "]").length > 0) {
                        //desplegamos el contendor con horarios            
                        $("#container-pbn-turnos-holder-" + idmedico).slideDown();
                        $("a.change_consultorio.presencial[data-idmedico=" + idmedico + "]").trigger("click");
                        scrollToEl($("a.change_consultorio.presencial[data-idmedico=" + idmedico + "]"));
                    } else {

                        $(this).data("title", x_translate("Pas d'agenda"));
                        $(this).tooltip("show");
                    }

                });


                $('.pbp-planes-item').on('click', function (e) {
                    e.preventDefault();

                    var rippleElement = '<span class="okm-ripple"></span>';
                    var parentOffset = $(this).offset();
                    var relX = e.pageX - parentOffset.left;
                    var relY = e.pageY - parentOffset.top;

                    var lnk = $(this).attr('href');

                    $(rippleElement).remove();

                    $(rippleElement).appendTo($(this));
                    var ripleIn = $(this).find('.okm-ripple');

                    ripleIn.css({
                        top: relY + "px",
                        left: relX + "px",
                        width: "1px",
                        height: "1px",
                        opacity: "0.5"
                    }).show();
                    ripleIn.velocity({
                        width: "+=400px",
                        height: "+=400px",
                        top: "-=200px",
                        left: "-=200px",
                        opacity: 0
                    },
                            {
                                duration: "slow",
                                queue: false,
                                easing: "easeOutSine",
                                complete: function (elements) {
                                    $(elements).remove();
                                    window.location.href = lnk;
                                }
                            }
                    );

                });

            });
        </script>
    {/literal}

{else}
    {if $programa_salud.propio=="0"}
        <div class="sin-registros">
            <i class="dp-pacientes dp-icon"></i>
            <h6>{"¡No se encontraron resultados!"|x_translate}</h6>
            <p>{"No registramos profesionales dentro de esos parámetros."|x_translate}</p>
            <p>{"Vuelva a intentarlo cambiando sus opciones de búsqueda"|x_translate}</p>
        </div>
    {/if}
    {literal}
        <script>
            $(function () {
                $("#Main").spin(false);
                scrollToEl($("body"));
            });
        </script>
    {/literal}
{/if}