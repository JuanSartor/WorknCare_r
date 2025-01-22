<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerGrilla");
   
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
