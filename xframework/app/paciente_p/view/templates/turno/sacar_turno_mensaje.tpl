<script>

    //callbacks de la imagen

    var startImg = function (file) {
        //validamos tamaño maximo
        if ((file.size / 1024 / 1024) > 8) {
            return false;
        }
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


    };
    var successImg = function (file, responseText) {
        $("#cantidad_adjunto").val(parseInt($("#cantidad_adjunto").val()) + 1);
        $("#cantidad").val($("#cantidad_adjunto").val());
        if (file.previewElement && responseText.status == 1) {
            return file.previewElement.classList.add("dz-success");
        } else {
            //x_alert(responseText.error);
            errorImg(file, responseText.error);
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
<div class="col-xs-12">
    <div class="col-sm-10 col-sm-offset-1 ce-nc-p4-mensaje">
      
        <label>{"Mensaje"|x_translate}&nbsp;*</label>
        <textarea id="text-msg" maxlength="800" name="mensaje" placeholder='{"Ingresa aquí tu consulta con el mayor detalle posible para una respuesta más rápida y precisa."|x_translate}'>{$mensaje.mensaje}</textarea>
        <span id="caracter-count">800/0</span>
        
    </div>
</div>
<div class="col-xs-12">
    <div class="col-sm-10 col-sm-offset-1 estudio-imagenes-files ce-nc-p4-upload">

        <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
            {x_component_upload_multiple max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="images_mensajes_turno"
                    callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf"}
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
    </div>
</div>
{literal}
    <script>
        $(function () {
            //contador de caracteres

            $("#caracter-count").html("800/" + $("#text-msg").val().length);

            $("#text-msg").keyup(function () {

                var long = $("#text-msg").val().length;
                $("#caracter-count").html("800/" + long);
            });

            $("#text-msg").change(function () {

                var long = $("#text-msg").val().length;
                $("#caracter-count").html("800/" + long);
            });
        });
    </script>
{/literal}