<!-- Modal full width- ver archivos-->
<link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
<style>

    .carrusel-robots{
        width:370px;
        margin-top: 30px;     
    }

    .modal-content{
        width:450px;
    }
    .modal-dialogo{
        position: absolute;
        margin: 0 auto !important;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%) !important;
    }
    @media(max-width:600px){
        .usrlogin .modal-header {
            border-bottom: 0;
            min-height: inherit;
            padding-left: 0px;
        }
        .modal-content{
            width:365px;
        }
        img{
            width:330px;
        }
        .carrusel-robots{
            width:340px;
            margin-top: 30px;     
        }
        .modal-dialogo{
            top: 46%;
        }
    } 

</style>
<div class="modal fade usrlogin login login-background" tabindex="-1" role="dialog"   aria-labelledby="myLargeModalLabel" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialogo  modal-sm" role="document" style="height: 90%; max-width: none; width: 95%;">
        <div class="modal-content" style="background-color: white !important; width: 100%; height: 600px; border-radius: 20px; box-shadow: 0 5px 15px rgb(193 189 189 / 50%);" >
            <div class="modal-header">
                <button name="cerrar_wizard" id="cerrar_wizard" type="button" class="close btn-cerrar"   title='{"Cerrar"|x_translate}' data-dismiss="modal" aria-label="Close"><span  aria-hidden="true"><i class="fa fa-times"></i></span></button>
                <div class="carrusel-robots" style="margin-inline: auto; margin-top: 0px;">
                    <div><img style="width: 100%;"  src="{$IMGS}wizard_inicio/1.png " title="WorknCare"></div>

                    {if $plan_contratado.idprograma_salud_plan == '18' || $plan_contratado.idprograma_salud_plan == '19' || $plan_contratado.idprograma_salud_plan == '20'}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/2-mini.jpg" title="WorknCare"> </div>
                        {else}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/2.png" title="WorknCare"> </div>
                        {/if}
                        {if $plan_contratado.idprograma_salud_plan == '18' || $plan_contratado.idprograma_salud_plan == '19' || $plan_contratado.idprograma_salud_plan == '20'}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/3-mini.png" title="WorknCaree"> </div>
                        {else}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/3.png" title="WorknCare"> </div>
                        {/if}
                        {if $plan_contratado.idprograma_salud_plan == '18' || $plan_contratado.idprograma_salud_plan == '19' || $plan_contratado.idprograma_salud_plan == '20'}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/4-mini.png" title="WorknCare"> </div>
                        {else}
                        <div> <img style="width: 100%;"  src="{$IMGS}wizard_inicio/4.png" title="WorknCare"> </div>
                        {/if}
                    <div><img style="width: 100%;"  src="{$IMGS}wizard_inicio/5.png" title="WorknCare"></div>
                    <div><img style="width: 100%;"  src="{$IMGS}wizard_inicio/6.png" title="WorknCare"></div>
                    <div><img style="width: 100%;"  src="{$IMGS}wizard_inicio/7.png" title="WorknCare"></div>

                </div>
            </div>
        </div>
        <a id="flecha-izquierda" style="visibility:hidden;" name="flecha-izquierda" href="javascript:;" class="pcuh-pf-slide-control left slider-control-medicos-frecuentes fondo-flecha-izquierda"><img  src="{$IMGS}wizard_inicio/icono.svg"></a>
        <a href="javascript:;" class="pcuh-pf-slide-control right slider-control-medicos-frecuentes fondo-flecha-derecha"><img src="{$IMGS}wizard_inicio/icono.svg"></a>
    </div>
</div>
<!-- modal -->
{literal}
    <script>
        $('.login').modal('show');

        $('.carrusel-robots').slick(
                {
                    autoplay: true,
                    autoplaySpeed: 4000,
                    speed: 1000,
                    nextArrow: '.pcuh-pf-slide-control.right',
                    prevArrow: '.pcuh-pf-slide-control.left'
                });
        $("#cerrar_wizard").on("click", function (e) {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'actualizar_primer_inicio_sesion.do'


                    );
        });
        $(".fondo-flecha-derecha").click(function () {
            $("#flecha-izquierda").css("visibility", "visible");
        });
    </script>
{/literal}