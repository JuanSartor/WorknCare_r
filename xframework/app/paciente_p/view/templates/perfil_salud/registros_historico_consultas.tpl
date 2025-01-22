<section class="historico-consultas container-fluid">
    <div class="row">
        <div class="col-sm-10 col-sm-offset-1 col-md-10 col-md-offset-1">
            <div class="row">
                <div class="col-sm-12">
                    <div id="registros-paciente">
                        <table class="table historico-consultas-table expand-table">
                            <thead>
                                <tr>
                                    <td class="text-center">{"Fecha"|x_translate}</td>
                                    <td class="text-center">{"Profesional"|x_translate}</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$listado.rows item=consulta name=foo}
                                    <tr class="ver-conclusion" data-id="{$consulta.idperfilSaludConsulta}">
                                        <td class="text-center">{$consulta.fecha_format}</td>
                                        <td>{$consulta.medico.nombre} {$consulta.medico.apellido} (<em>{$consulta.medico.mis_especialidades.0.especialidad}</em>)
                                      
                                            <div class="iconos-tabla hidden-xs">
                                                {if $consulta.estudios_list!=""} 
                                                    <i class="fui-clip"></i>
                                                {/if} 

                                                {if $consulta.consultaExpress_idconsultaExpress!="" } 
                                                    <i class="icon-doctorplus-chat"></i>
                                                {elseif $consulta.videoconsulta_idvideoconsulta != ""}
                                                    <i class="icon-doctorplus-video-call"></i>
                                                {/if}
                                            </div>	
                                        </td>
                                        <td class="text-center">
                                            {"Ver"|x_translate}&nbsp;<i class="fui-arrow-right"></i>
                                        </td>
                                    </tr>
                                    <tr class="full-width">
                                        <td colspan="5">
                                            <div class="expand-content">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- /ROW + Collapse -->
                                {/foreach}            

                            </tbody>
                        </table>
                    </div>


                    <div class="paginas">
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="perfil_salud" submodulo="registros_historico_consultas" container_id="div_historico_consultas"  params="idpaciente=$idpaciente&idespecialidad=$idespecialidad"}
                    </div>
                </div>
            </div>
        </div> 
    </div>


</section>

{literal}
    <script>

        $(function () {
            $(".ver-conclusion").click(function () {
                $("body").spin("large");
                window.location.href = BASE_PATH + "panel-paciente/perfil-salud/registros-consultas-medicas-detalle/" + $(this).data("id");
            });
        });
        renderUI2("div_historico_consultas");

    </script>
{/literal}