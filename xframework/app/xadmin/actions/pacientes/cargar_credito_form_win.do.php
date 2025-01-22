<?php
	/**	
	*	Accion: cargar credito desde admin 
	*
	*/ 

    $manager = $this->getManager("ManagerMovimientoCuenta");
   //$manager->debug();
    $manager->cargar_credito_from_admin($this->request);    
    
    $this->finish($manager->getMsg());
