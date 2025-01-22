<link href="{$url}xframework/app/themes/dp02/css/home_public.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<style>
    .paciente-nav-menu ul.paciente-nav-menu-rsp li:last-child {
        margin-right: 12px;
    }
    .paciente-nav-menu ul.paciente-nav-menu-rsp li {
        display: inline-block;
        margin-right: 12px;
    }
    .paciente-nav-menu ul.paciente-nav-menu-rsp {
        position: relative;
        top: 12px;
    }
    .paciente-nav .paciente-nav-logo {
        display: inline-block;
        float: left !important;
        padding-top: 10px;
        margin-left: 16px;
        position: relative;
        left: auto;
        top: auto;
        transform: none;
    }
    @media (min-width: 960px) {
        .paciente-nav .btn-login, .paciente-nav .btn-signup {
            border: solid 1px;
            border-radius: 5px;
            border-color: white;
            padding: 5px 10px;
            background: #ffa912;
            font-size: 16px;
        }
    }



    @media (max-width: 960px){
        .paciente-nav-menu ul.paciente-nav-menu-rsp {
            display: none;
            position: absolute;
            left: inherit;
            right: 0;
            top: 60px;
            background-color: #ffa912;
            text-align: right;
            line-height: 42px;
            padding: 16px 10px;
            min-width: 190px;
        }
        .paciente-nav-menu ul.menu-show {
            display: flex !important;
            flex-direction: column-reverse;
        }

        .paciente-nav-menu ul.paciente-nav-menu-rsp li {
            display: block;
            background-color: #ffa912;
            margin-right: 12px !important;;
            width: auto;
        }
        .paciente-nav-menu ul.paciente-nav-menu-rsp li a {
            font-size: 16px;
        }


        .paciente-nav-menu .paciente-nav-menu-burger {
            display: inline-block;
            color: #fff;
            font-size: 24px;
            float: right;
            position: relative;
            top: 10px;
            margin-right: 16px;
        }

        .paciente-nav .paciente-nav-logo {
            display: inline-block;
            position: absolute;
            top: 50%;
            left: 50%;
            bottom: auto;
            transform: translate(-50%,-50%);
            float: none;
            padding-top: 16px;
            margin-left: 0;

        }

        .paciente-nav-menu ul.paciente-nav-menu-rsp li a {
            padding: 0;
        }
    }
</style>
<!-- <nav class="paciente-nav hom-nav">
    <div class="okm-container paciente-nav-container">


        <div class="paciente-nav-logo">
            <a href="{$url}" title="DoctorPlus">
                <img src="{$IMGS}doctorplus_logo_mobile.png" title="DoctorPlus"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a class="paciente-nav-menu-burger" id="hom-nav-rsp-trg"><i class="icon-doctorplus-burger"></i></a>
            <ul class="paciente-nav-menu-rsp" id="burger-menu">
                <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup" title='{"Crear cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
                <li><a href="javascript:;" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login"  title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
            </ul>
        </div>
    </div>
</nav> -->
<section class="top-section section-registrar-paciente">
    <div class="okm-container">
        <div class="home-doctorplus-logo logo-small">
            <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
        </div>
        <div class="home-main">
            <div class="home-doctorplus-logo">
                <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
            </div>
        </div>
        <nav class="hom-nav2">
            <div id="hom-nav-menu" class="hom-nav-menu nav-menu-v2">
                <div class="menu-group">
                    <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger hom-nav-burger-v2"><i class="fa fa-bars"></i></a>
                </div>
                <ul id="hom-nav-rsp-get">
                  <!--  <li class="pass-bienetre empresa" ><a href="{$url}creer-compte.html?connecter"  title='{"Pase de Salud"|x_translate}'><strong>{"Pase de Salud"|x_translate}</strong></a></li>
                    <li class="pass-bienetre particular" ><a href="{$url}portailsalariés.html"  title='{"Pase de Salud particular"|x_translate}'><strong>{"Pase de Salud particular"|x_translate}</strong></a></li>
                    -->  
                    <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup" title='{"Crear cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
                    <li><a href="javascript:;" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login"  title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
                </ul>
            </div> 
        </nav>
    </div>
</section>
{literal}
    <script>

        $('.paciente-nav-menu-burger').on('click', function () {
            $('#burger-menu').toggleClass('menu-show');
        });
        $(document).on('click', function (event) {
            if ((!$(event.target).closest('.paciente-nav-trigger').length)) {
                $('#paciente-menu').removeClass('menu-show');
            }
            if ((!$(event.target).closest('.paciente-nav-menu-burger').length)
                    &&
                    $('.paciente-nav-menu-burger').is(':visible')) {
                $('#burger-menu').removeClass('menu-show');
            }
        });

    </script>
    <script>

        $(function () {


            $('#hom-nav-rsp-trg').on('click', function (e) {

                $('#hom-nav-menu').toggleClass('menu-show');

            });

        });

    </script>
{/literal}