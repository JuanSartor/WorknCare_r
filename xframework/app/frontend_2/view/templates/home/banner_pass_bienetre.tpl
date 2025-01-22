<section  class="banner-pass-bienetre">
    <div class="okm-container"  > 
        <div class='wrapper'>
            <div class="content-pass-bienetre" >
                <div class="container-logo mobile-hide">
                    <img id="scroll-banner-pass-bienetre" style="    height: 40px; margin-bottom: 80px; top: 20px; position: relative;" class="logo-pass-bien-etre-nuevo" src="{$IMGS}logo_workncare_color.png" title="WorknCare" alt="WorknCare"/>
                </div>
                <div class="container-texto mobile-hide" >
                    <h2>{"2 opciones para tus colaboradores"|x_translate}</h2>
                </div>
                <div class="button-container" >
                    <a href="{$url}creer-compte.html" title='{"Adherir"|x_translate}' class="btn btn-adquirir">{"Adherir"|x_translate}</a>
                    <a href="{$url}creer-compte.html?connecter" title='{"Iniciar sesión"|x_translate}' class="btn btn-extra">{"Iniciar sesión"|x_translate}</a>
                </div>
                <div class="button-container" >
                    <a href="https://www.offrepassbienetre.eu/" target="_blank" title='{"Pase de Salud"|x_translate}' class="btn btn-saber-mas">{"Saber más"|x_translate}</a>
                </div>
            </div>
            <div class="carousel-wrapper">
                <div class="content-pass-bienetre mobile-show" >
                    <div class="container-logo  mobile-show">
                        <img id="scroll-banner-pass-bienetre-mobile" class="logo-pass-bien-etre-nuevo" src="{$IMGS}logo_pass_bienetre_fit.png" title="WorknCare" alt="WorknCare"/>
                    </div>
                    <div class="container-texto  mobile-show" >
                        <h2>{"2 opciones para tus colaboradores"|x_translate}</h2>
                    </div>
                </div>
                {**    <div class="carousel-container">
                <a href="javascript:;" class="pcuh-pf-slide-control left"><i class="icon-doctorplus-left-arrow"></i></a>

                <div class="carousel"  data-speed="4000" >
                <div class="carousel-item img-mujer" >

                </div>
                <div class="carousel-item img-mujer" >
                <div class="content-2">
                <p class="texto-p">{"Pago mensual por beneficiario inscripto"|x_translate}</p>
                <p class="texto-p"><strong>{"Contrato de adhesion por 12 meses"|x_translate}</strong></p>
                </div>
                </div>
                </div>
                <div class="carousel-footer footer-1">
                <a href="{$url}creer-compte.html"><h6>{"Adhesión gratuita"|x_translate}</h6>
                </a> 
                </div>
                <a href="javascript:;" class="pcuh-pf-slide-control right"><i class="icon-doctorplus-right-arrow"></i></a>

                </div> **}
                <div class="carousel-container">
                    <a href="javascript:;" class="pcuh-pf-slide-control left"><i class="icon-doctorplus-left-arrow"></i></a>

                    <div class="carousel" data-speed="4500" >
                        <div class="carousel-item img-hombre" >

                        </div>
                        <div class="carousel-item img-hombre" >
                            <div class="content-2">
                                <p class="texto-p">{"Ocasionalmente compras pases"|x_translate}</p>
                                <p class="texto-p"><strong>{"Sin compromiso"|x_translate}</strong></p>
                            </div>
                        </div>
                    </div>
                    <a href="javascript:;" class="pcuh-pf-slide-control right"><i class="icon-doctorplus-right-arrow"></i></a>

                    <div class="carousel-footer footer-2" >
                        <a href="{$url}creer-compte.html?achatdepack=1">
                            <h6>{"Compra de packs"|x_translate}</h6>
                        </a>
                    </div>

                </div>
            </div>

        </div>
        <div class="clearfix">&nbsp;</div>
</section>

{literal}

    <script type="text/javascript">
        $(document).ready(function () {
            $('.carousel').each(function (i, e) {

                let speed = $(e).data("speed");
                console.log(speed);
                $(e).slick({
                    infinite: true,
                    arrows: true,
                    dots: false,
                    draggable: true,
                    nextArrow: '.pcuh-pf-slide-control.right',
                    prevArrow: '.pcuh-pf-slide-control.left',
                    edgeFriction: 1,
                    slidesToScroll: 1,
                    touchThreshold: 5,
                    useCSS: false,
                    autoplay: true,
                    autoplaySpeed: speed
                });
            });
        });

    </script>

{/literal}