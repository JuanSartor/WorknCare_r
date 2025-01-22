{if $smarty.request.print==1}
    {include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
    {include file="perfil_salud/menu_perfil_salud.tpl"}

    <section class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                        <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                        <li><a class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                        <li class="active">{"Estudios e imágenes"|x_translate}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>
{/if}
{*<section class="module-header estudio-imagenes-header container">
<div class="row">
<div class="col-md-10 col-md-offset-1">
<div class="row"><figure class="circle-icon-images"></figure></div>
<div class="row">
<h1>{"Estudios e imágenes"|x_translate}</h1>
</div>
</div>
</div>
</section>*}

<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<div class="modal fade modal-type-2" id="modal_compartir_estudio" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<script>
    $(document).ready(function (e) {
        $('#ver-archivo, #modal_compartir_estudio').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });
    });
</script> 



<section class="estudio-imagenes-grid container">
    <header>
        <h3><span class="fui-folder"></span>{"Estudios e imágenes"|x_translate}</h3>
        <ul>
            {if $listado_imagenes}
                <li><a href="javascript:;" id="view_thumbs" class="active"><span class="fui-list-small-thumbnails"></span></a></li>
                <li><a href="javascript:;" id="view_list"><span class="fui-list-columned"></span></a></li>
                    {/if}
        </ul>
    </header>	
    <div id="div_perfil_estudios_imagenes">
        {if !$paciente || !$listado_imagenes}

            <div class="sin-registros">
                <i class="fui-clip"></i>
                <h6>{"¡La sección está vacía!"|x_translate}</h6>
                <p>{"Aquí podrá almacenar archivos de estudios realizados."|x_translate}
                    <br> 
                    {"Una manera práctica y segura que le evitará extravíos, le permitirá tenerlos siempre a su alcance y en caso de desearlo compartirlos con otros profesionales."|x_translate}</p>
            </div>

        {else}

            <div class="row sub-grid-fix" id="div_list_table_thumb">		
                {foreach from=$listado_imagenes.rows item=estudio}
                    <div class="col-sm-4 col-xs-6 col-md-2 item">
                        <label for="archive-th-{$estudio.idperfilSaludEstudios}" class="checkbox">
                            <input class="input_check_thumb" data-nombrearchivo="{$estudio.nombre_archivo}" data-locationarchivo="{$estudio.list_imagenes.0.path_images}" type="checkbox" value="{$estudio.idperfilSaludEstudios}" id="archive-th-{$estudio.idperfilSaludEstudios}">
                        </label>

                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo">
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
                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo">
                                        <img alt="{$estudio.titulo}" src="{$estudio.list_imagenes.0.path_images}" >
                                    </a>
                                </td>
                                <td><a href="javascript:;" class="modal-btn" data-target="ver-archivo" role="button">{$estudio.titulo}</a></td>
                                <td>
                                    <label for="archive-list-{$estudio.idperfilSaludEstudios}" class="checkbox">
                                        <input type="checkbox" class="input_check_list" data-locationarchivo="{$estudio.list_imagenes.0.path_images}" data-nombrearchivo="{$estudio.nombre_archivo}" id="archive-list-{$estudio.idperfilSaludEstudios}">
                                    </label>
                                </td>
                            </tr>
                        {/foreach}

                    </tbody>
                </table>
            </div>

            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="perfil_salud" submodulo="perfil_estudios_imagenes_module" container_id="div_perfil_estudios_imagenes"}

        {/if}

    </div>
</section>
{x_load_js}
