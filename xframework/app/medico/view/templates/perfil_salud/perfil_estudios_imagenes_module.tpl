{if !$paciente || !$listado_imagenes}

    <div class="sin-registros">
        <i class="fui-clip"></i>
        <h6>{"¡La sección está vacía!"|x_translate}</h6>
        <p>{"Aquí podrá almacenar archivos de estudios realizados."|x_translate} <br> {"Una manera práctica y segura que le evitará extravíos, le permitirá tenerlos siempre a su alcance y en caso de desearlo compartirlos con otros profesionales."|x_translate}</p>
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
    <!--/vista tabla -->

    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="perfil_salud" submodulo="perfil_estudios_imagenes_module" container_id="div_perfil_estudios_imagenes"}

{/if}