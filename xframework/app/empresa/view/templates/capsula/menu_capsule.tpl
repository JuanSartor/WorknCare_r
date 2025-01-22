<style>
    .titulo-funcionalidades{
        color: #000000 !important;
        font-size: 18px;
    }
    .envoltorio-circular{
        background: #3DB4C0;
        border-radius: 50%;
        width: 35px;
        height: 35px;
        cursor: pointer;
    }
    .ubi-env-file{
        position: relative;
        top: 25px;
        left: 160px;
        text-align: center;
        line-height: 1.5;
        color: white;
    }
    .ubi-env-link{
        position: relative;
        top: 29px;
        left: 160px;
        text-align: center;
        line-height: 1.5;
        color: white;
    }
    .ubi-env-video{
        position: relative;
        top: 35px;
        left: 160px;
        text-align: center;
        line-height: 1.5;
        color: white;
    }
    .ubi-env-ondemanda{
        position: relative;
        top: 31px;
        left: 160px;
        text-align: center;
        line-height: 1.5;
        color: white;
    }
    .tam-card{
        height: 200px;
    }
    .tam-img-file{
        width: 55px;
        position: relative;
        top: 25px;
    }
    .tam-img-link{
        width: 65px;
        position: relative;
        top: 25px;
    }
    .tam-img-video{
        width: 70px;
        position: relative;
        top: 30px;
    }
    .tam-img-ondemand-video{
        width: 70px;
        position: relative;
        top: 30px;
    }

</style>

<section class="okm-container cards-home" id="cards-home">
    {include file="capsula/slider_modelos_capsulas.tpl"}
    <div class="okm-row" style="text-align: center;">
        <span style="font-size: 20px; font-weight: 600;">{"Empezar sin plantilla"|x_translate}</span>
    </div>
    <div class="okm-row card-wrapper" style="margin-top: 40px;">

        <div class="card-container col-md-3 col-sm-12" >
            <div class="okm-row">
                <h4 class="title text-center titulo-funcionalidades">{"Añadir archivo"|x_translate}</h4>
            </div>
            <div class="card card-white row tam-card">
                <a  href="{$url}entreprises/ajouter.html?banderaCapsula=1" style="cursor: pointer;">

                    <div class="okm-row" style="text-align: center;">
                        <img class="tam-img-file"  src="{$IMGS}icons/Icon-awesome-file-upload.png" />   
                    </div>
                    <div hr class="envoltorio-circular ubi-env-file">
                        <i class="fa fa-plus"></i>
                    </div>
                </a>

            </div>
        </div>

        <div class="card-container col-md-3 col-sm-12" >
            <div class="okm-row">
                <h4 class="title text-center titulo-funcionalidades">{"Añadir enlace"|x_translate}</h4>
            </div>
            <div class="card card-white row tam-card">    
                <a href="{$url}entreprises/ajouter.html?banderaCapsula=2" style="cursor: pointer;">
                    <div class="okm-row" style="text-align: center;">
                        <img class="tam-img-link"  src="{$IMGS}icons/Icon-awesome-link.png" />   
                    </div>
                    <div class="envoltorio-circular ubi-env-link">
                        <i class="fa fa-plus"></i>
                    </div>
                </a>

            </div>
        </div>
        <div class="card-container col-md-3 col-sm-12" >
            <div class="okm-row">
                <h4 class="title text-center titulo-funcionalidades">{"Añadir video"|x_translate}</h4>
            </div>
            <div class="card card-white row tam-card">     
                <a href="{$url}entreprises/ajouter.html?banderaCapsula=3" style="cursor: pointer;">
                    <div class="okm-row" style="text-align: center;">
                        <img class="tam-img-video" src="{$IMGS}icons/Icon-awesome-video.png" />   
                    </div>
                    <div class="envoltorio-circular ubi-env-video">
                        <i class="fa fa-plus"></i>
                    </div>
                </a>

            </div>
        </div>
        <div class="card-container col-md-3 col-sm-12" >
            <div class="okm-row">
                <h4 class="title text-center titulo-funcionalidades">{"Grabar video"|x_translate}</h4>
            </div>
            <div class="card card-white row tam-card"> 
                <a href="{$url}entreprises/ajouter.html?banderaCapsula=4" style="cursor: pointer;">
                    <div class="okm-row" style="text-align: center;">
                        <img class="tam-img-ondemand-video"  src="{$IMGS}icons/Icon-material-ondemand-video.png" />   
                    </div>
                    <div class="envoltorio-circular ubi-env-ondemanda">
                        <i class="fa fa-plus"></i>
                    </div>
                </a>
            </div>
        </div>


    </div>

</section>  

{literal}
    <script>
        $(function () {


        });
    </script>
{/literal}