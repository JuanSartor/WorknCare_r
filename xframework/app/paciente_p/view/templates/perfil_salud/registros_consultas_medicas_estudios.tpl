{if ($consulta.estudios_list && $consulta.estudios_list|@count > 0) ||( $consulta.adjuntos_list && $consulta.adjuntos_list|@count > 0)}

    <div role="tabpanel" class="w tab-pane fade" id="agregar-archivo">
        <div class="form-content">

            <div class="estudio-imagenes-grid nueva-consulta-grid">
                <header>
                    <h3><span class="fui-folder"></span> {"Estudios e Imágenes"|x_translate}</h3>
                </header>	

                <div class="table-responsive table-nueva-consulta">
                    <table class="table table-striped mps-archivos-table">
                        <tbody>
                            {foreach from=$consulta.estudios_list item=estudio}
                                <tr>
                                    <td>
                                        <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo" role="button">
                                            <img alt="{$estudio.titulo}" src="{$estudio.list_imagenes.0.path_images}">
                                        </a>
                                    </td>
                                    <td>
                                        <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$estudio.idperfilSaludEstudios}" data-target="#ver-archivo" role="button">
                                            {if $estudio.titulo != ""}
                                                {$estudio.titulo}
                                            {else} 
                                                - 
                                            {/if}
                                        </a>
                                    </td>
                                </tr>
                            {/foreach}
                            {foreach from=$consulta.adjuntos_list item=adjunto}
                                {foreach from=$adjunto.list_archivos item=archivo_adjunto}
                                    <tr id="tr_imagen_{$archivo_adjunto.idperfilSaludAdjuntoArchivo}">
                                        <td>
                                            <a  href="{$archivo_adjunto.path}" title="{$archivo_adjunto.nombre_archivo}" target="_blank">
                                                <img class="img-responsive" src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png"> 
                                            </a>
                                        </td>
                                        <td>
                                            <a  href="{$archivo_adjunto.path}" title="{$archivo_adjunto.nombre_archivo}" target="_blank">

                                                <span>{if $archivo_adjunto.nombre_archivo != ""}{$archivo_adjunto.nombre_archivo}{else} - {/if}</span>    </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            {/foreach}
                        </tbody>
                    </table>
                </div>


            </div>		


        </div>						
    </div>
{/if}