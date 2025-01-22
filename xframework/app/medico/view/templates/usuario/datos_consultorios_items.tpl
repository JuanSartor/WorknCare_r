<style>
    @media(min-width: 600px){
        .dc-consultorios-list {
            max-width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 24px;
        }
    }

    .btn-agregar-horario{
        color: #fff;
        background: #78cbcd;
        padding: 4px;
        font-size: 16px !important;
        margin-right:10px;
    }
    .eliminar-consultorio{
        color: #fff;
        background: #ff6f6f;
        padding: 4px;
        font-size: 16px !important;
        margin-left:10px;
    }
    .eliminar-consultorio:hover,.btn-agregar-horario:hover,.eliminar-consultorio:focus,.btn-agregar-horario:focus{
        color: #fff;
    }
    .dc-consultorio-item.active{
        background-color:#7be2dc
    }
    .dc-consultorio-item{
        background-color:#99e2de40;
    }
</style>
<div class="okm-row dc-consultorios-list">
    {if $consultorio_virtual.idconsultorio!=""}
        <div id="div_consultorio_virtual" class="dc-consultorio-item-box">
            <div class="dc-consultorio-item" id="consultorio-item-{$consultorio_virtual.idconsultorio}">
                <figure>
                    <i class="icon-doctorplus-consultorio-virtual"></i>
                </figure>
                <h4> {"Consultorio Virtual"|x_translate} </h4>

                <div class="okm-row dc-consultorio-action-row">
                    <div class="dc-consultorio-action-col">
                        <a href="javascript:;" class="btnEditarConsultorio btn-agregar-horario" data-idconsultorio="{$consultorio_virtual.idconsultorio}" >
                            {"Agregar horario"|x_translate}   
                        </a>
                    </div>
                    <div class="dc-consultorio-action-col">
                        <a href="javascript:;" class="dc-modal-del eliminar-consultorio" data-name='{"Consultorio Virtual"|x_translate}' data-idconsultorio="{$consultorio_virtual.idconsultorio}"  >
                            {"Eliminar"|x_translate}  
                        </a>
                    </div>
                </div>
            </div>
        </div>
    {else}
        <div id="div_consultorio_virtual" class="dc-consultorio-item-box empty">
            <a href="javascript:;" class="btnAddConsultorioVirtual" >
                <div class="dc-consultorio-item">
                    <figure>
                        <i class="icon-doctorplus-consultorio-virtual"></i>
                    </figure>
                    <h4>{"Agregar Consultorio Virtual"|x_translate}</h4>

                    <div class="okm-row dc-consultorio-action-row">

                        <i class="icon-doctorplus-circle-plus"></i>

                    </div>
                </div>
            </a>
        </div>
    {/if}


    {if $consultorios[0].idconsultorio!=""}
        <div class="dc-consultorio-item-box">
            <div class="dc-consultorio-item" id="consultorio-item-{$consultorios[0].idconsultorio}">
                <figure>
                    <i class="icon-doctorplus-map-plus-rounded"></i>
                </figure>
                <h4>{"Consultorio Físico"|x_translate}</h4>

                <div class="okm-row dc-consultorio-action-row">
                    <div class="dc-consultorio-action-col">
                        <a href="javascript:;" class="btnEditarConsultorio btn-agregar-horario" data-idconsultorio="{$consultorios[0].idconsultorio}">
                            {"Agregar horario"|x_translate}
                            {*<i class="icon-doctorplus-pen"></i>*}
                        </a>
                    </div>
                    <div class="dc-consultorio-action-col">
                        <a href="javascript:;" class="dc-modal-del eliminar-consultorio" data-name='{"Consultorio Físico"|x_translate}' data-idconsultorio="{$consultorios[0].idconsultorio}" data-placement="bottom" >
                            {"Eliminar"|x_translate}
                            {*<i class="icon-doctorplus-trash"></i>*}
                        </a>
                    </div>
                </div>
            </div>
        </div>



    {else}
        <div class="dc-consultorio-item-box empty">
            <a href="javascript:;" class="btnAddConsultorio">
                <div class="dc-consultorio-item">
                    <figure>
                        <i class="icon-doctorplus-map-plus-rounded"></i>
                    </figure>
                    <h4>{"Agregar Consultorio Físico"|x_translate}</h4>

                    <div class="okm-row dc-consultorio-action-row">

                        <i class="icon-doctorplus-circle-plus"></i>

                    </div>
                </div>
            </a>
        </div>
    {/if}

