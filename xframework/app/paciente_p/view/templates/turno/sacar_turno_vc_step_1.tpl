{include file="turno/pasos_turno.tpl"}
<script src="https://js.stripe.com/v3/"></script>
<div id="reservar_turno_container">
    {if $turno}
        {if $no_aplica_medico_lux==1}
            {include file="error/error_medico_lux.tpl"}
        {else}
            <input type="hidden" id="imgs_path" value="{$IMGS}" />

            <section class="okm-container">
                <div class="okm-row">
                    <div class="bst-col">
                        <h2>{"Datos del profesional"|x_translate}</h2>
                        <div class="bst-box medico">
                            <ul>
                                <li>
                                    <a target="_blank" href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html?from_busqueda=1">
                                        {if $medico.images.perfil}
                                            <img src="{$medico.images.perfil}" alt="{$medico.nombre} {$medico.apellido}" id="img_medico" />
                                        {else}
                                            <img class="img-responsive img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.nombre} {$medico.apellido}" id="img_medico" style="width: 50px;">
                                        {/if}

                                        <div class="bst-usr-data">
                                            <input type="hidden" id="titulo_profesional_medico" value="{$medico.titulo_profesional.titulo_profesional}" />
                                            <input type="hidden" id="nombre_apellido_medico" value="{$medico.nombre} {$medico.apellido}" />
                                            <input type="hidden" id="especialidad_medico" value=" {$medico.mis_especialidades.0.especialidad}" />

                                            <h3>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}
                                            </h3>
                                            <span>{$medico.mis_especialidades.0.especialidad}</span>
                                            {if $paciente.pais_idpais==1 && $medico.pais_idpais==1}
                                                {if $medico.preferencia.sector.sector!=""}
                                                    <h3>{$medico.preferencia.sector.sector}</h3>
                                                {/if}
                                            {else}
                                                <h3>{$medico.pais_medico}</h3>
                                            {/if}
                                            {if $medico.medico_cabecera==1}
                                                <h3 style="color:#F23243">{"Médico de cabecera"|x_translate}</h3>
                                            {/if}

                                        </div>
                                    </a>
                                </li>
                                {if $programa_categoria.programa_categoria!=""}
                                    <li>
                                        <div class="bst-usr-data">
                                            <img src="{$IMGS}pass_bienetre_icon.png" style="
                                                 top: 10px;
                                                 left: 16px;
                                                 width: 36px;
                                                 ">
                                            <p class="date">
                                                {if $programa_salud.programa_salud!=""}
                                                    {$programa_salud.programa_salud}
                                                {/if}
                                                {if $programa_categoria.programa_categoria!=""}
                                                    &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                                                {/if}
                                            </p>
                                        </div>
                                    </li>
                                {/if}
                                <li>
                                    <figure><i class="icon-doctorplus-calendar"></i></figure>
                                    <div class="bst-usr-data">
                                        <p class="date">{$turno.fechaTurno_format} - <strong>{$turno.horarioTurno_format}
                                                {"hs"|x_translate}</strong></p>
                                    </div>
                                </li>
                                <li>
                                    <figure><i class="icon-doctorplus-video-call"></i></figure>
                                    <div class="bst-usr-data">
                                        <p>{"Consultorio Virtual"|x_translate}</p>
                                    </div>
                                </li>
                            </ul>

                        </div>

                    </div>
                    <div class="bst-col">
                        <h2>{"Datos del  paciente"|x_translate}</h2>
                        <div class="bst-box paciente">
                            <!--                Recorro todos los miembros y si es el titular lo asigno..-->

                            {foreach from=$header_info.all_members item=miembro}

                                <div {if $paciente.idpaciente != $miembro.idpaciente}style="display:none;" {/if} class="div_info_paciente_turno" id="info_paciente_turno_{$miembro.idpaciente}">

                                    {if $miembro.image.perfil != ""}
                                        <img class="img-responsive img-circle" src="{$miembro.image.perfil}" alt="{$miembro.nombre} {$miembro.apellido}">
                                    {else}
                                        <img class="img-responsive img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre} {$miembro.apellido}" style="width: 50px;">
                                    {/if}
                                    <div class="paciente-data">
                                        <h3>{$miembro.nombre} {$miembro.apellido}</h3>
                                        <span>

                                            {if $miembro.sexo == 1}
                                                <i class="icon-doctorplus-masc-symbol"></i>
                                            {else}
                                                <i class="icon-doctorplus-fem-symbol"></i>
                                            {/if}
                                            DN {$miembro.fechaNacimiento_format}
                                        </span>
                                    </div>
                                </div>
                            {/foreach}

                        </div>

                        <div class="bst-box cobertura">
                            <h3>{"Reintegro"|x_translate}</h3>
                            <div class="bst-cobertura-slide-box">
                                <div class="cobertura-slide-box-1">
                                    <div class="okm-row">

                                        {if $medico.pais_idpais==1 && $medico.mis_especialidades.0.tipo==1 && (($paciente.titular==1 && $paciente.pais_idpais==1 && ($medico.medico_cabecera==1 || ($medico.medico_cabecera==0 &&$medico.mis_especialidades.0.acceso_directo==1 ))) || ($paciente.titular==0 && $account.paciente.pais_idpais==1 && $paciente.animal!=1)) }
                                            <div class=" pago-particular">
                                                <label class="checkbox">
                                                    <input type="checkbox" id="beneficia_reintegro" data-toggle="radio" class="custom-radio">
                                                    {if $paciente.beneficia_ald==1}
                                                        {"Confirmo que he tenido una consulta presencial en los últimos 12 meses y que el especialista está incluido en mi protocolo de tratamiento"|x_translate}
                                                    {else}
                                                        {"Confirmo que he tenido una consulta presencial en los últimos 12 meses"|x_translate}
                                                    {/if}
                                                </label>
                                            </div>
                                            <div>
                                                <div class="pago-particular">
                                                    <p>
                                                        <small class="x_small">{"Si confirma que si, tendrá derecho al reintegro de la consulta por la caja. Recibirá una notificación cuando su médico envía a la caja los datos de su consulta. Podrá identificar en su resumen de cuenta la teleconsulta con el codigo TCG o TC."|x_translate}</small>
                                                    </p>
                                                </div>
                                            </div>
                                        {else}
                                            <div class=" pago-particular">
                                                <label class="checkbox">
                                                    <input type="checkbox" id="particular" checked data-toggle="radio" class="custom-radio">
                                                    {"Pagaré en forma particular"|x_translate}
                                                </label>
                                            </div>

                                        {/if}

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <form name="reservar_turno" id="reservar_turno" action="{$url}reservar.do" method="post">
                    <input type="hidden" id="idmedico_reservar" name="idmedico" value="{$medico.idmedico}" />
                    <input type="hidden" id="idturno_reservar" name="idturno" value="{$turno.idturno}" />
                    <input type="hidden" id="motivoVideoConsulta_idmotivoVideoConsulta_reservar" name="motivoVideoConsulta_idmotivoVideoConsulta" value="{$turno.motivoVideoConsulta_idmotivoVideoConsulta}" />
                    <input type="hidden" id="visitaPrevia_reservar" name="visitaPrevia" value="{$turno.visitaPrevia}" />
                    <input type="hidden" id="particular_reservar" name="particular" value="" />
                    <input type="hidden" id="beneficia_reintegro_reservar" name="beneficia_reintegro" value="" />
                    <input type="hidden" id="paciente_idpaciente_reservar" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
                    <input type="hidden" id="idprograma_categoria_reservar" name="idprograma_categoria" value="{$programa_categoria.idprograma_categoria}">
                    {if $acceso_perfil_salud=="1"}
                        <input type="hidden" id="mostrar_cambio_privacidad" value="{$mostrar_cambio_privacidad}" />
                        <input type="hidden" id="perfil_privado" name="perfil_privado" value="{$perfil_privado}" />
                    {/if}

                    <div class="col-xs-12">
                        {if $combo_programas}
                            <div class="col-sm-5 col-sm-offset-1" id="programa_categoria_container">
                                <div class="cs-nc-p2-input-holder  ce-nc-p4-mensaje">
                                    <label>{"Programas de salud"|x_translate}&nbsp;*</label>
                                    <input type="hidden" id="idprograma_categoria" name="idprograma_categoria" value="">
                                    <input type="hidden" id="idprograma_salud" name="idprograma_salud" value="">
                                    <div class="dropdown dropdown-programas-container select2-container form-control select select-primary select-block mbl">
                                        <a class="select2-choice" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                            <span class="label-default"> {"Seleccione un programa de salud"|x_translate}</span>
                                            <span class="item-seleccionado" style="display: none;"></span>
                                            <span class="select2-arrow" role="presentation"><b role="presentation"></b></span>
                                        </a>
                                        <ul class="select2-results dropdown-menu dropdown-programas" aria-labelledby="dropdownMenu1">
                                            {foreach from=$combo_programas item=programa}
                                                <li>
                                                    <a href="javascript:;" class="select-programa" data-idprograma="{$programa.idprograma_salud}">
                                                        <i class="fa fa-chevron-right"></i> 
                                                        <strong class="nombre-programa" data-idprograma="{$programa.idprograma_salud}">{$programa.programa_salud}:</strong>
                                                        <span class="tag-container" >
                                                            <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                                                                <span class="content">
                                                                    {"Gratuita"|x_translate}
                                                                </span>
                                                            </div>
                                                        </span>
                                                    </a>
                                                    <ul class="dropdown-submenu">
                                                        {foreach from=$programa.programa_categoria item=categoria}
                                                            <li class="select-categoria" data-idprograma="{$programa.idprograma_salud}" data-idcategoria="{$categoria.idprograma_categoria}" >
                                                                - <span class="nombre-categoria" data-idcategoria="{$categoria.idprograma_categoria}">&nbsp;{$categoria.programa_categoria}</span>
                                                            </li>
                                                        {/foreach}
                                                    </ul>
                                                </li>
                                            {/foreach}
                                        </ul>
                                    </div>
                                </div>
                            </div>

                        {/if}
                        <div class="{if $combo_programas}col-sm-5{else}col-sm-10 col-sm-offset-1{/if} ce-nc-p4-mensaje">
                            <label>{"Motivo de la consulta"|x_translate}&nbsp;*</label>
                            <select  class="form-control select select-block green-select" id="motivoVideoConsulta_idmotivoVideoConsulta" name="motivoVideoConsulta_idmotivoVideoConsulta"  {if $combo_programas}disabled="disabled"{/if} class="form-control select select-primary select-block mbl">
                                <option value="">{"Seleccione una opción"|x_translate}</option>
                                {html_options options=$combo_motivo_videoconsulta selected=$turno.motivoVideoConsulta_idmotivoVideoConsulta}

                            </select>

                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                    {include file="turno/sacar_turno_mensaje.tpl"}
                </form>
                <div class="okm-row ce-nc-p3-monto-btns-holder">
                    <button onclick="window.history.back();" class="btn btn-secondary">{"volver"|x_translate}</button>
                    <button id="btn_reservar" class="btn btn-default">{"confirmar"|x_translate}</button>
                </div>
                <div class="clearfix">&nbsp;</div>
            </section>
            <script>
                var ids_excepciones_programa = "{$ids_excepciones_programa}";
            </script>
            {x_load_js}
            <!--	ALERTAS - Perfil de Salud completo - acreditacion	-->
            <div class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" id="modal-cambio-privacidad-perfil-salud" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <input type="hidden" id="cambio_privacidad" value="0" />
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">{"¡Atencion!"|x_translate}</h4>
                        </div>
                        <div class="modal-body">
                            <p>
                                {"Esta consulta requiere cambiar la privacidad del Perfil de Salud del paciente a"|x_translate}
                                <span id="txt_change_privacidad">{$txt_change_privacidad}</span>.
                                {"A menos que vuelvas a modificar posteriormente esta selección, dicha configuración quedará permanentemente."|x_translate}
                            </p>
                            <div class="modal-perfil-completo-action-holder">
                                <button type="button" data-dismiss="modal" aria-label="Close" style="background-color: #ff6f6f"><i class="icon-doctorplus-cruz"></i> {"Cancelar"|x_translate}</button>
                                <button id="btnCambiarPrivacidad" data-privacidad=""><i class="dpp-lock"></i>
                                    {"Cambiar privacidad"|x_translate}</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        {/if}
        {*TEST RTC*}
        <link rel="stylesheet" href="{$url}xframework/app/themes/dp02/css/checkrtc.css">
        <script type="text/javascript" src="https://static.opentok.com/v2/js/opentok.min.js"></script>
        <script src="{$url}xframework/files/session_conectividad.js"></script>
        <script src="{$url}xframework/core/libs/libs_js/bundle_test_conectividad_2.js"></script>
        <div id="run-checkrtc" class="modal fade " tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content" id="checkRTC_container">
                </div>
            </div>
        </div>
    {else}
        <div class="okm-container" style="padding-top:10px; padding-bottom:10px !important;margin-bottom:20px;">
            <div class="vc-interrumpidas-header">
                <i class="icon-doctorplus-alert-round"></i>
                <h1>{"El turno que desea reservar ya no se encuentra disponible"|x_translate}</h1>
            </div>
            <p class="text-center">
                <a href="{$url}" class="btn btn-blue">{"volver"|x_translate}</a>
            </p>

        </div>
    {/if}
</div>