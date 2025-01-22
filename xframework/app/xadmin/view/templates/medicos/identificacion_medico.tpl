{*DNI*}
<div class="upload-image-wrapper" id="attachment-dni" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>{"Foto de tarjeta de identificación"|x_translate}</label>

        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.dni.path!=""}
                <a href="{$imagenes_tarjetas.dni.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.dni.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-dni" class="img-responsive img-circle cont-imagen dni">
                    {else}
                        <img src="{$imagenes_tarjetas.dni.path}" width="110" height="110"  id="cont-imagen-dni" class="img-responsive img-circle cont-imagen dni">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-dni" class="img-responsive img-circle cont-imagen dni">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-dni"  {if $imagenes_tarjetas.dni.path!=""}style="display:none"{/if} class="button  icon save file-upload dni picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-dni" {if $imagenes_tarjetas.dni.path==""}style="display:none"{/if} data-tipo="dni" class="btn-delete-file dni button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_dni"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successFileDNI = function (file, responseText) {
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-dni").data("hash", responseText.hash);
                $("#delete-imagen-dni").data("name", responseText.fileName);
                $("#delete-imagen-dni").data("tipo", "dni");

                console.log(src);
                $("#cont-imagen-dni").attr("src", src);
                $("#cont-imagen-dni").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-dni").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=medicos&submodulo=upload_file_medico',
                        "name=" + "dni" + "&hash=" + responseText.hash + "&idmedico=" + $("#idmedico").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('medicos', 'identificacion_medico', 'id=' + $("#idmedico").val(), 'identificacion_medico_container');

                        }
                );

            }
        };
        var startFileDNI = function () {

            $("body").spin("large", '#000');
        };
        var stopFileDNI = function () {
            $("body").spin(false);
        };
        var errorFileDNI = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-dni").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerMedico" name="dni" selector="#file-upload-dni" preview="#hidden_upload_dni" callback_success="successFileDNI" callback_start="startFileDNI" callback_stop="stopFileDNI" callback_error="errorFileDNI" }

</div>

{*CPS*}
<div class="upload-image-wrapper" id="attachment-cps" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        {if $record.mis_especialidades.0.tipo_identificacion=="0"}
            <label>{"Foto de tarjeta CPS"|x_translate}</label>
        {else if $record.mis_especialidades.0.tipo_identificacion=="1"}
            <label>{"Foto Adeli"|x_translate}</label>
        {else}
            <label>{"Foto de título"|x_translate}</label>
        {/if}
        <div class="image-box" style="padding:10px">
            {if $imagenes_tarjetas.cps.path!=""}
                <a href="{$imagenes_tarjetas.cps.path}" target="_blank" id="lnk-image">
                    {if $imagenes_tarjetas.cps.ext==".pdf"}
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png" width="110" height="110"  id="cont-imagen-cps" class="img-responsive img-circle cont-imagen cps">
                    {else}
                        <img src="{$imagenes_tarjetas.cps.path}" width="110" height="110"  id="cont-imagen-cps" class="img-responsive img-circle cont-imagen cps">
                    {/if}
                </a>
            {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="cont-imagen-cps" class="img-responsive img-circle cont-imagen cps">
            {/if}
        </div>

        <a href="javascript:;"  id="file-upload-cps"  {if $imagenes_tarjetas.cps.path!=""}style="display:none"{/if} class="button  icon save file-upload cps picture dz-clickable">{"Agregar"|x_translate}</a>

        <a href="javascript:;" id="delete-imagen-cps" {if $imagenes_tarjetas.cps.path==""}style="display:none"{/if} data-tipo="cps" class="btn-delete-file cps button  icon trash">{"Eliminar"|x_translate}</a>

        <div style="display:none" id="hidden_upload_cps"></div>
    </div>
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
                //seteamos la data para borrar el archivo
                $("#delete-imagen-cps").data("hash", responseText.hash);
                $("#delete-imagen-cps").data("name", responseText.fileName);
                $("#delete-imagen-cps").data("tipo", "cps");

                console.log(src);
                $("#cont-imagen-cps").attr("src", src);
                $("#cont-imagen-cps").parent().attr("href", BASE_PATH + 'xframework/files/temp/' + responseText.hash + '.' + responseText.extension);
                $("#cont-imagen-cps").show();
                //guardamos el archivo temporal
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'xadmin.php?action=1&modulo=medicos&submodulo=upload_file_medico',
                        "name=" + "cps" + "&hash=" + responseText.hash + "&idmedico=" + $("#idmedico").val(),
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            x_loadModule('medicos', 'identificacion_medico', 'id=' + $("#idmedico").val(), 'identificacion_medico_container');

                        }
                );

            }
        };
        var startFileCPS = function () {

            $("body").spin("large", '#000');
        };
        var stopFileCPS = function () {
            $("body").spin(false);
        };
        var errorFileCPS = function (file, error) {
            $("body").spin(false);
            $("#cont-imagen-cps").hide();
            x_alert(error);
        };
    </script>

    {x_component_upload_gen filter="image/jpeg,image/png,application/pdf" manager="ManagerMedico" name="cps" selector="#file-upload-cps" preview="#hidden_upload_cps" callback_success="successFileCPS" callback_start="startFileCPS" callback_stop="stopFileCPS" callback_error="errorFileCPS" }

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
                                    BASE_PATH + 'xadmin.php?action=1&modulo=medicos&submodulo=delete_file_medico',
                                    "name=" + tipo + "&idmedico=" + $("#idmedico").val(),
                                    function (data) {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                        x_loadModule('medicos', 'identificacion_medico', 'id=' + $("#idmedico").val(), 'identificacion_medico_container');

                                    }
                            );
                        }
                    }
            );

        });


    });
</script>
