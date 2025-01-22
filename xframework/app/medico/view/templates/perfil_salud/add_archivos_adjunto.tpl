{literal}
    <script>
        var upload_success = function (file, responseText) {
            $("#upload_adjunto #cantidad_adjunto").val(parseInt($("#upload_adjunto #cantidad_adjunto").val()) + 1);
            $("#upload_adjunto #cantidad").val($("#upload_adjunto #cantidad_adjunto").val());
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
                return file.previewElement.classList.add("dz-success");
            }

        };

        var upload_start = function (file) {
            //$("#btnEnviar").attr("disabled", true);
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
            if (parseInt($("#upload_adjunto #cantidad").val()) > 8) {
                x_alert(x_translate("No puede agregar más de 8 archivos pertenecientes a una misma documentación"));
                return false;
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
            if (typeof error !== "String" && error.error) {
                error = error.error;
            }
            if ((file.size / 1024 / 1024) > 8) {
                error = x_translate("Error. Tamaño máximo de archivo 8 MB.");

            }
            x_alert(error);
            if (file.previewElement) {
                file.previewElement.remove();
            }
            if ($(".dropzone .dz-preview").length == 0) {
                $(".dropzone").removeClass("dz-started");
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
        #upload_adjunto .dz-message h3{
            font-size: 14px;
        }
        #upload_adjunto .dz-message small{
            font-size: 12px;
        }

    }
</style>
<form action="{$url}add_adjunto_medico.do" method="post" id="upload_adjunto" >
    <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}"/>
    <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" value="{$idperfilSaludConsulta}"/>
    <input type="hidden" name="cantidad" id="cantidad" value=""/>


    <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone_adjunto">
        {x_component_upload_multiple selector="#dropzone_adjunto" max_size=8 id_cantidad="cantidad_adjunto" folder="adjunto_archivo" callback_success="upload_success" callback_start="upload_start" callback_stop="upload_stop" callback_error="upload_error" filter="application/pdf"}

        <div class="dz-message needsclick">
            <i class="icon-doctorplus-plus"></i>
            <h3>{"Agregar archivo"|x_translate}</h3>
            <small>{"Ud. podrá subir archivos PDF"|x_translate}</small>
            <div class="add-more-container">
                <div class="add-more-btn"> 
                    <i class="fa fa-plus-circle"></i>
                    <span>{"Agregar más"|x_translate}</span>
                </div>
            </div>
        </div>

    </div>
    <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>

    <div class="estudios-imagenes-action-holder" style="display:block; text-align:center; float: none;   margin-right:0px">
        <a href="javascript:;" id="save_adjunto" class="btn btn-primary guardar-btn"><span class="fui-plus"></span> {"Agregar"|x_translate}</a>
    </div>
</form>
<p>&nbsp;</p>

{literal}
    <script>
        $(function () {
            renderUI2();
            $("#save_adjunto").click(function () {



                $('#upload_adjunto').spin("large");
                x_sendForm(
                        $('#upload_adjunto'),
                        true,
                        function (data) {
                            $('#upload_adjunto').spin(false);

                            if (data.result) {
                                x_loadModule('perfil_salud', 'add_archivos_adjunto', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_add_adjunto', BASE_PATH + "medico");
                                x_loadModule('perfil_salud', 'list_archivos_adjunto_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_adjunto', BASE_PATH + "medico");

                                //window.location.href = location_path;
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });

        });
    </script>
{/literal}