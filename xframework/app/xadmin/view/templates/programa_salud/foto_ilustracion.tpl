<style>
    .image-box img{
        background:#ccc;
    }
</style>
<div class="upload-image-wrapper" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>Foto Ilustracion</label>
        <div class="image-box" style="padding:10px">
            {if $record.ilustracion.original!=""}
                <a href="{$record.ilustracion.original}" target="_blank" id="lnk-ilustracion"><img src="{$record.ilustracion.original}" width="110" height="110"  id="img_ilustracion" class="img-responsive img-circle"></a>
                {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="img_ilustracion" class="img-responsive img-circle">
            {/if}
        </div>
        <a href="javascript:;"  id="file-upload-ilustracion" class="button  icon save file-upload picture dz-clickable">{"Actualizar Foto"|x_translate} PNG</a>
        <div style="display:none" id="hidden_upload_ilustracion"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successImg = function (file, responseText) {
            //					console.log(file);
            console.log("response_text", responseText);
            if (responseText.status == 0) {
                x_alert(responseText.error);

            } else if (responseText.status == 1 && responseText.image && responseText.image !== "") {
                $("#img_ilustracion").attr("src", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
                $("#lnk-ilustracion").attr("href", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
            }
        };

        var startImg = function () {

        };
        var stopImg = function () {

        };
        var errorImg = function (file, error) {

            x_alert(error);
        };
    </script>

    {x_component_upload_img_v3 id=$record.idprograma_categoria manager="ManagerProgramaSaludCategoria" name="ilustracion" selector="#file-upload-ilustracion" preview="#hidden_upload_ilustracion" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/png"}

</div>
