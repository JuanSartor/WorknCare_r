<!-- Paso 1 -->
<section class="nro-iban" id="section-iban" {if $iban_beneficiario["iban"]!=''} hidden {/if}>
    <form id="form_reembolso_steep-1" role="form"  method="POST" onsubmit="return false;">
        <input type="hidden" name="step" value="1" />
        <div class="okm-container">
            <div class="container-texto-iban">
                <h6> {"Agregue su numero de cuenta bancaria"|x_translate}</h6>
                <h7> {"Su cuenta quedara registrada para los proximos reembolsos"|x_translate}</h7>
            </div>
            <div class="container-cta-bancaria">
                <span><i class="fas fa-university fa-2x icono-cta-bancaria"></i>{"Numéro IBAN"|x_translate}</span>
            </div>
            <div class="container-input-iban">
                <input  type="text"  id="iban" name="iban"  placeholder="FR14 0000 0000 0000 0000 0X00 000"/>
            </div>
            <div class="contenedor-btn-siguiente-iban">
                <a href="javascript:;" id="validar_iban" class="btn-default btn-siguiente btn-default-iban" data-step="1" >{"Siguiente"|x_translate}</a>
            </div>
        </div>
    </form>
</section>
<!-- Paso 2 -->
<section class="cargar-factura" {if $iban_beneficiario["iban"]==''} hidden {/if} id="section-factura">
    <form id="form_reembolso_steep-2"  name="form_reembolso_steep-2" action="{$url}cargar_adjuntos.do" method="POST" onsubmit="return false;">
        <input type="hidden" name="step" value="2" />
        <!-- seteo el iban con el valor obtenido en el form anterior -->
        <input type="hidden" name="ibanForm2" id="ibanForm2" {if $iban_beneficiario["iban"]!=''} value='{$iban_beneficiario["iban"]}'  {/if} />
        <input type="hidden" name="bandera_iban" id="bandera_iban" {if $iban_beneficiario["iban"]!=''} value='1' {else}  value='0'  {/if} />
        <div class="okm-container">
            <div class="container-texto-iban">
                <h6> {"Envianos tu ticket o factura (foto...)"|x_translate}</h6>
            </div>
            <div class="row row-mobile">
                <div class="col-sm-10 col-sm-offset-1 estudio-imagenes-files ce-nc-p4-upload">
                    <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone">
                        {x_component_upload_multiple max_size=8 id_cantidad="cantidad_adjunto" selector="#dropzone" callback_success="successImg" folder="archivos_reembolso_beneficiario"
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
            <div class="contenedor-btn-siguiente-iban">
                <a href="javascript:;" data-vc="{$vc_disponibles_previa}" class="btn-default btn-siguiente btn-default-iban" id="btn-carga-archivos" >{"Siguiente"|x_translate}</a>
            </div>
        </div>
    </form>
</section>
<!-- Paso 3 -->
<section class="section-confirmacion" id="section-confirmacion" hidden>
    <form id="form_reembolso_steep-1" role="form"  method="POST" onsubmit="return false;">
        <input type="hidden" name="step" value="1" />
        <div class="okm-container">
            <div class="container-texto-iban">
                <div class="container-confirmacion">
                    <img src="{$IMGS}icons/icon-check-verde.png" class="img-primero">
                    <h6> {"Su reembolso se procesa dentro de las 72 horas"|x_translate}</h6>
                </div>
                <div class="container-confirmacion">
                    <img src="{$IMGS}icons/icon-check-verde.png">
                    <h6 class="h6-segundo">{"Tienes [[{$vc_disponibles}]] de sesion o experiencia para usar antes de"|x_translate} {$empresa.fecha_vencimiento|date_format:"%d/%m/%y"}</h6>
                </div>
            </div>
            <div class="contenedor-btn-siguiente-iban container-btns-carga-realizada">
                <a href="{$url}panel-paciente/" id="btn-home" class="btn-default btn-siguiente btn-default-iban btn-volver-home" ><i class="fas fa-home"></i> {"Bienvenida"|x_translate}</a>
                <a href="javascript:;" id="btn-mis-reembolsos-confirmacion" class="btn-default btn-siguiente btn-default-iban btn-mis-reembolsos" ><i class="fas fa-history"></i>{"Mis reembolsos"|x_translate}</a>
            </div>
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

    // mascara para iban
    $("#iban").mask("AA00 AAAA AAAA AAAA AAAA AAAA AAAA AAA");

</script> 
