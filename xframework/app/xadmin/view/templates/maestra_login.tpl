<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>{$TITLE}</title>

	{*x_css_local*}
    {x_css_global}  
	{x_js_global debug=1}    
    {x_js_local}
    {x_theme name="$theme" debug="1"}  
    

<script language="javascript" type="text/javascript" src="{$url}xframework/core/libs/libs_js/jquery/jquery.reject.js" ></script>
<script language="javascript" type="text/javascript">


$(document).ready(function() {
	
		
			$.reject({
				reject: { 
					//all:true,
					safari: true, // Apple Safari  
//					chrome: true, // Google Chrome  
					//firefox:true,
					firefox1: true, // Mozilla Firefox  
					firefox2: true, // Mozilla Firefox  
					firefox3: true, // Mozilla Firefox  
					msie5: true, // Microsoft Internet Explorer  
					msie6: true, // Microsoft Internet Explorer  
					msie7: true, // Microsoft Internet Explorer  
					msie8: true, // Microsoft Internet Explorer  
					msie: true, // Microsoft Internet Explorer  
					//opera: true, // Opera  
					konqueror: true, // Konqueror (Linux)  
					unknown: true // Everything else  
				}, // Reject all renderers for demo
				close: false, // Prevent closing of window
				display:['firefox','chrome','opera'],
				imagePath: './xframework/app/xadmin/view/imgs/', // Path where images are located  
				header: 'ATENCI�N: Su browser no es compatible con la aplicaci�n a la que intenta acceder',  
				paragraph1: 'Por favor, actualice a alguna de las versiones permitidas', // Warning about closing
				paragraph2: ' ' // Display refresh link
			});

		
	
});


</script>
 {include file="js_templates/a_run.tpl"}   
<link rel="shortcut icon" href="{$url}favicon2.png" type="image/png" />
</head>
<noscript>
	Por favor, active la utilizaci&oacute;n de scripts para visualizar este sitio.
</noscript>
<body id="login-bg">
<!-- Elementos del Sistema -->
<input type="hidden" id="jscontainer" />
<input type="hidden" id="modulo" value="{$modulo}" />
<input type="hidden" id="submodulo" value="{$submodulo}" />
{x_component_loading_box_in_context text="Cargando..." visible="yes"}

{*
<div id="messageBox" style="width:600px;">
<table border="0" cellpadding="0" cellspacing="0" id="messageTable" align="center">
	<tr>
	  <td height="34" class="msg_left">&nbsp;</td>
    	<td nowrap="nowrap" class="msg_text" id="message">&nbsp;</td>
	    <td class="msg_right">&nbsp;</td>
	</tr>
</table>
</div>
<div id="viewMessageBox" style="width:87px; display:none;" onclick="showMsg()" title="Mostrar Mensajes y Advertencias"></div>
*}
<div id="login-holder">

	<!-- start logo -->
	<div id="logo-login">
		
	</div>
	<!-- end logo -->
	
	<div class="clear"></div>
	

{include file="$content"}
</div>
</body>
</html>