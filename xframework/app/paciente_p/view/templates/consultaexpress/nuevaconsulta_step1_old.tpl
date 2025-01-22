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
                        <h3>{"¿a quién está dirigida la consulta?"|x_translate}</h3>
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

<section class="consulta-express-slider-holder">

    <div class="item">
        <div class="item-4 ce-nc-consulta-bottom-slide">
            <div class="item-inner item-4-img">

                <div class="item-4-frame-holder">

                    <div class="item-2-icon-holder">
                        <div class="item-2-icon-shadow"></div>
                        <div class="item-3-icon-icon">
                            <i class="icon-doctorplus-video-call"></i>
                        </div>
                    </div>

                    <div class="item-4-content-holder">
                        <div class="item-4-content">
                            <h4>
                                {"Profesionales en la red"|x_translate}
                            </h4>
                            <p>
                                {"Su consulta atendida en menor tiempo por nuestra red de Profesionales y especialistas."|x_translate}
                            </p>
                            <p>
                                {"¡Conectándonos fácilmente cuidamos mejor nuestra salud!"|x_translate}
                            </p>
                            <div class="item-3-content-link-holder">
                                <a class="item-3-content-link" href="{$url}panel-paciente/guia-de-uso/">{"Más Info"|x_translate} <span></span></a>
                            </div>
                        </div>
                        <div class="item-shadow"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</section>

{literal}
    <script>
        $(':checkbox').radiocheck();
        //maramos el paso 1 activo
        $(".vc-nc-steps li:eq(0)").addClass("active");

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

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'nuevaconsulta_step1.do',
                            "tipo_consulta=" + $("#tipo_consulta").val() + "&idconsultaExpress=" + $("#idconsultaExpress").val() + "&cambio_privacidad=" + $("#cambio_privacidad").val(),
                            function (data) {
                                //seteamos el id luego de crear la consulta
                                $("#idconsultaExpress").val(data.id);

                                if (data.result) {
                                    if ($("#tipo_consulta").val() == "1") {
                                        x_loadModule('consultaexpress', 'nuevaconsulta_step2_profesional_frecuente', 'idconsultaExpress=' + $("#idconsultaExpress").val(), 'consulta-express-step-container', BASE_PATH + "paciente_p");
                                        // window.location.href=BASE_PATH+"panel-paciente/busqueda-profesional/?servicio=consulta-express";
                                    } else {
                                        x_loadModule('consultaexpress', 'nuevaconsulta_step2_profesional_red_busqueda', 'idconsultaExpress=' + $("#idconsultaExpress").val(), 'consulta-express-step-container', BASE_PATH + "paciente_p");
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
        });
    </script>


{/literal}