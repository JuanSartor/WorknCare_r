<style>
    @media (max-width: 600px){
        .mad-menu .mul-col-3 {
            width: 33%;
            text-align: center;
        }
        .mad-menu a {
            display: block;
            margin-bottom: 0px;
        }
        .mad-menu a span {
            color: #fff;
            font-size: 14px;
        }
    }
</style>
<nav class="mad-menu">
    <h1>{"Configuración"|x_translate}</h1>
    <div class="container">
        <div class="ok-row mul-row">
            <div class="mul-col-3">
                <a href="javascript:;" id="mul-datos-administrador-trg">
                    <figure class="mad-icon {if $smarty.request.mod=="1"}active{/if}"><i class="icon-doctorplus-profile-sheet"></i></figure>
                    <span>{"Datos administrador"|x_translate}</span>
                </a>
            </div>
            <div class="mul-col-3">
                <a href="javascript:;" id="mul-configuracion-trg">
                    <figure class="mad-icon {if $smarty.request.mod=="2"}active{/if}"><i class="fa fa-cogs"></i></figure>
                    <span>{"Servicios que ofrece"|x_translate}</span>
                </a>
            </div>
            <div class="mul-col-3">
                <a href="javascript:;" id="mul-vencimientos-trg">
                    <figure class="mad-icon {if $smarty.request.mod=="3"}active{/if}"><i class="icon-doctorplus-dollar-circular"></i></figure>
                    <span>{"Vencimientos"|x_translate}</span>
                </a>
            </div>
        </div>
    </div>
</nav>

<div id="div_submodulo_adminsitrador">
    {include file="usuario/datos_administrador.tpl"}
</div>
<div id="div_submodulo_configuracion">
    {include file="usuario/configuracion.tpl"}
</div>
<div id="div_submodulo_vencimientos">
    {include file="usuario/vencimientos.tpl"}
</div>

{*Cargamos el submodulo solicitado*}
<script>



    $(function (){ldelim}

    {if $smarty.request.mod=="1"}


            $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
            $('.mul-datos-administrador-box').slideDown();
    {/if}

    {if $smarty.request.mod=="2"}

            $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
            $('.mul-configuracion-box').slideDown();
    {/if}

    {if $smarty.request.mod=="3"}

            $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
            $('.mul-vencimientos-box').slideDown();
    {/if}

    {rdelim});
    {literal}



        if ($('.mad-menu').length > 0) {

            function mulScroll(trgObj) {
                var trgObjHeight = trgObj.outerHeight();
                $('html, body').animate({
                    scrollTop: (trgObj.offset().top - trgObjHeight) - 60
                }, 1000);
            }



            $('#mul-configuracion-trg').on('click', function (e) {

                if (!$(this).children('figure').hasClass('active')) {

                    $('#mul-datos-administrador-trg').children('figure').removeClass('active');
                    $('#mul-vencimientos-trg').children('figure').removeClass('active');
                    $(this).children('figure').addClass('active');
                    $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
                    $('.mul-configuracion-box').slideDown();
                    var mulvpw = $(window).width() + getScrollBarWidth();
                    if (mulvpw <= 600) {
                        mulScroll($('.mul-configuracion-box'));
                    }

                }


            });
            $('#mul-datos-administrador-trg').on('click', function (e) {

                if (!$(this).children('figure').hasClass('active')) {

                    $('#mul-configuracion-trg').children('figure').removeClass('active');
                    $('#mul-vencimientos-trg').children('figure').removeClass('active');
                    $(this).children('figure').addClass('active');
                    $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
                    $('.mul-datos-administrador-box').slideDown();
                    var mulvpw = $(window).width() + getScrollBarWidth();
                    if (mulvpw <= 600) {
                        mulScroll($('.mul-datos-administrador-box'));
                    }

                }


            });
            $('#mul-vencimientos-trg').on('click', function (e) {

                if (!$(this).children('figure').hasClass('active')) {

                    $('#mul-configuracion-trg').children('figure').removeClass('active');
                    $('#mul-datos-administrador-trg').children('figure').removeClass('active');
                    $(this).children('figure').addClass('active');
                    $('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
                    $('.mul-vencimientos-box').slideDown();
                    var mulvpw = $(window).width() + getScrollBarWidth();
                    if (mulvpw <= 600) {
                        mulScroll($('.mul-vencimientos-box'));
                    }

                }

            });
        }

    {/literal}
</script>    