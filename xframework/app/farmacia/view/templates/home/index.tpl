<style>
    .hub-box {
        background-color: #f7f7f7;
        max-width: 600px;
        margin: 40px auto 40px;
        text-align: center;
        padding: 24px 16px;
    }
</style>
{*include file="home/header.html"*}
<nav class="paciente-nav">
    <div class="container paciente-nav-container">
        <div class="paciente-nav-logo">
            <a href="{$url}" title="DoctorPlus">
                <img src="{$IMGS}doctorplus_logo_mobile.png" title="DoctorPlus"/>
            </a>
        </div>
        <span class="section-title pull-right">{"Acceso farmacia"|x_translate}</span>
    </div>
</nav>
<div class="plogin-header">
    <h1>{"Receta electronica"|x_translate}</h1>

</div>
<div class="hin-slide-data-box hin-rsp pos1">
    <h4 class="text-center text-danger">{"Importante"|x_translate}</h4>
</div>

<div class="hub-account-already">
    <div class="hub-box white">
        <div class="hub-account-already-row">
            {"Tiene que verificar que tiene el medicamento disponible para la entrega en la farmacia ANTES DE IMPRIMIR LA RECETA."|x_translate}
        </div>
        <div class="hub-account-already-row">
            {"La receta solo puede ser imprimida una vez."|x_translate}
        </div>

    </div>
</div>

<div class="hub-account-already">
    <div class="hub-box">
        <h3 class="hin-portada-title text-blue">{"Procedimiento"|x_translate}</h3>
        <ul>

            <li class="text-left">1. {"Verificar identidad del paciente"|x_translate}  </li>
            <li class="text-left">2. {"Verificar que tiene todos los medicamentos disponibles"|x_translate}  </li>
            <li class="text-left">3. {"Imprimir la receta"|x_translate}  </li>
            <li class="text-left">4. {"Use los datos de esa receta para su software"|x_translate}   </li>


        </ul>

    </div>
</div>



<div id="div_pdf_wiewer">
{include file="home/pdf_viewer.tpl"}
</div>




         
    


