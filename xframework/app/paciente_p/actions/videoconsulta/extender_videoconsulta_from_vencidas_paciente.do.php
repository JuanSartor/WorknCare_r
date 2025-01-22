<?php

 
  /**
   * Método para extender el plazo de tiempo para la Video Consulta   */
  $manager = $this->getManager("ManagerVideoConsulta");
  
  $resultado = $manager->extender_from_vencidas_paciente($this->request);
  
  $this->finish($manager->getMsg());