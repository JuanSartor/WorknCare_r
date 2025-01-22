<link rel="stylesheet" type="text/css" href="{$url}xframework/app/medico/view/css/conclusion-medica.css?v={$smarty.now|date_format:"%j"}" />
<input type="hidden" id="url_paciente_seo" value="{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}"/>

{if $ConsultaExpress || $videoconsulta}
    <nav class="section-header ce-ca-top profile">
        <div class="container">
            <div class="user-select pull-left user-select-sonsulta-express-rsp">
                <h1 class="section-name">
                    {if $ConsultaExpress}
                        <i class="icon-doctorplus-chat"></i>
                        <a class="consulta-express-tittle-lnk" href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a>
                    {/if}
                    {if $videoconsulta}
                        <i class="icon-doctorplus-video-call"></i>
                        <a class="consulta-express-tittle-lnk mvc-guia-title" href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a>
                    {/if}
                </h1>
            </div>

            <div class="clearfix"></div>
        </div>
    </nav>
{/if}
{if $smarty.request.mis_registros_consultas_medicas!=1}
    {include file="perfil_salud/menu_perfil_salud.tpl"}
{/if}

{*Verificamos si viene la consulta express o videoconsulta que no este finalizada ya*}
{if $consultaexpress_finalizada=="1" || $videoconsulta_finalizada=="1" }

    <br>
    {if $consultaexpress_finalizada=="1"}
        <h5 class="text-center">{"La Consulta Express ya se encuentra finalizada"|x_translate}</h5><br>
    {/if}
    {if $videoconsulta_finalizada=="1"}
        <h5 class="text-center">{"La Video Consulta ya no se encuentra pendiente de finalización"|x_translate}</h5><br>
    {/if}
{else}
    <section class="container-fluid hidden-xs">
        <br>
        <div class="row ">
            <div class="col-md-12">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>

                        {if $ConsultaExpress}
                            <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                            <li class="active">
                                {"Consulta Express Nº"|x_translate}{$ConsultaExpress.numeroConsultaExpress}
                            </li>
                        {/if}
                        {if $videoconsulta} 
                            <li><a href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a></li>
                            <li class="active">
                                {"Video Consulta Nº"|x_translate}{$videoconsulta.numeroVideoConsulta}
                            </li>
                        {/if}
                        <li>{"Nueva consulta / Anotaciones"|x_translate}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />

    <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
        <div class="modal-dialog">
            <div class="modal-content"></div>
        </div>
    </div>

    <div class="modal fade modal-type-2" id="modal_compartir_estudio" data-load="no">
        <div class="modal-dialog">
            <div class="modal-content"></div>
        </div>
    </div>

    <script>
        $(document).ready(function (e) {
            $('#ver-archivo, #modal_compartir_estudio').on('hidden.bs.modal', function () {
                $(this)
                        .removeData('bs.modal')
                        .find(".modal-content").html('');
            });
        });
    </script> 

    <section class="okm-container nueva-consulta" id="nueva-consulta">
        <div class="col-xs-12 no-gutter">

            <div class="col-md-3  pull-left col-xs-12" >
                <!--Menu-->
                {include file="perfil_salud/consulta_nueva_menu.tpl"}
            </div>

            <div class="col-md-9 pull-right col-xs-12">
                <div class="row tab-content view-doctor">
                    <!--Anotaciones-->
                    {include file="perfil_salud/consulta_nueva_anotaciones.tpl"}

                    <!--Estudios - Archivos-->
                    {include file="perfil_salud/consulta_nueva_estudios.tpl"}

                    <!--Medicacion-->
                    {include file="perfil_salud/consulta_nueva_medicacion.tpl"}

                    <!--Receta-->
                    {include file="perfil_salud/consulta_nueva_receta.tpl"}

                </div>

                <div class="row button-container text-center"> 
                    <button class="btn btn-inverse" onclick="window.history.back();">{"volver"|x_translate}</button>
                    <button class="btn btn-primary " onclick ="cerrarConsulta();" >{"cerrar consulta"|x_translate}</button>
                </div>
            </div>

        </div>
    </section>

    <div class="clearfix">&nbsp;</div>

    <!--	Modal -  Consulta express finalizada- acreditacion	-->
    <div id="modal-final-consultaexpress-acreditacion" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button"  onclick="window.location.href = '{$url}panel-medico/consultaexpress/';" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{"¡Felicitaciones ha concluído la consulta!"|x_translate}</h4>
                </div>
                <div class="modal-body">
                    <p>
                        {"Se acreditarán"|x_translate}&nbsp;
                        <strong id="precio_tarifa_consultaexpress_modal"></strong>
                    </p>
                    <div class="modal-perfil-completo-action-holder">
                        <button onclick="window.location.href = '{$url}panel-medico/consultaexpress/';"><i class="icon-doctorplus-chat"></i>{"Volver a Consulta Express"|x_translate}</button>
                        <button onclick="window.location.href = '{$url}panel-medico/mi-cuenta/';"><i class="icon-doctorplus-sheet"></i>{"ir a Mi Cuenta"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--	Modal -  Video Consulta finalizada- acreditacion	-->
    <div id="modal-final-videoconsulta-acreditacion" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button"  onclick="window.location.href = '{$url}panel-medico/videoconsulta/';" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{"¡Felicitaciones ha concluído la consulta!"|x_translate}</h4>
                </div>
                <div class="modal-body">
                    <p>
                        {"Se acreditarán"|x_translate}&nbsp;
                        <strong id="precio_tarifa_videoconsulta_modal"></strong>
                    </p>
                    <div class="modal-perfil-completo-action-holder">
                        <button onclick="window.location.href = '{$url}panel-medico/videoconsulta/';"><i class="icon-doctorplus-video-call"></i> {"Volver a Video Consulta"|x_translate}</button>
                        <button onclick="window.location.href = '{$url}panel-medico/mi-cuenta/';"><i class="icon-doctorplus-sheet"></i>{"ir a Mi Cuenta"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {include file="home/modal_display_file.tpl"}

    {literal}
        <script>
            x_runJS();

            function submitForm() {

                $("#consulta_form").validate({
                    showErrors: function (errorMap, errorList) {

                        // Clean up any tooltips for valid elements
                        $.each(this.validElements(), function (index, element) {
                            var $element = $(element);

                            $element.data("title", "") // Clear the title - there is no error associated anymore
                                    .removeClass("error")
                                    .tooltip("destroy");
                        });

                        // Create new tooltips for invalid elements
                        $.each(errorList, function (index, error) {
                            var $element = $(error.element);

                            $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                                    .data("title", error.message)
                                    .addClass("error")
                                    .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                        });
                    },
                    submitHandler: function (form) {
                        x_sendForm($('#consulta_form'), true, function (data) {
                            x_alert(data.msg);
                            if (data.result) {
                                x_loadModule('perfil_salud', 'consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + data.id, "Main", BASE_PATH + "medico");
                            }
                        });
                    }
                });
            }

            $(document).ready(function () {

                //opciones date picker de fecha
                $('#fecha').mask("00/00/0000", {placeholder: "jj/mm/aaaa"});
                $('#medicamento_fecha_inicio').mask("00/00/0000", {placeholder: x_translate("Fecha de inicio")});
                $('#medicamento_fecha_fin').mask("00/00/0000", {placeholder: x_translate("Fecha de fin")});

                $(".ui-datepicker-trigger")
                        .datetimepicker({
                            pickTime: false,
                            language: 'fr'
                        });
                $('#modal-final-consultaexpress-acreditacion').on('hidden.bs.modal', function () {
                    window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + $("#url_paciente_seo").val() + "/registro-consultas-medicas.html";
                });

                /*verificamos que se cambie de tab con archivos subiendo pendientes*/
                $(".nueva-consulta .nav li a").click(function (e) {
                    // Validamos que no existan archivos temporales
                    if ($(".dz-preview.dz-processing.dz-success.dz-complete").size() > 0 || $(".dz-preview.dz-preview.dz-processing.dz-success.dz-complete").size() > 0) {
                        x_alert(x_translate("¡Atención! Usted importó archivos pero olvidó agregarlos al informe."));
                        e.preventDefault();
                        return false;
                    }

                });
            });

            /*Cerrar consulta - guardar conclusion*/
            function  cerrarConsulta() {

                // Validamos que no existan archivos temporales
                if ($(".dz-preview.dz-processing.dz-success.dz-complete").size() > 0 || $(".dz-preview.dz-preview.dz-processing.dz-success.dz-complete").size() > 0) {
                    x_alert(x_translate("¡Atención! Usted importó archivos pero olvidó agregarlos al informe."));
                    return false;
                }

                //verififcamos campos requeridos
                $("#diagnostico").css("border", "none");
                $("#tratamiento").css("border", "none");
                if ($("#diagnostico").val() === "" || $("#tratamiento").val() === "") {
                    x_alert(x_translate("Ingrese el diagnostico y tratamiento para el paciente"));
                    $("a[href='#anotaciones']").trigger("click");
                    if ($("#tratamiento").val() === "") {
                        $("#tratamiento").css("border", "1px solid red");
                    }
                    if ($("#diagnostico").val() === "") {
                        $("#diagnostico").css("border", "1px solid red");
                    }

                    return false;
                }

                //verificar fecha de consulta
                if ($("#fecha").val().length !== 10 || (typeof (validatedate) === "function" && !validatedate($("#fecha").val()))) {
                    x_alert(x_translate("Error. verifique la fecha ingresada"));
                    return false;
                }


                jConfirm({
                    title: x_translate("Cerrar consulta"),
                    text: x_translate('Desea cerrar la consulta?'),
                    confirm: function () {

                        $("#Main").spin("large");
                        setTimeout(function () {
                            x_sendForm($('#consulta_form'), true, function (data) {

                                $("#Main").spin(false);
                                if (data.result) {

                                    //si venia de una consulta express
                                    if (data.hasOwnProperty("precio_tarifa") && data.precio_tarifa != "") {

                                        if (data.hasOwnProperty("idvideoconsulta") && data.idvideoconsulta != "") {
                                            //seteamos el precio de la consulta en el modal
                                            $("#precio_tarifa_videoconsulta_modal").html("&euro;" + data.precio_tarifa);
                                            if (data.precio_tarifa == 0) {
                                                $("#precio_tarifa_videoconsulta_modal").parent().hide();
                                            }
                                            //mostramos el modal de finalizacion de consulta express
                                            $("#modal-final-videoconsulta-acreditacion").modal('show');
                                        }
                                        if (data.hasOwnProperty("idconsultaexpress") && data.idconsultaexpress != "") {


                                            //seteamos el precio de la consulta en el modal
                                            $("#precio_tarifa_consultaexpress_modal").html("&euro;" + data.precio_tarifa);
                                            if (data.precio_tarifa == 0) {
                                                $("#precio_tarifa_consultaexpress_modal").parent().hide();
                                            }
                                            //mostramos el modal de finalizacion de consulta express
                                            $("#modal-final-consultaexpress-acreditacion").modal('show');
                                        }

                                    } else {
                                        x_alert(data.msg, function () {
                                            window.history.back();
                                        });

                                    }

                                } else {
                                    x_alert(data.msg);
                                }
                            });
                        }, 500);

                    },
                    cancel: function () {

                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });


            }


        </script>

    {/literal}

{/if}

