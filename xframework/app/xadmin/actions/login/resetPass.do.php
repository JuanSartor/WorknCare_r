<?php
	/**
	*	
	*
	*	Resetea la pass de un usuario,
	*
	*	@author Xinergia <info@e-xinergia.com>
	*	@version 1.0 2008-08-28
	*
	*/	
    
    $this->start();
	if (!$_SESSION['resetAutorizado'] || (int)$_SESSION['resetAutorizado']==0){
        $this->finish("[false]acceso denegado[false]");
    }
	
    $managerUsu = $this->getManager("ManagerXadminUsers");	
    $managerUsu->resetPass($this->request);
    $this->finish($managerUsu->getMsg());  
	
?>
