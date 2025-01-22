<style>
    .mapc-registro-box {
        margin: 10px auto;
    }
    .mapc-politicas-box {
        margin: 12px auto;
    }
    .mapc-politicas-box .mapc-politicas p{
        color: #415b70;
        font-size: 14px;
        line-height: 18px;
        margin-bottom: 10px;
    }
    .mapc-registro-form-row .btn-siguiente,.mapc-registro-form-row .btn-crear-cuenta{
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver{
        min-width:auto !important;
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver:hover{
        background: #b6b6b6 !important;
    }
    @media (max-width: 600px){
        .plogin-registro-accordios-title {
            font-size: 13px;
            padding: 8px;
        }
    }
    .mapc-select {
        margin-top: 0px;
    }
    .mapc-select .mbl{
        margin-bottom: 0px;
    }
    .plogin-mensaje-registro p {
        margin: auto auto 24px;
    }
    .plogin-mensaje-registro .plogin-mensaje-registro-actions{
        margin-bottom: 24px;
    }
    /*mostrar contraseña*/
    .mapc-input-line>.btnShowPassword{
        font-size: 24px;
        line-height: 22px;
        display: inline-block;
        position: absolute;
        top: 19px;
        right: 22px;
        /*color: #d8d8d8;*/
    }

    .btnShowPassword i {
        cursor:pointer;
    }
    /*archivos identificacion*/
    .cont-imagen{
        width:165px;
        height: 80px;
    }
    .cont-imagen.pdf{
        width:80px;
        height: 80px;
    }
    .upload-filename label{
        display:inline
    }
    .upload-filename .btn-delete-file {
        color: #f33243;
    }
</style>
{include file="paciente/menu.tpl"}

{include file="home/login.tpl"}


<div class="plogin-header">
    <h1>{"Crear una cuenta"|x_translate}</h1>
    <h2>{"Paciente"|x_translate}</h2>
    <h3>{"Para descubrir el Equipo :)"|x_translate}</h3>
</div>

<section  class="plogin-registro">



    <div id="registroAccordon" class="mapc-registro-box pul-nuevo-paciente-accordion">


        <h4 class="plogin-registro-accordios-title">{"REGISTRARME COMO USUARIO"|x_translate} <span id="span_steps" class="pull-right visible-xs">1/6</span></h4>

        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">

                <div class="row">
                    <div class="col-md-12 portlets">
                        <!-- Your awesome content goes here -->
                        <div class="widget animated fadeInDown">

                            <div id="wizard_registro_paciente">
                                <section class="step"  data-step-title="" data-callback='step1' >
                                    <form id="form_registro_paciente_step1" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="1" />
                                        <input type="hidden" class="g-recaptcha-response" name="g-recaptcha-response" value="" />
                                        <div id="cont_1">
                                            <div class="panel-body">
                                                <input type="hidden" name="password" id="password" value="" />
                                                <div class="okm-row">
                                                    <div class="pul-col-x2">

                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Correo electrónico"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="text" class="pul-np-dis" name="email" tabindex='7' id="email_input" placeholder='{"ej: su-nombre@dominio.com"|x_translate}'/>
                                                                <i class="icon-doctorplus-envelope"></i>
                                                            </div>
                                                        </div>

                                                        <div class="mapc-registro-form-row">
                                                            <div class="mapc-input-line">
                                                                <input type="text" class="pul-np-dis" name="mail2"  tabindex='8' id="reemail_input" placeholder='{"Repita correo electrónico"|x_translate}'/>
                                                                <i class="icon-doctorplus-envelope"></i>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    <div class="pul-col-x2">
                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Celular"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="tel" class="pul-np-dis" name="numeroCelular" tabindex='10' id="telefono_input" />
                                                                <i class="icon-doctorplus-cel"></i>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="okm-row">
                                                    <div class="pul-col-x2">

                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Contraseña"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="password" class="pul-np-dis input_password_strength" tabindex='8' id="password_aut" placeholder='{"Contraseña de al menos 8 caracteres"|x_translate}'/>
                                                                <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                                                            </div>
                                                        </div>

                                                        <div class="mapc-registro-form-row">
                                                            <div class="mapc-input-line">
                                                                <input type="password" class="pul-np-dis input_password_strength" tabindex='9' id="repassword_aut" placeholder='{"Repita contraseña"|x_translate}'/>
                                                                <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                                <!-- Terminos y condiciones + BTN registro -->
                                                <div class="okm-row">
                                                    <div class="mapc-politicas-box" id="politicas">

                                                        <div class="mapc-politicas-check-box">
                                                            <div class="mapc-politicas-check-holder">
                                                                <label class="checkbox">
                                                                    <input type="checkbox"  id="terminos_condiciones" value="1" name="terminos_condiciones" data-toggle="checkbox" class="custom-checkbox">
                                                                </label>
                                                            </div>
                                                            <div class="mapc-politicas">
                                                                <p>
                                                                    <span>{"He leído y acepto los"|x_translate}&nbsp;</span>
                                                                    <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
                                                                    <span>{"así como el"|x_translate}&nbsp;</span>
                                                                    <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow" target="_blank">{"Consentimiento del usuario"|x_translate}</a>.
                                                                </p>                                                        
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>         

                                                <div class="okm-row">
                                                    <div class="mapc-registro-form-row center">
                                                        <a href="javascript:;" class="btn-default btn-siguiente" data-step="1" >{"siguiente"|x_translate}</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step2'> 
                                    <form id="form_registro_paciente_step2" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="2" />
                                        <input type="hidden" class="idpaciente" name="idpaciente" value="" />


                                        <div  id="cont_2">

                                            <div class="okm-row">
                                                <div class="pul-col-x2 form-element-center ">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Código"|x_translate}</label>
                                                        <input type="text" id="codigo_input" tabindex='1' name="codigoValidacionCelular" maxlength="15"/>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="okm-row">
                                                <div class="mapc-politicas-box">


                                                    <div class="mapc-politicas-holder">
                                                        <figure>
                                                            <i class="icon-doctorplus-cel"></i>
                                                        </figure>
                                                        <div class="mapc-politicas">
                                                            <p>{"Por su seguridad, le hemos enviado un mensaje con el código de uso único. Ingrese el código a continuación para continuar."|x_translate}</p>
                                                            <p>{"El mismo puede demorar unos minutos en llegar, aguarde. Si quiere generar el código nuevamente haga"|x_translate} <a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a></p>

                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="1" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="2" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step3'> 
                                    <form id="form_registro_paciente_step3" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="3" />
                                        <input type="hidden" class="idpaciente" name="idpaciente" value="" />

                                        <div  id="cont_3">

                                            <div class="okm-row">
                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Nombre"|x_translate}</label>
                                                        <input type="text" id="nombre_input" tabindex='1' name="nombre" maxlength="15"/>
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Apellido"|x_translate}</label>
                                                        <input type="text"  id="apellido_input" tabindex='2'name="apellido" maxlength="20" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="okm-row">
                                                <div class="pul-col-x2">
                                                    <div class="mapc-registro-form-row">
                                                        <label class="mapc-label">{"Fecha de nacimiento"|x_translate}</label>
                                                        <div class="mapc-input-line">
                                                            <input type="text" id="fechaNacimiento_input" tabindex='4' name="fechaNacimiento" />
                                                            <i class="icon-doctorplus-calendar"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2 " >
                                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                                        <label class="mapc-label">{"Sexo"|x_translate}</label>
                                                        <select id="sexo" name="sexo"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                            <option value="1" selected>{"HOMBRE"|x_translate}</option>
                                                            <option value="0" >{"MUJER"|x_translate}</option>
                                                        </select>
                                                    </div>
                                                </div>    
                                            </div>


                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="2" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="3" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step4'> 
                                    <form id="form_registro_paciente_step4" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                        <div  id="cont_4">
                                            <input type="hidden" name="step" value="4" />
                                            <input type="hidden" class="idpaciente" name="idpaciente" value="" />
                                            <!-- Terminos y condiciones + BTN registro -->
                                            <div class="okm-row">
                                                <div class="mapc-politicas-box" id="div_beneficio_reintegro">

                                                    <div class="mapc-politicas-check-box">
                                                        <div class="mapc-politicas-check-holder">
                                                            <label class="radio">
                                                                <input type="radio"  id="sin_beneficios_reintegro" value="0" name="beneficios_reintegro" data-toggle="radio" class="custom-checkbox">
                                                            </label>
                                                        </div>
                                                        <div class="mapc-politicas">
                                                            <p>{"Abrir una cuenta gratis rápidamente"|x_translate}</p>
                                                        </div>
                                                    </div>
                                                    <div class="mapc-politicas-check-box">
                                                        <div class="mapc-politicas-check-holder">
                                                            <label class="radio">
                                                                <input type="radio"  id="con_beneficios_reintegro" value="1" name="beneficios_reintegro" data-toggle="radio" class="custom-checkbox">
                                                            </label>
                                                        </div>
                                                        <div class="mapc-politicas">
                                                            <p>{"Agregar información para realizar teleconsultas médicas"|x_translate}</p>
                                                        </div>
                                                    </div>
                                                    <div class="mapc-politicas-holder">

                                                        <div class="mapc-politicas">
                                                            <p>
                                                                {"Deberá agregar su tarjeta de seguro social para identificarse"|x_translate}
                                                            </p>

                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <div class="okm-row" >
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="3" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="4" >{"siguiente"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-crear-cuenta" data-step="4" style="display:none;">{"crear cuenta"|x_translate}</a>
                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step5' >
                                    <form id="form_registro_paciente_step5" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="5" />
                                        <input type="hidden" class="idpaciente" name="idpaciente" value="" />

                                        <div  id="cont_5">

                                            <div class="okm-row">
                                                <div class="pul-col-x2  form-element-center" >
                                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                                        <select id="pais_idpais" name="pais_idpais"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                            <option value="" selected>{"Pais de residencia"|x_translate}</option>


                                                            <option value="1">{"Francia"|x_translate}</option>
                                                            <option value="2">{"Luxemburgo"|x_translate}</option>
                                                            <option value="3">{"Bélgica"|x_translate}</option>
                                                            <option value="4">{"Otro país"|x_translate}</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="pul-col-x2"  style="display:none;">


                                                </div>

                                            </div>
                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;" data-prev="4" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="5" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>
                                        </div>	
                                    </form>
                                </section>

                                <section class="step" data-step-title=""  data-callback='step6'>
                                    <div  id="cont_6">
                                        <form id="form_registro_paciente_step6" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=paciente_registracion" method="POST" onsubmit="return false;">
                                            <input type="hidden" name="step" value="6" />
                                            <input type="hidden" class="idpaciente" name="idpaciente" value="" />


                                            <p></p>

                                            <!-- CONTENEDOR Tarjeta Vitale -->
                                            <div class="okm-row" id="div_tarjeta_vitale" style="display:none;">
                                                <div class="pul-col-x2"  >
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Número de tarjeta Vitale"|x_translate}</label>
                                                        <input type="number"  id="tarjeta_vitale_input"  name="tarjeta_vitale" maxlength="15" />
                                                    </div>
                                                </div>

                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label">{"Agregar foto de tarjeta Vitale"|x_translate}</label>
                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-vitale" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-vitale" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successImgVitale = function (file, responseText) {


                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {

                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-vitale").addClass("pdf");

                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-vitale").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-vitale").text(responseText.fileName);
                                                                                $(".upload-filename.vitale").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-vitale").attr("src", src);
                                                                                $("#cont-imagen-vitale").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-vitale").show();

                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-vitale").data("hash", responseText.hash);
                                                                                $("#delete-imagen-vitale").data("name", responseText.fileName);
                                                                                $("#delete-imagen-vitale").data("tipo", "vitale");

                                                                            }
                                                                        };
                                                                        var startImgVitale = function () {

                                                                            $("#attachment-vitale").spin("large", '#000');
                                                                        };
                                                                        var stopImgVitale = function () {
                                                                            $("#attachment-vitale").spin(false);
                                                                        };
                                                                        var errorImgVitale = function (file, error) {
                                                                            $("#cont-imagen-vitale").hide();
                                                                            x_alert(error);
                                                                        };</script>
                                                                    {/literal}                                        

                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="vitale" form_id="frmRegistro" selector="#file-upload-vitale" preview="#hidden_upload_vitale" callback_success="successImgVitale" callback_start="startImgVitale" callback_stop="stopImgVitale" callback_error="errorImgVitale" }
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_vitale"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'>
                                                            <img id="cont-imagen-vitale" class="cont-imagen vitale" style="display: none" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'/>
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename vitale" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-vitale" class="btn-delete-file vitale" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-vitale"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- CONTENEDOR Tarjeta Pasaporte -->
                                            <div class="okm-row" id="div_tarjeta_pasaporte" style="display:none;">
                                                <div class="pul-col-x2"  >
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Número de tarjeta Pasaporte"|x_translate}</label>
                                                        <input type="text"  id="tarjeta_pasaporte_input"  name="tarjeta_pasaporte" maxlength="25" />
                                                    </div>
                                                </div>

                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label">{"Agregar foto de tarjeta Pasaporte"|x_translate}</label>
                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-pasaporte" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-pasaporte" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successImgPasaporte = function (file, responseText) {


                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {

                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-pasaporte").addClass("pdf");

                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-pasaporte").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-pasaporte").text(responseText.fileName);
                                                                                $(".upload-filename.pasaporte").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-pasaporte").attr("src", src);
                                                                                $("#cont-imagen-pasaporte").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-pasaporte").show();

                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-pasaporte").data("hash", responseText.hash);
                                                                                $("#delete-imagen-pasaporte").data("name", responseText.fileName);
                                                                                $("#delete-imagen-pasaporte").data("tipo", "pasaporte");

                                                                            }
                                                                        };
                                                                        var startImgPasaporte = function () {

                                                                            $("#attachment-pasaporte").spin("large", '#000');
                                                                        };
                                                                        var stopImgPasaporte = function () {
                                                                            $("#attachment-pasaporte").spin(false);
                                                                        };
                                                                        var errorImgPasaporte = function (file, error) {
                                                                            $("#cont-imagen-pasaporte").hide();
                                                                            x_alert(error);
                                                                        };</script>
                                                                    {/literal}                                        

                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="pasaporte" form_id="frmRegistro" selector="#file-upload-pasaporte" preview="#hidden_upload_pasaporte" callback_success="successImgPasaporte" callback_start="startImgPasaporte" callback_stop="stopImgPasaporte" callback_error="errorImgPasaporte" }
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_pasaporte"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'>
                                                            <img id="cont-imagen-pasaporte" class="cont-imagen pasaporte" style="display: none" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'/>
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename pasaporte" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-pasaporte" class="btn-delete-file pasaporte" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-pasaporte"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- CONTENEDOR Tarjeta eID -->
                                            <div class="okm-row" id="div_tarjeta_eID" style="display:none;">
                                                <div class="pul-col-x2"  >
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Número de tarjeta eID"|x_translate}</label>
                                                        <input type="number"  id="tarjeta_eID_input"  name="tarjeta_eID" maxlength="12" />
                                                    </div>
                                                </div>

                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label">{"Agregar foto de tarjeta eID"|x_translate}</label>
                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-eID" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-eID" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successImgeID = function (file, responseText) {


                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {

                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-eID").addClass("pdf");

                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-eID").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-eID").text(responseText.fileName);
                                                                                $(".upload-filename.eID").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-eID").attr("src", src);
                                                                                $("#cont-imagen-eID").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-eID").show();

                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-eID").data("hash", responseText.hash);
                                                                                $("#delete-imagen-eID").data("name", responseText.fileName);
                                                                                $("#delete-imagen-eID").data("tipo", "eID");

                                                                            }
                                                                        };
                                                                        var startImgeID = function () {

                                                                            $("#attachment-eID").spin("large", '#000');
                                                                        };
                                                                        var stopImgeID = function () {
                                                                            $("#attachment-eID").spin(false);
                                                                        };
                                                                        var errorImgeID = function (file, error) {
                                                                            $("#cont-imagen-eID").hide();
                                                                            x_alert(error);
                                                                        };</script>
                                                                    {/literal}                                        

                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="eID" form_id="frmRegistro" selector="#file-upload-eID" preview="#hidden_upload_eID" callback_success="successImgeID" callback_start="startImgeID" callback_stop="stopImgeID" callback_error="errorImgeID" }
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_eID"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'>
                                                            <img id="cont-imagen-eID" class="cont-imagen eID" style="display: none" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'/>
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename eID" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-eID" class="btn-delete-file eID" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-eID"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                            <p></p>
                                            <div class="okm-row">
                                                <div class="item-wrapper" id="div_trabaja_otro_pais"  style="display:none;">
                                                    <span class="question small">{"¿Trabaja en otro país?"|x_translate}</span>&nbsp;
                                                    <br>
                                                    <label class="radio" for="trabaja_otro_pais_si" style="display:inline">
                                                        <input type="radio" data-toggle="radio" value="1" id="trabaja_otro_pais_si" name="trabaja_otro_pais" class="custom-checkbox">
                                                        {"Si"|x_translate}
                                                    </label>
                                                    <label class="radio" for="trabaja_otro_pais_no" style="display:inline">
                                                        <input type="radio" data-toggle="radio" value="0" id="trabaja_otro_pais_no" name="trabaja_otro_pais"  class="custom-checkbox">
                                                        {"No"|x_translate}
                                                    </label>
                                                </div>
                                            </div>
                                            <p></p>
                                            <!-- CONTENEDOR Tarjeta CNS -->
                                            <div class="okm-row"  id="div_tarjeta_cns" style="display:none;" >
                                                <div class="pul-col-x2"  >
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Número de tarjeta CNS (Luxemburgo)"|x_translate}</label>
                                                        <input type="number"  id="tarjeta_cns_input"  name="tarjeta_cns" maxlength="13" />
                                                    </div>
                                                </div>

                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label">{"Agregar foto de tarjeta CNS"|x_translate}</label>
                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-cns" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-cns" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successImgCNS = function (file, responseText) {


                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {

                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-cns").addClass("pdf");

                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-cns").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-cns").text(responseText.fileName);
                                                                                $(".upload-filename.cns").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-cns").attr("src", src);
                                                                                $("#cont-imagen-cns").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-cns").show();

                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-cns").data("hash", responseText.hash);
                                                                                $("#delete-imagen-cns").data("name", responseText.fileName);
                                                                                $("#delete-imagen-cns").data("tipo", "cns");

                                                                            }
                                                                        };
                                                                        var startImgCNS = function () {

                                                                            $("#attachment-cns").spin("large", '#000');
                                                                        };
                                                                        var stopImgCNS = function () {
                                                                            $("#attachment-cns").spin(false);
                                                                        };
                                                                        var errorImgCNS = function (file, error) {
                                                                            $("#cont-imagen-cns").hide();
                                                                            x_alert(error);
                                                                        };</script>
                                                                    {/literal}                                        

                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="cns" form_id="frmRegistro" selector="#file-upload-cns" preview="#hidden_upload_cns" callback_success="successImgCNS" callback_start="startImgCNS" callback_stop="stopImgCNS" callback_error="errorImgCNS" }
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_cns"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'>
                                                            <img id="cont-imagen-cns" class="cont-imagen cns" style="display: none" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'/>
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename cns" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-cns" class="btn-delete-file cns" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-cns"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                            <div class="okm-row" id="div_no_trabajo_luxemburgo"  style="display:none;">
                                                <div class="item-wrapper">

                                                    <label class="checkbox" for="no_trabajo_luxemburgo" style="display:inline">
                                                        <input type="checkbox" data-toggle="checkbox" value="1" id="no_trabajo_luxemburgo" name="no_trabajo_luxemburgo" checked="" class="custom-checkbox">

                                                    </label>
                                                    <span class="question small">{"No trabajo en Luxemburgo y no tengo tarjeta CNS"|x_translate}</span>&nbsp;

                                                </div>
                                            </div>

                                            <p>&nbsp;</p>

                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="5" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-crear-cuenta" data-step="6">{"crear cuenta"|x_translate}</a>

                                                </div>
                                            </div>
                                        </form>
                                    </div>	

                                </section>


                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <div class="plogin-mensaje-registro" id="mensajeRegistro">
        <h3>{"¡Gracias por registrarse en DoctorPlus!"|x_translate}</h3>
        <h4>{"Su cuenta ha sido generada en el sistema."|x_translate}</h4>
        <p class="plogin-envio-correo">
            {"Se le ha enviado un email, siga los pasos indicados para activarla."|x_translate}
        </p>
        <div class="plogin-mensaje-registro-actions">
            <a href="{$url}portailsalaries" class="btn-default btnVolver">{"volver"|x_translate}</a>
        </div>
        <p>
            {"Recuerde poner a resguardo su información personal de ingreso al sistema (usuario y contraseña), la necesitará para administrar su cuenta."|x_translate}<br> 
            {"Existen aplicaciones para smartphones y tablets que sirven para almacenar y cuidar todas las claves de modo seguro."|x_translate}
        </p>

    </div>
