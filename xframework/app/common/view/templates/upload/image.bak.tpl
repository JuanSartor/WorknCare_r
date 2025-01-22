<script language="JavaScript" type="text/javascript" src="{$url_js_libs}/prototype/prototype.js" ></script>
<div style="float:left">
<form action="{$action_x}" method="post" enctype="multipart/form-data" name="f_common_upload" id="f_common_upload">
<input type="hidden" value="{$hash}" name="hash" id="hash" />
<input type="hidden" value="{$todo}" name="todo" id="todo" />
	<input type="file" name="{$hash}" id="file_temp" size="40"  /><br /><br />
<input name="btnSubir" type="button" value="Adjuntar archivo" onClick="subir()">
{if $image!=""}
<input name="btnEliminar" type="button" value="Borrar archivo" onClick="eliminar()">
{/if}
</form>
</div>
{if $image!=""}

<div style="float:right">
{if $entity == "categoria"}
<img src="{$image}" border="0" style="border:#999999 1px solid; "/>
{else}
<img src="common.php?action=1&modulo=images&submodulo=getThumb&image={$image}&{$smarty.now|date_format:'%S'}" border="0" style="border:#999999 1px solid; "/>
{/if}
</div>
{/if}
<div id="div_subiendo" style="display:none;color:#FF0000">
	<strong style="font-family:Arial, Helvetica, sans-serif;">Subiendo archivo...</strong>
</div>

{if $msg != "ok"}
<div style="color:#FF0000;font-size:10px">
	<strong>{$msg}</strong>
</div>
{/if}
<script type="text/javascript">
	function subir(){ldelim}
		
		$('f_common_upload').hide();
		$('div_subiendo').show();
		$('f_common_upload').submit();
	
	{rdelim}

	function eliminar(){ldelim}
		if (confirm("Eliminar esta imagen?")){ldelim}
			$('todo').value = "delete";
			$('f_common_upload').hide();
			$('div_subiendo').innerHTML="<strong>Eliminando</strong>";
			$('div_subiendo').show();
			$('f_common_upload').submit();
		{rdelim}	
	{rdelim}	
</script>