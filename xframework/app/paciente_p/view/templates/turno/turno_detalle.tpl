
<!--	content-->
<section class="okm-container">
    <div class="container-a">
        <a href="{$url}panel-paciente/"  class="btn-volver-home-sante btn-volver-reembolso a-personalizado container-btn-a-volver"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
    </div>
    <div class="okm-row">
        <div class="bst-p3-title">
            <h1>{"Detalle de Turno"|x_translate}</h1>
        </div>
    </div>
    <div class="okm-row">

        <div class="bst-img-col">
            <img src="{$IMGS}bst-mobile.png" alt="DoctorPlus"/>
        </div>

        <div class="bst-data-col">
            <ul class="bst-p3-user-data">
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-usr-add"></i></figure>
                        <span>{"Profesional"|x_translate}</span>
                    </div>
                    <p>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</p>
                </li>
                {if $programa_categoria.programa_categoria!=""}
                    <li>
                        <div class="bst-p3-label">
                            <figure>
                                <img src="{$IMGS}pass_bienetre_icon.png" style="
                                     top: 10px;
                                     left: 16px;
                                     width: 36px;
                                     ">
                            </figure>
                            <span>{"Programas de salud"|x_translate}</span>
                        </div>
                        <p>
                            {if $programa_salud.programa_salud!=""}
                                {$programa_salud.programa_salud}
                            {/if}
                            {if $programa_categoria.programa_categoria!=""}
                                &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                            {/if}
                        </p>

                    </li>
                {/if}
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-calendar"></i></figure>
                        <span>{"Fecha"|x_translate}</span>
                    </div>
                    <p> {$turno.fechaTurno_format} - <strong>{$turno.horarioTurno_format} {"hs"|x_translate}</strong></p>
                    {if $paciente_turno && ($turno.estado_turno=="1" || $turno.estado_turno=="0")}
                        <button id="btn-reprogramar" class="btn btn-green" style="display: inline-block;">{"Reprogramar"|x_translate}</button>
                    {/if}
                    <div id="modulo_listado_consultorios" style="display:none; margin-top:10px;">
                        <div class="pbn-turnos-holder pbn-turnos-sm" id="pbn-turnos-holder-{$turno.consultorio_idconsultorio}" data-fecha="" data-idmedico="{$medico.idmedico}" data-idconsultorio="{$turno.consultorio_idconsultorio}">

                            <div class="pbn-turnos-sm-slide" id="div_busqueda_agenda_semanal_medico_{$turno.consultorio_idconsultorio}" >

                                <!-- ACÁ VA EL CONTENIDO DEL MODULO-->

                            </div>

                        </div>
                    </div>
                </li>
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                        <span>{"Lugar"|x_translate}</span>
                    </div>
                    <p>
                        {if $consultorio.is_virtual==1}
                            {"Consultorio Virtual"|x_translate}
                        {else}
                            {"Consultorio Físico"|x_translate}: {$consultorio.direccion|lower|ucfirst}  {$consultorio.numero}, {$consultorio.localidad_corta|lower|ucfirst}, {$consultorio.pais}
                        {/if}
                    </p>
                </li>
                {if $paciente_turno}
                    <li>
                        <div class="bst-p3-label">
                            <figure><i class="icon-doctorplus-user"></i></figure>
                            <span>{"Paciente"|x_translate}</span>
                        </div>
                        <p>{$paciente_turno.nombre} {$paciente_turno.apellido}</p>
                    </li>
                {/if}
            </ul>

            {if $paciente_turno}
                {if $consultorio.is_virtual==1 && $turno.estado_turno=="1"}
                    <div class="okm-row text-center">
                        <a href="{$url}panel-paciente/videoconsulta/sala-espera.html" class="btn-default btn_espera" >{"Ingresar a Sala de espera"|x_translate}</a>
                    </div>
                {/if}
                {if $turno.estado_turno=="3"}
                    <div class="okm-row text-center">
                        <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html#modulo_listado_consultorios" class="btn-default btn_espera" >{"Solicitar otro turno"|x_translate}</a>
                    </div>
                {/if}
                {if $turno.mensaje_turno.mensaje!=""}
                    <div class="okm-row">

                        <label><strong>{"Comentario para el médico"|x_translate}</strong></label>
                        <p>

                            {$turno.mensaje_turno.mensaje|escape}
                        </p>
                        {if $turno.mensaje_turno.cantidad_archivos_mensajes > 0}
                            <div class="chat-content-attach">
                                <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=turno&submodulo=mensajes_imagenes_slider&id={$turno.mensaje_turno.idmensajeTurno}" data-target="#ver-archivo">
                                    <i class="fui-clip"></i>
                                    &nbsp;{$turno.mensaje_turno.cantidad_archivos_mensajes}&nbsp;{"Archivos adjuntos"|x_translate}
                                </a>
                            </div>
                        {/if}
                    </div>
                {/if}
                <div class="okm-row">
                    <div class="bst-p2-txt-disclaimer">
                        {if $consultorio.is_virtual==1}
                            <h3>{"Número de Turno de Video Consulta:"|x_translate} {$turno.idturno}</h3>
                            <p>{"Una vez que el especialista te llame recuerda que tienes [[{$VIDEOCONSULTA_VENCIMIENTO_SALA}]] minutos para ingresar al consultorio virtual. Transcurrido dicho plazo el médico puede cancelar la consulta y llamar al próximo paciente. ¡Te sugerimos estar atento!"|x_translate}</p>
                        {else}
                            <h3>{"Número de Turno:"|x_translate} {$turno.idturno}</h3>
                            <p>{"Por favor presente el número en la recepción al concurrir al turno"|x_translate}</p>
                        {/if}
                    </div>
                </div>

            {else}
                {if $turno_no_disponible}
                    <div class="okm-row">
                        <div class="bst-p2-txt-disclaimer text-center">
                            <h3><i class="fa fa-exclamation-circle"></i>&nbsp;{"Horario no disponible"|x_translate} </h3>
                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                {/if}
                <div class="okm-row text-center">
                    <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html#modulo_listado_consultorios" class="btn-default btn_espera" >{"Solicitar otro turno"|x_translate}</a>
                </div>
            {/if}
        </div>
        <div class="clearfix">&nbsp;</div>
    </div>
