<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPinesPaciente");
   
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());

?>
