<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerBanco");
   
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

