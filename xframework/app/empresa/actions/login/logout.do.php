<?php

//guarda el status
$this->start();

$this->getManager("ManagerUsuarioEmpresa")->logOut();
$this->finish(array("result" => true, "location" => URL_ROOT . "creer-compte.html"));
//header("Location:".CONTROLLER.".php");        
?>
