<!-- Modal full width- ver archivos-->
<style>
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .modal.modal-full  {
        position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        overflow: hidden;
        z-index: 900000;
    }

    .modal-full .modal-dialog {
        position: fixed;
        margin: 0;
        width: 100%;
        height: 90%;
        padding: 0;
    }

    .modal-full .modal-content {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        border: 2px solid #3c7dcf;
        border-radius: 0;
        box-shadow: none;
        width: 90%;
        margin: auto;
    }

    .modal-full  .modal-header {
        position: absolute;
        top: 0;
        right: 0;
        left: 0;
        height: 50px;
        padding: 10px;
        background: #f1f3f5;
        border: 0;
    }
    .modal-full  .modal-header .close{
        font-size: 32px;
    }



    .modal-full .modal-body {
        position: absolute;
        top: 50px;
        bottom: 60px;
        width: 100%;
        font-weight: 300;
        overflow: scroll;
        text-align: center;
    }

    .modal-full .modal-footer {
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        height: 60px;
        padding: 10px;
        background: #f1f3f5;
    }

    .modal-full .modal-footer a{
        max-width:150px;
        cursor:pointer;
        padding:10px 20px;
    }
    .modal-full  .modal-content object,.modal-full  .modal-content embed{
        height:100%;
    }
    .modal-full  .modal-content object[type="application/pdf"],.modal-full  .modal-content embed[type="application/pdf"]{
        width:100%;
        height:100%;
    }
    @media (max-width: 992px){
        .modal-full .modal-dialog {
            margin-top: 25px!important;
        }
        .modal-full  .modal-content object,.modal-full  .modal-content embed{
            height: auto;
            width: 100%;
            max-height: 100%;
        }
    }
    @media (max-width: 600px){
        .excepcion-sacar-rojo:hover {
            background-color:  transparent !important;
        }

    }

    .ajuste-texto-btn-1{
        margin-left: 35px;
        width:150px !important;
        background-color: #F5C370;
        border-radius: 8px !important;
        text-align: center;
    }
    .ajuste-texto-btn-1:hover {
        background-color: #edb964 !important;  
    }
    .ajuste-texto-btn-2:hover {
        background-color: #edb964 !important;  
    }
    .ajuste-texto-btn-2{
        margin-left: 35px;
        width:150px !important;
        background-color: #F5C370;
        border-radius: 8px !important;
        margin-top: 5px;
        text-align: center;
    }


</style>

