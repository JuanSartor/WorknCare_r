<script>


    //callbacks de la imagen
    var successImg = function (file, responseText) {

        if (file.previewElement) {
            return file.previewElement.classList.add("dz-success");
        }
        if (responseText.status == 0) {
            x_alert(responseText.error);
        }

    };



    var startImg = function (file) {
        if ((file.size / 1024 / 1024) > 8) {
            return false;
        }
        $("#cantidad_image").val(parseInt($("#cantidad_image").val()) + 1);
        $("#cantidad").val($("#cantidad_image").val());
        //$("#dropzone").spin("large");

        if (file.previewElement) {
            file.previewElement.classList.add("dz-processing");
            if (file._removeLink) {
                return file._removeLink.textContent = this.options.dictCancelUpload;
            }
        }
        //agregar icono para pdf
        if (file.type == "application/pdf") {
            file.previewElement.classList.add("dz-pdf");
            $(".dropzone .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_pdf.png");
        }
        if (parseInt($("#cantidad_image").val()) > 20) {
            x_alert(x_translate("No puede agregar más de 20 imágenes pertenecientes a un mismo título"));
            return false;
        }


    };
    var stopImg = function (file) {
        if (file._removeLink) {
            file._removeLink.textContent = this.options.dictRemoveFile;
        }
        if (file.previewElement) {
            return file.previewElement.classList.add("dz-complete");
        }
        //$("#dropzone").spin(false);
    };
    var errorImg = function (file, error) {
        //$("#btnEnviar").attr("disabled", false);
        if (typeof error !== "String" && error.error) {
            error = error.error;
        }
        if ((error.size / 1024 / 1024) > 8) {
            error = x_translate("Error. Tamaño máximo de archivo 8 MB.");

        }
        x_alert(error);
        if (file.previewElement) {
            file.previewElement.remove();
        }
        if ($("#dropzone .dz-preview").length == 0) {
            $("#dropzone").removeClass("dz-started");
        }

        var _ref;
        if (file.previewElement) {
            if ((_ref = file.previewElement) != null) {
                _ref.parentNode.removeChild(file.previewElement);
            }
        }
        return this._updateMaxFilesReachedClass();

    };
</script>

<div class="modal-header">
    <div class="modal-title">
        <h5><span  class="fui-photo"></span>{"Agregar archivo"|x_translate}</h5>
    </div>

</div>
<div class="modal-body">
    <form action="{$url}add_estudio_image_medico.do" method="post" id="upload_image" >
        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}"/>
        <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" value="{$idperfilSaludConsulta}"/>
        <input type="hidden" name="cantidad" id="cantidad" value=""/>


        <div class="form-content" >
            <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
                <p>
                    {x_component_upload_multiple_img manager="ManagerPerfilSaludEstudios" id_group=$idpaciente selector="#dropzone" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpg,image/jpeg"}
                    <label for="file-upload" class="dp-plus file-upload">{"Agregar exámen, estudio o foto "|x_translate}<small>{"Ud. podrá subir archivos jpg, pdf, png"|x_translate}</small>
                    </label>
                </p>
            </div>


            <p><input type="text"  name="titulo" id="tituloArchivo" placeholder='{"Titulo Ej. Radiografía de tórax, Control"|x_translate}'></p>
            <p><small><small>{"Las archivos de imagen no deben pesar más de 8MB."|x_translate}</small></small></p>
        </div>
        <div class="modal-btns">
            <a href="javascript:;" id="save_all_images" >{"Agregar"|x_translate}</a>
        </div>
    </form>


</div>

{literal}
    <script>

        $("#save_all_images").click(function () {

            if ($("#fechaArchivo").val() == "" || $("#tituloArchivo").val() == "") {
                x_alert(x_translate("La fecha y el título de las imágenes son obligatorias"));
                return false;
            }

            $('body').spin("large");


            x_sendForm(
                    $('#upload_image'),
                    true,
                    function (data) {
                        $('body').spin(false);

                        if (data.result) {
                            x_loadModule('perfil_salud', 'archivos_consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_consulta', BASE_PATH + "medico");
                            //window.location.href = location_path;
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );
        });

    </script>
{/literal}