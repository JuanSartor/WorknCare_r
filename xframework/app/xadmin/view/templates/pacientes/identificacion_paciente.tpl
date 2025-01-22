{*VITALE*}
<div class="upload-image-wrapper" id="attachment-vitale" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>{"Tarjeta Vitale"|x_translate}</label>

        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.vitale.path!=""}
                <a href="{$imagenes_tarjetas.vitale.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.vitale.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-vitale" class="img-responsive img-circle cont-imagen vitale">
                    {else}
                        <img src="{$imagenes_tarjetas.vitale.path}" width="110" height="110"  id="cont-imagen-vitale" class="img-responsive img-circle cont-imagen vitale">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-vitale" class="img-responsive img-circle cont-imagen vitale">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-vitale"  {if $imagenes_tarjetas.vitale.path!=""}style="display:none"{/if} class="button  icon save file-upload vitale picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-vitale" {if $imagenes_tarjetas.vitale.path==""}style="display:none"{/if} data-tipo="vitale" class="btn-delete-file vitale button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_vitale"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successFileVITALE = function (file, responseText) {
            console.log("response", responseText);
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-vitale").data("hash", responseText.hash);
                $("#delete-imagen-vitale").data("name", responseText.fileName);
                $("#delete-imagen-vitale").data("tipo", "vitale");

                console.log(src);
                $("#cont-imagen-vitale").attr("src", src);
                $("#cont-imagen-vitale").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-vitale").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=pacientes&submodulo=upload_file_paciente',
                        "name=" + "vitale" + "&hash=" + responseText.hash + "&idpaciente=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('pacientes', 'identificacion_paciente', 'id=' + $("#idpaciente").val(), 'identificacion_paciente_container');

                        }
                );

            }
        };
        var startFileVITALE = function () {

            $("body").spin("large", '#000');
        };
        var stopFileVITALE = function () {
            $("body").spin(false);
        };
        var errorFileVITALE = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-vitale").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="vitale" selector="#file-upload-vitale" preview="#hidden_upload_vitale" callback_success="successFileVITALE" callback_start="startFileVITALE" callback_stop="stopFileVITALE" callback_error="errorFileVITALE" }

</div>

{*CNS*}
<div class="upload-image-wrapper" id="attachment-cns" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>{"Tarjeta CNS"|x_translate}</label>
        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.cns.path!=""}
                <a href="{$imagenes_tarjetas.cns.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.cns.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-cns" class="img-responsive img-circle cont-imagen cns">
                    {else}
                        <img src="{$imagenes_tarjetas.cns.path}" width="110" height="110"  id="cont-imagen-cns" class="img-responsive img-circle cont-imagen cns">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-cns" class="img-responsive img-circle cont-imagen cns">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-cns"  {if $imagenes_tarjetas.cns.path!=""}style="display:none"{/if} class="button  icon save file-upload cns picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-cns" {if $imagenes_tarjetas.cns.path==""}style="display:none"{/if} data-tipo="cns" class="btn-delete-file cns button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_cns"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successFileCNS = function (file, responseText) {
            console.log("response", responseText);
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-cns").data("hash", responseText.hash);
                $("#delete-imagen-cns").data("name", responseText.fileName);
                $("#delete-imagen-cns").data("tipo", "cns");

                console.log(src);
                $("#cont-imagen-cns").attr("src", src);
                $("#cont-imagen-cns").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-cns").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=pacientes&submodulo=upload_file_paciente',
                        "name=" + "cns" + "&hash=" + responseText.hash + "&idpaciente=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('pacientes', 'identificacion_paciente', 'id=' + $("#idpaciente").val(), 'identificacion_paciente_container');

                        }
                );

            }
        };
        var startFileCNS = function () {

            $("body").spin("large", '#000');
        };
        var stopFileCNS = function () {
            $("body").spin(false);
        };
        var errorFileCNS = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-cns").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="cns" selector="#file-upload-cns" preview="#hidden_upload_cns" callback_success="successFileCNS" callback_start="startFileCNS" callback_stop="stopFileCNS" callback_error="errorFileCNS" }

</div>

