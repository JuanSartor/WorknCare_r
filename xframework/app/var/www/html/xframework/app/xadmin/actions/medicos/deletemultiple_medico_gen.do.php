<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerMedico");
   
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
