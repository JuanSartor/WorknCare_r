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
            background: #1A3661;
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
{include file="home/login.tpl"}
<nav class="paciente-nav">
    <div class="okm-container paciente-nav-container">
        <div class="paciente-nav-logo">
            <a href="{$url}" title="WorknCare">
                <img src="{$IMGS}logo_workcnare_blanco.png" title="WorknCare"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a class="paciente-nav-menu-burger"><i class="icon-doctorplus-burger"></i></a>
            <ul class="paciente-nav-menu-rsp" id="burger-menu">
                <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup" title='{"Crear una cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
                <li><a href="JavaScript:void(0)" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login" title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="plogin-header">
    <h1>{"Crear una cuenta como"|x_translate}</h1>
    <div class="okm-row hub-account-action-box home-francia" id="comparativo">
        <div class="col-md-6 col-sm-6 col-xs-12">
            <a href="{$url}patient/creer-un-compte.html" title='{"Paciente"|x_translate}'>
                <h2 class="red">{"Paciente"|x_translate}</h2>
            </a>
        </div>
        <div class="col-md-6 col-sm-6 col-xs-12">
            <a href="{$url}professionnel/creer-un-compte.html" title='{"Profesional de la salud"|x_translate}'>
                <h2 class="green">{"Profesional de la salud"|x_translate}</h2>
            </a>
        </div>

    </div>
</div>
<div class="hub-account-already">
    <div class="hub-account-already-box">
        <div class="hub-account-already-row">
            {"¿Ya tiene una cuenta?"|x_translate} <a href="JavaScript:void(0)" id="loginbtn2" class="uh-top-lnk" data-toggle="modal" data-target=".login" title='{"Iniciar sesión ahora"|x_translate}'>{"Iniciar sesión ahora"|x_translate}</a>
        </div>
        <div class="hub-account-already-row">
            <a href="javascript:;" id="ForgotPass" title='{"¿Olvidó su contraseña?"|x_translate}'>{"¿Olvidó su contraseña?"|x_translate}</a>
        </div>
    </div>
</div>


{literal}
    <script>
        $(function () {
            $("#ForgotPass").click(function () {
                $('#login').hide();
                $('#timeout').hide();
                $('#passrecovery').fadeIn();
                $(".login").modal("show");
            });

            $('.paciente-nav-trigger').on('click', function (e) {
                e.preventDefault();
                $pacienteMenu = $('#paciente-menu');
                $pacienteMenu.toggleClass('menu-show');

            });


            $('.paciente-nav-menu-burger').on('click', function (e) {
                e.preventDefault();
                var vpw = $(window).width() + getScrollBarWidth();
                $burgerMenu = $('#burger-menu');
                $burgerMenu.toggleClass('menu-show');
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

        });
    </script>
{/literal}
