<style>
    #section_btns{
        margin-bottom: 36px;
    }
</style>

{if $paciente}
    {if $smarty.request.print==1}
        {include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
    {else}
        {include file="perfil_salud/menu_perfil_salud.tpl"}
    {/if}
    {if $smarty.request.registro_consultas_medicas!="1"}


        <section class="container-fluid">
            <div class="row ">
                <div class="col-md-12">
                    <div class="container">
                        <ol class="breadcrumb">
                            <li><a  class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                            <li class="active">{"Registro consultas médicas"|x_translate}</li>
                        </ol>
                    </div>
                </div>
            </div>
        </section>
    {/if}


    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />





    <div id="div_mis_registros_paciente">
        {include file="perfil_salud/mis_registros_pacientes.tpl"}
    </div>
    <!-- /Mis registros del paciente -->

    <!-- Registros de otros profesionales -->
    <div id="div_registros_otros_profesionales" style="display:none">


    </div>


    <div id="div_historico_consultas"></div>


    <div class="row" id="section_btns">
        <div class="col-sm-12 text-center">
            <a class="btn btn-inverse" onclick="window.history.back();">{"volver"|x_translate}</a>
            {if $account.medico.acceso_perfil_salud=="1"}
                <a href="javascript:;" id="btnRegistrosOtrosProfesionales"  class="btn btn-primary">
                    <span>{"Registros de otros profesionales"|x_translate}</span>
                </a>	
            {/if}
            <a href="javascript:;" id="btnMisRegistros" style="display:none;" class="btn btn-primary">
                <span>{"Mis Registros del paciente"|x_translate}</span>
            </a>	
        </div>			
    </div>


    <!--	Modal Imprimir consultas medicas	-->

    {if $smarty.request.mis_registros_consultas_medicas!="1"}
        <div id="modal-imprimir-registros-consultas-medicas" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title">{"Imprimir registro de consulta médicas"|x_translate}</h4>


                    </div>
                    <div class="modal-body">
                        <p>
                            {"Ingrese el rango de búsqueda de Registros de consultas médicas que desea imprimir"|x_translate}
                        </p>


                        <form id="f_imprimir_registro_consultas" action="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registros_consultas_medicas_imprimir/" target="_blank" method="post" >


                            <div class="pul-col-x2">
                                <div class="mapc-input-line">
                                    <label class="mapc-label">{"Fecha desde"|x_translate}</label>

                                    <div id="datetimepicker1" data-date-format="DD/MM/YYYY">
                                        <input id="fecha_desde" name="fecha_desde" placeholder="DD/MM/YYYY" data-title="Fecha desde" data-date-format="DD/MM/YYYY" value="" type="text">
                                        <button><i class="icon-doctorplus-calendar"></i></button>
                                    </div>
                                </div>
                            </div>
                            <div class="pul-col-x2">
                                <div class="mapc-input-line">
                                    <label class="mapc-label">{"Fecha hasta"|x_translate}</label>

                                    <div id="datetimepicker2" data-date-format="DD/MM/YYYY">
                                        <input id="fecha_hasta" name="fecha_hasta" placeholder="DD/MM/YYYY" data-title="Fecha hasta" data-date-format="DD/MM/YYYY" value="" type="text">
                                        <button><i class="icon-doctorplus-calendar"></i></button>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <div class="modal-perfil-completo-action-holder">
                            <button id="btnImprimirResigtroConsultas"><i class="icon-doctorplus-print"></i>{"Imprimir"|x_translate}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    {/if}



    {if $smarty.request.otros_profesionales==1}
        <script>
            $(function () {
                $("#div_mis_registros_paciente").hide();
                $("body").spin("large");
                x_loadModule('perfil_salud', 'registros_otros_profesionales', 'do_reset=1&idpaciente=' + $("#idpaciente").val(), 'div_registros_otros_profesionales', BASE_PATH + "medico").then(function () {

                    $("#btnRegistrosOtrosProfesionales").hide();
                    $("#div_registros_otros_profesionales").show();
                    $("#btnMisRegistros").show();
                });
            });
        </script>
    {/if}

    {x_load_js}

{/if}