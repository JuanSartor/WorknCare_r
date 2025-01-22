<section  class="banner-pass-bienetre" >
    <div class="details-bg"></div>
    <div class="details">
        <h3 class="caracteristicas__subtitle">{"Votre outil dès 39 € par mois"|x_translate}</h3>
        <h4>{"Sans frais cachés."|x_translate}</h4>
        <div class="card-container">
            <div class="card">
                <div class="card__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4 >{"Découverte"|x_translate}</h4>
                </div>
                <div class="card__body">
                    <span>{"Pour découvrir ou utiliser ponctuellement"|x_translate}</span>                
                    <h4>{"Aucun frais"|x_translate}</h4>
                    <p>{"Inclus dans l'offre"|x_translate} :</p>
                    <p>{"Votre 1er DUERP gratuit et 6 utilisations pour"|x_translate} :</p>
                    <p>- {"Questionnaires"|x_translate}</p>
                    <p>- {"Capsules Information"|x_translate}</p>
                    <a style="font-size: 17px;" href="{$url}creer-compte.html?free=1">{"Je découvre"|x_translate}</a>
                </div>
            </div>   
            <div class="card" id="banner-pass-bienetreid">
                <div class="card__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"Regular"|x_translate}</h4>
                </div>
                <div class="card__body">
                    <span>{"Pour une utilisation régulière"|x_translate}</span>                
                    <h4>{"39€ HT d’abonnement"|x_translate}</h4>
                    <p>{"Inclus dans l'offre"|x_translate} :</p>
                    <p>{"L’accès à toutes nos fonctionnalités en illimité"|x_translate} :</p>
                    <p>- {"DUERP"|x_translate}</p>
                    <p>- {"Questionnaires"|x_translate}</p>
                    <p>- {"Capsules d’information"|x_translate}</p>
                    {** <a>{"Je découvre"|x_translate}</a> **}
                </div>
            </div>  
            <div class="card">
                <div class="card__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"Booster"|x_translate}</h4>
                    <div class="card_hover_booster">
                        <img class="card__img-cross-booster" src="{$url}xframework/app/themes/dp02/img/cross_booster.svg" alt="star">
                        <div class="card__popup-booster">
                            <h5>{"Budget prestations"|x_translate}</h5>
                            <span style="color: #727272;">{"Vous choisissez votre budget pour financer les prestations de votre choix Les budgets non utiIisés sont remboursés"|x_translate}</span>
                        </div>
                        </img>
                    </div>
                </div>
                <div class="card__body">
                    <span>{"Pour cibler en plus des actions Prévention & QVT"|x_translate}</span>
                    <h4>{"39€ HT d’abonnement + 2€ HT par salarié inscrit"|x_translate}</h4>
                    <p>{"L'offre Regular, avec en plus"|x_translate} :</p>
                    <p>- {"Gestion du Pass"|x_translate}</p>
                    <p>- {"Ajout de vos Professionnels"|x_translate}</p>
                    <p>et {"prestataires aux Pass."|x_translate}</p>
                    {**    <a>{"Je découvre"|x_translate}</a> **}
                </div>
            </div>  
        </div>
    </div> 
    <div class="plan">
        <h3>{"Gardez le contrôle sur votre budget, avec une facturation transparente"|x_translate}</h3>
        <div class="plan-grid">
            <div class="card-small">
                <div class="card-small__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"RGDP friendly"|x_translate}</h4>
                </div>
                <div class="card-small__body">
                    <p>{"Pas d'impact RGPD. Pas besoin de charger les emails de salariés."|x_translate}</p>
                </div>
            </div>
            <div class="card-small">
                <div class="card-small__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"Pas de frais cachés"|x_translate}</h4>
                </div>
                <div class="card-small__body">
                    <p>{"Le même tarif chaque mois. Pas de coût caché. Votre facture est transparente."|x_translate}</p>
                </div>
            </div>
            <div class="card-small">
                <div class="card-small__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"Offres flexibles"|x_translate}</h4>
                </div>
                <div class="card-small__body">
                    <p>{"Vous travaillez sans budget sur notre offre Regular. Vous passez sur Booster pour cibler une action Prévention & QVT. Sans frais de dossier."|x_translate}</p>
                </div>
            </div>
            <div class="card-small">
                <div class="card-small__header">
                    <img src="{$url}xframework/app/themes/dp02/img/star_plan.svg" alt="star"></img>
                    <h4>{"Plug & Play"|x_translate}</h4>
                </div>
                <div class="card-small__body">
                    <p>{"Pas de déploiement à réaliser. Vous utilisez la solution directement."|x_translate}</p>
                </div>
            </div>
        </div>
    </div>
</section>

{literal}

    <script type="text/javascript">
        $(document).ready(function () {
            let space = ($(document).width() - ($('.card')[0]).offsetWidth * 3) / 4;
            // $('.carousel').each(function (i, e) {

            //     let speed = $(e).data("speed");
            //     console.log(speed);
            //     $(e).slick({
            //         infinite: true,
            //         arrows: true,
            //         dots: false,
            //         draggable: true,
            //         nextArrow: '.pcuh-pf-slide-control.right',
            //         prevArrow: '.pcuh-pf-slide-control.left',
            //         edgeFriction: 1,
            //         slidesToScroll: 1,
            //         touchThreshold: 5,
            //         useCSS: false,
            //         autoplay: true,
            //         autoplaySpeed: speed
            //     });
            // });

            // if($(document).width()>1000){
            //     $('.card').each(function (i, e) {                
            //         e.style.left = (space + i * ($('.card')[0]).offsetWidth + space*i)  + 'px';
            //     });
            // }
            // addEventListener("resize", (event) => {
            //     if($(document).width()>1000){
            //         space = ($(document).width() - ($('.card')[0]).offsetWidth *3)/4;
            //         $('.card').each(function (i, e) {                
            //             e.style.left = (space + i * ($('.card')[0]).offsetWidth + space*i)  + 'px';
            //         });
            //     }
            // });
        });



    </script>

{/literal}