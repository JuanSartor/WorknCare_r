<?php
	/**
	*	forgot.do.php
	*
	*	Procesa el la peticion de un usuario que olvido su password
	*
	*	@author Emanuel del Barco Balestrini <emanueldb@gmail.com>
	*
	*/	
    
    $this->start();
    $managerUsu = $this->getManager("ManagerUsuarios");
    $managerUsu->forgotPass($this->request);
    $this->finish($managerUsu->getMsg());  
   
?>
