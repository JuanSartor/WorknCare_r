<?php

  
  /**
   * Método para eliminar de la visualización para el médico
   */
  $manager = $this->getManager("ManagerConsultaExpress");
  
  $resultado = $manager->eliminar_from_vencidas($this->request);
  
  $this->finish($manager->getMsg());