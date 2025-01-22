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


	// Obtengo la instancia de smarty
	$smarty = $this->getSmarty();
	
    $this->getClass("HTMLHeaders");
    
    $manager = new HTMLHeaders();


	$css_code = $manager->getCssContent($path, $smarty);

	header('Content-Type: text/css');
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
	die($css_code);
		
	ob_end_flush();
?>
