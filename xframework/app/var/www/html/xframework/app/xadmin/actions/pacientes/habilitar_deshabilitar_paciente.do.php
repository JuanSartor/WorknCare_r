<?php
	/**	
	*	Accion: Cambiar paciente a activo/inactivo
	*
	*
	*/ 

    $manager = $this->getManager("ManagerPaciente");
   //$manager->debug();
    $manager->HabilitarDesabilitarPaciente($this->request['idpaciente']);    
    
    $this->finish($manager->getMsg());

?>
