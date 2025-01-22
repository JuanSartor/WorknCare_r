{if $paciente.animal==1}
    {include file="pacientes/editar_mascota.tpl"}
    {else}
<style>
    #Main{
        background-color:#f7f7f7;
    }
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .mapc-select{
        margin-top: 0px;
    }
    /*header titulo*/
    .top-verde-centrado {
        min-height: 60px;

    }
    .top-verde-centrado h1 {
        font-size: 18px;
        line-height: 60px;
    }

    .top-verde-centrado h1>i {
        font-size: 24px;
        margin-right: 12px;
        top: 2px;
    }
</style>
<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >
<div class="top-verde-centrado">
    <h1><i class="icon-doctorplus-ficha-tecnica"></i> {"Editar paciente"|x_translate}</h1>
</div>
<input type="hidden" name="completer"  id="completer" value="{$completer}">

<form id="frm_Img" role="form" action="{$url}save_image_paciente.do" method="post" >
    <input type="hidden" name="idpaciente" value="{$paciente.idpaciente}" />
</form>

<section class="pul-datos-paciente">
    <form id="frmRegistro" role="form" method="post" action="{$url}cambiar-datos-paciente.do" onsubmit="return false;">
        {if $paciente.titular==1}
            <input type="hidden" id="usuarioweb_idusuarioweb" name="usuarioweb_idusuarioweb" value="{$paciente.usuarioweb_idusuarioweb}" />
        {/if}
        <input type="hidden" id="idpaciente" name="idpaciente" value="{$paciente.idpaciente}" />
        <input type="hidden" name="filter_selected" id="filter_selected" value="{$filter_selected}" />

        <div class="mapc-registro-box pul-nuevo-paciente-accordion">

            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" id="accordion-trg-1" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                {"Datos personales del paciente"|x_translate}
                                <i class="more-less fa fa-chevron-down pull-right"></i>
                            </a>
                        </h4>
                    </div>

                    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">

                            <!-- foto de perfil-->
                            {include file="pacientes/foto_perfil.tpl"}

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Nombre"|x_translate}</label>
                                        <input type="text" id="nombre_input" name="nombre" maxlength="15" data-title='{"Ingrese nombre del paciente"|x_translate}' value="{$paciente.nombre}"/>
                                    </div>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Apellido"|x_translate}</label>
                                        <input type="text" name="apellido" id="apellido_input" maxlength="20" data-title='{"Ingrese apellido del paciente"|x_translate}'  value="{$paciente.apellido}"/>
                                    </div>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-registro-form-row">
                                        <label class="mapc-label">{"Fecha de nacimiento"|x_translate} </label>
                                        <div class="mapc-input-line">
                                            <input type="text" id="fecha_nacimiento"  name="fechaNacimiento" data-title='{"Ingrese fecha de nacimiento"|x_translate}' value="{$paciente.fechaNacimiento|date_format:'%d/%m/%Y'}"/>
                                            <i class="icon-doctorplus-calendar"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="pul-col-x2 " >
                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                        <label class="mapc-label">{"Sexo"|x_translate}</label>
                                        <select id="sexo" name="sexo"  class="form-control select select-primary select-block mbl pul-np-dis">
                                            <option value="1" {if $paciente.sexo ==1}selected{/if}>{"HOMBRE"|x_translate}</option>
                                            <option value="0" {if $paciente.sexo ==0}selected{/if}>{"MUJER"|x_translate}</option>
                                        </select>
                                    </div>
                                </div>   
                            </div>
                            {if $paciente.titular==1}
                                <div id="titular_datos">
                                    <div class="okm-row">
                                        <div class="pul-col-x2">
                                            <div class="mapc-registro-form-row">
                                                <label class="mapc-label">{"Celular"|x_translate}</label>
                                                <div class="mapc-input-line">


                                                    <input type="tel" class="pul-np-dis" name="numeroCelular" tabindex='10' id="telefono_input" value="{$paciente.numeroCelular}" />
                                                    <i class="icon-doctorplus-cel"></i>

                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="okm-row" >
                                        <div class="okm-row mul-slide-validar-box" id="mul-validar-cel" {if $paciente.celularValido==1}style="display: none"{/if}>
                                            <div class="validar-cell-box">
                                                <h2>{"Validar celular"|x_translate} </h2>
                                                <div class="validar-cell-content relative">

                                                    <span id="validar_cel_msg" class="validar-cell-telefono">{"Le enviamos un mensaje de texto (SMS) con el código de validación de su celular al número"|x_translate} <span id="cambio_nroCelular"></span></span>

                                                    <p>
                                                        {"Deberá ingresarlo para un correcto funcionamiento del sistema. El mismo puede demorar unos minutos en llegar, aguarde. Si quiere generar el código nuevamente"|x_translate}  <a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a> 
                                                    </p>
                                                    <div class="validar-cell-action-box text-center">
                                                        <input type="text" class="codigo-cell" name="codigo-cell" placeholder='{"INGRESE CODIGO"|x_translate}'>
                                                    </div>
                                                    <div class="validar-cell-action-box text-center">
                                                        <a href="javascript:;" class="btn-secondary-square  validarCodigoCelular">{"confirmar"|x_translate}</a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="clearfix">&nbsp;</div>
                                        </div>
                                    </div>
                                </div>
                            {else}
                                <input type="hidden" id="pais_idpais" value="{$paciente.pais_idpais}">
                                <input type="hidden" id="pais_idpais_trabajo" value="{$paciente.pais_idpais_trabajo}">

                                <div class="okm-row">
                                    <div class="pul-col-x2">
                                        <div class="mapc-registro-form-row mapc-select pul-np-select">
                                            <select id="relacionGrupo_idrelacionGrupo" name="relacionGrupo_idrelacionGrupo"  class="form-control select select-primary select-block mbl" data-title='{"Seleccione la relación con el paciente"|x_translate}'>
                                                <option value="">{"Relación con el paciente"|x_translate}</option>
                                                {html_options options=$combo_relacion_grupo selected=$paciente.relacionGrupo_idrelacionGrupo}
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            {/if}

                            <div class="okm-row" >
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;"  class="btn-alert btnGuardarDatos">{"guardar"|x_translate}</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <!--Seccion identificacion - Visible para tituluar y Familiares de LUX (Tarjeta CNS propia)-->
                {if $paciente.titular==1 || $paciente.pais_idpais==2 || $paciente.pais_idpais_trabajo==2}
                    <div  class="panel panel-default">
                        {if $paciente.pais_idpais=="" || $paciente.pais_idpais_trabajo==""}
                            {assign "required_fields" true}
                        {/if}

                        <div class="panel-heading" role="tab" id="headingTwo">
                            <h4 class="panel-title">
                                <a class="collapsed" id="accordion-trg-2" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    {"Identificación"|x_translate}
                                    {if $required_fields }<i class="fa fa-exclamation-circle " style="margin-left: 10px;color: #ff6f6f;"></i>{/if}
                                    <i class="more-less fa {if $required_fields }fa-chevron-up{else}fa-chevron-down{/if} pull-right"></i>
                                </a>
                            </h4>
                        </div>

                        <div id="collapseTwo" class="panel-collapse collapse  {if $required_fields }in{/if} {if $paciente.beneficios_reintegro==1}{/if}" role="tabpanel" aria-labelledby="headingTwo">


                            {if $paciente.titular==1}
                                <!--Seleccionar pais resincia-trabajo-->
                                <div class="okm-row" id="div_paises" >
                                    <div class="pul-col-x2" >
                                        <div class="mapc-registro-form-row mapc-select pul-np-select">
                                            <label class="mapc-label">{"País de residencia"|x_translate}</label>
                                            <select id="pais_idpais" name="pais_idpais"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                <option value="" selected>{"País de residencia"|x_translate}</option>
                                                <option value="1" {if $paciente.pais_idpais==1}selected{/if}>{"Francia"|x_translate}</option>  
                                                <option value="2" {if $paciente.pais_idpais==2}selected{/if}>{"Luxemburgo"|x_translate}</option>
                                                <option value="3" {if $paciente.pais_idpais==3}selected{/if}>{"Bélgica"|x_translate}</option>
                                                <option value="4" {if $paciente.pais_idpais==4}selected{/if}>{"Otro país"|x_translate}</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="pul-col-x2" >
                                        <div class="mapc-registro-form-row mapc-select pul-np-select">
                                            <label class="mapc-label">{"País de trabajo"|x_translate}</label>
                                            <select id="pais_idpais_trabajo" name="pais_idpais_trabajo"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                <option value="" selected>{"País de trabajo"|x_translate}</option>                        
                                                <option value="1" {if $paciente.pais_idpais_trabajo==1}selected{/if}>{"Francia"|x_translate}</option>  
                                                <option value="2" {if $paciente.pais_idpais_trabajo==2}selected{/if}>{"Luxemburgo"|x_translate}</option>
                                                <option value="3" {if $paciente.pais_idpais_trabajo==3}selected{/if}>{"Bélgica"|x_translate}</option>
                                                <option value="4" {if $paciente.pais_idpais_trabajo==4}selected{/if}>{"Otro país"|x_translate}</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <!-- Seccion check beneficia reintegro seguridad social-->
                                <div class="okm-row">
                                    <div class="mapc-politicas-box" id="div_beneficio_reintegro" style="padding:0px;" >


                                        <div class="mapc-politicas-check-box">
                                            <div class="mapc-politicas-check-holder">
                                                <label class="checkbox">
                                                    <input type="checkbox"  id="con_beneficios_reintegro" value="1" name="beneficios_reintegro"  {if $paciente.beneficios_reintegro=="1"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                                </label>
                                            </div>
                                            <div class="mapc-politicas">
                                                <p>{"Quiero beneficiarme del reintegro de mis consultas médicas y demás beneficios adicionales"|x_translate}</p>
                                            </div>
                                        </div>
                                        <div class="mapc-politicas-holder">

                                            <div class="mapc-politicas">
                                                <p>
                                                    {"Si quiere tener acceso a beneficios adicionales usando su cuenta, tendrá que agregar información sobre su tarjeta de seguridad social"|x_translate}
                                                </p>

                                            </div>
                                        </div>

                                    </div>
                                </div>
                            {/if}
                            <!-- Contenedor de numero y tarjetas de identificacion-->
                            {include file="pacientes/tarjetas_identificacion.tpl"}
                            <!-- Fin contenedor-->

                            {if $paciente.titular==1}
                                <!-- Seccion agregar medico cabecera-->
                                <div id="buscador_medico_cabecera_container" style="display:none">
                                    {include file="pacientes/buscador_medico_cabecera.tpl"}
                                </div>
                            {/if}
                            <!-- FIN Seccion agregar medico cabecera-->
                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;"  class="btn-alert btnGuardarDatos">{"guardar"|x_translate}</a>
                                </div>
                            </div>
                        </div>


                    </div> 
                {/if}
                <!--privacidad-->
                <div class="panel panel-default">

                    <div class="panel-heading" role="tab" id="headingThree">
                        <h4 class="panel-title">  
                            <a role="button" id="accordion-trg-3"data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="true" aria-controls="collapseThree">
                                {"Privacidad"|x_translate}
                                <i class="more-less fa fa-chevron-down pull-right"></i>
                            </a>
                        </h4>
                    </div>
                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                        <div class="panel-body">
                            <div class="okm-row">
                                <div class="mapc-registro-form-row">
                                    <div class="pul-np-privacidad-trg"><i class="icon-doctorplus-lock"></i> {"¿Quién podrá ver el Perfil de salud este paciente?"|x_translate}</div>
                                </div>
                            </div>

                            <div class="okm-row pul-np-option-center pul-permisos-checks">
                                <div class="pul-permisos-col">
                                    <label class="radio pul-np-radio">
                                        <input type="radio" id="permisos-nadie" name="privacidad_perfil_salud" {if $paciente.privacidad_perfil_salud === "0"}checked{/if} value="0">
                                        {"Nadie"|x_translate}
                                    </label>

                                    <label class="radio pul-np-radio">
                                        <input type="radio" id="permisos-frecuentes" name="privacidad_perfil_salud" {if $paciente.privacidad_perfil_salud === "1"}checked{/if} value="1">
                                        {"Profesionales frecuentes"|x_translate}
                                    </label>

                                    <label class="radio pul-np-radio">
                                        <input type="radio" id="permisos-todos" name="privacidad_perfil_salud" {if $paciente.privacidad_perfil_salud === "2"}checked{/if} value="2">
                                        {"Todos los profesionales de DoctorPlus"|x_translate}
                                    </label>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div id="permisos-nadie-disclaimer" class="perfil-permisos-disclaimer"  {if $paciente.privacidad_perfil_salud === "0"}style="display:block"{/if}>
                                    <div class="icon-box">
                                        <i class="icon-doctorplus-alert-round"></i>
                                    </div>
                                    <p>
                                        {"El Perfil de Salud solo será visible para la ti."|x_translate}
                                        {"Varias funcionalidades del sistema se encontrarán limitadas por ej. no podras realizar consultas médicas a distancia para este paciente."|x_translate}
                                    </p>
                                </div>

                                <div id="permisos-frecuentes-disclaimer" class="perfil-permisos-disclaimer"  {if $paciente.privacidad_perfil_salud === "1"}style="display:block"{/if}>
                                    <div class="icon-box">
                                        <i class="icon-doctorplus-alert-round"></i>
                                    </div>
                                    <p>
                                        {"El Perfil de Salud solo será visible a los Profesionales Frecuentes o profesionales con los que hayas solicitado un turno."|x_translate}
                                        {"Recuerda que varias funcionalidades del sistema se encontrarán limitadas por ej. no podras enviar consultas médicas simultáneas al resto de los profesionales de la Red."|x_translate}
                                    </p>
                                </div>

                            </div>

                            <div class="okm-row">
                                <div class="pul-np-politicas">
                                    <p>
                                        {"La  información de registro de su cuenta de usuario se almacenta encriptada en nuestra base de datos."|x_translate}
                                    </p>
                                    <p class="disclaimer text-center">{"Consulte nuestra"|x_translate} 
                                        <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
                                        <span>{"así como el"|x_translate}&nbsp;</span>
                                        <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow" target="_blank">{"Consentimiento del usuario"|x_translate}</a>.

                                    </p>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;"  class="btn-alert btnGuardarDatos">{"guardar"|x_translate}</a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- FIN privacidad-->

            </div>

        </div>

    </form>
</section>
<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js"></script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js"></script>

{x_load_js}
{/if}