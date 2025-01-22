<?php


 
  /**
   * Método para extender el plazo de tiempo para la consulta
   */
  $manager = $this->getManager("ManagerVideoConsulta");
//  $manager->debug();
  $resultado = $manager->republicar_from_vencidas_paciente($this->request);
  
  $this->finish($manager->getMsg());