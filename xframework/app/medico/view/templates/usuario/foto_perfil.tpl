<!-- Modal full width- ver archivos-->
<style>

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

</style>
<div class="row">
    <div class="text-center pul-np-image-holder mul-medico-info-profesional dropdown-menu-container">
        <div class="dropdown">
            <a class="dropdown-toggle" type="button" id="dropdown-foto-perfil" data-toggle="dropdown">

                <figure class="pul-np-image-box">
                    {if $imgs}
                        <img src="{$imgs.usuario}" width="200" alt="Foto de perfil" id="img_usuario" class="img-responsive img-circle">
                    {else}
                        <img src="{$IMGS}extranet/noimage_perfil.png" width="200" alt='{"Foto de perfil"|x_translate}' id="img_usuario" class="img-responsive img-circle">
                    {/if}
                    <div class="icon">
                        <i class="fa fa-camera"></i>
                    </div>
                </figure>
            </a>
            <ul class="dropdown-menu" aria-labelledby="dropdown-foto-perfil">
                <li><a href="javascript:;" id="file-upload-perfil">{"Actualizar foto de perfil"|x_translate}</a></li>
                <li><a href="javascript:;" id="a_image_modal" data-toggle="modal" data-target="#modal">{"Recorte y personalice la foto de perfil"|x_translate}</a></li>
            </ul>
        </div>

        <div class="text-center">
            <p class="disclaimer">
                <small>
                    {"Recuerde que es importante que cargue una foto actualizada. A los pacientes les gusta ver el rostro del profesional que los atenderán. (Imagen 400 x 235 px)."|x_translate}
                </small>
            </p>
        </div>

        <a href="javascript:;" data-target="#modal" data-toggle="modal" class="thumb-cropper">
        </a>
        <!--Modal cropper imagen-->
        <div class="modal modal-full fade" id="modal" aria-labelledby="modalLabel" role="dialog" tabindex="-1">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body cropper-body">
                        <div>
                            {if $imagen_medico.original}
                                <img id="image" src="{$imagen_medico.original}" alt='{"Mi foto de perfil"|x_translate}'>

                            {else}
                                <img id="image" src="{$IMGS}extranet/noimage-paciente.jpg" width="200" alt='{"Mi foto de perfil"|x_translate}' >
                            {/if}
                        </div>                                 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary  pull-left" data-method="rotate" data-option="-90" title='{"Girar a la izquierda"|x_translate}'><i class="fa fa-rotate-left"></i></button>
                        <button type="button" class="btn btn-primary  pull-left" data-method="rotate" data-option="90" title='{"Girar a la derecha"|x_translate}'><i class="fa fa-rotate-right"></i></button>
                        <button type="button" class="btn btn-primary pull-right" id="btnRecortar" data-dismiss="modal">{"Guardar"|x_translate}</button>
                    </div>


                </div>
            </div>
        </div>
        <!--Fin modal cropper-->

        <!-- Scripts cropper -->

        <script>
            $(function () {
                var $image = $('#image');
                var cropBoxData;
                var canvasData;
                var imageData;


                $('button[data-method="rotate"]').on("click", function () {
                    var btn = $(this);
                    var grados = btn.data("option");
                    $('#image').cropper("rotate", grados);
                });

                $("#img_usuario").click(function (e) {
                    e.preventDefault();

                    console.log("click");
                    $(".dropdown button").trigger("click");
                });



                $('#modal').on('shown.bs.modal', function () {
                    $image.cropper({
                        aspectRatio: 1,
                        viewMode: 0,
                        minContainerHeight: 300,
                        dragMode: 'none',
                        zoomable: false,
                        scaleX: 1,
                        scaleY: 1,
                        autoCropArea: 1,
                        built: function () {
                            $image.cropper('setCanvasData', canvasData);
                            $image.cropper('setCropBoxData', cropBoxData);
                        }
                    });
                }).on('click', '#btnRecortar', function () {
                    cropBoxData = $image.cropper('getCropBoxData');
                    canvasData = $image.cropper('getCanvasData');
                    imageData = $image.cropper('getImageData');

                    //                            console.log($image.cropper('getImageData'));
                    //                            console.log(cropBoxData);
                    //                            console.log(canvasData);
                    //                            return false;
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
                            BASE_PATH + 'crop_image_medico_and_save.do',
                            "&top=" + top_proporcional +
                            "&left=" + left_proporcional +
                            "&height=" + height_proporcional +
                            "&width=" + witdh_proporcional +
                            "&idmedico=" + $("#idmedico").val() +
                            "&grado=" + rotate_image,
                            function (data) {
                                if (data.result) {

                                    if (data.imgs) {
                                        var $date = new Date();

                                        $("#img_usuario").attr("src", data.imgs.usuario + "?" + $date.getTime());
                                        $("#image").attr("src", data.imgs.original + "?" + $date.getTime());
                                        $("#imagen_menu_privado_perfil").attr("src", data.imgs.perfil + "?" + $date.getTime());

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
            {* <label for="picture-upload" id="file-upload-perfil" class="file-upload picture dz-clickable">{"Actualizar Foto"|x_translate}</label>*}
            <div style="display:none" id="hidden_upload"></div>

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

                                        var $date = new Date();

                                        $("#img_usuario").attr("src", data.imgs.usuario + "?" + $date.getTime());
                                        $("#image").attr("src", data.imgs.original + "?" + $date.getTime());
                                        $("#imagen_menu_privado_perfil").attr("src", data.imgs.perfil + "?" + $date.getTime());

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
            <form id="frm_Img" role="form" action="{$url}save_medico.do" method="post" >
                <input type="hidden" name="foto_perfil" value="1"/>
                {x_component_upload_img_v3 id=$medico.idmedico manager="ManagerMedico" selector="#file-upload-perfil" preview="#hidden_upload" callback_success="successImg" callback_start="startImg" callback_stop="stopImg" callback_error="errorImg" filter="image/jpg,image/jpeg,image/png"}
            </form>
        </div>

    </div>



</div>