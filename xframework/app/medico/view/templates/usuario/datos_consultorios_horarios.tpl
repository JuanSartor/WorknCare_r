
<div class="row">
    <div class="col-md-10 col-md-offset-1">

        <h4 class="mul-form-tittle dc-horarios-consultorio-title">
            {if $consultorio.is_virtual=="1"}
                <i class="icon-doctorplus-consultorio-virtual dc-title-icon"></i>
                {"Consultorio Virtual"|x_translate}

            {else}
                <i class="icon-doctorplus-map-plus-rounded dc-title-icon"></i>
                {"Consultorio Físico"|x_translate}
            {/if}
        </h4>
    </div>
</div>

<div class="row">
    <div class="col-md-10 col-md-offset-1">
        <ul class="dc-horarios-tab okm-row">
            <li>
                <div class="dc-horarios-tab-header">{"Lunes"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_1" class="tagsinput tag-trg" data-role="tagsinput" value="" />
                    </div>
                </div>
            </li>

            <li>
                <div class="dc-horarios-tab-header">{"Martes"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_2" class="tagsinput tag-trg" data-role="tagsinput" value="" />
                    </div>
                </div>
            </li>

            <li>
                <div class="dc-horarios-tab-header">{"Miércoles"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_3" class="tagsinput tag-trg" data-role="tagsinput" value="" />
                    </div>
                </div>
            </li>

            <li>
                <div class="dc-horarios-tab-header">{"Jueves"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_4" class="tagsinput tag-trg" data-role="tagsinput" value="" />
                    </div>
                </div>
            </li>

            <li>
                <div class="dc-horarios-tab-header">{"Viernes"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_5" class="tagsinput tag-trg" data-role="tagsinput" value="" />
                    </div>
                </div>
            </li>

            <li>
                <div class="dc-horarios-tab-header">{"Sábado"|x_translate}</div>
                <div class="dc-horarios-tab-day-content">
                    <div class="tagsinput-primary okm-tags-no-margin">
                        <input id="tagsinput_dia_6" class="tagsinput tag-trg" data-role="tagsinput" value="" />

                    </div>
                </div>
            </li>

        </ul>

        <hr>
    </div>
</div>

<!-- Modal eliminar turno -->
<div id="modal-eliminar-turnos" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">

    <div class="modal-dialog modal-lg" role="document">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon consultorios"><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                <h4 class="modal-title modal-consulorios-disclaimer">
                    {"En el caso de que tuviese pacientes con turnos confirmados en los días y horarios cancelados les notificaremos que los mismos quedan cancelados."|x_translate} 
                </h4>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-alert" data-dismiss="modal" aria-label="Close"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                    <a href="javascript:;" id="btnAceptarEliminarConfiguracion" data-id="" class="btn-default"><i class="icon-doctorplus-check-thin"></i> {"aceptar"|x_translate}</a>

                </div>
            </div>
        </div>



    </div>
</div>

{*agregamos los tags input*}
<script>

    $(function (){ldelim}
            //inicializamos los tagsinput
    {for $dia=1 to 6}

            $("#tagsinput_dia_{$dia}").tagsinput({ldelim}
                        itemValue: 'id',
                        itemText: 'text'
        {rdelim});
    {/for}

                //iteramos para todos los horarios de cada dia
    {foreach from = $horarios item = dia}
        {foreach from = $dia item = un_horario}
                $("#tagsinput_dia_{$un_horario.dia_iddia}").tagsinput("add", {ldelim}
                            "id": "{$un_horario.idconfiguracionAgenda}",
                            "text": "{$un_horario.desde|date_format:'%H:%M'} a {$un_horario.hasta|date_format:'%H:%M'}"{rdelim});
        {/foreach}
    {/foreach}

    {rdelim});
</script>

{literal}
    <script>
        $(function () {


            $("#btnAceptarEliminarConfiguracion").click(function () {
                var id = $(this).data("id");
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'eliminar_horario.do',
                        'id=' + id,
                        function (data) {
                            $("body").spin(false);

                            if (data.result) {
                                $("#modal-eliminar-turnos").modal("hide");
                                scrollToEl($("#div_horarios_cont"));
                                x_loadModule('usuario', 'datos_consultorios_horarios', 'idconsultorio=' + $("#horario_idconsultorio").val(), 'div_horarios_cont');
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            });


            //accion a remover el tag -> eliminanos la asociacion y quitamos el tag
            $('#div_horarios_cont .tagsinput').on('beforeItemRemove', function (event) {


                var id = event.item.id;
                $("#btnAceptarEliminarConfiguracion").data("id", id);
                event.cancel = true;
                $("#modal-eliminar-turnos").modal("show");



            });
        });
    </script>
{/literal}
