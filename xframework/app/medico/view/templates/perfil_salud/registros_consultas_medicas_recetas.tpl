<!-- Recetas-->
{if $consulta.recetas_list|@count > 0}
    <div role="tabpanel" class="w tab-pane fade" id="agregar-recetas">
        <div class="form-content">


            <div class="row">
                <div class="col-md-12">
                    <div class="table-responsive table-nueva-consulta">
                        <table class="table table-striped table-mis-prescripciones mps-table">
                            <thead>
                                <tr>
                                    <td style="width: 10%;">&nbsp;</td>
                                    <td class="col-wide">{"Tipo"|x_translate}</td>

                                </tr>
                            </thead>
                            <tbody>

                                {foreach from=$consulta.recetas_list item=receta}
                                    {foreach from=$receta.list_archivos item=archivo_receta}
                                        <tr id="tr_imagen_{$archivo_receta.idperfilSaludRecetaArchivo}">

                                            <td>
                                                <a  href="{$url}get_receta_prof.do?id={$archivo_receta.idperfilSaludRecetaArchivo}" title="{$archivo_receta.nombre_archivo}" target="_blank">
                                                    {*<a  href="{$archivo_receta.path}" title="{$archivo_receta.nombre_archivo}" target="_blank">*}
                                                    <img class="img-responsive" src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png"> 
                                                </a>
                                            </td>
                                            <td>
                                                {*<a  href="{$archivo_receta.path}" title="{$archivo_receta.nombre_archivo}" target="_blank">*}
                                                <a  href="{$url}get_receta_prof.do?id={$archivo_receta.idperfilSaludRecetaArchivo}" title="{$archivo_receta.nombre_archivo}" target="_blank">
                                                    <span>{if $receta.tipo_receta != ""}{$receta.tipo_receta}{else} - {/if}</span>    </a>
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
            </div>
        </div>
    </div>
{/if}