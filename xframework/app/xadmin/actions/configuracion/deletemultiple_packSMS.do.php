<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPackSMSMedico");
   
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());

?>
