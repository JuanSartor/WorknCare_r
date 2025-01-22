{literal}
    <script>
        var upload_success = function (file, responseText) {
            $("#upload_receta #cantidad_file").val(parseInt($("#upload_receta #cantidad_file").val()) + 1);
            $("#upload_receta #cantidad_archivos_receta").val($("#upload_receta #cantidad_file").val());




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
            if ((file.size / 1024 / 1024) > 8) {
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
                $("#dropzone_receta .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_pdf.png");
            }
            if (parseInt($("#upload_receta #cantidad_file").val()) > 8) {
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

        var upload_error = function (file, message) {

            if (file._removeLink) {
                file._removeLink.click();
            }
            if (typeof message !== "String" && message.error) {
                message = message.error;
            }
            if ((file.size / 1024 / 1024) > 8) {
                message = x_translate("Error. Tamaño máximo de archivo 8 MB.");

            }
            x_alert(message);
            if (file.previewElement) {
                file.previewElement.remove();
            }
            if ($("#dropzone_receta .dz-preview").length == 0) {
                $("#dropzone_receta").removeClass("dz-started");
            }
            var node, _i, _len, _ref, _results;
            if (file.previewElement) {
                file.previewElement.classList.add("dz-error");
                if (typeof message !== "String" && message.error) {
                    message = message.error;
                }
                _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]");
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    node = _ref[_i];
                    _results.push(node.textContent = message);
                }
                return _results;
            }
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
        #upload_receta .dz-message h3{
            font-size: 14px;
        }
        #upload_receta .dz-message small{
            font-size: 12px;
        }

    }
</style>
<form action="{$url}add_receta_medico.do" method="post" id="upload_receta" >
    <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}"/>
    <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" value="{$idperfilSaludConsulta}"/>
    <input type="hidden" name="cantidad" id="cantidad_archivos_receta" value=""/>

    <p>
        <select name="tipo_receta_idtipo_receta" id="tipo_receta_idtipo_receta" class="form-control select select-inverse select-block">
            <option value="">{"Seleccione tipo de receta"|x_translate}</option>
            {html_options options=$combo_tipo_receta}
        </select>
    </p>

    <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone_receta">
        {x_component_upload_multiple selector="#dropzone_receta" max_size=8 folder="receta_archivo" callback_success="upload_success" callback_start="upload_start" callback_stop="upload_stop" callback_error="upload_error" filter="application/pdf"}

        <div class="dz-message needsclick">
            <i class="icon-doctorplus-plus"></i>
            <h3>{"Agregar receta escaneada"|x_translate}</h3>
            <small>{"Ud. podrá subir archivos en formato:"|x_translate}&nbsp; PDF</small>
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
        <a href="javascript:;" id="save_receta" class="btn btn-primary guardar-btn"><span class="fui-plus"></span> {"Agregar"|x_translate}</a>
    </div>
</form>
<p>&nbsp;</p>

{literal}
    <script>
        $(function () {
            renderUI2();
            $("#save_receta").click(function () {

                //carga de imagenes en proces
                if ($("#dropzone_receta .dz-complete").length != $("#dropzone_receta .dz-preview").length) {
                    x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                    return false;

                }
                if ($("#tipo_receta_idtipo_receta").val() == "") {
                    x_alert(x_translate("Seleccione el tipo de receta"));
                    return false;
                }
                $('body').spin("large");
                x_sendForm(
                        $('#upload_receta'),
                        true,
                        function (data) {
                            $('body').spin(false);

                            if (data.result) {
                                x_loadModule('perfil_salud', 'add_archivos_receta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_add_receta', BASE_PATH + "medico");
                                x_loadModule('perfil_salud', 'list_archivos_receta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_receta', BASE_PATH + "medico");
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });

        });
    </script>
{/literal}