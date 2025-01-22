<?php

  /**
   * Action >> ManagerGlucemia
   */
  $manager = $this->getManager("ManagerPacienteVacunaVacunaEdad");

  $result = $manager->processFromPerfilPaciente($this->request);

  $this->finish($manager->getMsg());