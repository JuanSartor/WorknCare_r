<style>
    @media (min-width: 960px) {
        .hom-nav .btn-login, .hom-nav .btn-signup {
            border: solid 1px;
            border-radius: 5px;
            border-color: white;
            padding: 5px 10px;
            background: #1A3661;
        }

    }
    @media (max-width: 960px) {
        .hom-nav .hom-nav-menu ul.menu-show {
            display: flex !important;
            flex-direction: column-reverse;
        }
        .hom-nav .hom-nav-logo {
            display: inline-block;
            position: absolute;
            top: 50%;
            left: 50%;
            bottom: auto;
            transform: translate(-50%,-50%);
            float: none;
            padding-top: 4px;
            margin-left: 0;
        }

    }
    @media (max-width: 600px) {
        .hom-nav .hom-nav-logo img{
            width:120px;
        }
    }
</style>
<nav class="hom-nav">
    <div class="okm-container">
        <div class="okm-row">
            <div class="hom-nav-logo">
                <a href="{$url}">
                    <img src="{$IMGS}logo_workcnare_blanco.png" alt="WorknCare">
                </a>
            </div>
            <div class="hom-nav-menu">
                <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="icon-doctorplus-burger"></i></a>
                <ul id="hom-nav-rsp-get">
                    <li><a href="{$url}medecin-ou-professionnel/#hom-solucion" title='{"Solución"|x_translate}' data-lnk="hom-solucion">{"Solución"|x_translate}</a></li>
                    <li><a href="{$url}medecin-ou-professionnel/#hom-planes" title='{"Planes"|x_translate}'data-lnk="hom-planes">{"Planes"|x_translate}</a></li>
                    <li><a href="{$url}medecin-ou-professionnel/#hom-contacto" title='{"Contacto"|x_translate}' data-lnk="hom-contacto">{"Contacto"|x_translate}</a></li>
                    <li><a href="{$url}medecin-ou-professionnel/#hom-funcionalidades" title='{"Funcionalidades"|x_translate}' data-lnk="hom-funcionalidades" >{"Funcionalidades"|x_translate}</a></li>
                    <li><a href="{$url}creer-un-compte.html" class="btn-signup" title='{"Crear una cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
                    <li><a href="JavaScript:void(0)" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login"  title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>
{literal}
    <script>
        $(function () {
            $('#hom-nav-rsp-trg').on('click', function (e) {
                $('#hom-nav-rsp-get').toggleClass('menu-show');

            });
            $(document).on('click', function (event) {
                if ((!$(event.target).closest('#hom-nav-rsp-trg').length)) {
                    $('#hom-nav-rsp-get').removeClass('menu-show');
                }
            });
        });
    </script>
{/literal}