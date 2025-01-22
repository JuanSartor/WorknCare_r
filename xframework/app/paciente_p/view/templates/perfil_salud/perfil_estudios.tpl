{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Estudios e imágenes"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}

<input type="hidden" id="cantidad_imagenes" value="{$cantidad_imagenes}">
<section class="module-header estudio-imagenes-header container ajustes-panel-paciente">
    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="row"><figure class="circle-icon-images"></figure></div>
            <div class="row">
                <h1>{"Estudios e imágenes"|x_translate}</h1>
            </div>
        </div>
    </div>
</section>

<section class="estudio-imagenes-files container">
    <div class="row">
        <div class="col-sm-12 col-md-8" id="div_dropzone">

        </div>
        <div class="col-sm-12 col-md-3">
            <div class="files-panel">
                <h3><span class="fui-folder"></span> {"Mis estudios"|x_translate}</h3>
                {if $cantidad_imagenes}
                    <p id="p_cant_imagenes">{"Ud. tiene [[{$cantidad_imagenes}]] estudios en esta sección"|x_translate}</p>
                {else}
                    <p>{"Ud. no tiene estudios en esta sección"|x_translate}</p>
                {/if}
            </div>
        </div>
    </div>
</section>	

<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content">

        </div>
    </div>
</div>

<script>
    $(document).ready(function (e) {
        $('#ver-archivo').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });
    });
</script> 

<br>

<div id="div_list_images">

    <input type="hidden" id="ids_win" />

    <section class="estudio-imagenes-grid container" id="section_list_images" style="display: block">
        <header>
            <h3><span class="fui-folder"></span> {"Estudios e imágenes"|x_translate}</h3>
            <ul>
                {if $listado_imagenes}
                    <li>
                        <a href="javascript:;" id="view_thumbs" class="active"><span class="fui-list-small-thumbnails"></span></a>
                    </li>
                    <li>
                        <a href="javascript:;" id="view_list"><span class="fui-list-columned"></span></a>
                    </li>
                {/if}
            </ul>
        </header>


        {if !$paciente || !$listado_imagenes}

            <div class="sin-registros">
                <i class="fui-clip"></i>
                <h6>{"¡La sección está vacía!"|x_translate}</h6>
                <p>{"Aquí podrá almacenar archivos de estudios realizados."|x_translate}
                    <br>{"Una manera práctica y segura que le evitará extravíos, le permitirá tenerlos siempre a su alcance y en caso de desearlo compartirlos con otros profesionales."|x_translate}</p>
            </div>


        {else}

            <div class="row sub-grid-fix" id="div_list_table_thumb">		
                {foreach from=$listado_imagenes.rows item=estudio}
                    <div class="col-sm-4 col-xs-6 col-md-2 item">
                        <label for="archive-th-{$estudio.idperfilSaludEstudios}" class="checkbox">
                            <input class="input_check_thumb" data-nombrearchivo="{$estudio.nombre_archivo}" type="checkbox" value="{$estudio.idperfilSaludEstudios}" id="archive-th-{$estudio.idperfilSaludEstudios}">
                        </label>

                        <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo">
                            <img alt="{$estudio.titulo}" src="{$estudio.list_imagenes.0.path_images}" width="110px" height="110px"/>
                        </a>
                        <span>{$estudio.fecha|date_format:"%Y/%m/%d"}</span>
                        <span>{$estudio.titulo}</span>
                    </div>
                {/foreach}
            </div>
            <!--/vista thumbs-->

            <div class="table-responsive table-nueva-consulta" id="div_list_table_list" style="display: none">
                <table class="table table-striped">
                    <tbody>
                        {foreach from=$listado_imagenes.rows item=estudio}
                            <tr>
                                <td>
                                    <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo">
                                        <img alt="{$estudio.titulo}" src="{$estudio.list_imagenes.0.path_images}">
                                    </a>
                                </td>
                                <td><a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo" role="button">{$estudio.titulo}</a></td>
                                <td>
                                    <label for="archive-list-{$estudio.idperfilSaludEstudios}" class="checkbox">
                                        <input type="checkbox" class="input_check_list" data-nombrearchivo="{$estudio.nombre_archivo}" id="archive-list-{$estudio.idperfilSaludEstudios}" value="{$estudio.idperfilSaludEstudios}">
                                    </label>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <!--/vista tabla -->

            <div class="text-right clearfix">
                <a href="javascript:;" class="btn btn-md btn-red modal-btn" data-target="table-modal" role="button"><span class="fui-trash"></span>{"Eliminar"|x_translate}</a>
            </div>	

            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="perfil_salud"  submodulo="perfil_estudios_module" container_id="div_list_images"}

            <!-- /paginas -->
        {/if}
    </section>


    <div class="modal fade" id="table-modal">
        <div class="modal-dialog modal-imagenes">
            <div class="modal-content">
                <div class="modal-text">
                    {"¿Está seguro que desea eliminar los estudios seleccionados?"|x_translate}
                </div>
                <div class="modal-btns">
                    <button data-dismiss="modal">{"cancelar"|x_translate}</button>
                    <button id="btnAceptarEliminacion">{"aceptar"|x_translate}</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    {literal}
        <script>
            $("#view_thumbs").click(function () {
                $("#view_list").removeClass("active");
                $(this).addClass("active");
                $("#div_list_table_thumb").show();
                $("#div_list_table_list").hide();
            });

            $("#view_list").click(function () {
                $("#view_thumbs").removeClass("active");
                $(this).addClass("active");
                $("#div_list_table_thumb").hide();
                $("#div_list_table_list").show();
            });




            $("#btnAceptarEliminacion").click(function () {
                var classe = "input_check_list";
                if ($("#view_thumbs").hasClass("active") != false) {
                    //Si está en la vista thumb
                    classe = "input_check_thumb";
                }

                var ids = "";
                $("#ids_win").val("");

                $.each($("." + classe + ":checked"),
                        function (index, value) {

                            ids += "," + $(this).val();

                        });

                $("#ids_win").val(ids);

                if ($("#ids_win").val() != "") {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "eliminar_imagenes_estudios.do",
                            'ids=' + $("#ids_win").val(),
                            function (data) {

                                if (data.result) {
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }
                            });
                } else {
                    x_alert(x_translate("No hay imágenes seleccionadas"));
                    return false;
                }
            });

            $(':checkbox').radiocheck();


        </script>
    {/literal}
</div>

{x_load_js}
{if $smarty.request.show_all=="1"}
    <script>
        $(function () {

            $('html, body').animate({
                scrollTop: $("#div_list_images").offset().top
            }, 1000);
        });
    </script>
{/if}