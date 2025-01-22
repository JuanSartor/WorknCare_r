{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Medicamentos"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}
<section class="module-header medicamentos-header container ajustes-panel-paciente">
    <div class="row">
        <div class="col-md-12">
            <figure class="circle-icon-images"></figure>
            <h1>{"Medicamentos"|x_translate}</h1>
            <!-- <p class="notice">Ud. no ingreso aún ninguna prescipción para el paciente</p> -->
        </div>
    </div>
</section>


<input type="hidden" id="is_actual" value="1"/>

<div id="div_medicacion_actual" style="display: none">
    <section class="container-fluid">
        <div class="row">
            <div class="col-sm-12 col-md-10 col-md-offset-1">
                <div class="module-subheader">
                    <h3>{"Medicación actual"|x_translate}	
                        <br>
                        <a href="javascript:;" id="ver_thumb"><span class="fui-list-small-thumbnails"></span></a>
                        <a href="javascript:;" id="ver_row"><span class="fui-list-columned"></span></a>
                    </h3>
                </div>
            </div>
        </div>
    </section>

    <section class="container-fluid" id="medicacion-actual-row">
        <div class="row">
            <div class="col-sm-12 col-md-10 col-md-offset-1">


                <div class="table-responsive">

                    <table class="table table-striped table-medicamentos">
                        <thead>
                            <tr>
                                <td>{"Rp/"|x_translate}</td>
                                <td>{"Medicamento"|x_translate}</td>
                                <td>{"Posología"|x_translate}</td>
                                <td class="date">{"Inicio"|x_translate}</td>
                                <td class="date">{"Fin"|x_translate}</td>
                                <td>{"Solicitar renovación"|x_translate}</td>
                                <td style="min-width:70px"></td>

                            </tr>
                        </thead>
                        <tbody>
                            {if $listado_medicacion_actual}
                                {foreach from=$listado_medicacion_actual item=medicacion}
                                    <tr>
                                        <td>
                                            {if $medicacion.nombre =="" && $medicacion.apellido == ""}
                                                {$medicacion.especialidad}
                                            {else}
                                                <a href="javascript:;" class="modal-btn" data-target="ver-info-doctor-{$medicacion.idperfilSaludMedicamento}" role="button"><span>{$medicacion.nombre} {$medicacion.apellido}</span>{$medicacion.especialidad}</a>
                                                <div class="modal fade" id="ver-info-doctor-{$medicacion.idperfilSaludMedicamento}">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                                                            <div class="tab-content view-doctor">
                                                                <div role="tabpanel" id="doctor-info" class="w-300 w tab-pane active fade in">
                                                                    <div class="doctor-info">
                                                                        {if $medicacion.imagen.list != ""}
                                                                            <img src="{$medicacion.imagen.list}" height="106" width="105" alt="">
                                                                        {else}
                                                                            <img src="{$IMGS}extranet/noimage_nuevomiembro.jpg" height="106" width="105" alt="">
                                                                        {/if}
                                                                        <h4>{$medicacion.tituloprofesional} {$medicacion.nombre} {$medicacion.apellido}</h4>
                                                                        <p>
                                                                            {$medicacion.especialidad} <br>
                                                                        </p>
                                                                    </div>
                                                                    <div class="options options-tres">
                                                                        <a href="#enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" role="tab" data-toggle="tab" class="dp-renew" title='{"Renovar receta"|x_translate}'>{"Renovar receta"|x_translate}</a>
                                                                        {if $medicacion.valorPinesConsultaExpress!=""} <a class="dp-express setMedicoConsultaExpress" data-idmedico="{$medicacion.medico_idmedico}" href="javascript:;" title='{"Consulta express"|x_translate}'>{"Consulta express"|x_translate}</a>{/if}
                                                                        <a href="{$url}panel-paciente/profesionales/{$medicacion.medico_idmedico}-{$medicacion.nombre|str2seo}-{$medicacion.apellido|str2seo}.html" class="dp-turno"  title='{"Solicitar turnos"|x_translate}'>{"Solicitar turnos"|x_translate}</a>
                                                                    </div>
                                                                </div>
                                                                <div id="enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" role="tabpanel" class="w tab-pane fade" >
                                                                    {if $medicacion.medico_idmedico != ""}
                                                                        <form id="solicitar-renovacion-{$medicacion.idperfilSaludMedicamento}" action="{$url}solicitar_renovacion_receta.do" method="post" onsubmit="return false;">
                                                                            <input type="hidden" name="perfilSaludMedicamento_idperfilSaludMedicamento" value="{$medicacion.idperfilSaludMedicamento}" />
                                                                            <h5 class="modal-header">{"Solicitud de Renovación de Receta"|x_translate}</h5>

                                                                            <div class="form-content">
                                                                                <dl class="dl-horizontal">
                                                                                    <dt>{"Profesional"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre} {$medicacion.apellido}</dd>
                                                                                    <dt>{"Medicamento"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre_medicamento}</dd>
                                                                                    <dt>{"Posología"|x_translate}</dt>
                                                                                    <dd>{$medicacion.posologia}</dd>
                                                                                    <dt>{"Observaciones"|x_translate}</dt>
                                                                                    <dd>{$medicacion.observaciones}</dd>
                                                                                </dl>
                                                                                <p><textarea class="h-200" name="mensajePaciente" placeholder='{"Mensaje"|x_translate}'>{$medicacion.mensajePaciente}</textarea></p>
                                                                            </div>
                                                                            <div class="modal-btns modal-btns-text">
                                                                                <button class="btnSolicitarReceta" data-id="{$medicacion.idperfilSaludMedicamento}">{"Enviar"|x_translate}</button>
                                                                            </div>
                                                                        </form>
                                                                    {else}
                                                                        <h5 class="modal-header">{"No posee médico asociado para solicitar la renovación"|x_translate}</h5>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}
                                        </td>
                                        <td>{$medicacion.nombre_medicamento}</td>
                                        <td>{$medicacion.posologia}</td>
                                        <td>{$medicacion.fecha_inicio_f}</td>
                                        <td>{$medicacion.fecha_fin_f}</td>
                                        <td>

                                            {if $medicacion.receto_medicofrecuente=="0"}
                                                <a href="javascript:;" class="renew_deactivated" data-toggle="tooltip" data-placement="right"><span class="dp-renew deactivated"></span></a>

                                            {else}
                                                <a href="javascript:;" class="modal-btn  " data-target="mdl-medicamento-{$medicacion.idperfilSaludMedicamento}" role="button"><span class="dp-renew"></span></a>

                                                <div class="modal fade" id="mdl-medicamento-{$medicacion.idperfilSaludMedicamento}">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div id="doctor-info-{$medicacion.idperfilSaludMedicamento}">
                                                                <div id="mdl-enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" >
                                                                    {if $medicacion.medico_idmedico != ""}
                                                                        <form id="solicitar-renovacion-2-{$medicacion.idperfilSaludMedicamento}" action="{$url}solicitar_renovacion_receta.do" method="post" onsubmit="return false;">
                                                                            <input type="hidden" name="perfilSaludMedicamento_idperfilSaludMedicamento" value="{$medicacion.idperfilSaludMedicamento}" />
                                                                            <h5 class="modal-header">{"Solicitud de Renovación de Receta"|x_translate}</h5>

                                                                            <div class="form-content">
                                                                                <dl class="dl-horizontal">
                                                                                    <dt>{"Profesional"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre} {$medicacion.apellido}</dd>
                                                                                    <dt>{"Medicamento"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre_medicamento}</dd>
                                                                                    <dt>{"Posología"|x_translate}</dt>
                                                                                    <dd>{$medicacion.posologia}</dd>
                                                                                    <dt>{"Observaciones"|x_translate}</dt>
                                                                                    <dd>{$medicacion.observaciones}</dd>
                                                                                </dl>
                                                                                <p><textarea class="h-200" name="mensajePaciente" placeholder='{"Mensaje"|x_translate}'>{$medicacion.mensajePaciente}</textarea></p>
                                                                            </div>
                                                                            <div class="modal-btns modal-btns-text">
                                                                                <button class="btnSolicitarReceta2" data-id="{$medicacion.idperfilSaludMedicamento}">{"Enviar"|x_translate}</button>
                                                                            </div>
                                                                        </form>
                                                                    {else}
                                                                        <h5 class="modal-header">{"No posee médico asociado para solicitar la renovación"|x_translate}</h5>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}
                                        </td>
                                        <td>
                                            {if $medicacion.alta_paciente==1}

                                                <label for="medicamento-{$medicacion.idperfilSaludMedicamento}" class="checkbox check_delete_medicamento"><input type="checkbox" value="{$medicacion.idperfilSaludMedicamento}" id="medicamento-{$medicacion.idperfilSaludMedicamento}"></label>
                                                {else}
                                                <label for="medicamento-{$medicacion.idperfilSaludMedicamento}" class="checkbox "><input type="checkbox" disabled value="" id="medicamento-{$medicacion.idperfilSaludMedicamento}"></label>

                                            {/if}

                                        </td>
                                    </tr>
                                {/foreach}
                            {else}
                                <tr>
                                    <td colspan="6">
                                        {"No posee registro de medicamentos"|x_translate}
                                    </td>
                                </tr>
                            {/if}
                        </tbody>
                    </table>

                    <div class="opciones-archivos clearfix">
                        <a href="javascript:;" class="btn btn-md btn-primary modal-btn" data-target="table-modal" role="button"><span class="fui-trash"></span>{"Eliminar"|x_translate}</a>
                    </div>

                </div>
            </div>
        </div>
        <!--@tabla -->
    </section>

    <section class="container" id="medicacion-actual-thumb" style="display: none">
        <div class="clearfix"></div>
        <div class="row">			
            {if $listado_medicacion_actual}
                {foreach from=$listado_medicacion_actual item=medicacion}
                    <article class="col-md-4">
                        <div class="card grid-overview">
                            <div class="card-header">
                                <h1 class="card-title">{"Medicamentos"|x_translate}</h1>
                                <div class="card-value value icon-card">
                                    <span class="dp-medicine"></span>
                                </div>	
                            </div>
                            <div class="card-body">
                                <div class="data"><em>{"Medicamento / droga"|x_translate}</em>{$medicacion.nombre_medicamento}</div>
                                <div class="data"><em>{"Posología / droga"|x_translate}</em>{$medicacion.posologia}</div>
                            </div>
                        </div>
                    </article>
                {/foreach}
            {/if}
            <!-- medicamentos -->						
        </div>
    </section>
