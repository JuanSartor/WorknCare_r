<?php


  /** 	
 * 	Accion: Asocia una medico al prestador ISIC
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerMedicoPrestador");
    
    $result = $manager->agregar_prestador_isic_from_medico();
    $this->finish($manager->getMsg());
