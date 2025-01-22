<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>


<meta http-equiv="Content-Type" content="text/html; charset={$charset}" />
<title>{$TITLE}</title>
	
    {include file="js_templates/a_run.tpl"}
    <script type="text/javascript">
		var BASE_PATH = "{$url}";
	</script>


	{x_css_local}
    {x_css_global}  
	{x_js_global debug=1}    
    {x_js_local}
    {x_theme name="$theme" debug="1"}  

    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/jqwidgets/jqxmenu.js"></script>
    
	<!-- Extras para el menu lateral izquierdo -->
    <link rel="stylesheet" href="{$url}xframework/core/libs/libs_js/jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="{$url}xframework/core/libs/libs_js/jqwidgets/styles/jqx.admin.css" type="text/css" />
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/jqwidgets/jqxexpander.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/jqwidgets/jqxnavigationbar.js"></script>

  




    <link rel="stylesheet" type="text/css" href="{$url}xframework/core/libs/libs_js/SlidePushMenus/css/component.css" />
    <script src="{$url}xframework/core/libs/libs_js/SlidePushMenus/js/modernizr.custom.js"></script>
    <script src="{$url}xframework/core/libs/libs_js/SlidePushMenus/js/classie.js"></script>

	
    <link href='//fonts.googleapis.com/css?family=Lato:400,700' rel='stylesheet' type='text/css'>        
<link rel="shortcut icon" href="{$url}favicon.ico">
	<link rel="shortcut icon" href="{$url}favicon.png" type="image/png" />
</head>
<noscript>
	Por favor, active la utilizaci&oacute;n de scripts para visualizar este sitio.
</noscript>
<body id="body">
<!-- Elementos del Sistema -->
<input type="hidden" id="jscontainer" />
<input type="hidden" id="modulo" value="{$modulo}" />
<input type="hidden" id="submodulo" value="{$submodulo}" />
<input type="hidden" id="path_imgs" value="{$PATH_THEME_IMGS}" />
{x_component_window showControls="0"}
	<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left gn-menu-wrapper" id="xmnu">

	</nav>



<div id="Header">
	{x_component_loading_box_in_context text="Cargando..." visible="yes"}
	<ul>
    	<li class="mnu-action mnu-trigger">
        <a href="javascript:;" id="start" title="Acceda al menu aqui">&nbsp;</a>
        </li>
        <li class="mnu-logo {$ENTORNO}">&nbsp;<div class="entorno">v{$VERSION}</div>
		</li>
        <li class="mnu-welcome"><span>Bienvenido<strong>  {$account.name} {$account.lastname}</strong></span></li>
        <li class="mnu-action mnu-logout"><a href="javascript:;" title="Cerrar sesi&oacute;n" id="logout">Salir</a></li>

		<li class="mnu-action mnu-profile"><a href="javascript:;" id="perfil">Mi perfil</a></li>
        
    </ul>
    
    
    
    
    
    
    
    {*<div class="logo {$ENTORNO}">&nbsp;</div>
    
    
    
     {if $allowed}
        <div class="saludo">
        <br />Bienvenido<strong>  {$account.name} {$account.lastname}</strong><br />
        </div>


    	<!-- start nav-right -->
		<div id="nav-right">
			<a href="javascript:;" onclick="x_goTo('usuarios','miperfil','','Main')">Mi perfil</a> | 
			<a href="javascript:;" onclick="x_LogOut()" title="Cerrar sesi&oacute;n" id="logout">Salir</a>		
		</div>
        <!-- end nav-right -->
    {/if}
    *}
</div>

<!-- begin #main-->
<div id="Main">

		{include file="$content"}

</div>

<!-- end #main-->
<div id="cont_aux" style="display:none"></div>
<!-- Begin #Footer -->
<div class="clear">&nbsp;</div>
<div id="Footer">

<div style="float:right"></div>

<strong>Tous droits r&eacute;serv&eacute;s, DoctorPlus 2019</strong><br />
	
</div>
<!-- end #Footer -->


{include file="js_templates/z_run.tpl"}
</body>
</html>