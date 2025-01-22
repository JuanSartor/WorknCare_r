{if !$listado}
{literal}
<script>
    var upload_success = function (file, responseText) {
        $("#cantidad_file").val(parseInt($("#cantidad_file").val()) + 1);
        $("#cantidad").val($("#cantidad_file").val());
       
    


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
        }
        else if (file.previewElement) {
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
        if (parseInt($("#cantidad_file").val()) > 8) {
         x_alert("No puede agregar más de 8 archivos pertenecientes a una misma documentación");
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
        x_alert(error);

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
<div class="top">&nbsp;</div>
<div class="contenido">



    <div class="xForm ">

        <form action="{$controller}.php?action=1&modulo=medicos&submodulo=medicos_documentacion_form"  method="post"  id="f_documentacion" >
            <input type="hidden" name="medico_idmedico" id="idmedicoWin" value="{$smarty.request.idmedico}" />

            <div class="form_container ">
                <div class="title">Cargar documentación</div>
                <ul>
                    <li class="wide">
                        <label>Descripción</label> 
                        {x_form_input  name="titulo" id="descripcion" maxChars="100"}
                    </li>
                    <li class="wide"  style="height: auto !important;">
                        <div class="upload-widget dropzone needsclick dz-clickable" id="dropzone2" style="padding:0px; min-height: 200px !important;" >
                            <div class="dz-message" data-dz-message style="margin-top:80px !important"><span>Haz click aquí o arrastra los archivos</span></div>
                            {x_component_upload_multiple selector="#dropzone2" max_size=8 folder="documentacion_medico" callback_success="upload_success" callback_start="upload_start" callback_stop="upload_stop" callback_error="upload_error" filter="image/jpg,image/jpeg,image/png,text/plain,application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/msword,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"}
                        </div>
                        <div class="clear"></div>

                    </li>
                    <li class="clear"></li>
                </ul>


               
                <ul>
                    <li class="tools">
                        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
                        {x_form_html_button id="btnGuardarDoc" label="Guardar" w="100" type="button" class="icon save"}
                    </li>
                </ul>



            </div> 

        </form>
    </div> 


</div>  
{else}
<div class="top">&nbsp;</div>
<div class="contenido">
    <div class="xForm ">

        <input type="hidden" name="medico_idmedico" id="idmedicoWin" value="{$smarty.request.idmedico}" />

        <div class="form_container ">
            <div class="title">Documentación</div>
            <ul>
                <li class="wide" style="height: auto !important">
                    <div class="upload-widget dropzone needsclick  dz-started" id="lista_archivos_documentacion" style="padding:0px;  min-height: 200px !important;">
                        {foreach from=$listado item=archivo}
                        <a href="{$archivo.path}" download >
                            <div class="dz-preview dz-processing dz-image-preview dz-success dz-complete">
                                <div class="dz-image">
                                {if $archivo.type=="image"}
                                  <img data-dz-thumbnail="" alt="{$archivo.filename}" style="height:120px;width:120px;" src="{$archivo.path}">
                                  {else}
                                <img data-dz-thumbnail="" alt="{$archivo.filename}" style="height:120px;width:120px;" src="{$archivo.icon}">
                                {/if}
                            </div> 
                            <div class="dz-details"> 
                                   
                                <div class="dz-filename">
                                    <span data-dz-name="">{$archivo.filename}</span>
                                </div>  
                            </div> 
                                 <a href="{$archivo.path}" title="{$archivo.filename}" download class="dz-remove">{$archivo.filename_format}</a>
                        </div>
                        </a>
                        
                        {/foreach}
                    </div>
                <div class="clear"></div>
                </li>
                
            <li class="clear"></li>
            </ul>
        </div>
    </div>
</div>
{/if}

