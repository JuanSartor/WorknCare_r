<style>
    .btnEliminarMedicos {
        font-size: 12px;
        position: absolute;
        top: 80px;
        left: 10px;
        color:#f33243 !important;
    }
    .btnEliminarMedicos:hover {
        color:#f33243  !important;
        font-weight: 600;
        text-decoration: underline;
    }
    .gnlist-usr-avatar {
        width: 80px;
    }

</style>
<nav class="section-header consulta-express-top profile">
    <div class="container">
        <div class="user-select pull-left user-select-sonsulta-express-rsp">

            <h1 class="section-name">
                <a class="consulta-express-tittle-lnk pcu-header-lnk" href="{$url}panel-paciente/profesionales-frecuentes/">
                    <i class="icon-doctorplus-user-add-like"></i>
                    {"Profesionales Frecuentes"|x_translate}
                </a>
            </h1>
        </div>

        <div class="clearfix"></div>
    </div>
</nav>
<div id="profesionales_frecuentes_container">
    <!--Contenedor listado medicos frecuentes paginado:frecuentes_list-->
    <div id="div_profesionales_frecuentes_list">

    </div>
    <!--Contenedor listado medicos favoritos paginado:favoritos_list-->
    <div id="div_profesionales_favoritos_list">

    </div>
</div>
<!--	Modal horarios consultorio	-->
<div class="modal fade bs-example-modal-lg " id="modal-horarios-consultorio" data-load="no" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <p>{"Turnos disponibles del consultorio seleccionado"|x_translate}</p>
            </div>
            <div class="modal-body" >

                <div id="div_horarios_consultorio"></div>


            </div>
        </div>
    </div>
</div>
<!-- Modal dinero faltante VC -->
<div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" id="modal_info_dinero_cuenta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"No posees dinero suficiente en tu cuenta para realizar la Video Consulta al profesional seleccionado."|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Debes cargar en dinero en tu cuenta para para poder realizarla o consultar un profesional de menor tarifa. Dinero faltane:"|x_translate} <span id="faltante_dinero"></span>
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button id="btnCargarCredito">
                        {"cargar crédito"|x_translate}
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    x_loadModule('profesionalesfrecuentes', 'frecuentes_list', 'do_reset=1', 'div_profesionales_frecuentes_list', BASE_PATH + "paciente_p");
    x_loadModule('profesionalesfrecuentes', 'favoritos_list', 'do_reset=1', 'div_profesionales_favoritos_list', BASE_PATH + "paciente_p");
</script>

