<link href="{$url}xframework/app/themes/dp02/css/home_public_w.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<link href="{$url}xframework/app/themes/dp02/css/banner_pass_esante.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<input type="hidden" id="idconectar" value="{$conectarr}" />

{include file="programa_salud_registro/login.tpl"}

<section class="top-section home-main-background">

    <div class="fluid-container ">
        {* menu *}
        <div class="bg-hom-nav2"></div>

        <nav class="hom-nav2">
            <div class="nav-logo-img">
                <img src="{$url}xframework/app/themes/dp02/img/logo_workncare.svg"></img>                                                                        
            </div>
            <div id="hom-nav-menu" class="hom-nav-menu">
                <div class="menu-group">
                    <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="fa fa-bars"></i></a>
                </div>
                <ul id="hom-nav-rsp-get">          
                    <li class=" " ><a style="cursor:pointer;" class="scroll"  title='{"Pourquoi WorknCare"|x_translate}'>{"Pourquoi WorknCare"|x_translate}</a></li>
                    <li id="open-modal-nos-offres" ><a style="cursor:pointer;" title='{"Notre solution"|x_translate}'>{"Notre solution"|x_translate}</a></li>
                    <li ><a class="scroll" data-lnk="banner-pass-bienetreid" href="javascript:;" title='{"Nos offres"|x_translate}' >{"Nos offres"|x_translate}</a></li>
                    <li><a class="btnSalaries"   href="{$url}portailsalaries" target="_blank" title='{"Accès salariés"|x_translate}' >{"Accès salariés"|x_translate}</a></li>
                    <li><a class="se-conecter" style="cursor: pointer;"  id="loginbtnEmpresa" title='{"Se connecter"|x_translate}' >{"Se connecter"|x_translate}</a></li>
                </ul>
            </div>
            <div class="ubi-sel-idioma selec-idioma" > {include file="home_w/select_idioma.tpl"}</div>
        </nav>

        {**   href="{$url}pass-bienetre/adhesion.html?connecter"
        href="{$url}pass-bienetre/particulier.html" **}
        <div class="home-main">

            {* modal *}
            <div id="modal-nos-offres" class="modal fade bs-example-modal-lg nos-offres-modal vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>                        
                            <h4 class="modal-title">{"LES FONCTIONNALITES"|x_translate}</h4>
                        </div>
                        <div class="modal-body">
                            <div class="modal-item">
                                <div class="item-img">                                
                                    <img src="{$url}xframework/app/themes/dp02/img/check.svg" alt="{"Accès à des professionnels de santé"|x_translate}"></img>                                                                        
                                </div>
                                <div>
                                    <h5>{"Génération de DUERP"|x_translate}</h5>
                                    <h6>{"Assurez votre conformité en quelques clics."|x_translate}</h6>
                                </div>
                            </div>
                            <div class="modal-item">
                                <div class="item-img">                                
                                    <img src="{$url}xframework/app/themes/dp02/img/check.svg" alt="{"Accès à des professionnels de santé"|x_translate}"></img>                                                                        
                                </div>
                                <div>
                                    <h5>{"Questionnaires Prévention & QVT spécialisés"|x_translate}</h5>
                                    <h6>{"Documentez facilement vos évaluations"|x_translate}</h6>
                                </div>
                            </div>
                            <div class="modal-item">
                                <div class="item-img">                                
                                    <img src="{$url}xframework/app/themes/dp02/img/check.svg" alt="{"Accès à des professionnels de santé"|x_translate}"></img>                                                                        
                                </div>
                                <div>
                                    <h5>{"Capsules d’information terrain"|x_translate}</h5>
                                    <h6>{"Générez contenus et flyers pour votre communication"|x_translate}</h6>
                                </div>
                            </div>
                            <div class="modal-item">
                                <div class="item-img">                                
                                    <img src="{$url}xframework/app/themes/dp02/img/check.svg" alt="{"Accès à des professionnels de santé"|x_translate}"></img>                                                                        
                                </div>
                                <div>
                                    <h5>{"Ciblez une action via un Pass"|x_translate}</h5>
                                    <h6>{"Créez un Pass que les employés utilisent en privé"|x_translate}</h6>
                                </div>
                            </div>
                            <div class="modal-item">
                                <div class="item-img">                                
                                    <img src="{$url}xframework/app/themes/dp02/img/check.svg" alt="{"Accès à des professionnels de santé"|x_translate}"></img>                                                                        
                                </div>
                                <div>
                                    <h5>{"Intégration Prestataires"|x_translate}</h5>
                                    <h6>{"Ajoutez au Pass vos prestataires pour gagner du temps"|x_translate}</h6>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            {* modal *}

        </div>
        <div class="container-home-title">
            <div class="home-title">
                <div>
                    <h1>{"WorknCare"|x_translate}</h1>
                    <h2>{"la solution Prévention & QVT plug & play"|x_translate}</h2>
                    <h3>{"Choisissez la solution simple et automatisée qui vous aide sur l’évaluation, l’information et le ciblage d’actions en Prévention & QVT"|x_translate}</h3>
                    <div>
                        <a href="{$url}creer-compte.html?free=1" class="btn-signup" title='{"Ouvrir un compte gratuit"|x_translate}' >{"Ouvrir un compte gratuit"|x_translate}</a>
                        {**<a href="{$url}pass-bienetre/particulier.html" class="btn-login" title='{"Demander une démo"|x_translate}'>{"Demander une démo"|x_translate}</a>
                        **}
                    </div>
                </div>
                <img id="img-show-video" onclick="showHomeVideo()" src="{$url}xframework/app/themes/dp02/img/home_temporary_3.svg" alt={"WorknCare, la solution Prévention & QVT plug & play"|x_translate} />
            </div>
            <div class="popup-iframe-video" id="popup-iframe-video">
                <iframe width="100%" height="100%"  {if $TRADUCCION_IDIOMA=="fr"} src="{$url}xframework/app/themes/dp02/videos/workncare_home_video.mp4" {else}src="{$url}xframework/app/themes/dp02/videos/workncare_home_video_en.mp4" {/if}>

                </iframe>
            </div>
        </div>
        {* <div class="button-container">
        <a href="{$url}creer-un-compte.html" class="btn-signup" title='{"Crear una cuenta"|x_translate}' >{"Crear una cuenta"|x_translate}</a>
        <a href="JavaScript:void(0)" id="loginbtn" class="btn-login" title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a>
        </div> *}
        <div style="margin-top: 20px; margin-bottom: 20px;" id="button-containerid" class="button-container">
            {* <p>{"Automatisez vos taches liées à la Prévention & QVT avec"|x_translate}        
            <br> *}
            {* logo *}
            {* <img src="{$url}xframework/app/themes/dp02/img/logo_workncare.png" alt="WorknCare"
            ></img>
            </p> *}
            <p>{"Documentez votre conformité et automatisez vos tâches avec notre solution"|x_translate}</p>
            {* <p>{"WorknCare est une solution de prévention et de QVT plug & play pour les entreprises"|x_translate}</p>
            <div class="button-container">
            <a href="{$url}creer-un-compte.html" class="btn-signup" title='{"Crear una cuenta"|x_translate}' >{"Crear una cuenta"|x_translate}</a>
            <a href="JavaScript:void(0)" id="loginbtn" class="btn-login" title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a>
            </div> *}


            <img id="img-show-video-inf" class="img-v"  onclick="showHomeVideoInf()" src="{$url}xframework/app/themes/dp02/videos/caaac.png" alt={"WorknCare, la solution Prévention & QVT plug & play"|x_translate} />
            <i id="ico-repro" class="fa fa-play-circle ico-repro"></i>
            <div id="container-desktop" class="container-desktop">
                <video id="home-video" controls="true"  preload  muted="false" class="video-info">
                    <source  {if $TRADUCCION_IDIOMA=="fr"}  src="{$url}xframework/app/themes/dp02/videos/prevention_report.mp4" {else} src="{$url}xframework/app/themes/dp02/videos/prevention_report_en.mp4" {/if} type="video/mp4">
                    <source   {if $TRADUCCION_IDIOMA=="fr"} src="{$url}xframework/app/themes/dp02/videos/prevention_report.webm" {else} src="{$url}xframework/app/themes/dp02/videos/prevention_report_en.webm" {/if} type="video/webm">
                </video>  
                <div class="{if $TRADUCCION_IDIOMA=="en"} ubi-en {/if}  div-stilo"></div>
                <div class="div-hori-stilo"></div>
            </div>
        </div>

    </div>
