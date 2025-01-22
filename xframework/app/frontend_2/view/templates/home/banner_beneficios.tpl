<div class="clearfix"></div>
<section class="hin-beneficios" id="beneficios">
    <div class="okm-container section-title-container">
        <h2 class="beneficios-title">
            {"¿Por qué usar DoctorPlus?"|x_translate}
        </h2>
    </div>

    <div class="hin-beneficios-box">
        <div class="hin-beneficios-content">
            <div class="container hin-beneficios-list">
                <a href="javascript:;" class="beneficios pcuh-pf-slide-control left"><i class="icon-doctorplus-left-arrow"></i></a>

                <div class="okm-row carousel-beneficios">

                    <div class="hin-beneficios-col anim-beneficios">
                        <div class="hin-beneficios-icon">
                            <img src="{$IMGS}home2/beneficios-icon1.png"  title='{"Marco legal y seguro"|x_translate}'/>
                        </div>
                        <h4>{"Marco legal y seguro"|x_translate}</h4>
                        <p>
                            {"Consultas e info de salud bajo estrictas normas de confidencialidad y protección de datos."|x_translate}
                        </p>
                    </div>

                    <div class="hin-beneficios-col anim-beneficios">
                        <div class="hin-beneficios-icon">
                            <img src="{$IMGS}home2/beneficios-icon2.png"  title='{"Atención calificada"|x_translate}'/>
                        </div>
                        <h4>{"Atención calificada"|x_translate}</h4>
                        <p>
                            {"Se evita la búsqueda de consejos por internet o robots de respuestas automáticas para solucionar cuestiones de salud."|x_translate}
                        </p>
                    </div>

                    <div class="hin-beneficios-col anim-beneficios">
                        <div class="hin-beneficios-icon">
                            <img src="{$IMGS}home2/beneficios-icon3.png"  title='{"Abonas solo cuando consultas"|x_translate}'/>
                        </div>
                        <h4>{"Abonas solo cuando consultas"|x_translate}</h4>
                        <p>
                            {"Una cuenta de uso gratuito y sin costos fijos. Abonas solo cuando consultas. Cada profesional publica su tarifa."|x_translate}
                        </p>
                    </div>

                    <div class="hin-beneficios-col anim-beneficios">
                        <div class="hin-beneficios-icon">
                            <img src="{$IMGS}home2/beneficios-icon4.png"  title='{"Prevención"|x_translate}'/>
                        </div>
                        <h4>{"Prevención"|x_translate}</h4>
                        <p>
                            {"La salud es algo que no puede esperar. No más horas de espera en una guardia ni turnos con alta demora de atención."|x_translate}
                        </p>
                    </div>

                </div>
                <a href="javascript:;" class="beneficios pcuh-pf-slide-control right"><i class="icon-doctorplus-right-arrow"></i></a>

            </div>
        </div>
    </div>

</section>


{literal}

    <script type="text/javascript">
        $(document).ready(function () {

            if ($(window).width() <= 850) {
                $('.carousel-beneficios').slick({
                    infinite: true,
                    arrows: true,
                    dots: false,
                    draggable: true,
                    nextArrow: '.beneficios.pcuh-pf-slide-control.right',
                    prevArrow: '.beneficios.pcuh-pf-slide-control.left',
                    edgeFriction: 1,
                    slidesToScroll: 1,
                    touchThreshold: 5,
                    useCSS: false,
                    autoplay: true,
                    autoplaySpeed: 4500
                });
            }



        });


    </script>

{/literal}
