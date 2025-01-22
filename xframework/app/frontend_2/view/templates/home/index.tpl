<link href="{$url}xframework/app/themes/dp02/css/home_public.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<link href="{$url}xframework/app/themes/dp02/css/banner_pass_esante.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
{**{include file="home/login.tpl"}**}

<style>
    /*Fix video borderd*/
    #home-video{
        border-radius: 0 0 150% 150% / 0 0 90px 90px;
    }
    @media (max-width:600px){
        #home-video{
            border-radius: 0 0 190% 190% / 0 0 90px 90px;   
        }
    }
    .dim-video{
        width: 800px;
        border-radius: inherit !important;
    }
    .img-v {
        display: none;
        width: 300px;
    }
    .video-info {
        cursor: pointer;
    }

    .marg-tittle-vi{
        margin-top: 30px;  
        margin-bottom: 200px;
    }
    @media (max-width:600px){
        .video-info {
            width: 100%;
        }
        .container-desktop {
            display: none;
        }
        .img-v {
            display: block;
            width: 100%;
            margin-inline: auto;
            margin-top: 40px;
        }
        .marg-tittle-vi{
            margin-top: 0px;  
            margin-bottom: 120px;
        }

    }
</style>

{include file="home/login_azul.tpl"} 
<div   style="padding-top: 0px; " class="hin-beneficios marg-tittle-vi">
    <div style="padding-top: 0px;" class="hin-beneficios okm-container section-title-container">
        <h2 class="beneficios-title tittle-vid">
            {"Laissez vous guider par Bob"|x_translate}
        </h2>
    </div>
</div>
<img id="img-show-video-inf" class="img-v"  onclick="showHomeVideoInfE()" src="{$url}xframework/app/themes/dp02/videos/img-v-emple.png" alt={"WorknCare, la solution Prévention & QVT plug & play"|x_translate} />

<div style="text-align: center; margin-top: 40px;" id="container-desktop" class="container-desktop">
    <video  id="home-video" controls="true"  preload  muted="false" class="video-info dim-video">
        <source src="{$url}xframework/app/themes/dp02/videos/D-ID-Portada-empleados.mp4" type="video/mp4">
        <source src="{$url}xframework/app/themes/dp02/videos/D-ID-Portada-empleados.webm" type="video/webm">
    </video>  
</div>
{**<section class="top-section home-main-background">
<div class="banda-top">
<div class="texto-negrita">{"Eres un empleador?"|x_translate}</div>
<div class="texto-negrita-mobile">{"Eres un empleador?"|x_translate}</div>
<div class="texto-comun">{"Tu herramienta dedicada a la prevención y QVT te espera !"|x_translate}</div>
<div class="texto-comun-mobile">{"Herramienta de prevención y QVT!"|x_translate}</div>
<a href="https://www.offrepassbienetre.eu/" title='{"Descubrir"|x_translate}' target="_blank" class="btn-descubrir">{"Descubrir"|x_translate}</a>
</div> 
<div class=convex></div>
<video  id="home-video" playsinline preload autoplay muted loop style=" ">
<source src="{$url}xframework/app/themes/dp02/videos/video_home.mp4" type="video/mp4">
<source src="{$url}xframework/app/themes/dp02/videos/video_home.webm" type="video/webm">
</video>   
<div class="fluid-container ">
<nav class="hom-nav2">
<div id="hom-nav-menu" class="hom-nav-menu">
<div class="menu-group">
<a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="fa fa-bars"></i></a>
</div>
<ul id="hom-nav-rsp-get">
<li class="pass-bienetre empresa" ><a href="{$url}creer-compte.html?connecter"  title='{"Pase de Salud"|x_translate}'><strong>{"Pase de Salud"|x_translate}</strong></a></li>
<li class="pass-bienetre particular" ><a href="{$url}portailsalariés.html"  title='{"Pase de Salud particular"|x_translate}'><strong>{"Pase de Salud particular"|x_translate}</strong></a></li>
<li id="scroll-banner-pass-bienetre-li"><a class="scroll" data-lnk="scroll-banner-pass-bienetre" href="javascript:;" title='{"Nuestra oferta"|x_translate}' >{"Nuestra oferta"|x_translate}</a></li>
<li id="scroll-banner-pass-bienetre-mobile-li"><a class="scroll" data-lnk="scroll-banner-pass-bienetre-mobile" href="javascript:;" title='{"Nuestra oferta"|x_translate}' >{"Nuestra oferta"|x_translate}</a></li>
<li><a class="scroll" data-lnk="scroll-hom-contacto-container" href="javascript:;" title='{"Contacto"|x_translate}' >{"Contacto"|x_translate}</a></li>
</ul>
</div>
</nav>
<div class="home-doctorplus-logo logo-small">
<a href="{$url}"><img src="{$IMGS}logo_pass_bienetre_fit.png" title="Pass Bien-être"></a>
</div>
<div class="home-main">
<div class="home-doctorplus-logo">
<a href="{$url}"><img src="{$IMGS}logo_pass_bienetre_fit.png" title="Pass Bien-être"></a>
</div>

</div>
<div class="home-title">
<h1>{"La solución de bienestar para tu empresa"|x_translate}</h1>

</div>
<div class="button-container">
<a href="{$url}creer-un-compte.html" class="btn-signup" title='{"Crear una cuenta"|x_translate}' >{"Crear una cuenta"|x_translate}</a>
<a href="JavaScript:void(0)" id="loginbtn" class="btn-login" title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a>
</div>

</div>
</section> **}

