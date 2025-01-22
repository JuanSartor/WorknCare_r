<section class="consultas-grid-block-holder container-fluid">
    {if $listado}
        <div class="row">
            <div class="col-sm-12">
                <ul>
                    <li></li>
                    <li><a id="btnMostrarTarjeras" href="javascript:;"><span class="fui-list-small-thumbnails"></span></a></li>
                    <li><a id="btnMostrarListado" href="javascript:;" class="active"><span class="fui-list-columned"></span></a></li>
                </ul>
            </div>
        </div>
    {else}
        <div class="sin-registros">
            {*<i class="dpp-consulta"></i>*}
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>
                {"Ud no tiene registros de consultas médicas."|x_translate}
            </p>
            <div class="clearfix">&nbsp;</div>
            <a href="{$url}panel-paciente/" class="btn btn-xs btn-secondary ">{"volver"|x_translate}</a>
        </div>
    {/if}
</section>
{if $listado}
    <div id="div_listado_registros_profesionales">
        <section id="tarjetas-cont" class="antecedentes-ginecologicos container-fluid">
            <div class="row">
                <div class="col-sm-10 col-sm-offset-1 col-md-10 col-md-offset-1">
                    <div class="row">
                        {foreach from=$listado item=medico}

                            <div class="col-sm-4 consultas-card-left">
                                <div class="consultas-card">
                                    <h3>{$medico.especialidad}</h3>
                                    <label class="consultas-card-diagnostico">{"Diagnóstico"|x_translate}</label>
                                    <p>{$medico.diagnostico}</p>
                                    <label>{"Ultima consulta"|x_translate}</label>
                                    <span>{$medico.fecha_format}</span>
                                    {if $medico.consultaExpress_idconsultaExpress!=""}
                                        <figure class="green-circle circle-55 card-circle">

                                            <i class="icon-doctorplus-chat"></i>
                                        </figure>
                                    {/if}

                                    {if $medico.videoconsulta_idvideoconsulta!=""}
                                        <figure class="green-circle circle-55 card-circle">
                                            <i class="icon-doctorplus-video-call"></i>
                                        </figure>
                                    {/if}

                                </div>
                                <button class="btn btn-md btn-inverse consultas-card-btn btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}" >{"ver más"|x_translate}</button>
                            </div>

                        {foreachelse}
                            <div class="col-sm-4 consultas-card-left">
                                <div class="consultas-card">
                                    <p>{"No hay consultas médicas "|x_translate}</p>
                                </div>
                            </div>

                        {/foreach}

                    </div>
                </div>
            </div>
        </section>


        <section id="listado-cont"  style="display: none;" class="historico-consultas container-fluid">
            <div class="row">
                <div class="col-sm-10 col-sm-offset-1 col-md-10 col-md-offset-1 historico-consultas-holder">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="historico-consultas-table ">
                                    <thead>
                                        <tr>
                                            <td class="col-1">{"Especialidad"|x_translate}</td>
                                            <td class="col-2">{"Profesional"|x_translate}</td>
                                            <td>{"Fecha"|x_translate}</td>
                                            <td class="col-3">{"Diagnostico"|x_translate}</td>
                                            <td></td>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        {foreach from=$listado item=medico}
                                            <tr>
                                                <td><a href="javascript:;" class="btnVerMas">{$medico.especialidad}</a></td>
                                                <td>{$medico.nombre} {$medico.apellido}</td>
                                                <td>{$medico.fecha_format}</td>
                                                <td>{$medico.diagnostico}
                                                    <div class="iconos-tabla">
                                                        {if $medico.estudios_list!=""}
                                                            <i class="icon-doctorplus-camera"></i>
                                                        {/if} 
                                                        {if $medico.consultaExpress_idconsultaExpress!=""}
                                                            <i class="icon-doctorplus-chat"></i>
                                                        {/if}
                                                        {if $medico.videoconsulta_idvideoconsulta!=""}
                                                            <i class="icon-doctorplus-video-call"></i>
                                                        {/if}
                                                    </div>
                                                </td>
                                                <td><button class="btnVerMas"data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}"><span class="fui-arrow-right "></span></buton></td>
                                            </tr>
                                        {foreachelse}
                                            <tr>
                                                <td colspan="5">{"No hay consultas médicas"|x_translate}</td>
                                            </tr>
                                        {/foreach}

                                        <!-- /ROW + Collapse -->								
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


        $('#listado-cont .expand-table').children("tbody").children(" tr:even").click(function (e) {
            if ($(this).data('display') == 1) {
                $(this).data('display', 0);
                $(this).next().removeClass('next-tr');
                $(this).children().eq(3).children().eq(0).removeClass('expanded');
            } else {
                $(this).data('display', 1);
                $(this).next().addClass('next-tr');
                $(this).children().eq(3).children().eq(0).addClass('expanded');
            }
        });



        $(".btnVerMas").click(function () {
            $("#is_listado_registro_profesionales").val("0");
            $("#div_registros_otros_profesionales").hide();
            $("#div_registros_historico_consultas").show();
            x_loadModule('perfil_salud', 'registros_historico_consultas', 'do_reset=1&idespecialidad=' + $(this).data("idespecialidad") + '&idpaciente=' + $("#idpaciente").val() + '&idmedico=' + $(this).data("idmedico"), 'div_historico_consultas', BASE_PATH + "paciente_p");
            $("#div_historico_consultas").show();
        });

        $("#btnMostrarTarjeras").click(function () {


            $("#listado-cont").fadeOut();
            $("#tarjetas-cont").fadeIn("slow");


        });

        $("#btnMostrarListado").click(function () {

            $("#tarjetas-cont").fadeOut();
            $("#listado-cont").fadeIn("slow");



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