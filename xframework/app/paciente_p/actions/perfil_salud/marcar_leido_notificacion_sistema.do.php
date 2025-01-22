<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerNotificacionSistemaPacientePaciente");

  $result = $manager->marcarLeido($this->request);

  $this->finish($manager->getMsg());
