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
<section class="cargar-factura"id="section-factura">
    <form id="form_cargar_file"  name="form_cargar_file" action="{$url}cargar_file.do" method="POST" onsubmit="return false;">
        <input  id="titulo" name="titulo" hidden >
        <input  id="banderaGenerica" name="banderaGenerica" hidden value="{$banderaGenerica}" >
        {if $banderaGenerica =='0'}
            <div class="row row-mobile">
                <div class="estudio-imagenes-files ce-nc-p4-upload">
                    <div class="upload-widget dropzone needsclick dz-clickable dim-rec-punteado" id="dropzone">
                        {x_component_upload_multiple max_size=8  id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="capsula/files"
                    callback_start="startImg"  callback_stop="stopImg" callback_error="errorImg" filter="image/jpeg,image/png,application/pdf,.gif, application/vnd.ms-powerpoint,  application/vnd.openxmlformats-officedocument.presentationml.slideshow, application/vnd.openxmlformats-officedocument.presentationml.presentation, .pps, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.presentationml.presentation"}
                        <div class="dz-message needsclick mensaje-upload">
                            <i class="fui-clip"></i>
                            <h3>{"Archivo adjunto"|x_translate}</h3>
                            <small>{"Ud. podrá subir un archivo en formato:"|x_translate}&nbsp; JPG, PNG, PDF, GIF</small>
                            <div class="add-more-container">
                                <div class="add-more-btn"> 
                                    <i class="fa fa-plus-circle"></i>

                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="upload-widget-disclaimer span-aviso">{"El archivo no deben pesar más de 8MB."|x_translate}</span>
                </div>
            </div>
        {else}
            <!-- este else entra cuando es creado a partir de una capsula generica -->
            {if $fileCapsula.ext=='pptx' }
                <!--  aca entra cuando es una ppt -->
                <div style="background: #4582B4; width: 200px;  height: 40px; text-align: center; margin: auto;  margin-bottom: 150px;  border-radius: 8px; line-height: 2; position: relative; top: 90px; right: 85px;">
                    <a style="color: white;" href="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}" >{"Descargar PPT"|x_translate}<i style="margin-left: 10px;" class="fa fa-download"></i></a>
                </div>
                <input  id="src" name="src" hidden value="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}" >

            {else}
                <embed style="height: 500px; margin-bottom: 20px;" class="tm-img-mobile"  src="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}#toolbar=0&navpanes=0&scrollbar=0"  width="100%" height="600px" />
                <input  id="src" name="src" hidden value="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}" >

            {/if}
        {/if}
        <div style="width: 380px;   {if $banderaGenerica =='1'}   margin: auto; {/if}"  class="contenedor-btn-siguiente-iban">
            <a href="javascript:;" data-bandera="{$banderaGenerica}" class="btn-default btn-siguiente btn-default-iban" id="btn-carga-archivos" >{"Crear capsula"|x_translate}</a>
        </div>

    </form>
</section>


{x_load_js}
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




    $(function () {

// boton de paso 2 al clickear valido que exista al menos un archivo cargardo
// y q a su vez no se este cargando ninguno si esto se cumple envio el formulario
        $("#btn-carga-archivos").click(function () {
            bandera = $(this).data("bandera");

            if (bandera == '0') {
                if ($("#cant_capsulas_lista").val() < 1) {
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
                        titulo = $("#input_titulo").val();
                        if (titulo != '') {
                            $("#titulo").val($("#input_titulo").val());
                            x_sendForm($('#form_cargar_file'), true, function (data) {

                                window.location.href = BASE_PATH + "entreprises/capsuleresready/" + data.hash + ".html";
                            });
                        } else {
                            x_alert(x_translate("Debe completar un titulo"));
                            $("#input_titulo").css('border', 'solid 2px red');
                        }
                    }
                } else {
                    x_alert(x_translate('Solo puede tener una capsula para ser compartida'));
                }
            } else {
                if ($("#cant_capsulas_lista").val() < 1) {
                    titulo = $("#input_titulo").val();
                    if (titulo != '') {
                        $("#titulo").val($("#input_titulo").val());
                        x_sendForm($('#form_cargar_file'), true, function (data) {

                            window.location.href = BASE_PATH + "entreprises/capsuleresready/" + data.hash + ".html";
                        });
                    } else {
                        x_alert(x_translate("Debe completar un titulo"));
                        $("#input_titulo").css('border', 'solid 2px red');
                    }
                } else {
                    x_alert(x_translate('Solo puede tener una capsula para ser compartida'));
                }
            }

        });



        $("#input_titulo").keypress(function () {
            if ($("#input_titulo").val().length >= 0) {
                $("#input_titulo").css('border', '1px solid #ccc');

            } else {
                $("#input_titulo").css('border', 'solid 2px red');
            }
        });


    });


</script> 
