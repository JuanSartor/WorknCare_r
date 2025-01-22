<?php
	/**
	* @author Sebastian Balestrini <sbalestrini@gmail.com>
	* @version 1.0
	*
	* Controlador central del Framework
	*
	*/	
	session_start();

	chdir(__DIR__);
    //Incluimos las configuraciones
	require_once("xframework/config/path.config.php");

    // Obtenemos el nombre del controlador que estamos solicitando
	$cname = $_REQUEST["cname"];

	// Cargamos el RequestController, segundo parametro en true para debug.
    $xframework = new xFramework($cname);

	// Procesamos la solicitud
    $xframework->process();

?>