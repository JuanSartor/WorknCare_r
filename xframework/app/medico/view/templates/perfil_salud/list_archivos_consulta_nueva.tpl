{if $listado_imagenes && $listado_imagenes|@count > 0}
    <header>
        <h3><span class="fui-folder"></span>{"Archivos adjuntos"|x_translate}</h3>
    </header>	
    <div class="table-responsive table-nueva-consulta" id="table_archivos">
        <table class="table table-striped">
            <tbody>
                {if $listado_imagenes && $listado_imagenes|@count > 0}
                    {foreach from=$listado_imagenes item=key}
                        <tr id="tr_imagen_{$key.idperfilSaludEstudios}">
                            <td class="icon-file">
                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$key.idperfilSaludEstudios}" data-target="#ver-archivo">
                                    <img alt="{$key.titulo}" src="{$key.list_imagenes.0.path_images}"/>
                                </a>
                            </td>
                            <td>
                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$key.idperfilSaludEstudios}" data-target="#ver-archivo">
                                    <span>{if $key.titulo != ""}{$key.titulo}{else} - {/if}</span>
                                </a>
                            </td>
                            <td class="text-center check_delete">

                                <button class="btn-delete-file" title='{"Eliminar"|x_translate}' data-id="{$key.idperfilSaludEstudios}">
                                    <span class="fui-trash"></span>&nbsp;<span class="hidden-xs">{"Eliminar"|x_translate}</span>
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                {/if}
            </tbody>
        </table>
    </div>


    {literal}
        <script>
            $(document).ready(function () {

                renderUI2("table_archivos");
                /*Boton eliminar - Desplegar modal confirmacon eliminar archivos*/
                $(".btn-delete-file").click(function () {
                    var id = $(this).data("id");
                    jConfirm({
                        title: x_translate("Eliminar"),
                        text: x_translate("Desea eliminar los archivos seleccionados?"),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_multiple_imagen_estudio_medico.do',
                                    'ids=' + id,
                                    function (data) {

                                        $("body").spin(false);
                                        if (data.result) {
                                            //Actualizo el listado
                                            x_loadModule('perfil_salud', 'list_archivos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_consulta', BASE_PATH + "medico");
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