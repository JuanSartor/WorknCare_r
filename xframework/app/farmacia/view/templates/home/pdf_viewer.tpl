

{if $smarty.request.codigo=="" }
<div class="okm-row text-center">
    <div class="hub-box">
        <input type="text" class="form-control" name="codigo" id="codigo" value="{$smarty.request.codigo}" placeholder='{"Ingrese el codigo de la receta electronica"|x_translate}' style="margin-bottom: 10px;">
    </div>
</div>

<div class="okm-row text-center">

    <a class="btn btn-blue" id="btnVisualizar" href="javascript:;">{"Visualizar"|x_translate}</a>

</div>

{else}
{if !$receta}

<div class="okm-row status-block" >

    <div class="hub-box white">
        <div class="alert alert-warning">
            <div class="icon"><i class="fa fa-check-circle-o"></i></div>            
            <div class="alert-body">
                <strong>{"Receta no disponible!"|x_translate}</strong><br>
                {"Verifique el código ingresado"|x_translate}
            </div>
            <div class="clearfix"></div>
        </div>



    </div>
</div>
{else}
{if  $receta && $receta.procesada==0}
<div class="okm-row text-center">

    <a class="btn btn-blue" id="btnImprimir" target="_blank" href="{$receta.file_original}">{"Imprimir"|x_translate}</a>

</div>
{/if}
<div class="okm-row status-block" >

    <div class="hub-box white">
        <div class="alert alert-warning" id="div_alert_receta_procesada" {if $receta && $receta.procesada==1}style="display:block;"{else}style="display:none;"{/if}>
             <div class="icon"><i class="fa fa-check-circle-o"></i></div>            
            <div class="alert-body">
                <strong>{"Receta ya procesada!"|x_translate}</strong><br>
                {"No tiene que entregar medicamentos al paciente"|x_translate} 
            </div>
            <div class="clearfix"></div>
        </div>

        <div class="alert alert-success" id="div_alert_receta_disponible" {if  $receta && $receta.procesada==0}style="display:block;"{else}style="display:none;"{/if}>
             <div class="icon"><i class="fa fa-times-circle-o"></i></div>
            <div class="alert-body">
                <strong>{"Receta disponible!"|x_translate}</strong><br>
                {"Todavia no usada, lista para procesar"|x_translate}
            </div>
            <div class="clearfix"></div>
        </div>

        <div class="pdf-viewer-container">
            <iframe src="{$url}xframework/core/libs/libs_js/ViewerJS/index.html#{$receta.file_copia}" width='100%' height='600' allowfullscreen webkitallowfullscreen></iframe>
        </div>

    </div>
</div>
{/if}
{/if}
{literal}
<script>
    $(function () {
        $("#btnVisualizar").click(function () {
            if ($("#codigo").val() != "") {
                x_loadModule("home", "pdf_viewer", "codigo=" + $("#codigo").val(), "div_pdf_wiewer");
            }
        });

        $("#btnImprimir").click(function () {
            $(this).remove();
            $("#div_alert_receta_procesada").show();
            $("#div_alert_receta_disponible").hide();
        });
    })
</script>
{/literal}
