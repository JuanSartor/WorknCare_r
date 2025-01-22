<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPacientePrestador");

    $manager->deleteMultiple($this->request['ids'],true);    
    
    $this->finish($manager->getMsg());

?>
