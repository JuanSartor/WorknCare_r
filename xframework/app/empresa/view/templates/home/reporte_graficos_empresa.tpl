<section class="container divider-print">
    <div class="row " style="display:flex;">

        <div class="col-sm-6 left-chart">
            <div class="row text-center">
                <label> {"Facturacion por beneficiarios registrados"|x_translate}</label>
                <canvas  id="myChart"></canvas>
            </div> 
            <div class="row text-center">
                <label> {"Tasa de inscripcion"|x_translate}</label>
                <canvas id="myChart4"></canvas>
            </div>
            <div class="row text-center">
                <label> {"Programas más utilizados"|x_translate}</label>
                <canvas  id="myChart3" ></canvas>
            </div> 

        </div>
        <div class="col-sm-6 right-charts" >
            <div class="row text-center">
                <label>  {"Presupuesto maximo vs. Presupuesto utilizado"|x_translate}</label>
                <canvas  id="myChart2" ></canvas>
            </div>
            <div class="row text-center">
                <label> {"Porcentaje de uso del servicio"|x_translate}</label>
                <div class="chart-porcentaje-container">
                    <span class="porcentaje">{$porcentajeUso}%</span>
                    <canvas  id="myChart5" style="margin-bottom: 0px"></canvas>
                </div>

            </div>   
        </div>   

    </div>   

</section>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/chart/dist/chart.min.js"></script>
<script>
    // defino las variables js
    var mesesTasa ={$mesesTasa};
    var valoresTasa ={$valoresTasa};
    var mesesPresupuesto ={$mesesPresupuesto};
    var valoresPresupuesto ={$valoresPresupuesto};
    var mesesImporte ={$mesesImporte};
    var valoresImporte ={$valoresImporte};
    var labelProgramas ={$labelProgramas};
    var valoresProgramas ={$valoresProgramas};
    var porcentajeUso ={$porcentajeUso};
    console.log(valoresPresupuesto);
</script>