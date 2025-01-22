<div class="documentacion-list">
    {foreach from=$listado_documentacion item=documentacion}
   

        <a href="javascript:;" title="Abrir" onclick="x_loadWindow(this, 'medicos', 'medicos_documentacion_form', 'idmedico={$smarty.request.idmedico}&iddocumentacion={$documentacion.iddocumentacionMedico}', 800, 400);">{$documentacion.titulo}</a>
   
    {foreachelse}
    <div class="wide">
	
        <strong>No se ha adjuntado documentación </strong>

    </div>
    {/foreach}
</div>