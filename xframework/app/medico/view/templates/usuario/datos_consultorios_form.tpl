
<div class="container">

    <div class="row" id="div_horarios">
        <div class="col-md-10 col-md-offset-1">
            <h4 class="mul-form-tittle">{"Días y horarios de atención"|x_translate}</h4>
        </div>
    </div>


    <form class="form" id="frmHorario" action="{$url}registrar-horario.do" method="post" onsubmit="false;">		
        <input type="hidden" name="consultorio_idconsultorio" id="horario_idconsultorio" value="{$record.idconsultorio}"/>
        {include file="usuario/intervalos_turno.tpl"}
        <div class="row">
            <div class="col-md-10 col-md-offset-1">

                <div class="dc-horarios-check-holder">

                    <div class="dc-horarios-check-box-row">
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="1" name="dias[]" data-toggle="checkbox">
                                {"Lunes"|x_translate}
                            </label>
                        </div>
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="2" name="dias[]" data-toggle="checkbox">
                                {"Martes"|x_translate}
                            </label>
                        </div>
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="3" name="dias[]" data-toggle="checkbox">
                                {"Miércoles"|x_translate}
                            </label>
                        </div>
                    </div>
                    <div class="dc-horarios-check-box-row">
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="4" name="dias[]" data-toggle="checkbox">
                                {"Jueves"|x_translate}
                            </label>
                        </div>
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="5" name="dias[]" data-toggle="checkbox">
                                {"Viernes"|x_translate}
                            </label>
                        </div>
                        <div class="dc-horarios-item">
                            <label class="checkbox">
                                <input type="checkbox" value="6" name="dias[]" data-toggle="checkbox">
                                {"Sábado"|x_translate}
                            </label>
                        </div>
                    </div>

                </div>


                <hr>

            </div>

        </div>

        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <p class="dc-horarios-disclaimer">
                    {"Si ud. tienen en un mismo día y consultorio horarios de atención fragmentado (por ej. de 08:00 a 12 hs y de 16:00 a 20 hs.) debe agregar primero el horario de 8 a 12 y luego el de 16 a 20 hs."|x_translate}
                </p>
            </div>
        </div>


        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <div class="dc-horario-add-row">

                    <div class="dc-horario-add-item">
                        <div class="mapc-registro-form-row mapc-select">
                            <select id="hora_desde" name="hora_desde" class="form-control select select-primary select-block mbl">
                                {html_options options=$horas_minutos selected="08:00"}
                            </select>
                        </div>
                    </div>

                    <span class="dc-horaio-add-divider">a</span>

                    <div class="dc-horario-add-item">
                        <div class="mapc-registro-form-row mapc-select">
                            <select id="hora_hasta" name="hora_hasta" class="form-control select select-primary select-block mbl">
                                {html_options options=$horas_minutos selected="08:00"}
                            </select>
                        </div>
                    </div>

                    <div class="dc-horario-add-action-box">
                        <a href="javascript:;" class="btn-default-square agregar_horario">{"Agregar horario"|x_translate}</a>
                    </div>
                </div>
            </div>
        </div>
    </form>



    <div id="div_horarios_cont">

    </div>


</div>

{literal}
    <script>

        $(function () {
            x_loadModule('usuario', 'datos_consultorios_horarios', 'idconsultorio=' + $("#horario_idconsultorio").val(), 'div_horarios_cont');

            //seteamos el consultorio activo
            $(".dc-consultorio-item").removeClass("active");
            $("#consultorio-item-" + $("#horario_idconsultorio").val()).addClass("active");

            renderUI2("div_consultorio");
            $('.switch-checkbox').bootstrapSwitch();
            $(':checkbox').radiocheck();
            $(':radio, :checkbox').radiocheck();
            $('[data-toggle="tooltip"]').tooltip();

            var idconsultorio = $("#horario_idconsultorio").val();

            //Creacion de horario de turno

            $(".agregar_horario").click(function () {

                if ($("#frmHorario :checkbox:checked").length == 0) {
                    x_alert(x_translate("Selecciona el dia del turno"));
                    return false;
                }
                if ($("#hora_desde").val() == $("#hora_hasta").val()) {
                    x_alert(x_translate("Seleccione un horario de inicio y fin distintos"));
                    return false;
                }

                if (parseInt(idconsultorio) > 0) {
                    $("body").spin("large");
                    x_sendForm($('#frmHorario'), true, alert_resultado_horarios);
                } else {
                    x_alert(x_translate("No se ha definido un consultorio"));
                }

            });
            function alert_resultado_horarios(data) {

                $("body").spin(false);
                if (data.result) {
                    x_loadModule('usuario', 'datos_consultorios_horarios', 'idconsultorio=' + idconsultorio, 'div_horarios_cont');
                    $("#hora_desde").val("08:00");
                    $("#hora_hasta").val("08:00");
                    renderUI2("frmHorario");
                    $('#frmHorario :checkbox').radiocheck("uncheck");
                    scrollToEl($("#div_horarios_cont"));
                } else {
                    x_alert(data.msg);
                }


            }

        });
    </script>
{/literal}


