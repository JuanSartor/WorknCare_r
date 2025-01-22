<?php
	/**	
	*	Accion: Activacion mutiple de cuentas de medico
	*
	*
	*/ 

    $manager = $this->getManager("ManagerMedico");
   
    $manager->activeMultiple($this->request['ids']);    
    
    $this->finish($manager->getMsg());

?>