</section>

<input type="hidden" id="idturno" value="{$turno.idturno}">
<input type="hidden" id="idmedico" value="{$medico.idmedico}">
<input type="hidden" id="idconsultorio" value="{$turno.consultorio_idconsultorio}">
<input type="hidden" id="idprograma_categoria_seleccionado" value="{$turno.idprograma_categoria}" />
{include file="home/modal_display_file.tpl"}
<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

{literal}
    <script>

        $(function () {
            $("#Main").spin(false);
            $('#ver-archivo').on('hidden.bs.modal', function () {
                $(this)
                        .removeData('bs.modal')
                        .find(".modal-content").html('');
            });

            $("#btn-reprogramar").click(function () {
                if (!$("#modulo_listado_consultorios").is(":visible")) {
                    $("body").spin();
                    x_loadModule("profesionalesfrecuentes",
                            "agenda_semanal_medico",
                            "idmedico=" + $("#idmedico").val() + "&idconsultorio=" + $("#idconsultorio").val() + "&reprogramar=" + $("#idturno").val(),
                            "div_busqueda_agenda_semanal_medico_" + $("#idconsultorio").val(), BASE_PATH + "paciente_p").then(function () {
                        $("body").spin(false);
                        $("#modulo_listado_consultorios").slideDown();

                    });
                }

            });

            $('#modulo_listado_consultorios').on('click', '.a_semana_next, .a_semana_next_turno', function () {

                $this = $(this);
                //Div que tiene la data del consultorio, médico y semana
                $div_with_data = $this.parents(".pbn-turnos-holder");
                var semana;
                if ($this.hasClass("a_semana_next")) {
                    semana = "&week=next";
                } else if ($this.hasClass("a_semana_previous")) {
                    semana = "&week=previous";
                } else {
                    semana = "&diferencia_semanas=" + $this.data("cantidad_semanas");
                }

                $("#div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio")).spin("large");
                x_loadModule("profesionalesfrecuentes",
                        "agenda_semanal_medico",
                        "idmedico=" + $div_with_data.data("idmedico") + "&idconsultorio=" + $div_with_data.data("idconsultorio")
                        + semana + "&fecha=" + $div_with_data.data("fecha"),
                        "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "paciente_p");
            });

            //click boton en agenda sin turno  link para hacer vc/ce inmediata
            $("#modulo_listado_consultorios").on("click", ".no-turno-select-profesional-frecuente-vc", function () {

                console.log("sacar VC inmediata");
                var idmedico = $(this).data("idmedico");
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
            });
            $("#modulo_listado_consultorios").on("click", ".no-turno-select-profesional-frecuente-ce", function () {
                console.log("sacar CE inmediata");
                var idmedico = $(this).data("idmedico");
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
            });

            //listener para reprogramar el turno seleccionado
            $("#modulo_listado_consultorios").on("click", "a.a_reservar_turno,a.a_reservar_turno_vc", function (e) {

                e.preventDefault();
                e.stopPropagation();
                console.log("reprogramar_turno");

                var idturno_reprogramar = $(this).data("idturno");
                if (parseInt(idturno_reprogramar) > 0 && parseInt($("#idturno").val()) > 0) {
                    //formateamos la fecha/hora para el mensaje
                    let fecha = $(this).parent().parent().find("li:first span").html().replace(/\s/g, "").replace("<br>", " ");
                    let hora = $(this).text();
                    let nueva_fecha_turno = fecha + " " + hora + "hs";

                    jConfirm({
                        title: x_translate("Reprogramar turno"),
                        text: x_translate("Desear confirmar el cambio de su turno para el día") + " " + nueva_fecha_turno + "?",
                        confirm: function () {
                            $("body").spin();
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "paciente_p.php?action=1&modulo=turno&submodulo=reprogramar_turno",
                                    "idturno=" + $("#idturno").val() + "&reprogramar=" + idturno_reprogramar,
                                    function (data) {
                                        $("body").spin(false);
                                        if (data.result) {
                                            x_alert(data.msg, recargar(BASE_PATH + "panel-paciente/#listado-turnos"));
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

            });
        });
    </script>
{/literal}
{if $smarty.request.reprogramar!=""}
    {literal}
        <script>
            $(function () {
                $("#btn-reprogramar").trigger("click");
            });
        </script>
    {/literal}
{/if}