</div>
<!-- Modal consultorio eliminado-->
<div id="modal-eliminar-consultorio" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">

        <div class="modal-content" id="dc-del-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon consultorios"><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                <h4 class="modal-title">{"¿Está seguro que desea eliminar el consultorio?"|x_translate}</h4>
                <p id="nombre-consultorio-modal-eliminar" class="dc-consultorio-modal "></p>
                <h4 class="modal-title modal-consulorios-disclaimer">{"En el caso de que tuviese pacientes con turnos confirmados les notificaremos que los mismos quedan cancelados."|x_translate} </h4>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-alert" data-dismiss="modal" aria-label="Close"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                    <a href="javascript:;" class="btn-default" id="btnEliminarConsultorio" data-idconsultorio=""><i class="icon-doctorplus-check-thin"></i> {"aceptar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>

{literal}
    <script>
        $(function () {
            //actualizo el contador de consultorios
            $("#cant_consultorios").html($(".btnEditarConsultorio").length);


            //elimnar el consultorio, seteamos los valores y desplegamos modal
            $(".eliminar-consultorio").click(function () {
                var nombre = $(this).data("name");
                var idconsultorio = $(this).data("idconsultorio");
                $("#btnEliminarConsultorio").data("idconsultorio", idconsultorio);
                $("#nombre-consultorio-modal-eliminar").html(nombre);
                $("#modal-eliminar-consultorio").modal("show");
            });
            //Agregar consultorio fisica
            $(".btnAddConsultorio").click(function () {

                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'consultorio-medico.do',
                        '',
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            if (data.result) {
                                x_loadModule('usuario', 'datos_consultorios_items', '', 'div_items_consultorios');
                                x_loadModule('usuario', 'datos_consultorios_form', 'idconsultorio=' + data.id, 'div_consultorio');

                            }
                        }
                );
            });
            $(".btnAddConsultorioVirtual").click(function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'consultorio-virtual-medico.do',
                        '',
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                x_loadModule('usuario', 'datos_consultorios_items', '', 'div_items_consultorios');
                                x_loadModule('usuario', 'datos_consultorios_form', 'idconsultorio=' + data.id, 'div_consultorio');

                            }
                            if (data.result && data.showModal) {
                                x_alert(x_translate("Se han completado sus datos profesionales minimos para poder operar en DoctorPlus"), function () {
                                    recargar(BASE_PATH + "panel-medico/");
                                });
                            } else {
                                x_alert(data.msg);
                            }

                        }

                );
            });

            //CONFIRMAR Eliminar consultorio
            $("#btnEliminarConsultorio").click(function () {
                var idconsultorio = $(this).data("idconsultorio");
                if (parseInt(idconsultorio) > 0) {
                    $("#Main").spin("large");

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'eliminar_consultorio.do',
                            'id=' + idconsultorio,
                            function (data) {

                                $("#Main").spin(false);
                                $("#modal-eliminar-consultorio").modal("hide");

                                if (data.result) {
                                    x_alert(x_translate("Se dio de baja el consultorio"));

                                    //recargamos los items de consultorios
                                    x_loadModule('usuario', 'datos_consultorios_items', '', 'div_items_consultorios');
                                    //limpiamos los horarios
                                    $("#div_consultorio").empty();

                                } else {
                                    x_alert(x_translate("Se produjo un error al eliminar el consultorio"));
                                }

                            }
                    );
                }

            });

            //Editar consultorio - Agregar horarios
            $(".btnEditarConsultorio").click(function () {

                var idconsultorio = $(this).data("idconsultorio");
                if (parseInt(idconsultorio) > 0) {
                    x_loadModule('usuario', 'datos_consultorios_form', 'idconsultorio=' + idconsultorio, 'div_consultorio').then(function () {
                        $('html, body').animate({scrollTop: $("#div_horarios").offset().top - 50}, 1000);
                    });
                }
            });

        });
    </script>
{/literal}

{* metodo para simular click en en agregar horario dependiendo de si es virtual o presencial *}
{if $idconsultorio !='' && $asignarhorario=='1'}
    <script>
        $(function () {
            var idconsultorio = {$idconsultorio};
            $(".btnEditarConsultorio[data-idconsultorio='" + idconsultorio + "']").trigger("click");
        });
    </script>
{/if}