{include file="agenda/agenda_header.tpl"}
<div class="okm-container">
    <h6 class="text-center">{"Vacaciones"|x_translate}</h6>
    <div class="okm-row">
        <div class="col-md-3 col-md-offset-3">
            <label>{"Fecha de inicio"|x_translate}</label>
            <div class="bst-form-row cobertura-form-row green-search-box" id="desde_datepicker">
                <input type="text" id="vacaciones_desde" name="desde" placeholder='{"DD/MM/AAAA"|x_translate}'/>
                <button><i class="icon-doctorplus-calendar"></i></button>
            </div>
        </div>
        <div class="col-md-3">
            <label>{"Fecha de fin"|x_translate}</label>
            <div class="bst-form-row cobertura-form-row green-search-box" id="hasta_datepicker">
                <input type="text" id="vacaciones_hasta" name="hasta" placeholder='{"DD/MM/AAAA"|x_translate}'/>
                <button><i class="icon-doctorplus-calendar"></i></button>
            </div>

        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div class="okm-row text-center">
        <div class="col-xs-12">
            <button id="btn_cargar_vacaciones" class="btn btn-default btn-primary">{"guardar"|x_translate}</button>

        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div class="okm-row text-center" id='vacaciones_list_container'>
        {include file="agenda/vacaciones_list.tpl"}
    </div>
    <div class="clearfix">&nbsp;</div>
</div>
{literal}
    <script>
        $(function () {
            $("#desde_datepicker")
                    .datetimepicker({
                        pickTime: false,
                        language: 'fr'
                    });
            $("#hasta_datepicker")
                    .datetimepicker({
                        pickTime: false,
                        language: 'fr'
                    });
            //cargar nuevo periodo de vacaciones
            $("#btn_cargar_vacaciones").click(function () {
                if ($("#vacaciones_desde").val() === "" || $("#vacaciones_hasta").val() === "") {
                    x_alert(x_translate("Ingrese la fecha del periodo de vacaciones que desea cargar"));
                    return false;
                }

                if (validar_fechas()) {

                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "medico.php?action=1&modulo=agenda&submodulo=agregar_vacaciones",
                            "desde=" + $("#vacaciones_desde").val() + "&hasta=" + $("#vacaciones_hasta").val(),
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    x_alert(data.msg);
                                    //recargamos el modulo del listado
                                    x_loadModule('agenda', 'vacaciones_list', '', 'vacaciones_list_container').then(function () {
                                        $("body").spin(false);
                                        $("#vacaciones_desde").val("");
                                        $("#vacaciones_hasta").val("");
                                    });
                                } else {
                                    if (data.turno_existente) {
                                        jConfirm({
                                            title: x_translate("Turno existente"),
                                            text: x_translate("Usted tiene citas asignadas durante este período. Debes cancelarlos antes de cargar las vacaciones."),
                                            confirm: function () {
                                                $("body").spin("large");
                                                window.location.href = BASE_PATH + "panel-medico/agenda/agenda-semanal/?idconsultorio=" + data.idconsultorio + "&fecha=" + data.fecha;

                                            },
                                            cancel: function () {

                                            },
                                            confirmButton: x_translate("Ver agenda"),
                                            cancelButton: x_translate("Volver")
                                        });
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }


                            }
                    );
                }
            });
            function validar_fechas() {

                //verificar fecha
                if ($("#vacaciones_desde").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#vacaciones_desde").val()))) {
                    $("#vacaciones_desde").data("title", x_translate("Ingrese una fecha válida")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#vacaciones_desde").offset().top - 200}, 300);
                    return false;
                }
                if ($("#vacaciones_hasta").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#vacaciones_hasta").val()))) {
                    $("#vacaciones_hasta").data("title", x_translate("Ingrese una fecha válida")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#vacaciones_hasta").offset().top - 200}, 300);
                    return false;
                }

                //validar fecha pasada

                var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                var arr_split1 = $("#vacaciones_desde").val().split("/");
                var fecha_desde = new Date(parseInt(arr_split1[2]), parseInt(arr_split1[1] - 1), parseInt(arr_split1[0]));
                if (fecha_desde.getTime() < fecha_actual.getTime()) {
                    $("#vacaciones_desde").data("title", x_translate("La fecha no puede ser anterior a hoy")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#vacaciones_desde").offset().top - 200}, 300);
                    return false;
                }
                var arr_split2 = $("#vacaciones_hasta").val().split("/");
                var fecha_hasta = new Date(parseInt(arr_split2[2]), parseInt(arr_split2[1] - 1), parseInt(arr_split2[0]));
                if (fecha_hasta.getTime() < fecha_actual.getTime()) {
                    $("#vacaciones_hasta").data("title", x_translate("La fecha no puede ser anterior a hoy")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#vacaciones_hasta").offset().top - 200}, 300);
                    return false;
                }

                if (fecha_hasta.getTime() < fecha_desde.getTime()) {
                    $("#vacaciones_hasta").data("title", x_translate("La fecha de fin debe ser posterior a la fecha de inicio")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#vacaciones_hasta").offset().top - 200}, 300);
                    return false;
                }
                return true;
            }
        });
    </script>
{/literal}