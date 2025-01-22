{include file="programa_salud_registro/menu.tpl"}

{if $particular=="1"}
    {include file="home/login.tpl"}
{else}
    {include file="programa_salud_registro/login.tpl"}
{/if}

<style>
    .mapc-registro-box {
        margin: 10px auto;
    }
    .mapc-politicas-box {
        margin: 12px auto;
    }
    .mapc-politicas-box .mapc-politicas p{
        color: #415b70;
        font-size: 14px;
        line-height: 18px;
        margin-bottom: 10px;
    }
    .mapc-registro-form-row .btn-siguiente,.mapc-registro-form-row .btn-crear-cuenta{
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver{
        min-width:auto !important;
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver:hover{
        background: #b6b6b6 !important;
    }
    @media (max-width: 600px){
        .plogin-registro-accordios-title {
            font-size: 13px;
            padding: 8px;
        }
    }
    .mapc-select {
        margin-top: 0px;
    }
    .mapc-select .mbl{
        margin-bottom: 0px;
    }
    .plogin-mensaje-registro p {
        margin: auto auto 24px;
    }
    .plogin-mensaje-registro .plogin-mensaje-registro-actions{
        margin-bottom: 24px;
    }
    /*mostrar contraseña*/
    .mapc-input-line>.btnShowPassword{
        font-size: 24px;
        line-height: 22px;
        display: inline-block;
        position: absolute;
        top: 19px;
        right: 22px;
        /*color: #d8d8d8;*/
    }

    .btnShowPassword i {
        cursor:pointer;
    }
    /*archivos identificacion*/
    .cont-imagen{
        width:165px;
        height: 80px;
    }
    .cont-imagen.pdf{
        width:80px;
        height: 80px;
    }
    .upload-filename label{
        display:inline
    }
    .upload-filename .btn-delete-file {
        color: #f33243;
    }
</style>
<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

<section class="pass-sante-registro-planes">
    <input type="hidden"  id="achatdepack" value="{$achatdepack}"/>
    <div class="okm-container creacion-cuenta">
        <div class="header-container text-center">
            <div class="logo-container">
              <!--  <img src="{$IMGS}logo_pass_bienetre.png"/>
                <span class="label-logo">par DoctorPlus</span> -->
            </div>
            {**verificamos si es contratacion particular**}
            {if $particular!="1"}
                <div class="header-title planes"  id="planPago"> 
                    <h1 class="text-center texto-21-22">{"El Pase de Salud, ¡no cuesta nada probarlo!"|x_translate}</h1>
                    <h2 class="text-center">{"Afiliación gratuita"|x_translate}</h2> 
                </div>
                <div class="header-title planes"  id="planFree" style="display:none;">  
                    <h1 class="text-center texto-21-22">{"El Pase de Salud, ¡no cuesta nada probarlo, gratuito!"|x_translate}</h1>
                    <h2 class="text-center">{"Afiliación gratuita"|x_translate}</h2> 
                </div>
                <div class="header-title packs" id="packPago" style="display:none;">
                    <h1 class="text-center">{"Ideal para sus campañas de dotación de personal!"|x_translate}</h1>
                    <h2 class="text-center">{"Compra un pack ahora"|x_translate}</h2> 
                </div>
                <div class="header-title packs" id="packFree" style="display:none;">
                    <h1 class="text-center">{"Formule Découverte"|x_translate}</h1>
                    <h2 class="text-center">{"Inscripcion"|x_translate}</h2> 
                </div>
                <div class="header-title 500" id="pack500" style="display:none;">
                    <h1 class="text-center">{"Ideal para sus campañas de dotación de personal! 500"|x_translate}</h1>
                    <h2 class="text-center">{"Compra un pack ahora 500"|x_translate}</h2> 
                </div>
            {else}
                <div class="header-title planes" >
                    <h1 class="text-center">{"Su solucion de bienestar"|x_translate}</h1>
                    <h2 class="text-center">{"Plan mensual o compra única"|x_translate}</h2> 
                </div>
                <div class="header-title packs" style="display:none;">
                    <h1 class="text-center">{"Su solucion de bienestar"|x_translate}</h1>
                    <h2 class="text-center">{"Plan mensual o compra única"|x_translate}</h2> 
                </div>
            {/if}

        </div>
        <a href="{$url}" class="btn-volver-home-sante btn-volver-planes" id="btnVolverPlanes" ><i class="fa fa-chevron-left"></i></a>

        <div class="planes-wrapper"> 

            <div class="okm-row text-center">
                {**verificamos si es contratacion particular**}
                {if $particular!="1"}
                    <button class="btn btn-default btn-switch-planes active btn-adhesion"  data-target="planes" id="oferta-empresas">{"Oferta para empresas"|x_translate}</button>
                    <button class="btn btn-default btn-switch-planes" data-target="packs" id="oferta-obras-sociales">{"Oferta para Obras Sociales"|x_translate}</button>
                    <div class="okm-row text-center">
                        <button class="btn btn-default btn-switch-planes btn-enterprise-500" data-target="500" id="oferta-empresa-500">{"Empresa con mas de 500 empleados"|x_translate}</button>
                    </div>
                {else}
                    <button class="btn btn-default btn-switch-planes active" data-target="planes" id="oferta-empresas">{"Suscripción particular"|x_translate}</button>
                    <button class="btn btn-default btn-switch-planes" data-target="packs" id="oferta-obras-sociales">{"Pago unico particular"|x_translate}</button>
                {/if}
            </div>
            <!--Listamos los planes para empresas-->
            <div class="listado-planes"  id="planes-list">
                {foreach from=$planes item=plan} 
                    {include file="programa_salud_registro/registro_form_item_plan.tpl" plan=$plan}
                {/foreach}

            </div>

            <!--Listamos los pack para Obras Sociales-->

            <div class="listado-planes"  id="packs-list" style="display:none;">
                {foreach from=$packs item=pack} 
                    {if $pack.idprograma_salud_plan!=20 && $pack.idprograma_salud_plan!=23}
                        {include file="programa_salud_registro/registro_form_item_plan.tpl" plan=$pack pack=1}
                    {/if}
                {/foreach}

            </div>
            <!-- listamos super plan 500 -->
            <div class="listado-planes margen-500"   id="500-list" style="display:none;">
                {foreach from=$packs item=pack} 
                    {if $pack.idprograma_salud_plan == 20 || $pack.idprograma_salud_plan == 23}
                        {include file="programa_salud_registro/registro_form_item_plan.tpl" plan=$pack pack=1}
                    {/if}
                {/foreach}
            </div>

            {if $particular!="1"}
                <div class="aclaracion-impuestos">{"(i) Por encima del límite de 171 euros / año y por empleado."|x_translate}</div>
            {/if}
        </div>
        {**verificamos si es contratacion particular**}
        {if $particular!="1"}
            {*Formualrio datos cuenta empresa*}
            {include file="programa_salud_registro/datos_registro.tpl"}
        {else}
            {*Formualrio datos cuenta particular*}
            {include file="programa_salud_registro/datos_registro_particular.tpl"}
        {/if}
    </div>
    <div class="okm-container registro-tarjeta" style="display:none;">
        <div class="header-container text-center">
            <div class="logo-container">
                <img class="tam-logo-workncare" src="{$IMGS}logo_workncare_color.png"/>
            </div>
        </div>
        {*formulario checkout*}
        <div id="checkout-container" class="col-xs-12"></div>
    </div>
</section>
<script>
    var STRIPE_APIKEY_PUBLIC = "{$STRIPE_APIKEY_PUBLIC}";
</script>
<script src="https://js.stripe.com/v3/"></script>
<script>
    var FREE = "{$free}";
</script>
{x_load_js}