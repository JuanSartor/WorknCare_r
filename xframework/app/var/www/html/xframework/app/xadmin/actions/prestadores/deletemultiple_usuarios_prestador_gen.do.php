<?php
	/**	
	*	Accion: Eliminacion mutiple
	*
	*
	*/ 

    $manager = $this->getManager("ManagerUsuarioPrestador");

    $manager->deleteMultiple($this->request['ids'],false);    
    
    $this->finish($manager->getMsg());

?>
