<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerMedicoPrestador");

    $manager->deleteMultiple($this->request['ids'],true);    
    
    $this->finish($manager->getMsg());

?>
