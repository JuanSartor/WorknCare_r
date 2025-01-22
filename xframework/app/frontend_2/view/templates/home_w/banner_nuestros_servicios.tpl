<section class="hin-soluciones" id="soluciones">
    <h2 class="caracteristicas__subtitle">{"Bénéficiez d'une solution d'automatisation pour la Prévention & QVT, avec un accompagnement qualifié"|x_translate}</h2>
    <p>{"Vous n'êtes pas expert en questionnaires et outils de communication? Avec WorknCare, gagnez du temps sur vos actions."|x_translate}</p>
    <a style="font-size: 16px;" href="{$url}creer-compte.html?free=1"  class="btn">{"Je découvre"|x_translate}</a>    
    <img id="graph_workncare_horizontal" {if $TRADUCCION_IDIOMA=="fr"} src="{$url}xframework/app/themes/dp02/img/graph_workncare_horizontal_2.png" {else} src="{$url}xframework/app/themes/dp02/img/graph_workncare_horizontal_2_en.png" {/if} ></img>
    <img id="graph_workncare_vertical"  {if $TRADUCCION_IDIOMA=="fr"}  src="{$url}xframework/app/themes/dp02/img/graph_workncare_vertical_2.png" {else} src="{$url}xframework/app/themes/dp02/img/graph_workncare_vertical_2_en.png" {/if}></img>   
</section>


{literal}

    <script type="text/javascript">
        $(document).ready(function () {

            if ($(window).width() <= 800) {
                $('.carousel-servicios').slick({
                    infinite: true,
                    arrows: true,
                    dots: false,
                    draggable: true,
                    nextArrow: '.servicios.pcuh-pf-slide-control.right',
                    prevArrow: '.servicios.pcuh-pf-slide-control.left',
                    edgeFriction: 1,
                    slidesToScroll: 1,
                    touchThreshold: 5,
                    useCSS: false,
                    autoplay: true,
                    autoplaySpeed: 3000
                });
            }



        });


    </script>

{/literal}
