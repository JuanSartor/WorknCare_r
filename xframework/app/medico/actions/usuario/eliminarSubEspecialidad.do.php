<?php

  /** 	
 * 	Accion: Eliminar la especialidad asociada al médico
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerEspecialidadMedico");
    $result = $manager->deleteSubEspecialidadMedico($this->request["especialidad_idespecialidad"],$this->request["subEspecialidad_idsubEspecialidad"]);
    $this->finish($manager->getMsg());