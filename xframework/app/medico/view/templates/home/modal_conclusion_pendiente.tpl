{if $cantidad_notificaciones.pendientes_finalizacion>0}
    <!-- Modal Consultas Express pendientes de finalizacion -->
    <div class="modal fade bs-example-modal-lg modal-alert"  id="modal-consultaexpress-pendiente_finalizacion" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-labelledby="myLargeModalLabel">
        <input type="hidden" class="from_logout_ce" value="">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content modal-content-alert">

                <div class="mod-alert-header">
                    <figure><i class="icon-doctorplus-alert"></i></figure>
                    <h3>{"Posee Consultas Express pendientes de registro médico"|x_translate}</h3>
                </div>
                <div class="mod-alert-action-holder">
                    <div class="mod-alert-action">
                        <button id="btn-resolver-consultaexpress"><i class="fa fa-check"></i>{"Completar"|x_translate}</button>
                        <button id="btn-cancelar-conclusion-ce" class="mod-alert-action-cancel" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i>{"Cerrar"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>	

    {literal}
        <script>
            $(document).ready(function () {
                /*Consulta express*/
                if ((modulo == "consultaexpress" || modulo == "home") && (submodulo == "bandeja_entrada" || submodulo == "consultaexpress_finalizadas" || submodulo == "home") && sessionStorage.getItem("modal-consultaexpress-pendiente_finalizacion") != "0") {
                    $("#modal-consultaexpress-pendiente_finalizacion").modal('show');
                    sessionStorage.setItem("modal-consultaexpress-pendiente_finalizacion", 0);
                }
                $("#btn-resolver-consultaexpress").click(function () {
                    if ($("#div_pendientes_finalizacion").length > 0) {
                        scrollToEl($("#div_pendientes_finalizacion"));
                        $("#modal-consultaexpress-pendiente_finalizacion").modal('hide');

                    } else {
                        window.location.href = BASE_PATH + "panel-medico/consultaexpress/finalizadas.html#div_pendientes_finalizacion";
                    }
                });

                //al cancelar, si se preiona el boton de LogOut mostramos el modal de cerrar sesion
                $("#btn-cancelar-conclusion-ce").click(function () {
                    if ($("#modal-consultaexpress-pendiente_finalizacion .from_logout_ce").val() === "1") {
                        x_LogOut();
                    }

                });
                //limpiamos el flag de cerrar sesion
                $('#modal-consultaexpress-pendiente_finalizacion').on('hidden.bs.modal', function () {
                    $("#modal-consultaexpress-pendiente_finalizacion .from_logout_ce").val("");
                });


            });
        </script>
    {/literal}
{/if}

{if $videoconsulta_notificaciones.pendientes_finalizacion>0}
    <!-- Modal Video Consultas pendientes de finalizacion -->
    <div class="modal fade bs-example-modal-lg modal-alert"  id="modal-videoconsulta-pendiente_finalizacion" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-labelledby="myLargeModalLabel">
        <input type="hidden" class="from_logout_vc" value="">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content modal-content-alert">

                <div class="mod-alert-header">
                    <figure><i class="icon-doctorplus-alert"></i></figure>
                    <h3>{"Posee Video Consultas pendientes de registro médico"|x_translate}</h3>
                </div>
                <div class="mod-alert-action-holder">
                    <div class="mod-alert-action">
                        <button id="btn-resolver-videoconsulta"><i class="fa fa-check"></i> {"Completar"|x_translate}</button>
                        <button id="btn-cancelar-conclusion-vc" class="mod-alert-action-cancel" data-dismiss="modal"><i class="icon-doctorplus-cruz"></i>{"Cerrar"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>	

    {literal}
        <script>
            $(document).ready(function () {
                /*Video Consulta*/
                if ((modulo == "videoconsulta" || modulo == "home") && (submodulo == "bandeja_entrada" || submodulo == "videoconsulta_finalizadas" || submodulo == "home") && sessionStorage.getItem("modal-videoconsulta-pendiente_finalizacion") != "0") {
                    $("#modal-videoconsulta-pendiente_finalizacion").modal('show');
                    sessionStorage.setItem("modal-videoconsulta-pendiente_finalizacion", 0);
                }


                $("#btn-resolver-videoconsulta").click(function () {
                    if ($("#div_pendientes_finalizacion").length > 0) {
                        scrollToEl($("#div_pendientes_finalizacion"));
                        $("#modal-videoconsulta-pendiente_finalizacion").modal('hide');
                    } else {
                        window.location.href = BASE_PATH + "panel-medico/videoconsulta/finalizadas.html#div_pendientes_finalizacion";
                    }
                });

                //al cancelar, si se preiona el boton de LogOut mostramos el modal de cerrar sesion
                $("#btn-cancelar-conclusion-vc").click(function () {
                    if ($("#modal-videoconsulta-pendiente_finalizacion .from_logout_vc").val() === "1") {
                        x_LogOut();
                    }

                });
                //limpiamos el flag de cerrar sesion
                $('#modal-videoconsulta-pendiente_finalizacion').on('hidden.bs.modal', function () {
                    $("#modal-videoconsulta-pendiente_finalizacion .from_logout_vc").val("");
                });

            });
        </script>
    {/literal}
{/if}