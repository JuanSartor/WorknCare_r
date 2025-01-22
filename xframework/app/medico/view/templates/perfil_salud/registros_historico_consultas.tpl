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
                                    <tr class="ver-conclusion" data-id="{$consulta.idperfilSaludConsulta}"  data-src="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}">

                                        <td class="text-center">{$consulta.fecha_format}</td>
                                        <td>{$consulta.medico.nombre} {$consulta.medico.apellido} (<em>{$consulta.medico.mis_especialidades.0.especialidad})
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

                                {/foreach}            

                            </tbody>
                        </table>
                    </div>

                    <div class="paginas">

                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="perfil_salud" submodulo="mis_registros_pacientes"  container_id="div_mis_registros_paciente" params="idpaciente=$idpaciente"}

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

{literal}
    <script>


        renderUI2("div_historico_consultas");


        $('.nueva-consulta .tab-buttons .nav-tabs li a').on("click", function () {
            $('#div_historico_consultas .slider-for').slick('setPosition');
        });
        
         $(".ver-conclusion").click(function () {
            $("body").spin("large");
            window.location.href = $(this).data("src");
        });

    </script>
{/literal}