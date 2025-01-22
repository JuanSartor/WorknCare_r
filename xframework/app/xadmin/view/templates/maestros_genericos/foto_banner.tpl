<style>
    .image-box img{
        background:#ccc;
    }
</style>
<div class="upload-image-wrapper" style="text-align:center;    display: inline-block;margin-top:10px">
    <div class="upload-container">
        <label>Foto banner</label>
        <div class="image-box" style="padding:10px">
            {if $record.banner.original!=""}
                <a href="{$record.banner.original}" target="_blank" id="lnk-banner"><img src="{$record.banner.original}" width="110" height="110"  id="img_banner" class="img-responsive img-circle"></a>
                {else}
                <img src="{$url}xframework/app/themes/dp02/imgs/extranet/no-photo.png" width="110" height="110"  id="img_banner" class="img-responsive img-circle">
            {/if}
        </div>
        <a href="javascript:;"  id="file-upload-banner" class="button  icon save file-upload picture dz-clickable">{"Actualizar Foto"|x_translate} PNG</a>
        <div style="display:none" id="hidden_upload_banner"></div>
    </div>
    <script>
        //callbacks de la imagen
        var successImg = function (file, responseText) {
            //					console.log(file);
            console.log("response_text", responseText);
            if (responseText.status == 0) {
                x_alert(responseText.error);

            } else if (responseText.status == 1 && responseText.image && responseText.image !== "") {
                $("#img_banner").attr("src", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
                $("#lnk-banner").attr("href", BASE_PATH + responseText.image + "?v=" + new Date().getTime());
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

    {x_component_upload_img_v3 id=$record.idbanner_promocion manager="ManagerBannerPromocion" name="banner" selector="#file-upload-banner" preview="#hidden_upload_banner" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/png"}

</div>