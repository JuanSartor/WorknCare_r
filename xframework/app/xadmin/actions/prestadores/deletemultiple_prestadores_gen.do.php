<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPrestador");
   //$manager->debug();
    $manager->deleteMultiple($this->request['ids'],true);    
    
    $this->finish($manager->getMsg());

?>
