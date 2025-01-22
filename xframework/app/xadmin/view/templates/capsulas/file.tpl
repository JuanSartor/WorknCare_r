<style>
    .dim-rec-punteado{
        width: 70% !important;
        height: 250px !important;
    }
    .mensaje-upload{
        position: relative;
        bottom: 30px;
    }
    .span-aviso{
        position: relative;
        right: 100px;
    }

</style>
<script>

// 
// todo lo callbakc y demas que se encuentra abajo son para insertar las imagenes
//

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

        //agregar icono para pppt
        if (file.type == "application/vnd.openxmlformats-officedocument.presentationml.presentation") {
            file.previewElement.classList.add("dz-pdf");
            $(".dropzone .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_ppt.png");
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
<section class="cargar-factura"id="section-factura">
    <form id="form_cargar_file"  name="form_cargar_file" action="{$url}cargar_filex.do" method="POST" onsubmit="return false;">
        <input type="hidden" name="contenedorcapsula_idcontenedorcapsula" id="contenedorcapsula_idcontenedorcapsula"  />
        <input type="hidden" name="titulo" id="titulo" />
        <input type="hidden" name="tipo_capsula" id="tipo_capsula" value="1" />
        <div class="row row-mobile">
            <div class="estudio-imagenes-files ce-nc-p4-upload" style="margin-left: 40px; width: 500px;">
                <div class="upload-widget dropzone needsclick dz-clickable dim-rec-punteado" id="dropzone">
                    {x_component_upload_multiple max_size=8  id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="capsula/files"
                    callback_start="startImg"  callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf,.gif, application/vnd.ms-powerpoint,  application/vnd.openxmlformats-officedocument.presentationml.slideshow, application/vnd.openxmlformats-officedocument.presentationml.presentation, .pps, application/vnd.openxmlformats-officedocument.presentationml.presentation"}
                    <div class="dz-message needsclick mensaje-upload">
                        <i class="fui-clip"></i>
                        <h3>{"Archivo adjunto"|x_translate}</h3>

                        <div class="add-more-container">
                            <div class="add-more-btn"> 
                                <i class="fa fa-plus-circle"></i>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <div style="width: 380px; margin-left: 160px; margin-top: 20px;"  class="contenedor-btn-siguiente-iban">
            <a href="javascript:;"  class="button btn-default btn-siguiente btn-default-iban" id="btn-carga-archivos-file" >{"Crear capsula"|x_translate}</a>
        </div>

    </form>
</section>


<script>

    $(function () {

// boton de paso 2 al clickear valido que exista al menos un archivo cargardo
// y q a su vez no se este cargando ninguno si esto se cumple envio el formulario
        $("#btn-carga-archivos-file").click(function () {

//carga de imagenes en proceso
            if ($("#dropzone .dz-complete").length !== $("#dropzone .dz-preview").length) {
                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                return false;
            }
// verifico que cargo algun archivo
            else if ($("#dropzone .dz-complete").length != 1) {
                x_alert(x_translate("Debe cargar un solo archivo"));
                return false;
            } else {

                $("#titulo").val($("#tituloGeneral").val());
                $("#contenedorcapsula_idcontenedorcapsula").val($("#idcontenedorcapsula").val());
                x_sendForm($('#form_cargar_file'), true, function (data) {

                    x_goTo('capsulas', 'capsula_list', '', 'Main', this);
                });


            }

        });
    });
</script>

