<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerTurno");

  $result = $manager->marcarLeidoPaciente($this->request);

  $this->finish($manager->getMsg());