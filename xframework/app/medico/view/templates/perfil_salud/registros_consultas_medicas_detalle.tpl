<link rel="stylesheet" type="text/css" href="{$url}xframework/app/medico/view/css/conclusion-medica.css" />

{if $paciente}
    {*
    {if $smarty.request.mis_registros_consultas_medicas!="1"}
    {include file="perfil_salud/menu_perfil_salud.tpl"}
    {/if}
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
                    <br>
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                        <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                        <li><a  class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                        <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html">{"Registro consultas médicas"|x_translate}</a></li>
                        <li class="active">{"Detalle consulta médica"|x_translate}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>



    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />
    <input type="hidden" id="nombre_paciente" value="{$paciente.nombre|str2seo}" />
    <input type="hidden" id="apellido_paciente" value="{$paciente.apellido|str2seo}" />





    <div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
        <div class="modal-dialog">
            <div class="modal-content"></div>
        </div>
    </div>


    {if $smarty.request.mis_registros_consultas_medicas!="1" && $no_medico_frecuente=="1"}
        <section class="container nueva-consulta" id="nueva-consulta">


            <div class="module-subheader">
                <h2 class="dp-info" ><a href="javascript:;" onclick="window.history.back();"><img style="cursor: pointer" id="btnReloadBack" src="{$IMGS}icons/icon-reload.svg" alt=""></a>{"No es posible visualizar esta consulta médica"|x_translate}</h2>

            </div>	
        </section>

    {else}

        <section class="okm-container nueva-consulta" id="nueva-consulta">

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
        </section>
        <input type="hidden" id="url_paciente_seo" value="{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/"/>
        {include file="home/modal_display_file.tpl"}
    {/if}

    {literal}
        <script>
            $(function () {

                $("#btnImpresionPerfilSalud").attr("href", BASE_PATH + "panel-medico/mis-pacientes/" + $("#url_paciente_seo").val() + "/registros_consultas_medicas_imprimir/" + $("#idperfilSaludConsulta").val());

                renderUI2("table_archivos");
                $('#ver-archivo, #modal_compartir_estudio').on('hidden.bs.modal', function () {
                    $(this)
                            .removeData('bs.modal')
                            .find(".modal-content").html('');
                });

            });
        </script>
    {/literal}

{/if}