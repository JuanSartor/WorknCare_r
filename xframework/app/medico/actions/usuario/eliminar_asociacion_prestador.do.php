<?php


  /** 	
 * 	Accion: desasocia al medico del prestador
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerMedicoPrestador");
    $result = $manager->eliminar_relacion_prestador_from_medico($this->request["id"]);
    $this->finish($manager->getMsg());
