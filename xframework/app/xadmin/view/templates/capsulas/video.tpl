<link rel="stylesheet" type="text/css" href="{$url_themes}css/bootstrap-3.3.4.css" />
<link rel="stylesheet" type="text/css" href="{$url_themes}css/font-awesome.min.css" />
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
    <form  action="{$url}cargar_videox.do" method="POST" onsubmit="return checkSize(62914560);"  enctype="multipart/form-data" >
        <input   hidden  id="titulo_video" name="titulo_video" >
        <input type="hidden" name="tipo_capsula" id="tipo_capsula" value="3" />
        <input type="hidden" name="contenedorcapsula_idcontenedorcapsula_video" id="contenedorcapsula_idcontenedorcapsula_video"  />
        <!-- carga maxima aproximada 20MB-->
        <div class="row row-mobile">
            <div class="estudio-imagenes-files ce-nc-p4-upload" id="addVideosBtn">
                <div class="upload-widget dropzone needsclick dz-clickable dim-rec-punteado" >

                    <i class="fui-video"></i>
                    <h3 id="aniTi" class="h3-clase">{"Añadir video"|x_translate}</h3>
                    <div class="add-more-container">
                        <div class="add-more-btn"> 
                            <i class="fa fa-plus-circle"></i>
                            <div class="video-list ubi-video">
                                <ul id='listaVideo' style="top: 150px;  position: relative;  left: 30px;">

                                </ul>
                            </div>
                        </div>
                    </div>

                    <span id="spanTam" class="upload-widget-disclaimer">{"El archivo no deben pesar más de 60MB."|x_translate}</span>

                </div>

            </div>
        </div>

        <!-- <div class="contenedor-btn-siguiente-iban ubi-btn-avanzar">
         </div>  -->

        <input style="background-image: none;"  type="file"  id="addvideosinput" name="addvideosinput" accept="video/*">

        <input hidden   id="addvideosinputhidden" name="addvideosinputhidden" >



        <button style="margin-top: 30px; margin-left: 200px;" id="btnSiguienteV" type="submit" class="button btn-default btn-siguiente btn-default-iban">{"Siguiente"|x_translate}</button>

    </form>
</section>

{x_load_js}
<script>

    $('#btnSiguienteV').click(function () {
        $("#titulo_video").val($("#tituloGeneral").val());
        $("#contenedorcapsula_idcontenedorcapsula_video").val($("#idcontenedorcapsula").val());
        $("body").spin("large");
    });


    $('#addVideosBtn').click(function () {

        titulo = $("#input_titulo").val();
        $("#addvideosinputhidden").val($("#addvideosinput").val());


        $(this).parents().find('#addvideosinput').click();


    });

    document.getElementById('addvideosinput').onchange = e => {

        $("#aniTi").hide();
        $("#spanTam").hide();
        $("#listaVideo").empty();
        const file = e.target.files[0];
        const url = URL.createObjectURL(file);
        const li = '<li> <video controls="controls" src="' + url + '" type="video/mp4" width="400px" height="200px"></video></li>';
        $('.video-list ul').append(li);

    };




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
