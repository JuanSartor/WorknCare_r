<?php

 
  /**
   * Action de modificación de intervalos de turnos.
   * Eliminará todas las configuraciONES DE agenda pertenecientes a ese consultorio y modificará las preferencias
   */
  
  $manager = $this->getManager("ManagerConfiguracionAgenda");
  
  $rdo = $manager->modificar_intervalos_turno($this->request);
  
  $this->finish($manager->getMsg());

