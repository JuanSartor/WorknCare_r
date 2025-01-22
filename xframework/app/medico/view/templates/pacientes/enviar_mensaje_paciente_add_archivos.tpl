{literal}
    <script>
        var upload_success = function (file, responseText) {
            $("#archivos_mensaje #cantidad_file").val(parseInt($("#archivos_mensaje #cantidad_file").val()) + 1);
            //$("#archivos_mensaje #cantidad").val($("#archivos_mensaje #cantidad_file").val());

            //$("#btnEnviar").attr("disabled", false);

            if (responseText.status == "0") {
                x_alert(responseText.error);
                var _ref;
                if (file.previewElement) {
                    if ((_ref = file.previewElement) != null) {
                        _ref.parentNode.removeChild(file.previewElement);
                    }
                }
                return this._updateMaxFilesReachedClass();
            } else if (file.previewElement) {
                //sumamos el acumulado de peso de archivos 
                var total_filesize = parseInt($("#dropzone_mensaje #total_filesize").val());
                total_filesize += file.size;
                $("#dropzone_mensaje #total_filesize").val(total_filesize);
                return file.previewElement.classList.add("dz-success");
            }

        };

        var upload_start = function (file) {

            //$("#btnEnviar").attr("disabled", true);
            //verificamos el tamaño maximo de archivo
            if ((file.size / 1024 / 1024) > 8) {
                return false;
            }
            //verificamos el acumulado maximo de archivos
            var total_filesize = parseInt($("#dropzone_mensaje #total_filesize").val());
            if ((total_filesize / 1024 / 1024) + (file.size / 1024 / 1024) > 20) {
                x_alert(x_translate("Los archivos adjuntos superan el limite de 20MB"));
                return false;
            }
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

        };
        var upload_stop = function (file) {
            //$("#btnEnviar").attr("disabled", false);
            if (file._removeLink) {
                //    $("#btnEnviar").attr("disabled", false);
                file._removeLink.textContent = this.options.dictRemoveFile;
            }
            if (file.previewElement) {
                return file.previewElement.classList.add("dz-complete");
            }
        };

        var upload_error = function (file, error) {
            //$("#btnEnviar").attr("disabled", false);
            if ((file.size / 1024 / 1024) > 8) {
                error = x_translate("Error. Tamaño máximo de archivo 8 MB.");

            }
            x_alert(error);
            if (file.previewElement) {
                file.previewElement.remove();
            }
            if ($("#dropzone_mensaje .dz-preview").length == 0) {
                $("#dropzone_mensaje").removeClass("dz-started");
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
{/literal}

<style>
    .estudio-imagenes-files .upload-widget {
        padding: 0px 16px !important;
    }
    .dropzone .dz-message{
        margin: 1em 0 !important;
    }
    @media (max-width: 460px){
        #archivos_mensaje .dz-message h3{
            font-size: 14px;
        }
        #archivos_mensaje .dz-message small{
            font-size: 12px;
        }

    }
    .btnAdjuntarArchivos{
        font-size: 14px;
    }
    .enviar_mensaje .attache-files{
        margin-bottom:10px;
    }

</style>

<div class="row attache-files" id="archivos_mensaje">
    <div class="col-xs-12">
        <a href="javascript:;" class="btnAdjuntarArchivos">
            <i class="fa fa-paperclip"></i> 
            {"Agregar archivos"|x_translate}
        </a>
    </div>
    <div class="col-xs-12">
        <div id="container_dropzone" style="display:none;">
            <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone_mensaje">
                <input  type="hidden" id="total_filesize" value="0"/>
                {x_component_upload_multiple selector="#dropzone_mensaje" max_size=8 folder="archivos_mensaje_paciente" callback_success="upload_success" callback_start="upload_start" callback_stop="upload_stop" callback_error="upload_error" filter="application/pdf,image/jpeg,image/png"}

                <div class="dz-message needsclick">
                    <i class="icon-doctorplus-plus"></i>
                    <h3>{"Agregar archivos"|x_translate}</h3>
                    <small>{"Ud. podrá subir archivos en formato:"|x_translate} PDF, JPG, PNG</small>
                    <div class="add-more-container">
                        <div class="add-more-btn"> 
                            <i class="fa fa-plus-circle"></i>
                            <span>{"Agregar más"|x_translate}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>




{literal}
    <script>
        $(function () {
            renderUI2();

            $(".btnAdjuntarArchivos").click(function () {
                $("#container_dropzone").slideDown();
            });
        });
    </script>
{/literal}