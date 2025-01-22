<style>
    .image-box img{
        background:#ccc;
    }
</style>
<div class="upload-image-wrapper" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>Foto de la categoría</label>
        <div class="image-box" style="padding:10px">
            {if $record.portada.original!=""}
                <a href="{$record.portada.original}" target="_blank" id="lnk-portada"><img src="{$record.portada.original}" width="110" height="110"  id="img_portada" class="img-responsive img-circle"></a>
                {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="img_portada" class="img-responsive img-circle">
            {/if}
        </div>
        <a href="javascript:;"  id="file-upload-portada" class="button  icon save file-upload picture dz-clickable">{"Actualizar Foto"|x_translate} PNG</a>
        <div style="display:none" id="hidden_upload_portada"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successImg = function (file, responseText) {
            //					console.log(file);
            console.log("response_text", responseText);
            if (responseText.status == 0) {
                x_alert(responseText.error);

            } else if (responseText.status == 1 && responseText.image && responseText.image !== "") {
                $("#img_portada").attr("src", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
                $("#lnk-portada").attr("href", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
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

    {x_component_upload_img_v3 id=$record.idprograma_categoria manager="ManagerProgramaSaludCategoria" name="portada" selector="#file-upload-portada" preview="#hidden_upload_portada" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/png"}

</div>

<div class="upload-image-wrapper" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>Icono</label>
        <div class="image-box" style="padding:10px">
            {if $record.imagen.original!=""}
                <a href="{$record.imagen.original}" target="_blank" id="lnk-image"><img src="{$record.imagen.original}" width="110" height="110"  id="img_categoria" class="img-responsive img-circle"></a>
                {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="img_categoria" class="img-responsive img-circle">
            {/if}
        </div>
        <a href="javascript:;"  id="file-upload-perfil" class="button  icon save file-upload picture dz-clickable">{"Actualizar Foto"|x_translate} PNG</a>
        <div style="display:none" id="hidden_upload"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successImg = function (file, responseText) {
            //					console.log(file);
            console.log("response_text", responseText);
            if (responseText.status == 0) {
                x_alert(responseText.error);

            } else if (responseText.status == 1 && responseText.image && responseText.image !== "") {
                $("#img_categoria").attr("src", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
                $("#lnk-image").attr("href", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
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

    {x_component_upload_img_v3 id=$record.idprograma_categoria manager="ManagerProgramaSaludCategoria" selector="#file-upload-perfil" preview="#hidden_upload" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/png"}

</div>
