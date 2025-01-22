<?php

  /**
   * Action >> ManagerGlucemia
   */
  $manager = $this->getManager("ManagerPacienteVacunaVacunaEdad");

  $result = $manager->processFromPerfilMedico($this->request);

  $this->finish($manager->getMsg());