</section>


<div class="hp-home-wrapper hom-DoctorPlus" id="hom-DoctorPlus">

    <!-- Banner beneficios container-->
    {include file="home_w/banner_beneficios.tpl"}
    <div class="div-p">
        <p class="pa">{"<< Comment prendre soin de la santé des salariés ? >>"|x_translate}</p>
    </div>
    <div class="container-img" id="img-show-video-inf-2">
        <img  class="img-v img-2"  onclick="showHomeVideoInf2()" src="{$url}xframework/app/themes/dp02/videos/gdfdsfd.png" alt={"WorknCare, la solution Prévention & QVT plug & play"|x_translate} />  
    </div>

    <div id="container-desktop-2" class="container-desktop container-segu-vid">
        <video id="home-video-2" controls="true"  preload  muted="false" class="video-info">
            <source {if $TRADUCCION_IDIOMA=="fr"} src="{$url}xframework/app/themes/dp02/videos/Employees_Mental_Health.mp4"{else}src="{$url}xframework/app/themes/dp02/videos/Employees_Mental_Health_en.mp4" {/if} type="video/mp4">
            <source {if $TRADUCCION_IDIOMA=="fr"} src="{$url}xframework/app/themes/dp02/videos/Employees_Mental_Health.webm" {else} src="{$url}xframework/app/themes/dp02/videos/Employees_Mental_Health_en.webm" {/if} type="video/webm">
        </video>  
    </div>
    <div class="div-hori-stilo band-sti-hor-2"></div>
    <i id="ico-repro-2" class="fa fa-play-circle ico-repro ico-repro-2"></i>
    <!-- Banner servicios container-->
    {include file="home_w/banner_nuestros_servicios.tpl"}
    <div class="banner__separator">
        <p>{"Cochez la case conformité<br/>et gagnez du temps"|x_translate}</p>
        <div class="banner__separator-card">
            <div>
                <h3>{"Un outil qui me rend service"|x_translate}</h3>
                <h4>{"« J'apprécie la simplicité de l'outil, qui m'aide cibler mon action Ià où sont les besoins. Pour mes évaluations, la communication terrain mais aussi l'accompagnement des salariés sur des budgets hyper flexibles. »"|x_translate}</h4>
            </div>
            <div class="banner__separator-card-img">
                <img src="{$url}xframework/app/themes/dp02/img/card_profile_3.jpg" alt="WorknCare"></img>
            </div>
        </div>
    </div>
    <!-- seccion baner presentacion pass bientre-->
    {include file="home_w/banner_pass_bienetre.tpl"}
    {* 
    <div class="banner__separator">
    <p>Vous êtes Professionnel de santé,
    Coach ou prestataire ?</p>
    <li><a class="se-conecter scroll" data-lnk="scroll-hom-contacto-container" href="javascript:;" title='{"Se connecter"|x_translate}' >{"Se connecter"|x_translate}</a></li>

    </div> *}


