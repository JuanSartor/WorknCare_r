<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >
<div class="okm-row pul-pi-data-box">
    <div class="col-data">
        <figure><i class="icon-doctorplus-user-add-like"></i></figure>
        <p>{"Profesionales frecuentes"|x_translate}</p>
    </div>
    <div class="col-action">
        <a href="javascript:;" id='btnCancelarInvitarMedicoFrecuente' class="btn" style='display:none;'>{"Cancelar"|x_translate}</a>
        <a href="javascript:;" id='btnInvitarMedicoFrecuente' class="btn">{"Invitar"|x_translate}</a>
    </div>
</div>

<div class="row" id="agregar-medico-frecuente" style='display:none;'>

    <div class="form-content form-content-variante">
        <h4 class="text-center dp-add-user">{"Datos del profesional"|x_translate}</h4>



        <div id="datos-nuevo-paciente" class="">
            <div class="row">

                <div class="col-md-8 col-md-offset-2">
                    <form  id="invitacion_medico_form" action="{$url}invitar-medico.do" method="post" onsubmit="return false;">	
                        <p class="input-aux-container">
                            <select class="form-control select select-primary select-block mbl" name="especialidad_idespecialidad" id="invitar_especialidad" style="border-bottom: 1px solid #69aaac;width:100%">
                                <option value="">{"Especialidad"|x_translate}</option>
                                {if $paciente.email!=""}
                                    <option value="-1">{"Médico de cabecera"|x_translate}</option>
                                {/if}
                                {html_options options=$combo_especialidades}
                            </select>     
                            <span class="input-required">*</span>
                        </p>
                        <p class="input-aux-container">
                            <input type="text" id="invitar_nombre" name="nombre" data-title='{"Ingrese apellido"|x_translate}' placeholder='{"Apellido"|x_translate}'><span class="input-required">*</span>
                        </p>
                        <p class="input-aux-container">
                            <input type="text" id="invitar_email" name="email" data-title='{"Ingrese un email válido"|x_translate}' placeholder='{"Email"|x_translate}'><span class="input-required">*</span>
                        </p>
                        <p>
                            <input type="tel" id="invitar_celular" name="celular" data-title='{"Ingrese un número de celular válido"|x_translate}' placeholder='{"Celular"|x_translate}'>
                        </p>							

                    </form>
                </div>
            </div>
            <br>
            <a href="javascript:;" data-modal="yes" id="btnEnviarInvitacion" class="btn-primary btn btn-submit" role="button">{"Enviar invitación"|x_translate}<i class="dpp-send"  ></i></a>

        </div>

    </div>

</div>

<div id="div_invitaciones_medicos_frecuentes" >
    <script>
        x_loadModule('home', 'invitaciones_medicos_frecuentes_list', '', 'div_invitaciones_medicos_frecuentes');
    </script>  
</div>

<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js">
</script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js">
</script>
{literal}
    <script>
        $(function () {
            $("#invitar_celular").intlTelInput({
                nationalMode: false,
                preferredCountries: ['fr', 'be', 'lu'],
                utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
            });
            $("#invitar_celular").mask("+0000000000000");
            //agregamos el + al numero de telefono
            $("#invitar_celular").on("keyup", function () {
                if ($(this).val().substring(0, 1) != "+") {
                    $(this).val("+" + $(this).val());
                }
            });

            //mostrar/ocultar contenedor de invitacion profesional
            $("#btnInvitarMedicoFrecuente").click(function () {
                $("#btnInvitarMedicoFrecuente").hide();
                $("#btnCancelarInvitarMedicoFrecuente").show();
                $("#agregar-medico-frecuente").slideDown();
                scrollToEl($("#datos-nuevo-paciente"));
            });
            $("#btnCancelarInvitarMedicoFrecuente").click(function () {
                $("#btnInvitarMedicoFrecuente").show();
                $("#btnCancelarInvitarMedicoFrecuente").hide();
                $("#agregar-medico-frecuente").slideUp();
            });

            //boton enviar invitacion a médico
            $("#btnEnviarInvitacion").click(function () {
                if ($("#invitar_especialidad").val() == "") {
                    x_alert(x_translate("Seleccione la especialidad del profesional"));
                    return false;
                }

                if ($("#invitar_nombre").val() == "") {
                    x_alert(x_translate("Ingrese el nombre del profesional"));
                    return false;
                }

                if ($("#invitar_email").val() == "" && $("#invitar_celular").val() == "") {
                    x_alert(x_translate("Ingrese  email o celular del profesional"));
                    return false;
                }
                if ($("#invitar_email").val() != "" && !validarEmail($("#invitar_email").val())) {
                    x_alert(x_translate("Ingrese  un email válido"));
                    return false;
                }


                if ($("#invitar_celular").val() != "") {


                    if ($("#invitar_celular").intlTelInput("isValidNumber")) {
                        //ok
                    } else {
                        if ($("#invitar_celular").val().substring(0, 4) == "+337" && ($("#invitar_celular").val().length == 12)) {
                            //ok
                        } else {
                            x_alert(x_translate("Ingrese  un número de celular válido"));
                            return false;
                        }
                    }
                }

                //confirmar la accion
                jConfirm({
                    title: x_translate("Enviar invitación"),
                    text: x_translate("Confirma que desea agregar este profesional a sus médicos frecuentes?"),
                    confirm: function () {

                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "invitar-medico.do",
                                $("#invitacion_medico_form").serialize(),
                                function (data) {

                                    $("body").spin(false);
                                    if (data.result) {

                                        $("#div_invitaciones_medicos_frecuentes").spin("large");
                                        x_loadModule('home', 'invitaciones_medicos_frecuentes_list', '', 'div_invitaciones_medicos_frecuentes');
                                        x_loadModule('home', 'home_new_medicos_frecuentes', '', 'div_listado_medicos_frecuentes');

                                        $("#btnInvitarMedicoFrecuente").show();
                                        $("#btnCancelarInvitarMedicoFrecuente").hide();
                                        $("#agregar-medico-frecuente").slideUp();
                                        $("#invitacion_medico_form input").val("");
                                        $("#invitacion_medico_form select").val("");
                                        renderUI2();


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
        });
    </script>
{/literal}

