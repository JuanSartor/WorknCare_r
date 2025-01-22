<?php
	/**
	 * @author Sebastian Balestrini <sbalestrini@gmail.com>
	 * @version 1.0
	 *
	 * Controlador central del Framework
	 *
	 */	
    //opcache_reset();
	ini_set('display_errors','0');
	
	//ini_set('display_errors','1');
	//error_reporting(6143);
    
    define("VIEW_DEBUG", false); 
if ($_SERVER["REMOTE_ADDR"] == "_152.170.137.72") {
    ini_set('display_errors', '1');
    error_reporting(6143);
    define("VIEW_DEBUG", true);
    define("DEBUG_DB", true);
    define("DEBUG_APP", true);
}
	$_REQUEST["cname"] = "paciente_p";

	require_once("xframework.php");