</div>




<div id="div_historico_medicacion"  style="display: none">

    <section class="container-fluid" id="historico-medicacion-row">

        <div class="row">
            <div class="col-sm-12 col-md-10 col-md-offset-1">
                <div class="module-subheader">
                    <h3><a href="javascript:;" id="btnVolver"><img src="{$IMGS}icons/icon-reload.svg" alt="" width="24" class="volver"></a> {"Histórico de medicación"|x_translate}</h3>
                </div>
                <div class="table-responsive">
                    <table class="table table-striped table-medicamentos">
                        <thead>
                            <tr>
                                <td>{"Rp/"|x_translate}</td>
                                <td>{"Medicamento"|x_translate}</td>
                                <td>{"Posología"|x_translate}</td>
                                <td class="date">{"Inicio"|x_translate}</td>
                                <td class="date">{"Fin"|x_translate}</td>
                                <td>{"Solicitar renovación"|x_translate}</td>
                                <td></td>

                            </tr>
                        </thead>
                        <tbody>
                            {if $listado_medicacion_historica}
                                {foreach from=$listado_medicacion_historica item=medicacion}
                                    <tr>
                                        <td>
                                            {if $medicacion.nombre =="" && $medicacion.apellido == ""}
                                                {$medicacion.especialidad}
                                            {else}
                                                <a href="javascript:;" class="modal-btn" data-target="ver-info-doctor-{$medicacion.idperfilSaludMedicamento}" role="button"><span>{$medicacion.nombre} {$medicacion.apellido}</span>{$medicacion.especialidad}</a>
                                                <div class="modal fade" id="ver-info-doctor-{$medicacion.idperfilSaludMedicamento}">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>

                                                            <div class="tab-content view-doctor">
                                                                <div role="tabpanel" id="doctor-info" class="w-300 w tab-pane active fade in">
                                                                    <div class="doctor-info">
                                                                        {if  $medicacion.imagen.list != ""}
                                                                            <img src="{$medicacion.imagen.list}" height="106" width="105" alt="">
                                                                        {else}
                                                                            <img src="{$IMGS}extranet/noimage_nuevomiembro.jpg" height="106" width="105" alt="">
                                                                        {/if}
                                                                        <h4>{$medicacion.nombre} {$medicacion.apellido}</h4>
                                                                        <p>
                                                                            {$medicacion.especialidad} <br>
                                                                        </p>
                                                                    </div>
                                                                    <div class="options options-tres">
                                                                        <a href="#enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" role="tab" data-toggle="tab" class="dp-renew" title='{"Renovar receta"|x_translate}'>{"Renovar receta"|x_translate}</a>
                                                                        {if $medicacion.valorPinesConsultaExpress!=""}    <a href="javascript:;" class="dp-express setMedicoConsultaExpress" data-idmedico="{$medicacion.medico_idmedico}" title='{"Consulta express"|x_translate}'>{"Consulta express"|x_translate}</a>{/if}
                                                                        <a href="{$url}panel-paciente/profesionales/{$medicacion.medico_idmedico}-{$medicacion.nombre|str2seo}-{$medicacion.apellido|str2seo}.html" class="dp-turno" title='{"Solicitar turnos"|x_translate}'>{"Solicitar turnos"|x_translate}</a>
                                                                    </div>
                                                                </div>
                                                                <div id="enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" role="tabpanel" class="w tab-pane fade" >
                                                                    {if $medicacion.medico_idmedico != ""}
                                                                        <form id="solicitar-renovacion-{$medicacion.idperfilSaludMedicamento}" action="{$url}solicitar_renovacion_receta.do" method="post" onsubmit="return false;">
                                                                            <input type="hidden" name="perfilSaludMedicamento_idperfilSaludMedicamento" value="{$medicacion.idperfilSaludMedicamento}" />
                                                                            <h5 class="modal-header">{"Solicitud de Renovación de Receta"|x_translate}</h5>

                                                                            <div class="form-content">
                                                                                <dl class="dl-horizontal">
                                                                                    <dt>{"Profesional"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre} {$medicacion.apellido}</dd>
                                                                                    <dt>{"Medicamento"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre_medicamento}</dd>
                                                                                    <dt>{"Posología"|x_translate}</dt>
                                                                                    <dd>{$medicacion.posologia}</dd>
                                                                                    <dt>{"Observaciones"|x_translate}</dt>
                                                                                    <dd>{$medicacion.observaciones}</dd>
                                                                                </dl>
                                                                                <p><textarea class="h-200" name="mensajePaciente" placeholder='{"Mensaje"|x_translate}'>{$medicacion.mensajePaciente}</textarea></p>
                                                                            </div>
                                                                            <div class="modal-btns modal-btns-text">
                                                                                <button class="btnSolicitarReceta" data-id="{$medicacion.idperfilSaludMedicamento}">{"Enviar"|x_translate}</button>
                                                                            </div>
                                                                        </form>
                                                                    {else}
                                                                        <h5 class="modal-header">{"No posee médico asociado para solicitar la renovación"|x_translate}</h5>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            {/if}
                                        </td>
                                        <td>{$medicacion.nombre_medicamento}</td>
                                        <td>{$medicacion.posologia}</td>
                                        <td>{$medicacion.fecha_inicio_f}</td>
                                        <td>{$medicacion.fecha_fin_f}</td>
                                        <td> {if $medicacion.receto_medicofrecuente=="0"}
                                            <a href="javascript:;" class="renew_deactivated" data-toggle="tooltip" data-placement="right"><span class="dp-renew deactivated"></span></a>

                                            {else}
                                                <a href="javascript:;" class="modal-btn  " data-target="mdl-medicamento-{$medicacion.idperfilSaludMedicamento}" role="button"><span class="dp-renew"></span></a>

                                                <div class="modal fade" id="mdl-medicamento-{$medicacion.idperfilSaludMedicamento}">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div id="doctor-info-{$medicacion.idperfilSaludMedicamento}">
                                                                <div id="mdl-enviar-mensaje-{$medicacion.idperfilSaludMedicamento}" >
                                                                    {if $medicacion.medico_idmedico != ""}
                                                                        <form id="solicitar-renovacion-2-{$medicacion.idperfilSaludMedicamento}" action="{$url}solicitar_renovacion_receta.do" method="post" onsubmit="return false;">
                                                                            <input type="hidden" name="perfilSaludMedicamento_idperfilSaludMedicamento" value="{$medicacion.idperfilSaludMedicamento}" />
                                                                            <h5 class="modal-header">{"Solicitud de Renovación de Receta"|x_translate}</h5>

                                                                            <div class="form-content">
                                                                                <dl class="dl-horizontal">
                                                                                    <dt>{"Profesional"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre} {$medicacion.apellido}</dd>
                                                                                    <dt>{"Medicamento"|x_translate}</dt>
                                                                                    <dd>{$medicacion.nombre_medicamento}</dd>
                                                                                    <dt>{"Posología"|x_translate}</dt>
                                                                                    <dd>{$medicacion.posologia}</dd>
                                                                                    <dt>{"Observaciones"|x_translate}</dt>
                                                                                    <dd>{$medicacion.observaciones}</dd>
                                                                                </dl>
                                                                                <p><textarea class="h-200" name="mensajePaciente" placeholder='{"Mensaje"|x_translate}'>{$medicacion.mensajePaciente}</textarea></p>
                                                                            </div>
                                                                            <div class="modal-btns modal-btns-text">
                                                                                <button class="btnSolicitarReceta2" data-id="{$medicacion.idperfilSaludMedicamento}">{"Enviar"|x_translate}</button>
                                                                            </div>
                                                                        </form>
                                                                    {else}
                                                                        <h5 class="modal-header">{"No posee médico asociado para solicitar la renovación"|x_translate}</h5>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                {/if}
                                                </td>
                                                <td>
                                                    {if $medicacion.alta_paciente==1}

                                                        <label for="medicamento-{$medicacion.idperfilSaludMedicamento}" class="checkbox check_delete_medicamento"><input type="checkbox" value="{$medicacion.idperfilSaludMedicamento}" id="medicamento-{$medicacion.idperfilSaludMedicamento}"></label>
                                                        {else}
                                                        <label for="medicamento-{$medicacion.idperfilSaludMedicamento}" class="checkbox "><input type="checkbox"  disabled value="" id="medicamento-{$medicacion.idperfilSaludMedicamento}"></label>

                                                    {/if}
                                                </td>

                                            </tr>
                                            {/foreach}
                                                {else}
                                                    <tr>
                                                        <td colspan="6">{"No posee medicación histórica"|x_translate}</td>
                                                    </tr>
                                                    {/if}								
                                                    </tbody>
                                                </table>
                                                <div class="opciones-archivos clearfix">
                                                    <a href="javascript:;" class="btn btn-md btn-primary modal-btn" data-target="table-modal" role="button"><span class="fui-trash"></span>{"Eliminar"|x_translate}</a>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <!--@tabla -->
                                </section>

                                <section class="container" id="historico-medicacion-thumb" style="display: none">
                                    <div class="row">			
                                        {if $listado_medicacion_historica}
                                            {foreach from=$listado_medicacion_historica item=medicacion}
                                                <article class="col-md-4">
                                                    <div class="card grid-overview">
                                                        <div class="card-header">
                                                            <h1 class="card-title">{"Medicamentos"|x_translate}</h1>
                                                            <div class="card-value value icon-card">
                                                                <span class="dp-medicine"></span>
                                                            </div>	
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="data"><em>{"Medicamento / droga"|x_translate}</em>{$medicacion.nombre_medicamento}</div>
                                                            <div class="data"><em>{"Posología / droga"|x_translate}</em>{$medicacion.posologia}</div>
                                                        </div>
                                                    </div>
                                                </article>
                                            {/foreach}
                                        {/if}
                                    </div>
                                </section>
                            </div>

                            <!-- Formulario de prescripción-->
                            <section class="container">
                                <div class="row">
                                    <div class="col-sm-12 col-md-4">
                                        <a href="javascript:;" class="modal-btn border-box dp-plus" data-target="agregar-prescripcion" role="button"><span>{"Agregar medicación"|x_translate}</span></a>	
                                        <!-- Modal Agregar Medicación-->
                                        <div class="modal fade  modal-type-1" id="agregar-prescripcion">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <div class="modal-title pull-left">
                                                            <h5 class="dp-medicine">{"Agregar medicación"|x_translate}</h5>
                                                        </div>
                                                        <div class="clearfix"></div>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form id="medicamentos_form" action="{$url}save_medicamentos_paciente.do" method="post" onsubmit="return false;">			
                                                            <input type="hidden" name="idperfilSaludMedicamento" id="idperfilSaludMedicamento" value="{$record.idperfilSaludMedicamento}" />
                                                            <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}" />


                                                            <div class="form-content">
                                                                <p><input type="text" placeholder='{"Medicamento"|x_translate}' name="nombre_medicamento" id="nombre_medicamento" value="{$record.nombre_medicamento}"></p>
                                                                <p><input type="text" placeholder='{"Posología"|x_translate}' name="posologia" id="posologia" value="{$record.posologia}"></p>
                                                                <p>
                                                                    <select name="tipoTomaMedicamentos_idtipoTomaMedicamentos" id="tipoTomaMedicamentos_idtipoTomaMedicamentos" class="form-control select select-primary select-block">
                                                                        {html_options options=$combo_tipo_toma_medicamento selected=$medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos}                                        
                                                                    </select>
                                                                </p>
                                                                <div class="date-holder">
                                                                    <span>
                                                                        <input id="fecha_inicio" type="text" placeholder='{"Fecha de inicio"|x_translate}'  name="fecha_inicio" data-date-format="DD/MM/YYYY" required="required"  />
                                                                        <img class="ui-datepicker-trigger" src="{$IMGS}icons/icon-calendar.svg" alt='{"Calendario"|x_translate}'>
                                                                    </span>   
                                                                    <span>
                                                                        <input id="fecha_fin" type="text" placeholder='{"Fecha de fin"|x_translate}'  name="fecha_fin" data-date-format="DD/MM/YYYY" required="required"  />
                                                                        <img class="ui-datepicker-trigger" src="{$IMGS}icons/icon-calendar.svg" alt='{"Calendario"|x_translate}'>                                            
                                                                    </span>
                                                                </div>

                                                                {*
                                                                <div class="date-holder">
                                                                <input id="fecha_inicio" type="text" placeholder="Fecha de inicio"  name="fecha_inicio" data-date-format="DD/MM/YYYY" required="required"  />
                                                                <input type="text" id="fecha_fin" placeholder="Fecha de fin"  name="fecha_fin" data-date-format="DD/MM/YYYY" />
                                                                <img src="{$IMGS}icons/icon-calendar.svg" alt="Calendario"/>
                                                                </div>
                                                                *}
                                                                <p>
                                                                    <span style="display:block;">{"Especialidad del profesional que lo recetó:"|x_translate}</span>  
                                                                    <select name="especialidad_idespecialidad" id="especialidad_idespecialidad" class="form-control select select-primary select-block">
                                                                        <option value="">{"Especialidad"|x_translate}</option>
                                                                        {html_options options=$combo_especialidades selected=$record.especialidad_idespecialidad}
                                                                    </select>
                                                                </p>

                                                            </div>
                                                            <div class="modal-btns">
                                                                <button data-dismiss="modal">{"cancelar"|x_translate}</button>
                                                                <button onclick ="submitForm()">{"agregar"|x_translate}</button>
                                                            </div>
                                                        </form>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>	
                                    </div>
                                    <div class="col-sm-12 col-md-4">
                                        <a href="javascript:;" id="btnVerMedicacionActual" class="border-box border-box-solid dp-medicine"><span>{"Medicación actual"|x_translate}</span></a>	
                                    </div>			
                                    <div class="col-sm-12 col-md-4">
                                        <a href="javascript:;" id="btnVerMedicacionHistorica" class="border-box border-box-solid dp-add-user"><span>{"Histórico de medicación"|x_translate}</span></a>	
                                    </div>
                                </div>
                                <br>
                            </section>

                            <div class="modal fade" id="table-modal">
                                <div class="modal-dialog modal-medicamentos">
                                    <div class="modal-content">
                                        <div class="modal-text">{"¿Está seguro que desea eliminar los medicamentos seleccionados?"|x_translate}</div>
                                        <div class="modal-btns">
                                            <button data-dismiss="modal" id="cancelar_multiple_medicamentos">{"Cancelar"|x_translate}</button>
                                            <button id="eliminar_multiple_medicamentos">{"Aceptar"|x_translate}</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix"></div>


                            {literal}
                                <script>
                                    $(document).ready(function () {

                                        $("ul.slider-menu li a").removeClass("active");
                                        $("ul.slider-menu li i.dpp-medicina").parent().addClass("active");

                                        //inicializamos ocultos los combobox de especialidad y medico
                                        /*
                                         $('#select_medico').hide();
                                         $('#select_especialidad').hide();
                                         // Eventos para check y uncheck 1
                                         $('#receto_medicofrecuente').on('change.radiocheck', function () {
                                         // Do something
         
                                         if ($("#receto_medicofrecuente").is(':checked')) {
                                         $('#receto_especialidad').radiocheck('uncheck');
                                         $('#select_medico').show();
                                         } else {
                                         $('#select_medico').hide();
                                         }
                                         });
                                         // Eventos para check y uncheck 1
                                         $('#receto_especialidad').on('change.radiocheck', function () {
                                         // Do something
         
                                         if ($("#receto_especialidad").is(':checked')) {
                                         $('#receto_medicofrecuente').radiocheck('uncheck');
                                         $('#select_especialidad').show();
                                         } else {
                                         $('#select_especialidad').hide();
                                         }
                                         });
                                         */

                                        $(".renew_deactivated").tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                                                .data("title", x_translate("Renovación no Disponible. El medicamento no fue recetado por un profesional de DoctorPlus"))
                                                .addClass("error")
                                                .tooltip();


                                //        $('[data-toggle="tooltip"]').tooltip({
                                //            template: '<div class="tooltip alert-tooltip" role="tooltip">Renovación no Disponible. El medicamento no fue recetado por un profesional de DoctorPlus</div>'
                                //        });

                                        if ($("#tipoTomaMedicamentos_idtipoTomaMedicamentos").val() != "4") {
                                            $("#fecha_fin").prop("disabled", true);
                                        }

                                        $("#tipoTomaMedicamentos_idtipoTomaMedicamentos").change(function () {
                                            if ($("#tipoTomaMedicamentos_idtipoTomaMedicamentos").val() != "4") {
                                                $("#fecha_fin").prop("disabled", true);
                                                $("#fecha_fin").val("");
                                            } else {
                                                $("#fecha_fin").prop("disabled", false);
                                            }
                                        });

                                        $("#fecha_inicio")
                                                .datetimepicker({
                                                    pickTime: false,
                                                    language: 'fr'
                                                });

                                        $("#fecha_fin")
                                                .datetimepicker({
                                                    pickTime: false,
                                                    language: 'fr'
                                                });
                                        /*
                                         $('.modal-btn').on('click', function() {
                                         var targetId = '#' + $(this).data('target');
                                         $(targetId).modal();
                                         });
                                         */
                                        $(".btnSolicitarReceta").click(function () {
                                            var id = $(this).data("id");
                                            x_sendForm($('#solicitar-renovacion-' + id),
                                                    true,
                                                    function (data) {
                                                        x_alert(data.msg);
                                                        if (data.result) {
                                                            $("#mdl-medicamento-" + id).modal("toggle");
                                                        }
                                                    });
                                        });

                                        $(".btnSolicitarReceta2").click(function () {
                                            var id = $(this).data("id");
                                            x_sendForm($('#solicitar-renovacion-2-' + id),
                                                    true,
                                                    function (data) {
                                                        x_alert(data.msg);
                                                        if (data.result) {
                                                            $("#mdl-medicamento-" + id).modal("toggle");
                                                        }
                                                    });
                                        });

                                        $("#eliminar_multiple_medicamentos").click(function () {
                                            var ids = "";

                                            $.each($(".check_delete_medicamento").find("[type=checkbox]:checked"),
                                                    function (index, value) {
                                                        ids += "," + $(this).val();
                                                        //console.log($(this).val());
                                                    });

                                            if (ids.length > 0) {
                                                ids = ids.substring(1);
                                            } else {

                                                x_alert(x_translate("No hay medicamentos seleccionados"));
                                                return false;
                                            }

                                            $("#table_medicamentos").spin("large");
                                            x_doAjaxCall(
                                                    'POST',
                                                    BASE_PATH + 'delete_multiple_medicamento.do',
                                                    'ids=' + ids,
                                                    function (data) {

                                                        $("#table_medicamentos").spin(false);
                                                        if (data.result) {


                                                            x_alert(data.msg, recargar);

                                                        } else {
                                                            x_alert(data.msg);
                                                        }
                                                        $("#cancelar_multiple_medicamentos").click();
                                                    }
                                            );
                                        });

                                        x_runJS();

                                        //boton crear consulta express directa a un medico
                                        $("#doctor-info .setMedicoConsultaExpress").click(function () {
                                            var idmedico = $(this).data('idmedico');
                                            x_doAjaxCall(
                                                    'POST',
                                                    BASE_PATH + "crear_consultaexpress_medico.do",
                                                    'medico_idmedico=' + idmedico,
                                                    function (data) {



                                                        if (data.borrador == "1") {
                                                            x_alert(data.msg);
                                                            return false;
                                                        }
                                                        if (data.result) {
                                                            window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                                        } else {
                                                            x_alert(data.msg);
                                                        }

                                                    }




                                            );
                                        });

                                    });

                                    $("#ver_thumb").click(function () {
                                        //Quito y agrego las clases activas
                                        $(this).addClass("active");
                                        $("#ver_row").removeClass("active");

                                        if ($("#is_actual").val() == "1") {
                                            $("#medicacion-actual-thumb").show();
                                            $("#medicacion-actual-row").hide();
                                            $("#historico-medicacion-row").hide();
                                            $("#historico-medicacion-thumb").hide();
                                        } else {
                                            $("#medicacion-actual-thumb").hide();
                                            $("#medicacion-actual-row").hide();
                                            $("#historico-medicacion-row").hide();
                                            $("#historico-medicacion-thumb").show();
                                        }
                                    });

                                    $("#btnVolver").click(function () {
                                        $("#btnVerMedicacionActual").trigger("click");
                                    });

                                    $("#ver_row").click(function () {
                                        //Quito y agrego las clases activas
                                        $(this).addClass("active");
                                        $("#ver_thumb").removeClass("active");

                                        if ($("#is_actual").val() == "1") {
                                            $("#medicacion-actual-thumb").hide();
                                            $("#medicacion-actual-row").show();
                                            $("#historico-medicacion-row").hide();
                                            $("#historico-medicacion-thumb").hide();
                                        } else {
                                            $("#medicacion-actual-thumb").hide();
                                            $("#medicacion-actual-row").hide();
                                            $("#historico-medicacion-row").show();
                                            $("#historico-medicacion-thumb").hide();
                                        }
                                    });

                                    $("#btnVerMedicacionHistorica").click(function () {
                                        $("#btnVerMedicacionActual").removeClass("border-box-solid-blue");
                                        $(this).addClass("border-box-solid-blue");
                                        $("#div_medicacion_actual").hide();
                                        $("#div_historico_medicacion").show();
                                        $("#is_actual").val("0");
                                        $("#ver_row").click();
                                    });

                                    $("#btnVerMedicacionActual").click(function () {
                                        $("#btnVerMedicacionHistorica").removeClass("border-box-solid-blue");
                                        $(this).addClass("border-box-solid-blue");

                                        $("#div_medicacion_actual").show();
                                        $("#div_historico_medicacion").hide();
                                        $("#is_actual").val("1");
                                        $("#ver_row").click();
                                    });

                                    function submitForm() {

                                        $("#medicamentos_form").validate({
                                            showErrors: function (errorMap, errorList) {

                                                // Clean up any tooltips for valid elements
                                                $.each(this.validElements(), function (index, element) {
                                                    var $element = $(element);

                                                    $element.data("title", "") // Clear the title - there is no error associated anymore
                                                            .removeClass("error")
                                                            .tooltip("destroy");
                                                });

                                                // Create new tooltips for invalid elements
                                                $.each(errorList, function (index, error) {
                                                    var $element = $(error.element);

                                                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                                                            .data("title", error.message)
                                                            .addClass("error")
                                                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                                                });
                                            },
                                            submitHandler: function (form) {

                                                if ($("#nombre_medicamento").val() == "" || $("#posologia").val() == "") {
                                                    x_alert(x_translate("Ingrese un medicamento y su posología"));
                                                    return false;
                                                }


                                                if ($("#especialidad_idespecialidad").val() == "") {
                                                    x_alert(x_translate("Seleccione el especialista que recetó el medicamento"));
                                                    return false;

                                                }

                                                x_sendForm($('#medicamentos_form'), true, function (data) {

                                                    if (data.result) {

                                                        x_alert(data.msg, recargar);
                                                    } else {
                                                        x_alert(data.msg);
                                                    }
                                                });
                                            }
                                        });
                                    }
                                </script>
                            {/literal}