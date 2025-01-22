<style>
    .dim-btns{
        width: 280px;
        margin-top: 15px;
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: solid;
    }
    .font-iconos{
        font-size: 20px;
    }
    .btn-tarjeta:hover {
        background: #469df7 !important;
        opacity: 0.5;
    }
    .btn-factura:hover {
        background: #F5C370 !important;
        opacity: 0.5;
    }
    .label-personalizar{
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
    }
    .input-personalizar{
        margin-bottom: 15px;
        padding-left: 10px;
    }
    .title-preguntas{
        font-size: 18px;
        margin-top: 55px;
    }
    .container-btn{
        margin-top:70px;
    }
    .input-title{
        width: 433px !important;
    }
    .ubicacion-checkbox{
        position: relative;
        top: -35px;
        left: 150px;
    }
    .label-presupuesto{
        position: relative;
        top: -33px;
        left: 120px;
    }
    .borde-sombra{
        box-shadow: 1px 1px 10px 2px #ccc;
        height: 210px;
        width: 300px;
        border-radius: 8px;
    }
</style>
<section class="okm-container" id="personalizadsec">
    <!-- primer columna -->
    <input  id="idcuestionario" hidden value='{$cuestionario.idcuestionario}'>

    <div class="col-xs-6 programas-incluidos">
        <h2 class="title">
            <button onclick="location.href = 'JavaScript:window.history.back();'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Pago"|x_translate}
                {*      {$cuestionario.idcuestionario}
                {$cuestionario.empresa_idempresa} *}
        </h2>
        <div style="text-align: center;">
            <div style=" width: 225px; background-color: #ebebeb; height: 22px; margin-left: 35px; margin-top: 30px;">
                <label  class="mapc-label label-personalizar" style=" line-height: 1.3;"> 
                    {"Presupuesto"|x_translate}:{"  "}{if $cuestionario.recompensa == 1}{30 * $cuestionario.cantidad} {else}{65 * $cuestionario.cantidad} {/if}
                </label>
            </div>
            <div class="borde-sombra">
                <div class="container-inputs" style="margin-top: 20px;">
                    <div class="col-xs-12" style="margin-top: 30px;">
                        <label  class="mapc-label label-personalizar"> {"Encuesta - Barometro"|x_translate}</label>
                    </div>
                    <div class="col-xs-12">
                        <div style="background-color: #ebebeb;  height: 30px; margin-top: 10px;">
                            <label style="line-height: 1.8"  class="mapc-label label-personalizar"> {"Preguntas"|x_translate}</label>
                        </div>
                    </div>
                    <div class="col-xs-12" style="display: flex;    margin-top: 20px;">
                        <label style="line-height: 2;"  class="mapc-label label-personalizar"> {"Fin:"|x_translate}</label>
                        <input style="width: 120px; height: 30px; margin-left: 115px;"  disabled value="{$cuestionario.fecha_fin}"  class="input-personalizar" />
                    </div>
                    <div class="col-xs-12" style="margin-top: 10px;">
                        <label style="color: #ED799E; font-size: 13px;"  class="mapc-label label-personalizar">{$cuestionario.cantidad}  {"  Prestations offertes, tirage aléatoire"|x_translate}</label>
                    </div>

                </div>
            </div>
        </div>

    </div>
    <!-- segunda columna -->
    <div class="col-xs-6 preguntas-incluidas">

        <br><br><br><br><br>
        <div class="okm-row text-center" style="text-align: center;">
            <div class="col-xs-12">
                <a href="javascript:;" id="bntPagoTarjeta" style="background: #469df7; height: 35px; line-height: 0.6;" class="btn btn-xs btn-default  btn-guardar dim-btns btn-tarjeta" >{"Pago por tarjeta"|x_translate}</a>
            </div>
        </div>
        <div class="okm-row text-center" style="text-align: center;">
            <div class="col-xs-12">
                <a href="javascript:;" id="btnOtroPago" style="background: #F5C370; height: 35px; line-height: 0.6;"  class="btn btn-xs btn-default  btn-guardar dim-btns btn-factura" >{"Pagar al recibir la facutra"|x_translate}</a>
            </div>
        </div>

        {include  file="gestion/tabs_metodo_pago.tpl"}

    </div>
    <div class="clearfix">&nbsp;</div>
    <div class="col-xs-12" style=" text-align: center;font-size: 13px; font-weight: 600;  margin-bottom: 15px;">
        {"Nota: los servicios ofrecidos no están sujetos al IVA en el momento de su concesión por parte de la empresa sino en el momento de la utilización del servicio por parte de su beneficiario, en su caso."|x_translate}
    </div>
</section>


{literal}
    <script>
        $(function () {

            $("#input_cantidad").on("input", function () {
                var rdopres = $("#tipo_recompensa").val() * $(this).val();

                $("#labelrdopresupuesto").text(rdopres + " eur");
            });

            $("#tipo_recompensa").change(function () {
                var rdopres = $("#tipo_recompensa").val() * $("#input_cantidad").val();
                $("#labelrdopresupuesto").text(rdopres + " eur");
            });


            //Listener que despliega el form para cambiar el metodo de pago seleccionado de la suscripcions
            $("#bntPagoTarjeta").click(function (e) {

                $("#sepa-panel").removeClass("active");
                $("#tarjeta-credito-panel").addClass("active");

            });

            $("#btnOtroPago").click(function (e) {

                $("#tarjeta-credito-panel").removeClass("active");
                $("#sepa-panel").addClass("active");

            });


        });
    </script>
{/literal}