</div>
{**{include file="home_w/programas_listado.tpl"} **}

<!-- Contactenos container-->
<div id="hom-contacto-container">

</div>


{literal}
    <script>
        document.querySelector('.bg-hom-nav2').style.opacity = '0';
        $(window).on('scroll', function () {
            if (window.innerWidth <= '500') {
                if ($(window).scrollTop() >= '50') {
                    document.querySelector('.bg-hom-nav2').style.opacity = '1';
                } else {
                    document.querySelector('.bg-hom-nav2').style.opacity = '0';
                }
            } else {
                if ($(window).scrollTop() >= '150') {
                    document.querySelector('.bg-hom-nav2').style.opacity = '1';
                } else {
                    document.querySelector('.bg-hom-nav2').style.opacity = '0';
                }
            }
        });


        window.addEventListener('click', function (e) {
            if (!document.getElementById('popup-iframe-video').contains(e.target) && !document.getElementById('img-show-video').contains(e.target)) {
                if (document.getElementById('popup-iframe-video').style.display != 'none') {
                    document.getElementById('popup-iframe-video').style.display = 'none';
                }
            }
        });

        function showHomeVideo() {
            document.getElementById('popup-iframe-video').style.display = 'block';
        }

        function showHomeVideoInf() {
            $("#container-desktop").css('display', 'block');
            $("#img-show-video-inf").css('display', 'none');
            $("#ico-repro").css('display', 'none');
            $('#home-video').trigger('play');
            $("#home-video").prop('muted', false);

        }

        function showHomeVideoInf2() {
            $("#container-desktop-2").css('display', 'block');
            $("#img-show-video-inf-2").css('display', 'none');
            $("#ico-repro-2").css('display', 'none');
            $('#home-video-2').trigger('play');
            $("#home-video-2").prop('muted', false);

        }

        $(function () {
            x_loadModule("home_w", "contactenos", "", "hom-contacto-container");
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

            $("#open-modal-nos-offres").click(function () {
                $("#modal-nos-offres").modal("show");
            });
            ;

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
            } else if ($(this).data('lnk') == 'banner-pass-bienetreid') {
                scrollToEl($("#banner-pass-bienetreid"));
            } else {
                scrollToEl($("#button-containerid"));
            }
        });

        $(document).ready(function () {
            $("#home-video").prop('muted', false);
            $("#home-video-2").prop('muted', false);
            if ($("#idconectar").val() == '1') {
                $("#loginbtnEmpresa").trigger("click");
            }
        });

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