<style>
    .fix-nav2{
        top: 5px !important;
    }
    @media (max-width:600px){
        .fix-nav2{
            top: 4px !important;
        }
    }
</style>
<nav class="hom-nav2" id="hom-nav2">
    <div id="hom-nav-menu" class="hom-nav-menu">
        <div class="menu-group">
            <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="fa fa-bars"></i></a>
        </div>
        <ul id="hom-nav-rsp-get">
         <!--   <li class="pass-bienetre empresa" ><a href="{$url}creer-compte.html?connecter"  title='{"Pase de Salud"|x_translate}'><strong>{"Pase de Salud"|x_translate}</strong></a></li>
            <li class="pass-bienetre particular" ><a href="{$url}portailsalariés.html"  title='{"Pase de Salud particular"|x_translate}'><strong>{"Pase de Salud particular"|x_translate}</strong></a></li>
         -->   
         <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup" title='{"Crear cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
            <li><a href="javascript:;" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login"  title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
        </ul>
    </div>
</nav>
{literal}
    <script>

        $(function () {
            $(document).ready(function () {
                $("#hom-nav2").addClass("fix-nav2");
                //console.log($(location).attr('href'));
            });


            $('#hom-nav-rsp-trg').on('click', function (e) {

                $('#hom-nav-menu').toggleClass('menu-show');

            });

        });

    </script>
{/literal}