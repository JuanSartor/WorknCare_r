{include file="turno/pasos_turno.tpl"}
{if $turno}
    {if $no_aplica_medico_lux==1}
        {include file="error/error_medico_lux.tpl"}
    {else}

        <!--	PASOS NAV-->
        <input type="hidden" id="lat" value="{$consultorio.lat}"/>
        <input type="hidden" id="lng" value="{$consultorio.lng}"/>
        <input type="hidden" id="imgs_path" value="{$IMGS}"/>




        <!--	content-->
        <section class="okm-container">
            <div class="okm-row">
                <div class="bst-col">
                    <h2>{"Datos del profesional"|x_translate}</h2>
                    <div class="bst-box medico">
                        <ul>
                            <li>
                                <a target="_blank" href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html?from_busqueda=1">
                                    {if $medico.images.perfil}
                                        <img src="{$medico.images.perfil}" alt="{$medico.nombre} {$medico.apellido}" id="img_medico"/>
                                    {else}
                                        <img class="img-responsive img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.nombre} {$medico.apellido}" id="img_medico" style="width: 50px;">
                                    {/if}

                                    <div class="bst-usr-data">
                                        <input type="hidden" id="titulo_profesional_medico" value="{$medico.titulo_profesional.titulo_profesional}" />
                                        <input type="hidden" id="nombre_apellido_medico" value="{$medico.nombre} {$medico.apellido}" />
                                        <input type="hidden" id="especialidad_medico" value=" {$medico.mis_especialidades.0.especialidad}" />

                                        <h3>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</h3>
                                        <span>{$medico.mis_especialidades.0.especialidad} </span>
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
                                    <p class="date">{$turno.fechaTurno_format} - <strong>{$turno.horarioTurno_format} {"hs"|x_translate}</strong></p>
                                </div>
                            </li>
                            <li>
                                <a href="#" class="ver-mapa-trigger">
                                    <figure><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                                    <div class="bst-usr-data">
                                        <input type="hidden" id="direccion_medico" value="{$consultorio.direccion} {$consultorio.numero}" />
                                        <p><strong>{"Consultorio Físico"|x_translate}:</strong> {$consultorio.direccion|ucfirst} {$consultorio.numero}, {$consultorio.localidad_corta|lower|ucfirst}, {$consultorio.pais}</p>
                                    </div>
                                </a>
                            </li>
                        </ul>

                        <div class="bst-map-box" id="bst-mapa">
                            <div class="google-maps" id="map_canvas_modal">

                            </div>

                        </div>
                    </div>


                </div>
                <div class="bst-col">
                    <h2>{"Datos del  paciente"|x_translate}</h2>
                    <div class="bst-box paciente">
                        <!--                Recorro todos los miembros y si es el titular lo asigno..-->

                        {foreach from=$header_info.all_members item=miembro} 

                            <div {if $paciente.idpaciente != $miembro.idpaciente}style="display: none" {/if} class="div_info_paciente_turno" id="info_paciente_turno_{$miembro.idpaciente}">

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
                                        {$miembro.fechaNacimiento_format}
                                    </span>
                                </div>
                            </div>
                        {/foreach}

                    </div>

                    <div class="bst-box cobertura">
                        <h3>{"Cobertura Médica"|x_translate}</h3>
                        <div class="bst-cobertura-slide-box">

                            <div class="cobertura-slide-box" >

                                <ul class="cobertura-data-list">
                                    {*paciente frances*}
                                    {if $paciente.pais_idpais==1 }
                                        {if $medico.pais_idpais==1 && $paciente.tarjeta_vitale!=""}
                                            <li>
                                                <label>{"Cobertura"|x_translate}</label>
                                                <p  class="numero-afiliado">{"Tarjeta Vitale"|x_translate}</p>
                                            </li>

                                            <li>
                                                <label>{"Nro de afiliado"|x_translate}</label>
                                                <p class="numero-afiliado" >{$paciente.tarjeta_vitale}</p>
                                            </li>
                                        {else}
                                            {if $medico.pais_idpais==2 && $paciente.tarjeta_cns!=""}
                                                <li>
                                                    <label>{"Cobertura"|x_translate}</label>
                                                    <p  class="numero-afiliado">{"Tarjeta CNS"|x_translate}</p>
                                                </li>

                                                <li>
                                                    <label>{"Nro de afiliado"|x_translate}</label>
                                                    <p class="numero-afiliado" >{$paciente.tarjeta_cns}</p>
                                                </li>
                                            {else}
                                                <li>
                                                    <label>{"Cobertura"|x_translate}</label>
                                                    <p  class="numero-afiliado">{"Pagaré en forma particular"|x_translate}</p>
                                                </li>
                                            {/if}
                                        {/if}
                                    {else}
                                        {if $paciente.pais_idpais==2 || $paciente.pais_idpais==3 }
                                            {if $medico.pais_idpais==2 && $paciente.tarjeta_cns!=""}
                                                <li>
                                                    <label>{"Cobertura"|x_translate}</label>
                                                    <p class="numero-afiliado"> {"Tarjeta CNS"|x_translate}</p>
                                                </li>

                                                <li>
                                                    <label>{"Nro de afiliado"|x_translate}</label>
                                                    <p class="numero-afiliado" >{$paciente.tarjeta_cns}</p>
                                                </li>
                                            {else}
                                                <li>
                                                    <label>{"Cobertura"|x_translate}</label>
                                                    <p  class="numero-afiliado">{"Pagaré en forma particular"|x_translate}</p>
                                                </li>
                                            {/if}
                                        {else}
                                            <li>
                                                <label>{"Cobertura"|x_translate}</label>
                                                <p  class="numero-afiliado">{"Pagaré en forma particular"|x_translate}</p>
                                            </li>
                                        {/if}
                                    {/if}
                                </ul>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <form name="reservar_turno" id="reservar_turno" action="{$url}reservar.do" method="post">
                <input type="hidden" id="idmedico_reservar" name="idmedico" value="{$medico.idmedico}" />
                <input type="hidden" id="idturno_reservar" name="idturno" value="{$turno.idturno}" />
                <input type="hidden" id="motivovisita_idmotivoVisita_reservar" name="motivovisita_idmotivoVisita" value="{$turno.motivovisita_idmotivoVisita}" />
                <input type="hidden" id="visitaPrevia_reservar" name="visitaPrevia" value="{$turno.visitaPrevia}" />
                <input type="hidden" id="particular_reservar" name="particular" value="{$turno.particular}" />
                <input type="hidden" id="planObraSocial_idplanObraSocial_reservar" name="planObraSocial_idplanObraSocial" value="{$turno.planObraSocial_idplanObraSocial}" />
                <input type="hidden" id="obraSocial_idobraSocial_reservar" name="obraSocial_idobraSocial" value="{$turno.obraSocial_idobraSocial}" />
                <input type="hidden" id="paciente_idpaciente_reservar" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
                <input type="hidden" id="idprograma_categoria_reservar" name="idprograma_categoria" value="{$programa_categoria.idprograma_categoria}">
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

                        <select  class="form-control select select-block green-select" id="motivovisita_idmotivoVisita" name="motivovisita_idmotivoVisita"  {if $combo_programas}disabled="disabled"{/if} class="form-control select select-primary select-block mbl">
                            <option value="">{"Seleccione una opción"|x_translate}</option>
                            {html_options options=$combo_motivo_visita selected=$turno.motivovisita_idmotivoVisita}

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
    {/if}
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
