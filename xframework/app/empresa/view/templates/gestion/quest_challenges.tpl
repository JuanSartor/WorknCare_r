<style>
    .recuadro-borde{
        border: solid;
        height: 308px;
        width: 580px;
        border-color: #9dcbf3;
        position: absolute;
        bottom: -20px;
        left: 589px;
    }
    @media (max-width: 700px){
        .recuadro-borde{  
            height: 320px;
            width: 370px;
            bottom: 5px;
            left: 3px;
        }
    }
</style>

<section class="okm-container cards-home" id="cards-home">
    {include file="gestion/slider_modelos_cuestionarios.tpl"}
    <div class="okm-row" style="text-align: center;">
        <span style="font-size: 20px; font-weight: 600;">{"Comenzar Nuevo"|x_translate}</span>
    </div>
    <div class="okm-row card-wrapper" style="margin-top: 40px;">

        <div class="card-container col-md-6 col-sm-12">
            <div class="card  card-white  row">
                <div class="okm-row">
                    <h4 class="title text-center">{"Encuesta - Barometro"|x_translate}</h4>
                </div>
                <div class="okm-row" style="text-align: center;">
                    <span>{"RPS - QVT"|x_translate}</span>
                </div>
                <div class="okm-row text-center">
                    <a id="btnGestionarBeneficiarios" href="{$url}entreprises/questionnaireslist/personalizar/0.html" class="btn btn-default">{"Comenzar"|x_translate}</a>
                </div>
            </div>
        </div>


        <div class="card-container col-md-6 col-sm-12" >
            <div class="card card-white row">
                <div class="okm-row">
                    <h4 class="title text-center title-cuestionario">{"Challenges"|x_translate}</h4>
                </div>
                <div class="okm-row" style="text-align: center;">
                    <span>{"Lograr un objetivo"|x_translate}</span>
                </div>

                <div class="okm-row text-center">
                    <a id="btnFacturacion" href="{$url}entreprises/factures.html" class="btn btn-default btn-cuestionario disabled">{"Comenzar"|x_translate}</a>
                </div>
            </div>
        </div>


    </div>
    <div class="recuadro-borde"></div>  
</section>   