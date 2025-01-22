<style>
    .intervalo-spacer {
        margin-top: 32px;
        margin-bottom: 0px;
    }
    #div-cambio-horario .mul-picture-disclaimer-action-box{
        text-align: center;
        margin-top: 20px;
        padding-bottom: 0px; 
    }
</style>
<div class="row">
    <div class="col-md-8 col-md-offset-2">
        <div class="dc-disclaimer">
            <p>{"IMPORTANTE: Su configuración de intervalo de turnos se aplicará para todos los consultorios que cree por igual."|x_translate}</p>
        </div>
    </div>
</div>
<div class="row intervalo-spacer" id="div_select_intervalo">
    <div class="col-md-8 col-md-offset-2">
        <div class="row dc-intervalo-holder">

            <div class="dc-intervalo-box">
                {"Configurar intervalo de turnos cada"|x_translate}
            </div>
            <input type="hidden" id="intervalo_prev" value="{$preferencia.duracionTurnos}" />

            <div class="dc-intervalo-select-box">
                <div class="okm-select-plus-box mdc-style" id="idiomas-input">
                    <div class="okm-select">
                        <select class="form-control select select-primary select-block mbl" name="intervalo" id="select_intervalos">
                            {html_options options=$combo_duracion_turnos selected=$preferencia.duracionTurnos}
                        </select>
                    </div>
                </div>
            </div>

        </div>

    </div>
</div>
<div class="row" id="div-cambio-horario" style="display:none;">
    <div class="col-md-10 col-md-offset-1">
        <div class="mul-picture-disclaimer-action-box">
            <a href="javascript:;" id="btnListoHorarios" class="btn-oil-large">{"listo"|x_translate} <i class="icon-doctorplus-check-thin"></i></a>
        </div>
    </div>
</div>
<!-- Modal cambiar configuracion horarios-->
<div id="modal-cambiar-configuracion-horarios" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">

        <div class="modal-content" id="dc-del-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon consultorios"><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                <h4 class="modal-title">{"¿Está seguro que desea modificar el intervalo de turnos?"|x_translate}</h4>
                <p id="nombre-consultorio-modal-eliminar" class="dc-consultorio-modal "></p>
                <h4 class="modal-title modal-consulorios-disclaimer">{"Se eliminarán todas las configuraciones de turnos. En el caso de que tuviese pacientes con turnos confirmados les notificaremos que los mismos quedan cancelados."|x_translate} </h4>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-alert" id="btnCancelarCambioConfiguracion" data-dismiss="modal" aria-label="Close"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                    <a href="javascript:;" class="btn-default" id="btnAceptarCambioConfiguracion" data-idconsultorio=""><i class="icon-doctorplus-check-thin"></i> {"aceptar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>
{literal}
<script>
    $(function () {
        //metodo que cambia los intervalos y desplega el boton de aceptar
        $("#select_intervalos").change(function () {
            if ($("#select_intervalos").val() != $("#intervalo_prev").val()) {
                $("#div-cambio-horario").slideDown();
            } else {
                $("#div-cambio-horario").slideUp();
            }



        });


        //Modal cambio configuracion horaris
        $("#btnListoHorarios").click(function () {
            $("#modal-cambiar-configuracion-horarios").modal("show");
        });
        //aceptar cambio
        $("#btnAceptarCambioConfiguracion").click(function () {
            $("body").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'modificar_intervalos_turnos.do',
                    "duracionTurnos=" + $("#select_intervalos").val(),
                    function (data) {
                        $("body").spin(false);
                        $("#modal-cambiar-configuracion-horarios").modal("hide");
                        x_alert(data.msg);
                        if (data.result) {
                            x_loadModule('usuario', 'datos_consultorios_form', 'idconsultorio=' + $("#horario_idconsultorio").val(), 'div_consultorio');

                        }
                    }
            );
        });

        //cancelar cambio
        $("#btnCancelarCambioConfiguracion").click(function () {
            $("#select_intervalo").val($("#intervalo_prev").val());
            renderUI2("div_select_intervalo");
            $("#div-cambio-horario").slideUp();
            $("#modal-cambiar-configuracion-horarios").modal("hide");
        });

    });
</script>
{/literal}