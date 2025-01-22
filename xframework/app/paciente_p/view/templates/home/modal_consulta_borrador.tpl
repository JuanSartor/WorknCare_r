<!--Modal alerta consulta borrador	-->


<div class="modal fade bs-example-modal-lg modal-alert"  id="modal-consulta-borrador" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-content-alert">

            <div class="mod-alert-header">
                <figure><i class="icon-doctorplus-alert"></i></figure>
                <h3>{"Ud. tiene una Consulta Express en proceso."|x_translate}</h3>
            </div>
            <div class="mod-alert-action-holder">
                <div class="mod-alert-action">
                    <button id="btnContinuarBorrador"><i class="fa fa-check"></i>{"Continuar"|x_translate}</button>
                    <button id="btnDeleteBorrador" class="mod-alert-action-cancel" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>	


<!--Modal alerta consulta borrador	-->


<div class="modal fade bs-example-modal-lg modal-alert"  id="modal-videoconsulta-borrador" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-content-alert">

            <div class="mod-alert-header">
                <figure><i class="icon-doctorplus-alert"></i></figure>
                <h3>{"Ud. tiene una Video Consulta en proceso."|x_translate}</h3>
            </div>
            <div class="mod-alert-action-holder">
                <div class="mod-alert-action">
                    <button id="btnContinuarBorradorVC"><i class="fa fa-check"></i> {"Continuar"|x_translate}</button>
                    <button id="btnDeleteBorradorVC" class="mod-alert-action-cancel" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>	
<!--Modal alerta turno borrador	-->


<div class="modal fade bs-example-modal-lg modal-alert"  id="modal-turno-borrador" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-content-alert">

            <div class="mod-alert-header">
                <figure><i class="icon-doctorplus-alert"></i></figure>
                <h3>{"Ud. tiene una solicitud de turno en proceso."|x_translate}</h3>
            </div>
            <div class="mod-alert-action-holder">
                <div class="mod-alert-action">
                    <button id="btnContinuarBorradorTurno"><i class="fa fa-check"></i> {"Continuar"|x_translate}</button>
                    <button id="btnDeleteBorradorTurno" class="mod-alert-action-cancel" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>	
{*Si se encuentra un turno en estado borrador abrimos un modal para continuar o descartarlo*}
{if $ConsultaExpress && !$smarty.request.continue}
    <script>
        $(document).ready(function () {

            $("#modal-consulta-borrador").modal('show');

            //eliminamos la consulta en borrador y recargamos
            $("#btnDeleteBorrador").click(function () {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'delete_consultaexpress_borrador.do',
                        'idconsultaExpress={$ConsultaExpress.idconsultaExpress}',
                        function (data) {

                            if (data.result) {
                                $("#modal-consulta-borrador").modal('hide');
                                if (submodulo === "nuevaconsulta") {
                                    window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html";
                                }
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });



            //eliminamos la consulta en borrador y recargamos
            $("#btnContinuarBorrador").click(function () {

                window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html" + "?continue=true";

            });
        });
    </script>
{/if}


{*Si se encuentra una consulta en estado borrador abrimos un modal para continuar o descartarla*}
{if $VideoConsulta && !$smarty.request.continue}
    <script>
        $(document).ready(function () {

            $("#modal-videoconsulta-borrador").modal('show');

            //eliminamos la consulta en borrador y recargamos
            $("#btnDeleteBorradorVC").click(function () {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'delete_videoconsulta_borrador.do',
                        'idvideoconsulta={$VideoConsulta.idvideoconsulta}',
                        function (data) {

                            if (data.result) {
                                $("#modal-videoconsulta-borrador").modal('hide');
                                if (submodulo === "nuevavideoconsulta") {
                                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html";
                                }
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });



            //eliminamos la consulta en borrador y recargamos
            $("#btnContinuarBorradorVC").click(function () {

                window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html" + "?continue=true";

            });
        });
    </script>
{/if}


{*Si se encuentra una consulta en estado borrador abrimos un modal para continuar o descartarla*}
{if $turno_borrador && !$smarty.request.continue}
    <script>
        $(document).ready(function () {

            $("#modal-turno-borrador").modal('show');

            //eliminamos la consulta en borrador y recargamos
            $("#btnDeleteBorradorTurno").click(function () {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'cancelar_from_creacion.do',
                        'id={$turno_borrador.idturno}',
                        function (data) {

                            if (data.result) {
                                $("#modal-turno-borrador").modal('hide');
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });



            //eliminamos la consulta en borrador y recargamos
            $("#btnContinuarBorradorTurno").click(function () {
        {if $turno_borrador.is_turno_videoconsulta=="1"}
                window.location.href = BASE_PATH + "panel-paciente/busqueda-profesional/reservar-turno-video-llamada-{$turno_borrador.idturno}.html";
        {else}
                window.location.href = BASE_PATH + "panel-paciente/busqueda-profesional/reservar-turno-{$turno_borrador.idturno}.html";
        {/if}
            });
        });
    </script>
{/if}
