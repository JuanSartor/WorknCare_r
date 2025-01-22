<?php
  /** 	
 * 	Accion: Asocia una idioma a un médico
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerEspecialidadMedico");
    $result = $manager->addSubEspecialidadMedico($this->request["especialidad_idespecialidad"],$this->request["subEspecialidad_idsubEspecialidad"]);
    $this->finish($manager->getMsg());
