<style>
    .ratting-like{
        margin-left:0px !important
    }
</style>
<link href="{$url}xframework/app/themes/dp02/css/home_public.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
{include file="home/login.tpl"}

<div class="listado_medicos_wrapper top-section profesionales-section">
    <div class="okm-container">
        {include file="programa_salud/menu.tpl"}

        <div class="home-doctorplus-logo logo-small profesionales-section">
            <a href="{$url}"><img src="{$IMGS}logo_pass_bienetre_fit.png" title="WorknCare"></a>
        </div>
        <div class="home-main profesionales-section">
            <div class="home-doctorplus-logo">
                <a href="{$url}"><img src="{$IMGS}logo_pass_bienetre_fit.png" title="WorknCare"></a>
            </div>
        </div>
        <a href="javascript:;" onclick="window.history.back();" class="btn-volver-home-sante" data-id="{$programa.idprograma_salud}"><i class="fa fa-chevron-left"></i>{"Volver"|x_translate}</a>


        {if $medico.idmedico!=""}

            <div class="">

                <div class="title-holder">
                    <h1 class="title">
                        {"Ficha de Médico"|x_translate}
                    </h1>
                </div>



                <input type="hidden" id="idmedico" value="{$medico.idmedico}">
                <input type="hidden" id="idconsultorio" value="{$medico.consultorios[0].idconsultorio}">
                <input type="hidden" id="fecha_agenda" value="">

                <section class="okm-container pbp-medico-ficha">
                    <div class="okm-row">
                        <div class="pbp-col">
                            {**Medico*}
                            <div class="gnlist-profesional-holder">
                                <div class="okm-row gnlist-profesional-row">

                                    <figure class="gnlist-usr-avatar">
                                        <a href="javascript:;">
                                            {if !$medico.imagen}
                                                <img src="{$IMGS}extranet/noimage_perfil.png"  alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">
                                            {else}
                                                <img src="{$medico.imagen.list}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}">
                                            {/if}
                                        </a>
                                    </figure>

                                    <div class="gnlist-usr-data-holder">
                                        <h3><a href="javascript:;">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</a></h3>
                                        <h4>{$medico.mis_especialidades.0.especialidad}</h4>
                                        <div class="usr-data-content">
                                            {if $medico.direccion.iddireccion!=""}
                                                <p>
                                                    {if $medico.direccion.mostrar_direccion=="1"}
                                                        {$medico.direccion.direccion|upper} {$medico.direccion.numero}, 
                                                    {/if} 
                                                    {$medico.direccion.localidad}
                                                </p>
                                            {/if}                                                                 

                                        </div>
                                    </div>
                                </div>
                            </div>
                            {*Formacion*}
                            {if $medico.formacionAcademica!="" || $medico.experienciaProfesional!=""}
                                <div class="pbp-card pbp-perfil-profesional">
                                    <div class="pbp-card-inner">

                                        <h3 class='ficha-tecnica'>
                                            <i class="icon-doctorplus-ficha-tecnica"></i>
                                            <strong> {"Perfil Profesional"|x_translate}</strong>
                                            <span class="pull-down pull-right"><i class="fa fa-chevron-down"></i></span>
                                            <div class='web-profesional-ficha-tecnica'>
                                                {foreach from=$listado_web_profesional item=web}
                                                    <a href="{$web.url_web}" target="_blank">
                                                        <figure class="tipo_web">
                                                            {if $web.tipo_web=="web"}
                                                                <i class="fa fa-link"></i>
                                                            {else if $web.tipo_web=="linkedin"}
                                                                <i class="fa fa-linkedin"></i>
                                                            {else if $web.tipo_web=="youtube"}
                                                                <i class="fa fa-youtube"></i>
                                                            {else if $web.tipo_web=="facebook"}
                                                                <i class="fa fa-facebook"></i>
                                                            {else if $web.tipo_web=="instagram"}
                                                                <i class="fa fa-instagram"></i>
                                                            {else}
                                                                <i class="fa fa-link"></i>
                                                            {/if}
                                                        </figure>
                                                    </a>
                                                {/foreach}
                                            </div>

                                        </h3>
                                        <div class="pbp-card-slide">
                                            {if $medico.formacionAcademica!=""}
                                                <h4>{"CV / Formación académica y experiencia profesional"|x_translate}</h4>

                                                <div class="pbp-perfil-profesional-expand-text" data-lines="20" data-linesrsp="10">
                                                    <span><p>{$medico.formacionAcademica}</p></span>
                                                </div>
                                            {/if}
                                            {if $medico.experienciaProfesional!=""}
                                                <h4>{"Miembro de Asociaciones Médicas"|x_translate}</h4>

                                                <div class="pbp-perfil-profesional-expand-text" data-lines="20" data-linesrsp="10">
                                                    <span><p>{$medico.experienciaProfesional}</p></span>
                                                </div>
                                            {/if}

                                        </div>
                                    </div>
                                </div>
                            {/if}

                        </div>

                        <div class="pbp-col">
                            {*Tarifas*}
                            {include file="profesionalesfrecuentes/profesionales_frecuentes_tarifas.tpl"}
                            {*Mapa*}
                            {include file="profesionalesfrecuentes/profesionales_mapa.tpl"}
                        </div>
                    </div>

                </section>
                {if $medico.vacaciones==""}
                    {*Agenda turnos*}
                    <section class="okm-container pbp-turnos-holder" style="padding:0 16px;">
                        <div class="pbp-card">
                            <h3>
                                <i class="icon-doctorplus-ficha-time"></i>
                                <strong>{"Solicitar turno"|x_translate}</strong>
                            </h3>
                            <div class="row pbp-turno-holder" id="modulo_listado_consultorios">
                                <!--			------>
                                {foreach from=$medico.consultorios item=consultorio name=foo1}

                                    <div class="pbp-turno" >

                                        <div class="pbp-turno-header {if $consultorio.is_virtual=="0"}presencial{else}virtual{/if}" id="target-consultorio-{if $consultorio.is_virtual=="0"}{$consultorio.idconsultorio}{else}virtual{/if}" {if $consultorio.is_virtual=="0"}style="background-color:#699dac"{/if}>

                                            {if $consultorio.is_virtual=="0"}
                                                <i class="icon-doctorplus-ficha-check"></i>
                                                <p>{"Consultorio Físico"|x_translate}</p>
                                                <div class="pbp-turno-direccion">
                                                    <p><em>{$consultorio.direccion|upper} {$consultorio.numero}, {$consultorio.localidad|upper}, {$consultorio.pais}</em></p>

                                                </div>
                                            {else}
                                                <i class="icon-doctorplus-video-call"></i>
                                                <p>{"Consultorio Virtual"|x_translate}</p>
                                                <div class="pbp-turno-direccion">
                                                </div>
                                            {/if}
                                        </div>
                                        <div class="pbn-turnos-slide-scroll">
                                            <div class="pbn-turnos-holder pbn-turnos-sm" id="pbn-turnos-holder-{$consultorio.idconsultorio}" data-fecha="" data-idmedico="{$consultorio.medico_idmedico}" data-idconsultorio="{$consultorio.idconsultorio}">

                                                <div class="pbn-turnos-sm-slide" id="div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}" >

                                                    <!-- ACÁ VA EL CONTENIDO DEL MODULO-->

                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <script>
                                        x_loadModule("profesionalesfrecuentes",
                                                "agenda_semanal_medico",
                                                "idmedico={$consultorio.medico_idmedico}&idconsultorio={$consultorio.idconsultorio}",
                                                "div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}", BASE_PATH + "frontend_2");
                                    </script>

                                {/foreach}
                            </div>
                        </div>
                    </section>
                {/if}
                {include file="profesionalesfrecuentes/como_funciona.tpl"}
                {x_load_js}

            {else}
                <br>
                <h3 class="text-center">
                    {"No se ha encontrado el profesional"|x_translate}
                </h3>
            {/if}


