<?php
    /**
	*	
	*  Carga dinamica de JS comprimido con GZIP
	*
	*	@author Sebastian Balestrini 
	*
	*/	
	
	
	$path = base64_decode($_REQUEST["path"]);
	$url_js_core = base64_decode($_REQUEST["url_js_core"]);
	$url_js_libs =base64_decode($_REQUEST["url_js_libs"]);


	// Obtengo la instancia de smarty
	$smarty = $this->getSmarty();
	
	$smarty->assign("url_js_core",$url_js_core);
	$smarty->assign("url_js_libs",$url_js_libs);
	
		
    $manager = $this->getClass("HTMLHeaders", true);

	$js_code = $manager->getJSGlobal2html($path, $smarty);
	
//	header('Content-Type: text/js');
/*
	$offset = 60 * 60 ;
	$ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";
	header($ExpStr);
*/
	echo $js_code;
		
?>
