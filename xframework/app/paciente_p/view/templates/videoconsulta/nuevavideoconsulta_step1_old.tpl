<input type="hidden" id="tipo_consulta" value="">

<section class="container ce-nc-consulta">
    <div class="row" id="div_seleccion_tipo">
        <div class="col-xs-10 col-xs-offset-1">
            <div class="row">
                <div class="col-sm-6">
                    <div class="ce-nc-consulta-paciente">
                        <h3>{"Paciente"|x_translate}</h3>
                        <div class="ce-nc-consulta-title-divider">
                            <span></span>
                        </div>
                        <div class="ce-nc-consulta-paciente-holder">
                            <div class="ce-nc-consulta-paciente-icon">
                                <i class="icon-doctorplus-user"></i>
                            </div>
                            <div class="ce-nc-consulta-paciente-content">
                                <p>{$paciente.nombre} {$paciente.apellido}</p>
                                <span></span>
                            </div>
                        </div>


                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="ce-nc-consulta-medico">
                        <h3>{"¿a quién está dirigida la video consulta?"|x_translate}</h3>
                        <div class="ce-nc-consulta-title-divider">
                            <span></span>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <a href="javascript:;" role="button" id="btnSelectProfesionalFrecuente" class="ce-nc-consulta-medico-lnk">
                                    <figure>
                                        <i class="icon-doctorplus-user-add-like"></i>
                                    </figure>
                                    <span>{"A UN PROFESIONAL EN PARTICULAR"|x_translate}</span>
                                </a>
                            </div>
                            <div class="col-xs-6">
                                <a href="javascript:;" role="button" id="btnSelectProfesionalRed" class="ce-nc-consulta-medico-lnk">
                                    <figure >
                                        <i class="icon-doctorplus-people-add"></i>
                                    </figure>
                                    <span>{"A VARIOS PROFESIONALES EN SIMULTANEO"|x_translate}</span>
                                </a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
</section>


{literal}
    <script>
        $(':checkbox').radiocheck();
   
        $(function () {
            //botones de seleccion a quien esta dirigida la cosnulta
            $("#btnSelectProfesionalFrecuente").click(function () {
                $("#btnSelectProfesionalRed").removeClass("active");
                $(this).addClass("active");

                $("#tipo_consulta").val("1");

            });
            $("#btnSelectProfesionalRed").click(function () {
                $("#btnSelectProfesionalFrecuente").removeClass("active");
                $(this).addClass("active");
                $("#tipo_consulta").val("0");

            });

            //boton siguiente paso- se crea la consultaexpre->/ tambien se valida si la privacidad del perfil de salud es adecuada, si el usuario decide cambiarla se vuelve a ejecutar con el cambio de privacidad
            $("#btnSelectProfesionalFrecuente,#btnSelectProfesionalRed").click(function () {


                //verificamos que se seleccione una opcion
                if ($("#tipo_consulta").val() == "1" || $("#tipo_consulta").val() == "0") {
                    $("#videoconsulta-step-container").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'nuevavideoconsulta_step1.do',
                            "tipo_consulta=" + $("#tipo_consulta").val() + "&idvideoconsulta=" + $("#idvideoconsulta").val() + "&cambio_privacidad=" + $("#cambio_privacidad").val(),
                            function (data) {
                                $("#videoconsulta-step-container").spin(false);
                                //seteamos el id luego de crear la consulta
                                $("#idvideoconsulta").val(data.id);

                                if (data.result) {
                                    if ($("#tipo_consulta").val() == "1") {
                                        // window.location.href = BASE_PATH + "panel-paciente/busqueda-profesional/?servicio=videoconsulta";
                                        x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_frecuente', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
                                    } else {
                                        x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_red_busqueda', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");

                                    }
                                } else {

                                    x_alert(data.msg);

                                }
                            }
                    );
                } else {
                    x_alert(x_translate("Seleccione a quien está dirigida la consulta"));
                    return false;
                }



            });


            //salir de video consulta
            $("#btn-cancelar-consulta").click(function () {
                jConfirm({
                    title: x_translate("Cancelar Video Consulta"),
                    text: x_translate("Está por cancelar la Video Consulta. ¿Desea continuar?"),
                    confirm: function () {

                        window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
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