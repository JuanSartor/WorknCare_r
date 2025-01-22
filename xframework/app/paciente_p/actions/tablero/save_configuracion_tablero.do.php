<?php

 
  /**
   * Action >> Tablero Configuración >> FORM
   */
  $manager = $this->getManager("ManagerPacienteTablero");

  $result = $manager->processFromFrontEnd($this->request);

  $this->finish($manager->getMsg());
  