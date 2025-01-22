{literal}
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
            if ($("#dropzone .dz-preview").length == 0) {
                $("#dropzone").removeClass("dz-started");
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


<form action="{$url}add_estudio_image_medico.do" method="post" id="upload_image" >
    <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}"/>
    <input type="hidden" name="perfilSaludConsulta_idperfilSaludConsulta" value="{$idperfilSaludConsulta}"/>
    <input type="hidden" name="cantidad" id="cantidad" value=""/>

    <p><input type="text" placeholder='{"Titulo Ej. Radiografía de tórax, Control"|x_translate}'  auto-focus name="titulo"></p>
    <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">


        {x_component_upload_multiple selector="#dropzone" max_size=8 id_cantidad="cantidad_adjunto" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" folder="images_estudios_imagenes" filter="image/jpeg,image/png,application/pdf"}    
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

</form>
<div class="estudios-imagenes-action-holder"  style="display:block; text-align:center; float: none;   margin-right:0px">
    <a href="javascript:;" id="save_all_images" class="btn btn-primary guardar-btn"><span class="fui-plus"></span> {"Agregar"|x_translate}</a>
</div>

{literal}
    <script>
        $("#save_all_images").click(function () {
            //verififcamos campos requeridos
            $("input[name='titulo']").css("border", "none");
            if ($("input[name='titulo']").val() == "") {
                x_alert(x_translate("Ingrese un titulo para los documentos adjuntos"));
                $("input[name='titulo']").css("border", "1px solid red");
                return false;
            }
            //imagenes requeridas
            if ($("#dropzone .dz-preview.dz-success").length == 0) {
                x_alert(x_translate("Error, no ha seleccionado archivos"));
                return false;
            }


            //carga de imagenes en proces
            if ($("#dropzone .dz-complete").length != $("#dropzone .dz-preview").length) {
                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                return false;

            }

            $("#cantidad").val($("#dropzone .dz-preview.dz-success").length);
            $('body').spin("large");


            x_sendForm(
                    $('#upload_image'),
                    true,
                    function (data) {
                        $('body').spin(false);

                        if (data.result) {
                            x_loadModule('perfil_salud', 'list_archivos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_consulta', BASE_PATH + "medico");
                            x_loadModule('perfil_salud', 'add_archivos_estudios', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_add_archivos', BASE_PATH + "medico");
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );
        });

    </script>
{/literal}