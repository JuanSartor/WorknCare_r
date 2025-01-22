<style>
    .pcuh-slide-item{
        min-height: fit-content;
    }
    .pcuh-slide-header {
        margin-top: 0px;
        margin-bottom: 0px;
    }
    .pcuh-slide-content .pcuh-slide-content-inner,.pcuh-slide-content .pcuh-slide-content-inner.pcuh-turnos-inner {
        min-height: 170px;
    }
    #listado-consultas .pcuh-tunos-footer .mdl-cancelar-turno{
        color: #FFF;
        margin-top: 5px;

    }
    .pcuh-slide-content p.pcuh-tunos-descripcion {
        padding-top: 5px;
        margin: 0px;
    }
    .pcuh-slide-content span.pcuh-tunos-date {
        display: block;
        color: #cd3845;
        font-size: 20px;
    }
    .pcuh-slide-content p.pcuh-tunos-tipo {
        color: #415b70;
        font-size: 14px;
        line-height: 16px;
        padding-top: 0px;
    }
    .pcuh-slide-content p.pcuh-tunos-tipo i{
        margin-right:4px; 
        font-size: 18px;
    }
    .pcuh-slide-content p.pcuh-tunos-descripcion i{
        margin-right:4px; 
    }
    .pcuh-slide-content p.pcuh-tunos-descripcion.especialidad{
        padding-top: 0px;
        margin-bottom: 10px;
    }   
    .pcuh-tunos-descripcion.estado .confirmado{
        color:#0ec2a1;
    }

    .pcuh-tunos-descripcion.estado .pendiente{
        color:#f6a800;
    }
    .pcuh-slide-header {
        margin-top: 0px;
        margin-bottom: 0px;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .pcuh-slide-header>figure {
        margin: 0;
        margin-right:10px;
    }
    .pcuh-turnos {
        background-color: #FFFFFF; 
        padding: 10px;
    }

    .pcuf-controles-slide {
        box-shadow: 2px 2px 10px 0 #666;
        border-radius: 10px;
    }
    .pcuh-slide-sin-turnos {
        position: relative;
        height: 150px;
    }
    .pcuh-slide-sin-turnos>p {
        display: block;
        position: relative;
        text-align: center;
        top: 50%;
        bottom: auto;
        margin-bottom: 0px;
        font-weight: 600;
        transform: none;
        font-size: 18px;
        color: #F23243;
    }
    @media(max-width:600px){
        .pcuh-slide-sin-turnos {
            position: relative;
            height: auto;
        }
        .pcuf-controles-slide.slick-initialized.slick-slider{
            min-height: 550px
        }
    }

</style>
<section class="pul-perfil-incompleto">
    <div class="pul-pi-box">
        <div class="okm-row pul-pi-data-box turnos-banner {if $empresa_beneficiario!='Particulier' && $empresa_beneficiario!=''} contenedores-con-reembolso {/if}">

            <figure><img class="icono-mesa-consultas" src="{$url}xframework/app/themes/dp02/img/mesa_consultas.png"></figure>
            <p class="texto">{"Consultas"|x_translate}</p>
            <div class="col-action btn-consultas-mobile">
                <a href="javascript:;" class="btn boton-consultas  {if $empresa_beneficiario!='Particulier' &&  $empresa_beneficiario!=''}  btn-reembolso-consulta-margen {/if}" id="btnMostrarConsultas">{"ver"|x_translate}</a>
                <a href="javascript:;" class="btn boton-consultas  {if $empresa_beneficiario!='Particulier' &&   $empresa_beneficiario!=''}  btn-reembolso-consulta-margen {/if}" id="btnOcultarConsultas" style="display: none;">{"cerrar"|x_translate}</a>
            </div>
            <div id="div_home_cant_consultas_totales">
                {if $cantidad_notificaciones.notificacion_general + $videoconsulta_notificaciones.notificacion_general>0}
                    <span class="div-span-nuevo-total">{$cantidad_notificaciones.notificacion_general + $videoconsulta_notificaciones.notificacion_general}</span>
                {/if}
            </div>
        </div>

        <div id="listado-consultas"  style="display: none;">
            {include file="home/home_iconos.tpl"}
        </div>

    </div>
</section>


{literal}
    <script>
        $(function () {
            //Mostrar listado controles
            $("#btnMostrarConsultas").click(function () {
                //$(window).trigger('resize');//triger widtg slide controles
                $("#btnMostrarConsultas").hide();
                $("#btnOcultarConsultas").show();
                $("#listado-consultas").slideDown();
                $("#div_home_cant_consultas_totales").hide();
            });
            //Mostrar listado controles
            $("#btnOcultarConsultas").click(function () {
                $("#btnOcultarConsultas").hide();
                $("#btnMostrarConsultas").show();
                $("#listado-consultas").slideUp();
                $("#div_home_cant_consultas_totales").show();
            });



        });
    </script>
{/literal}
