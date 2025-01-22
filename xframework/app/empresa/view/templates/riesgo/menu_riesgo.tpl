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
    {include file="riesgo/slider_modelos.tpl"}
    <div class="okm-row" style="text-align: center;">
        <span style="font-size: 20px; font-weight: 600;">{"Comenzar Nuevo"|x_translate}</span>
    </div>
    <div class="okm-row card-wrapper" style="margin-top: 40px;">

        <div class="card-container col-md-6 col-sm-12">
            <div class="card  card-white  row">
                <div class="okm-row">
                    <h4 class="title text-center">{"Crear un DUERP"|x_translate}</h4>
                </div>
                <div class="okm-row" style="text-align: center;">
                    <span>{"RPS - QVT"|x_translate}</span>
                </div>
                <div class="okm-row text-center">
                    <a id="btnGestionarBeneficiarios" href="{$url}entreprises/questionnaireslist/personalizar/0.html" class="btn btn-default">{"Comenzar"|x_translate}</a>
                </div>
            </div>
        </div>

    </div>
    <div style="width: 100%;  text-align: center; margin-top: 100px;">
        <p>
            {"Note : le DUERP doit être mis à jour à chaque changement, en cas de nouvelles informations et au minimum tous les ans"|x_translate}
        </p>
    </div>
</section>   