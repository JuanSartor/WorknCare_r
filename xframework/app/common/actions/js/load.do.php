<?php
    /**
	*	
	*  Carga dinamica de JS comprimido con GZIP
	*
	*	@author Sebastian Balestrini 
	*
	*/	
	
	ob_start("ob_gzhandler");
	
	$path = base64_decode($_REQUEST["path"]);
	$url_js_core = base64_decode($_REQUEST["url_js_core"]);
	$url_js_libs =base64_decode($_REQUEST["url_js_libs"]);


	// Obtengo la instancia de smarty
	$smarty = $this->getSmarty();
	
	$smarty->assign("url_js_core",$url_js_core);
	$smarty->assign("url_js_libs",$url_js_libs);
		
    $this->getClass("HTMLHeaders");
    
    $manager = new HTMLHeaders();

	$js_code = $manager->getJSGlobal($path, $smarty);

	header("Content-type: text/javascript; charset: UTF-8");
	header("Cache-Control: must-revalidate");
	header("HTTP/1.1 200 OK");
	header("Status: 200 OK");
	header("Pragma: public");
	header("Cache-Control: max-age=3600, must-revalidate");	
//	header('Content-Type: text/js');
/*
	$offset = 60 * 60 ;
	$ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";
	header($ExpStr);
*/
	die($js_code);
		
	ob_end_flush();
?>
