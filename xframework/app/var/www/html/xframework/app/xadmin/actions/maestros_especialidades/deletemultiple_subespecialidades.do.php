<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerSubEspecialidades");
   	
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());

?>
