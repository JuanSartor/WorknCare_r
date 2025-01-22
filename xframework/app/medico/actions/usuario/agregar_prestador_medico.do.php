<?php


  /** 	
 * 	Accion: Asocia una medico al prestador 
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerMedicoPrestador");
    
    $result = $manager->agregar_prestador_from_medico();
    $this->finish($manager->getMsg());
