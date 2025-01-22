<link rel="stylesheet" type="text/css" href="{$url}xframework/app/empresa/view/css/reporte.css">

<section class="okm-container divider-print">
    <div class="row vista-impresion-divider reporte-title">   
        <div class="vista-impresion-holder">
            <label class="text-center"><strong>{"Empresa"|x_translate}: {$empresa}</strong></label>
        </div>
        <div class="vista-impresion-holder">
            <label class="text-center"><strong>{"Fecha"|x_translate}: {$hoy}</strong></label>
        </div>    
    </div>
</section>
{include file="home/reporte_graficos_empresa.tpl"} 
<div class="okm-row text-center button-container">
    <a href="{$url}entreprises/" class="btn btn-default btn-inverse btn-volver">{"volver"|x_translate}</a>
    <button class="btn btn-default btn-imprimir">{"Imprimir"|x_translate}</button>
    <div class="clearfix">&nbsp;</div>
</div>

{x_load_js}