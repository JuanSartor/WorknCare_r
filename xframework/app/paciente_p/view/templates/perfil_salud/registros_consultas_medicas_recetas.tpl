{if $consulta.recetas_list|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="div_archivos_receta">
        <div class="form-content">


            <div class="row">
                <div class="col-md-12">
                    <div class="table-responsive table-nueva-consulta">
                        <table class="table table-striped table-mis-prescripciones mps-archivos-table">

                            <tbody>

                                {foreach from=$consulta.recetas_list item=receta}
                                    {foreach from=$receta.list_archivos item=archivo_receta}
                                        <tr id="tr_imagen_{$archivo_receta.idperfilSaludRecetaArchivo}">

                                            <td>
                                                <a  href="{$url}get_receta.do?id={$archivo_receta.idperfilSaludRecetaArchivo}" title="{$archivo_receta.nombre_archivo}" target="_blank">
                                                    <img  src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png"> 
                                                </a>                                                    
                                            </td>
                                            <td class="">
                                                <a  href="{$url}get_receta.do?id={$archivo_receta.idperfilSaludRecetaArchivo}" title="{$archivo_receta.nombre_archivo}" target="_blank"><span>{if $receta.tipo_receta != ""}{$receta.tipo_receta}{else} - {/if}</span>    </a>
                                            </td>

                                            <td  class="pull-right">
                                                <label for="receta-{$archivo_receta.idperfilSaludRecetaArchivo}" class="radio check_receta"><input  name="receta" id="receta-{$archivo_receta.idperfilSaludRecetaArchivo}" type="radio" value="{$archivo_receta.idperfilSaludRecetaArchivo}"><span class="hidden-xs">{"Seleccionar"|x_translate}</span></label>
                                            </td>
                                        </tr>


                                    {/foreach}
                                {foreachelse}
                                    <tr>
                                        <td collspan="5">{"No hay recetas para la consulta"|x_translate}</td>
                                    </tr>
                                {/foreach}

                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="col-md-12 text-center">
                    <p>{"Imprima la receta electrónica y preséntela en la farmacia."|x_translate}</p> 
                    <p>{"Puede sino enviarla directamente en forma remota, solo tendrá que recuperarla cuando se presente!"|x_translate}</p>
                    <div class="clearfix">&nbsp;</div>
                    <div class="col-md-4 col-md-offset-4">
                        <input type="text" id="email-receta" class="form-control"  name="email-receta" placeholder="Email">
                    </div>

                    <div class="col-md-4">
                        <a href="javascript:;" class="btn btn-md btn-default btn-primary" id="enviar-recetas"><span class="fui-mail"></span>{"Enviar por email"|x_translate}</a>
                    </div>

                </div>
            </div>
        </div>

    </div>
{/if}
{literal}
    <script>
        $(function () {
            //enviar por mail
            $("#enviar-recetas").click(function () {


                if ($("#div_archivos_receta .check_receta").find("[type=radio]:checked").val()) {

                    var id = $("#div_archivos_receta .check_receta").find("[type=radio]:checked").val();


                    if ($("#email-receta").val() == "" || !validarEmail($("#email-receta").val())) {
                        x_alert(x_translate("Ingrese un email válido"));
                        return false;
                    }

                    jConfirm({
                        title: x_translate("Enviar receta"),
                        text: x_translate('Desea enviar las recetas seleccionadas a:') + " " + $("#email-receta").val() + "?",
                        confirm: function () {
                            $("#div_archivos_receta").spin("large");

                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'enviar_recetas.do',
                                    'id=' + id + "&email=" + $("#email-receta").val(),
                                    function (data) {
                                        x_alert(data.msg);
                                        $("#div_archivos_receta").spin(false);
                                        if (data.result) {
                                            $("#email-receta").val("");
                                        }

                                    }
                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                } else {
                    x_alert(x_translate("No hay recetas seleccionadas"));
                    return false;
                }
            });
        });
    </script>
{/literal}