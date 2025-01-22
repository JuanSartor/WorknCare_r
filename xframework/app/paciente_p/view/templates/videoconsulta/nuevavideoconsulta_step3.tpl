<section class="container ce-nc-consulta ce-nc-p4-usr">
    <div class="row">

        <div class="col-xs-12">
            <div class="row">
                <div class="col-sm-5 ce-nc-p4-arrow-divider">
                    <div class="ce-nc-consulta-paciente">
                        <h3>{"DEL PACIENTE"|x_translate}</h3>
                        <div class="ce-nc-consulta-title-divider">
                            <span></span>
                        </div>
                        <div class="ce-nc-consulta-paciente-holder ce-nc-p4-usr-left">
                            <div class="ce-nc-consulta-paciente-icon">
                                <i class="icon-doctorplus-user"></i>
                            </div>
                            <div class="ce-nc-consulta-paciente-content">
                                <p><strong>{$paciente.nombre} {$paciente.apellido}</strong></p>
                                <span></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-sm-offset-1">
                    <div class="ce-nc-consulta-medico">


                        <div class="ce-nc-consulta-paciente">
                            {if $VideoConsulta.tipo_consulta=="0"}
                                <h3>{"PROFESIONALES EN LA RED"|x_translate}</h3>
                            {else}
                                <h3>{"PROFESIONAL"|x_translate}</h3>

                            {/if}
                            <div class="ce-nc-consulta-title-divider">
                                <span></span>
                            </div>
                            <div class="ce-nc-consulta-paciente-holder ce-nc-p4-usr-right">
                                {if $VideoConsulta.tipo_consulta=="0"}
                                    <div href="#" class="cv-nc-consulta-medico-icon">

                                        {if $programa_categoria.imagen.original !=""}
                                            <figure style="width:43px;height: 43px;">
                                                <img src="{$programa_categoria.imagen.original}" title="{$programa_categoria.programa_categoria}" alt=" {$programa_categoria.programa_categoria}" style="width: 30px; margin: 7px;" />
                                            </figure>
                                        {else}
                                            <figure>
                                                <i class="icon-doctorplus-people-add"></i>
                                            </figure>
                                        {/if}

                                        <span>
                                            <strong>
                                                {if $programa_salud.programa_salud!=""}
                                                    {$programa_salud.programa_salud}
                                                {/if}
                                                {if $programa_categoria.programa_categoria!=""}
                                                    &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                                                {/if}

                                                {if $especialidad.especialidad!=""}
                                                    <h3>{$especialidad.especialidad}</h3>
                                                {/if}
                                            </strong>
                                        </span>
                                    </div>
                                {else}
                                    <div class="cv-nc-consulta-medico-icon">
                                        {if $programa_categoria.imagen.original !=""}
                                            <figure style="width:43px;height: 43px;">
                                                <img src="{$programa_categoria.imagen.original}" title="{$programa_categoria.programa_categoria}" alt=" {$programa_categoria.programa_categoria}" style="width: 30px; margin: 7px;" />
                                            </figure>
                                        {else}
                                            <figure>
                                                <i class="icon-doctorplus-user-add-like"></i>
                                            </figure>
                                        {/if}
                                        <span>
                                            <strong>

                                                {if $programa_salud.programa_salud!="" && $programa_categoria.programa_categoria!=""}
                                                    {if $programa_salud.programa_salud!=""}

                                                        {$programa_salud.programa_salud}
                                                    {/if}
                                                    {if $programa_categoria.programa_categoria!=""}
                                                        &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                                                    {/if}:
                                                    <br>
                                                {/if}
                                                {$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}
                                            </strong>
                                        </span>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="row" id="div_alerta_confirmacion" style="padding-top:30px" >
        {include file="videoconsulta/banner_alerta_confirmacion_urgencia.tpl"}
    </div>
    <div class="clearfix">
        &nbsp;
    </div>
    <form id="f_publicar" name="f_publicar" action="{$url}publicar_videoconsulta.do" method="post" onsubmit="return false;" style="display:none" >
        <input type="hidden" name="cantidad" id="cantidad" value=""/>

        <input id="acceso_perfil_salud" name="acceso_perfil_salud" value="{$acceso_perfil_salud}" type="hidden" >
        {if $acceso_perfil_salud=="1"}
            <input type="hidden" id="mostrar_cambio_privacidad" value="{$mostrar_cambio_privacidad}"/>
            <input type="hidden" id="perfil_privado" name="perfil_privado" value="{$perfil_privado}"/>
        {/if}

        <input id="idvideoconsulta_f" name="idvideoconsulta" value="{$VideoConsulta.idvideoconsulta}" type="hidden" >
        <div class="row">
            {if $combo_programas}
                <div class="col-sm-5 col-sm-offset-1" id="programa_categoria_container">
                    <div class="cs-nc-p2-input-holder  ce-nc-p4-mensaje">
                        <label>{"Programas de salud"|x_translate}&nbsp;*</label>
                        <input type="hidden" id="idprograma_categoria" name="idprograma_categoria" value="">
                        <input type="hidden" id="idprograma_salud" name="idprograma_salud" value="">
                        <div class="dropdown dropdown-programas-container select2-container form-control select select-primary select-block mbl">
                            <a class="select2-choice" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                <span class="label-default"> {"Seleccione un programa de salud"|x_translate}</span>
                                <span class="item-seleccionado" style="display: none;"></span>
                                <span class="select2-arrow" role="presentation"><b role="presentation"></b></span>
                            </a>
                            <ul class="select2-results dropdown-menu dropdown-programas" aria-labelledby="dropdownMenu1">
                                {foreach from=$combo_programas item=programa}
                                    <li>
                                        <a href="javascript:;" class="select-programa" data-idprograma="{$programa.idprograma_salud}">
                                            <i class="fa fa-chevron-right"></i> 
                                            <strong class="nombre-programa" data-idprograma="{$programa.idprograma_salud}">{$programa.programa_salud}:</strong>
                                            <span class="tag-container" >
                                                <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                                                    <span class="content">
                                                        {"Gratuita"|x_translate}
                                                    </span>
                                                </div>
                                            </span>
                                        </a>
                                        <ul class="dropdown-submenu">
                                            {foreach from=$programa.programa_categoria item=categoria}
                                                <li class="select-categoria" data-idprograma="{$programa.idprograma_salud}" data-idcategoria="{$categoria.idprograma_categoria}" >
                                                    - <span class="nombre-categoria" data-idcategoria="{$categoria.idprograma_categoria}">&nbsp;{$categoria.programa_categoria}</span>
                                                </li>
                                            {/foreach}
                                        </ul>
                                    </li>
                                {/foreach}
                            </ul>
                        </div>
                    </div>
                </div>

            {/if}
            <div class="{if $combo_programas}col-sm-5{else}col-sm-10 col-sm-offset-1{/if} ce-nc-p4-mensaje">
                <label>{"Motivo"|x_translate}&nbsp;*</label>
                <div class="cs-nc-p2-input-holder">
                    <select id="motivovideoconsulta" name="motivoVideoConsulta_idmotivoVideoConsulta"  {if $combo_programas}disabled="disabled"{/if} class="form-control select select-primary select-block mbl">
                        <option value="">{"Seleccione una opción"|x_translate}</option>
                        {html_options options=$combo_motivos selected=$VideoConsulta.motivoVideoConsulta_idmotivoVideoConsulta}

                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-10 col-sm-offset-1 ce-nc-p4-mensaje">
                <label>{"Mensaje"|x_translate}&nbsp;*</label>
                <textarea id="text-msg" maxlength="800" name="mensaje" placeholder='{"Ingresa aquí el motivo de tu video consulta con el mayor detalle posible para una respuesta más rápida y precisa."|x_translate}'>{$mensaje.mensaje}</textarea>
                <span id="caracter-count">800/0</span>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-10 col-sm-offset-1 estudio-imagenes-files ce-nc-p4-upload">

                <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
                    {x_component_upload_multiple max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="images_mensajes_vc" 
                    callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf"}
                    <div class="dz-message needsclick">
                        <i class="fui-clip"></i>
                        <h3>{"Archivos adjuntos"|x_translate}</h3>
                        <small>{"Ud. podrá subir archivos en formato:"|x_translate}&nbsp; JPG, PNG, PDF</small>
                        <div class="add-more-container">
                            <div class="add-more-btn"> 
                                <i class="fa fa-plus-circle"></i>
                                <span>{"Agregar más"|x_translate}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>
            </div>
        </div>
        <div class="row">
            <div class="ce-nc-p3-monto-btns-holder">
                <button id="btnPasoAnterior" class="btn btn-secondary ">
                    {"volver"|x_translate}
                </button>
                <button id="btnEnviarConsulta" class="btn btn-primary btn-default">
                    {"continuar"|x_translate}
                </button>
            </div>
        </div>
        <div class="row">
            <div class="okm-center-col">
                <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>

    </form>
</section>

<!--	ALERTAS - Perfil de Salud completo - acreditacion	-->
<div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" id="modal-cambio-privacidad-perfil-salud" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atencion!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Esta consulta requiere cambiar la privacidad del Perfil de Salud del paciente a"|x_translate} 
                    <span id="txt_change_privacidad">{$txt_change_privacidad}</span>.
                    {"A menos que vuelvas a modificar posteriormente esta selección, dicha configuración quedará permanentemente."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button type="button"  data-dismiss="modal" aria-label="Close" style="background-color: #ff6f6f"><i class="icon-doctorplus-cruz"></i> {"Cancelar"|x_translate}</button>
                    <button id="btnCambiarPrivacidad"><i class="dpp-lock"></i> {"Cambiar privacidad"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>	


<!--	MODAL - consulta pendiente con el medico	-->
{if $consulta_pendiente_exist.idvideoconsulta!=""}
    <div id="modal-consulta-pendiente-medico" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" >
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <figure class="modal-icon"><i class="fas fa-user-clock"></i></figure>
                    <h3 class="modal-sub-title">{"Ya has enviado una consulta al profesional"|x_translate}</h4>
                        <h4 class="modal-title">{"Tienes una videoconsulta pendiente con este profesional. Puedes esperar su respuesta o solicitarle otra consulta nuevamente"|x_translate}</h3>
                </div>
                <div class="modal-footer">
                    <div class="modal-action-row">
                        <a href="javascript:;" class="btn-default btn-secondary" id="btn-esperar-respuesta"><i class="fa fa-chevron-left"></i>&nbsp;{"Seguiré esperando"|x_translate}</a>
                        <a href="javascript:;" class="btn-default" id="enviar-otra-consulta"  data-dismiss="modal" aria-label="Close">{"Enviar otra consulta"|x_translate}&nbsp;<i class="fa fa-chevron-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {literal}
        <script>
            $(function () {
                $("#modal-consulta-pendiente-medico").modal("show");
                $("#btn-esperar-respuesta").click(function () {
                    $("body").spin();
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'delete_videoconsulta_borrador.do',
                            'idvideoconsulta=' + $("#idvideoconsulta").val(),
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                });
            });
        </script>
    {/literal}
{/if}
{*TEST RTC*}
<link rel="stylesheet" href="{$url}xframework/app/themes/dp02/css/checkrtc.css">
<script type="text/javascript" src="https://static.opentok.com/v2/js/opentok.min.js"></script>
<script src="{$url}xframework/files/session_conectividad.js"></script>
<script src="{$url}xframework/core/libs/libs_js/bundle_test_conectividad_2.js"></script>
<div id="run-checkrtc" class="modal fade " tabindex="-1" role="dialog"  data-backdrop="static" data-keyboard="false" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-dialog-centered" role="document" >
        <div class="modal-content" id="checkRTC_container">
        </div>
    </div>
</div>
<script>
            var ids_excepciones_programa = "{$ids_excepciones_programa}";
</script>
{literal}
    <script>
        $(function () {

            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#videoconsulta-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }

            renderUI2("videoconsulta-step-container");


            //contador de caracteres

            $("#caracter-count").html("800/" + $("#text-msg").val().length);

            $("#text-msg").keyup(function () {

                var long = $("#text-msg").val().length;
                $("#caracter-count").html("800/" + long);
            });

            $("#text-msg").change(function () {

                var long = $("#text-msg").val().length;
                $("#caracter-count").html("800/" + long);
            });

            //desmarcamos los programas que no son ofrecidos por la empresa
            if (ids_excepciones_programa !== "") {

                if (ids_excepciones_programa !== "ALL") {
                    ids_excepciones_programa.split(',').forEach(function (id) {
                        $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
                    });
                    $(".programa-destacado-tag:not(.hide)").show();
                } else {
                    $(".programa-destacado-tag").show();
                }
            }
            //marcamos el programa o categoria seleccionado
            $(".select-programa").click(function (e) {
                e.preventDefault();
                e.stopPropagation();
                let idprograma = $(this).data("idprograma");
                $(".select-programa").not("[data-idprograma=" + idprograma + "]").removeClass("open");
                $(this).toggleClass("open");
            });
            //marcamos el programa o categoria seleccionado
            $(".select-categoria").click(function (e) {
                e.preventDefault();

                $(".item-seleccionado").html("");
                $("#idprograma_categoria").val("");
                $("#idprograma_salud").val("");
                if ($(this).data("idprograma") != "") {
                    let idprograma = $(this).data("idprograma");
                    $(".item-seleccionado").append($(".nombre-programa[data-idprograma=" + idprograma + "]").clone());
                    $("#idprograma_salud").val(idprograma);
                }
                if ($(this).data("idcategoria") != "") {
                    let idcategoria = $(this).data("idcategoria");
                    $(".item-seleccionado").append($(".nombre-categoria[data-idcategoria=" + idcategoria + "]").clone());
                    $("#idprograma_categoria").val(idcategoria);
                }

                $(".label-default").hide();
                $(".item-seleccionado").show();
                updateComboBoxSelect2("#idprograma_categoria", 'motivovideoconsulta', 'ManagerMotivoVideoConsulta', 'getComboByProgramaCategoria', 0, x_translate('Seleccione una opción'), doUpdateComboBoxSelect2);


            });

            //boton para volver al paso anterior
            //boton para cancelar pago y volver al paso anterior
            $("#btnPasoAnterior").click(function () {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'back_paso_2_vc.do',
                        "idvideoconsulta=" + $("#idvideoconsulta").val() + "&consulta_step=2",
                        function (data) {

                            if (data.result) {

                                window.location.href = "" + "?continue=true";

                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });

            //envio de la consulta

            $("#btnEnviarConsulta").click(function () {
                $(".select-required").removeClass("select-required");

                if ($("#idprograma_categoria").length > 0 && $("#idprograma_categoria").val() === "") {
                    x_alert(x_translate("Seleccione un programa de salud"));
                    $(".dropdown-programas-container").addClass("select-required");
                    return false;
                }
                if ($("#motivovideoconsulta").val() === "") {
                    x_alert(x_translate("Seleccione el motivo de su Video Consulta"));
                    $("#motivovideoconsulta").addClass("select-required");
                    return false;
                }
                if ($("#text-msg").val().length === 0) {
                    x_alert(x_translate("Ingresa el texto de la consulta con el mayor detalle posible para una respuesta más rápida y precisa."));
                    $("#text-msg").addClass("select-required");
                    return false;
                }


                //carga de imagenes en proceso
                if ($("#dropzone .dz-complete").length !== $("#dropzone .dz-preview").length) {
                    x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                    return false;

                }
                //si no pasó el test, lo ejecutamos
                if (localStorage.getItem('hide_checkrtc_modal_paciente') !== "1") {
                    return false;
                }

                $("#videoconsulta-step-container").spin("large");

                x_sendForm($('#f_publicar'), true, function (data) {


                    $("#videoconsulta-step-container").spin(false);
                    if (data.result) {
                        x_loadModule('videoconsulta', 'nuevavideoconsulta_step4', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
                    } else {
                        x_alert(data.msg);
                    }
                });
            });


            //boton siguiente paso- se crea la videoconsulta->/ tambien se valida si la privacidad del perfil de salud es adecuada, si el usuario decide cambiarla se vuelve a ejecutar con el cambio de privacidad
            $("#btnContinuar").click(function () {
                if ($("#check_casos_urgentes").is(':checked')) {
                    if ($("#mostrar_cambio_privacidad").val() === "1") {
                        $("#modal-cambio-privacidad-perfil-salud").modal('show');
                    } else {
                        //verificamos el dispositivo - Test RTC
                        var hide_checkrtc_modal_paciente = localStorage.getItem('hide_checkrtc_modal_paciente');
                        if (hide_checkrtc_modal_paciente !== "1") {
                            $("#checkRTC_container").empty();
                            $("#checkRTC_container").spin("large");
                            $("#run-checkrtc").modal("show");

                            x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                                $("#checkRTC_container").spin(false);
                            });
                        } else {
                            $("#div_alerta_confirmacion").hide();
                            $("#f_publicar").slideDown();
                        }

                    }

                } else {
                    x_alert(x_translate("Confirme que no consulta un caso urgente"));
                    return false;
                }

            });

            /**/

            //seteamos la variable de cambio de privacidad
            $("#btnCambiarPrivacidad").click(function () {

                $("#mostrar_cambio_privacidad").val(0);
                $("#modal-cambio-privacidad-perfil-salud").modal('hide');
                $("#btnContinuar").trigger("click");

            });

        });

    </script>
{/literal}

