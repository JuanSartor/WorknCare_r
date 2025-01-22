<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerSolicitudRenovacionPerfilSaludMedicamento");

  $result = $manager->marcarLeidoPaciente($this->request);

  $this->finish($manager->getMsg());