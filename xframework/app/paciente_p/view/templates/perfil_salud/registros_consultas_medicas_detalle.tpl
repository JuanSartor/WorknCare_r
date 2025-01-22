<link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/conclusion-medica.css?v={$smarty.now|date_format:"%j"}" />
{if $paciente}
    {*
    {include file="perfil_salud/menu_perfil_salud.tpl"}
    *}
    {if $consulta.consulta_express|@count > 0 ||  $consulta.videoconsulta|@count > 0}
        <nav class="section-header ce-ca-top profile">
            <div class="container">
                <div class="user-select pull-left user-select-sonsulta-express-rsp">
                    <h1 class="section-name">
                        {if $consulta.consulta_express|@count > 0}
                            <i class="icon-doctorplus-chat"></i>
                            <a class="consulta-express-tittle-lnk" href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a>
                        {/if}
                        {if $consulta.videoconsulta|@count > 0}
                            <i class="icon-doctorplus-video-call"></i>
                            <a class="consulta-express-tittle-lnk mvc-guia-title" href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a>
                        {/if}
                    </h1>
                </div>

                <div class="clearfix"></div>
            </div>
        </nav>
    {/if}
    <section class="container-fluid hidden-xs">
        <div class="row ">
            <div class="col-md-12">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/registro-consultas-medicas.html">{"Registro consultas medicas"|x_translate}</a></li>
                        <li class="active">{"Detalle consulta médica"|x_translate}</li>
                        {if $consulta.numeroConsultaExpress !=""}<li class="active">{"Consulta Express"|x_translate} Nº{$consulta.numeroConsultaExpress}</li>{/if}
                        {if $consulta.numeroVideoConsulta !=""}<li class="active">{"Video Consulta"|x_translate} Nº{$consulta.numeroVideoConsulta}</li>{/if}
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />

    <section class="okm-container nueva-consulta pps-chat-tabs-section">
        <div class="no-gutter consulta-container">
            <div class="col-md-3  pull-left col-xs-12" >
                {include file="perfil_salud/registros_consultas_medicas_menu.tpl"}
            </div>		
            <div class="col-md-9 pull-right col-xs-12">
                <div class="row tab-content view-doctor">
                    <!-- Anotaciones -->
                    {include file="perfil_salud/registros_consultas_medicas_anotaciones.tpl"}

                    <!-- Medicamentos -->
                    {include file="perfil_salud/registros_consultas_medicas_medicamentos.tpl"}

                    <!-- Recetas -->
                    {include file="perfil_salud/registros_consultas_medicas_recetas.tpl"}

                    <!-- Estudios - Archivos -->
                    {include file="perfil_salud/registros_consultas_medicas_estudios.tpl"}

                    <!-- Mensajes -->
                    {include file="perfil_salud/registros_consultas_medicas_mensajes.tpl"}

                </div>
            </div>
        </div>
        <div class="row button-container text-center"> 
            <button class="btn btn-inverse" onclick="window.history.back();">{"volver"|x_translate}</button>
        </div>
        <div class="clearfix">&nbsp;</div>
        {include file="home/modal_display_file.tpl"}
        <!-- Recomendacion -->
        {include file="perfil_salud/registros_consultas_medicas_recomendacion.tpl"}
    </section>

    <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
        <div class="modal-dialog">
            <div class="modal-content">
            </div>
        </div>
    </div>

    <!--Modal Medico perfil action-->
    <div class="modal fade  modal-medico-perfil" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    {if $consulta.medico_imagen.list!=""}
                        <img class="mps-modal-medico-img" src="{$consulta.medico_imagen.list}" alt="{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}" style="width:100px">
                    {else}
                        <img class="mps-modal-medico-img" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}" style="width:100px">
                    {/if}
                    <span class="mps-modal-medico">{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}</span>

                    <span class="mps-modal-especialidad">{$consulta.especialidades.especialidad}</span>
                </div>
                <div class="modal-footer">
                    <div class="mps-modal-action-holder">
                        <a href="javascript:;" class="select-profesional-frecuente" data-id="{$consulta.medico_idmedico}">
                            <figure><i class="icon-doctorplus-chat"></i></figure>
                            <span >{"Consulta Express"|x_translate}</span>
                        </a>
                        <a href="{$url}panel-paciente/profesionales/{$consulta.medico_idmedico}-{$consulta.nombre|str2seo}-{$consulta.apellido|str2seo}.html">
                            <figure><i class="icon-doctorplus-calendar-time"></i></figure>
                            <span>{"Solicitar turno"|x_translate}</span>
                        </a>
                    </div>	
                </div>
            </div>
        </div>
    </div>


    {literal}
        <script>
            $(document).ready(function () {

                renderUI2("table_archivos");
                $('#ver-archivo, #modal_compartir_estudio').on('hidden.bs.modal', function () {
                    $(this)
                            .removeData('bs.modal')
                            .find(".modal-content").html('');
                });


                //botones para crear la consulta express asociada a un medico
                $(".modal-medico-perfil .select-profesional-frecuente").click(function () {
                    var idmedico = $(this).data('id');
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'set_medico_consultaexpress.do',
                            'medico_idmedico=' + idmedico,
                            function (data) {

                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                } else {
                                    x_alert(data.msg);
                                }

                            }

                    );

                });

            });


        </script>
    {/literal}
{/if}