<?php

/**
   * Action para la eliminación de medicos de la bolsa de consulta express 
   */
  $manager = $this->getManager("ManagerMedicoEliminadoConsultaExpress");
  
  $result = $manager->eliminarMedicosConsultaExpress($this->request);
  
  $this->finish($manager->getMsg());
