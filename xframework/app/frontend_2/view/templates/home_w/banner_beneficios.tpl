<div class="clearfix"></div>
<section class="hin-beneficios" id="beneficios">

    <div class="caracteristicas">
        <div class="caracteristicas__section">
            <div>
                <div>
                    <img src=" {$url}xframework/app/themes/dp02/img/home_w_v1.svg" ></img>
                </div>
                <h3>{"Simplicité"|x_translate}</h3>
            </div>
            <p>{"Aucune connaissance technique n'est nécessaire l'utilisation de WorknCare. Aucun impact RGPD, pas besoin de charger les emails des salariés."|x_translate}
            </p>
        </div>
        <div class="caracteristicas__section">
            <div>
                <div>
                    <img src=" {$url}xframework/app/themes/dp02/img/home_w_v2.svg" ></img>
                </div>
                <h3>{"Automatisation"|x_translate}</h3>
            </div>
            <p>
                {"Profitez de nos outils pour gagner du temps (questionnaires, capsules d’information, Pass Prévention & QVT, rapports...)"|x_translate}
            </p>
        </div>
        <div class="caracteristicas__section">
            <div>
                <div>
                    <img src=" {$url}xframework/app/themes/dp02/img/home_w_v3.svg" ></img>
                </div>
                <h3>{"Aide à la Conformité"|x_translate}</h3>
            </div>
            <p>
                {"Générez puis actualisez votre DUERP afin d’assurer votre conformité avec les obligations de santé au travail."|x_translate}
            </p>
        </div>
    </div>

    <h2 class="caracteristicas__subtitle">{"Centralisez la gestion de vos actions Prévention & QVT"|x_translate}</h2>

    <div class="carousel-beneficios">
        <div class="carousel-beneficios-child">
            <div class="carousel-beneficios-child-header">
                <img src="xframework/app/themes/dp02/img/carousel-1.png"></img>
                <h3>{"Créer un questionnaire"|x_translate}</h3>
            </div>
            <div class="carousel-beneficios-child-header">
                <img src="xframework/app/themes/dp02/img/carousel-2.png"></img>
                <h3>{"Créer une capsule"|x_translate}</h3>
            </div>
            <div class="carousel-beneficios-child-header">
                <img src="xframework/app/themes/dp02/img/carousel-3.png"></img>
                <h3>{"Créer un Pass"|x_translate}</h3>
            </div>


            <div class="carousel-beneficios-child-bar active"></div>
            <div class="carousel-beneficios-child-bar"></div>
            <div class="carousel-beneficios-child-bar"></div>


            <div class="carousel-beneficios-child-container">
                <div class="carousel-beneficios-child-container-title">{"Générez vos questionnaires sans devoir charger d'emails."|x_translate}</div>
                <div class="carousel-beneficios-child-container-subtitle">{"Utilisez nos modêles ou créez directement vos questionnaires. Ajoutez des prestations faire gagner aux participants. Gestion et rapports automatisés."|x_translate}
                </div>
            </div>
            {* <img src="xframework/app/themes/dp02/img/arrow_down.svg"></img> *}
        </div>

    </div>
    <div class="carousel-beneficios-image">
        <img src="xframework/app/themes/dp02/img/carousel-img-1.png"></img>
    </div>  
</section>


{literal}

    <script type="text/javascript">
        $(document).ready(function () {


            //set the interval for the carousel

            function item1() {
                $(".carousel-beneficios-child-bar.active").removeClass("active");
                $(".carousel-beneficios-child-bar").first().addClass("active");
                $(".carousel-beneficios-child-container").removeClass("two-column");
                $(".carousel-beneficios-child-container").removeClass("three-column");
                $(".carousel-beneficios-child-container").addClass("one-column");
                $(".carousel-beneficios-child-container-title").text(x_translate("Générez vos questionnaires sans devoir charger d'emails."));
                $(".carousel-beneficios-child-container-subtitle").text(x_translate("Utilisez nos modêles ou créez directement vos questionnaires. Ajoutez des prestations faire gagner aux participants. Gestion et rapports automatisés."));
                $(".carousel-beneficios-image img").attr("src", "xframework/app/themes/dp02/img/carousel-img-1.png");
            }
            function item2() {
                $(".carousel-beneficios-child-bar.active").removeClass("active");
                $(".carousel-beneficios-child-bar").first().next().addClass("active");
                $(".carousel-beneficios-child-container").removeClass("one-column");
                $(".carousel-beneficios-child-container").removeClass("three-column");
                $(".carousel-beneficios-child-container").addClass("two-column");
                $(".carousel-beneficios-child-container-title").text(x_translate("Créez des capsules vidéos pour vos salariés."));
                $(".carousel-beneficios-child-container-subtitle").text(x_translate("Créez des capsules vidéos pour vos salariés. Ajoutez des prestations faire gagner aux participants. Gestion et rapports automatisés."));
                $(".carousel-beneficios-image img").attr("src", "xframework/app/themes/dp02/img/carousel-img-2.png");
            }
            function item3() {
                $(".carousel-beneficios-child-bar.active").removeClass("active");
                $(".carousel-beneficios-child-bar").last().addClass("active");
                $(".carousel-beneficios-child-container").removeClass("one-column");
                $(".carousel-beneficios-child-container").removeClass("two-column");
                $(".carousel-beneficios-child-container").addClass("three-column");
                $(".carousel-beneficios-child-container-title").text(x_translate("Créez des Pass pour vos salariés."));
                $(".carousel-beneficios-child-container-subtitle").text(x_translate("Créez des Pass pour vos salariés. Ajoutez des prestations faire gagner aux participants. Gestion et rapports automatisés."));
                $(".carousel-beneficios-image img").attr("src", "xframework/app/themes/dp02/img/carousel-img-3.png");
            }

            $(".carousel-beneficios-child-header").first().click(function () {
                item1();
            });
            $(".carousel-beneficios-child-header").first().next().click(function () {
                item2();
            });
            $(".carousel-beneficios-child-header").last().click(function () {
                item3();
            });

            // var scroller = {};
            // scroller.e = document.getElementById("b");

            // if (scroller.e.addEventListener) {
            //     scroller.e.addEventListener("mousewheel", MouseWheelHandler, false);
            //     scroller.e.addEventListener("DOMMouseScroll", MouseWheelHandler, false);
            // } else scroller.e.attachEvent("onmousewheel", MouseWheelHandler);

            // function MouseWheelHandler(e) {

            //     // cross-browser wheel delta
            //     var e = window.event || e;
            //     var delta = - 20 * (Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail))));

            //     var pst = $('#b').scrollLeft() + delta;

            //     if (pst < 0) {
            //         pst = 0;
            //     } else if (pst > $('.img_holder').width()) {
            //         pst = $('.img_holder').width();
            //     }

            //     $('#b').scrollLeft(pst);

            //     return false;
            // }




        });
    </script>

{/literal}