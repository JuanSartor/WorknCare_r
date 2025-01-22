<?php
	/**
	* @author Sebastian Balestrini <sbalestrini@gmail.com>
	* @version 1.0
	*
	* Controlador central del Framework
	*
	*/	
    ini_set('display_errors','0');
 //ini_set('display_errors','1');
//error_reporting(6143);
define("VIEW_DEBUG", false); 	

	$_REQUEST["cname"] = "xadmin";

	require_once("xframework.php");
?>