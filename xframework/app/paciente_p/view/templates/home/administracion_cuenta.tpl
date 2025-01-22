<style>
    .pul-menu-admin-action-col {
        width: 25%;
        float: left;
        text-align: center;
    }
    .mul-datos-administrador-box {
        display: block; 
    }
    .datos-administrador-submodulo{
        display:none;
    }
    .ce-nc-consulta-precios {
        background: #ffffff;
    }
</style>
<section class="pul-menu-admin">
    <div class="pul-menu-admin-header header-blanco-nuevo">
        <div class="okm-container">
            <a href="javascript:;" onclick="window.history.back();" class="btn-volver-home-sante btn-volver-reembolso"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
            <h1>{"Administración de Cuenta"|x_translate}</h1>
        </div>
    </div>
    <div class="pul-menu-admin-box">
        <div class="pul-menu-admin-container">
            <div class="okm-row">
                <div id="pul-datos-administrador-trg" class="pul-menu-admin-action-col" data-target="div_submodulo_adminsitrador">
                    <a href="javascript:;" {if $smarty.request.mod=="1"}class="active"{/if}>
                        <figure><i class="icon-doctorplus-profile-sheet"></i></figure>
                        <div>{"Datos administrador"|x_translate}</div>
                    </a>
                </div>
                <div id="pul-estado-cuenta-trg" class="pul-menu-admin-action-col" data-target="div_estado_cuenta" >
                    <a href="javascript:;" {if $smarty.request.mod=="2"}class="active"{/if} >
                        <figure><i class="icon-doctorplus-dollar-circular"></i></figure>
                        <div>{"Estado de Cuenta"|x_translate}</div>
                    </a>
                </div>
                <div id="pul-tarjetas-trg" class="pul-menu-admin-action-col" data-target="div_tarjetas" >
                    <a href="javascript:;" {if $smarty.request.mod=="4"}class="active"{/if} >
                        <figure><i class="fa fa-credit-card"></i></figure>
                        <div>{"Tarjetas de crédito"|x_translate}</div>
                    </a>
                </div>
                <div id="pul-privacidad-trg" class="pul-menu-admin-action-col" data-target="div_submodulo_privacidad" >
                    <a href="javascript:;" {if $smarty.request.mod=="3"}class="active"{/if} >
                        <figure><i class="icon-doctorplus-unlock"></i></figure>
                        <div>{"CONFIGURACIÓN DE PRIVACIDAD"|x_translate}</div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<div id="div_submodulo_adminsitrador" class="datos-administrador-submodulo">
    {include file="home/datos_administrador.tpl"}
</div>
<div id="div_estado_cuenta" class="datos-administrador-submodulo">

</div>
<div id="div_tarjetas" class="datos-administrador-submodulo">

</div>
<div id="div_submodulo_privacidad" class="datos-administrador-submodulo">
    {include file="home/datos_privacidad.tpl"}
</div>


{literal}
    <script>

        $(function () {
            //cargamos el modulo de movimientos de cuenta
            x_loadModule('home', 'estado_cuenta', 'mod={$smarty.request.mod}', 'div_estado_cuenta', BASE_PATH + "paciente_p");

            //cargamos el modulo de tarjetas
            x_loadModule('home', 'listado_tarjetas', 'mod={$smarty.request.mod}', 'div_tarjetas', BASE_PATH + "paciente_p");

            //cargamos el activo
            $("#" + $(".pul-menu-admin-action-col a.active").parent().data("target")).show();


            $('.pul-menu-admin-action-col').on('click', function (e) {
                $(".pul-menu-admin-action-col a").removeClass("active");
                $(this).find("a").addClass("active");
                var target = $(this).data("target");
                $(".datos-administrador-submodulo").not('#' + target).slideUp();
                $('#' + target).slideDown();

            });

        });
    </script> 
{/literal}    