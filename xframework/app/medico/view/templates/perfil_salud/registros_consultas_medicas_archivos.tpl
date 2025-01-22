{if $consulta.estudios_list && $consulta.estudios_list|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="agregar-archivo">
        <div class="form-content">

            <div class="estudio-imagenes-grid nueva-consulta-grid">
                <header>
                    <h3><span class="fui-folder"></span>{"Estudios e Imágenes"|x_translate}</h3>
                </header>	

                {if $consulta.estudios_list && $consulta.estudios_list|@count > 0}
                    <div class="table-responsive table-nueva-consulta">
                        <table class="table table-striped mps-archivos-table">
                            <tbody>
                                {foreach from=$consulta.estudios_list item=estudio}
                                    <tr>
                                        <td>
                                            <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo" role="button">
                                                <img alt="{$estudio.titulo}" src="{$estudio.list_imagenes.0.path_images}">
                                            </a>
                                        </td>
                                        <td>
                                            <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo" role="button">
                                                {if $estudio.titulo != ""}
                                                    {$estudio.titulo}
                                                {else} 
                                                    - 
                                                {/if}
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                {/if}
            </div>		
        </div>						
    </div>
{/if}