<style>
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .mapc-select{
        margin-top: 0px;
    }
    .datos-registro p{
        font-style: italic;
        padding-left: 15px;
        font-size: 16px;
        display: inline-block;
    }
    .form.edit .datos-registro label {
        display: block;
        font-weight: 600;
        display: inline-block;
    }
    .form.edit .datos-registro .cont-imagen{
        float:none;
    }
</style>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<div id="div_menu_usuario"></div>
<script>
    x_loadModule('usuario', 'menu_usuario', 'sm={$submodulo}', 'div_menu_usuario');
</script>


<section class="form edit info-profesional-form">
    <div class="container">
        <h2 class="text-center">{"Información Profesional"|x_translate} </h2>

        <!-- foto de perfil-->
        {include file="usuario/foto_perfil.tpl"}


        <form id="frm_medico" role="form" action="{$url}save_medico.do" method="post" >
            <input type="hidden" id="pais_idpais" name="pais_idpais" value="{$medico.pais_idpais}"/>
            <input type="hidden" id="tipo_especialidad" name="tipo_especialidad" value="{$medico_especialidad.0.tipo}"/>



            <div class="col-xs-12">

                {if $medico.pais_idpais==1}

                    <div class="row" >
                        {if $medico_especialidad.0.requiere_sector=="1"}
                            <div class="col-md-4 col-md-offset-2">
                                <label>{"Sector"|x_translate}</label>
                                <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                                    <div class="okm-select">
                                        <select name="sector_idsector" id="sector_idsector" class="form-control select select-primary select-block mbl">
                                            <option value="">{"Sector"|x_translate}...</option>
                                            {html_options options=$combo_sector selected=$medico.sector_idsector}
                                        </select>
                                    </div>

                                </div>


                            </div>
                        {/if}
                        {if $medico_especialidad.0.requiere_numero_am=="1"}
                            <div class="col-md-4  {if $medico_especialidad.0.requiere_sector!="1"} col-md-offset-2{/if}">
                                <label>{"Número AM"|x_translate}</label>
                                <div class="field-edit dp-edit">
                                    <input type="number"  id="numero_am"  name="numero_am" maxlength="9" value="{$medico.numero_am}" />
                                </div>
                            </div>
                        {/if}
                    </div>
                    {if $medico_especialidad.0.requiere_modo_facturacion=="1"}
                        <div class="row" >
                            <div class="col-md-4 col-md-offset-2">
                                <label>{"Facturacion teleconsulta"|x_translate}</label>
                                <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                                    <div class="okm-select">
                                        <select name="facturacion_teleconsulta" id="facturacion_teleconsulta" class="form-control select select-primary select-block mbl">
                                            <option value="">{"Facturacion teleconsulta"|x_translate}...</option>
                                            <option value="1" {if $medico.facturacion_teleconsulta==1}selected{/if}>{"Teletransmision caja 'mode dégradé'"|x_translate}</option>
                                            <option value="2" {if $medico.facturacion_teleconsulta==2}selected{/if}>{"Envio por el paciente"|x_translate}</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <p id="p_teletransmision_caja" style="{if $medico.facturacion_teleconsulta==1}display:block;{else}display:none;{/if} font-size: 14px;line-height:1.5;">* Choisissez cette option si votre logiciel professionnel vous permet de télétransmettre en mode dégradé. Vous retrouverez sur votre relevé de compte un récapitulatif détaillé et imprimable de toutes les consultations réalisées (identification du patient, numéro carte vitale, code CPAM, tarif correspondant incluant la majoration applicable etc…) Vous pourrez utiliser ces informations pour envoyer une FSE en mode “dégradé”.</p>
                                <p id="p_envio_paciente"style="{if $medico.facturacion_teleconsulta==2}display:block;{else}display:none;{/if} font-size: 14px;line-height:1.5;">* Choisissez cette option si vous ne pratiquez pas la télétransmission de FSE en mode dégradé. Vous retrouverez sur votre relevé de compte un récapitulatif détaillé et imprimable de toutes les consultations réalisées (identification du patient, numéro carte vitale, code CPAM, tarif correspondant incluant la majoration applicable etc…) Vous pourrez utiliser ces informations pour envoyer à votre patient une feuille de soin papier, qu’ils pourront ensuite envoyer à leur CPAM pour être remboursés. </p>

                            </div>
                        </div>
                    {/if}
                    {*<div class="row">
                    <div class="col-md-4 col-md-offset-2">  
                    <label>
                    {"PREFERENCIAS DE PAGO DE VIDEOCONSULTAS"|x_translate}
                    </label>
                    <label class="radio" style="margin-left: 20px;">
                    {"Solo mis pacientes no pagan "|x_translate}
                    <input type="radio" {if $medico.vc_reintegro=="1"}checked{/if} name="vc_reintegro" value="1"/>
                    </label>
                    <label class="radio"  style="margin-left: 20px;">
                    {"Todos los pacientes no pagan"|x_translate}
                    <input type="radio" {if $medico.vc_reintegro=="2"}checked{/if} name="vc_reintegro" value="2"/>
                    </label>
                    
                    </div>
                    <div class="col-md-6">
                    <p  style="display:block; font-size: 14px;line-height:1.5; margin-top:42px">* {"Seleccione los tipos de pacientes para los cuales usted no quiere cobrar la consulta por parte del paciente"|x_translate}</p>
                    </div>
                     
                    </div>*}

                    <div class="clearfix">&nbsp;</div>
                {/if}
            </div>
            <div class="col-xs-12">
                <div class="clearfix"></div>
                <div class="row">
                    <div class="col-md-9 col-md-offset-2">
                        <label class="mult-textarea-label" for="resume">{"CV / Formación académica y experiencia profesional"|x_translate}</label>
                        <textarea class="resume" id="formacionAcademica" name="formacionAcademica" rows="4">{$medico.formacionAcademica}</textarea>
                    </div>
                </div>
                <div class="clearfix">&nbsp;</div>
                <div class="row">
                    <div class="col-md-9 col-md-offset-2">
                        <label class="mult-textarea-label" for="memberships">{"Miembro de Asociaciones Médicas"|x_translate}</label>
                        <textarea class="memberships" id="experienciaProfesional" name="experienciaProfesional" rows="4">{$medico.experienciaProfesional}</textarea>
                    </div>
                </div>
                <div class="clearfix">&nbsp;</div>
            </div>
        </form>  
        <div class="col-xs-12">
            <div class="row web-profesional-container">
                <div class="col-md-3 col-md-offset-2">
                    <label>{"Agregar una web profesional"|x_translate}</label>
                    <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                        <div class="okm-select">
                            <select name="tipo_web" id="tipo_web" class="form-control select select-primary select-block mbl">
                                <option value="web">{"Sitio web profesional"|x_translate}</option>
                                <option value="linkedin">{"LinkedIn"|x_translate}</option>
                                <option value="youtube">{"YouTube"|x_translate}</option>
                                <option value="facebook">{"Facebook"|x_translate}</option>
                                <option value="instagram">{"Instagram"|x_translate}</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <label>{"URL del sitio"|x_translate}</label>
                    <div class="dp-edit-container input-group">
                        <span class="input-group-addon web-profesional-icon" >
                            <i class="fa fa-link web"></i>
                            <i class="fa fa-linkedin linkedin" style="display:none;"></i>
                            <i class="fa fa-youtube youtube" style="display:none;"></i>
                            <i class="fa fa-facebook facebook" style="display:none;"></i>
                            <i class="fa fa-instagram instagram" style="display:none;"></i>
                        </span>
                        <div class="field-edit dp-edit">
                            <input type="text" class="url_web" name="url_web" id="url_web" placeholder="https://www.example.com" />
                        </div>
                    </div>
                </div>
                <div class="col-md-2 text-center">
                    <button id="btnGuardarWebProfesional" type="submit" class="btn-default btn btn-xs">{"Agregar"|x_translate}&nbsp;<i class='fa fa-check'></i></button>
                </div>
                <div class="clearfix">&nbsp;</div>
                <div class="col-md-9 col-md-offset-2" id='web_profesional_list_container'>
                    {include file="usuario/web_profesional_list.tpl"}
                </div>
                <div class="clearfix">&nbsp;</div>
            </div>
        </div>
        <div class="mul-submit-box">
            <button id="btnGuardarInfoPersonal" type="submit" class="save-data btn-default">{"Guardar"|x_translate}</button>
        </div>

        <!-- fin foto-->

        <div class="col-xs-12">
            <div class="mul-group-set datos-registro">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <p class="mul-mod-disclaimer">
                            {"Para modificar los datos deshabilitados deberá ponerse en contacto con el Sector Administrativo de DoctorPlus. Se le solicitará la documentación necesaria para validación de los mismos."|x_translate}
                        </p>
                        <div class="mul-picture-disclaimer-action-box">
                            <a href="javascript:;" id="btnSolicitudModificacion">{"Solicitar modificación de datos"|x_translate}</a>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Nombre"|x_translate}:</label>
                        <p>{$medico.nombre}</p>
                    </div>
                    <div class="col-md-4">
                        <label>{"Apellido"|x_translate}:</label>
                        <p>{$medico.apellido} </p>
                    </div>
                </div>

                <div class="row">


                    <div class="col-md-4 col-md-offset-2">
                        <label >{"Sexo"|x_translate}:</label>
                        {if $medico.sexo ==1} 
                            <p>{"HOMBRE"|x_translate}</p>
                        {/if}
                        {if $medico.sexo ==0} 
                            <p>{"MUJER"|x_translate}</p>
                        {/if}
                    </div>
                    <div class="col-md-4">
                        <label>{"Celular"|x_translate}:</label>
                        <p>
                            {$medico.numeroCelular}
                        </p>
                    </div>
                </div>

                <div class="row" >


                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Especialidad"|x_translate}:</label>
                        <p>{$medico_especialidad.0.especialidad}</p>

                    </div>
                    {if $medico.pais_idpais==1}
                        {if $medico_especialidad.0.tipo_identificacion == "1"}
                            <div class="col-md-4 ">
                                <label>{"Número ADELI"|x_translate}:</label>
                                <p>{$medico.numero_adeli}<p>
                            </div>
                        {else}
                            {if $medico_especialidad.0.tipo_identificacion == "0"}
                                <div class="col-md-4 ">
                                    <label>{"Número de tarjeta RPPS"|x_translate}:</label>
                                    <p>{$medico.numero_rpps}</p>
                                </div>
                            {else}
                                <div class="col-md-4 ">
                                    <label>{"Número de identificación"|x_translate}:</label>
                                    <p>{$medico.numero_identificacion}<p>
                                </div>
                            {/if}
                        {/if}
                    {/if}

                </div>

                <div class="row" >


                    <div class="col-md-4 col-md-offset-2 col-sm-12  col-xs-12">

                        <label>{"Foto de tarjeta de identificación"|x_translate}:</label>
                        <div class="col-xs-6 cont-imagen">                                               
                            {if $imagenes_tarjetas.dni.path!=""}
                                <a href="{$imagenes_tarjetas.dni.path}" target="_blank"> 
                                    {if $imagenes_tarjetas.dni.ext==".pdf"}
                                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="50px" height="50px"  id="cont-imagen-dni" >
                                    {else}
                                        <img src="{$imagenes_tarjetas.dni.path}"width="140" height="80"  id="cont-imagen-dni" >
                                    {/if}

                                </a>
                            {else}
                                <img src="{$IMGS}extranet/no-photo.png" width="80" height="80"  id="cont-imagen-dni" >
                            {/if}
                        </div>
                    </div>
                    {if $medico.pais_idpais==1}

                        <div class="col-md-4  col-sm-12 col-xs-12">

                            {if $medico_especialidad.0.tipo_identificacion == "1"}
                                <label >{"Foto Adeli"|x_translate}:</label>
                            {else}
                                {if $medico_especialidad.0.tipo_identificacion == "0"}
                                    <label>{"Foto de tarjeta CPS"|x_translate}:</label>
                                {else}
                                    <label >{"Foto de título"|x_translate}:</label>
                                {/if}
                            {/if}

                            <div class="col-xs-6 cont-imagen">                                               

                                {if $imagenes_tarjetas.cps.path!=""}
                                    <a href="{$imagenes_tarjetas.cps.path}" target="_blank"> 
                                        {if $imagenes_tarjetas.cps.ext==".pdf"}
                                            <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="50px" height="50px"  id="cont-imagen-cps" >
                                        {else}
                                            <img src="{$imagenes_tarjetas.cps.path}" width="140" height="80"  id="cont-imagen-cps" >
                                        {/if}
                                    </a>
                                {else}
                                    <img src="{$IMGS}extranet/no-photo.png" width="80" height="80" alt='{"Imagen"|x_translate}'  id="cont-imagen-cps" >
                                {/if}
                            </div>
                        </div>
                    {/if}
                </div>
                <div class="clearfix">&nbsp;</div>
            </div>
        </div>
    </div>

