<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerEnfermedad");
   
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());

?>
