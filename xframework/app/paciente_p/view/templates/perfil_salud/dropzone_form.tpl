<script>
    //callbacks de la imagen
    var successImg = function (file, responseText) {

        if (file.previewElement) {
            return file.previewElement.classList.add("dz-success");
        }
        if (responseText.status <= 0) {
            x_alert(responseText.error);
            if (file._removeLink) {
                file._removeLink.textContent = this.options.dictRemoveFile;
            }
            if (file.previewElement) {
                return file.previewElement.classList.add("dz-complete");
            }
        }
    };

    var startImg = function (file) {

        $("#cantidad_adjunto").val(parseInt($("#cantidad_adjunto").val()) + 1);
        $("#cantidad").val($("#cantidad_adjunto").val());
        //$("#dropzone").spin("large");

        if (file.previewElement) {
            file.previewElement.classList.add("dz-processing");
            if (file._removeLink) {
                file._removeLink.textContent = this.options.dictCancelUpload;
            }
        }

        //agregar icono para pdf
        if (file.type == "application/pdf") {
            file.previewElement.classList.add("dz-pdf");
            $(".dropzone .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_pdf.png");
        }
        if (parseInt($("#cantidad_adjunto").val()) > 20) {
            x_alert(x_translate("No puede agregar más de 20 imágenes pertenecientes a un mismo estudio"));
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

    var errorImg = function (file, message) {
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
        if ($(".dropzone .dz-preview").length == 0) {
            $(".dropzone").removeClass("dz-started");
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
<form name="estudios-imagenes-agregar-estudio" id="upload_image" action="{$url}add_estudio_image.do" method="post">
    <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$idpaciente}"/>
    <input type="hidden" name="cantidad" id="cantidad" value=""/>




    <div class="container-fluid">
        <div class="row estudios-imagenes-date-title-row">
            <div class="col-sm-6 col-md-4">
                <div class="estudios-imagenes-date-holder">
                    <div id='datetimepicker1' data-date-format="DD/MM/YYYY">
                        <input type="text" id="fechaArchivo" name="fecha" placeholder="__/__/____" data-date-format="DD/MM/YYYY" >
                        <img src="{$IMGS}icons/icon-calendar.svg"  class="ico"/>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-md-8">
                <input type="text" name="titulo" id="tituloArchivo" placeholder='{"Titulo Ej. Radiografía de tórax, Control"|x_translate}'/>
            </div>
        </div>
        <div class="upload-widget dropzone needsclick dz-clickable"  id="dropzone">

            {x_component_upload_multiple max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" folder="images_estudios_imagenes" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf"}

            <div class="dz-message needsclick">
                <i class="fui-clip"></i>
                <h3>{"Archivos adjuntos"|x_translate}</h3>
                <small>{"Ud. podrá subir archivos en formato:"|x_translate}&nbsp; JPG, PNG, PDF</small>
                <div class="add-more-container">
                    <div class="add-more-btn"> 
                        <i class="fa fa-plus-circle"></i>
                        <span>{"Agregar más"|x_translate}</span>
                    </div>
                </div>
            </div>
        </div>
        <span class="upload-widget-disclaimer">{"Los archivos no deben pesar más de 8MB."|x_translate}</span>

        <div class="row">
            <div class="col-sm-12">
                <div class="estudios-imagenes-action-holder">
                    <a href="javascript:;" id="save_all_images" class="btn btn-primary guardar-btn">{"Agregar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</form>
{literal}
    <script>
        $(document).ready(function (e) {
            $("#datetimepicker1")
                    .datetimepicker({
                        pickTime: false,
                        language: 'fr'
                    });

            $("#fechaArchivo").inputmask("d/m/y");

        });


        $("#save_all_images").click(function () {

            //valdamos las opciones obligatorias
            $("#fechaArchivo").css("border", "none");
            $("#tituloArchivo").css("border", "none");
            if ($("#fechaArchivo").val() == "" || $("#tituloArchivo").val() == "") {
                if ($("#fechaArchivo").val() == "") {
                    $("#fechaArchivo").css("border", "1px solid red");
                }
                if ($("#tituloArchivo").val() == "") {
                    $("#tituloArchivo").css("border", "1px solid red");
                }

                x_alert(x_translate("La fecha y el título de las imágenes son obligatorias"));
                return false;
            }


            //imagenes requeridas
            if ($("#dropzone .dz-preview.dz-success").length == 0) {
                x_alert(x_translate("Error, no ha seleccionado imágenes"));
                return false;
            }


            //carga de imagenes en proces
            if ($("#dropzone .dz-complete").length != $("#dropzone .dz-preview").length) {
                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                return false;
            }
            $('#upload_image').spin("large");
            x_sendForm(
                    $('#upload_image'),
                    true,
                    function (data) {
                        $('#upload_image').spin(false);
                        x_alert(data.msg);
                        if (data.result) {
                            window.location.href = "";
                        }
                    }
            );
        });

    </script>
{/literal}