{*eID*}
<div class="upload-image-wrapper" id="attachment-eID" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>{"Tarjeta eID"|x_translate}</label>
        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.eID.path!=""}
                <a href="{$imagenes_tarjetas.eID.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.eID.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-eID" class="img-responsive img-circle cont-imagen eID">
                    {else}
                        <img src="{$imagenes_tarjetas.eID.path}" width="110" height="110"  id="cont-imagen-eID" class="img-responsive img-circle cont-imagen eID">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-eID" class="img-responsive img-circle cont-imagen eID">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-eID"  {if $imagenes_tarjetas.eID.path!=""}style="display:none"{/if} class="button  icon save file-upload eID picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-eID" {if $imagenes_tarjetas.eID.path==""}style="display:none"{/if} data-tipo="eID" class="btn-delete-file eID button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_eID"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successFileeID = function (file, responseText) {
            console.log("response", responseText);
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-eID").data("hash", responseText.hash);
                $("#delete-imagen-eID").data("name", responseText.fileName);
                $("#delete-imagen-eID").data("tipo", "eID");

                console.log(src);
                $("#cont-imagen-eID").attr("src", src);
                $("#cont-imagen-eID").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-eID").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=pacientes&submodulo=upload_file_paciente',
                        "name=" + "eID" + "&hash=" + responseText.hash + "&idpaciente=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('pacientes', 'identificacion_paciente', 'id=' + $("#idpaciente").val(), 'identificacion_paciente_container');

                        }
                );

            }
        };
        var startFileeID = function () {

            $("body").spin("large", '#000');
        };
        var stopFileeID = function () {
            $("body").spin(false);
        };
        var errorFileeID = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-eID").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="eID" selector="#file-upload-eID" preview="#hidden_upload_eID" callback_success="successFileeID" callback_start="startFileeID" callback_stop="stopFileeID" callback_error="errorFileeID" }

</div>


{*PASAPORTE*}
<div class="upload-image-wrapper" id="attachment-pasaporte" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>{"Pasaporte"|x_translate}</label>
        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.pasaporte.path!=""}
                <a href="{$imagenes_tarjetas.pasaporte.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.pasaporte.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-pasaporte" class="img-responsive img-circle cont-imagen pasaporte">
                    {else}
                        <img src="{$imagenes_tarjetas.pasaporte.path}" width="110" height="110"  id="cont-imagen-pasaporte" class="img-responsive img-circle cont-imagen pasaporte">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-pasaporte" class="img-responsive img-circle cont-imagen pasaporte">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-pasaporte"  {if $imagenes_tarjetas.pasaporte.path!=""}style="display:none"{/if} class="button  icon save file-upload pasaporte picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-pasaporte" {if $imagenes_tarjetas.pasaporte.path==""}style="display:none"{/if} data-tipo="pasaporte" class="btn-delete-file pasaporte button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_pasaporte"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successFilePASAPORTE = function (file, responseText) {
            console.log("response", responseText);
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-pasaporte").data("hash", responseText.hash);
                $("#delete-imagen-pasaporte").data("name", responseText.fileName);
                $("#delete-imagen-pasaporte").data("tipo", "pasaporte");

                console.log(src);
                $("#cont-imagen-pasaporte").attr("src", src);
                $("#cont-imagen-pasaporte").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-pasaporte").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=pacientes&submodulo=upload_file_paciente',
                        "name=" + "pasaporte" + "&hash=" + responseText.hash + "&idpaciente=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('pacientes', 'identificacion_paciente', 'id=' + $("#idpaciente").val(), 'identificacion_paciente_container');

                        }
                );

            }
        };
        var startFilePASAPORTE = function () {

            $("body").spin("large", '#000');
        };
        var stopFilePASAPORTE = function () {
            $("body").spin(false);
        };
        var errorFilePASAPORTE = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-pasaporte").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerPaciente" name="pasaporte" selector="#file-upload-pasaporte" preview="#hidden_upload_pasaporte" callback_success="successFilePASAPORTE" callback_start="startFilePASAPORTE" callback_stop="stopFilePASAPORTE" callback_error="errorFilePASAPORTE" }

</div>


<script>
    $(function () {

        /*Accion eliminar archivo subido - tarjetas identificacion*/
        $(".btn-delete-file").click(function () {
            var tipo = $(this).data("tipo");
            jConfirm(
                    "Confirma que desea eliminar el archivo seleccionado?",
                    "Eliminar",
                    function (r) {
                        if (r) {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'xadmin.php?action=1&modulo=pacientes&submodulo=delete_file_paciente',
                                    "name=" + tipo + "&idpaciente=" + $("#idpaciente").val(),
                                    function (data) {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                        x_loadModule('pacientes', 'identificacion_paciente', 'id=' + $("#idpaciente").val(), 'identificacion_paciente_container');

                                    }
                            );
                        }
                    }
            );

        });


    });
</script>
