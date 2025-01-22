    
{if $paciente}

    {if $smarty.request.print==1}
        {include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
    {else}
        {include file="perfil_salud/menu_perfil_salud.tpl"}
        <section class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div class="container">
                        <ol class="breadcrumb">
                            <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                            <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                            <li><a  class="nombre_paciente"  href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                            <li class="active">{"Medicamentos"|x_translate}</li>
                        </ol>
                    </div>
                </div>
            </div>
        </section>
    {/if}


    {*<section class="module-header medicamentos-header container-fluid" >
    <div class="row">
    <div class="col-md-12">
    <figure class="circle-icon-images"></figure>
    <h1>{"Medicamentos"|x_translate}</h1>
        
    </div>
    </div>
    </section>*}




    {if $list_medicacion_actual}

        <section class="container-fluid" id="section_medicacion_actual">
            <div class="row">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="module-subheader">
                        <h3>{"Medicación actual del paciente"|x_translate}</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-medicamentos">
                            <thead>
                                <tr>
                                    <td>{"Profesional"|x_translate}</td>
                                    <td>{"Medicamento"|x_translate}</td>
                                    <td>{"Posología"|x_translate}</td>
                                    <td class="date">{"Inicio"|x_translate}</td>
                                    <td class="date">{"Fin"|x_translate}</td>
                                </tr>
                            </thead>
                            <tbody>

                                {if $list_medicacion_actual}
                                    {foreach from=$list_medicacion_actual item=medicacion_actual}
                                        <tr>
                                            <td> 
                                                {if $medicacion_actual.receto_especialidad==1}
                                                    {$medicacion_actual.especialidad}
                                                {else}

                                                    {if $medicacion_actual.medico_idmedico==""}

                                                    {else}
                                                        {if $medicacion_actual.medico_idmedico != $idmedico}
                                                            <a href="javascript:;" class="modal-btn" data-target="ver-info-doctor-{$medicacion_actual.medico_idmedico}" role="button"><span>{$medicacion_actual.titulo_profesional} {$medicacion_actual.nombre} {$medicacion_actual.apellido}</span>{$medicacion_actual.especialidad|truncate:20:"...":true}</a>
                                                            <!-- Modal ver info doctor -->


                                                            <div class="modal fade" id="ver-info-doctor-{$medicacion_actual.medico_idmedico}">
                                                                <div class="modal-dialog">
                                                                    <div class="modal-content">
                                                                        <div class="tab-content view-doctor">
                                                                            <div role="tabpanel" id="doctor-info" class="w tab-pane active fade in">
                                                                                <div class="doctor-info">
                                                                                    {if $medicacion_actual.image.list != ""}
                                                                                        <img src="{$medicacion_actual.image.list}" height="106" width="105" alt="">
                                                                                    {else}
                                                                                        <img src="{$IMGS}temp/info-doctor.gif" height="106" width="105" alt="">
                                                                                    {/if}

                                                                                    <h4>{$medicacion_actual.titulo_profesional} {$medicacion_actual.nombre} {$medicacion_actual.apellido}</h4>
                                                                                    <p>

                                                                                        {$medicacion_actual.especialidad} <br>
                                                                                    </p>
                                                                                </div>
                                                                                <div class="options">
                                                                                    <a href="#enviar-mensaje" role="tab" data-toggle="tab" class="dp-email" title='{"Enviar Mensaje"|x_translate}'></a>
                                                                                    <a href="#" class="dp-vcard" target="_blank" title='{"Ver ficha"|x_translate}'></a>
                                                                                </div>
                                                                            </div>
                                                                            <div id="enviar-mensaje" role="tabpanel" class="w tab-pane fade">
                                                                                <form action="" method="">
                                                                                    <h5 class="modal-header">{"Mensaje"|x_translate}</h5>

                                                                                    <div class="form-content">
                                                                                        <p class="to">{"A: "|x_translate}<span>{$medicacion_actual.titulo_profesional} {$medicacion_actual.nombre} {$medicacion_actual.apellido}</span></p>
                                                                                        <p><textarea name="" id=""  placeholder='{"Escriba aqui su consulta"|x_translate}'></textarea></p>
                                                                                    </div>
                                                                                    <div class="modal-btns">
                                                                                        <button></button>
                                                                                    </div>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        {else}
                                                            <span>{$medicacion_actual.titulo_profesional} {$medicacion_actual.nombre} {$medicacion_actual.apellido}</span><br>{$medicacion_actual.especialidad|truncate:20:"...":true}
                                                            <!-- Modal ver info doctor -->
                                                        {/if}
                                                    {/if}
                                                {/if}
                                            </td>
                                            <td>{$medicacion_actual.nombre_medicamento}</td>
                                            <td>{$medicacion_actual.posologia}</td>
                                            <td class="text-center">{$medicacion_actual.fecha_inicio_f}</td>
                                            <td class="text-center">
                                                {if $medicacion_actual.fecha_fin_f !=""}
                                                    {$medicacion_actual.fecha_fin_f}
                                                {elseif $medicacion_actual.tipoTomaMedicamentos_idtipoTomaMedicamentos == 1}
                                                    {"Medicación Crónica"|x_translate}
                                                {elseif $medicacion_actual.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                                                    {"Temporal"|x_translate}
                                                {/if}
                                            </td>

                                        </tr>
                                    {/foreach}
                                {/if}


                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
            <!--@tabla -->
        </section>
    {else}
        <section class="module-header medicamentos-header container-fluid" id="section_medicacion_actual">
            <div class="row">
                <div class="col-md-12">
                    <figure class="circle-icon-images"></figure>
                    <h1>{"Medicación actual del paciente"|x_translate}</h1>
                    <p class="notice">{"No hay medicación actual del paciente"|x_translate}</p>
                </div>
            </div>
        </section>
    {/if}


    {if $list_medicacion_medico}
        <section class="container-fluid" style="display:none" id="section_medicacion_mis_prescripciones">
            <div class="row">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="module-subheader">
                        <h3>{"Histórico de medicación"|x_translate}</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-mis-prescripciones">
                            <thead>
                                <tr>
                                    <td>{"Profesional"|x_translate}</td>
                                    <td class="col-wide">{"Medicamento"|x_translate}</td>
                                    <td>{"Posología"|x_translate}</td>
                                    <td class="date">{"Inicio"|x_translate}</td>
                                    <td class="date">{"Fin"|x_translate}</td>
                                </tr>
                            </thead>
                            <tbody>

                                {foreach from=$list_medicacion_medico item=medicacion_medico}
                                    <tr>
                                        <td><span>{$medicacion_medico.titulo_profesional} {$medicacion_medico.nombre} {$medicacion_medico.apellido}</span><br>{$medicacion_medico.especialidad|truncate:20:"...":true}</td>
                                        <td>{$medicacion_medico.nombre_medicamento}</td>
                                        <td>{$medicacion_medico.posologia}</td>
                                        <td>{$medicacion_medico.fecha_inicio_f}</td>
                                        <td>
                                            {if $medicacion_medico.fecha_fin_f !=""}
                                                {$medicacion_medico.fecha_fin_f}
                                            {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 1}
                                                {"Medicación Crónica"|x_translate}
                                            {elseif $medicacion_medico.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                                                {"Temporal"|x_translate}
                                            {/if}
                                        </td>
                                    </tr>								
                                {/foreach}

                            </tbody>
                        </table>
                    </div>

                </div>
            </div>

        </section>	
    {else}
        <section class="module-header medicamentos-header container-fluid" id="section_medicacion_mis_prescripciones" style="display:none">
            <div class="row">
                <div class="col-md-12">
                    <figure class="circle-icon-images"></figure>
                    <h1>{"Histórico de medicación"|x_translate}</h1>
                    {if !$list_medicacion_medico}
                        <p class="notice">{"Ud. no ingreso aún ninguna prescipción para el paciente"|x_translate}</p>
                    {/if}
                </div>
            </div>
        </section>

    {/if}

    {if $smarty.request.print!="1"}
        <section class="container-fluid">
            <div class="row">
                <div class="col-md-12 text-center">
                    <a href="javascript:;" id="btnMedicacionActual" style="display:none" class="btn btn-primary"><span>{"Medicación actual del paciente"|x_translate}</a>	

                    <a href="javascript:;" id="btnMisPrescripciones" class="btn btn-primary"><span>{"Histórico de medicación"|x_translate}</a>	
                    <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/consultanueva.html"  class="btn btn-primary">{"Agregar Prescripción"|x_translate}</a>

                </div>
            </div>
        </section>
    {/if}
    <p><div class="clearfix"></div></p>
<input type="hidden" id="idpaciente" value="{$paciente.idpaciente}"/>

{literal}
    <script>
        $("ul.slider-menu li a").removeClass("active");
        $("ul.slider-menu li i.dpp-medicina").parent().addClass("active");

        $("#btnMedicacionActual").click(function () {
            $("#section_medicacion_mis_prescripciones").hide();
            $("#section_medicacion_actual").show();
            $("#btnMedicacionActual").hide();
            $("#btnMisPrescripciones").show();

        });

        $("#btnMisPrescripciones").click(function () {
            $("#section_medicacion_mis_prescripciones").show();
            $("#section_medicacion_actual").hide();
            $("#btnMedicacionActual").show();
            $("#btnMisPrescripciones").hide();
        });

        $('.modal-btn').on('click', function () {
            var targetId = '#' + $(this).data('target');
            $(targetId).modal();
        });



    </script>
{/literal}

{/if}