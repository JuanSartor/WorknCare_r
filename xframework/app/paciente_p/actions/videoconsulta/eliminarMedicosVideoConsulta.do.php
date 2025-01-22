<?php

/**
   * Action para la eliminación de medicos de la bolsa de Video Consulta
   */
  $manager = $this->getManager("ManagerMedicoEliminadoVideoConsulta");
  
  $result = $manager->eliminarMedicosVideoConsulta($this->request);
  
  $this->finish($manager->getMsg());
