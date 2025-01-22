<style>
    .textarea-dim{
        width: 606px !important;
        height: 152px !important;
        text-align: left !important;
    }
    body{
        margin-top:20px !important;
    }
    .check-color{
        color: #ED799E;
        margin-right: 15px;
    }
    .card-logo-socio{
        position: relative;
        left: 310px;
        bottom: 30px;
    }
    @media (max-width: 600px){
        .card-pass{
            position: relative;
            right: 90px;
        }
        .card-logo-socio{
            left: 90px;
        }

    }
    .circulo {
        width: 30px;
        height: 30px;
        -moz-border-radius: 50%;
        -webkit-border-radius: 50%;
        border-radius: 50%;
        background: #5cb85c;
        position: absolute;
    }

    .interno:hover {
        border: solid 3px #f5ff61;
    }
    .rectangulo {
        width: 45px;
        height: 16px; 
        position: relative;
        top: 7px;
        margin-left: 26px;
    }
    .label-rta{
        font-size: 12px;
        width: 60px;
        line-height: 1.5;
        font-weight: 600;
        color: #c6cbc6;
    }
    .btn-cuestionario:hover {
        background: #76a8e5 !important;
    }
    .seleccionado{
        border: solid 15px #f5ff61;
    }
    .todoMalSelect{
        color: black !important;
        top: -15px;
        position: relative;
        right: 8px;
    }
    .todoBienSelect{
        color: black !important;
        top: -15px;
        position: relative;
        right: 8px;
    }
    .input-pregunta{
        font-weight: 600;
        width: 750px;
        background-color: #ffffff;
        margin: auto;
        text-align: center;
        border-radius: 4px;
        height: 60px;
        box-shadow: 0 2px 2px 0 rgb(0 0 0 / 10%), 0 2px 10px 0 rgb(0 0 0 / 9%);
    }
    @media (max-width: 600px){
        .input-pregunta{
            font-size: 15px !important;
            width: 320px;
            height: 97px;
        }
    }
    .ceroDeAcuerdoc{
        background: #dddddd; 
        text-align: center;
        left: 390px;
    }
    .rectangulo-ceroDeAcuerdo{
        background: #dddddd; 
        left: 290px;
    }
    .nadaAcuerdoc{
        background: #a9c5a9; 
        margin-left: 69px; 
        left: 390px;
    }
    .rectangulo-nadaAcuerdo{
        background: #a9c5a9; 
        left: 290px;
    }
    .deAcuerdoc{
        background: #88bf88;
        margin-left: 140px;
        left: 390px;
    }
    .rectangulo-deAcuerdo{
        background: #88bf88;
        left: 290px;
    }
    .superDeAcuerdoc{
        background: #82bd82; 
        margin-left: 211px; 
        text-align: center; 
        left: 390px;
    }
    @media (max-width: 600px){
        .ceroDeAcuerdoc{
            left: 60px;
        }
        .rectangulo-ceroDeAcuerdo{
            left: 40px;
        }
        .nadaAcuerdoc{
            left: 60px;
        }
        .rectangulo-nadaAcuerdo{ 
            left: 40px;
        }
        .deAcuerdoc{
            left: 60px;
        }
        .rectangulo-deAcuerdo{
            left: 40px;
        }
        .superDeAcuerdoc{
            left: 60px;
        }
        .textarea-dim{
            width: 300px !important;
            font-size: 12px !important;
        }
    }
    .input-abierta{ 
        width: 750px;
        text-align: center;
        border-radius: 8px; 
    }
    .primer-label{
        margin-right: 16px;
    }
    @media (max-width: 600px){
        .primer-label{
            position: relative;
            right: 5px;
        }
        .segundo-label{
            position: relative;
            right: 10px;
        }
        .tercer-label{
            position: relative;
            right: 5px;
        }
        .input-abierta{
            width: 325px;
            font-size: 16px;
        }
        .pass-sante-registro-planes.bienvenida-preview {
            margin-top: 0px;
        }
        body{
            margin-top:0px !important;
        }
        .btnmobile{
            display: block !important;
            margin-top: 50px;
        }
        .tm-img-mobile{
            height: 400px;
        }
        .tm-video-mobile{
            height: 300px;
        }
        .ubicacion-logo{
            left: 110px !important;
        }
        .tam-logo{
            height: 33px; 
            width: 150px !important;
        }

    }
    .ubicacion-logo{
        height: 50px;
        position: relative;
        left: 800px;
        bottom: 15px;
        width: 130px;
        top: 20px;
    }
    .tam-logo{
        height: 33px; 
        width: 200px;
    }
    .vd-oculto{
        display: none;
    }
    .img-vid {
        display: none;

    }
    .tam-video{
        width: 800px;
    }
    @media (max-width: 600px){
        .img-vid {
            display: block;
            width: 300px;
        }
        .tam-video{
            width: 300px;
            display: none;
        }
    }