</section>


<script>
    var RECAPTCHA_PUBLIC = "{$RECAPTCHA_PUBLIC}";
</script>
<script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}&data-badge=inline&data-size=invisible" async defer>
</script>

{literal}
    <script>
        $(function () {
            var step1 = function () {
                scrollToEl($("body"));

                $("#span_steps").text("1/6");
            };
            var step2 = function () {
                scrollToEl($("body"));

                $("#span_steps").text("2/6");
                //$("#codigo_input").inputmask("*****");
            };
            var step3 = function () {
                scrollToEl($("body"));

                $("#span_steps").text("3/6");
            };
            var step4 = function () {
                scrollToEl($("body"));

                $("#span_steps").text("4/6");
            };
            var step5 = function () {
                scrollToEl($("body"));
                $("#span_steps").text("5/6");
            };
            var step6 = function () {
                scrollToEl($("body"));
                $("#span_steps").text("6/6");
                var pais = $("#pais_idpais option:selected").val();
                $('#trabaja_otro_pais_si').radiocheck('uncheck');
                $('#trabaja_otro_pais_no').radiocheck('uncheck');
                $('#no_trabajo_luxemburgo').radiocheck('uncheck');
                $("#div_tarjeta_vitale").hide();
                $("#div_tarjeta_eID").hide();
                $("#div_tarjeta_cns").hide();
                $("#div_tarjeta_pasaporte").hide();
                $("#div_trabaja_otro_pais").hide();
                /**
                 *  56-Francia
                 *   14-Bélgica
                 *  92-Luxemburgo
                 *  222-Otro país
                 **/
                if (pais == 1) {
                    $("#div_tarjeta_vitale").show();
                    $("#div_trabaja_otro_pais").show();
                } else if (pais == 2) {
                    $("#div_tarjeta_cns").show();
                } else if (pais == 3) {
                    $("#div_tarjeta_eID").show();
                    $("#div_trabaja_otro_pais").show();
                } else if (pais == 4) {
                    $("#div_tarjeta_pasaporte").show();
                }

                $("#tarjeta_vitale_input").mask('000000000000000');
                $("#tarjeta_eID_input").mask('000000000000');
                $("#tarjeta_cns_input").mask('0000000000000');

            };

            //agregamos el + al numero de telefono
            $("#telefono_consultorio").on("keyup", function () {
                if ($(this).val().substring(0, 1) != "+") {
                    $(this).val("+" + $(this).val());
                }
            });

            var validarStep1 = function () {

                //validar email
                //expresion regular para mail
                $("#email_input").val($("#email_input").val().trim());
                $("#reemail_input").val($("#reemail_input").val().trim());
                if (!validarEmail($("#email_input").val())) {
                    $("#email_input").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#email_input").offset().top - 200}, 1000);
                    return false;
                }

                if ($("#reemail_input").val() == "") {
                    $("#reemail_input").data("title", x_translate("Reingrese su email")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#reemail_input").offset().top - 200}, 1000);
                    return false;
                }
                //coincidencia de los 2 email
                if ($("#email_input").val() != $("#reemail_input").val()) {
                    $("#reemail_input").data("title", x_translate("Las casillas de correo electrónico no coinciden")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#reemail_input").offset().top - 200}, 1000);
                    return false;
                }

                //validar contraseñas

                //Si el validador retorna que es muy débil la contraseña.
                if (!$("[data-meter='password_aut']").hasClass("strong")) {
                    $("#password_aut")
                            .data("title", x_translate("La contraseña es muy débil, debe tener al menos 8 caracteres, una mayúscula y un número"))
                            .tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#password_aut").offset().top - 100
                    }, 1000);
                    return false;
                }

                if ($("#password_aut").val() == "") {
                    $("#password_aut").data("title", x_translate("Ingrese una contraseña")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#password_aut").offset().top - 200}, 1000);
                    return false;
                }
                if ($("#repassword_aut").val() == "") {
                    $("#repassword_aut").data("title", x_translate("Reingrese su contraseña")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#repassword_aut").offset().top - 200}, 1000);
                    return false;
                }

                var password1 = $.trim($('#password_aut').val());
                var password2 = $.trim($('#repassword_aut').val());
                if (password1 !== password2) {
                    $("#repassword_aut").data("title", x_translate("Las contraseñas no coinciden")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#repassword_aut").offset().top - 200}, 1000);
                    return false;
                }

                //si hay telefono verifico la longitud

                if ($("#telefono_input").val() == "") {

                    $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#telefono_input").offset().top - 200}, 1000);
                    return false;
                } else {
                    if ($("#telefono_input").intlTelInput("isValidNumber")) {
                        //ok
                    } else {
                        if ($("#telefono_input").val().substring(0, 4) == "+337" && ($("#telefono_input").val().length == 12)) {
                            //ok
                        } else {
                            $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                            $('html, body').animate({
                                scrollTop: $("#telefono_input").offset().top - 200}, 1000);
                            return false;
                        }
                    }
                }
                if (!$("#terminos_condiciones").is(":checked")) {
                    x_alert(x_translate("Debe aceptar los términos y condiciones de uso del sistema"));
                    return false;
                }

                //codificamos la contraseña

                var valor = Base64.encode(SHA1(password1));
                $("#password").val(valor);
                $('#password_aut, #repassword_aut').val("");
                return true;
            };
            var validarStep2 = function () {

                //verificar codigo
                if ($("#codigo_input").val() == "") {
                    $("#codigo_input").data("title", x_translate("Ingrese el código de verificación para continuar")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#codigo_input").offset().top - 200}, 1000);
                    return false;
                }
                return true;
            }
            var validarStep3 = function () {

                //verificar nombre
                if ($("#nombre_input").val() == "") {
                    $("#nombre_input").data("title", x_translate("Ingrese su nombre")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#nombre_input").offset().top - 200}, 1000);
                    return false;
                }



                //verificar apellido
                if ($("#apellido_input").val() == "") {
                    $("#apellido_input").data("title", x_translate("Ingrese su apellido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#apellido_input").offset().top - 200}, 1000);
                    return false;
                }




                //verificar fecha de nacimiento
                if ($("#fechaNacimiento_input").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fechaNacimiento_input").val()))) {
                    $("#fechaNacimiento_input").data("title", x_translate("Ingrese una fecha de nacimiento válida: DD/MM/AAAA")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
                    return false;
                }



                //validar fecha futura
                var time_actual = new Date().getTime();
                var arr_split = $("#fechaNacimiento_input").val().split("/");
                var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                if (fecha_nac > time_actual) {
                    $("#fechaNacimiento_input").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
                    return false;
                }
                //validar mayor de edad
                var fecha_actual = new Date();
                var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 18);
                if (time_mayor_edad > time_actual) {
                    $("#fechaNacimiento_input").data("title", x_translate("El paciente titular debe ser mayor de edad")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
                    return false;
                }
                return true;
            };
            var validarStep4 = function () {
                if (!$("#sin_beneficios_reintegro").is(":checked") && !$("#con_beneficios_reintegro").is(":checked")) {


                    $("#div_beneficio_reintegro").data("title", x_translate("Seleccione una opción")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#div_beneficio_reintegro").offset().top - 200}, 1000);
                    return false;
                }
                return true;
            }
            var validarStep5 = function () {

                //verificar apellido
                if ($("#pais_idpais option:selected").val() == "") {
                    $("#pais_idpais").data("title", x_translate("Seleccione su país de residencia")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#pais_idpais").offset().top - 200}, 1000);
                    return false;
                }
                return true;
            };
            var validarStep6 = function () {
                /**
                 *  56-Francia
                 *   14-Bélgica
                 *  92-Luxemburgo
                 *  222-Otro país
                 **/
                var pais = $("#pais_idpais option:selected").val();
                //Francia
                if (pais == 1) {
                    if ($("#tarjeta_vitale_input").val() == "") {
                        $("#tarjeta_vitale_input").data("title", x_translate("Ingrese su número de tarjeta Vitale")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_vitale_input").offset().top - 200}, 1000);
                        return false;
                    }

                    if (!$("#trabaja_otro_pais_si").is(":checked") && !$("#trabaja_otro_pais_no").is(":checked")) {
                        $("#div_trabaja_otro_pais").data("title", x_translate("Seleccione si trabaja en otro país")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#trabaja_otro_pais_si").offset().top - 200}, 1000);
                        return false;
                    }

                    if ($("#trabaja_otro_pais_si").is(":checked") && $("#tarjeta_cns_input").val() == "" && !$('#no_trabajo_luxemburgo').is(":checked")) {
                        $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                        return false;
                    }

                } else if (pais == 2) {
                    //Luxemburgo
                    if ($("#tarjeta_cns_input").val() == "") {
                        $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                        return false;
                    }
                } else if (pais == 3) {
                    //Belgica
                    if ($("#tarjeta_eID_input").val() == "") {
                        $("#tarjeta_eID_input").data("title", x_translate("Ingrese su número de tarjeta e-ID")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_eID_input").offset().top - 200}, 1000);
                        return false;
                    }

                    if (!$("#trabaja_otro_pais_si").is(":checked") && !$("#trabaja_otro_pais_no").is(":checked")) {
                        $("#div_trabaja_otro_pais").data("title", x_translate("Seleccione si trabaja en otro país")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#trabaja_otro_pais_si").offset().top - 200}, 1000);
                        return false;
                    }

                    if ($("#trabaja_otro_pais_si").is(":checked") && $("#tarjeta_cns_input").val() == "" && !$('#no_trabajo_luxemburgo').is(":checked")) {
                        $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                        return false;
                    }

                } else if (pais == 4) {
                    //Otro Pais
                    if ($("#tarjeta_pasaporte_input").val() == "") {
                        $("#tarjeta_pasaporte_input").data("title", x_translate("Ingrese su número de tarjeta Pasaporte")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#tarjeta_pasaporte_input").offset().top - 200}, 1000);
                        return false;
                    }
                }
                return true;
            };

            $(document).ready(function () {


                $('#wizard_registro_paciente').easyWizard({
                    showButtons: false,
                    submitButton: false,
                    before: function (wizardObj, currentStepObj, nextStepObj) {

                        var callback = nextStepObj.data("callback");
                        if (typeof (callback) != "undefined") {
                            eval(callback + "()");
                        }

                    },
                    beforeSubmit: function (wizardObj) {
                    }
                });
                //plugin numero celular
                $("#telefono_input").intlTelInput({
                    nationalMode: false,
                    preferredCountries: ['fr', 'be', 'lu'],
                    utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
                });
                $("#telefono_input").mask("+0000000000000");
                //agregamos el + al numero de telefono
                $("#telefono_input").on("keyup", function () {
                    if ($(this).val().substring(0, 1) != "+") {
                        $(this).val("+" + $(this).val());
                    }
                });
                $('#password_aut,#repassword_aut').strength({
                    strengthClass: 'input_password_strength',
                    strengthMeterClass: 'strength_meter',
                    strengthButtonClass: 'button_strength',
                    strengthButtonText: 'Show Password',
                    strengthButtonTextToggle: 'Hide Password'
                });
                $(".button_strength").hide();

                $("#sin_beneficios_reintegro").on('change.radiocheck', function () {
                    $("#cont_4 .btn-crear-cuenta").show();
                    $("#cont_4 .btn-siguiente").hide();

                });

                $("#con_beneficios_reintegro").on('change.radiocheck', function () {
                    $("#cont_4 .btn-crear-cuenta").hide();
                    $("#cont_4 .btn-siguiente").show();

                });

                $(".btn-siguiente").click(function (e) {
                    e.preventDefault();
                    var step = $(this).data("step");
                    grecaptcha.ready(function () {
                        grecaptcha.execute(RECAPTCHA_PUBLIC, {action: 'submit'}).then(function (token) {
                            $(".g-recaptcha-response").val(token);

                            //limpiamos los tooltip de validacion anteriores
                            $.each($('#form_registro_paciente_step' + step + ' input'), function (index, error) {
                                var $element = $(error);
                                $element.tooltip("destroy");
                            });
                            $.each($('#form_registro_paciente_step' + step + ' div'), function (index, error) {
                                var $element = $(error);
                                $element.tooltip("destroy");
                            });
                            var validacion = eval("validarStep" + step + "()");
                            if (validacion) {

                                $("body").spin("large");
                                x_sendForm($('#form_registro_paciente_step' + step), true, function (data) {
                                    $("body").spin(false);
                                    if (data.idpaciente != undefined) {
                                        $(".idpaciente").val(data.idpaciente);
                                    }
                                    //reseteamos el validador de contraseña
                                    $("[data-meter='password_aut']").html("");
                                    $("[data-meter='repassword_aut']").html("");
                                    $("[data-meter='password_aut']").removeClass("veryweak");
                                    $("[data-meter='password_aut']").removeClass("medium");
                                    $("[data-meter='password_aut']").removeClass("strong");
                                    $("[data-meter='repassword_aut']").removeClass("veryweak");
                                    $("[data-meter='repassword_aut']").removeClass("medium");
                                    $("[data-meter='repassword_aut']").removeClass("strong");
                                    if (data.result) {
                                        if ($("#sin_beneficios_reintegro").is(":checked")) {
                                            $("#registroAccordon").slideUp();
                                            $("#mensajeRegistro").slideDown();
                                            scrollToEl($("body"));
                                        } else {
                                            $('#wizard_registro_paciente').easyWizard('nextStep');
                                        }
                                    } else {
                                        x_alert(data.msg);
                                    }
                                });
                            }
                        });
                    });
                });

                $(".btn-volver").click(function () {
                    var step = $(this).data("prev");
                    if ($(this).data("prev") != undefined) {
                        $('#wizard_registro_paciente').easyWizard('goToStep', step);
                    } else {
                        $('#wizard_registro_paciente').easyWizard('prevStep');
                    }
                    $("#span_steps").text(step + "/6");
                });


                $(".generateCodigoCelular").click(function () {
                    $("#step2").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'generar_codigo_celular_registro_p.do',
                            "idpaciente=" + $(".idpaciente").val(),
                            function (data) {
                                $("#step2").spin(false);
                                if (data.result) {
                                    x_alert(x_translate("En unos minutos recibirá un SMS con el código de valiación"));
                                } else {
                                    x_alert(data.msg);
                                }

                            }
                    );
                });
                //$("#DNI_input").inputmask("99999999");

                $(".button_gth").hide();
                $(':radio, :checkbox').radiocheck();
                $('.switch-checkbox').bootstrapSwitch();
                $('#trabaja_otro_pais_si').on('change.radiocheck', function () {
                    // Do something
                    $("#div_tarjeta_cns").show();
                    $("#div_no_trabajo_luxemburgo").show();
                    $('#no_trabajo_luxemburgo').radiocheck('uncheck');
                });
                $('#trabaja_otro_pais_no').on('change.radiocheck', function () {
                    // Do something
                    $("#div_tarjeta_cns").hide();
                    $("#div_no_trabajo_luxemburgo").hide();
                    $('#no_trabajo_luxemburgo').radiocheck('uncheck');
                });

                $('.btn-crear-cuenta').on('click', function (e) {
                    //se verifican los campos
                    $.each($("#form input"), function (index, error) {
                        var $element = $(error);
                        $element.tooltip("destroy");
                    });

                    var step = $(this).data("step");
                    x_sendForm($('#form_registro_paciente_step' + step), true, function (data) {

                        if (data.result) {

                            $("#registroAccordon").slideUp();
                            $("#mensajeRegistro").slideDown();
                            scrollToEl($("body"));
                        } else {
                            x_alert(data.msg);
                        }
                    });



                });
                $("#refresh_captcha").click(function () {
                    $('#captcha_img').attr('src', $('#url').val() + 'captcha.img?t=' + new Date().getTime());
                });
                //opciones date picker de fecha de nacimiento
                $('#fechaNacimiento_input').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});

                //mostrar contraseña
                $('.btnShowPassword').click(function () {
                    if ($('#password_aut').attr('type') === "password") {
                        $('#password_aut').attr('type', "text");
                        $('#repassword_aut').attr('type', "text");
                        $('.btnShowPassword').attr('title', x_translate("Ocultar contraseña"));
                        $('.btnShowPassword i').removeClass('fa fa-eye').addClass('fa fa-eye-slash');
                    } else {
                        $('#password_aut').attr('type', "password");
                        $('#repassword_aut').attr('type', "password");
                        $('.btnShowPassword').attr('title', x_translate("Mostrar contraseña"));
                        $('.btnShowPassword i').removeClass('fa fa-eye-slash').addClass('fa fa-eye');
                    }
                });
                /*Accion eliminar archivo subido - tarjetas identificacion*/
                $(".btn-delete-file").click(function () {
                    var hash = $(this).data("hash");
                    var name = $(this).data("name");
                    var tipo = $(this).data("tipo");
                    var $btn = $(this);
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'common.php?action=1&modulo=upload&submodulo=upload_gen',
                            "delete=1&hash=" + hash + "&name=" + name,
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    $btn.closest(".upload-filename").hide();
                                    $(".cont-imagen." + tipo).hide();
                                    $btn.closest(".pul-col-x2").find(".dz-clickable.upload-success").removeClass("upload-success");
                                } else {
                                    x_alert(data.msg);
                                }

                            }
                    );
                });

            });
        });
    </script>		
{/literal}