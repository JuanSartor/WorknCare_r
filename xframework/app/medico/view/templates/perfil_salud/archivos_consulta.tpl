<div class="row">
    <div class="col-sm-12 col-md-10 col-md-offset-1">
        <input type="hidden" id="cantidad_imagenes_modulo" value="{$cantidad_imagenes}"/>
        <header>
            <h3><span class="fui-folder"></span>{"Archivos"|x_translate}</h3>
            <ul>
                <li><a href="javascript:;" id="view_thumbs"><span class="fui-list-small-thumbnails"></span></a></li>
                <li><a href="javascript:;" id="view_list" class="active"><span class="fui-list-columned"></span></a></li>
            </ul>
        </header>	

        <div class="table-responsive table-nueva-consulta"  id="row_list">
            <table class="table table-striped">
                <tbody>
                    {if $listado_imagenes}
                    {foreach from=$listado_imagenes item=key}
                    <tr id="tr_imagen_{$key.idperfilSaludEstudios}">
                        <td><img alt="{$key.titulo}" src="{$key.path_images}" /></td>
                        <td><span>{if $key.titulo != ""}{$key.titulo}{else} - {/if}</span></td>
                        <td><span>{if $key.fecha != ""}{$key.fecha|date_format:"%d/%m/%Y"}{else} - {/if}</span></td>
                        <td>
                            <label for="archive-{$key.idperfilSaludEstudios}" class="checkbox check_delete"><input data-nombrearchivo="{$key.nombre_archivo}" type="checkbox" value="{$key.idperfilSaludEstudios}" id="archive-{$key.idperfilSaludEstudios}"></label>
                        </td>
                    </tr>
                    {/foreach}
                    {/if}

                </tbody>
            </table>
        </div>
        <!--@tabla -->




        <div class="row sub-grid-fix" id="row_thumb" style="display:none">
            {if $listado_imagenes}
            {foreach from=$listado_imagenes item=key}
            <div class="col-sm-4 col-md-2 item" id="div_image_{$key.idperfilSaludEstudios}">
                <img alt="{$key.titulo}" src="{$key.path_images}" width="110px" height="110px"/>
                <span>{if $key.fecha != ""}{$key.fecha|date_format:"%d/%m/%Y"}{else} - {/if}</span>
                <span>{if $key.titulo != ""}{$key.titulo}{else} - {/if}</span>
                <div class="item-hover-panel">
                    <div class="item-hover-panel-btn-holder">	
                        <a href="javascript:;" class="delete_estudio" data-id="{$key.idperfilSaludEstudios}"><span class="fui-trash"></span></a>
                        <a href="{$key.path_images}" data-title="{$key.nombre_archivo}" data-lightbox="example-set" ><span class="fui-search"></span></a>
                    </div>
                </div>
            </div>
            {/foreach}
            {/if}
        </div>

        <!-- Modal Eliminar -->
        <div class="modal fade" id="table-modal">
            <div class="modal-dialog modal-imagenes">
                <div class="modal-content">
                    <div class="modal-text">{"¿Está seguro que desea eliminar los archivos seleccionados?"|x_translate}</div>
                    <div class="modal-btns">
                        <button data-dismiss="modal" id="cancelar_multiple_files">{"Cancelar"|x_translate}</button>
                        <button id="eliminar_multiple_files">{"Aceptar"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="opciones-archivos clearfix">
            <a href="#" class="btn btn-md btn-primary modal-btn" data-target="table-modal" role="button"><span class="fui-trash"></span>{"Eliminar"|x_translate}</a>
            <a class="btn btn-md btn-primary" data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=compartir" data-target="#winModal" role="button"><span class="fui-link"></span>{"Compartir con un colega"|x_translate}</a>
        </div>				

        <!--/@grilla-->		
    </div>
</div>

{literal}
<script>
    $(document).ready(function() {
        $(".delete_estudio_table").click(function() {
            var id = $(this).data("id");

            var dom_id = "div_image_" + id;

            jConfirm({
                title: x_translate("Eliminar Imagen"),
                text: x_translate('Desea eliminar la imagen del estudio?'),
                confirm: function() {
                    $("#" + dom_id).spin("large");

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'eliminar_imagen_estudio_medico.do',
                            'id=' + id,
                            function(data) {
                                $("#" + dom_id).spin(false);
                                x_alert(data.msg);
                                if (data.result) {

                                    //Actualizo la cantidad de imágenes
                                    $("#cantidad_imagenes").val(parseInt($("#cantidad_imagenes").val()) - 1);

                                    if ($("#cantidad_imagenes").val() == 0) {
                                        $("#p_cant_imagenes").html("Vous avez pas de fichiers");
                                    } else {
                                        $("#strong_cant_imagenes").html($("#cantidad_imagenes").val() + " fichiers");
                                    }



                                    $("#" + dom_id).remove();
                                    $("#tr_imagen_" + id).remove();
                                }
                            }
                    );
                },
                cancel: function() {

                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });
        });


        $("#eliminar_multiple_files").click(function() {
            var ids = "";

            $.each($(".check_delete").find("[type=checkbox]:checked"),
                    function(index, value) {
                        ids += "," + $(this).val();
                        //console.log($(this).val());
                    });

            if (ids.length > 0) {
                ids = ids.substring(1);
            } else {
                $("#cancelar_multiple_files").click();
                x_alert(x_translate("No hay archivos seleccionados"));
                return false;
            }

            $("#row_list").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'eliminar_multiple_imagen_estudio_medico.do',
                    'ids=' + ids,
                    function(data) {
                        x_alert(data.msg);
                        $("#row_list").spin(false);
                        if (data.result) {
                            //Actualizo la cantidad de imágenes


                            $.each($(".check_delete").find("[type=checkbox]:checked"),
                                    function(index, value) {
                                        $("#cantidad_imagenes").val(parseInt($("#cantidad_imagenes").val()) - 1);

                                        $("#div_image_" + $(this).val()).remove();

                                        $("#tr_imagen_" + $(this).val()).remove();

                                        //console.log($(this).val());
                                    });

                        }
                        $("#cancelar_multiple_files").click();
                    }
            );
        });


        $("#view_thumbs").click(function() {
            $(this).addClass("active");
            $("#view_list").removeClass("active");
            $("#row_thumb").show();
            $("#row_list").hide();
        });

        $("#view_list").click(function() {
            $(this).addClass("active");
            $("#view_thumbs").removeClass("active");
            $("#row_thumb").hide();
            $("#row_list").show();
        });
    });


</script>
{/literal}