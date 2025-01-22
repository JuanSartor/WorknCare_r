<?php session_start();
	/**
	*	login.do.php
	*
	*	Procesa el logueo de usuarios
	*
	*	@author Emanuel del Barco Balestrini <emanueldb@gmail.com>
	*
	*/	
    
    
    $manager = $this->getManager("ManagerUsuarios");

    //login idrol 1 admin total
    //$manager->process(1,$_REQUEST); 		
    $manager->login($this->request);
	
    $this->finish($manager->getMsg());

?>
