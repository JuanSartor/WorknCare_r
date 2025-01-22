<style>
    #Main {
        min-height: 100%;
        background: #f7f7f7;
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
<div class="top-verde-centrado">
    <h1><i class="icon-doctorplus-user-add-circle"></i> {"Crear nuevo miembro"|x_translate}</h1>
</div>

<section class="pul-datos-paciente">
    <form id="frmRegistro" role="form" method="post" action="{$url}alta-miembro-grupo-familiar.do" onsubmit="return false;">
        <div class="mapc-registro-box pul-nuevo-paciente-accordion">

            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" {*data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne"*}>
                                {"Datos personales del paciente"|x_translate}
                            </a>
                        </h4>
                    </div>

                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Nombre"|x_translate}</label>
                                        <input type="text" id="nombre_input" name="nombre" maxlength="15" data-title='{"Ingrese nombre del paciente"|x_translate}' />
                                    </div>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Apellido"|x_translate}</label>
                                        <input type="text" name="apellido" id="apellido_input" maxlength="20" data-title='{"Ingrese apellido del paciente"|x_translate}' />
                                    </div>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <label class="mapc-label">{"Fecha de nacimiento"|x_translate}</label>
                                    <div class="mapc-input-line">
                                        <input type="text" id="fecha_nacimiento"  name="fechaNacimiento" placeholder='{"Fecha de nacimiento"|x_translate}'  data-title='{"Ingrese fecha de nacimiento"|x_translate}' data-date-format="DD/MM/YYYY" />
                                        <i class="icon-doctorplus-calendar"></i>
                                    </div>
                                </div>
                                <div class="pul-col-x2 " >
                                    <div class="mapc-registro-form-row">
                                        <div class="mapc-registro-form-row mapc-select pul-np-select">
                                            <label class="mapc-label">{"Sexo"|x_translate}</label>
                                            <select id="sexo" name="sexo"  class="form-control select select-primary select-block mbl">
                                                <option value="1">{"HOMBRE"|x_translate}</option>
                                                <option value="0">{"MUJER"|x_translate}</option>
                                            </select>
                                        </div> 
                                    </div>
                                </div> 
                            </div>

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                                        <label class="mapc-label">{"Relación con el paciente"|x_translate}</label>
                                        <select id="relacionGrupo_idrelacionGrupo" name="relacionGrupo_idrelacionGrupo"  class="form-control select select-primary select-block mbl" data-title="Seleccione la relación con el paciente">
                                            <option value="" >{"Seleccione"|x_translate}</option>
                                            {html_options options=$combo_relacion_grupo}
                                        </select>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                {*tarjetas seguridad social*}
                <div  class="panel panel-default">
                    {if $paciente_titular.beneficios_reintegro==1 && ($paciente_titular.pais_idpais==2 || $paciente_titular.pais_idpais_trabajo==2)}
                        <div id="div_identificacion">
                            <div class="panel-heading" role="tab" id="headingTwo">
                                <h4 class="panel-title">
                                    <a class="collapsed" id="accordion-trg-2" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        {"Identificación"|x_translate}
                                    </a>
                                </h4>
                            </div>
                            <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTwo">

                                <div class="okm-row"  id="div_tarjeta_cns"  >
                                    <div class="pul-col-x2"  >
                                        <div class="mapc-input-line">
                                            <label class="mapc-label">{"Número de tarjeta CNS (Luxemburgo)"|x_translate}</label>
                                            <input type="number"  id="tarjeta_cns_input"  name="tarjeta_cns" value="" maxlength="13" />
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
                                                            };
                                                        </script>
                                                    {/literal}                                        

                                                    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="cns" form_id="frmRegistro" selector="#file-upload-cns" preview="#hidden_upload_cns" callback_success="successImgCNS" callback_start="startImgCNS" callback_stop="stopImgCNS" callback_error="errorImgCNS" }
                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-xs-6">                                               
                                            <div style="display:none" id="hidden_upload_cns"></div>  
                                            {if $imagenes_tarjetas.cns.path!=""}
                                                <a href="{$imagenes_tarjetas.cns.path}" target="_blank" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'>
                                                    {if $imagenes_tarjetas.cns.ext==".pdf"}
                                                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" class="cont-imagen pdf cns" id="cont-imagen-cns" >                
                                                    {else}
                                                        <img id="cont-imagen-cns"  src="{$imagenes_tarjetas.cns.path}" class="cont-imagen cns" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'/>
                                                    {/if}
                                                </a>
                                            {else}
                                                <a href="" target="_blank" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'>
                                                    <img id="cont-imagen-cns" class="cont-imagen cns" style="display: none" alt='{"Agregar foto de tarjeta CNS"|x_translate}' title='{"Agregar foto de tarjeta CNS"|x_translate}'/>
                                                </a>
                                            {/if}
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


                            </div>
                        </div>
                    {/if}

                </div>

                {*privacidad paciente*}
                <div class="panel panel-default">
                    <!--privacidad-->
                    <h4 class="mapc-privacidad-title">{"Privacidad"|x_translate}</h4>
                    <div class="okm-row">
                        <div class="mapc-registro-form-row">
                            <div class="pul-np-privacidad-trg"><i class="icon-doctorplus-lock"></i> {"¿Quién podrá ver el Perfil de salud este paciente?"|x_translate}</div>
                        </div>
                    </div>

                    <div class="okm-row pul-np-option-center pul-permisos-checks">
                        <div class="pul-permisos-col">
                            <label class="radio pul-np-radio">
                                <input type="radio" id="permisos-nadie" name="privacidad_perfil_salud" checked value="0">
                                {"Nadie"|x_translate}
                            </label>

                            <label class="radio pul-np-radio">
                                <input type="radio" id="permisos-frecuentes" name="privacidad_perfil_salud" value="1">
                                {"Profesionales frecuentes"|x_translate}
                            </label>

                            <label class="radio pul-np-radio">
                                <input type="radio" id="permisos-todos" name="privacidad_perfil_salud" value="2">
                                {"Todos los profesionales de DoctorPlus"|x_translate}
                            </label>
                        </div>
                    </div>

                    <div class="okm-row">
                        <div id="permisos-nadie-disclaimer" class="perfil-permisos-disclaimer" style="display:block">
                            <div class="icon-box">
                                <i class="icon-doctorplus-alert-round"></i>
                            </div>
                            <p>
                                {"El Perfil de Salud solo será visible para la ti. Varias funcionalidades del sistema se encontrarán limitadas por ej. no podras realizar consultas médicas a distancia para este paciente."|x_translate}
                            </p>
                        </div>

                        <div id="permisos-frecuentes-disclaimer" class="perfil-permisos-disclaimer">
                            <div class="icon-box">
                                <i class="icon-doctorplus-alert-round"></i>
                            </div>
                            <p>
                                {"El Perfil de Salud solo será visible a los Profesionales Frecuentes o profesionales con los que hayas solicitado un turno. Recuerda que varias funcionalidades del sistema se encontrarán limitadas por ej. no podras enviar consultas médicas simultáneas al resto de los profesionales de la Red."|x_translate}
                            </p>
                        </div>

                    </div>

                    <div class="okm-row">
                        <div class="pul-np-politicas">
                            <p>
                                {"La  información de registro de su cuenta de usuario se almacenta encriptada en nuestra base de datos."|x_translate}
                            </p>
                            <p class="disclaimer text-center">{"Consulte nuestra"|x_translate} 
                                <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow" target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
                                <span>{"así como el"|x_translate}&nbsp;</span>
                                <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow" target="_blank">{"Consentimiento del usuario"|x_translate}</a>.

                            </p>
                        </div>
                    </div>

                    <div class="okm-row">
                        <div class="mapc-registro-form-row center">
                            <a href="javascript:;" id="btnCrearMiembro" class="btn-alert">{"Crear miembro"|x_translate}</a>
                        </div>
                    </div>


                    <!--privacidad-->
                </div>

            </div>

        </div>


    </form>
</section>

{x_load_js}
