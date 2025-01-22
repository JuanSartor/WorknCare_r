
<section class="pul-menu-admin">  
    <div class="okm-container" id="menu-reembolsos-datos">
        <div class="container-btn-volver">
            <a href="{$url}panel-paciente/" class="btn-volver-home-sante btn-volver-reembolso"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
        </div>
        <h1 class="titulo-reembolso">{"Reembolsos"|x_translate}</h1> 

        <div class="container-botones-reembolsos">
            <div  class="container-reembolso container-activo-recibir-reembolso">
                <a href="javascript:;" class="btn-container-reembolso"  ></i>{"Recibir reembolso"|x_translate}</a>
            </div>
            <div class="container-mis-reembolsos">
                <a href="javascript:;"  ></i>{"Mis reembolsos"|x_translate}</a>
            </div>
        </div>
        <div class="container-datos-bancarios">
            {include file="reembolso_beneficiario/datos_bancarios.tpl"}
        </div>
        <div class="container-datos-mis-reembolsos" hidden>
            {include file="reembolso_beneficiario/mis_reembolsos_beneficiario.tpl"}
        </div>
    </div>
</section>

{literal}
    <script>
        $(".container-reembolso").click(function (e) {
            $(".container-mis-reembolsos").removeClass("container-activo-mis-reembolso");
            $(".container-reembolso").addClass("container-activo-recibir-reembolso");
            $(".container-datos-bancarios").show();
            $(".container-datos-mis-reembolsos").hide();

        });
        $(".container-mis-reembolsos").click(function (e) {
            x_loadModule('reembolso_beneficiario', 'administracion_reembolso', '', 'menu-reembolsos-datos', BASE_PATH + "paciente_p").then(function () {
                $(".container-reembolso").removeClass("container-activo-recibir-reembolso");
                $(".container-mis-reembolsos").addClass("container-activo-mis-reembolso");
                $(".container-datos-mis-reembolsos").show();
                $(".container-datos-bancarios").hide();
            });
        });

    </script>
{/literal}