<style>
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
<div id="div_identificacion"  {if $paciente.beneficios_reintegro!=1}style="display:none;"{/if}>
    <!-- CONTENEDOR Tarjeta CNS -- Luxemburgo Titular Y Propia para familiares LUX-->
    <div class="okm-row"  id="div_tarjeta_cns" style="display:none;" >
        <div class="pul-col-x2"  >
            <div class="mapc-input-line">
                <label class="mapc-label">{"Número de tarjeta CNS (Luxemburgo)"|x_translate}</label>
                <input type="number"  id="tarjeta_cns_input"  name="tarjeta_cns" value="{$paciente.tarjeta_cns}" maxlength="13" />
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
    <!-- FIN CONTENEDOR Tarjeta CNS -->

    <!-- Seccion tarjetas identificacion para reintegro Seguridad social al titular de cuenta-->
    {if $paciente.titular==1}
        <!-- CONTENEDOR Tarjeta Vitale - Francia-->
        <div class="okm-row" id="div_tarjeta_vitale" >
            <div class="pul-col-x2"  >
                <div class="mapc-input-line">
                    <label class="mapc-label">{"Número de tarjeta Vitale"|x_translate}</label>
                    <input type="number"  id="tarjeta_vitale_input"  name="tarjeta_vitale" value="{$paciente.tarjeta_vitale}" maxlength="15" />
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
                                    };
                                </script>
                            {/literal}                                        

                            {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="vitale" form_id="frmRegistro" selector="#file-upload-vitale" preview="#hidden_upload_vitale" callback_success="successImgVitale" callback_start="startImgVitale" callback_stop="stopImgVitale" callback_error="errorImgVitale" }
                        </div>

                    </div>
                </div>

                <div class="col-xs-6">                                               
                    <div style="display:none" id="hidden_upload_vitale"></div>  
                    {if $imagenes_tarjetas.vitale.path!=""}
                        <a href="{$imagenes_tarjetas.vitale.path}" target="_blank" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'>
                            {if $imagenes_tarjetas.vitale.ext==".pdf"}
                                <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" class="cont-imagen pdf vitale" id="cont-imagen-vitale" >
                            {else}
                                <img id="cont-imagen-vitale"  src="{$imagenes_tarjetas.vitale.path}" class="cont-imagen vitale" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'/>
                            {/if}
                        </a>
                    {else}
                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'>
                            <img id="cont-imagen-vitale" class="cont-imagen vitale" style="display: none" alt='{"Agregar foto de tarjeta Vitale"|x_translate}' title='{"Agregar foto de tarjeta Vitale"|x_translate}'/>
                        </a>
                    {/if}
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
        <!-- Seccion preguntas para la cobertura de facturacion -->
        {include file="pacientes/preguntas_cobertura_facturacion.tpl"}
        <!--    Fin Seccion cobertrua facturacion-->
        <!-- FIN CONTENEDOR Tarjeta Vitale -->

        <!-- CONTENEDOR Tarjeta Pasaporte - Otros paises -->
        <div class="okm-row" id="div_tarjeta_pasaporte" style="display:none;">
            <div class="pul-col-x2"  >
                <div class="mapc-input-line">
                    <label class="mapc-label">{"Número de tarjeta Pasaporte"|x_translate}</label>
                    <input type="text"  id="tarjeta_pasaporte_input"  name="tarjeta_pasaporte" value="{$paciente.tarjeta_pasaporte}" maxlength="25" />
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
                                    };
                                </script>
                            {/literal}                                        

                            {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="pasaporte" form_id="frmRegistro" selector="#file-upload-pasaporte" preview="#hidden_upload_pasaporte" callback_success="successImgPasaporte" callback_start="startImgPasaporte" callback_stop="stopImgPasaporte" callback_error="errorImgPasaporte" }
                        </div>

                    </div>
                </div>

                <div class="col-xs-6">                                               
                    <div style="display:none" id="hidden_upload_pasaporte"></div>  
                    {if $imagenes_tarjetas.pasaporte.path!=""}
                        <a href="{$imagenes_tarjetas.pasaporte.path}" target="_blank" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'>
                            {if $imagenes_tarjetas.pasaporte.ext==".pdf"}
                                <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" class="cont-imagen pdf pasaporte" id="cont-imagen-pasaporte" >
                            {else}
                                <img id="cont-imagen-pasaporte"  src="{$imagenes_tarjetas.pasaporte.path}" class="cont-imagen pasaporte" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'/>
                            {/if}
                        </a>
                    {else}
                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'>
                            <img id="cont-imagen-pasaporte" class="cont-imagen pasaporte" style="display: none" alt='{"Agregar foto de tarjeta Pasaporte"|x_translate}' title='{"Agregar foto de tarjeta Pasaporte"|x_translate}'/>
                        </a>
                    {/if}
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
        <!-- FIN CONTENEDOR Tarjeta Pasaporte -->

        <!-- CONTENEDOR Tarjeta eID - Belgica -->                
        <div class="okm-row" id="div_tarjeta_eID" style="display:none;">
            <div class="pul-col-x2"  >
                <div class="mapc-input-line">
                    <label class="mapc-label">{"Número de tarjeta eID"|x_translate}</label>
                    <input type="number"  id="tarjeta_eID_input"  name="tarjeta_eID" maxlength="12" value="{$paciente.tarjeta_eID}"  />
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
                                    };
                                </script>
                            {/literal}                                        

                            {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="eID" form_id="frmRegistro" selector="#file-upload-eID" preview="#hidden_upload_eID" callback_success="successImgeID" callback_start="startImgeID" callback_stop="stopImgeID" callback_error="errorImgeID" }
                        </div>

                    </div>
                </div>

                <div class="col-xs-6">                                               
                    <div style="display:none" id="hidden_upload_eID"></div>  
                    {if $imagenes_tarjetas.eID.path!=""}
                        <a href="{$imagenes_tarjetas.eID.path}" target="_blank" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'>
                            {if $imagenes_tarjetas.eID.ext==".pdf"}
                                <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" class="cont-imagen pdf eID" id="cont-imagen-eID" >
                            {else}
                                <img id="cont-imagen-eID"  src="{$imagenes_tarjetas.eID.path}" class="cont-imagen eID" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'/>
                            {/if}
                        </a>
                    {else}
                        <a href="" target="_blank" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'>
                            <img id="cont-imagen-eID" class="cont-imagen eID" style="display: none" alt='{"Agregar foto de tarjeta eID"|x_translate}' title='{"Agregar foto de tarjeta eID"|x_translate}'/>
                        </a>
                    {/if}
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
    {/if}
    <!-- FIN CONTENEDOR Tarjeta eID -->
</div>
<script>
    $(function () {
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
                            $btn.closest(".pul-col-x2").find(".dz-clickable.upload-success").removeClass("upload-success");

                            $(".cont-imagen." + tipo).hide();
                        } else {
                            x_alert(data.msg);
                        }

                    }
            );
        });
    });
</script>