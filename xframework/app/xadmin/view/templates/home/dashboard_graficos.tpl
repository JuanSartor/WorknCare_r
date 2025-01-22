<link rel="{$url}xframework/app/themes/admin/css/dashboard_graficos.css" >
<div class="contenedor-dashboard">



    <div class="row-sm">


        <div class="container-col-sm">
           
            <div class="col-sm">
                <div class="titulo-sm">
                    {"Cantidad de Pacientes"|x_translate}
                </div>
                <div id="cantPacientes" class="cuerpo-sm">
                    000
                </div>
            </div>
            <div class="col-sm">
                <div class="titulo-sm">
                    {"Cantidad de Médicos"|x_translate}
                </div>
                <div id="cantMedicos" class="cuerpo-sm">  
                    000
                </div>
            </div>
        </div>



        <div class="container-col-sm">

            <div class="col-sm">
                <div class="titulo-sm">
                    {"Cantidad de Beneficiarios"|x_translate}
                </div>
                <div  id="cantBeneficiarios"class="cuerpo-sm">    
                    000
                </div>
            </div>
            <div class="col-sm">
                <div class="titulo-sm">
                    {"Cantidad de Empresas"|x_translate}
                </div>
                <div  id="cantEmpresas" class="cuerpo-sm">   
                    000
                </div>
            </div>
     
        </div>


    </div>   

    <div class="row-md">


        <div class="col-md">
            <div class="col-md-titulo">
                <div class="text-titulo-md"> {"Consultas Express de los últimos 12 meses"|x_translate}</div>
            </div>



            <canvas   id="myChart"></canvas>

        </div>
        <div class="col-md">
            <div class="col-md-titulo">
                <div class="text-titulo-md">  {"Video Consultas de los últimos 12 meses"|x_translate}</div>
            </div>

            <canvas id="myChart2" ></canvas>

        </div>



        <div class="col-md">
            <div class="col-md-titulo">
                <div class="text-titulo-md"> {"Cantidad consultas express de los últimos 12 meses"|x_translate}</div>
            </div>

            <canvas class="canvas-donas" id="myChart3" ></canvas>

        </div>
        <div class="col-md">
            <div class="col-md-titulo">
                <div class="text-titulo-md"> {"Cantidad video consultas de los últimos 12 meses"|x_translate}</div>
            </div>

            <canvas class="canvas-donas"id="myChart4"></canvas>

        </div> 
    </div>
</div>




<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/chart/dist/chart.min.js"></script>

<script>
    {include file = "home/dashboard_graficos.js"}
    {include file = "home/dashboard_cantidades.js"}
</script>