</section>
<!--	Modal Enviar Solicitud Cambio Datos	-->


<div class="modal fade bs-example-modal-lg  modal-chrome " id="modal-solicitud-modificacion-datos" data-load="no" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="chrome-modal-holder">
                    <form id="f_solicitud" role="form" action="{$url}panel-medico/solicitud_modificacion_datos_profesionales.do" method="POST" onsubmit="return false;">
                        <h2>{"Solicitud de modificación de datos"|x_translate}</h2>

                        <textarea class="form-control" placeholder='{"Mensaje"|x_translate}' name="mensaje" rows="6"></textarea>

                        <div class="clear-fix">&nbsp;</div>
                        <div class="mul-submit-box text-center">
                            <button class="save-data btn-default" id="btnEnviarSolicitudModificacion" type="submit" > {"Enviar"|x_translate}</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<script language="javascript" type="text/javascript">
    $(document).ready(function (e) {

        $("#experienciaProfesional,#formacionAcademica").summernote({
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']]
            ]

        });

        $('#sexo-switch').bootstrapSwitch('onText', x_translate('Varón'));
        $('#sexo-switch').bootstrapSwitch('offText', x_translate('Mujer'));



        $("#frm_medico").submit(function (e) {
            e.preventDefault();
        });

        $("#frm_preferenciaMedico").submit(function (e) {
            e.preventDefault();
        });

        //listener cambio tipo link web personal
        $("#tipo_web").click(function () {
            let tipo = $("#tipo_web").val();
            $(".web-profesional-icon i").hide();
            $(".web-profesional-icon i." + tipo).show();
        });

        //cargar nuevo web personal
        $("#btnGuardarWebProfesional").click(function () {
            if ($("#tipo_web").val() === "" || $("#url_web").val() === "") {
                x_alert(x_translate("Ingrese el link de su web profesional que desea cargar"));
                return false;
            }

            $("body").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "medico.php?action=1&modulo=usuario&submodulo=agregar_web_profesional",
                    "url_web=" + $("#url_web").val() + "&tipo_web=" + $("#tipo_web").val(),
                    function (data) {

                        if (data.result) {
                            //recargamos el modulo del listado
                            x_loadModule('usuario', 'web_profesional_list', '', 'web_profesional_list_container').then(function () {
                                $("body").spin(false);
                                //resetarmos los campos para cargar la web
                                $("#url_web").val("");
                                $("#tipo_web").val("web");
                                $(".web-profesional-icon i").hide();
                                $(".web-profesional-icon i.web").show();

                                renderUI2("Main");
                                x_alert(data.msg);
                            });
                        } else {

                            $("body").spin(false);
                            x_alert(data.msg);
                        }
                    }
            );

        });
    });
</script>
{x_load_js}
