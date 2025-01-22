<script language="JavaScript" type="text/javascript" src="{$url_js_libs}/prototype/prototype.js" ></script>
<div style="float:left">
<form action="{$action_x}" method="post" enctype="multipart/form-data" name="f_common_upload" id="f_common_upload">
<input type="hidden" value="{$hash}" name="hash" id="hash" />
	<input type="hidden" value="{$todo}" name="todo" id="todo" />
	<input type="file" name="file_temp" id="file_temp" size="10" style="width:70px;"  /><br>
<input name="btnSubir" type="button" value="Adjuntar archivo" onClick="subir()">
</form>
</div>
{if $img!="" && $type == "jpg"}
<div style="float:right"><img src="{$img}?{$smarty.now|date_format:'%S'}" border="0"/></div>
{/if}
<div id="div_subiendo" style="display:none;color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-size:11px; float:none; clear:both; width:150px;">
	<strong>Subiendo archivo...</strong>
</div>
{if $msg == "ok"}
<div  style="color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-size:11px; float:none; clear:both; width:250px;">
	<strong>Subido con exito {$realName}</strong>
</div>
{else}
<div  style="color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-size:11px; float:none; clear:both; width:250px;">
	<strong>{$msg}</strong>
</div>
{/if}
<script type="text/javascript">
	function subir(){ldelim}
		
		$('f_common_upload').hide();
		$('div_subiendo').show();
		$('f_common_upload').submit();
	
	{rdelim}
	
</script>