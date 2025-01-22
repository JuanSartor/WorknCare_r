<section class="consultas-grid-block-holder container-fluid">
    <div class="row">
        <div class="col-md-12">

            <div class="module-subheader">
                <input type="hidden" id="is_listado_registro_profesionales" value="1" />
                <h2 class="dp-add-user">
                    {"Registros de otros profesionales"|x_translate}
                </h2>
            </div>
            {if !$listado}
                <div class="sin-registros">
                    <h6>{"¡La sección está vacía!"|x_translate}</h6>
                    <p>{"El paciente no tiene registros de otros profesionales"|x_translate}.</p>
                </div>
            {/if}
        </div>	

    </div>
</section>


{if $listado}
    <div id="div_listado_registros_profesionales">

        <section id="listado-cont" class="historico-consultas container-fluid">
            <div class="row">
                <div class="col-sm-10 col-sm-offset-1 col-md-10 col-md-offset-1">
                    <div class="row">
                        <div class="col-sm-12">
                            <div >
                                <table class="table historico-consultas-table expand-table">
                                    <thead>
                                        <tr>
                                            <td class="text-center">{"Fecha"|x_translate}</td>
                                            <td class="">{"Profesional"|x_translate}</td>
                                            <td></td>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        {foreach from=$listado item=medico}
                                            <tr class="btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}">
                                                <td class="text-center">{$medico.fecha_format}</td>
                                                <td>{$medico.nombre} {$medico.apellido} (<em>{$medico.especialidad}</em>)
                                                    <div class="iconos-tabla hidden-xs">
                                                        {if $medico.estudios_list!=""}
                                                            <i class="fui-clip"></i>
                                                        {/if} 
                                                        {if $medico.consultaExpress_idconsultaExpress!=""}
                                                            <i class="icon-doctorplus-chat"></i>
                                                        {/if}
                                                        {if $medico.videoconsulta_idvideoconsulta!=""}
                                                            <i class="icon-doctorplus-video-call"></i>
                                                        {/if}
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    {"Ver"|x_translate}&nbsp;<i class="fui-arrow-right"></i>
                                                </td>
                                            </tr>
                                        {foreachelse}
                                            <tr>
                                                <td colspan="5">{"No hay consultas históricas"|x_translate}</td>
                                            </tr>
                                        {/foreach}
							
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>	
    </div>

{/if}






{literal}
    <script>

        $("body").spin(false);

        $(".btnVerMas").click(function () {
            $("#is_listado_registro_profesionales").val("0");
            $("#div_registros_otros_profesionales").hide();
            $("#div_registros_historico_consultas").show();
            x_loadModule('perfil_salud', 'registros_historico_consultas', 'do_reset=1&idespecialidad=' + +$(this).data("idespecialidad") + '&idpaciente=' + $("#idpaciente").val() + '&idmedico=' + $(this).data("idmedico"), 'div_historico_consultas', BASE_PATH + "medico");
            $("#div_historico_consultas").show();
        });



        $("#a_reload_otros_profesionales").click(function () {
            if ($("#is_listado_registro_profesionales").val() == "1") {
                //Tengo que poner visible  "section_btns"
                $("#div_registros_otros_profesionales").hide();
                $("#section_btns").show();
            } else {
                $("#is_listado_registro_profesionales").val("1");
                $("#div_ver_mas_registros_otros_profesionales").empty();
                $("#div_listado_registros_profesionales").show();
            }
        });
    </script>
{/literal}