</style>
<div>  
    <input   hidden  id="idcapsula" value="{$capsula.idcapsula}">
    <div class="ubicacion-logo">
        <a  href="{$url}"><img class="tam-logo" src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
    </div>


    <div class="description-content">
        <div style="text-align: center;">
            <h5 style="color: #ababab; margin-top: 0px; margin-bottom: 10px;">{"Capsula"|x_translate}</h5>
        </div>

        {if $capsula.tipo_capsula=='1'} <p id="parrafoBienvenida" style="color:#df2929;" class="text-center">{"File:"|x_translate} {$capsula.titulo}       </p>
            {** {if $fileCapsula.ext !='pdf'} **}
            {if $fileCapsula.ext=='pptx' }
                <div style="background: #4582B4; width: 200px;  height: 40px; text-align: center; margin: auto; margin-top: 50px; margin-bottom: 20px;  border-radius: 8px; line-height: 2;">
                    <a style="color: white;" href="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}" >{"Descargar PPT"|x_translate}<i style="margin-left: 10px;" class="fa fa-download"></i></a>
                </div>
            {else}
               <!-- <embed class="tm-img-mobile"  src="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}"  width="100%" height="600px" />
                -->
                <!-- asi funciona el pdf y en chrome aparece para descargar porque sino te pide un complemento si o si -->


<!--  <iframe class="tm-img-mobile"  src="{$url}xframework/files/entities/capsula/files/{$fileCapsula.idfilecapsula}/{$fileCapsula.nombre}.{$fileCapsula.ext}" height="600px" width="100%"></iframe>
                -->
                <iframe class="tm-img-mobile"  src="https://capsula-bck-test.s3.amazonaws.com/capsula/files/118/constancia-alumno-regular.pdf" height="600px" width="100%"></iframe>

            {/if}

        {else if $capsula.tipo_capsula=='2'} <p id="parrafoBienvenida" style="color:#df2929;" class="text-center">{"Link:"|x_translate} {$capsula.titulo} </p>
            <hr> 
            <div style="text-align: center;">
                <a style="text-align: center;font-size: 22px;" href="{$linkCapsula.link}">{$linkCapsula.link}&nbsp&nbsp&nbsp&nbsp&nbsp{"Click Me"|x_translate}</a>
            </div>
            <hr>

        {else if $capsula.tipo_capsula=='3'} <p id="parrafoBienvenida" style="color:#df2929;" class="text-center">{"Video:"|x_translate} {$capsula.titulo} </p>
            <div style="background: #4582B4; width: 200px;  height: 40px; text-align: center; margin: auto; margin-top: 50px; margin-bottom: 20px;  border-radius: 8px; line-height: 2;">
                <a style="color: white;" download="{$videoCapsula.nombre}" href="{$url}xframework/files/entities/capsula/video/{$videoCapsula.idvideocapsula}/{$videoCapsula.nombre}.{$videoCapsula.ext}" >{"Descargar Video"|x_translate}<i style="margin-left: 10px;" class="fa fa-download"></i></a>
            </div>
            <embed class="tm-video-mobile" src="{$url}xframework/files/entities/capsula/video/{$videoCapsula.idvideocapsula}/{$videoCapsula.nombre}.{$videoCapsula.ext}#toolbar=0&navpanes=0&scrollbar=0"  width="100%" height="600px" />

        {else} <p id="parrafoBienvenida" style="color:#df2929;" class="text-center"> {"Grabacion:"|x_translate} {$capsula.titulo} </p>
            <!--
             <div style="background: #4582B4; width: 200px;  height: 40px; text-align: center; margin: auto; margin-top: 50px; margin-bottom: 20px;  border-radius: 8px; line-height: 2;">
                 <a style="color: white;" download="{$grabacionCapsula.nombre}" href="{$url}xframework/files/entities/capsula/grabacion_video/{$grabacionCapsula.idgrabarvideocapsula}/{$grabacionCapsula.nombre}.mp4" >{"Descargar Grabacion"|x_translate}<i style="margin-left: 10px;" class="fa fa-download"></i></a>
             </div>
            -->
            <img id="img-show-video-inf" class="img-vid"  onclick="showHomeVideoInf()" src="{$url}xframework/app/themes/dp02/videos/img-video-click.png" alt={"WorknCare, la solution Prévention & QVT plug & play"|x_translate} />

            <video class="tam-video" id="home-video" preload  muted="false" controls="true">
                <source   id="video-grab" class="tm-video-mobile " src="{$url}xframework/files/entities/capsula/grabacion_video/{$grabacionCapsula.idgrabarvideocapsula}/{$grabacionCapsula.nombre}.mp4"  width="100%" height="600px"  type="video/mp4" >
            </video>  
        {/if}
    </div>

</div>

{literal}
    <script>
        $(function () {

            $(document).ready(function () {
                $("#home-video").prop('muted', false);
                $("#video-grab").prop('muted', false);


                idcapsula = $("#idcapsula").val();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=sumar_visitas",
                        'idcapsula=' + idcapsula,
                        function () {

                        }

                );
            });


        });

        function showHomeVideoInf() {
            $("#img-show-video-inf").css('display', 'none');
            $("#home-video").css('display', 'block');
            $('#home-video').trigger('play');
            $("#home-video").prop('muted', false);
            $("#video-grab").prop('muted', false);

        }
    </script>
{/literal}
