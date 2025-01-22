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
    .plogin-mensaje-registro h3.medico {
        color: #f33243;
        margin-bottom: 24px;
    }
    .plogin-mensaje-registro-actions{
        margin-bottom: 20px
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
        .plogin-mensaje-registro p {
            margin-bottom: 24px;
        }
    }
    .mapc-select {
        margin-top: 0px;
    }
    .mapc-select .mbl{
        margin-bottom: 0px;
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
{include file="medico/menu.tpl"}

{include file="home/login.tpl"}

<div class="plogin-header">
    <h1>{"Crear una cuenta como"|x_translate}</h1>
    <h2>{"Profesional de la Salud"|x_translate}</h2>
    <h3>{"¡Una solución integral para las consultas fuera del consultorio!"|x_translate}</h3>
</div>

<section class="plogin-registro">

    <div id="registroAccordon" class="mapc-registro-box pul-nuevo-paciente-accordion">

        <h4 class="plogin-registro-accordios-title">{"REGISTRARME COMO PROFESIONAL"|x_translate} <span id="span_steps" class="pull-right visible-xs">1/5</span></h4>	
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">

                <div class="row">
                    <div class="col-md-12 portlets">
                        <!-- Your awesome content goes here -->
                        <div class="widget animated fadeInDown">

                            <div id="wizard_registro_medico">
                                <section class="step"  data-step-title="" data-callback='step1' >
                                    <form id="form_registro_medico_step1" role="form" action="{$url}{$controller}.php?action=1&modulo=medico&submodulo=medico_registracion" method="POST" onsubmit="return false;">
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
                                                                    <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow" target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
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
                                    <form id="form_registro_medico_step2" role="form" action="{$url}{$controller}.php?action=1&modulo=medico&submodulo=medico_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="2" />
                                        <input type="hidden" class="idmedico" name="idmedico" value="" />


                                        <div  id="cont_2">



                                            <div class="okm-row">
                                                <div class="pul-col-x2 form-element-center">
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
                                                    <a href="javascript:;" class="btn-default btn-volver" data-prev="1"style="background:#455a64" >{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="2" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step3'> 
                                    <form id="form_registro_medico_step3" role="form" action="{$url}{$controller}.php?action=1&modulo=medico&submodulo=medico_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="3" />
                                        <input type="hidden" class="idmedico" name="idmedico" value="" />

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
                                                        <input type="text"  id="apellido_input" tabindex='2' name="apellido" maxlength="20" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="okm-row">
                                                <div class="pul-col-x2 " >
                                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                                        <label class="mapc-label">{"Sexo"|x_translate}</label>
                                                        <select id="sexo" name="sexo"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                            <option value="1" selected>{"HOMBRE"|x_translate}</option>
                                                            <option value="0" >{"MUJER"|x_translate}</option>
                                                        </select>
                                                    </div>
                                                </div>    
                                                {*
                                                <div class="pul-col-x1 text-center">
                                                <div class="mapc-registro-form-row mapc-switch pul-np-switch">
                                                <div class="switch-large mul-sexo-switch">	
                                                <input type="checkbox" class="switch-checkbox" tabindex='5' data-on-text='{"HOMBRE"|x_translate}"' data-off-text='{"MUJER"|x_translate}' data-on-label="1" data-off-label="0"  id="sexo" name="sexo"/>
                                                </div>
                                                </div>
                                                </div>
                                                *}
                                            </div>
                                            <p>&nbsp;</p>    
                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;" class="btn-default btn-volver" data-prev="2" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="3" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>


                                <section class="step" data-step-title="" data-callback='step4'> 
                                    <form id="form_registro_medico_step4" role="form" action="{$url}{$controller}.php?action=1&modulo=medico&submodulo=medico_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="4" />
                                        <input type="hidden" class="idmedico" name="idmedico" value="" />

                                        <div  id="cont_4">
                                            <div class="okm-row" >
                                                <div class="pul-col-x2" >
                                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                                        <label class="mapc-label">{"Elija el país donde ejerce"|x_translate}</label>
                                                        <select id="pais_idpais" name="pais_idpais"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                            <option value="1"  selected>France</option>
                                                            {*<option value="2" >Luxembourg</option>*}

                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <p>&nbsp;</p>    
                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"   class="btn-default btn-volver" data-prev="3" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="4" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>
                                            <div class="okm-row text-center">
                                                <br>
                                                <p>
                                                    <small>{"Nous n’acceptons que des professionnels de santé exerçant en France ou au Luxembourg."|x_translate}</small>
                                                </p>
                                                <p>
                                                    <small>{"Les patients français n’auront accès qu’aux professionnels exerçant en France, à l’exception des patients français frontaliers du Luxembourg, qui bénéficient d’une exception."|x_translate} </small>
                                                </p>
                                            </div>                                                
                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title=""  data-callback='step5'>
                                    <div  id="cont_5">
                                        <form id="form_registro_medico_step5" role="form" action="{$url}{$controller}.php?action=1&modulo=medico&submodulo=medico_registracion" method="POST" onsubmit="return false;">
                                            <input type="hidden" name="step" value="5" />
                                            <input type="hidden" class="idmedico" name="idmedico" value="" />


                                            <p></p>

                                            <!-- Imagenes identificacion -->
                                            <div class="okm-row" >
                                                <div class="pul-col-x2" >
                                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                                        <label class="mapc-label">{"Especialidad"|x_translate}</label>
                                                        <select id="especialidad_idespecialidad" name="especialidad_idespecialidad"  class="form-control select select-primary select-block mbl pul-np-dis">
                                                            <option value="" selected>{"Seleccione una Especialidad"|x_translate}</option>
                                                            {foreach from=$combo_especialidades item=especialidad}
                                                                <option value="{$especialidad.idespecialidad}" data-identificacion="{$especialidad.tipo_identificacion}">{$especialidad.especialidad}</option>
                                                            {/foreach}

                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2"  id="div_rpps" style="display:none;">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label" >{"Número de tarjeta RPPS"|x_translate}</label>                                                        
                                                        <input type="number"  id="numero_rpps"  name="numero_rpps" maxlength="11" />
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2"  id="div_adeli" style="display:none;">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label" >{"Número Adeli"|x_translate}</label>                                                        
                                                        <input type="text"  id="numero_adeli"  name="numero_adeli" maxlength="9" style="text-transform: uppercase;" />
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2"  id="div_numero_identificacion" style="display:none;">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label" >{"Número de identificación"|x_translate}</label>                                                        
                                                        <input type="text"  id="numero_identificacion"  name="numero_identificacion" style="text-transform: uppercase;" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="okm-row" >
                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label">{"Agregar foto de tarjeta DNI"|x_translate}</label>                                                        

                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-dni" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-dni" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successFileIdent = function (file, responseText) {

                                                                            console.log("response", responseText);
                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {
                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-dni").addClass("pdf");

                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-dni").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-dni").text(responseText.fileName);
                                                                                $(".upload-filename.dni").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-dni").attr("src", src);
                                                                                $("#cont-imagen-dni").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-dni").show();

                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-dni").data("hash", responseText.hash);
                                                                                $("#delete-imagen-dni").data("name", responseText.fileName);
                                                                                $("#delete-imagen-dni").data("tipo", "dni");
                                                                            }
                                                                        };
                                                                        var startFileIdent = function () {

                                                                            $("#attachment-dni").spin("large", '#000');
                                                                        };
                                                                        var stopFileIdent = function () {
                                                                            $("#attachment-dni").spin(false);
                                                                        };
                                                                        var errorFileIdent = function (file, error) {
                                                                            $("#cont-imagen-dni").hide();
                                                                            x_alert(error);
                                                                        };
                                                                    </script>
                                                                {/literal}                                        
                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerMedico" name="dni" form_id="form_registro_medico_step4" selector="#file-upload-dni" preview="#hidden_upload_dni" callback_success="successFileIdent" callback_start="startFileIdent" callback_stop="stopFileIdent" callback_error="errorFileIdent" }

                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_dni"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta DNI"|x_translate}' title='{"Agregar foto de tarjeta DNI"|x_translate}'>
                                                            <img id="cont-imagen-dni" class="cont-imagen dni" style="display: none" alt='{"Agregar foto de tarjeta DNI"|x_translate}' title='{"Agregar foto de tarjeta DNI"|x_translate}'/>
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename dni" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-dni" class="btn-delete-file dni" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-dni"></label>
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="pul-col-x2 " id="div_cps" style="display:none;">
                                                    <div class="mapc-input-line" >
                                                        <label class="mapc-label" id="lbl_foto_cps">{"Agregar foto de tarjeta CPS"|x_translate}</label>
                                                        <label class="mapc-label" id="lbl_foto_adeli" style="display:none">{"Agregar foto Adeli"|x_translate}</label>
                                                        <label class="mapc-label" id="lbl_foto_titulo" style="display:none">{"Agregar foto de título"|x_translate}</label>
                                                    </div>

                                                    <div class="col-xs-6" style="min-height: 100px">

                                                        <div class="mapc-upload-box">
                                                            <div class="attachment" id="attachment-cps" style="position:relative">
                                                                <label for="picture-upload" id="file-upload-cps" class="file-upload  picture dz-clickable " >

                                                                </label>

                                                                {literal}
                                                                    <script>
                                                                        //callbacks de la imagen
                                                                        var successFileCPS = function (file, responseText) {
                                                                            console.log("response", responseText);
                                                                            if (responseText.status == 0) {
                                                                                x_alert(responseText.error);
                                                                            } else if (responseText.status == 1) {
                                                                                if (responseText.extension == "pdf") {
                                                                                    //si es pdf a la imagen la reemplazamos por un icono
                                                                                    var image = 'xframework/app/themes/dp02/imgs/ico_pdf.png';
                                                                                    var src = BASE_PATH + image;
                                                                                    $("#cont-imagen-cps").addClass("pdf");
                                                                                } else {
                                                                                    //si es imagen la reemplazamos por la miniatura
                                                                                    var image = 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension;
                                                                                    var src = BASE_PATH + 'common.php?action=1&modulo=images&submodulo=getThumb&image=' + image + '&w=165&h=80&v=' + new Date().getTime();
                                                                                    $("#cont-imagen-cps").removeClass("pdf");
                                                                                }
                                                                                $("#filename-imagen-cps").text(responseText.fileName);
                                                                                $(".upload-filename.cps").show();
                                                                                console.log(src);
                                                                                $("#cont-imagen-cps").attr("src", src);
                                                                                $("#cont-imagen-cps").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                                                                                $("#cont-imagen-cps").show();
                                                                                //seteamos la data para borrar el archivo
                                                                                $("#delete-imagen-cps").data("hash", responseText.hash);
                                                                                $("#delete-imagen-cps").data("name", responseText.fileName);
                                                                                $("#delete-imagen-cps").data("tipo", "cps");
                                                                            }
                                                                        };
                                                                        var startFileCPS = function () {

                                                                            $("#attachment-cps").spin("large", '#000');
                                                                        };
                                                                        var stopFileCPS = function () {
                                                                            $("#attachment-cps").spin(false);
                                                                        };
                                                                        var errorFileCPS = function (file, error) {
                                                                            $("#cont-imagen-cps").hide();
                                                                            x_alert(error);
                                                                        };
                                                                    </script>
                                                                {/literal}                                        

                                                                {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerMedico" name="cps" form_id="form_registro_medico_step4" selector="#file-upload-cps" preview="#hidden_upload_cps" callback_success="successFileCPS" callback_start="startFileCPS" callback_stop="stopFileCPS" callback_error="errorFileCPS" }
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="col-xs-6">                                               
                                                        <div style="display:none" id="hidden_upload_cps"></div>  
                                                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta CPS"|x_translate}' title='{"Agregar foto de tarjeta CPS"|x_translate}'>
                                                            <img id="cont-imagen-cps" class="cont-imagen cps" style="display: none" alt='{"Agregar foto de tarjeta CPS"|x_translate}' title='{"Agregar foto de tarjeta CPS"|x_translate}' />
                                                        </a>
                                                    </div>
                                                    <div class="col-xs-12 upload-filename cps" style="display: none">
                                                        <div class="row">
                                                            <button id="delete-imagen-cps" class="btn-delete-file cps" title='{"Eliminar"|x_translate}'>
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <label  id="filename-imagen-cps"></label>
                                                        </div>
                                                    </div>
                                                </div>


                                            </div>





                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"   class="btn-default btn-volver" data-prev="4" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-crear-cuenta btn-default" id="btn-crear-cuenta" data-step="5" >{"crear cuenta"|x_translate}</a>
                                                </div>
                                            </div>
                                    </div>	
                                    </form>
                                </section>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="plogin-mensaje-registro" id="mensajeRegistro">
        <h3 class="medico">{"¡Gracias por registrarse en DoctorPlus!"|x_translate}</h3>
        <h4>{"Su cuenta está pendiente de validación."|x_translate}</h4>
        <p class="plogin-envio-correo">
            {"Los datos profesionales ingresados serán chequeados por DoctorPlus."|x_translate}<br><br> 
            {"Será notificado cuando su cuenta como profesional haya sido validada."|x_translate}
        </p>
        <div class="plogin-mensaje-registro-actions">
            <a href="{$url}" class="btn-default btnVolver">{"volver"|x_translate}</a>
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
<script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}" async defer>
</script>

{x_load_js}