{if $listado_recetas && $listado_recetas|@count > 0}
    <header>
        <h3><span class="fui-folder"></span>{"Recetas"|x_translate}</h3>
    </header>	
    <div class="table-responsive table-nueva-consulta" id="table_archivos">
        <table class="table table-striped">
            <tbody>

                {foreach from=$listado_recetas item=receta}
                    {foreach from=$receta.list_archivos item=archivo_receta}
                        <tr id="tr_imagen_{$archivo_receta.idperfilSaludRecetaArchivo}">

                            <td class="icon-file">
                                <a  href="{$archivo_receta.path}" title="{$archivo_receta.nombre_archivo}" target="_blank">
                                    <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png"> 
                                </a>
                            </td>
                            <td>
                                <a  href="{$archivo_receta.path}" title="{$archivo_receta.nombre_archivo}" target="_blank"><span>{if $receta.tipo_receta != ""}{$receta.tipo_receta}{else} - {/if}</span>    </a>
                            </td>

                            <td class="text-center check_delete">
                                <button class="eliminar-receta" title='{"Eliminar"|x_translate}' data-id="{$archivo_receta.idperfilSaludRecetaArchivo}">
                                    <span class="fui-trash"></span>&nbsp;<span class="hidden-xs">{"Eliminar"|x_translate}</span>
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                {/foreach}

            </tbody>
        </table>
    </div>

    <div class="clearfix"></div>
    {literal}
        <script>
            $(document).ready(function () {

                renderUI2("table_archivos");

                //eliminar recetas
                $(".eliminar-receta").click(function () {
                    var id = $(this).data("id");
                    if (id == "") {
                        x_alert(x_translate("No hay recetas seleccionadas"));
                        return false;
                    }


                    jConfirm({
                        title: x_translate("Eliminar receta"),
                        text: x_translate('Desea eliminar las recetas seleccionadas?'),
                        confirm: function () {
                            $("body").spin("large");

                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'drop_multiple_recetas.do',
                                    'ids=' + id,
                                    function (data) {

                                        $("body").spin(false);
                                        if (data.result) {
                                            //Actualizo el listado
                                            x_loadModule('perfil_salud', 'list_archivos_receta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_receta', BASE_PATH + "medico");

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
                });


            });


        </script>
    {/literal}
{/if}