<div class="hp-home-wrapper hom-DoctorPlus" style="top: 30px; position: relative;" id="hom-DoctorPlus">
    <!-- Banner beneficios container-->
    {include file="home/banner_beneficios.tpl"}
    <div class="clearfix"></div>
    <!-- Banner servicios container-->
    {include file="home/banner_nuestros_servicios.tpl"}

    <!-- Slider programas-->
    {include file="home/slider_programas.tpl"}
    <section class="hp-home home-francia" id="bien-etre-programmes">

        {include file="programa_salud/grid_programas.tpl"}

    </section>





    <!-- seccion baner presentacion pass bientre-->
    {** {include file="home/banner_pass_bienetre.tpl"} **}

</div>
<div class="clearfix">&nbsp;</div>
<!-- Contactenos container-->
{**<div id="hom-contacto-container">

</div> **}

<section style="display: none;"  class="hin-solucion-integral">
    {**<a href="{$url}medecin-ou-professionnel/">
    <div style="position: relative; top: 70px;" class="hin-solucion-integral-box">
    
    <h2>
    {"¿Eres practicante?"|x_translate}
    </h2>
    
    <span>{"Saber más"|x_translate}</span>
    
    </div>
    </a>**}
</section> 
{literal}
    <script>
        $(function () {
            $(document).ready(function () {
                $("#home-video").prop('muted', false);
                if ($(window).width() < 500) {
                    $("#scroll-banner-pass-bienetre-li").hide();
                    $("#scroll-banner-pass-bienetre-mobile-li").show();
                } else {
                    $("#scroll-banner-pass-bienetre-mobile-li").hide();
                    $("#scroll-banner-pass-bienetre-li").show();
                }



            });

            x_loadModule("home", "contactenos", "", "hom-contacto-container");
            $(':checkbox').radiocheck();
            $(':radio').radiocheck();
            function mulScroll(trgObj) {
                var trgObjHeight = trgObj.outerHeight();
                $('html, body').animate({
                    scrollTop: (trgObj.offset().top - trgObjHeight) - 60
                }, 1000);
            }

            $(".btnBuscarProfesionales").click(function (e) {
                e.preventDefault();
                if ($("#especialidad_ti").val() == "") {
                    x_alert(x_translate("Seleccione al menos una especialidad"));
                    return false;
                }
                if ($("#pais_idpais").val() == "") {
                    x_alert(x_translate("Seleccione al menos un país"));
                    return false;
                }

                console.log("buscar", $("#buscar_profesionales").serialize());
                window.location.href = BASE_PATH + "recherche-medecin/?" + $("#buscar_profesionales").serialize();
            });
            if ($('.js-rsp').length > 0) {
                enquire.register("screen and (max-width:1200px)", {

                    match: function () {
                        // medico home img swap
                        imgSrc = $('#hin-img-rsp-swap').data('altimg-1200');
                        $('#hin-img-rsp-swap').attr('src', imgSrc);
                    },
                    unmatch: function () {
                        // medico home img swap
                        imgSrc = $('#hin-img-rsp-swap').data('altimg-big');
                        $('#hin-img-rsp-swap').attr('src', imgSrc);
                    }
                });
            }
            //seleccionar tipo usuario
            $("#btnSelectUsuario").click(function () {
                if ($("#paciente").is(":checked")) {
                    window.location.href = BASE_PATH + "paciente/";
                }
                if ($("#profesional").is(":checked")) {
                    window.location.href = BASE_PATH + "profesional/";
                }
            });
            //mostrar modal de login
            $('#loginbtn,#loginbtn2, #loginbtn3').on('click', function (e) {
                e.preventDefault();
                $('.usrlogin').modal('toggle');
            });
            $('#hom-nav-rsp-trg').on('click', function (e) {

                $('#hom-nav-menu').toggleClass('menu-show');
            });
            $(document).on('click', function (event) {
                if ((!$(event.target).closest('#hom-nav-rsp-trg').length)) {
                    $('#hom-nav-rsp-get').removeClass('menu-show');
                }
            });
            $(window).on('scroll', function () {
                var currentTop = $(window).scrollTop();
                if (currentTop >= 60) {
                    $('.hom-nav').addClass('transparent');
                } else if (currentTop < 60) {
                    $('.hom-nav').removeClass('transparent');
                }

            });
            $("#comparativo h2").click(function () {
                $(this).siblings().slideToggle();
            });
            var menuEl = $('#hom-nav-rsp-get').children('li').children('a');
            menuEl.on('click', function (e) {


                if (typeof $(this).data('lnk') !== 'undefined') {
                    var lnkTo = "#" + $(this).data('lnk');
                    mulScroll($(lnkTo));
                }


                if ($('#hom-nav-rsp-get').hasClass('menu-show')) {
                    $('#hom-nav-rsp-get').removeClass('menu-show');
                }

            });
        });
        $(".scroll").click(function (e) {
            if ($(this).data('lnk') == 'scroll-banner-pass-bienetre') {
                scrollToEl($("#scroll-banner-pass-bienetre"));
            } else if ($(this).data('lnk') == 'scroll-banner-pass-bienetre-mobile') {
                scrollToEl($("#scroll-banner-pass-bienetre-mobile"));
            } else {
                scrollToEl($("#scroll-hom-contacto-container"));
            }
        });


        function showHomeVideoInfE() {
            $("#container-desktop").css('display', 'block');
            $("#img-show-video-inf").css('display', 'none');
            $('#home-video').trigger('play');
            $("#home-video").prop('muted', false);

        }

    </script>
{/literal}

{if $timeout_modal=="1"}
    {literal}
        <script>
            $(function () {

                $('#timeout-trigger').click();
                $('#modal_login').on('hidden.bs.modal', function () {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "clear_user.do",
                            '',
                            function () {});
                });
            });
        </script>
    {/literal}
{/if}