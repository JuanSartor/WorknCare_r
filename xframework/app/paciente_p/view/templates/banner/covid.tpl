<style>
    .covid-container{
        position: fixed;
        top: 60px;
        color: #fff;
        width: 100%;
        z-index: 2000;
    }
    .covid_alert{
        padding: 10px 30px 10px 10px;
        position:relative;
        min-height: 60px;

    }
    .covid_alert.lux{

        background-color: #323e70;

    }
    .covid_alert.france{

        background-color: #657db0;



    }
    .covid_alert_close {
        right: 15px;
        top: 5px;
        position: absolute;
        cursor:pointer;
    }
    .covid_alert p {
        margin: 0;
        text-align: justify;
        font-size: 16px;
        line-height: 1.2
    }
    .covid_flag{

        cursor: pointer;
        shape-image-threshold: 0.5;
        shape-margin: 20px;
        float: left;
        margin-right: 10px;
        width: 50px;
        height: 25px;
    }

    @media (max-width: 600px) {
        .covid_alert p {
            font-size: 12px;
        }
        .covid_flag{
            margin-top: 5px;
            width: 30px;
            height: 15px;
        }

        .covid_alert_close {
            right: 10px;
            top: 5px;
            position: absolute;
            cursor: pointer;
            font-size: 14px;
        }
    }
</style>
<div class="covid-container">
    {if $paciente.pais_idpais==1}
        <div class="covid_alert hidden france" >
            <div class="covid_alert_close">X</div>
            <img class="covid_flag" src="{$IMGS}home/france-flag.png" title="France">
            <div class="covid_alert_content">
                <p>  
                    <strong>{"Alerte Coronavirus France!"|x_translate}</strong>
                    {"En cas de symptômes suspects, votre téléconsultation est  actuellement remboursée par la CPAM (sécurité sociale France) pour tous les médecins généralistes sur DoctorPlus!"|x_translate}
                </p>
            </div>
        </div>
    {/if}
    {if $paciente.pais_idpais==2 || $paciente.pais_idpais_trabajo==2}
        <div class="covid_alert hidden lux" >
            <div class="covid_alert_close">X</div>
            <img  class="covid_flag" src="{$IMGS}home/lux-flag.png" title="Lux">

            <div class="covid_alert_content">
                <p>  
                    <strong>{"Alerte Coronavirus Luxembourg!"|x_translate}</strong>
                    {"En cas de symptômes suspects, votre téléconsultation est actuellement remboursée par la CNS (sécurité sociale Luxembourg) pour tous les médecins généralistes sur DoctorPlus!"|x_translate}
                </p>
            </div>
        </div>
    {/if}
</div>

<script>
    $(function () {

        var datalux = sessionStorage.getItem('covid_alert_close_lux');
        if (datalux != "true") {
            $(".covid_alert.lux").removeClass("hidden");
        }
        $(".covid_alert.lux .covid_alert_close").click(function () {
            sessionStorage.setItem('covid_alert_close_lux', true);
            $(".covid_alert.lux").remove();
        });

        var datafrance = sessionStorage.getItem('covid_alert_close_france');
        if (datafrance != "true") {
            $(".covid_alert.france").removeClass("hidden");
        }
        $(".covid_alert.france .covid_alert_close").click(function () {
            sessionStorage.setItem('covid_alert_close_france', true);
            $(".covid_alert.france").remove();
        });
    })
</script>