{literal}
    <script>
        $(function () {
            scrollToEl($("body"));
            //desplegar listado tarifas
            $('#profesionales_frecuentes_container').on("click", ".btn-mostrar-planes", function () {
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
            $('#profesionales_frecuentes_container').on("click", ".btn-ocultar-planes", function () {
                var id = $(this).data("id");
                $(this).hide();
                $(".btn-mostrar-planes[data-id=" + id + "]").show();
                $("#medico-data-row-" + id).slideUp();
                $("#div_turnos_modulo_" + id).slideUp();

            });
            /*
             $("#btnCargarCredito").click(function () {
             var monto_compra = $(this).data("monto-compra");
             window.location.href = BASE_PATH + "panel-paciente/credito-proceso-compra/?compra=" + monto_compra;
             });
             */
            //boton deliminar multiples medicos listado profesionales frecuentes
            $('#div_profesionales_frecuentes_list').on("click", ".btnEliminarMedicos", function () {
                var ids = $(this).data("idmedico");
                if (ids) {
                    jConfirm({
                        title: x_translate("Eliminar profesionales frecuentes"),
                        text: x_translate('Está por eliminar los profesionales seleccionados de su lista de profesionales frecuentes. ¿Desea continuar?'),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'delete_multiple_profesionales_frecuentes.do',
                                    'ids=' + ids,
                                    function (data) {
                                        x_alert(data.msg);
                                        $("body").spin(false);
                                        if (data.result) {


                                            x_loadModule('profesionalesfrecuentes', 'frecuentes_list', '&do_reset=1', 'div_profesionales_frecuentes_list', BASE_PATH + "paciente_p");
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
            // eliminar medico favorito
            $('#div_profesionales_favoritos_list').on("click", ".btnEliminarMedicos", function () {
                $element = $(this);
                var id = $(this).data('idmedico');
                if (id) {
                    jConfirm({
                        title: x_translate("Eliminar profesional favorito"),
                        text: x_translate('Está por eliminar el profesional seleccionado de su lista de profesionales favoritos. ¿Desea continuar?'),
                        confirm: function () {

                            $("#div_profesionales_favoritos_list").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'marcar_favorito.do',
                                    'idmedico=' + id,
                                    function (data) {
                                        $("#div_profesionales_favoritos_list").spin(false);
                                        if (data.result) {
                                            x_loadModule('profesionalesfrecuentes', 'favoritos_list', '&do_reset=1', 'div_profesionales_favoritos_list', BASE_PATH + "paciente_p");
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

            // eliminar medico de cabecera
            $('#profesionales_frecuentes_container').on("click", ".btn-eliminar-medico-cabecera", function () {
                $element = $(this);
                var id = $(this).data('idmedico');
                if (id) {
                    jConfirm({
                        title: x_translate("Eliminar médico de cabecera"),
                        text: x_translate('Está por eliminar el profesional como médico de cabecera. Permanecerá en su lista de profesionales frecuentes. ¿Desea continuar?'),
                        confirm: function () {

                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_medico_cabecera.do',
                                    'idmedico=' + id,
                                    function (data) {
                                        $("body").spin(false);
                                        if (data.result) {
                                            x_loadModule('profesionalesfrecuentes', 'frecuentes_list', '&do_reset=1', 'div_profesionales_frecuentes_list', BASE_PATH + "paciente_p");
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
            //botones para crear la consulta express asociada a un medico
            $('#profesionales_frecuentes_container').on("click", ".select-profesional-frecuente-ce", function () {
                var idmedico = $(this).data('idmedico');
                if (idmedico) {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'set_medico_consultaexpress.do',
                            'medico_idmedico=' + idmedico,
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                } else {
                                    x_alert(data.msg);
                                }

                            }

                    );
                }

            });
            //botones para crear la videoconsulta asociada a un medico
            $('#profesionales_frecuentes_container').on("click", ".select-profesional-frecuente-vc", function () {
                var idmedico = $(this).data('idmedico');
                if (idmedico) {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'set_medico_videoconsulta.do',
                            'medico_idmedico=' + idmedico,
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true";
                                } else {

                                    x_alert(data.msg);
                                }

                            }

                    );
                }

            });
            //seleccionar sacar turno
            $('#profesionales_frecuentes_container').on("click", ".select-turno", function () {
                $elem = $(this);
                var idmedico = $(this).data("idmedico");
                if (idmedico) {
                    var tipo = $(this).data("tipo");
                    x_loadModule('profesionalesfrecuentes', 'modal_horarios_consultorio', 'idmedico=' + idmedico + "&tipo=" + tipo, 'container-pbn-turnos-holder-' + idmedico, BASE_PATH + "paciente_p").then(
                            function () {
                                if ($("#container-pbn-turnos-holder-" + idmedico + " #modulo_listado_consultorios").length > 0) {
                                    $("#container-pbn-turnos-holder-" + idmedico).slideDown();
                                    scrollToEl($("#container-pbn-turnos-holder-" + idmedico));
                                } else {
                                    $elem.data("title", x_translate("Pas d'agenda"));
                                    $elem.tooltip("show");
                                }

                                //$("#modal-horarios-consultorio").modal("show");
                            });
                }
            });
        });

    </script>
{/literal}
