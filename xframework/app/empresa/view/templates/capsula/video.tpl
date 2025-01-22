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
    .ubi-video{
        position: relative;
        top: -150px;
        right: 13px;
    }
    .ubi-btn-avanzar{
        position: relative;
        margin-top: 20px;
        right: 80px;
    }
    .h3-clase{
        font-size: 18px;
        margin-top: 10px;
    }



</style>

<section class="cargar-factura"id="section-factura">
    <form  action="{$url}cargar_video.do" method="POST" onsubmit="return checkSize(62914560);"  enctype="multipart/form-data" >
        <input   hidden  id="titulo" name="titulo" >
        <input  id="banderaGenerica" name="banderaGenerica" hidden value="{$banderaGenerica}" >
        {if $banderaGenerica =='0'}
            <!-- carga maxima aproximada 20MB-->
            <div class="row row-mobile">
                <div class="estudio-imagenes-files ce-nc-p4-upload" id="addVideosBtn">
                    <div class="upload-widget dropzone needsclick dz-clickable dim-rec-punteado" >

                        <i class="fui-video"></i>
                        <h3 class="h3-clase">{"Añadir video"|x_translate}</h3>
                        <div class="add-more-container">
                            <div class="add-more-btn"> 
                                <i class="fa fa-plus-circle"></i>
                                <div class="video-list ubi-video">
                                    <ul id='listaVideo'>

                                    </ul>
                                </div>
                            </div>
                        </div>

                        <span class="upload-widget-disclaimer">{"El archivo no deben pesar más de 60MB."|x_translate}</span>

                    </div>

                </div>
            </div>

            <div class="contenedor-btn-siguiente-iban ubi-btn-avanzar">
            </div> 
            <div class="row">
                <div class="col-md-4">
                    <input  type="file"  id="addvideosinput" name="addvideosinput" accept="video/*">
                </div>
                <input hidden   id="addvideosinputhidden" name="addvideosinputhidden" >
                <div class="col-md-12">

                </div>
            </div>

        {else}
            <embed style="height: 400px;" class="tm-video-mobile" src="{$url}xframework/files/entities/capsula/video/{$videoCapsula.idvideocapsula}/{$nombVideo}.{$videoCapsula.ext}#toolbar=0&navpanes=0&scrollbar=0"  width="100%" height="600px" />
            <input  id="srcV" name="srcV" hidden value="{$url}xframework/files/entities/capsula/video/{$videoCapsula.idvideocapsula}/{$nombVideo}.{$videoCapsula.ext}" >

        {/if}
        <button style="position: relative;    {if $banderaGenerica =='1'}  right: 0px; {else} right: 70px; {/if}"  id="btnSiguiente" type="submit" class="btn-default btn-siguiente btn-default-iban">{"Siguiente"|x_translate}</button>

    </form>
</section>

{x_load_js}
<script>

    $('#btnSiguiente').click(function () {
        $("#titulo").val($("#input_titulo").val());
        $("body").spin("large");
    });


    $('#addVideosBtn').click(function () {
        if ($("#cant_capsulas_lista").val() < 1) {
            titulo = $("#input_titulo").val();
            $("#addvideosinputhidden").val($("#addvideosinput").val());

            if (titulo != '') {
                $("#titulo").val($("#input_titulo").val());
                $(this).parents().find('#addvideosinput').click();
            } else {
                x_alert(x_translate("Debe completar un titulo"));
                $("#input_titulo").css('border', 'solid 2px red');
            }
        } else {
            x_alert(x_translate('Solo puede tener una capsula para ser compartida'));
        }

    });

    document.getElementById('addvideosinput').onchange = e => {
        $("#btnSiguiente").show();
        $("#listaVideo").empty();
        const file = e.target.files[0];
        const url = URL.createObjectURL(file);
        const li = '<li> <video controls="controls" src="' + url + '" type="video/mp4" width="400px" height="200px"></video></li>';
        $('.video-list ul').append(li);

    };


    $(function () {

        $("#input_titulo").keypress(function () {
            if ($("#input_titulo").val().length >= 0) {
                $("#input_titulo").css('border', '1px solid #ccc');

            } else {
                $("#input_titulo").css('border', 'solid 2px red');
            }
        });


    });


    $(document).ready(function () {
        $("#btnSiguiente").hide();
    });

    function checkSize(max_img_size)
    {
        var input = document.getElementById("addvideosinput");
        // check for browser support (may need to be modified)
        if (input.files && input.files.length == 1)
        {
            if (input.files[0].size > max_img_size)
            {
                $("body").spin(false);
                x_alert(x_translate("El archivo debe ser inferior a 40MB"));

                return false;
            }
        }

        return true;
    }

</script> 