<div class="okm-row">
    <div class="text-center pul-np-image-holder mul-medico-info-profesional dropdown-menu-container">
        <form id="frm_Img" role="form" method="post" action="{$url}cargar_icono.do" onsubmit="return false;">
            <input type="hidden" id="idempresa" name="idempresa" value="{$record.idempresa}" />
            <div class="dropdown">
                <a class="dropdown-toggle excepcion-sacar-rojo" type="button" id="dropdown-foto-perfil" data-toggle="dropdown">
                    <figure class="pul-np-image-box">

                        {if $record.image}
                            <img src="{$record.image.usuario}?t={$smarty.now}" data-image="1" width="120" id="img_icono_empresa" class=" img-circle pull-right">
                        {else}
                            {if $TRADUCCION_DEFAULT=="fr"}
                                <img src="{$url}xframework/app/themes/dp02/imgs/no-icono-empresa.jpg"  data-image="0" width="120"  height="120" id="img_icono_empresa" class=" img-circle pull-right">
                            {else}
                                <img src="{$url}xframework/app/themes/dp02/imgs/no-icono-empresa_en.jpg"  data-image="0" width="120"  height="120" id="img_icono_empresa" class=" img-circle pull-right">
                            {/if}
                        {/if}
                        <div class="icon">
                            <figure>
                                <i  style="color: #9b9b9b; top: 3px; font-size: 22px;" class="icon-doctorplus-camera"></i>
                            </figure>
                        </div>
                    </figure>
                </a>
                <ul class="dropdown-menu" style="border-color: #1A3661; background-color: #1A3661; " aria-labelledby="dropdown-foto-perfil">
                    <li><a href="javascript:;" class="ajuste-texto-btn-1" id="file-upload-perfil">{"Cargar logo"|x_translate}</a></li>
                    <li><a href="javascript:;" class="ajuste-texto-btn-2"  {if $record.image}data-image="1" {else}data-image="0" {/if} id="a_image_modal" data-toggle="modal" data-target="#modal">{"Personalizar logo"|x_translate}</a></li>
                </ul>
            </div>
        </form>

        <!-- Modal -->
        <div class="modal modal-full fade"  id="modal" aria-labelledby="modalLabel" role="dialog" tabindex="-1">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body cropper-body">
                        <div id="modal_image" {if !$record.image}style="display:none"{/if}>
                            <img id="image" src="{$record.image.comun}?t={$smarty.now}" >
                        </div>
                        <div id="modal_msg_no_image" {if $record.image}style="display:none"{/if}>
                            <h3>{"Seleccione imagen"|x_translate}</h3>
                        </div>
                    </div>
                    <div class="modal-footer">


                        <button type="button" class="btn btn-primary pull-left" data-method="rotate" data-option="-90" title="Girar a la izquierda"><i class="fa fa-rotate-left"></i></button>
                        <button type="button" class="btn btn-primary pull-left" data-method="rotate" data-option="90" title="Girar a la derecha"><i class="fa fa-rotate-right"></i></button>

                        <button type="button" class="btn btn-primary pull-right" id="btnRecortar" data-dismiss="modal">{"Guardar"|x_translate}</button>
                    </div>
                </div>
            </div>
        </div>


        <script>



            $(function () {

                $('#modal').on("click", function (e) {
                    e.stopPropagation();
                });
                var $image = $('#image');
                var cropBoxData;
                var canvasData;
                var imageData;
                $('button[data-method="rotate"]').on("click", function () {
                    var btn = $(this);
                    var grados = btn.data("option");
                    $('#image').cropper("rotate", grados);
                });
                $('#modal').on('shown.bs.modal', function () {
                    if ($('#a_image_modal').data("image") == '0') {

                        x_alert(x_translate("Debe cargar un logo previamente"), recargar);

                    } else {

                        $("#paciente-nav-menu-burger").trigger("click");
                        $image.cropper({
                            aspectRatio: 1,
                            dashed: false,
                            dragCrop: false,
                            checkImageOrigin: false,
                            viewMode: 0,
                            minContainerHeight: 500,
                            dragMode: 'none',
                            zoomable: false,
                            autoCropArea: 1,
                            built: function () {
                                $image.cropper('setCanvasData', canvasData);
                                $image.cropper('setCropBoxData', cropBoxData);
                            }

                        });
                    }

                }).on('click', '#btnRecortar', function () {
                    cropBoxData = $image.cropper('getCropBoxData');
                    canvasData = $image.cropper('getCanvasData');
                    imageData = $image.cropper('getImageData');
                    var crop_top = parseFloat(cropBoxData.top) - parseFloat(canvasData.top);
                    var crop_left = parseFloat(cropBoxData.left) - parseFloat(canvasData.left);
                    //Obtengo los proporcionales a la imagen original
                    var witdh_proporcional = parseFloat(canvasData.naturalWidth) * parseFloat(cropBoxData.width) / parseFloat(canvasData.width);
                    var height_proporcional = parseFloat(canvasData.naturalHeight) * parseFloat(cropBoxData.height) / parseFloat(canvasData.height);
                    //Obtengo los proporcionales al top y left
                    var left_proporcional = parseFloat(canvasData.naturalWidth) * parseFloat(crop_left) / parseFloat(canvasData.width);
                    var top_proporcional = parseFloat(canvasData.naturalHeight) * parseFloat(crop_top) / parseFloat(canvasData.height);
                    var rotate_image = 0;
                    if (imageData.rotate !== "undefined" || parseInt(imageData.rotate) != 0) {
                        rotate_image = parseInt(imageData.rotate);
                    }


                    $("body").spin("large");
                    $image.cropper('destroy');
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'crop_image_and_save_empresa.do',
                            "&top=" + top_proporcional +
                            "&left=" + left_proporcional +
                            "&height=" + height_proporcional +
                            "&width=" + witdh_proporcional +
                            "&idempresa=" + $("#idempresa").val() +
                            "&grado=" + rotate_image,
                            function (data) {

                                if (data.result) {

                                    if (data.imgs) {
                                        var $date = new Date();
                                        $("#img_icono_empresa").attr("src", data.imgs.usuario + "?" + $date.getTime());
                                        $("#image").attr("src", data.imgs.original + "?" + $date.getTime());
                                        $("#modal_image").show();
                                        $("#modal_msg_no_image").hide();
                                        if (data.modificar_cabecera) {
                                            $("#imagen_menu_privado_perfil").attr("src", data.imgs.perfil + "?" + $date.getTime());
                                        }
                                        $("#paciente-nav-menu-burger").trigger("click");
                                        x_alert(data.msg, recargar);
                                    }
                                } else {
                                    x_alert(data.msg);
                                }
                                $("body").spin(false);
                            },
                            "",
                            //Funcion de error
                                    function (data) {
                                        x_alert(x_translate("Se produjo un error al procesar la imagen. Verifique el tamaño de la misma."));
                                        $("body").spin(false);
                                    }
                            );
                        }).on('hidden.bs.modal', function () {
                    $image.cropper('destroy');
                });
            });
        </script>
        <div>
            <div style="display:none" id="hidden_upload"></div>

            {literal}
                <script>
                    //callbacks de la imagen
                    var successImg = function (file, responseText) {
                        //					console.log(file);
                        $("body").spin(false);
                        if (responseText.status == 0) {
                            x_alert(responseText.error);
                        } else if (responseText.status == 1) {
                            x_sendForm(
                                    $('#frm_Img'),
                                    true,
                                    function (data) {
                                        if (data.result) {
                                            if (data.imgs) {
                                                var $date = new Date();
                                                $("#img_icono_empresa").attr("src", data.imgs.usuario + "?" + $date.getTime());
                                                $("#image").attr("src", data.imgs.original + "?" + $date.getTime());
                                                if (data.imgs.change) {
                                                    if ($("#filtro").val() == "self") {
                                                        $("#imagen_menu_privado_perfil").attr("src", data.imgs.perfil + "?" + $date.getTime());
                                                    }
                                                }
                                                x_alert(x_translate("Logo subido"), recargar);
                                            }
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                            );
                        }
                    };
                    var startImg = function () {

                        $("body").spin("large");
                    };
                    var stopImg = function () {
                        $("body").spin(false);
                    };
                    var errorImg = function (file, error) {
                        $("body").spin(false);
                        x_alert(error);
                    };
                </script>
            {/literal}

            {x_component_upload_img_v3 id=$record.idempresa manager="ManagerEmpresa" selector="#file-upload-perfil" preview="#hidden_upload" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" form_id="frm_Img" filter="image/jpg,image/jpeg,image/png"}
        </div>
    </div>
</div>
