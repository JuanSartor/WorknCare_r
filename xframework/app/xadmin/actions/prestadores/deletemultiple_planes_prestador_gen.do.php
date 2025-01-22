<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPlanPrestador");

    $manager->deleteMultiple($this->request['ids'],false);    
    
    $this->finish($manager->getMsg());

?>
