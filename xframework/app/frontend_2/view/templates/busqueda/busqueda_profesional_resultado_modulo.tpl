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
                                    <a href="{$url}recherche-medecin/professionnels/{$consultorio.idmedico}-{$consultorio.nombre|str2seo}-{$consultorio.apellido|str2seo}.html">
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
                                        <a href="{$url}recherche-medecin/professionnels/{$consultorio.idmedico}-{$consultorio.nombre|str2seo}-{$consultorio.apellido|str2seo}.html">{$consultorio.titulo_profesional} {$consultorio.nombre} {$consultorio.apellido}</a>
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

    {literal}
        <script>
            var guardar_reserva = function (tipo, id) {
                console.log("tipo reserva:" + tipo + "-id:" + id);

                //limpiamos el resto de las variables
                sessionStorage.removeItem('tipo_reserva');
                sessionStorage.removeItem('idreserva');
                sessionStorage.removeItem('idprograma_categoria_seleccionado');
                sessionStorage.setItem('tipo_reserva', tipo);
                sessionStorage.setItem('idreserva', id);
                sessionStorage.setItem('idprograma_categoria_seleccionado', $("#idprograma_categoria_seleccionado").val());
                //cargamos el login
                //$("#loginbtn").trigger("click");
                $("#login").show();
                $(".login").modal("show");

            };

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
                $("#modulo_listado_consultorios").on("click", "a.a_reservar_turno", function (e) {
                    e.preventDefault();
                    var idturno = $(this).data('idturno');
                    if (parseInt(idturno) > 0) {
                        guardar_reserva("turno", idturno);
                    }



                });
                $("#modulo_listado_consultorios").on("click", "a.a_reservar_turno_vc", function (e) {
                    e.preventDefault();
                    var idturno = $(this).data('idturno');
                    if (parseInt(idturno) > 0) {

                        guardar_reserva("turno_vc", idturno);
                    }



                });

                //medico ofrece consulta solo a sus pacientes
                $(".consultaexpress_solo_pacientes").on("click", function (e) {
                    e.preventDefault();
                    var idmedico = $(this).data('id');
                    if (parseInt(idmedico) > 0) {
                        guardar_reserva("consultaexpress", idmedico);
                    }
                });

                $(".videoconsulta_solo_pacientes").on("click", function (e) {
                    e.preventDefault();
                    var idmedico = $(this).data('id');
                    if (parseInt(idmedico) > 0) {
                        guardar_reserva("videoconsulta", idmedico);
                    }
                });




                //botones para crear la consulta express asociada a un medico
                $(".a_consultaexpress").click(function () {
                    var idmedico = $(this).data('idmedico');
                    if (parseInt(idmedico) > 0) {
                        guardar_reserva("consultaexpress", idmedico);
                    }


                });

                //botones para crear la consulta asociada a un medico
                $(".pbp-planes-item").click(function () {
                    //consulta express
                    var elem_ce = $(this).find(".select-profesional-frecuente-ce");
                    if (elem_ce.length > 0) {
                        var idmedico = elem_ce.data('id');

                        if (parseInt(idmedico) > 0) {
                            guardar_reserva("consultaexpress", idmedico);
                        }
                    }
                    //videoconsulta
                    var elem_vc = $(this).find(".select-profesional-frecuente-vc");

                    if (elem_vc.length > 0) {
                        var idmedico = elem_vc.data('id');
                        if (parseInt(idmedico) > 0) {
                            guardar_reserva("videoconsulta", idmedico);
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